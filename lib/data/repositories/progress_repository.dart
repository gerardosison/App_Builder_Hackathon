import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../../core/models/feedback_report.dart';
import '../../core/models/pose_metrics.dart';
import '../../core/models/speech_metrics.dart';
import '../../features/progress/services/scoring_service.dart';
import '../codecs/analysis_codec.dart';
import '../local/app_database.dart';
import 'account_guard.dart';
import 'profile_repository.dart';

/// Local-first practice history. Sessions are saved to SQLite before any
/// cloud work; only numeric summaries are uploaded to Firestore.
class ProgressRepository {
  ProgressRepository({
    required this.database,
    required this.firestore,
    required this.guard,
    required this.profiles,
    this.scoring = const ScoringService(),
  });

  final AppDatabase database;
  final FirebaseFirestore firestore;
  final AccountGuard guard;
  final ProfileRepository profiles;
  final ScoringService scoring;

  final Map<String, Future<void>> _activeSyncs = {};

  Stream<List<PracticeRecord>> watchRecords(String userId) =>
      database.watchRecords(userId);

  Stream<int> watchPendingCount(String userId) =>
      database.watchPendingCount(userId);

  Future<SessionDetail?> detail(String userId, String sessionId) {
    return (database.select(database.sessionDetails)..where(
          (row) => row.userId.equals(userId) & row.sessionId.equals(sessionId),
        ))
        .getSingleOrNull();
  }

  Future<PracticeRecord?> record(String userId, String sessionId) {
    return (database.select(
          database.practiceRecords,
        )..where((row) => row.userId.equals(userId) & row.id.equals(sessionId)))
        .getSingleOrNull();
  }

  /// Saves a completed session exactly once. Calling again with the same
  /// [sessionId] returns the stored record without re-awarding stars.
  Future<PracticeRecord> saveCompletedPractice({
    required String userId,
    required String sessionId,
    required String practicePurpose,
    required String language,
    required String topic,
    required int durationSeconds,
    required FeedbackReport report,
    SpeechMetrics? speech,
    PoseMetrics? pose,
    String? audioPath,
    bool isTest = false,
  }) async {
    if (userId.isEmpty || sessionId.isEmpty || practicePurpose.isEmpty) {
      throw ArgumentError('Invalid practice record.');
    }
    if (durationSeconds < 0 || durationSeconds > 6 * 3600) {
      throw ArgumentError.value(durationSeconds, 'durationSeconds');
    }
    final score = report.overallScore;
    if (score.isNaN || score < 0 || score > 100) {
      throw ArgumentError.value(score, 'overallScore');
    }

    return database.transaction(() async {
      final existing = await record(userId, sessionId);
      if (existing != null) return existing;

      final previous =
          await (database.select(database.practiceRecords)
                ..where(
                  (row) =>
                      row.userId.equals(userId) &
                      row.practicePurpose.equals(practicePurpose) &
                      row.language.equals(language) &
                      row.scoringVersion.equals(ScoringService.version) &
                      row.isTest.equals(false) &
                      row.overallScore.isNotNull(),
                )
                ..orderBy([(row) => OrderingTerm.desc(row.completedAt)]))
              .get();
      final award = isTest
          ? const StarAward(stars: 0, baselineSessionId: null)
          : scoring.award(
              score: score,
              previousCompatible: [
                for (final p in previous)
                  ScoredSession(id: p.id, score: p.overallScore!),
              ],
            );

      final stored = FeedbackReport(
        overallScore: report.overallScore,
        summary: report.summary,
        strengths: report.strengths,
        improvements: report.improvements,
        evidenceList: report.evidenceList,
        limitations: report.limitations,
        generatedAt: report.generatedAt,
        llmResponse: report.llmResponse,
        starsEarned: award.stars,
      );

      await database
          .into(database.practiceRecords)
          .insert(
            PracticeRecordsCompanion.insert(
              id: sessionId,
              userId: userId,
              completedAt: DateTime.now().toUtc(),
              practicePurpose: practicePurpose,
              durationSeconds: durationSeconds,
              starsEarned: award.stars,
              baselineSessionId: Value(award.baselineSessionId),
              scoringVersion: const Value(ScoringService.version),
              isTest: Value(isTest),
              language: Value(language),
              topic: Value(topic),
              overallScore: Value(score),
              wordsPerMinute: Value(speech?.wordsPerMinute),
              fillerCount: Value(speech?.totalFillers),
              pauseCount: Value(speech?.pauseCount),
              postureScore: Value(pose?.postureScore),
              bodySwayCm: Value(pose?.bodySwayCm),
              gestureScore: Value(pose?.handGestureActivityScore),
              hasLocalDetails: const Value(true),
            ),
          );
      await database
          .into(database.sessionDetails)
          .insert(
            SessionDetailsCompanion.insert(
              sessionId: sessionId,
              userId: userId,
              transcript: Value(speech?.transcript ?? ''),
              reportJson: AnalysisCodec.encodeReport(stored),
              audioPath: Value(audioPath),
            ),
          );
      return (await record(userId, sessionId))!;
    });
  }

