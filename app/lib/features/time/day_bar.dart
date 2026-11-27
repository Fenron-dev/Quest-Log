import 'package:material_ui/material_ui.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/color_palette.dart';
import '../tasks/data/tasks_repository.dart';
import 'data/time_repository.dart';
import 'day_summary.dart';
import 'engine/time_math.dart';

/// Colour used for unassigned gaps.
const gapColor = Color(0xFFF2C94C);

/// Visible hour range of a day: 08–17, widened to include all entries and
/// the work clock.
(int, int) visibleHours(
  DaySummary s,
  DateTime now, {
  List<TaskView> appointments = const [],
}) {
  var from = 8;
  var to = 17;
  final points = <DateTime>[
    for (final e in s.entries) ...[e.entry.start, e.entry.end ?? now],
    if (s.clock != null) s.clock!.start,
    if (s.clock?.end != null) s.clock!.end!,
    for (final a in appointments) ...[
      a.task.plannedDay!,
      a.task.plannedDay!.add(Duration(minutes: a.task.estimateMin ?? 30)),
    ],
  ].where((p) => dayOf(p) == s.day);
  for (final p in points) {
    if (p.hour < from) from = p.hour;
    final endHour = p.minute > 0 ? p.hour + 1 : p.hour;
    if (endHour > to) to = endHour.clamp(0, 24);
  }
  return (from, to);
}

/// Horizontal bar of the day: entries in their colour, gaps in yellow,
/// a marker for "now". Hour labels below.
class DayBar extends StatelessWidget {
  const DayBar({
    super.key,
    required this.summary,
    required this.now,
    this.appointments = const [],
  });

  final DaySummary summary;
  final DateTime now;

  /// Drawn as frames on top of the bar.
  final List<TaskView> appointments;

  @override
  Widget build(BuildContext context) {
    final (from, to) = visibleHours(summary, now, appointments: appointments);
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: scheme.onSurfaceVariant);
    final gapMinutes = summary.gaps.fold(
      Duration.zero,
      (a, g) => a + g.duration,
    );
    return Semantics(
      label:
          'Tagesbalken von $from bis $to Uhr, '
          '${formatHm(summary.recorded)} Stunden erfasst, '
          '${formatHm(gapMinutes)} Stunden offen',
      child: ExcludeSemantics(
        child: Column(
          children: [
            SizedBox(
              height: 28,
              child: CustomPaint(
                size: Size.infinite,
                painter: _DayBarPainter(
                  summary: summary,
                  appointments: appointments,
                  now: now,
                  fromHour: from,
                  toHour: to,
                  track: scheme.surfaceContainerHighest,
                  marker: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var h = from; h <= to; h += ((to - from) > 10 ? 2 : 1))
                  Text('$h', style: labelStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBarPainter extends CustomPainter {
  _DayBarPainter({
    required this.summary,
    required this.appointments,
    required this.now,
    required this.fromHour,
    required this.toHour,
    required this.track,
    required this.marker,
  });

  final DaySummary summary;
  final List<TaskView> appointments;
  final DateTime now;
  final int fromHour;
  final int toHour;
  final Color track;
  final Color marker;

  @override
  void paint(Canvas canvas, Size size) {
    final start = summary.day.add(Duration(hours: fromHour));
    final total = (toHour - fromHour) * 60.0;
    double x(DateTime t) =>
        (t.difference(start).inSeconds / 60 / total).clamp(0.0, 1.0) *
        size.width;
    final radius = const Radius.circular(4);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, radius),
      Paint()..color = track,
    );
    for (final g in summary.gaps) {
      canvas.drawRect(
        Rect.fromLTRB(x(g.start), 0, x(g.end), size.height),
        Paint()..color = gapColor,
      );
    }
    for (final e in summary.entries) {
      final end = e.entry.end ?? now;
      final background = e.entry.kind == TimeEntryKind.background;
      final top = background ? size.height * 0.55 : 0.0;
      canvas.drawRect(
        Rect.fromLTRB(x(e.entry.start), top, x(end), size.height),
        Paint()..color = ColorPalette.resolve(e.color),
      );
    }
    for (final a in appointments) {
      final s = a.task.plannedDay!;
      final e = s.add(Duration(minutes: a.task.estimateMin ?? 30));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x(s), 1, x(e), size.height - 1),
          radius,
        ),
        Paint()
          ..color = ColorPalette.resolve(a.color)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    if (dayOf(now) == summary.day) {
      final nx = x(now);
      canvas.drawRect(
        Rect.fromLTRB(nx - 1, -2, nx + 1, size.height + 2),
        Paint()..color = marker,
      );
    }
  }

  @override
  bool shouldRepaint(_DayBarPainter old) =>
      old.summary != summary || old.now != now || old.track != track;
}
