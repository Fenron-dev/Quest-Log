import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/backup/backup_crypto.dart';
import 'package:quest_log/core/backup/export.dart';
import 'package:quest_log/core/backup/snapshot.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/sample_data.dart';

import '../../helpers/test_database.dart';

/// Fast parameters for tests; real backups use [KdfParams.standard].
const fastKdf = KdfParams(memoryKib: 64, iterations: 1, parallelism: 1);

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  Future<Map<String, int>> counts(AppDatabase d) async => {
    for (final t in d.allTables)
      t.actualTableName:
          (await d
                  .customSelect(
                    'SELECT COUNT(*) AS n FROM "${t.actualTableName}"',
                  )
                  .getSingle())
              .read<int>('n'),
  };

  group('snapshot', () {
    test('dump and restore reproduce every row exactly', () async {
      await insertSampleData(db);
      await db.writeSetting('theme', 'dark');
      final before = await dumpDatabase(db);

      final other = createTestDatabase();
      addTearDown(other.close);
      await other
          .into(other.customers)
          .insert(CustomersCompanion.insert(name: 'Wird ersetzt'));
      // Through JSON, like a real file.
      await restoreDatabase(other, jsonDecode(jsonEncode(before)));

      final after = await dumpDatabase(other);
      expect(after['tables'], before['tables']);
      expect(await other.readSetting('theme'), 'dark');
      expect(
        (await other.select(other.customers).get()).map((c) => c.name),
        isNot(contains('Wird ersetzt')),
      );
    });

    test('inspect summarises without changing data', () async {
      await insertSampleData(db);
      final snap = await dumpDatabase(db, now: DateTime.utc(2026, 3, 2, 8));
      final info = inspectSnapshot(db, snap);
      expect(info.count('customers'), (await counts(db))['customers']);
      expect(info.createdAt, DateTime.utc(2026, 3, 2, 8).toLocal());
    });

    test('rejects foreign files, unknown tables and columns', () async {
      expect(
        () => restoreDatabase(db, {'format': 'x'}),
        throwsA(isA<BackupException>()),
      );
      Map<String, Object?> snap(Map<String, Object?> tables) => {
        'format': snapshotFormat,
        'schemaVersion': 1,
        'tables': tables,
      };
      expect(
        () => restoreDatabase(
          db,
          snap({
            'customers; DROP TABLE tasks': [<String, Object?>{}],
          }),
        ),
        throwsA(isA<BackupException>()),
      );
      expect(
        () => restoreDatabase(
          db,
          snap({
            'customers': [
              {'id': 'a', 'name) VALUES (1); --': 'x'},
            ],
          }),
        ),
        throwsA(isA<BackupException>()),
      );
      expect(
        () => restoreDatabase(db, {
          'format': snapshotFormat,
          'schemaVersion': 99,
          'tables': <String, Object?>{},
        }),
        throwsA(isA<BackupException>()),
      );
    });

    test('a failing restore leaves the data untouched', () async {
      await insertSampleData(db);
      final before = await counts(db);
      final snap = await dumpDatabase(db);
      // A time entry pointing at a task that does not exist.
      final tables = snap['tables']! as Map<String, List<Map<String, Object?>>>;
      tables['tasks'] = [];
      await expectLater(restoreDatabase(db, snap), throwsA(anything));
      expect(await counts(db), before);
    });
  });

  group('encrypted backup', () {
    test('round trip with the right password', () async {
      await insertSampleData(db);
      final snap = await dumpDatabase(db);
      final file = await encryptBackup(snap, 'geheim-123', kdf: fastKdf);

      // No readable content in the file.
      final text = utf8.decode(file);
      expect(text, isNot(contains('Beispiel GmbH')));
      expect(jsonDecode(text)['kdf']['name'], 'argon2id');

      final back = await decryptBackup(file, 'geheim-123');
      expect(jsonEncode(back), jsonEncode(snap));
    });

    test('wrong password and tampering are detected', () async {
      final file = await encryptBackup(
        await dumpDatabase(db),
        'geheim-123',
        kdf: fastKdf,
      );
      await expectLater(
        decryptBackup(file, 'falsch-456'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.message,
            'message',
            contains('Falsches Passwort'),
          ),
        ),
      );

      final env = jsonDecode(utf8.decode(file)) as Map<String, dynamic>;
      final data = base64Decode(env['data'] as String);
      data[0] ^= 1;
      env['data'] = base64Encode(data);
      await expectLater(
        decryptBackup(utf8.encode(jsonEncode(env)), 'geheim-123'),
        throwsA(isA<BackupException>()),
      );
      await expectLater(
        decryptBackup(utf8.encode('kein json'), 'geheim-123'),
        throwsA(isA<BackupException>()),
      );
    });

    test('refuses short passwords and absurd parameters', () async {
      await expectLater(
        encryptBackup(await dumpDatabase(db), 'kurz', kdf: fastKdf),
        throwsA(isA<BackupException>()),
      );
      final file = await encryptBackup(
        await dumpDatabase(db),
        'geheim-123',
        kdf: fastKdf,
      );
      final env = jsonDecode(utf8.decode(file)) as Map<String, dynamic>;
      (env['kdf'] as Map<String, dynamic>)['memoryKib'] = 1 << 30;
      await expectLater(
        decryptBackup(utf8.encode(jsonEncode(env)), 'geheim-123'),
        throwsA(isA<BackupException>()),
      );
    });
  });

  group('export', () {
    test('JSON is readable and skips deleted rows and settings', () async {
      await db.writeSetting('theme', 'dark');
      final a = await db
          .into(db.customers)
          .insertReturning(CustomersCompanion.insert(name: 'Beispiel GmbH'));
      final b = await db
          .into(db.customers)
          .insertReturning(CustomersCompanion.insert(name: 'Gelöscht AG'));
      await db.softDelete(db.customers, b.id);

      final json =
          jsonDecode(utf8.decode(await exportJson(db))) as Map<String, dynamic>;
      final tables = json['tables'] as Map<String, dynamic>;
      expect(tables.containsKey('app_settings'), isFalse);
      final customers = tables['customers'] as List<dynamic>;
      expect(customers.map((c) => c['name']), ['Beispiel GmbH']);
      expect(customers.single['id'], a.id);
      // Dates as ISO strings, not epoch numbers.
      expect(customers.single['createdAt'], isA<String>());
    });

    test('CSV lists finished entries with names, safely quoted', () async {
      final k = await db
          .into(db.customers)
          .insertReturning(CustomersCompanion.insert(name: 'Muster; AG'));
      final t = await db
          .into(db.tasks)
          .insertReturning(TasksCompanion.insert(title: '=Server "prüfen"'));
      await db
          .into(db.timeEntries)
          .insert(
            TimeEntriesCompanion.insert(
              start: DateTime(2026, 3, 2, 9),
              end: Value(DateTime(2026, 3, 2, 10, 30)),
              customerId: Value(k.id),
              taskId: Value(t.id),
              note: const Value('Lüfter getauscht'),
            ),
          );
      // Running entries are not exported.
      await db
          .into(db.timeEntries)
          .insert(TimeEntriesCompanion.insert(start: DateTime(2026, 3, 2, 11)));

      final bytes = await exportTimeEntriesCsv(db);
      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      final lines = utf8.decode(bytes.sublist(3)).trim().split('\r\n');
      expect(lines, hasLength(2));
      expect(lines.first, startsWith('Datum;Start;Ende;Minuten;Kunde'));
      expect(
        lines.last,
        '2026-03-02;09:00;10:30;90;"Muster; AG";;'
        '"\'=Server ""prüfen""";aktiv;;ja;Lüfter getauscht',
      );
    });
  });
}
