import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/view_settings.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../now/now_day_header.dart';
import '../routines/routine_widgets.dart';
import '../tasks/appointment_sheet.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
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

class _AppointmentRow extends _Row {
  _AppointmentRow(this.view);
  final TaskView view;
  @override
  DateTime get start => view.task.plannedDay!;
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
    final appointments =
        ref.watch(dayAppointmentsProvider(day)).value ?? const <TaskView>[];
    final textTheme = Theme.of(context).textTheme;

    Future<void> pickDay() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: day,
        firstDate: DateTime(2000),
        lastDate: today.add(const Duration(days: 365)),
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
                    onPressed: () => setState(
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
                        if (isToday) RoutineChips(today: today),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: DayBar(
                            summary: summary,
                            now: now,
                            appointments: appointments,
                          ),
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
                        if (view == DayView.timeline)
                          _Timeline(
                            summary: summary,
                            now: now,
                            appointments: appointments,
                          )
                        else if (summary.entries.isEmpty &&
                            summary.gaps.isEmpty &&
                            appointments.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: EmptyState(
                              icon: Icons.today_outlined,
                              message:
                                  'Noch nichts erfasst. Starte einen Timer auf '
                                  '„Jetzt“ – die Arbeitsuhr läuft dann '
                                  'automatisch. Im Zeitstrahl planst du '
                                  'Termine per Tipp auf eine freie Stelle.',
                            ),
                          )
                        else
                          ..._historyRows(context, summary, now, appointments),
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
    List<TaskView> appointments,
  ) {
    final rows = <_Row>[
      for (final e in summary.entries) _EntryRow(e),
      for (final g in summary.gaps) _GapRow(g),
      for (final a in appointments) _AppointmentRow(a),
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
          _AppointmentRow(:final view) => _AppointmentTile(view: view),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
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
          IconButton(
            tooltip: 'Zeiteintrag bearbeiten',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showEntryEditSheet(context, view),
          ),
        ],
      ),
      onTap: view.task != null
          ? () => openTask(context, view.task!.id)
          : () => showEntryEditSheet(context, view),
      onLongPress: () => showEntryEditSheet(context, view),
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

/// Vertical timeline: one row per hour. Entries and appointments open
/// their task; tapping free space plans an appointment or adds time.
/// Short entries get a minimum height and move to their own lane so they
/// stay readable and tappable; zoom stretches the hours.
class _Timeline extends ConsumerStatefulWidget {
  const _Timeline({
    required this.summary,
    required this.now,
    required this.appointments,
  });

  final DaySummary summary;
  final DateTime now;
  final List<TaskView> appointments;

