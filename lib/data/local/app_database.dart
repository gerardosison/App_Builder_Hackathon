import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Synchronized practice summary. Detailed local-only analysis lives in
/// [SessionDetails].
@DataClassName('PracticeRecord')
class PracticeRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get practicePurpose => text()();
  IntColumn get durationSeconds =>
      integer().customConstraint('NOT NULL CHECK (duration_seconds >= 0)')();
  IntColumn get starsEarned =>
      integer().customConstraint('NOT NULL CHECK (stars_earned >= 0)')();
  TextColumn get baselineSessionId => text().nullable()();
  TextColumn get scoringVersion => text().withDefault(const Constant('v1'))();
  BoolColumn get needsUpload => boolean().withDefault(const Constant(true))();
  BoolColumn get isTest => boolean().withDefault(const Constant(false))();

  // Added in schema v5.
  TextColumn get language => text().withDefault(const Constant('en-US'))();
  TextColumn get topic => text().withDefault(const Constant(''))();
  RealColumn get overallScore => real().nullable()();
  RealColumn get wordsPerMinute => real().nullable()();
  IntColumn get fillerCount => integer().nullable()();
  IntColumn get pauseCount => integer().nullable()();
  RealColumn get postureScore => real().nullable()();
  RealColumn get bodySwayCm => real().nullable()();
  RealColumn get gestureScore => real().nullable()();
  BoolColumn get hasLocalDetails =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProfile')
class UserProfiles extends Table {
  TextColumn get userId => text()();
  TextColumn get fullName => text()();
  TextColumn get nickname => text()();
  TextColumn get language => text()();
  TextColumn get practicePurpose => text()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  TextColumn get revision => text()();
  BoolColumn get needsUpload => boolean().withDefault(const Constant(true))();

  // Added in schema v5.
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get school => text().withDefault(const Constant(''))();

  /// Device-local file path; never synchronized.
  TextColumn get photoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Local-only detailed analysis for a session recorded on this device.
@DataClassName('SessionDetail')
class SessionDetails extends Table {
  TextColumn get sessionId => text()();
  TextColumn get userId => text()();
  TextColumn get transcript => text().withDefault(const Constant(''))();
  TextColumn get reportJson => text()();
  TextColumn get audioPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

/// Local-only metadata and analysis results for imported documents.
@DataClassName('LocalDocument')
class LocalDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  TextColumn get resultJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DeviceSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    PracticeRecords,
    UserProfiles,
    DeviceSettings,
    SessionDetails,
    LocalDocuments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'hawkabuild',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(userProfiles);
      }
      if (from < 3) {
        await migrator.addColumn(practiceRecords, practiceRecords.isTest);
      }
      if (from < 4) {
        await migrator.createTable(deviceSettings);
      }
      if (from < 3 || from < 4) {
        await customStatement(
          'UPDATE practice_records SET is_test = 1 WHERE practice_purpose = ?',
          ['Database test'],
        );
      }
      if (from < 5) {
        for (final column in [
          practiceRecords.language,
          practiceRecords.topic,
          practiceRecords.overallScore,
          practiceRecords.wordsPerMinute,
          practiceRecords.fillerCount,
          practiceRecords.pauseCount,
          practiceRecords.postureScore,
          practiceRecords.bodySwayCm,
          practiceRecords.gestureScore,
          practiceRecords.hasLocalDetails,
        ]) {
          await migrator.addColumn(practiceRecords, column);
        }
        if (from >= 2) {
          for (final column in [
            userProfiles.username,
            userProfiles.email,
            userProfiles.school,
            userProfiles.photoPath,
          ]) {
            await migrator.addColumn(userProfiles, column);
          }
        }
        await migrator.createTable(sessionDetails);
        await migrator.createTable(localDocuments);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Stream<List<PracticeRecord>> watchRecords(String userId) {
    return (select(practiceRecords)
          ..where((row) => row.userId.equals(userId))
          ..orderBy([(row) => OrderingTerm.desc(row.completedAt)]))
        .watch();
  }

  Future<List<PracticeRecord>> pendingRecords(String userId) {
    return (select(practiceRecords)..where(
          (row) => row.userId.equals(userId) & row.needsUpload.equals(true),
        ))
        .get();
  }

  Stream<int> watchPendingCount(String userId) {
    final count = practiceRecords.id.count();
    final query = selectOnly(practiceRecords)
      ..addColumns([count])
      ..where(
        practiceRecords.userId.equals(userId) &
            practiceRecords.needsUpload.equals(true),
      );
    return query.map((row) => row.read(count) ?? 0).watchSingle();
  }

  Future<void> markUploaded(String userId, String id) async {
    await (update(practiceRecords)
          ..where((row) => row.userId.equals(userId) & row.id.equals(id)))
        .write(const PracticeRecordsCompanion(needsUpload: Value(false)));
  }

  /// Inserts a downloaded summary without touching an existing local row.
  Future<void> insertDownloaded(PracticeRecordsCompanion record) async {
    await into(practiceRecords).insert(record, mode: InsertMode.insertOrIgnore);
  }

  Future<String?> setting(String key) async {
    final row = await (select(
      deviceSettings,
    )..where((row) => row.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(deviceSettings).insertOnConflictUpdate(
      DeviceSettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<void> removeSetting(String key) async {
    await (delete(deviceSettings)..where((row) => row.key.equals(key))).go();
  }

  /// Removes every local row owned by [userId].
  Future<void> deleteAccountData(String userId) async {
    await transaction(() async {
      await (delete(
        sessionDetails,
      )..where((row) => row.userId.equals(userId))).go();
      await (delete(
        practiceRecords,
      )..where((row) => row.userId.equals(userId))).go();
      await (delete(
        localDocuments,
      )..where((row) => row.userId.equals(userId))).go();
      await (delete(
        userProfiles,
      )..where((row) => row.userId.equals(userId))).go();
    });
  }
}
