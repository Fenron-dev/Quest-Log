/// Pure time-tracking calculations. No database or Flutter dependencies,
/// so everything here is unit-tested directly.
library;

/// A half-open time interval `[start, end)`.
class TimeSpan {
  TimeSpan(this.start, this.end)
    : assert(!end.isBefore(start), 'end must not be before start');

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  bool get isEmpty => !end.isAfter(start);

  /// Intersection with [other], or null if they do not overlap.
  TimeSpan? intersect(TimeSpan other) {
    final s = start.isAfter(other.start) ? start : other.start;
    final e = end.isBefore(other.end) ? end : other.end;
    return e.isAfter(s) ? TimeSpan(s, e) : null;
  }

  @override
  bool operator ==(Object other) =>
      other is TimeSpan && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'TimeSpan($start – $end)';
}

/// A recorded (or running, already clamped to "now") time entry.
class EntrySpan {
  const EntrySpan({
    required this.id,
    required this.start,
    required this.end,
    this.background = false,
    this.taskId,
    this.customerId,
    this.billable = true,
  });

  final String id;
  final DateTime start;
  final DateTime end;

  /// Runs alongside other work and therefore counts with a lower weight.
  final bool background;
  final String? taskId;
  final String? customerId;
  final bool billable;

  TimeSpan get span => TimeSpan(start, end);
}

/// Merges overlapping or touching spans into a sorted, disjoint list.
List<TimeSpan> union(Iterable<TimeSpan> spans) {
  final sorted = spans.where((s) => !s.isEmpty).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  final result = <TimeSpan>[];
  for (final s in sorted) {
    if (result.isNotEmpty && !s.start.isAfter(result.last.end)) {
      final last = result.removeLast();
      result.add(
        TimeSpan(last.start, s.end.isAfter(last.end) ? s.end : last.end),
      );
    } else {
      result.add(s);
    }
  }
  return result;
}

/// Removes [cuts] from [base].
List<TimeSpan> subtract(TimeSpan base, Iterable<TimeSpan> cuts) {
  var remaining = [base];
  for (final cut in union(cuts)) {
    final next = <TimeSpan>[];
    for (final r in remaining) {
      if (r.intersect(cut) == null) {
        next.add(r);
        continue;
      }
      if (cut.start.isAfter(r.start)) next.add(TimeSpan(r.start, cut.start));
      if (cut.end.isBefore(r.end)) next.add(TimeSpan(cut.end, r.end));
    }
    remaining = next;
  }
  return remaining;
}

Duration totalDuration(Iterable<TimeSpan> spans) =>
    union(spans).fold(Duration.zero, (sum, s) => sum + s.duration);

/// Periods of the work clock in which no timer ran. Gaps shorter than
/// [minGap] are ignored.
List<TimeSpan> findGaps(
  List<TimeSpan> clock,
  List<EntrySpan> entries, {
  Duration minGap = const Duration(minutes: 1),
}) {
  final covered = entries.map((e) => e.span).toList();
  return [
    for (final c in clock)
      ...subtract(c, covered).where((g) => g.duration >= minGap),
  ];
}

/// Distributes overlapping time across parallel entries.
///
/// Every instant is shared among the entries running at that moment.
/// Active entries have weight 1, background entries [backgroundWeight].
/// The sum of all allocations therefore equals the covered time and never
/// exceeds it.
Map<String, Duration> allocate(
  List<EntrySpan> entries, {
  double backgroundWeight = 0.5,
}) {
  final result = {for (final e in entries) e.id: Duration.zero};
  final points = {
    for (final e in entries)
      if (e.end.isAfter(e.start)) ...[e.start, e.end],
  }.toList()..sort();

  for (var i = 0; i + 1 < points.length; i++) {
    final a = points[i];
    final b = points[i + 1];
    final running = entries
        .where((e) => !e.start.isAfter(a) && !e.end.isBefore(b))
        .toList();
    if (running.isEmpty) continue;
    double weightOf(EntrySpan e) => e.background ? backgroundWeight : 1.0;
    final total = running.fold<double>(0, (s, e) => s + weightOf(e));
    if (total <= 0) continue;
    final micros = b.difference(a).inMicroseconds;
    for (final e in running) {
      result[e.id] =
          result[e.id]! +
          Duration(microseconds: (micros * weightOf(e) / total).round());
    }
  }
  return result;
}

/// Sums allocations per key, e.g. per task or customer.
Map<K, Duration> sumBy<K>(
  List<EntrySpan> entries,
  Map<String, Duration> allocation,
  K Function(EntrySpan e) key,
) {
  final result = <K, Duration>{};
  for (final e in entries) {
    final k = key(e);
    result[k] =
        (result[k] ?? Duration.zero) + (allocation[e.id] ?? Duration.zero);
  }
  return result;
}

/// Exact work units, e.g. 25 min at 10 min/AE = 2.5.
double exactAe(Duration d, {int aeMinutes = 10}) =>
    d.inSeconds / (aeMinutes * 60);

/// Rounds up to whole work units. Raw time is counted in whole minutes, so
/// a few seconds never produce an extra unit.
int roundUpAe(Duration d, {int aeMinutes = 10}) {
  final minutes = d.inSeconds ~/ 60;
  if (minutes <= 0) return 0;
  return (minutes + aeMinutes - 1) ~/ aeMinutes;
}

/// Rounds each bucket (e.g. one task on one day) up separately and sums.
int roundedAeTotal(Iterable<Duration> buckets, {int aeMinutes = 10}) =>
    buckets.fold(0, (s, d) => s + roundUpAe(d, aeMinutes: aeMinutes));

/// True if the recorded time exceeds the target time by more than
/// [thresholdPercent].
bool exceedsTarget(
  Duration actual, {
  required int targetMinutes,
  int thresholdPercent = 30,
}) {
  if (targetMinutes <= 0) return false;
  final limitSeconds = targetMinutes * 60 * (100 + thresholdPercent) / 100;
  return actual.inSeconds > limitSeconds;
}

/// Work clock intervals of a day: from start to end (or [now]) minus pauses.
List<TimeSpan> clockSpans({
  required DateTime start,
  DateTime? end,
  required List<TimeSpan> pauses,
  required DateTime now,
}) {
  final stop = end ?? now;
  if (!stop.isAfter(start)) return const [];
  final clampedPauses = pauses
      .map((p) => TimeSpan(p.start, p.end.isAfter(stop) ? stop : p.end))
      .where((p) => !p.isEmpty);
  return subtract(TimeSpan(start, stop), clampedPauses);
}

/// Formats a duration as `h:mm` (e.g. `1:05`).
String formatHm(Duration d) {
  final minutes = d.inMinutes;
  return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';
}

/// Formats a duration as `h:mm:ss` for running timers.
String formatHms(Duration d) {
  final s = d.inSeconds;
  return '${s ~/ 3600}:${((s ~/ 60) % 60).toString().padLeft(2, '0')}:'
      '${(s % 60).toString().padLeft(2, '0')}';
}
