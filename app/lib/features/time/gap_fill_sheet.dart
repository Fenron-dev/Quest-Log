import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../customers/data/customers_repository.dart';
import '../tasks/data/tasks_repository.dart';
import 'data/time_repository.dart';
import 'engine/time_math.dart';

String formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// Assigns an unrecorded gap to a task, a category or a break. The end can
/// be moved earlier to split the gap.
Future<void> showGapFillSheet(
  BuildContext context, {
  required TimeSpan gap,
  required List<EntryView> dayEntries,
  String title = 'Lücke nachtragen',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        _GapFillSheet(gap: gap, dayEntries: dayEntries, title: title),
  );
}

class _GapFillSheet extends ConsumerStatefulWidget {
  const _GapFillSheet({
    required this.gap,
    required this.dayEntries,
    required this.title,
  });

  final TimeSpan gap;
  final String title;
  final List<EntryView> dayEntries;

  @override
  ConsumerState<_GapFillSheet> createState() => _GapFillSheetState();
}

class _GapFillSheetState extends ConsumerState<_GapFillSheet> {
  late DateTime _end = widget.gap.end;
  String? _customerId;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  TimeSpan get _span => TimeSpan(widget.gap.start, _end);

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_end),
    );
    if (picked == null) return;
    final candidate = DateTime(
      _end.year,
      _end.month,
      _end.day,
      picked.hour,
      picked.minute,
    );
    if (candidate.isAfter(widget.gap.start) &&
        !candidate.isAfter(widget.gap.end)) {
      setState(() => _end = candidate);
    }
  }

  Future<void> _assign({String? taskId, String? category}) async {
    await ref
        .read(timeRepositoryProvider)
        .addEntry(
          start: _span.start,
          end: _span.end,
          taskId: taskId,
          customerId: taskId == null ? _customerId : null,
          category: category,
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _assignBreak() async {
    await ref.read(timeRepositoryProvider).addClockPause(_span);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final openTasks =
        ref
            .watch(
              taskListProvider((
                filter: TaskFilter.open,
                customerId: null,
                projectId: null,
              )),
            )
            .value ??
        const [];
    // Suggestions: tasks worked on today first, then other open tasks.
    final todayTaskIds = <String>{};
    final suggestions = <(String, String, String?)>[];
    for (final e in widget.dayEntries.reversed) {
      final t = e.task;
      if (t != null && todayTaskIds.add(t.id)) {
        suggestions.add((t.id, t.title, e.customer?.name));
      }
    }
    for (final v in openTasks) {
      if (todayTaskIds.add(v.task.id)) {
        suggestions.add((v.task.id, v.task.title, v.customer?.name));
      }
    }
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Text(widget.title, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${formatTime(widget.gap.start)} – ',
                  style: textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: _pickEnd,
                  child: Text(formatTime(_end), style: textTheme.titleMedium),
                ),
                Text('· ${_span.duration.inMinutes} min'),
              ],
            ),
            if (_end != widget.gap.end)
              Text(
                'Der Rest bis ${formatTime(widget.gap.end)} bleibt offen.',
                style: textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            Text('Aufgabe', style: textTheme.labelLarge),
            if (suggestions.isEmpty)
              const ListTile(title: Text('Keine offenen Aufgaben')),
            for (final (id, title, customer) in suggestions.take(6))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.task_alt),
                title: Text(title),
                subtitle: customer == null ? null : Text(customer),
                onTap: () => _assign(taskId: id),
              ),
            const Divider(),
            Text('Oder Kategorie', style: textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _customerId,
              decoration: const InputDecoration(
                labelText: 'Kunde',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Kein Kunde')),
                for (final Customer c in customers)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _customerId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Notiz (optional)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final k in QuickStartKind.values)
                  ActionChip(
                    label: Text(k.label),
                    onPressed: () => _assign(category: k.name),
                  ),
                ActionChip(
                  label: const Text('Intern'),
                  onPressed: () => _assign(category: 'internal'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.free_breakfast_outlined, size: 18),
                  label: const Text('Pause'),
                  onPressed: _assignBreak,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
