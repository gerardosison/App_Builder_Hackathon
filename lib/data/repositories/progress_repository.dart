import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import 'profile_repository.dart';

class ProgressRepository {
  ProgressRepository(this.database, this.firestore);

  final AppDatabase database;
  final FirebaseFirestore firestore;

  late final ProfileRepository profiles = ProfileRepository(
    database,
    firestore,
  );

  final Map<String, Future<void>> _activeSyncs = {};

  Stream<List<PracticeRecord>> watchRecords(String userId) {
    return database.watchRecords(userId);
  }

  Future<String> saveCompletedPractice({
    required String userId,
    required String practicePurpose,
    required int durationSeconds,
    required int starsEarned,
    String? baselineSessionId,
    bool isTest = false,
  }) async {
    if (userId.isEmpty || durationSeconds < 0 || starsEarned < 0) {
      throw ArgumentError('Invalid practice record.');
    }

    final id = const Uuid().v4();

    await database
        .into(database.practiceRecords)
        .insert(
          PracticeRecordsCompanion.insert(
            id: id,
            userId: userId,
            completedAt: DateTime.now().toUtc(),
            practicePurpose: practicePurpose,
            durationSeconds: durationSeconds,
            starsEarned: starsEarned,
            baselineSessionId: Value(baselineSessionId),
            isTest: Value(isTest),
          ),
        );

    return id;
  }

  Future<void> sync(String userId) {
    return _activeSyncs.putIfAbsent(userId, () => _syncAndClear(userId));
  }

  void _checkAccount(String userId) {
    if (FirebaseAuth.instance.currentUser?.uid != userId) {
      throw StateError('Account changed; sync paused.');
    }
  }

  Future<void> _syncAndClear(String userId) async {
    try {
      await _performSync(userId);
    } finally {
      _activeSyncs.remove(userId);
    }
  }

  Future<void> _performSync(String userId) async {
    _checkAccount(userId);

    await profiles.sync(userId);

    _checkAccount(userId);

    final collection = firestore
        .collection('users')
        .doc(userId)
        .collection('sessions');

    final pending = await database.pendingRecords(userId);

    for (final record in pending) {
      _checkAccount(userId);

      // Reuse the session ID so retries cannot create duplicates.
      await collection.doc(record.id).set({
        'userId': userId,
        'completedAt': Timestamp.fromDate(record.completedAt),
        'practicePurpose': record.practicePurpose,
        'durationSeconds': record.durationSeconds,
        'starsEarned': record.starsEarned,
        'baselineSessionId': record.baselineSessionId,
        'scoringVersion': record.scoringVersion,
        'isTest': record.isTest,
      });

      await database.markUploaded(userId, record.id);
    }

    _checkAccount(userId);

    final cloudRecords = await collection.get(
      const GetOptions(source: Source.server),
    );

    for (final document in cloudRecords.docs) {
      final data = document.data();

      final completedAt = data['completedAt'];
      final purpose = data['practicePurpose'];
      final duration = data['durationSeconds'];
      final stars = data['starsEarned'];
      final baseline = data['baselineSessionId'];
      final version = data['scoringVersion'];
      final testFlag = data['isTest'];

      if (data['userId'] != userId ||
          completedAt is! Timestamp ||
          purpose is! String ||
          duration is! int ||
          duration < 0 ||
          stars is! int ||
          stars < 0 ||
          version is! String ||
          (baseline != null && baseline is! String) ||
          (testFlag != null && testFlag is! bool)) {
        throw StateError('Invalid cloud practice record.');
      }

      await database.insertDownloaded(
        PracticeRecordsCompanion.insert(
          id: document.id,
          userId: userId,
          completedAt: completedAt.toDate().toUtc(),
          practicePurpose: purpose,
          durationSeconds: duration,
          starsEarned: stars,
          baselineSessionId: Value(baseline as String?),
          scoringVersion: Value(version),
          isTest: Value(testFlag == true || purpose == 'Database test'),
          needsUpload: const Value(false),
        ),
      );
    }
  }
}