  @override
  ConsumerState<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends ConsumerState<_Timeline> {
  static const _zoomLevels = [64.0, 128.0, 256.0];
  static const _labelWidth = 40.0;

  /// Smallest drawn height of an entry, enough for one line and a finger.
  static const minBlockHeight = 28.0;

  int _zoom = 0;

  double get _hourHeight => _zoomLevels[_zoom];
  DaySummary get summary => widget.summary;
  DateTime get now => widget.now;
  List<TaskView> get appointments => widget.appointments;

  Future<void> _onFreeSlot(BuildContext context, DateTime at) async {
    final canBackfill = at.isBefore(now);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text('Termin planen um ${formatTime(at)}'),
              onTap: () {
                Navigator.pop(sheet);
                showAppointmentSheet(context, at: at);
              },
            ),
            if (canBackfill)
              ListTile(
                leading: const Icon(Icons.more_time),
                title: Text('Zeit nachtragen ab ${formatTime(at)}'),
                onTap: () {
                  Navigator.pop(sheet);
                  final end = at.add(const Duration(minutes: 30));
                  showGapFillSheet(
                    context,
                    gap: TimeSpan(at, end.isAfter(now) ? now : end),
                    dayEntries: summary.entries,
                    title: 'Zeit nachtragen',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (from, to) = visibleHours(summary, now, appointments: appointments);
    final start = summary.day.add(Duration(hours: from));
    double y(DateTime t) =>
        (t.difference(start).inSeconds / 3600).clamp(
          0,
          (to - from).toDouble(),
        ) *
        _hourHeight;

    // Drawn extent of each entry (at least minBlockHeight). Entries whose
    // drawn boxes would overlap go side by side in lanes.
    final top = <String, double>{};
    final height = <String, double>{};
    final laneEnds = <double>[];
    final laneOf = <String, int>{};
    for (final e in [
      ...summary.entries,
    ]..sort((a, b) => a.entry.start.compareTo(b.entry.start))) {
      final t = y(e.entry.start);
      final h = (y(e.entry.end ?? now) - t).clamp(
        minBlockHeight,
        double.infinity,
      );
      top[e.entry.id] = t;
      height[e.entry.id] = h;
      var lane = laneEnds.indexWhere((end) => end <= t + 0.5);
      if (lane < 0) {
        laneEnds.add(0);
        lane = laneEnds.length - 1;
      }
      laneEnds[lane] = t + h;
      laneOf[e.entry.id] = lane;
    }
    final laneCount = laneEnds.isEmpty ? 1 : laneEnds.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Zeitstrahl verkleinern',
                icon: const Icon(Icons.zoom_out),
                onPressed: _zoom == 0 ? null : () => setState(() => _zoom--),
              ),
              IconButton(
                tooltip: 'Zeitstrahl vergrößern',
                icon: const Icon(Icons.zoom_in),
                onPressed: _zoom == _zoomLevels.length - 1
                    ? null
                    : () => setState(() => _zoom++),
              ),
            ],
          ),
          _body(context, from, to, start, y, top, height, laneOf, laneCount),
        ],
      ),
    );
  }

  Widget _body(
    BuildContext context,
    int from,
    int to,
    DateTime start,
    double Function(DateTime) y,
    Map<String, double> top,
    Map<String, double> height,
    Map<String, int> laneOf,
    int laneCount,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final total = (to - from) * _hourHeight;
    final bottom = top.keys.fold<double>(
      total,
      (m, id) => top[id]! + height[id]! > m ? top[id]! + height[id]! : m,
    );
    return SizedBox(
      height: bottom + 8,
      child: LayoutBuilder(
        builder: (context, c) {
          final width = c.maxWidth - _labelWidth;
          final laneWidth = width / laneCount;
          return Stack(
            children: [
              // Free space: tap to plan or backfill at that time.
              Positioned.fill(
                left: _labelWidth,
                child: GestureDetector(
                  key: const Key('timeline-free-space'),
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (d) {
                    final minutes = (d.localPosition.dy / _hourHeight * 60)
                        .floor();
                    final rounded = minutes - minutes % 15;
                    _onFreeSlot(context, start.add(Duration(minutes: rounded)));
                  },
                ),
              ),
              IgnorePointer(
                child: Stack(
                  children: [
                    for (var h = from; h <= to; h++)
                      Positioned(
                        top: (h - from) * _hourHeight,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: _labelWidth,
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
                  ],
                ),
              ),
              for (final g in summary.gaps)
                Positioned(
                  top: y(g.start),
                  height: (y(g.end) - y(g.start)).clamp(2, double.infinity),
                  left: _labelWidth,
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
              for (final a in appointments)
                Positioned(
                  top: y(a.task.plannedDay!),
                  height:
                      (y(
                                a.task.plannedDay!.add(
                                  Duration(minutes: a.task.estimateMin ?? 30),
                                ),
                              ) -
                              y(a.task.plannedDay!))
                          .clamp(20, double.infinity),
                  left: _labelWidth,
                  width: width,
                  child: InkWell(
                    onTap: () => openTask(context, a.task.id),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorPalette.resolve(a.color),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${formatTime(a.task.plannedDay!)} ${a.task.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              for (final e in summary.entries)
                Positioned(
                  top: top[e.entry.id],
                  height: height[e.entry.id],
                  left: _labelWidth + laneOf[e.entry.id]! * laneWidth,
                  width: laneWidth - 2,
                  child: GestureDetector(
                    key: Key('timeline-entry-${e.entry.id}'),
                    onTap: e.task != null
                        ? () => openTask(context, e.task!.id)
                        : () => showEntryEditSheet(context, e),
                    onLongPress: () => showEntryEditSheet(context, e),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorPalette.resolve(e.color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        e.title,
                        maxLines: height[e.entry.id]! >= 44 ? 2 : 1,
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
                ),
              if (dayOf(now) == summary.day)
                Positioned(
                  top: y(now),
                  left: _labelWidth - 4,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(height: 2, color: scheme.error),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.view});

  final TaskView view;

  @override
  Widget build(BuildContext context) {
    final t = view.task;
    final color = ColorPalette.resolve(view.color);
    final end = t.plannedDay!.add(Duration(minutes: t.estimateMin ?? 30));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(Icons.event, color: color),
        title: Text(t.title),
        subtitle: Text(
          '${formatTime(t.plannedDay!)}–${formatTime(end)} · Termin'
          '${view.customer == null ? '' : ' · ${view.customer!.name}'}',
        ),
        onTap: () => openTask(context, t.id),
      ),
    );
  }
}
