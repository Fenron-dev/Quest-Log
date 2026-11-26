import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/sample_data.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  Future<void> addViaDialog(
    WidgetTester tester,
    String tooltip,
    String text,
  ) async {
    await tester.tap(find.byTooltip(tooltip));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settleAsync(tester);
  }

  testWidgets('adding milestones, tasks and criteria in a project', (
    tester,
  ) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);
    await tester.tap(navItem('Projekte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eigenes Netzwerk-Monitoring'));
    await settleAsync(tester);

    await addViaDialog(tester, 'Meilenstein hinzufügen', 'Switches erfassen');
    expect(tester.takeException(), isNull);
    expect(find.text('Switches erfassen'), findsOneWidget);

    await addViaDialog(tester, 'Aufgabe erfassen', 'Zabbix testen');
    expect(tester.takeException(), isNull);
    expect(find.text('Zabbix testen'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byTooltip('Kriterium hinzufügen'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await addViaDialog(tester, 'Kriterium hinzufügen', 'Alarme kommen an');
    expect(tester.takeException(), isNull);
    expect(find.text('Alarme kommen an'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('adding a required checklist step to a task', (tester) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);
    await tester.longPress(find.text('Lizenzen verlängern'));
    await settleAsync(tester);

    await tester.tap(find.byTooltip('Schritt hinzufügen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Angebot einholen');
    await tester.tap(find.text('Pflichtschritt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hinzufügen'));
    await settleAsync(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Angebot einholen'), findsOneWidget);
    expect(find.text('Pflicht'), findsOneWidget);

    await closeTestApp(tester, db);
  });
}
