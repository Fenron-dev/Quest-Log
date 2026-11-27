import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import '../time/data/time_repository.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'reminder_settings.dart';

/// One local notification to schedule.
class PlannedReminder {
  const PlannedReminder({
    required this.key,
    required this.at,
    required this.title,
    required this.body,
    this.route,
  });

  /// Stable identity, e.g. `appointment:<taskId>`.
  final String key;
  final DateTime at;
  final String title;
  final String body;

  /// Where a tap on the notification leads.
  final String? route;

  /// Platform notification id derived from [key] (31-bit FNV-1a).
  int get id {
    var h = 0x811c9dc5;
    for (final c in key.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0xffffffff;
    }
    return h & 0x7fffffff;
  }

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder &&
      other.key == key &&
      other.at == at &&
      other.title == title &&
      other.body == body &&
      other.route == route;

  @override
  int get hashCode => Object.hash(key, at, title, body, route);

  @override
  String toString() => 'PlannedReminder($key @ $at: $title – $body)';
}

/// How far ahead reminders are scheduled; the plan is rebuilt whenever
/// data changes or the app comes back to the foreground.
const reminderHorizon = Duration(days: 7);

/// Upper bound of scheduled notifications (platforms limit pending alarms).
const maxPlannedReminders = 60;

/// Timer-guard repetitions scheduled ahead per running timer.
const _guardRepeats = 3;

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

/// Computes all reminders due after [now] within [reminderHorizon].
List<PlannedReminder> planReminders({
  required DateTime now,
  required ReminderSettings settings,
  required List<TaskView> tasks,
  required List<EntryView> running,
}) {
  if (!settings.enabled) return const [];
  final until = now.add(reminderHorizon);
  final out = <PlannedReminder>[];
  void add(PlannedReminder r) {
    if (r.at.isAfter(now) && !r.at.isAfter(until)) out.add(r);
  }

  String withCustomer(String text, TaskView v) =>
      v.customer == null ? text : '$text · ${v.customer!.name}';

  for (final v in tasks) {
    final t = v.task;
    if (t.status.isClosed) continue;
    if (settings.appointments && isAppointment(t)) {
      final lead = settings.appointmentLeadMin;
      add(
        PlannedReminder(
          key: 'appointment:${t.id}',
          at: t.plannedDay!.subtract(Duration(minutes: lead)),
          title: lead == 0 ? 'Termin jetzt' : 'Termin in $lead min',
          body: withCustomer('${formatTime(t.plannedDay!)} ${t.title}', v),
          route: taskRoute(t.id),
        ),
      );
    }
    if (settings.followUps &&
        t.status == TaskStatus.waitingFor &&
        t.followUpDate != null) {
      final who = t.waitingFor?.trim();
      add(
        PlannedReminder(
          key: 'followup:${t.id}',
          at: _day(t.followUpDate!).add(Duration(hours: settings.followUpHour)),
          title: who == null || who.isEmpty
              ? 'Nachfassen'
              : 'Nachfassen bei $who',
          body: withCustomer(t.title, v),
          route: taskRoute(t.id),
        ),
      );
    }
  }

  final endToday = _day(now).add(Duration(minutes: settings.endOfDayMin));

  if (settings.timerGuard) {
    for (final e in running) {
      final guard = Duration(minutes: settings.timerGuardMin);
      final route = e.task == null ? AppRoutes.myDay : taskRoute(e.task!.id);
      // Next few multiples of the guard interval after now.
      final elapsed = now.difference(e.entry.start);
      var k = elapsed.inMinutes ~/ settings.timerGuardMin + 1;
      for (var n = 0; n < _guardRepeats; n++, k++) {
        final at = e.entry.start.add(guard * k);
        final hours = (settings.timerGuardMin * k) / 60;
        add(
          PlannedReminder(
            key: 'timer:${e.entry.id}:$k',
            at: at,
            title: 'Timer läuft seit ${_hoursLabel(hours)}',
            body: '${e.title} – noch dran?',
            route: route,
          ),
        );
      }
      if (e.entry.start.isBefore(endToday)) {
        add(
          PlannedReminder(
            key: 'timer-eod:${e.entry.id}',
            at: endToday,
            title: 'Feierabend – Timer läuft noch',
            body: '${e.title} pausieren oder beenden?',
            route: route,
          ),
        );
      }
    }
  }

  // Day / week close at the end of the next working days.
  for (var d = 0; d <= reminderHorizon.inDays; d++) {
    final day = _day(now).add(Duration(days: d));
    if (day.weekday > DateTime.friday) continue;
    final at = day.add(Duration(minutes: settings.endOfDayMin));
    final friday = day.weekday == DateTime.friday;
    if (friday && settings.weekClose) {
      add(
        PlannedReminder(
          key: 'weekclose:${day.toIso8601String()}',
          at: at,
          title: 'Wochenabschluss',
          body: 'Lücken, „Zeit prüfen“ und Kontingente durchsehen',
          route: AppRoutes.myDay,
        ),
      );
    } else if (settings.dayClose) {
      add(
        PlannedReminder(
          key: 'dayclose:${day.toIso8601String()}',
          at: at,
          title: 'Tagesabschluss',
          body: 'Lücken zuordnen und offene Aufgaben verschieben',
          route: AppRoutes.myDay,
        ),
      );
    }
  }

  out.sort((a, b) => a.at.compareTo(b.at));
  return out.length > maxPlannedReminders
      ? out.sublist(0, maxPlannedReminders)
      : out;
}

String _hoursLabel(double h) {
  if (h == h.roundToDouble()) return '${h.round()} h';
  return '${h.toStringAsFixed(1).replaceAll('.', ',')} h';
}
