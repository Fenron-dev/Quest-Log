import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/sample_data.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  Future<List<TimeEntry>> entries() => db.select(db.timeEntries).get();

  Future<void> planToday(List<String> titles) async {
    final now = DateTime.now();
    for (final t in titles) {
      await db
          .into(db.tasks)
          .insert(
            TasksCompanion.insert(
              title: t,
              status: const Value(TaskStatus.planned),
              plannedDay: Value(DateTime(now.year, now.month, now.day)),
            ),
          );
    }
  }

  testWidgets('quick start runs a timer that can be paused', (tester) async {
    await pumpTestApp(tester, db);
    expect(find.text('Nichts läuft'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Telefon'));
    await settleAsync(tester);
    expect(find.text('1 laufen'), findsOneWidget);
    expect((await tester.runAsync(entries))!.single.end, isNull);

    await tester.tap(find.byTooltip('Timer pausieren'));
    await settleAsync(tester);
    expect(find.text('Nichts läuft'), findsOneWidget);
    expect((await tester.runAsync(entries))!.single.end, isNotNull);
    // Paused task stays on Jetzt to be resumed.
    expect(find.textContaining('Pausiert'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('several timers run in parallel without limit', (tester) async {
    await tester.runAsync(() => planToday(['Angebot', 'Sicherungen', 'Doku']));
    await pumpTestApp(tester, db);
    expect(find.text('Antippen zum Starten'), findsNWidgets(3));

    for (final title in ['Angebot', 'Sicherungen', 'Doku']) {
      await tester.tap(find.text(title));
      await settleAsync(tester);
    }
    expect(find.text('3 laufen'), findsOneWidget);
    expect(find.text('Fertig'), findsNWidgets(3));

    await closeTestApp(tester, db);
  });

  testWidgets('quick start asks whether to pause, then offers resume', (
    tester,
  ) async {
    await tester.runAsync(() => planToday(['Angebot']));
    await pumpTestApp(tester, db);
    await tester.tap(find.text('Angebot'));
    await settleAsync(tester);
    expect(find.text('1 laufen'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Fernwartung'));
    await settleAsync(tester);
    expect(find.text('Andere Timer pausieren?'), findsOneWidget);
    await tester.tap(find.text('Pausieren'));
    await settleAsync(tester);
    expect(find.text('1 laufen'), findsOneWidget);

    await tester.tap(find.byTooltip('Timer pausieren'));
    await settleAsync(tester);
    expect(find.text('Pausierten Timer fortsetzen?'), findsOneWidget);
    await tester.tap(find.text('Fortsetzen'));
    await settleAsync(tester);
    expect(find.text('1 laufen'), findsOneWidget);
    expect(find.textContaining('Pausiert'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('quick start can keep others running', (tester) async {
    await tester.runAsync(() => planToday(['Angebot']));
    await pumpTestApp(tester, db);
    await tester.tap(find.text('Angebot'));
    await settleAsync(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Telefon'));
    await settleAsync(tester);
    await tester.tap(find.text('Weiterlaufen lassen'));
    await settleAsync(tester);
    expect(find.text('2 laufen'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('Fertig completes a running task', (tester) async {
    await tester.runAsync(() => planToday(['Angebot']));
    await pumpTestApp(tester, db);
    await tester.tap(find.text('Angebot'));
    await settleAsync(tester);
    await tester.tap(find.text('Fertig'));
    await settleAsync(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Abschließen'));
    await settleAsync(tester);
    expect(find.text('Nichts läuft'), findsOneWidget);
    expect(find.text('Angebot'), findsNothing);

    await closeTestApp(tester, db);
  });

  testWidgets('start screen: customer, template, start', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Mehr'));
    await settleAsync(tester);
    await tester.tap(find.text('Muster AG'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passwort zurücksetzen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passwort zurücksetzen · Muster AG starten'));
    await settleAsync(tester);

    expect(find.text('Passwort zurücksetzen – Muster AG'), findsOneWidget);
    expect(find.text('1 laufen'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('new task from Jetzt is planned for today', (tester) async {
    await pumpTestApp(tester, db);
    await tester.tap(find.text('Neue Aufgabe'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Kabel bestellen');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settleAsync(tester);
    expect(find.text('Kabel bestellen'), findsOneWidget);
    expect(find.text('Antippen zum Starten'), findsOneWidget);
    await closeTestApp(tester, db);
  });
}
