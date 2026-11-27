import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/tasks/data/tasks_repository.dart';
import 'package:quest_log/features/time/data/time_repository.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TasksRepository tasks;
  late TimeRepository time;
  // Wednesday.
  DateTime at(int day, [int h = 0, int m = 0]) => DateTime(2026, 3, day, h, m);
  final today = at(4);
  var now = at(4, 9);

  setUp(() {
    db = createTestDatabase();
    tasks = TasksRepository(db);
    now = at(4, 9);
    time = TimeRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  Future<String> task(
    String title, {
    TaskStatus status = TaskStatus.planned,
    DateTime? planned,
    DateTime? followUp,
    String? tags,
    String? projectId,
  }) async =>
      (await db
              .into(db.tasks)
              .insertReturning(
                TasksCompanion.insert(
                  title: title,
                  status: Value(status),
                  plannedDay: Value(planned),
                  followUpDate: Value(followUp),
                  waitingFor: Value(followUp == null ? null : 'Muster AG'),
                  tags: Value(tags),
                  projectId: Value(projectId),
                ),
              ))
          .id;

  Future<List<String>> titles(Stream<List<TaskView>> s) async =>
      (await s.first).map((v) => v.task.title).toList();

  test('morning lists: inbox, left over and follow-ups', () async {
    await task('Notiz', status: TaskStatus.inbox);
    await task('Gestern offen', planned: at(3));
    await task('Gestern erledigt', planned: at(3), status: TaskStatus.done);
    await task('Heute', planned: at(4));
    await task(
      'Nachfassen fällig',
      status: TaskStatus.waitingFor,
      followUp: at(4),
    );
    await task(
      'Nachfassen später',
      status: TaskStatus.waitingFor,
      followUp: at(6),
    );

    expect(await titles(tasks.watchInbox()), ['Notiz']);
    expect(await titles(tasks.watchOverdue(today)), ['Gestern offen']);
    expect(await titles(tasks.watchFollowUpsDue(today)), ['Nachfassen fällig']);
  });

  test('planning: take over, move, someday and order', () async {
    final a = await task('A', status: TaskStatus.inbox);
    final b = await task('B', planned: at(3));
    final c = await task('Termin', planned: at(3, 14, 30));

    await tasks.planFor(a, today);
    await tasks.planFor(b, today);
    await tasks.planFor(c, at(5));
    final ta = (await tasks.getTask(a))!;
    expect(ta.status, TaskStatus.planned);
    expect(ta.plannedDay, today);
    // Appointments keep their time on the new day.
    expect((await tasks.getTask(c))!.plannedDay, at(5, 14, 30));

    await tasks.setOrder([b, a]);
    expect(await titles(tasks.watchPlannedOn(today)), ['B', 'A']);
    await tasks.setOrder([a, b]);
    expect(await titles(tasks.watchPlannedOn(today)), ['A', 'B']);

    await tasks.moveToSomeday(a);
    final parked = (await tasks.getTask(a))!;
    expect(parked.status, TaskStatus.someday);
    expect(parked.plannedDay, isNull);
  });

  test('done today and tagged tasks; removing a tag', () async {
    final d = await task('Erledigt', planned: at(4));
    await tasks.setDone(d, true);
    final r = await task(
      'Prüfen',
      status: TaskStatus.done,
      tags: encodeTags(['Zeit prüfen', 'Server']),
    );
    await task('Anderes', tags: encodeTags(['Zeit prüfen 2']));

    final doneToday = await titles(tasks.watchDoneOn(DateTime.now()));
    expect(doneToday, contains('Erledigt'));
    expect(await titles(tasks.watchTagged('Zeit prüfen')), ['Prüfen']);

    await tasks.removeTag(r, 'Zeit prüfen');
    expect(await titles(tasks.watchTagged('Zeit prüfen')), isEmpty);
    expect(decodeTags((await tasks.getTask(r))!.tags), ['Server']);
  });

  test('overnight entries and project units for the week', () async {
    final p =
        (await db
                .into(db.projects)
                .insertReturning(ProjectsCompanion.insert(name: 'Serverumzug')))
            .id;
    final t = await task('Umzug', projectId: p);
    Future<void> entry(DateTime s, DateTime? e) => db
        .into(db.timeEntries)
        .insert(
          TimeEntriesCompanion.insert(
            start: s,
            end: Value(e),
            taskId: Value(t),
            projectId: Value(p),
          ),
        );
    await entry(at(2, 9), at(2, 9, 55)); // 55 min → 6 AE
    await entry(at(2, 23), at(3, 1)); // over midnight
    await entry(at(3, 17), null); // still running since yesterday

    final overnight = await time.watchOvernight(at(2), at(5)).first;
    expect(overnight.map((v) => v.entry.start), [at(2, 23), at(3, 17)]);

    // Stop the runaway timer, then compute units.
    await (db.update(db.timeEntries)..where((e) => e.end.isNull())).write(
      TimeEntriesCompanion(end: Value(at(3, 17, 30))),
    );
    final ae = await time.watchProjectAe(at(2), at(9)).first;
    // Buckets per task and start day: Mon 55 + 120 min → 18 AE,
    // Tue 30 min → 3 AE.
    expect(ae[p], 21);

    await time.setTaskBillable(t, false);
    final entries = await db.select(db.timeEntries).get();
    expect(entries.every((e) => !e.billable), isTrue);
  });
}