  /// Runs at most one sync per account at a time.
  Future<void> sync(String userId) {
    return _activeSyncs[userId] ??= _performSync(userId).whenComplete(() {
      // Block body: returning the removed future would make it await itself.
      _activeSyncs.remove(userId);
    });
  }

  static Map<String, Object?> summaryFor(PracticeRecord record) {
    final data = <String, Object?>{
      'userId': record.userId,
      'completedAt': Timestamp.fromDate(record.completedAt),
      'practicePurpose': record.practicePurpose,
      'language': record.language,
      'durationSeconds': record.durationSeconds,
      'starsEarned': record.starsEarned,
      'baselineSessionId': record.baselineSessionId,
      'scoringVersion': record.scoringVersion,
      'isTest': record.isTest,
      'overallScore': record.overallScore,
      'wordsPerMinute': record.wordsPerMinute,
      'fillerCount': record.fillerCount,
      'pauseCount': record.pauseCount,
      'postureScore': record.postureScore,
      'bodySwayCm': record.bodySwayCm,
      'gestureScore': record.gestureScore,
    };
    data.removeWhere((_, value) => value == null);
    return data;
  }

  Future<void> _performSync(String userId) async {
    guard.check(userId);
    await profiles.sync(userId);
    guard.check(userId);
    final collection = firestore
        .collection('users')
        .doc(userId)
        .collection('sessions');

    for (final record in await database.pendingRecords(userId)) {
      guard.check(userId);
      // Stable document IDs make retries idempotent.
      await collection.doc(record.id).set(summaryFor(record));
      await database.markUploaded(userId, record.id);
    }

    guard.check(userId);
    final cloud = await collection.get(const GetOptions(source: Source.server));
    guard.check(userId);
    for (final document in cloud.docs) {
      final companion = parseCloudSummary(userId, document.id, document.data());
      if (companion != null) await database.insertDownloaded(companion);
    }
  }

  /// Validates a downloaded summary; returns null for malformed data.
  static PracticeRecordsCompanion? parseCloudSummary(
    String userId,
    String id,
    Map<String, dynamic> data,
  ) {
    final completedAt = data['completedAt'];
    final purpose = data['practicePurpose'];
    final duration = data['durationSeconds'];
    final stars = data['starsEarned'];
    final version = data['scoringVersion'];
    final baseline = data['baselineSessionId'];
    if (data['userId'] != userId ||
        completedAt is! Timestamp ||
        purpose is! String ||
        duration is! int ||
        duration < 0 ||
        stars is! int ||
        stars < 0 ||
        stars > 3 ||
        version is! String ||
        (baseline != null && baseline is! String)) {
      return null;
    }
    double? number(String key) {
      final value = data[key];
      return value is num ? value.toDouble() : null;
    }

    int? integer(String key) {
      final value = data[key];
      return value is int ? value : null;
    }

    return PracticeRecordsCompanion.insert(
      id: id,
      userId: userId,
      completedAt: completedAt.toDate().toUtc(),
      practicePurpose: purpose,
      durationSeconds: duration,
      starsEarned: stars,
      baselineSessionId: Value(baseline as String?),
      scoringVersion: Value(version),
      isTest: Value(data['isTest'] == true),
      needsUpload: const Value(false),
      language: Value(data['language'] is String ? data['language'] : 'en-US'),
      overallScore: Value(number('overallScore')),
      wordsPerMinute: Value(number('wordsPerMinute')),
      fillerCount: Value(integer('fillerCount')),
      pauseCount: Value(integer('pauseCount')),
      postureScore: Value(number('postureScore')),
      bodySwayCm: Value(number('bodySwayCm')),
      gestureScore: Value(number('gestureScore')),
    );
  }
}
