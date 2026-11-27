import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/empty_state.dart';
import '../customers/data/customers_repository.dart';
import '../projects/data/projects_repository.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/task_actions.dart';
import 'data/time_repository.dart';
import 'gap_fill_sheet.dart' show formatTime;

/// Edits a time entry: times, customer, project, task, kind, billable and
/// note. Optionally applies customer and project to the whole task.
Future<void> showEntryEditSheet(BuildContext context, EntryView view) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _EntryEditSheet(view: view),
  );
}

class _EntryEditSheet extends ConsumerStatefulWidget {
  const _EntryEditSheet({required this.view});

  final EntryView view;

  @override
  ConsumerState<_EntryEditSheet> createState() => _EntryEditSheetState();
}

class _EntryEditSheetState extends ConsumerState<_EntryEditSheet> {
  late DateTime _start = widget.view.entry.start;
  late DateTime? _end = widget.view.entry.end;
  late String? _customerId = widget.view.entry.customerId;
  late String? _projectId = widget.view.entry.projectId;
  late String? _taskId = widget.view.entry.taskId;
  late TimeEntryKind _kind = widget.view.entry.kind;
  late bool _billable = widget.view.entry.billable;
  late final _note = TextEditingController(text: widget.view.entry.note);
  bool _applyToTask = true;
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickTime(DateTime base) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (picked == null) return null;
    return DateTime(
      base.year,
      base.month,
      base.day,
      picked.hour,
      picked.minute,
    );
  }

  Future<void> _save() async {
    final repo = ref.read(timeRepositoryProvider);
    try {
      await repo.updateEntry(
        widget.view.entry.id,
        start: _start,
        end: _end,
        taskId: _taskId,
        customerId: _customerId,
        projectId: _projectId,
        kind: _kind,
        billable: _billable,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      );
      if (_taskId != null && _applyToTask) {
        await repo.assignTask(
          _taskId!,
          customerId: _customerId,
          projectId: _projectId,
        );
      }
      if (mounted) Navigator.pop(context);
    } on ArgumentError {
      setState(() => _error = 'Das Ende muss nach dem Beginn liegen.');
    }
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context, 'Zeiteintrag')) return;
    await ref.read(timeRepositoryProvider).deleteEntry(widget.view.entry.id);
    if (mounted) Navigator.pop(context);
  }

  InputDecoration _deco(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final projects = (ref.watch(projectListProvider(null)).value ?? const [])
        .where((p) => p.project.customerId == _customerId)
        .toList();
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
    final taskOptions = <(String, String)>[
      if (widget.view.task != null &&
          !openTasks.any((t) => t.task.id == widget.view.task!.id))
        (widget.view.task!.id, widget.view.task!.title),
      for (final t in openTasks) (t.task.id, t.task.title),
    ];
    final running = _end == null;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Zeiteintrag', style: textTheme.titleLarge),
                ),
                if (widget.view.task != null)
                  IconButton(
                    tooltip: 'Aufgabe öffnen',
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () {
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      openTask(navigator.context, widget.view.task!.id);
                    },
                  ),
                if (!running)
                  IconButton(
                    tooltip: 'Löschen',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _delete,
                  ),
                FilledButton(onPressed: _save, child: const Text('Speichern')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: Text('Von ${formatTime(_start)}'),
                    onPressed: () async {
                      final t = await _pickTime(_start);
                      if (t != null) setState(() => _start = t);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.schedule),
                    label: Text(running ? 'läuft' : 'Bis ${formatTime(_end!)}'),
                    onPressed: running
                        ? null
                        : () async {
                            final t = await _pickTime(_end!);
                            if (t != null) setState(() => _end = t);
                          },
                  ),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: customers.any((c) => c.id == _customerId)
                  ? _customerId
                  : null,
              decoration: _deco('Kunde'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Kein Kunde')),
                for (final c in customers)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() {
                if (_customerId == null && v != null) _billable = true;
                _customerId = v;
                _projectId = null;
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              key: ValueKey('project-$_customerId'),
              initialValue: projects.any((p) => p.project.id == _projectId)
                  ? _projectId
                  : null,
              decoration: _deco(
                _customerId == null ? 'Internes Projekt' : 'Projekt',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Kein Projekt'),
                ),
                for (final p in projects)
                  DropdownMenuItem(
                    value: p.project.id,
                    child: Text(p.project.name),
                  ),
              ],
              onChanged: (v) => setState(() => _projectId = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: taskOptions.any((o) => o.$1 == _taskId)
                  ? _taskId
                  : null,
              isExpanded: true,
              decoration: _deco('Aufgabe'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Keine Aufgabe'),
                ),
                for (final (id, title) in taskOptions)
                  DropdownMenuItem(
                    value: id,
                    child: Text(title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _taskId = v),
            ),
            if (_taskId != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Kunde und Projekt für die ganze Aufgabe übernehmen',
                ),
                subtitle: const Text(
                  'Gilt dann auch für ihre anderen Zeiteinträge',
                ),
                value: _applyToTask,
                onChanged: (v) => setState(() => _applyToTask = v ?? false),
              ),
            const SizedBox(height: 4),
            SegmentedButton<TimeEntryKind>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TimeEntryKind.active,
                  label: Text('Aktiv'),
                ),
                ButtonSegment(
                  value: TimeEntryKind.background,
                  label: Text('Nebenher'),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Abrechenbar'),
              value: _billable,
              onChanged: (v) => setState(() => _billable = v),
            ),
            TextField(
              controller: _note,
              minLines: 1,
              maxLines: 4,
              decoration: _deco('Notiz'),
            ),
          ],
        ),
      ),
    );
  }
}
