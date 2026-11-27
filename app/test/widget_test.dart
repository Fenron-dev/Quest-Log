import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/app.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/database_provider.dart';

import 'helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());
  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const QuestLogApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder navItem(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  testWidgets('navigates between tabs and opens settings', (tester) async {
    await pumpApp(tester);
    expect(find.widgetWithText(AppBar, 'Jetzt'), findsOneWidget);

    for (final label in ['Mein Tag', 'Projekte', 'Kunden']) {
      await tester.tap(navItem(label));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, label), findsOneWidget);
    }

    await tester.tap(navItem('Jetzt'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Einstellungen'), findsOneWidget);
  });

  testWidgets('selecting dark theme in settings applies and stores it', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Einstellungen'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dunkel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grün'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ListView));
    expect(Theme.of(context).brightness, Brightness.dark);
    await tester.runAsync(() async {
      expect(await db.readSetting('theme'), 'dark');
      expect(await db.readSetting('accent'), 'green');
    });
  });
}
