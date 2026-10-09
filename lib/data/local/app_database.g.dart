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
          ..write('isTest: $isTest')
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
          other.isTest == this.isTest);
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
  const LocalProfile({
    required this.userId,
    required this.fullName,
    required this.nickname,
    required this.language,
    required this.practicePurpose,
    required this.onboardingComplete,
    required this.revision,
    required this.needsUpload,
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
  }) => LocalProfile(
    userId: userId ?? this.userId,
    fullName: fullName ?? this.fullName,
    nickname: nickname ?? this.nickname,
    language: language ?? this.language,
    practicePurpose: practicePurpose ?? this.practicePurpose,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    revision: revision ?? this.revision,
    needsUpload: needsUpload ?? this.needsUpload,
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
          ..write('needsUpload: $needsUpload')
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
          other.needsUpload == this.needsUpload);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PracticeRecordsTable practiceRecords = $PracticeRecordsTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $DeviceSettingsTable deviceSettings = $DeviceSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    practiceRecords,
    userProfiles,
    deviceSettings,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PracticeRecordsTableTableManager get practiceRecords =>
      $$PracticeRecordsTableTableManager(_db, _db.practiceRecords);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$DeviceSettingsTableTableManager get deviceSettings =>
      $$DeviceSettingsTableTableManager(_db, _db.deviceSettings);
}
