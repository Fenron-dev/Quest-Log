import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/sample_data.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  testWidgets('quick capture puts a task into the inbox', (tester) async {
    await pumpTestApp(tester, db);
    await tester.tap(navItem('Aufgaben'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nichts offen'), findsOneWidget);

    await tester.tap(find.text('Erfassen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Router neu starten');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Router neu starten'), findsOneWidget);
    expect(find.textContaining('Eingang'), findsWidgets);

    await tester.tap(find.text('Router neu starten'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Abschließen'));
    await settleAsync(tester);
    expect(find.text('Erfasst: 0:00 h · 0 AE'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Abschließen'));
    await settleAsync(tester);
    expect(find.text('Router neu starten'), findsNothing);

    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Erledigt'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Erledigt'));
    await tester.pumpAndSettle();
    expect(find.text('Router neu starten'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('checklist, required steps and template start', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);
    await tester.tap(navItem('Aufgaben'));
    await settleAsync(tester);

    // Expand the checklist of a task and tick a step inline.
    await tester.tap(find.text('Drucker im Empfang prüfen'));
    await tester.pumpAndSettle();
    expect(find.text('Testseite drucken (Pflicht)'), findsOneWidget);
    await tester.tap(find.text('Treiber prüfen'));
    await tester.pumpAndSettle();
    expect(find.textContaining('2/3 Schritte'), findsOneWidget);

    // Completing with an open required step asks first.
    await tester.tap(find.widgetWithText(TextButton, 'Abschließen'));
    await settleAsync(tester);
    expect(find.text('Pflichtschritte offen'), findsOneWidget);
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();
    expect(find.text('Drucker im Empfang prüfen'), findsOneWidget);

    // Waiting task with follow-up today is highlighted.
    expect(find.textContaining('Nachfassen bei Großhändler'), findsOneWidget);

    // Start a task from a favourite template for a customer.
    await tester.tap(find.text('Erfassen'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ActionChip, 'Neuer Arbeitsplatz'));
    await settleAsync(tester);
    await tester.tap(find.widgetWithText(SimpleDialogOption, 'Muster AG'));
    await settleAsync(tester);

    expect(find.text('Neuer Arbeitsplatz – Muster AG'), findsOneWidget);
    expect(find.text('Benutzerkonto anlegen'), findsOneWidget);
    expect(find.text('Pflicht'), findsNWidgets(3));

    await closeTestApp(tester, db);
  });

  testWidgets('tiles view is remembered', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);
    await tester.tap(navItem('Aufgaben'));
    await settleAsync(tester);
    await tester.tap(find.byTooltip('Als Kacheln anzeigen'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(await db.readSetting('nowView'), 'tiles');
    await closeTestApp(tester, db);
  });
}
