import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

const _serializer = ValueSerializer.defaults(
  serializeDateTimeValuesAsString: true,
);

/// Readable, unencrypted export of all active records, grouped by table.
/// App preferences are left out.
Future<Uint8List> exportJson(AppDatabase db, {DateTime? now}) async {
  final tables = <String, List<Map<String, dynamic>>>{};
  for (final t in db.allTables) {
    if (t.actualTableName == db.appSettings.actualTableName) continue;
    final rows = await db.select(t).get();
    tables[t.actualTableName] = [
      for (final r in rows)
        if ((r as DataClass).toJson(serializer: _serializer) case final json
            when json['deletedAt'] == null)
          json,
    ];
  }
  final out = {
    'format': 'quest-log-export',
    'exportedAt': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'tables': tables,
  };
  return Uint8List.fromList(
    utf8.encode(const JsonEncoder.withIndent('  ').convert(out)),
  );
}

String _two(int n) => n.toString().padLeft(2, '0');
String _date(DateTime t) => '${t.year}-${_two(t.month)}-${_two(t.day)}';
String _time(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

/// Quotes a CSV field when needed and defuses spreadsheet formulas.
String _field(String? v) {
  var s = v ?? '';
  if (s.isNotEmpty && '=+-@\t\r'.contains(s[0])) s = "'$s";
  if (s.contains(RegExp('[;"\n\r]'))) s = '"${s.replaceAll('"', '""')}"';
  return s;
}

/// Finished time entries as CSV (semicolon, UTF-8 with BOM) for
/// spreadsheets.
Future<Uint8List> exportTimeEntriesCsv(AppDatabase db) async {
  final e = db.timeEntries;
  final query =
      db.select(e).join([
          leftOuterJoin(db.customers, db.customers.id.equalsExp(e.customerId)),
          leftOuterJoin(db.projects, db.projects.id.equalsExp(e.projectId)),
          leftOuterJoin(db.tasks, db.tasks.id.equalsExp(e.taskId)),
        ])
        ..where(e.deletedAt.isNull() & e.end.isNotNull())
        ..orderBy([OrderingTerm(expression: e.start)]);
  final rows = await query.get();
  final lines = <String>[
    'Datum;Start;Ende;Minuten;Kunde;Projekt;Aufgabe;Art;Kategorie;'
        'Abrechenbar;Notiz',
  ];
  for (final row in rows) {
    final entry = row.readTable(e);
    final end = entry.end!;
    lines.add(
      [
        _date(entry.start),
        _time(entry.start),
        _time(end),
        '${end.difference(entry.start).inMinutes}',
        _field(row.readTableOrNull(db.customers)?.name),
        _field(row.readTableOrNull(db.projects)?.name),
        _field(row.readTableOrNull(db.tasks)?.title),
        entry.kind == TimeEntryKind.background ? 'nebenher' : 'aktiv',
        _field(entry.category),
        entry.billable ? 'ja' : 'nein',
        _field(entry.note),
      ].join(';'),
    );
  }
  return Uint8List.fromList([
    0xEF, 0xBB, 0xBF, // BOM so spreadsheet apps detect UTF-8.
    ...utf8.encode('${lines.join('\r\n')}\r\n'),
  ]);
}
