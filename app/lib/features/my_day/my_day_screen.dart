import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/view_settings.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../now/now_day_header.dart';
import '../time/data/time_repository.dart';
import '../time/day_bar.dart';
import '../time/day_summary.dart';
import '../time/engine/time_math.dart';
import '../time/entry_edit_sheet.dart';
import '../time/gap_fill_sheet.dart';

class MyDayScreen extends ConsumerStatefulWidget {
  const MyDayScreen({super.key});

  @override
  ConsumerState<MyDayScreen> createState() => _MyDayScreenState();
}

/// One row of the day: an entry or a gap.
sealed class _Row {
  DateTime get start;
}

class _EntryRow extends _Row {
  _EntryRow(this.view);
  final EntryView view;
  @override
  DateTime get start => view.entry.start;
}

class _GapRow extends _Row {
  _GapRow(this.gap);
  final TimeSpan gap;
  @override
  DateTime get start => gap.start;
}

class _MyDayScreenState extends ConsumerState<MyDayScreen> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    final day = _selectedDay ?? today;
    final isToday = day == today;
    final summary = ref.watch(daySummaryProvider(day));
    final now = ref.watch(currentNowProvider);
    final view = ref.watch(dayViewProvider).value ?? DayView.history;
    final textTheme = Theme.of(context).textTheme;

    Future<void> pickDay() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: day,
        firstDate: DateTime(2000),
        lastDate: today,
      );
      if (picked != null) setState(() => _selectedDay = dayOf(picked));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: NowDayHeader(showingDay: true),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Vorheriger Tag',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(
                      () => _selectedDay = dayOf(
                        day.subtract(const Duration(hours: 12)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: pickDay,
                      child: Column(
                        children: [
                          Text(
                            isToday ? 'Heute' : formatDate(day),
                            style: textTheme.titleMedium,
                          ),
                          if (summary != null)
                            Text(
                              '${summary.ae} AE · ${formatHm(summary.recorded)} h · '
                              'davon abrechenbar ${formatHm(summary.billable)} h',
                              style: textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Nächster Tag',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: isToday
                        ? null
                        : () => setState(
                            () => _selectedDay = dayOf(
                              day.add(const Duration(hours: 36)),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: summary == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 32),
                      children: [
                        if (isToday) _ClockCard(summary: summary),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: DayBar(summary: summary, now: now),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: SegmentedButton<DayView>(
                            showSelectedIcon: false,
                            segments: [
                              for (final v in DayView.values)
                                ButtonSegment(value: v, label: Text(v.label)),
                            ],
                            selected: {view},
                            onSelectionChanged: (s) =>
                                ref.read(dayViewProvider.notifier).set(s.first),
                          ),
                        ),
                        if (summary.entries.isEmpty && summary.gaps.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: EmptyState(
                              icon: Icons.today_outlined,
                              message:
                                  'Noch nichts erfasst. Starte einen Timer auf '
                                  '„Jetzt“ – die Arbeitsuhr läuft dann automatisch.',
                            ),
                          )
                        else if (view == DayView.history)
                          ..._historyRows(context, summary, now)
                        else
                          _Timeline(summary: summary, now: now),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _historyRows(
    BuildContext context,
    DaySummary summary,
    DateTime now,
  ) {
    final rows = <_Row>[
      for (final e in summary.entries) _EntryRow(e),
      for (final g in summary.gaps) _GapRow(g),
    ]..sort((a, b) => a.start.compareTo(b.start));
    return [
      for (final r in rows)
        switch (r) {
          _EntryRow(:final view) => _EntryTile(
            view: view,
            summary: summary,
            now: now,
          ),
          _GapRow(:final gap) => _GapTile(gap: gap, summary: summary),
        },
    ];
  }
}

class _ClockCard extends ConsumerWidget {
  const _ClockCard({required this.summary});

  final DaySummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(timeRepositoryProvider);
    final clock = summary.clock;
    final String status;
    final List<Widget> actions;
    if (clock == null) {
      status = 'Arbeitsuhr startet mit dem ersten Timer.';
      actions = [
        FilledButton.tonal(
          onPressed: repo.startDay,
          child: const Text('Arbeitstag beginnen'),
        ),
      ];
    } else if (clock.isEnded) {
      status = 'Feierabend um ${formatTime(clock.end!)}';
      actions = [
        OutlinedButton(
          onPressed: repo.startDay,
          child: const Text('Weiterarbeiten'),
        ),
      ];
    } else if (clock.isPaused) {
      status = 'Pause seit ${formatTime(clock.openPauseStart!)}';
      actions = [
        FilledButton.tonal(
          onPressed: repo.resumeClock,
          child: const Text('Weiter'),
        ),
      ];
    } else {
      status = 'Arbeitsuhr läuft seit ${formatTime(clock.start)}';
      actions = [
        OutlinedButton(onPressed: repo.pauseClock, child: const Text('Pause')),
        FilledButton.tonal(
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Feierabend?'),
                content: const Text('Alle laufenden Timer werden gestoppt.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Abbrechen'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Feierabend'),
                  ),
                ],
              ),
            );
            if (ok == true) await repo.endClock();
          },
          child: const Text('Feierabend'),
        ),
      ];
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule),
                const SizedBox(width: 8),
                Expanded(child: Text(status)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends ConsumerWidget {
  const _EntryTile({
    required this.view,
    required this.summary,
    required this.now,
  });

  final EntryView view;
  final DaySummary summary;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = view.entry;
    final allocated = summary.allocatedFor(view);
    final end = e.end;
    final status = view.isRunning
        ? 'läuft'
        : e.kind == TimeEntryKind.background
        ? 'nebenher'
        : (view.task?.status == TaskStatus.done ? 'erledigt' : 'erfasst');
    final line2 = [
      view.customer?.name ?? 'Kein Kunde',
      if (view.task?.itflowTicketId != null)
        'Ticket ${view.task!.itflowTicketId}',
    ].join(' · ');
    final line3 =
        '${formatTime(e.start)}–${end == null ? 'jetzt' : formatTime(end)} · $status';
    return ListTile(
      leading: Container(
        width: 6,
        height: 44,
        decoration: BoxDecoration(
          color: ColorPalette.resolve(view.color),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      title: Text(view.title),
      subtitle: Text('$line2\n$line3'),
      isThreeLine: true,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${exactAe(allocated, aeMinutes: summary.aeMinutes).toStringAsFixed(1)} AE',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(formatHm(allocated)),
        ],
      ),
      onTap: () => showEntryEditSheet(context, view),
    );
  }
}

class _GapTile extends StatelessWidget {
  const _GapTile({required this.gap, required this.summary});

  final TimeSpan gap;
  final DaySummary summary;

  @override
  Widget build(BuildContext context) {
    final minutes = gap.duration.inMinutes;
    final ae = roundUpAe(gap.duration, aeMinutes: summary.aeMinutes);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: gapColor.withValues(alpha: 0.25),
        border: Border.all(color: gapColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.help_outline),
        title: Text('$minutes min · $ae AE offen'),
        subtitle: Text('${formatTime(gap.start)}–${formatTime(gap.end)}'),
        trailing: TextButton(
          onPressed: () =>
              showGapFillSheet(context, gap: gap, dayEntries: summary.entries),
          child: const Text('Nachtragen'),
        ),
      ),
    );
  }
}

