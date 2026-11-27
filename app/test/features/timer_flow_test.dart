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

  testWidgets('quick start runs a timer that can be paused', (tester) async {
    await pumpTestApp(tester, db);
    expect(find.textContaining('Kein Timer läuft'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Telefon'));
    await settleAsync(tester);
    expect(find.text('Läuft'), findsOneWidget);
    expect(find.textContaining('1 Timer läuft'), findsOneWidget);
    expect((await tester.runAsync(entries))!.single.end, isNull);

    await tester.tap(find.byTooltip('Timer pausieren').first);
    await settleAsync(tester);
    expect(find.text('Läuft'), findsNothing);
    expect((await tester.runAsync(entries))!.single.end, isNotNull);

    await closeTestApp(tester, db);
  });

  testWidgets('start screen: customer, template, start', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Mehr'));
    await settleAsync(tester);
    expect(find.text('1. Kunde'), findsOneWidget);

    await tester.tap(find.text('Muster AG'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passwort zurücksetzen'));
    await tester.pumpAndSettle();
    expect(
      find.text('Passwort zurücksetzen · Muster AG starten'),
      findsOneWidget,
    );

    await tester.tap(find.text('Passwort zurücksetzen · Muster AG starten'));
    await settleAsync(tester);

    // Back on Jetzt with the new timer running; the in-progress sample
    // task was not running, so nothing else is listed.
    expect(find.text('Läuft'), findsOneWidget);
    expect(find.text('Passwort zurücksetzen – Muster AG'), findsWidgets);

    await closeTestApp(tester, db);
  });

  testWidgets('starting from the task list and pausing others', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);

    await tester.tap(find.byTooltip('Timer starten').first);
    await settleAsync(tester);
    expect(find.textContaining('1 Timer läuft'), findsOneWidget);

    // Interruption by phone pauses the running timer...
    await tester.tap(find.widgetWithText(OutlinedButton, 'Telefon'));
    await settleAsync(tester);
    expect(find.textContaining('1 Timer läuft'), findsOneWidget);

    // ...and pausing the call offers to resume it.
    final pause = find.descendant(
      of: find.byType(Card),
      matching: find.byTooltip('Timer pausieren'),
    );
    await tester.tap(pause.first);
    await settleAsync(tester);
    expect(find.text('Pausierten Timer fortsetzen?'), findsOneWidget);
    await tester.tap(find.text('Fortsetzen'));
    await settleAsync(tester);
    expect(find.textContaining('1 Timer läuft'), findsOneWidget);

    await closeTestApp(tester, db);
  });
}
