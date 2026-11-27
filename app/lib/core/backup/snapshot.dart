import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Identifies a database snapshot inside a backup.
const snapshotFormat = 'quest-log-snapshot';

/// Thrown when a backup cannot be read or does not fit this app.
class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// What a snapshot contains, for the confirmation before restoring.
class SnapshotInfo {
  const SnapshotInfo({required this.createdAt, required this.rowCounts});

  final DateTime? createdAt;
  final Map<String, int> rowCounts;

  int count(String table) => rowCounts[table] ?? 0;
}

/// Dumps every table with its raw SQL values (exact, schema-faithful).
Future<Map<String, Object?>> dumpDatabase(
  AppDatabase db, {
  DateTime? now,
}) async {
  final tables = <String, List<Map<String, Object?>>>{};
  for (final t in db.allTables) {
    final rows = await db
        .customSelect('SELECT * FROM "${t.actualTableName}"')
        .get();
    tables[t.actualTableName] = [for (final r in rows) r.data];
  }
  return {
    'format': snapshotFormat,
    'schemaVersion': db.schemaVersion,
    'createdAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'tables': tables,
  };
}

/// Checks [json] and summarises it without touching the database.
SnapshotInfo inspectSnapshot(AppDatabase db, Object? json) {
  final tables = _validate(db, json);
  final created = DateTime.tryParse(
    (json! as Map)['createdAt'] as String? ?? '',
  )?.toLocal();
  return SnapshotInfo(
    createdAt: created,
    rowCounts: {for (final e in tables.entries) e.key: e.value.length},
  );
}

/// Replaces all data with the snapshot in one transaction. Either every
/// row is restored or nothing changes.
Future<void> restoreDatabase(AppDatabase db, Object? json) async {
  final tables = _validate(db, json);
  final known = {for (final t in db.allTables) t.actualTableName: t};
  await db.transaction(() async {
    // Rows reference each other; check foreign keys only at commit.
    await db.customStatement('PRAGMA defer_foreign_keys = ON');
    for (final t in known.values) {
      await db.customUpdate(
        'DELETE FROM "${t.actualTableName}"',
        updates: {t},
        updateKind: UpdateKind.delete,
      );
    }
    for (final MapEntry(key: name, value: rows) in tables.entries) {
      final table = known[name]!;
      for (final row in rows) {
        if (row.isEmpty) continue;
        final cols = row.keys.toList();
        await db.customInsert(
          'INSERT INTO "$name" (${cols.map((c) => '"$c"').join(', ')}) '
          'VALUES (${List.filled(cols.length, '?').join(', ')})',
          variables: [for (final c in cols) Variable(row[c])],
          updates: {table},
        );
      }
    }
  });
}

/// Validates structure, table and column names (they end up in SQL) and
/// value types. Returns the rows per table.
Map<String, List<Map<String, Object?>>> _validate(
  AppDatabase db,
  Object? json,
) {
  if (json is! Map || json['format'] != snapshotFormat) {
    throw const BackupException('Keine Quest-Log-Sicherung.');
  }
  final version = json['schemaVersion'];
  if (version is! int || version > db.schemaVersion) {
    throw const BackupException(
      'Die Sicherung stammt aus einer neueren App-Version. Bitte zuerst die '
      'App aktualisieren.',
    );
  }
  final tables = json['tables'];
  if (tables is! Map) {
    throw const BackupException('Die Sicherung ist unvollständig.');
  }
  final columns = {
    for (final t in db.allTables)
      t.actualTableName: {for (final c in t.$columns) c.name},
  };
  final out = <String, List<Map<String, Object?>>>{};
  for (final MapEntry(:key, :value) in tables.entries) {
    final allowed = columns[key];
    if (key is! String || allowed == null || value is! List) {
      throw BackupException('Unbekannte Tabelle in der Sicherung: $key');
    }
    final rows = <Map<String, Object?>>[];
    for (final row in value) {
      if (row is! Map) {
        throw const BackupException('Die Sicherung ist beschädigt.');
      }
      final clean = <String, Object?>{};
      for (final MapEntry(key: col, value: v) in row.entries) {
        if (col is! String || !allowed.contains(col)) {
          throw BackupException('Unbekannte Spalte in der Sicherung: $col');
        }
        if (v != null && v is! String && v is! num) {
          throw const BackupException('Die Sicherung ist beschädigt.');
        }
        clean[col] = v;
      }
      rows.add(clean);
    }
    out[key] = rows;
  }
  return out;
}