/// Vertical timeline: one row per hour, entries and gaps as blocks.
class _Timeline extends StatelessWidget {
  const _Timeline({required this.summary, required this.now});

  final DaySummary summary;
  final DateTime now;

  static const _hourHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    final (from, to) = visibleHours(summary, now);
    final start = summary.day.add(Duration(hours: from));
    final scheme = Theme.of(context).colorScheme;
    double y(DateTime t) =>
        (t.difference(start).inSeconds / 3600).clamp(
          0,
          (to - from).toDouble(),
        ) *
        _hourHeight;

    // Lay out overlapping entries side by side in lanes.
    final lanes = <List<EntryView>>[];
    final laneOf = <String, int>{};
    for (final e in [
      ...summary.entries,
    ]..sort((a, b) => a.entry.start.compareTo(b.entry.start))) {
      var lane = lanes.indexWhere(
        (l) => !(l.last.entry.end ?? now).isAfter(e.entry.start),
      );
      if (lane < 0) {
        lanes.add([]);
        lane = lanes.length - 1;
      }
      lanes[lane].add(e);
      laneOf[e.entry.id] = lane;
    }
    final laneCount = lanes.isEmpty ? 1 : lanes.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: SizedBox(
        height: (to - from) * _hourHeight + 8,
        child: LayoutBuilder(
          builder: (context, c) {
            const labelWidth = 40.0;
            final width = c.maxWidth - labelWidth;
            final laneWidth = width / laneCount;
            return Stack(
              children: [
                for (var h = from; h <= to; h++)
                  Positioned(
                    top: (h - from) * _hourHeight,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(
                            '$h:00',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(height: 1, color: scheme.outline),
                        ),
                      ],
                    ),
                  ),
                for (final g in summary.gaps)
                  Positioned(
                    top: y(g.start),
                    height: (y(g.end) - y(g.start)).clamp(2, double.infinity),
                    left: labelWidth,
                    width: width,
                    child: InkWell(
                      onTap: () => showGapFillSheet(
                        context,
                        gap: g,
                        dayEntries: summary.entries,
                      ),
                      child: Container(
                        color: gapColor.withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${g.duration.inMinutes} min offen – Nachtragen',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                for (final e in summary.entries)
                  Positioned(
                    top: y(e.entry.start),
                    height: (y(e.entry.end ?? now) - y(e.entry.start)).clamp(
                      4,
                      double.infinity,
                    ),
                    left: labelWidth + laneOf[e.entry.id]! * laneWidth,
                    width: laneWidth - 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorPalette.resolve(e.color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        e.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorPalette.onColor(
                            ColorPalette.resolve(e.color),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (dayOf(now) == summary.day)
                  Positioned(
                    top: y(now),
                    left: labelWidth - 4,
                    right: 0,
                    child: Container(height: 2, color: scheme.error),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
