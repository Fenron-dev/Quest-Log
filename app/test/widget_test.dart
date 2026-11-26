import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';

import 'helpers/test_app.dart';
import 'helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  testWidgets('navigates between tabs and opens settings', (tester) async {
    await pumpTestApp(tester, db);
    expect(find.text('Nichts läuft'), findsOneWidget);

    await tester.tap(find.text('Mein Tag'));
    await settleAsync(tester);
    expect(find.text('Heute'), findsOneWidget);
    await tester.tap(find.text('Jetzt').first);
    await settleAsync(tester);

    for (final label in ['Aufgaben', 'Projekte', 'Kunden']) {
      await tester.tap(navItem(label));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, label), findsOneWidget);
    }

    await tester.tap(navItem('Jetzt'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Einstellungen'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('selecting dark theme in settings applies and stores it', (
    tester,
  ) async {
    await pumpTestApp(tester, db);
    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dunkel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grün'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ListView));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(await db.readSetting('theme'), 'dark');
    expect(await db.readSetting('accent'), 'green');

    await closeTestApp(tester, db);
  });
}
