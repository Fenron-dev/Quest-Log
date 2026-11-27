import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/core/database/sample_data.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  testWidgets('create a customer and see it in the list', (tester) async {
    await pumpTestApp(tester, db);
    await tester.tap(navItem('Kunden'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Noch keine Kunden'), findsOneWidget);

    await tester.tap(find.byTooltip('Kunde anlegen'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name'),
      'Beispiel GmbH',
    );
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    // Lands on the detail page of the new customer.
    expect(find.text('Beispiel GmbH'), findsOneWidget);
    expect(find.text('Übersicht'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Beispiel GmbH'), findsOneWidget);

    await closeTestApp(tester, db);
  });

  testWidgets('sample data shows up in projects and customer detail', (
    tester,
  ) async {
    await tester.runAsync(() => insertSampleData(db));
    await pumpTestApp(tester, db);

    await tester.tap(navItem('Projekte'));
    await tester.pumpAndSettle();
    expect(find.text('Intern'), findsOneWidget);
    expect(find.text('Kundenprojekte'), findsOneWidget);
    expect(find.text('Serverumzug'), findsOneWidget);
    expect(find.text('2/4'), findsOneWidget);

    await tester.tap(find.text('Serverumzug'));
    await tester.pumpAndSettle();
    expect(find.text('Meilensteine'), findsOneWidget);
    expect(find.text('Daten migrieren'), findsOneWidget);

    await tester.tap(find.text('Daten migrieren'));
    await tester.pumpAndSettle();
    expect(find.text('3/4'), findsOneWidget);

    await tester.tap(navItem('Kunden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoriten'));
    await tester.pumpAndSettle();
    expect(find.text('Beispiel GmbH'), findsOneWidget);
    expect(find.text('Kanzlei Fiktiv & Partner'), findsNothing);

    await tester.tap(find.text('Beispiel GmbH'));
    await tester.pumpAndSettle();
    expect(find.text('Erika Musterfrau'), findsOneWidget);
    await tester.tap(find.text('Projekte').last);
    await tester.pumpAndSettle();
    expect(find.text('Serverumzug'), findsOneWidget);

    await closeTestApp(tester, db);
  });
}
