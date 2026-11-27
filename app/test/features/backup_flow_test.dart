import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/backup/backup_crypto.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/backup/backup_files.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

class FakeBackupFiles implements BackupFiles {
  final saved = <String, Uint8List>{};
  Uint8List? toOpen;

  @override
  Future<bool> save(String fileName, Uint8List bytes, String mimeType) async {
    saved[fileName] = bytes;
    return true;
  }

  @override
  Future<Uint8List?> open() async => toOpen;
}

void main() {
  late AppDatabase db;
  late FakeBackupFiles files;

  setUp(() {
    db = createTestDatabase();
    files = FakeBackupFiles();
  });

  Future<void> pump(WidgetTester tester) => pumpTestApp(
    tester,
    db,
    overrides: [
      backupFilesProvider.overrideWithValue(files),
      backupKdfProvider.overrideWithValue(
        const KdfParams(memoryKib: 64, iterations: 1, parallelism: 1),
      ),
      backgroundRunnerProvider.overrideWithValue(<R>(task) async => task()),
    ],
  );

  Future<void> openData(WidgetTester tester, String item) async {
    await tester.tap(find.byTooltip('Einstellungen'));
    await settleAsync(tester);
    await tester.scrollUntilVisible(
      find.text(item),
      200,
      scrollable: find.descendant(
        of: find.byType(ListView).last,
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(item));
    await settleAsync(tester);
  }

  testWidgets('backup, change data, restore it back', (tester) async {
    await tester.runAsync(
      () => db
          .into(db.customers)
          .insert(CustomersCompanion.insert(name: 'Beispiel GmbH')),
    );
    await pump(tester);

    await openData(tester, 'Jetzt sichern');
    await tester.enterText(
      find.widgetWithText(TextField, 'Passwort'),
      'geheim-123',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Passwort wiederholen'),
      'geheim-12',
    );
    await tester.tap(find.text('Sichern'));
    await tester.pumpAndSettle();
    expect(find.text('Die Passwörter stimmen nicht überein.'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Passwort wiederholen'),
      'geheim-123',
    );
    await tester.tap(find.text('Sichern'));
    await settleAsync(tester);
    await settleAsync(tester);
    expect(find.text('Sicherung gespeichert.'), findsOneWidget);
    final name = files.saved.keys.single;
    expect(name, endsWith('.qlbackup'));

    // Data changes after the backup.
    await tester.runAsync(
      () => db
          .into(db.customers)
          .insert(CustomersCompanion.insert(name: 'Neu nach Sicherung')),
    );

    files.toOpen = files.saved[name];
    await tester.tap(find.text('Wiederherstellen'));
    await settleAsync(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Passwort'),
      'falsch-1',
    );
    await tester.tap(find.text('Öffnen'));
    await settleAsync(tester);
    await settleAsync(tester);
    expect(find.textContaining('Falsches Passwort'), findsOneWidget);

    await tester.tap(find.text('Wiederherstellen'));
    await settleAsync(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Passwort'),
      'geheim-123',
    );
    await tester.tap(find.text('Öffnen'));
    await settleAsync(tester);
    await settleAsync(tester);
    expect(find.textContaining('1 Kunden'), findsOneWidget);
    await tester.tap(find.text('Ersetzen'));
    await settleAsync(tester);
    await settleAsync(tester);
    expect(find.text('Sicherung wiederhergestellt.'), findsOneWidget);

    final names = await tester.runAsync(
      () async => (await db.select(db.customers).get()).map((c) => c.name),
    );
    expect(names, ['Beispiel GmbH']);

    await closeTestApp(tester, db);
  });

  testWidgets('exports warn first and save JSON and CSV', (tester) async {
    await pump(tester);
    await openData(tester, 'Export CSV');
    expect(find.text('Unverschlüsselt exportieren?'), findsOneWidget);
    await tester.tap(find.text('Exportieren'));
    await settleAsync(tester);
    await settleAsync(tester);
    await tester.tap(find.text('Export JSON'));
    await settleAsync(tester);
    await tester.tap(find.text('Exportieren'));
    await settleAsync(tester);
    await settleAsync(tester);
    expect(files.saved.keys, [
      allOf(startsWith('quest-log-zeiten-'), endsWith('.csv')),
      allOf(startsWith('quest-log-export-'), endsWith('.json')),
    ]);
    await closeTestApp(tester, db);
  });
}
