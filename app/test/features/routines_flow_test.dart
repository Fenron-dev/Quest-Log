import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/tasks/data/tasks_repository.dart';
import 'package:quest_log/features/tasks/task_actions.dart';

import '../helpers/test_app.dart';
import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  // Real time: repositories stamp changes with the wall clock.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  setUp(() => db = createTestDatabase());

  Future<String> task(
    String title, {
    TaskStatus status = TaskStatus.planned,
    DateTime? planned,
    String? tags,
    String? customerId,
  }) async =>
      (await db
              .into(db.tasks)
              .insertReturning(
                TasksCompanion.insert(
                  title: title,
                  status: Value(status),
                  plannedDay: Value(planned),
                  tags: Value(tags),
                  customerId: Value(customerId),
                ),
              ))
          .id;

  Future<Task> read(String id) async =>
      (await (db.select(db.tasks)..where((t) => t.id.equals(id))).getSingle());

  Future<void> openRoutine(WidgetTester tester, String chip) async {
    await pumpTestApp(tester, db, now: now);
    await tester.tap(find.text('Mein Tag'));
    await settleAsync(tester);
    await tester.tap(find.widgetWithText(ActionChip, chip));
    await settleAsync(tester);
    expect(find.widgetWithText(AppBar, chip), findsOneWidget);
  }

  testWidgets('morning planning sorts the inbox and takes over', (
    tester,
  ) async {
    final ids = (await tester.runAsync(() async {
      return [
        await task('Rückruf notiert', status: TaskStatus.inbox),
        await task('Gestern offen', planned: yesterday),
        await task('Auch gestern', planned: yesterday),
      ];
    }))!;
    await openRoutine(tester, 'Morgenplanung');

    expect(find.text('Eingang (1)'), findsOneWidget);
    expect(find.text('Liegengeblieben (2)'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Heute').first);
    await settleAsync(tester);
    expect(find.text('Eingang ist leer.'), findsOneWidget);

    await tester.tap(find.text('Alle übernehmen'));
    await settleAsync(tester);
    expect(find.text('Nichts liegengeblieben.'), findsOneWidget);
    expect(find.text('Reihenfolge heute (3)'), findsOneWidget);

    final tasks = (await tester.runAsync(() => Future.wait(ids.map(read))))!;
    expect(tasks.map((t) => t.plannedDay), everyElement(today));
    expect(tasks.first.status, TaskStatus.planned);

    await tester.scrollUntilVisible(
      find.text('Tag starten'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Tag starten'));
    await settleAsync(tester);
    final clocks = await tester.runAsync(() => db.select(db.workClocks).get());
    expect(clocks, hasLength(1));

    await closeTestApp(tester, db);
  });

  testWidgets('day close moves what is left and ends the day', (tester) async {
    final ids = (await tester.runAsync(() async {
      await db
          .into(db.workClocks)
          .insert(
            WorkClocksCompanion.insert(
              day: today,
              start: now.subtract(const Duration(minutes: 30)),
            ),
          );
      final done = await task('Schon fertig', planned: today);
      await TasksRepository(db).setDone(done, true);
      return [
        await task('Noch offen', planned: today),
        await task('Auch offen', planned: today),
      ];
    }))!;
    await openRoutine(tester, 'Tagesabschluss');

    expect(find.text('Erledigt heute (1)'), findsOneWidget);
    expect(find.text('Offen von heute (2)'), findsOneWidget);
    await tester.tap(find.text('Alle auf morgen'));
    await settleAsync(tester);
    expect(find.text('Alles für heute erledigt.'), findsOneWidget);
    final moved = (await tester.runAsync(() => Future.wait(ids.map(read))))!;
    expect(moved.map((t) => t.plannedDay), everyElement(tomorrow));

    await tester.scrollUntilVisible(
      find.text('Feierabend'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Feierabend'));
    await settleAsync(tester);
    final clock = await tester.runAsync(
      () => db.select(db.workClocks).getSingle(),
    );
    expect(clock!.end, isNotNull);

    await closeTestApp(tester, db);
  });

  testWidgets('week close settles a time review as internal', (tester) async {
    final id = (await tester.runAsync(() async {
      final k = await db
          .into(db.customers)
          .insertReturning(
            CustomersCompanion.insert(
              name: 'Beispiel GmbH',
              contingentAePerMonth: const Value(20),
            ),
          );
      final t = await task(
        'Drucker einrichten',
        status: TaskStatus.done,
        tags: encodeTags([reviewTimeTag]),
        customerId: k.id,
      );
      await db
          .into(db.timeEntries)
          .insert(
            TimeEntriesCompanion.insert(
              start: today.add(const Duration(hours: 9)),
              end: Value(today.add(const Duration(hours: 10))),
              taskId: Value(t),
              customerId: Value(k.id),
            ),
          );
      return t;
    }))!;
    await openRoutine(tester, 'Wochenabschluss');

    expect(find.text('Zeit prüfen (1)'), findsOneWidget);
    expect(find.textContaining('von 20 AE diesen Monat'), findsOneWidget);

    await tester.tap(find.text('Entscheiden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Intern verbuchen'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Grund'),
      'Einarbeitung neues Modell',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Übernehmen'));
    await settleAsync(tester);
    expect(find.text('Keine Aufgaben über der Sollzeit.'), findsOneWidget);

    final result = (await tester.runAsync(() async {
      final t = await read(id);
      final entries = await db.select(db.timeEntries).get();
      final notes = await db.select(db.notes).get();
      return (t.tags, entries.single.billable, notes.single.body);
    }))!;
    expect(decodeTags(result.$1), isEmpty);
    expect(result.$2, isFalse);
    expect(
      result.$3,
      'Zeit geprüft: Intern verbuchen – Einarbeitung neues Modell',
    );

    await closeTestApp(tester, db);
  });
}
