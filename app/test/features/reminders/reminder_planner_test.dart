import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/core/database/app_database.dart';
import 'package:quest_log/features/reminders/reminder_planner.dart';
import 'package:quest_log/features/reminders/reminder_settings.dart';
import 'package:quest_log/features/tasks/data/tasks_repository.dart';
import 'package:quest_log/features/time/data/time_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TasksRepository tasks;
  late TimeRepository time;
  // Monday.
  DateTime at(int day, int h, [int m = 0]) => DateTime(2026, 3, day, h, m);
  final now = at(2, 9);
  const onlyTasks = ReminderSettings(
    enabled: true,
    timerGuard: false,
    dayClose: false,
    weekClose: false,
    morningPlan: false,
  );

  setUp(() {
    db = createTestDatabase();
    tasks = TasksRepository(db);
    time = TimeRepository(db, clock: () => now);
  });
  tearDown(() => db.close());

  Future<List<PlannedReminder>> plan(ReminderSettings s) async => planReminders(
    now: now,
    settings: s,
    tasks: await tasks.watchReminderTasks().first,
    running: await time.watchRunning().first,
  );

  Future<String> task(
    String title, {
    DateTime? planned,
    TaskStatus status = TaskStatus.planned,
    String? waitingFor,
    DateTime? followUp,
    String? customerId,
  }) async =>
      (await db
              .into(db.tasks)
              .insertReturning(
                TasksCompanion.insert(
                  title: title,
                  status: Value(status),
                  plannedDay: Value(planned),
                  waitingFor: Value(waitingFor),
                  followUpDate: Value(followUp),
                  customerId: Value(customerId),
                ),
              ))
          .id;

  test('nothing is planned while reminders are off', () async {
    await task('Wartung', planned: at(2, 14));
    expect(await plan(const ReminderSettings()), isEmpty);
  });

  test('appointment reminder before the start, with customer', () async {
    final k =
        (await db
                .into(db.customers)
                .insertReturning(
                  CustomersCompanion.insert(name: 'Beispiel GmbH'),
                ))
            .id;
    final id = await task('Wartung', planned: at(2, 14), customerId: k);
    final r = (await plan(onlyTasks)).single;
    expect(r.at, at(2, 13, 50));
    expect(r.title, 'Termin in 10 min');
    expect(r.body, '14:00 Wartung · Beispiel GmbH');
    expect(r.route, '/task/$id');
  });

  test('skips past, closed and all-day tasks and the far future', () async {
    await task('Vorbei', planned: at(2, 8));
    await task('Erledigt', planned: at(2, 15), status: TaskStatus.done);
    await task('Ganztägig', planned: at(3, 0));
    await task('Zu weit', planned: at(20, 10));
    expect(await plan(onlyTasks), isEmpty);
  });

  test('follow-up announced in the morning of its day', () async {
    await task(
      'Angebot',
      status: TaskStatus.waitingFor,
      waitingFor: 'Muster AG',
      followUp: at(4, 0),
    );
    final r = (await plan(onlyTasks)).single;
    expect(r.at, at(4, 8));
    expect(r.title, 'Nachfassen bei Muster AG');
    expect(r.body, 'Angebot');
  });

  test('timer guard repeats after the interval and warns at day end', () async {
    final id = await task('Server prüfen');
    await time.start(id, pauseOthers: false);
    const s = ReminderSettings(
      enabled: true,
      dayClose: false,
      weekClose: false,
      morningPlan: false,
    );
    final rs = await plan(s);
    final guard = rs.where((r) => r.key.startsWith('timer:')).toList();
    expect(guard.map((r) => r.at), [at(2, 11), at(2, 13), at(2, 15)]);
    expect(guard.first.title, 'Timer läuft seit 2 h');
    expect(guard.first.body, 'Server prüfen – noch dran?');
    final eod = rs.singleWhere((r) => r.key.startsWith('timer-eod:'));
    expect(eod.at, at(2, 17));
    expect(eod.route, '/task/$id');
  });

  test('day close on weekdays, week close on Friday', () async {
    final rs = await plan(
      const ReminderSettings(
        enabled: true,
        timerGuard: false,
        morningPlan: false,
      ),
    );
    // Within 7 days of Mon 09:00: Mon–Thu, Fri (next Mon 17:00 is beyond).
    expect(rs.map((r) => (r.at.day, r.title)), [
      (2, 'Tagesabschluss'),
      (3, 'Tagesabschluss'),
      (4, 'Tagesabschluss'),
      (5, 'Tagesabschluss'),
      (6, 'Wochenabschluss'),
    ]);
    expect(rs.every((r) => r.at.hour == 17), isTrue);
    expect(rs.first.route, '/routine/day');
    expect(rs[4].route, '/routine/week');
  });

  test('morning planning on the next weekday mornings', () async {
    final rs = await plan(
      const ReminderSettings(
        enabled: true,
        timerGuard: false,
        dayClose: false,
        weekClose: false,
        morningMin: 7 * 60 + 30,
      ),
    );
    // Monday 07:30 has passed (now is 09:00); Tue–Fri and next Monday.
    expect(rs.map((r) => r.at), [
      at(3, 7, 30),
      at(4, 7, 30),
      at(5, 7, 30),
      at(6, 7, 30),
      at(9, 7, 30),
    ]);
    expect(rs.first.route, '/routine/morning');
  });

  test('ids are stable and differ per key', () {
    PlannedReminder r(String key) =>
        PlannedReminder(key: key, at: now, title: '', body: '');
    expect(r('appointment:a').id, r('appointment:a').id);
    expect(r('appointment:a').id, isNot(r('appointment:b').id));
    expect(r('appointment:a').id, greaterThanOrEqualTo(0));
  });

  test('settings survive a JSON round trip', () {
    const s = ReminderSettings(
      enabled: true,
      appointmentLeadMin: 30,
      timerGuardMin: 90,
      endOfDayMin: 16 * 60 + 30,
      weekClose: false,
    );
    final back = ReminderSettings.fromJson(s.toJson());
    expect(back.toJson(), s.toJson());
  });
}
