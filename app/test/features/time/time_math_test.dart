import 'package:flutter_test/flutter_test.dart';
import 'package:quest_log/features/time/engine/time_math.dart';

DateTime t(int h, [int m = 0, int s = 0]) => DateTime(2026, 3, 2, h, m, s);
TimeSpan span(DateTime a, DateTime b) => TimeSpan(a, b);
EntrySpan entry(
  String id,
  DateTime a,
  DateTime b, {
  bool background = false,
  String? task,
  String? customer,
}) => EntrySpan(
  id: id,
  start: a,
  end: b,
  background: background,
  taskId: task,
  customerId: customer,
);

void main() {
  group('union and subtract', () {
    test('merges overlapping and touching spans', () {
      expect(
        union([span(t(10), t(11)), span(t(9), t(10)), span(t(10, 30), t(12))]),
        [span(t(9), t(12))],
      );
      expect(union([span(t(9), t(10)), span(t(11), t(12))]), hasLength(2));
      expect(union([span(t(9), t(9))]), isEmpty);
    });

    test('subtracts cuts in the middle and at the edges', () {
      expect(subtract(span(t(8), t(12)), [span(t(9), t(10))]), [
        span(t(8), t(9)),
        span(t(10), t(12)),
      ]);
      expect(subtract(span(t(8), t(12)), [span(t(7), t(9))]), [
        span(t(9), t(12)),
      ]);
      expect(subtract(span(t(8), t(12)), [span(t(7), t(13))]), isEmpty);
    });

    test('totalDuration ignores double-counted overlaps', () {
      expect(
        totalDuration([span(t(9), t(10)), span(t(9, 30), t(10, 30))]),
        const Duration(minutes: 90),
      );
    });
  });

  group('gaps', () {
    test('reports clock time without any timer', () {
      final clock = [span(t(8), t(12))];
      final entries = [
        entry('a', t(8), t(9)),
        entry('b', t(9, 15), t(10)),
        entry('c', t(9, 50), t(11, 30)),
      ];
      expect(findGaps(clock, entries), [
        span(t(9), t(9, 15)),
        span(t(11, 30), t(12)),
      ]);
    });

    test('ignores gaps shorter than the minimum', () {
      final gaps = findGaps(
        [span(t(8), t(9))],
        [entry('a', t(8), t(8, 59, 30))],
      );
      expect(gaps, isEmpty);
    });

    test('respects multiple clock spans (pauses)', () {
      final gaps = findGaps(
        [span(t(8), t(12)), span(t(13), t(14))],
        [entry('a', t(8), t(12)), entry('b', t(13), t(13, 30))],
      );
      expect(gaps, [span(t(13, 30), t(14))]);
    });
  });

  group('allocate', () {
    test('a single entry gets its full duration', () {
      final a = allocate([entry('a', t(9), t(10))]);
      expect(a['a'], const Duration(hours: 1));
    });

    test('two active timers share overlapping time equally', () {
      final a = allocate([
        entry('a', t(9), t(10)),
        entry('b', t(9, 30), t(10, 30)),
      ]);
      expect(a['a'], const Duration(minutes: 45));
      expect(a['b'], const Duration(minutes: 45));
    });

    test('background timers count with the configured weight', () {
      // 60 min overlap: active weight 1, background 0.5 → 40 / 20 min.
      final a = allocate([
        entry('a', t(9), t(10)),
        entry('bg', t(9), t(10), background: true),
      ]);
      expect(a['a'], const Duration(minutes: 40));
      expect(a['bg'], const Duration(minutes: 20));

      final equal = allocate([
        entry('a', t(9), t(10)),
        entry('bg', t(9), t(10), background: true),
      ], backgroundWeight: 1);
      expect(equal['a'], const Duration(minutes: 30));
    });

    test('a background timer alone gets the full time', () {
      final a = allocate([entry('bg', t(9), t(10), background: true)]);
      expect(a['bg'], const Duration(hours: 1));
    });

    test('allocated sum never exceeds the covered time', () {
      final entries = [
        entry('a', t(8), t(12)),
        entry('b', t(9), t(11), background: true),
        entry('c', t(10), t(10, 45)),
        entry('d', t(11, 30), t(13)),
      ];
      final alloc = allocate(entries);
      final sum = alloc.values.fold(Duration.zero, (s, d) => s + d);
      final covered = totalDuration(entries.map((e) => e.span));
      expect(sum.inSeconds, closeTo(covered.inSeconds, 1));
    });

    test('sums by task and by customer', () {
      final entries = [
        entry('a', t(9), t(10), task: 'x', customer: 'k1'),
        entry('b', t(10), t(10, 30), task: 'x', customer: 'k1'),
        entry('c', t(11), t(11, 20), task: 'y', customer: 'k2'),
      ];
      final alloc = allocate(entries);
      expect(sumBy(entries, alloc, (e) => e.taskId), {
        'x': const Duration(minutes: 90),
        'y': const Duration(minutes: 20),
      });
      expect(
        sumBy(entries, alloc, (e) => e.customerId)['k2'],
        const Duration(minutes: 20),
      );
    });
  });

  group('AE', () {
    test('exact units', () {
      expect(exactAe(const Duration(minutes: 25)), 2.5);
      expect(exactAe(const Duration(minutes: 30), aeMinutes: 15), 2);
    });

    test('rounds up per started unit, counting whole minutes', () {
      expect(roundUpAe(Duration.zero), 0);
      expect(roundUpAe(const Duration(seconds: 50)), 0);
      expect(roundUpAe(const Duration(minutes: 1)), 1);
      expect(roundUpAe(const Duration(minutes: 10)), 1);
      expect(roundUpAe(const Duration(minutes: 10, seconds: 59)), 1);
      expect(roundUpAe(const Duration(minutes: 11)), 2);
      expect(roundUpAe(const Duration(minutes: 16), aeMinutes: 15), 2);
    });

    test('rounds each bucket separately', () {
      expect(
        roundedAeTotal([
          const Duration(minutes: 5),
          const Duration(minutes: 5),
        ]),
        2,
      );
    });

    test('target time check with threshold', () {
      expect(
        exceedsTarget(const Duration(minutes: 39), targetMinutes: 30),
        isFalse,
      );
      expect(
        exceedsTarget(const Duration(minutes: 40), targetMinutes: 30),
        isTrue,
      );
      expect(
        exceedsTarget(
          const Duration(minutes: 40),
          targetMinutes: 30,
          thresholdPercent: 50,
        ),
        isFalse,
      );
      expect(
        exceedsTarget(const Duration(hours: 9), targetMinutes: 0),
        isFalse,
      );
    });
  });

  group('clock spans', () {
    test('start to now minus pauses, open pause clamped', () {
      final spans = clockSpans(
        start: t(8),
        pauses: [span(t(12), t(12, 30)), span(t(15), t(16))],
        now: t(15, 30),
      );
      expect(spans, [span(t(8), t(12)), span(t(12, 30), t(15))]);
    });

    test('ended clock ignores now', () {
      final spans = clockSpans(
        start: t(8),
        end: t(16),
        pauses: const [],
        now: t(20),
      );
      expect(spans, [span(t(8), t(16))]);
    });
  });

  test('formatting', () {
    expect(formatHm(const Duration(minutes: 65)), '1:05');
    expect(formatHms(const Duration(seconds: 3725)), '1:02:05');
  });
}
