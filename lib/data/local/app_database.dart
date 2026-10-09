import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

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

  @override
  Set<Column> get primaryKey => {userId};
}

class DeviceSettings extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [PracticeRecords, UserProfiles, DeviceSettings])
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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(userProfiles);
      }

      if (from < 3) {
        await migrator.addColumn(practiceRecords, practiceRecords.isTest);

        await customStatement(
          'UPDATE practice_records SET is_test = 1 '
          'WHERE practice_purpose = ?',
          ['Database test'],
        );
      }

      if (from < 4) {
        await migrator.createTable(deviceSettings);

        await customStatement(
          'UPDATE practice_records SET is_test = 1 '
          'WHERE practice_purpose = ?',
          ['Database test'],
        );
      }
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

  Future<void> markUploaded(String userId, String id) async {
    await (update(practiceRecords)
          ..where((row) => row.userId.equals(userId) & row.id.equals(id)))
        .write(const PracticeRecordsCompanion(needsUpload: Value(false)));
  }

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
}
