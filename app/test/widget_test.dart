import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/app.dart';

void main() {
  testWidgets('navigates between tabs and opens settings', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: QuestLogApp()));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Jetzt'), findsOneWidget);

    for (final label in ['Mein Tag', 'Projekte', 'Kunden']) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, label), findsOneWidget);
    }

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Jetzt'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Einstellungen'), findsOneWidget);
  });
}
