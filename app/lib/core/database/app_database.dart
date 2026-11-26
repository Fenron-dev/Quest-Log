import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/enums.dart';
import 'tables/sync_columns.dart';
import 'tables/tables.dart';

export 'tables/enums.dart';
export 'tables/sync_columns.dart' show newUuid;

part 'app_database.g.dart';

/// Simple key/value store for local app preferences.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AppSettings,
    Workspaces,
    Customers,
    Contacts,
    Projects,
    Milestones,
    Criteria,
    Goals,
    Habits,
    Templates,
    Tasks,
    ChecklistItems,
    TimeEntries,
    TimeEntryColleagues,
    WorkClocks,
    Notes,
    Materials,
    CheckRounds,
    CheckRoundResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'quest_log'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Selects all rows of [table] that are not soft-deleted.
  SimpleSelectStatement<T, D> selectActive<T extends SyncColumns, D>(
    TableInfo<T, D> table,
  ) => select(table)..where((t) => t.deletedAt.isNull());

  /// Marks the row with [id] as deleted without removing it, so the deletion
  /// can be synchronised later. Returns the number of affected rows.
  Future<int> softDelete<T extends SyncColumns, D>(
    TableInfo<T, D> table,
    String id,
  ) {
    final now = DateTime.now();
    return (update(
      table,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).write(
      RawValuesInsertable<D>({
        'deleted_at': Variable<DateTime>(now),
        'updated_at': Variable<DateTime>(now),
      }),
    );
  }

  Future<String?> readSetting(String key) async {
    final row = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> writeSetting(String key, String value) => into(
    appSettings,
  ).insertOnConflictUpdate(AppSettingsCompanion.insert(key: key, value: value));
}
