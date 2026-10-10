// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PracticeRecordsTable extends PracticeRecords
    with TableInfo<$PracticeRecordsTable, PracticeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practicePurposeMeta = const VerificationMeta(
    'practicePurpose',
  );
  @override
  late final GeneratedColumn<String> practicePurpose = GeneratedColumn<String>(
    'practice_purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (duration_seconds >= 0)',
  );
  static const VerificationMeta _starsEarnedMeta = const VerificationMeta(
    'starsEarned',
  );
  @override
  late final GeneratedColumn<int> starsEarned = GeneratedColumn<int>(
    'stars_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (stars_earned >= 0)',
  );
  static const VerificationMeta _baselineSessionIdMeta = const VerificationMeta(
    'baselineSessionId',
  );
  @override
  late final GeneratedColumn<String> baselineSessionId =
      GeneratedColumn<String>(
        'baseline_session_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _scoringVersionMeta = const VerificationMeta(
    'scoringVersion',
  );
  @override
  late final GeneratedColumn<String> scoringVersion = GeneratedColumn<String>(
    'scoring_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('v1'),
  );
  static const VerificationMeta _needsUploadMeta = const VerificationMeta(
    'needsUpload',
  );
  @override
  late final GeneratedColumn<bool> needsUpload = GeneratedColumn<bool>(
    'needs_upload',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_upload" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isTestMeta = const VerificationMeta('isTest');
  @override
  late final GeneratedColumn<bool> isTest = GeneratedColumn<bool>(
    'is_test',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_test" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en-US'),
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _overallScoreMeta = const VerificationMeta(
    'overallScore',
  );
  @override
  late final GeneratedColumn<double> overallScore = GeneratedColumn<double>(
    'overall_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordsPerMinuteMeta = const VerificationMeta(
    'wordsPerMinute',
  );
  @override
  late final GeneratedColumn<double> wordsPerMinute = GeneratedColumn<double>(
    'words_per_minute',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fillerCountMeta = const VerificationMeta(
    'fillerCount',
  );
  @override
  late final GeneratedColumn<int> fillerCount = GeneratedColumn<int>(
    'filler_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pauseCountMeta = const VerificationMeta(
    'pauseCount',
  );
  @override
  late final GeneratedColumn<int> pauseCount = GeneratedColumn<int>(
    'pause_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _postureScoreMeta = const VerificationMeta(
    'postureScore',
  );
  @override
  late final GeneratedColumn<double> postureScore = GeneratedColumn<double>(
    'posture_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodySwayCmMeta = const VerificationMeta(
    'bodySwayCm',
  );
  @override
  late final GeneratedColumn<double> bodySwayCm = GeneratedColumn<double>(
    'body_sway_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gestureScoreMeta = const VerificationMeta(
    'gestureScore',
  );
  @override
  late final GeneratedColumn<double> gestureScore = GeneratedColumn<double>(
    'gesture_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasLocalDetailsMeta = const VerificationMeta(
    'hasLocalDetails',
  );
  @override
  late final GeneratedColumn<bool> hasLocalDetails = GeneratedColumn<bool>(
    'has_local_details',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_local_details" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    completedAt,
    practicePurpose,
    durationSeconds,
    starsEarned,
    baselineSessionId,
    scoringVersion,
    needsUpload,
    isTest,
    language,
    topic,
    overallScore,
    wordsPerMinute,
    fillerCount,
    pauseCount,
    postureScore,
    bodySwayCm,
    gestureScore,
    hasLocalDetails,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('practice_purpose')) {
      context.handle(
        _practicePurposeMeta,
        practicePurpose.isAcceptableOrUnknown(
          data['practice_purpose']!,
          _practicePurposeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_practicePurposeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('stars_earned')) {
      context.handle(
        _starsEarnedMeta,
        starsEarned.isAcceptableOrUnknown(
          data['stars_earned']!,
          _starsEarnedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_starsEarnedMeta);
    }
    if (data.containsKey('baseline_session_id')) {
      context.handle(
        _baselineSessionIdMeta,
        baselineSessionId.isAcceptableOrUnknown(
          data['baseline_session_id']!,
          _baselineSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('scoring_version')) {
      context.handle(
        _scoringVersionMeta,
        scoringVersion.isAcceptableOrUnknown(
          data['scoring_version']!,
          _scoringVersionMeta,
        ),
      );
    }
    if (data.containsKey('needs_upload')) {
      context.handle(
        _needsUploadMeta,
        needsUpload.isAcceptableOrUnknown(
          data['needs_upload']!,
          _needsUploadMeta,
        ),
      );
    }
    if (data.containsKey('is_test')) {
      context.handle(
        _isTestMeta,
        isTest.isAcceptableOrUnknown(data['is_test']!, _isTestMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    }
    if (data.containsKey('overall_score')) {
      context.handle(
        _overallScoreMeta,
        overallScore.isAcceptableOrUnknown(
          data['overall_score']!,
          _overallScoreMeta,
        ),
      );
    }
    if (data.containsKey('words_per_minute')) {
      context.handle(
        _wordsPerMinuteMeta,
        wordsPerMinute.isAcceptableOrUnknown(
          data['words_per_minute']!,
          _wordsPerMinuteMeta,
        ),
      );
    }
    if (data.containsKey('filler_count')) {
      context.handle(
        _fillerCountMeta,
        fillerCount.isAcceptableOrUnknown(
          data['filler_count']!,
          _fillerCountMeta,
        ),
      );
    }
    if (data.containsKey('pause_count')) {
      context.handle(
        _pauseCountMeta,
        pauseCount.isAcceptableOrUnknown(data['pause_count']!, _pauseCountMeta),
      );
    }
    if (data.containsKey('posture_score')) {
      context.handle(
        _postureScoreMeta,
        postureScore.isAcceptableOrUnknown(
          data['posture_score']!,
          _postureScoreMeta,
        ),
      );
    }
    if (data.containsKey('body_sway_cm')) {
      context.handle(
        _bodySwayCmMeta,
        bodySwayCm.isAcceptableOrUnknown(
          data['body_sway_cm']!,
          _bodySwayCmMeta,
        ),
      );
    }
    if (data.containsKey('gesture_score')) {
      context.handle(
        _gestureScoreMeta,
        gestureScore.isAcceptableOrUnknown(
          data['gesture_score']!,
          _gestureScoreMeta,
        ),
      );
    }
    if (data.containsKey('has_local_details')) {
      context.handle(
        _hasLocalDetailsMeta,
        hasLocalDetails.isAcceptableOrUnknown(
          data['has_local_details']!,
          _hasLocalDetailsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      practicePurpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}practice_purpose'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      starsEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars_earned'],
      )!,
      baselineSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baseline_session_id'],
      ),
      scoringVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scoring_version'],
      )!,
      needsUpload: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_upload'],
      )!,
      isTest: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_test'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      overallScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overall_score'],
      ),
      wordsPerMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}words_per_minute'],
      ),
      fillerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}filler_count'],
      ),
      pauseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_count'],
      ),
      postureScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}posture_score'],
      ),
      bodySwayCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_sway_cm'],
      ),
      gestureScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gesture_score'],
      ),
      hasLocalDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_local_details'],
      )!,
    );
  }

  @override
  $PracticeRecordsTable createAlias(String alias) {
    return $PracticeRecordsTable(attachedDatabase, alias);
  }
}

