import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/time_settings.dart';
import 'data/time_repository.dart';
import 'engine/time_math.dart';

/// Everything Jetzt and Mein Tag show about one day, computed from the
/// day's entries and work clock.
class DaySummary {
  const DaySummary({
    required this.day,
    required this.entries,
    required this.clock,
    required this.allocation,
    required this.bucketTotals,
    required this.ae,
    required this.recorded,
    required this.billable,
    required this.gaps,
    required this.aeMinutes,
  });

  final DateTime day;
  final List<EntryView> entries;
  final WorkClockView? clock;

  /// Allocated time per entry id (clamped to this day).
  final Map<String, Duration> allocation;

  /// Allocated time per bucket (task, or category and customer).
  final Map<String, Duration> bucketTotals;

  /// Work units, rounded up per bucket.
  final int ae;
  final Duration recorded;
  final Duration billable;
  final List<TimeSpan> gaps;
  final int aeMinutes;

  int get runningCount => entries.where((e) => e.isRunning).length;

  Duration allocatedFor(EntryView e) => allocation[e.entry.id] ?? Duration.zero;

  Duration bucketFor(EntryView e) =>
      bucketTotals[bucketKey(e)] ?? Duration.zero;

  /// Allocated time of a task on this day.
  Duration taskTotal(String taskId) => bucketTotals[taskId] ?? Duration.zero;

  static String bucketKey(EntryView e) =>
      e.entry.taskId ?? 'cat:${e.entry.category}|${e.entry.customerId}';

  static DaySummary compute({
    required DateTime day,
    required List<EntryView> entries,
    required WorkClockView? clock,
    required DateTime now,
    required TimeSettings settings,
  }) {
    final from = dayOf(day);
    final to = from.add(const Duration(days: 1));
    final effectiveNow = now.isBefore(from) ? from : now;

    final spans = <EntrySpan>[];
    for (final e in entries) {
      final raw = e.toSpan(effectiveNow);
      final start = raw.start.isBefore(from) ? from : raw.start;
      var end = raw.end.isAfter(to) ? to : raw.end;
      if (end.isBefore(start)) end = start;
      spans.add(
        EntrySpan(
          id: raw.id,
          start: start,
          end: end,
          background: raw.background,
          taskId: raw.taskId,
          customerId: raw.customerId,
          billable: raw.billable,
        ),
      );
    }

    final allocation = allocate(
      spans,
      backgroundWeight: settings.backgroundWeight,
    );
    final byId = {for (final e in entries) e.entry.id: e};
    final buckets = <String, Duration>{};
    var billable = Duration.zero;
    for (final s in spans) {
      final view = byId[s.id]!;
      final d = allocation[s.id] ?? Duration.zero;
      final key = bucketKey(view);
      buckets[key] = (buckets[key] ?? Duration.zero) + d;
      if (s.billable) billable += d;
    }
    final recorded = allocation.values.fold(Duration.zero, (a, b) => a + b);
    final clockSpans = clock?.spans(effectiveNow) ?? const <TimeSpan>[];

    return DaySummary(
      day: from,
      entries: entries,
      clock: clock,
      allocation: allocation,
      bucketTotals: buckets,
      ae: roundedAeTotal(buckets.values, aeMinutes: settings.aeMinutes),
      recorded: recorded,
      billable: billable,
      gaps: findGaps(clockSpans, spans),
      aeMinutes: settings.aeMinutes,
    );
  }
}

/// Current time from the ticker, or the wall clock before the first tick.
final currentNowProvider = Provider<DateTime>(
  (ref) => ref.watch(nowProvider).value ?? DateTime.now(),
);

final daySummaryProvider = Provider.autoDispose.family<DaySummary?, DateTime>((
  ref,
  day,
) {
  final entries = ref.watch(dayEntriesProvider(day)).value;
  final clock = ref.watch(dayClockProvider(day));
  if (entries == null || clock.isLoading) return null;
  return DaySummary.compute(
    day: day,
    entries: entries,
    clock: clock.value,
    now: ref.watch(currentNowProvider),
    settings: ref.watch(currentTimeSettingsProvider),
  );
});

/// Today's date (midnight), following the ticker across midnight.
final todayProvider = Provider<DateTime>(
  (ref) => dayOf(ref.watch(currentNowProvider)),
);