class PracticeRecord extends DataClass implements Insertable<PracticeRecord> {
  final String id;
  final String userId;
  final DateTime completedAt;
  final String practicePurpose;
  final int durationSeconds;
  final int starsEarned;
  final String? baselineSessionId;
  final String scoringVersion;
  final bool needsUpload;
  final bool isTest;
  final String language;
  final String topic;
  final double? overallScore;
  final double? wordsPerMinute;
  final int? fillerCount;
  final int? pauseCount;
  final double? postureScore;
  final double? bodySwayCm;
  final double? gestureScore;
  final bool hasLocalDetails;
  const PracticeRecord({
    required this.id,
    required this.userId,
    required this.completedAt,
    required this.practicePurpose,
    required this.durationSeconds,
    required this.starsEarned,
    this.baselineSessionId,
    required this.scoringVersion,
    required this.needsUpload,
    required this.isTest,
    required this.language,
    required this.topic,
    this.overallScore,
    this.wordsPerMinute,
    this.fillerCount,
    this.pauseCount,
    this.postureScore,
    this.bodySwayCm,
    this.gestureScore,
    required this.hasLocalDetails,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['practice_purpose'] = Variable<String>(practicePurpose);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['stars_earned'] = Variable<int>(starsEarned);
    if (!nullToAbsent || baselineSessionId != null) {
      map['baseline_session_id'] = Variable<String>(baselineSessionId);
    }
    map['scoring_version'] = Variable<String>(scoringVersion);
    map['needs_upload'] = Variable<bool>(needsUpload);
    map['is_test'] = Variable<bool>(isTest);
    map['language'] = Variable<String>(language);
    map['topic'] = Variable<String>(topic);
    if (!nullToAbsent || overallScore != null) {
      map['overall_score'] = Variable<double>(overallScore);
    }
    if (!nullToAbsent || wordsPerMinute != null) {
      map['words_per_minute'] = Variable<double>(wordsPerMinute);
    }
    if (!nullToAbsent || fillerCount != null) {
      map['filler_count'] = Variable<int>(fillerCount);
    }
    if (!nullToAbsent || pauseCount != null) {
      map['pause_count'] = Variable<int>(pauseCount);
    }
    if (!nullToAbsent || postureScore != null) {
      map['posture_score'] = Variable<double>(postureScore);
    }
    if (!nullToAbsent || bodySwayCm != null) {
      map['body_sway_cm'] = Variable<double>(bodySwayCm);
    }
    if (!nullToAbsent || gestureScore != null) {
      map['gesture_score'] = Variable<double>(gestureScore);
    }
    map['has_local_details'] = Variable<bool>(hasLocalDetails);
    return map;
  }

  PracticeRecordsCompanion toCompanion(bool nullToAbsent) {
    return PracticeRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      completedAt: Value(completedAt),
      practicePurpose: Value(practicePurpose),
      durationSeconds: Value(durationSeconds),
      starsEarned: Value(starsEarned),
      baselineSessionId: baselineSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineSessionId),
      scoringVersion: Value(scoringVersion),
      needsUpload: Value(needsUpload),
      isTest: Value(isTest),
      language: Value(language),
      topic: Value(topic),
      overallScore: overallScore == null && nullToAbsent
          ? const Value.absent()
          : Value(overallScore),
      wordsPerMinute: wordsPerMinute == null && nullToAbsent
          ? const Value.absent()
          : Value(wordsPerMinute),
      fillerCount: fillerCount == null && nullToAbsent
          ? const Value.absent()
          : Value(fillerCount),
      pauseCount: pauseCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseCount),
      postureScore: postureScore == null && nullToAbsent
          ? const Value.absent()
          : Value(postureScore),
      bodySwayCm: bodySwayCm == null && nullToAbsent
          ? const Value.absent()
          : Value(bodySwayCm),
      gestureScore: gestureScore == null && nullToAbsent
          ? const Value.absent()
          : Value(gestureScore),
      hasLocalDetails: Value(hasLocalDetails),
    );
  }

  factory PracticeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeRecord(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      practicePurpose: serializer.fromJson<String>(json['practicePurpose']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      starsEarned: serializer.fromJson<int>(json['starsEarned']),
      baselineSessionId: serializer.fromJson<String?>(
        json['baselineSessionId'],
      ),
      scoringVersion: serializer.fromJson<String>(json['scoringVersion']),
      needsUpload: serializer.fromJson<bool>(json['needsUpload']),
      isTest: serializer.fromJson<bool>(json['isTest']),
      language: serializer.fromJson<String>(json['language']),
      topic: serializer.fromJson<String>(json['topic']),
      overallScore: serializer.fromJson<double?>(json['overallScore']),
      wordsPerMinute: serializer.fromJson<double?>(json['wordsPerMinute']),
      fillerCount: serializer.fromJson<int?>(json['fillerCount']),
      pauseCount: serializer.fromJson<int?>(json['pauseCount']),
      postureScore: serializer.fromJson<double?>(json['postureScore']),
      bodySwayCm: serializer.fromJson<double?>(json['bodySwayCm']),
      gestureScore: serializer.fromJson<double?>(json['gestureScore']),
      hasLocalDetails: serializer.fromJson<bool>(json['hasLocalDetails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'practicePurpose': serializer.toJson<String>(practicePurpose),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'starsEarned': serializer.toJson<int>(starsEarned),
      'baselineSessionId': serializer.toJson<String?>(baselineSessionId),
      'scoringVersion': serializer.toJson<String>(scoringVersion),
      'needsUpload': serializer.toJson<bool>(needsUpload),
      'isTest': serializer.toJson<bool>(isTest),
      'language': serializer.toJson<String>(language),
      'topic': serializer.toJson<String>(topic),
      'overallScore': serializer.toJson<double?>(overallScore),
      'wordsPerMinute': serializer.toJson<double?>(wordsPerMinute),
      'fillerCount': serializer.toJson<int?>(fillerCount),
      'pauseCount': serializer.toJson<int?>(pauseCount),
      'postureScore': serializer.toJson<double?>(postureScore),
      'bodySwayCm': serializer.toJson<double?>(bodySwayCm),
      'gestureScore': serializer.toJson<double?>(gestureScore),
      'hasLocalDetails': serializer.toJson<bool>(hasLocalDetails),
    };
  }

  PracticeRecord copyWith({
    String? id,
    String? userId,
    DateTime? completedAt,
    String? practicePurpose,
    int? durationSeconds,
    int? starsEarned,
    Value<String?> baselineSessionId = const Value.absent(),
    String? scoringVersion,
    bool? needsUpload,
    bool? isTest,
    String? language,
    String? topic,
    Value<double?> overallScore = const Value.absent(),
    Value<double?> wordsPerMinute = const Value.absent(),
    Value<int?> fillerCount = const Value.absent(),
    Value<int?> pauseCount = const Value.absent(),
    Value<double?> postureScore = const Value.absent(),
    Value<double?> bodySwayCm = const Value.absent(),
    Value<double?> gestureScore = const Value.absent(),
    bool? hasLocalDetails,
  }) => PracticeRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    completedAt: completedAt ?? this.completedAt,
    practicePurpose: practicePurpose ?? this.practicePurpose,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    starsEarned: starsEarned ?? this.starsEarned,
    baselineSessionId: baselineSessionId.present
        ? baselineSessionId.value
        : this.baselineSessionId,
    scoringVersion: scoringVersion ?? this.scoringVersion,
    needsUpload: needsUpload ?? this.needsUpload,
    isTest: isTest ?? this.isTest,
    language: language ?? this.language,
    topic: topic ?? this.topic,
    overallScore: overallScore.present ? overallScore.value : this.overallScore,
    wordsPerMinute: wordsPerMinute.present
        ? wordsPerMinute.value
        : this.wordsPerMinute,
    fillerCount: fillerCount.present ? fillerCount.value : this.fillerCount,
    pauseCount: pauseCount.present ? pauseCount.value : this.pauseCount,
    postureScore: postureScore.present ? postureScore.value : this.postureScore,
    bodySwayCm: bodySwayCm.present ? bodySwayCm.value : this.bodySwayCm,
    gestureScore: gestureScore.present ? gestureScore.value : this.gestureScore,
    hasLocalDetails: hasLocalDetails ?? this.hasLocalDetails,
  );
  PracticeRecord copyWithCompanion(PracticeRecordsCompanion data) {
    return PracticeRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      practicePurpose: data.practicePurpose.present
          ? data.practicePurpose.value
          : this.practicePurpose,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      starsEarned: data.starsEarned.present
          ? data.starsEarned.value
          : this.starsEarned,
      baselineSessionId: data.baselineSessionId.present
          ? data.baselineSessionId.value
          : this.baselineSessionId,
      scoringVersion: data.scoringVersion.present
          ? data.scoringVersion.value
          : this.scoringVersion,
      needsUpload: data.needsUpload.present
          ? data.needsUpload.value
          : this.needsUpload,
      isTest: data.isTest.present ? data.isTest.value : this.isTest,
      language: data.language.present ? data.language.value : this.language,
      topic: data.topic.present ? data.topic.value : this.topic,
      overallScore: data.overallScore.present
          ? data.overallScore.value
          : this.overallScore,
      wordsPerMinute: data.wordsPerMinute.present
          ? data.wordsPerMinute.value
          : this.wordsPerMinute,
      fillerCount: data.fillerCount.present
          ? data.fillerCount.value
          : this.fillerCount,
      pauseCount: data.pauseCount.present
          ? data.pauseCount.value
          : this.pauseCount,
      postureScore: data.postureScore.present
          ? data.postureScore.value
          : this.postureScore,
      bodySwayCm: data.bodySwayCm.present
          ? data.bodySwayCm.value
          : this.bodySwayCm,
      gestureScore: data.gestureScore.present
          ? data.gestureScore.value
          : this.gestureScore,
      hasLocalDetails: data.hasLocalDetails.present
          ? data.hasLocalDetails.value
          : this.hasLocalDetails,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('completedAt: $completedAt, ')
          ..write('practicePurpose: $practicePurpose, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('baselineSessionId: $baselineSessionId, ')
          ..write('scoringVersion: $scoringVersion, ')
          ..write('needsUpload: $needsUpload, ')
          ..write('isTest: $isTest, ')
          ..write('language: $language, ')
          ..write('topic: $topic, ')
          ..write('overallScore: $overallScore, ')
          ..write('wordsPerMinute: $wordsPerMinute, ')
          ..write('fillerCount: $fillerCount, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('postureScore: $postureScore, ')
          ..write('bodySwayCm: $bodySwayCm, ')
          ..write('gestureScore: $gestureScore, ')
          ..write('hasLocalDetails: $hasLocalDetails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    completedAt,
    practicePurpose,
    durationSeconds,
    starsEarned,
    baselineSessionId,
    scoringVersion,
    needsUpload,
    isTest,
    language,
    topic,
    overallScore,
    wordsPerMinute,
    fillerCount,
    pauseCount,
    postureScore,
    bodySwayCm,
    gestureScore,
    hasLocalDetails,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.completedAt == this.completedAt &&
          other.practicePurpose == this.practicePurpose &&
          other.durationSeconds == this.durationSeconds &&
          other.starsEarned == this.starsEarned &&
          other.baselineSessionId == this.baselineSessionId &&
          other.scoringVersion == this.scoringVersion &&
          other.needsUpload == this.needsUpload &&
          other.isTest == this.isTest &&
          other.language == this.language &&
          other.topic == this.topic &&
          other.overallScore == this.overallScore &&
          other.wordsPerMinute == this.wordsPerMinute &&
          other.fillerCount == this.fillerCount &&
          other.pauseCount == this.pauseCount &&
          other.postureScore == this.postureScore &&
          other.bodySwayCm == this.bodySwayCm &&
          other.gestureScore == this.gestureScore &&
          other.hasLocalDetails == this.hasLocalDetails);
}

class PracticeRecordsCompanion extends UpdateCompanion<PracticeRecord> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> completedAt;
  final Value<String> practicePurpose;
  final Value<int> durationSeconds;
  final Value<int> starsEarned;
  final Value<String?> baselineSessionId;
  final Value<String> scoringVersion;
  final Value<bool> needsUpload;
  final Value<bool> isTest;
  final Value<String> language;
  final Value<String> topic;
  final Value<double?> overallScore;
  final Value<double?> wordsPerMinute;
  final Value<int?> fillerCount;
  final Value<int?> pauseCount;
  final Value<double?> postureScore;
  final Value<double?> bodySwayCm;
  final Value<double?> gestureScore;
  final Value<bool> hasLocalDetails;
  final Value<int> rowid;
  const PracticeRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.practicePurpose = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.starsEarned = const Value.absent(),
    this.baselineSessionId = const Value.absent(),
    this.scoringVersion = const Value.absent(),
    this.needsUpload = const Value.absent(),
    this.isTest = const Value.absent(),
    this.language = const Value.absent(),
    this.topic = const Value.absent(),
    this.overallScore = const Value.absent(),
    this.wordsPerMinute = const Value.absent(),
    this.fillerCount = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.postureScore = const Value.absent(),
    this.bodySwayCm = const Value.absent(),
    this.gestureScore = const Value.absent(),
    this.hasLocalDetails = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeRecordsCompanion.insert({
    required String id,
    required String userId,
    required DateTime completedAt,
    required String practicePurpose,
    required int durationSeconds,
    required int starsEarned,
    this.baselineSessionId = const Value.absent(),
    this.scoringVersion = const Value.absent(),
    this.needsUpload = const Value.absent(),
    this.isTest = const Value.absent(),
    this.language = const Value.absent(),
    this.topic = const Value.absent(),
    this.overallScore = const Value.absent(),
    this.wordsPerMinute = const Value.absent(),
    this.fillerCount = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.postureScore = const Value.absent(),
    this.bodySwayCm = const Value.absent(),
    this.gestureScore = const Value.absent(),
    this.hasLocalDetails = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       completedAt = Value(completedAt),
       practicePurpose = Value(practicePurpose),
       durationSeconds = Value(durationSeconds),
       starsEarned = Value(starsEarned);
  static Insertable<PracticeRecord> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? completedAt,
    Expression<String>? practicePurpose,
    Expression<int>? durationSeconds,
    Expression<int>? starsEarned,
    Expression<String>? baselineSessionId,
    Expression<String>? scoringVersion,
    Expression<bool>? needsUpload,
    Expression<bool>? isTest,
    Expression<String>? language,
    Expression<String>? topic,
    Expression<double>? overallScore,
    Expression<double>? wordsPerMinute,
    Expression<int>? fillerCount,
    Expression<int>? pauseCount,
    Expression<double>? postureScore,
    Expression<double>? bodySwayCm,
    Expression<double>? gestureScore,
    Expression<bool>? hasLocalDetails,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (completedAt != null) 'completed_at': completedAt,
      if (practicePurpose != null) 'practice_purpose': practicePurpose,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (starsEarned != null) 'stars_earned': starsEarned,
      if (baselineSessionId != null) 'baseline_session_id': baselineSessionId,
      if (scoringVersion != null) 'scoring_version': scoringVersion,
      if (needsUpload != null) 'needs_upload': needsUpload,
      if (isTest != null) 'is_test': isTest,
      if (language != null) 'language': language,
      if (topic != null) 'topic': topic,
      if (overallScore != null) 'overall_score': overallScore,
      if (wordsPerMinute != null) 'words_per_minute': wordsPerMinute,
      if (fillerCount != null) 'filler_count': fillerCount,
      if (pauseCount != null) 'pause_count': pauseCount,
      if (postureScore != null) 'posture_score': postureScore,
      if (bodySwayCm != null) 'body_sway_cm': bodySwayCm,
      if (gestureScore != null) 'gesture_score': gestureScore,
      if (hasLocalDetails != null) 'has_local_details': hasLocalDetails,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? completedAt,
    Value<String>? practicePurpose,
    Value<int>? durationSeconds,
    Value<int>? starsEarned,
    Value<String?>? baselineSessionId,
    Value<String>? scoringVersion,
    Value<bool>? needsUpload,
    Value<bool>? isTest,
    Value<String>? language,
    Value<String>? topic,
    Value<double?>? overallScore,
    Value<double?>? wordsPerMinute,
    Value<int?>? fillerCount,
    Value<int?>? pauseCount,
    Value<double?>? postureScore,
    Value<double?>? bodySwayCm,
    Value<double?>? gestureScore,
    Value<bool>? hasLocalDetails,
    Value<int>? rowid,
  }) {
    return PracticeRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      completedAt: completedAt ?? this.completedAt,
      practicePurpose: practicePurpose ?? this.practicePurpose,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      starsEarned: starsEarned ?? this.starsEarned,
      baselineSessionId: baselineSessionId ?? this.baselineSessionId,
      scoringVersion: scoringVersion ?? this.scoringVersion,
      needsUpload: needsUpload ?? this.needsUpload,
      isTest: isTest ?? this.isTest,
      language: language ?? this.language,
      topic: topic ?? this.topic,
      overallScore: overallScore ?? this.overallScore,
      wordsPerMinute: wordsPerMinute ?? this.wordsPerMinute,
      fillerCount: fillerCount ?? this.fillerCount,
      pauseCount: pauseCount ?? this.pauseCount,
      postureScore: postureScore ?? this.postureScore,
      bodySwayCm: bodySwayCm ?? this.bodySwayCm,
      gestureScore: gestureScore ?? this.gestureScore,
      hasLocalDetails: hasLocalDetails ?? this.hasLocalDetails,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (practicePurpose.present) {
      map['practice_purpose'] = Variable<String>(practicePurpose.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (starsEarned.present) {
      map['stars_earned'] = Variable<int>(starsEarned.value);
    }
    if (baselineSessionId.present) {
      map['baseline_session_id'] = Variable<String>(baselineSessionId.value);
    }
    if (scoringVersion.present) {
      map['scoring_version'] = Variable<String>(scoringVersion.value);
    }
    if (needsUpload.present) {
      map['needs_upload'] = Variable<bool>(needsUpload.value);
    }
    if (isTest.present) {
      map['is_test'] = Variable<bool>(isTest.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (overallScore.present) {
      map['overall_score'] = Variable<double>(overallScore.value);
    }
    if (wordsPerMinute.present) {
      map['words_per_minute'] = Variable<double>(wordsPerMinute.value);
    }
    if (fillerCount.present) {
      map['filler_count'] = Variable<int>(fillerCount.value);
    }
    if (pauseCount.present) {
      map['pause_count'] = Variable<int>(pauseCount.value);
    }
    if (postureScore.present) {
      map['posture_score'] = Variable<double>(postureScore.value);
    }
    if (bodySwayCm.present) {
      map['body_sway_cm'] = Variable<double>(bodySwayCm.value);
    }
    if (gestureScore.present) {
      map['gesture_score'] = Variable<double>(gestureScore.value);
    }
    if (hasLocalDetails.present) {
      map['has_local_details'] = Variable<bool>(hasLocalDetails.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('completedAt: $completedAt, ')
          ..write('practicePurpose: $practicePurpose, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('starsEarned: $starsEarned, ')
          ..write('baselineSessionId: $baselineSessionId, ')
          ..write('scoringVersion: $scoringVersion, ')
          ..write('needsUpload: $needsUpload, ')
          ..write('isTest: $isTest, ')
          ..write('language: $language, ')
          ..write('topic: $topic, ')
          ..write('overallScore: $overallScore, ')
          ..write('wordsPerMinute: $wordsPerMinute, ')
          ..write('fillerCount: $fillerCount, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('postureScore: $postureScore, ')
          ..write('bodySwayCm: $bodySwayCm, ')
          ..write('gestureScore: $gestureScore, ')
          ..write('hasLocalDetails: $hasLocalDetails, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _practicePurposeMeta = const VerificationMeta(
    'practicePurpose',
  );
  @override
  late final GeneratedColumn<String> practicePurpose = GeneratedColumn<String>(
    'practice_purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<String> revision = GeneratedColumn<String>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _needsUploadMeta = const VerificationMeta(
    'needsUpload',
  );
  @override
  late final GeneratedColumn<bool> needsUpload = GeneratedColumn<bool>(
    'needs_upload',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_upload" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    fullName,
    nickname,
    language,
    practicePurpose,
    onboardingComplete,
    revision,
    needsUpload,
    username,
    email,
    school,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('practice_purpose')) {
      context.handle(
        _practicePurposeMeta,
        practicePurpose.isAcceptableOrUnknown(
          data['practice_purpose']!,
          _practicePurposeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_practicePurposeMeta);
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('needs_upload')) {
      context.handle(
        _needsUploadMeta,
        needsUpload.isAcceptableOrUnknown(
          data['needs_upload']!,
          _needsUploadMeta,
        ),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      practicePurpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}practice_purpose'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision'],
      )!,
      needsUpload: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_upload'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final String userId;
  final String fullName;
  final String nickname;
  final String language;
  final String practicePurpose;
  final bool onboardingComplete;
  final String revision;
  final bool needsUpload;
  final String username;
  final String email;
  final String school;

  /// Device-local file path; never synchronized.
  final String? photoPath;
  const LocalProfile({
    required this.userId,
    required this.fullName,
    required this.nickname,
    required this.language,
    required this.practicePurpose,
    required this.onboardingComplete,
    required this.revision,
    required this.needsUpload,
    required this.username,
    required this.email,
    required this.school,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['full_name'] = Variable<String>(fullName);
    map['nickname'] = Variable<String>(nickname);
    map['language'] = Variable<String>(language);
    map['practice_purpose'] = Variable<String>(practicePurpose);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['revision'] = Variable<String>(revision);
    map['needs_upload'] = Variable<bool>(needsUpload);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['school'] = Variable<String>(school);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      userId: Value(userId),
      fullName: Value(fullName),
      nickname: Value(nickname),
      language: Value(language),
      practicePurpose: Value(practicePurpose),
      onboardingComplete: Value(onboardingComplete),
      revision: Value(revision),
      needsUpload: Value(needsUpload),
      username: Value(username),
      email: Value(email),
      school: Value(school),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory LocalProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      userId: serializer.fromJson<String>(json['userId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      nickname: serializer.fromJson<String>(json['nickname']),
      language: serializer.fromJson<String>(json['language']),
      practicePurpose: serializer.fromJson<String>(json['practicePurpose']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      revision: serializer.fromJson<String>(json['revision']),
      needsUpload: serializer.fromJson<bool>(json['needsUpload']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      school: serializer.fromJson<String>(json['school']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'fullName': serializer.toJson<String>(fullName),
      'nickname': serializer.toJson<String>(nickname),
      'language': serializer.toJson<String>(language),
      'practicePurpose': serializer.toJson<String>(practicePurpose),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'revision': serializer.toJson<String>(revision),
      'needsUpload': serializer.toJson<bool>(needsUpload),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'school': serializer.toJson<String>(school),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  LocalProfile copyWith({
    String? userId,
    String? fullName,
    String? nickname,
    String? language,
    String? practicePurpose,
    bool? onboardingComplete,
    String? revision,
    bool? needsUpload,
    String? username,
    String? email,
    String? school,
    Value<String?> photoPath = const Value.absent(),
  }) => LocalProfile(
    userId: userId ?? this.userId,
    fullName: fullName ?? this.fullName,
    nickname: nickname ?? this.nickname,
    language: language ?? this.language,
    practicePurpose: practicePurpose ?? this.practicePurpose,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    revision: revision ?? this.revision,
    needsUpload: needsUpload ?? this.needsUpload,
    username: username ?? this.username,
    email: email ?? this.email,
    school: school ?? this.school,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  LocalProfile copyWithCompanion(UserProfilesCompanion data) {
    return LocalProfile(
      userId: data.userId.present ? data.userId.value : this.userId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      language: data.language.present ? data.language.value : this.language,
      practicePurpose: data.practicePurpose.present
          ? data.practicePurpose.value
          : this.practicePurpose,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      revision: data.revision.present ? data.revision.value : this.revision,
      needsUpload: data.needsUpload.present
          ? data.needsUpload.value
          : this.needsUpload,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      school: data.school.present ? data.school.value : this.school,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('nickname: $nickname, ')
          ..write('language: $language, ')
          ..write('practicePurpose: $practicePurpose, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('revision: $revision, ')
          ..write('needsUpload: $needsUpload, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('school: $school, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    fullName,
    nickname,
    language,
    practicePurpose,
    onboardingComplete,
    revision,
    needsUpload,
    username,
    email,
    school,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.userId == this.userId &&
          other.fullName == this.fullName &&
          other.nickname == this.nickname &&
          other.language == this.language &&
          other.practicePurpose == this.practicePurpose &&
          other.onboardingComplete == this.onboardingComplete &&
          other.revision == this.revision &&
          other.needsUpload == this.needsUpload &&
          other.username == this.username &&
          other.email == this.email &&
          other.school == this.school &&
          other.photoPath == this.photoPath);
}

class UserProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> userId;
  final Value<String> fullName;
  final Value<String> nickname;
  final Value<String> language;
  final Value<String> practicePurpose;
  final Value<bool> onboardingComplete;
  final Value<String> revision;
  final Value<bool> needsUpload;
  final Value<String> username;
  final Value<String> email;
  final Value<String> school;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.userId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.nickname = const Value.absent(),
    this.language = const Value.absent(),
    this.practicePurpose = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.revision = const Value.absent(),
    this.needsUpload = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.school = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String userId,
    required String fullName,
    required String nickname,
    required String language,
    required String practicePurpose,
    this.onboardingComplete = const Value.absent(),
    required String revision,
    this.needsUpload = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.school = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       fullName = Value(fullName),
       nickname = Value(nickname),
       language = Value(language),
       practicePurpose = Value(practicePurpose),
       revision = Value(revision);
  static Insertable<LocalProfile> custom({
    Expression<String>? userId,
    Expression<String>? fullName,
    Expression<String>? nickname,
    Expression<String>? language,
    Expression<String>? practicePurpose,
    Expression<bool>? onboardingComplete,
    Expression<String>? revision,
    Expression<bool>? needsUpload,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? school,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (fullName != null) 'full_name': fullName,
      if (nickname != null) 'nickname': nickname,
      if (language != null) 'language': language,
      if (practicePurpose != null) 'practice_purpose': practicePurpose,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (revision != null) 'revision': revision,
      if (needsUpload != null) 'needs_upload': needsUpload,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (school != null) 'school': school,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? userId,
    Value<String>? fullName,
    Value<String>? nickname,
    Value<String>? language,
    Value<String>? practicePurpose,
    Value<bool>? onboardingComplete,
    Value<String>? revision,
    Value<bool>? needsUpload,
    Value<String>? username,
    Value<String>? email,
    Value<String>? school,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      language: language ?? this.language,
      practicePurpose: practicePurpose ?? this.practicePurpose,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      revision: revision ?? this.revision,
      needsUpload: needsUpload ?? this.needsUpload,
      username: username ?? this.username,
      email: email ?? this.email,
      school: school ?? this.school,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (practicePurpose.present) {
      map['practice_purpose'] = Variable<String>(practicePurpose.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (revision.present) {
      map['revision'] = Variable<String>(revision.value);
    }
    if (needsUpload.present) {
      map['needs_upload'] = Variable<bool>(needsUpload.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('nickname: $nickname, ')
          ..write('language: $language, ')
          ..write('practicePurpose: $practicePurpose, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('revision: $revision, ')
          ..write('needsUpload: $needsUpload, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('school: $school, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceSettingsTable extends DeviceSettings
    with TableInfo<$DeviceSettingsTable, DeviceSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DeviceSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $DeviceSettingsTable createAlias(String alias) {
    return $DeviceSettingsTable(attachedDatabase, alias);
  }
}

class DeviceSetting extends DataClass implements Insertable<DeviceSetting> {
  final String key;
  final String value;
  const DeviceSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DeviceSettingsCompanion toCompanion(bool nullToAbsent) {
    return DeviceSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory DeviceSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DeviceSetting copyWith({String? key, String? value}) =>
      DeviceSetting(key: key ?? this.key, value: value ?? this.value);
  DeviceSetting copyWithCompanion(DeviceSettingsCompanion data) {
    return DeviceSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class DeviceSettingsCompanion extends UpdateCompanion<DeviceSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DeviceSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DeviceSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return DeviceSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionDetailsTable extends SessionDetails
    with TableInfo<$SessionDetailsTable, SessionDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transcriptMeta = const VerificationMeta(
    'transcript',
  );
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
    'transcript',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _reportJsonMeta = const VerificationMeta(
    'reportJson',
  );
  @override
  late final GeneratedColumn<String> reportJson = GeneratedColumn<String>(
    'report_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    userId,
    transcript,
    reportJson,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('transcript')) {
      context.handle(
        _transcriptMeta,
        transcript.isAcceptableOrUnknown(data['transcript']!, _transcriptMeta),
      );
    }
    if (data.containsKey('report_json')) {
      context.handle(
        _reportJsonMeta,
        reportJson.isAcceptableOrUnknown(data['report_json']!, _reportJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_reportJsonMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  SessionDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionDetail(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      transcript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transcript'],
      )!,
      reportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_json'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
    );
  }

  @override
  $SessionDetailsTable createAlias(String alias) {
    return $SessionDetailsTable(attachedDatabase, alias);
  }
}

class SessionDetail extends DataClass implements Insertable<SessionDetail> {
  final String sessionId;
  final String userId;
  final String transcript;
  final String reportJson;
  final String? audioPath;
  const SessionDetail({
    required this.sessionId,
    required this.userId,
    required this.transcript,
    required this.reportJson,
    this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['user_id'] = Variable<String>(userId);
    map['transcript'] = Variable<String>(transcript);
    map['report_json'] = Variable<String>(reportJson);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    return map;
  }

  SessionDetailsCompanion toCompanion(bool nullToAbsent) {
    return SessionDetailsCompanion(
      sessionId: Value(sessionId),
      userId: Value(userId),
      transcript: Value(transcript),
      reportJson: Value(reportJson),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
    );
  }

  factory SessionDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionDetail(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      userId: serializer.fromJson<String>(json['userId']),
      transcript: serializer.fromJson<String>(json['transcript']),
      reportJson: serializer.fromJson<String>(json['reportJson']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'userId': serializer.toJson<String>(userId),
      'transcript': serializer.toJson<String>(transcript),
      'reportJson': serializer.toJson<String>(reportJson),
      'audioPath': serializer.toJson<String?>(audioPath),
    };
  }

  SessionDetail copyWith({
    String? sessionId,
    String? userId,
    String? transcript,
    String? reportJson,
    Value<String?> audioPath = const Value.absent(),
  }) => SessionDetail(
    sessionId: sessionId ?? this.sessionId,
    userId: userId ?? this.userId,
    transcript: transcript ?? this.transcript,
    reportJson: reportJson ?? this.reportJson,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
  );
  SessionDetail copyWithCompanion(SessionDetailsCompanion data) {
    return SessionDetail(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      userId: data.userId.present ? data.userId.value : this.userId,
      transcript: data.transcript.present
          ? data.transcript.value
          : this.transcript,
      reportJson: data.reportJson.present
          ? data.reportJson.value
          : this.reportJson,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionDetail(')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('transcript: $transcript, ')
          ..write('reportJson: $reportJson, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, userId, transcript, reportJson, audioPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionDetail &&
          other.sessionId == this.sessionId &&
          other.userId == this.userId &&
          other.transcript == this.transcript &&
          other.reportJson == this.reportJson &&
          other.audioPath == this.audioPath);
}

class SessionDetailsCompanion extends UpdateCompanion<SessionDetail> {
  final Value<String> sessionId;
  final Value<String> userId;
  final Value<String> transcript;
  final Value<String> reportJson;
  final Value<String?> audioPath;
  final Value<int> rowid;
  const SessionDetailsCompanion({
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.transcript = const Value.absent(),
    this.reportJson = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionDetailsCompanion.insert({
    required String sessionId,
    required String userId,
    this.transcript = const Value.absent(),
    required String reportJson,
    this.audioPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       userId = Value(userId),
       reportJson = Value(reportJson);
  static Insertable<SessionDetail> custom({
    Expression<String>? sessionId,
    Expression<String>? userId,
    Expression<String>? transcript,
    Expression<String>? reportJson,
    Expression<String>? audioPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (userId != null) 'user_id': userId,
      if (transcript != null) 'transcript': transcript,
      if (reportJson != null) 'report_json': reportJson,
      if (audioPath != null) 'audio_path': audioPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionDetailsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? userId,
    Value<String>? transcript,
    Value<String>? reportJson,
    Value<String?>? audioPath,
    Value<int>? rowid,
  }) {
    return SessionDetailsCompanion(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      transcript: transcript ?? this.transcript,
      reportJson: reportJson ?? this.reportJson,
      audioPath: audioPath ?? this.audioPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (reportJson.present) {
      map['report_json'] = Variable<String>(reportJson.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionDetailsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('transcript: $transcript, ')
          ..write('reportJson: $reportJson, ')
          ..write('audioPath: $audioPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDocumentsTable extends LocalDocuments
    with TableInfo<$LocalDocumentsTable, LocalDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _resultJsonMeta = const VerificationMeta(
    'resultJson',
  );
  @override
  late final GeneratedColumn<String> resultJson = GeneratedColumn<String>(
    'result_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    wordCount,
    resultJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    if (data.containsKey('result_json')) {
      context.handle(
        _resultJsonMeta,
        resultJson.isAcceptableOrUnknown(data['result_json']!, _resultJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_resultJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
      resultJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalDocumentsTable createAlias(String alias) {
    return $LocalDocumentsTable(attachedDatabase, alias);
  }
}

class LocalDocument extends DataClass implements Insertable<LocalDocument> {
  final String id;
  final String userId;
  final String title;
  final int wordCount;
  final String resultJson;
  final DateTime createdAt;
  const LocalDocument({
    required this.id,
    required this.userId,
    required this.title,
    required this.wordCount,
    required this.resultJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['word_count'] = Variable<int>(wordCount);
    map['result_json'] = Variable<String>(resultJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalDocumentsCompanion toCompanion(bool nullToAbsent) {
    return LocalDocumentsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      wordCount: Value(wordCount),
      resultJson: Value(resultJson),
      createdAt: Value(createdAt),
    );
  }

  factory LocalDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDocument(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      resultJson: serializer.fromJson<String>(json['resultJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'wordCount': serializer.toJson<int>(wordCount),
      'resultJson': serializer.toJson<String>(resultJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalDocument copyWith({
    String? id,
    String? userId,
    String? title,
    int? wordCount,
    String? resultJson,
    DateTime? createdAt,
  }) => LocalDocument(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    wordCount: wordCount ?? this.wordCount,
    resultJson: resultJson ?? this.resultJson,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalDocument copyWithCompanion(LocalDocumentsCompanion data) {
    return LocalDocument(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      resultJson: data.resultJson.present
          ? data.resultJson.value
          : this.resultJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDocument(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('wordCount: $wordCount, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, title, wordCount, resultJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDocument &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.wordCount == this.wordCount &&
          other.resultJson == this.resultJson &&
          other.createdAt == this.createdAt);
}

class LocalDocumentsCompanion extends UpdateCompanion<LocalDocument> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<int> wordCount;
  final Value<String> resultJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalDocumentsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.resultJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDocumentsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.wordCount = const Value.absent(),
    required String resultJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       resultJson = Value(resultJson),
       createdAt = Value(createdAt);
  static Insertable<LocalDocument> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<int>? wordCount,
    Expression<String>? resultJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (wordCount != null) 'word_count': wordCount,
      if (resultJson != null) 'result_json': resultJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<int>? wordCount,
    Value<String>? resultJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalDocumentsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      wordCount: wordCount ?? this.wordCount,
      resultJson: resultJson ?? this.resultJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (resultJson.present) {
      map['result_json'] = Variable<String>(resultJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('wordCount: $wordCount, ')
          ..write('resultJson: $resultJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PracticeRecordsTable practiceRecords = $PracticeRecordsTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $DeviceSettingsTable deviceSettings = $DeviceSettingsTable(this);
  late final $SessionDetailsTable sessionDetails = $SessionDetailsTable(this);
  late final $LocalDocumentsTable localDocuments = $LocalDocumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    practiceRecords,
    userProfiles,
    deviceSettings,
    sessionDetails,
    localDocuments,
  ];
}

typedef $$PracticeRecordsTableCreateCompanionBuilder =
    PracticeRecordsCompanion Function({
      required String id,
      required String userId,
      required DateTime completedAt,
      required String practicePurpose,
      required int durationSeconds,
      required int starsEarned,
      Value<String?> baselineSessionId,
      Value<String> scoringVersion,
      Value<bool> needsUpload,
      Value<bool> isTest,
      Value<String> language,
      Value<String> topic,
      Value<double?> overallScore,
      Value<double?> wordsPerMinute,
      Value<int?> fillerCount,
      Value<int?> pauseCount,
      Value<double?> postureScore,
      Value<double?> bodySwayCm,
      Value<double?> gestureScore,
      Value<bool> hasLocalDetails,
      Value<int> rowid,
    });
typedef $$PracticeRecordsTableUpdateCompanionBuilder =
    PracticeRecordsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> completedAt,
      Value<String> practicePurpose,
      Value<int> durationSeconds,
      Value<int> starsEarned,
      Value<String?> baselineSessionId,
      Value<String> scoringVersion,
      Value<bool> needsUpload,
      Value<bool> isTest,
      Value<String> language,
      Value<String> topic,
      Value<double?> overallScore,
      Value<double?> wordsPerMinute,
      Value<int?> fillerCount,
      Value<int?> pauseCount,
      Value<double?> postureScore,
      Value<double?> bodySwayCm,
      Value<double?> gestureScore,
      Value<bool> hasLocalDetails,
      Value<int> rowid,
    });

class $$PracticeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeRecordsTable> {
  $$PracticeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baselineSessionId => $composableBuilder(
    column: $table.baselineSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTest => $composableBuilder(
    column: $table.isTest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get wordsPerMinute => $composableBuilder(
    column: $table.wordsPerMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get postureScore => $composableBuilder(
    column: $table.postureScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodySwayCm => $composableBuilder(
    column: $table.bodySwayCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gestureScore => $composableBuilder(
    column: $table.gestureScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasLocalDetails => $composableBuilder(
    column: $table.hasLocalDetails,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeRecordsTable> {
  $$PracticeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baselineSessionId => $composableBuilder(
    column: $table.baselineSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTest => $composableBuilder(
    column: $table.isTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get wordsPerMinute => $composableBuilder(
    column: $table.wordsPerMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get postureScore => $composableBuilder(
    column: $table.postureScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodySwayCm => $composableBuilder(
    column: $table.bodySwayCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gestureScore => $composableBuilder(
    column: $table.gestureScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasLocalDetails => $composableBuilder(
    column: $table.hasLocalDetails,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeRecordsTable> {
  $$PracticeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get starsEarned => $composableBuilder(
    column: $table.starsEarned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baselineSessionId => $composableBuilder(
    column: $table.baselineSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scoringVersion => $composableBuilder(
    column: $table.scoringVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTest =>
      $composableBuilder(column: $table.isTest, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<double> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get wordsPerMinute => $composableBuilder(
    column: $table.wordsPerMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get postureScore => $composableBuilder(
    column: $table.postureScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bodySwayCm => $composableBuilder(
    column: $table.bodySwayCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gestureScore => $composableBuilder(
    column: $table.gestureScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasLocalDetails => $composableBuilder(
    column: $table.hasLocalDetails,
    builder: (column) => column,
  );
}

class $$PracticeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeRecordsTable,
          PracticeRecord,
          $$PracticeRecordsTableFilterComposer,
          $$PracticeRecordsTableOrderingComposer,
          $$PracticeRecordsTableAnnotationComposer,
          $$PracticeRecordsTableCreateCompanionBuilder,
          $$PracticeRecordsTableUpdateCompanionBuilder,
          (
            PracticeRecord,
            BaseReferences<
              _$AppDatabase,
              $PracticeRecordsTable,
              PracticeRecord
            >,
          ),
          PracticeRecord,
          PrefetchHooks Function()
        > {
  $$PracticeRecordsTableTableManager(
    _$AppDatabase db,
    $PracticeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String> practicePurpose = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> starsEarned = const Value.absent(),
                Value<String?> baselineSessionId = const Value.absent(),
                Value<String> scoringVersion = const Value.absent(),
                Value<bool> needsUpload = const Value.absent(),
                Value<bool> isTest = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<double?> overallScore = const Value.absent(),
                Value<double?> wordsPerMinute = const Value.absent(),
                Value<int?> fillerCount = const Value.absent(),
                Value<int?> pauseCount = const Value.absent(),
                Value<double?> postureScore = const Value.absent(),
                Value<double?> bodySwayCm = const Value.absent(),
                Value<double?> gestureScore = const Value.absent(),
                Value<bool> hasLocalDetails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeRecordsCompanion(
                id: id,
                userId: userId,
                completedAt: completedAt,
                practicePurpose: practicePurpose,
                durationSeconds: durationSeconds,
                starsEarned: starsEarned,
                baselineSessionId: baselineSessionId,
                scoringVersion: scoringVersion,
                needsUpload: needsUpload,
                isTest: isTest,
                language: language,
                topic: topic,
                overallScore: overallScore,
                wordsPerMinute: wordsPerMinute,
                fillerCount: fillerCount,
                pauseCount: pauseCount,
                postureScore: postureScore,
                bodySwayCm: bodySwayCm,
                gestureScore: gestureScore,
                hasLocalDetails: hasLocalDetails,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime completedAt,
                required String practicePurpose,
                required int durationSeconds,
                required int starsEarned,
                Value<String?> baselineSessionId = const Value.absent(),
                Value<String> scoringVersion = const Value.absent(),
                Value<bool> needsUpload = const Value.absent(),
                Value<bool> isTest = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<double?> overallScore = const Value.absent(),
                Value<double?> wordsPerMinute = const Value.absent(),
                Value<int?> fillerCount = const Value.absent(),
                Value<int?> pauseCount = const Value.absent(),
                Value<double?> postureScore = const Value.absent(),
                Value<double?> bodySwayCm = const Value.absent(),
                Value<double?> gestureScore = const Value.absent(),
                Value<bool> hasLocalDetails = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PracticeRecordsCompanion.insert(
                id: id,
                userId: userId,
                completedAt: completedAt,
                practicePurpose: practicePurpose,
                durationSeconds: durationSeconds,
                starsEarned: starsEarned,
                baselineSessionId: baselineSessionId,
                scoringVersion: scoringVersion,
                needsUpload: needsUpload,
                isTest: isTest,
                language: language,
                topic: topic,
                overallScore: overallScore,
                wordsPerMinute: wordsPerMinute,
                fillerCount: fillerCount,
                pauseCount: pauseCount,
                postureScore: postureScore,
                bodySwayCm: bodySwayCm,
                gestureScore: gestureScore,
                hasLocalDetails: hasLocalDetails,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PracticeRecordsTable, PracticeRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PracticeRecordsTable,
                    PracticeRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeRecordsTable,
      PracticeRecord,
      $$PracticeRecordsTableFilterComposer,
      $$PracticeRecordsTableOrderingComposer,
      $$PracticeRecordsTableAnnotationComposer,
      $$PracticeRecordsTableCreateCompanionBuilder,
      $$PracticeRecordsTableUpdateCompanionBuilder,
      (
        PracticeRecord,
        BaseReferences<_$AppDatabase, $PracticeRecordsTable, PracticeRecord>,
      ),
      PracticeRecord,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String userId,
      required String fullName,
      required String nickname,
      required String language,
      required String practicePurpose,
      Value<bool> onboardingComplete,
      required String revision,
      Value<bool> needsUpload,
      Value<String> username,
      Value<String> email,
      Value<String> school,
      Value<String?> photoPath,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> userId,
      Value<String> fullName,
      Value<String> nickname,
      Value<String> language,
      Value<String> practicePurpose,
      Value<bool> onboardingComplete,
      Value<String> revision,
      Value<bool> needsUpload,
      Value<String> username,
      Value<String> email,
      Value<String> school,
      Value<String?> photoPath,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get practicePurpose => $composableBuilder(
    column: $table.practicePurpose,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<bool> get needsUpload => $composableBuilder(
    column: $table.needsUpload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          LocalProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            LocalProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, LocalProfile>,
          ),
          LocalProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> practicePurpose = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> revision = const Value.absent(),
                Value<bool> needsUpload = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                userId: userId,
                fullName: fullName,
                nickname: nickname,
                language: language,
                practicePurpose: practicePurpose,
                onboardingComplete: onboardingComplete,
                revision: revision,
                needsUpload: needsUpload,
                username: username,
                email: email,
                school: school,
                photoPath: photoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String fullName,
                required String nickname,
                required String language,
                required String practicePurpose,
                Value<bool> onboardingComplete = const Value.absent(),
                required String revision,
                Value<bool> needsUpload = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                userId: userId,
                fullName: fullName,
                nickname: nickname,
                language: language,
                practicePurpose: practicePurpose,
                onboardingComplete: onboardingComplete,
                revision: revision,
                needsUpload: needsUpload,
                username: username,
                email: email,
                school: school,
                photoPath: photoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, LocalProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    LocalProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      LocalProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        LocalProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, LocalProfile>,
      ),
      LocalProfile,
      PrefetchHooks Function()
    >;
typedef $$DeviceSettingsTableCreateCompanionBuilder =
    DeviceSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$DeviceSettingsTableUpdateCompanionBuilder =
    DeviceSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$DeviceSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DeviceSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceSettingsTable,
          DeviceSetting,
          $$DeviceSettingsTableFilterComposer,
          $$DeviceSettingsTableOrderingComposer,
          $$DeviceSettingsTableAnnotationComposer,
          $$DeviceSettingsTableCreateCompanionBuilder,
          $$DeviceSettingsTableUpdateCompanionBuilder,
          (
            DeviceSetting,
            BaseReferences<_$AppDatabase, $DeviceSettingsTable, DeviceSetting>,
          ),
          DeviceSetting,
          PrefetchHooks Function()
        > {
  $$DeviceSettingsTableTableManager(
    _$AppDatabase db,
    $DeviceSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  DeviceSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => DeviceSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceSettingsTable, DeviceSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeviceSettingsTable,
                    DeviceSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceSettingsTable,
      DeviceSetting,
      $$DeviceSettingsTableFilterComposer,
      $$DeviceSettingsTableOrderingComposer,
      $$DeviceSettingsTableAnnotationComposer,
      $$DeviceSettingsTableCreateCompanionBuilder,
      $$DeviceSettingsTableUpdateCompanionBuilder,
      (
        DeviceSetting,
        BaseReferences<_$AppDatabase, $DeviceSettingsTable, DeviceSetting>,
      ),
      DeviceSetting,
      PrefetchHooks Function()
    >;
typedef $$SessionDetailsTableCreateCompanionBuilder =
    SessionDetailsCompanion Function({
      required String sessionId,
      required String userId,
      Value<String> transcript,
      required String reportJson,
      Value<String?> audioPath,
      Value<int> rowid,
    });
typedef $$SessionDetailsTableUpdateCompanionBuilder =
    SessionDetailsCompanion Function({
      Value<String> sessionId,
      Value<String> userId,
      Value<String> transcript,
      Value<String> reportJson,
      Value<String?> audioPath,
      Value<int> rowid,
    });

class $$SessionDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionDetailsTable> {
  $$SessionDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionDetailsTable> {
  $$SessionDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionDetailsTable> {
  $$SessionDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);
}

class $$SessionDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionDetailsTable,
          SessionDetail,
          $$SessionDetailsTableFilterComposer,
          $$SessionDetailsTableOrderingComposer,
          $$SessionDetailsTableAnnotationComposer,
          $$SessionDetailsTableCreateCompanionBuilder,
          $$SessionDetailsTableUpdateCompanionBuilder,
          (
            SessionDetail,
            BaseReferences<_$AppDatabase, $SessionDetailsTable, SessionDetail>,
          ),
          SessionDetail,
          PrefetchHooks Function()
        > {
  $$SessionDetailsTableTableManager(
    _$AppDatabase db,
    $SessionDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> transcript = const Value.absent(),
                Value<String> reportJson = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionDetailsCompanion(
                sessionId: sessionId,
                userId: userId,
                transcript: transcript,
                reportJson: reportJson,
                audioPath: audioPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String userId,
                Value<String> transcript = const Value.absent(),
                required String reportJson,
                Value<String?> audioPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionDetailsCompanion.insert(
                sessionId: sessionId,
                userId: userId,
                transcript: transcript,
                reportJson: reportJson,
                audioPath: audioPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionDetailsTable, SessionDetail>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SessionDetailsTable,
                    SessionDetail
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionDetailsTable,
      SessionDetail,
      $$SessionDetailsTableFilterComposer,
      $$SessionDetailsTableOrderingComposer,
      $$SessionDetailsTableAnnotationComposer,
      $$SessionDetailsTableCreateCompanionBuilder,
      $$SessionDetailsTableUpdateCompanionBuilder,
      (
        SessionDetail,
        BaseReferences<_$AppDatabase, $SessionDetailsTable, SessionDetail>,
      ),
      SessionDetail,
      PrefetchHooks Function()
    >;
typedef $$LocalDocumentsTableCreateCompanionBuilder =
    LocalDocumentsCompanion Function({
      required String id,
      required String userId,
      required String title,
      Value<int> wordCount,
      required String resultJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalDocumentsTableUpdateCompanionBuilder =
    LocalDocumentsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<int> wordCount,
      Value<String> resultJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDocumentsTable> {
  $$LocalDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDocumentsTable> {
  $$LocalDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDocumentsTable> {
  $$LocalDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<String> get resultJson => $composableBuilder(
    column: $table.resultJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDocumentsTable,
          LocalDocument,
          $$LocalDocumentsTableFilterComposer,
          $$LocalDocumentsTableOrderingComposer,
          $$LocalDocumentsTableAnnotationComposer,
          $$LocalDocumentsTableCreateCompanionBuilder,
          $$LocalDocumentsTableUpdateCompanionBuilder,
          (
            LocalDocument,
            BaseReferences<_$AppDatabase, $LocalDocumentsTable, LocalDocument>,
          ),
          LocalDocument,
          PrefetchHooks Function()
        > {
  $$LocalDocumentsTableTableManager(
    _$AppDatabase db,
    $LocalDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<String> resultJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDocumentsCompanion(
                id: id,
                userId: userId,
                title: title,
                wordCount: wordCount,
                resultJson: resultJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                Value<int> wordCount = const Value.absent(),
                required String resultJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalDocumentsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                wordCount: wordCount,
                resultJson: resultJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalDocumentsTable, LocalDocument>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalDocumentsTable,
                    LocalDocument
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDocumentsTable,
      LocalDocument,
      $$LocalDocumentsTableFilterComposer,
      $$LocalDocumentsTableOrderingComposer,
      $$LocalDocumentsTableAnnotationComposer,
      $$LocalDocumentsTableCreateCompanionBuilder,
      $$LocalDocumentsTableUpdateCompanionBuilder,
      (
        LocalDocument,
        BaseReferences<_$AppDatabase, $LocalDocumentsTable, LocalDocument>,
      ),
      LocalDocument,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PracticeRecordsTableTableManager get practiceRecords =>
      $$PracticeRecordsTableTableManager(_db, _db.practiceRecords);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$DeviceSettingsTableTableManager get deviceSettings =>
      $$DeviceSettingsTableTableManager(_db, _db.deviceSettings);
  $$SessionDetailsTableTableManager get sessionDetails =>
      $$SessionDetailsTableTableManager(_db, _db.sessionDetails);
  $$LocalDocumentsTableTableManager get localDocuments =>
      $$LocalDocumentsTableTableManager(_db, _db.localDocuments);
}
