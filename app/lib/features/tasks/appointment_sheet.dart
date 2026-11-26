import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/formatting.dart';
import '../customers/data/customers_repository.dart';
import '../time/gap_fill_sheet.dart' show formatTime;
import 'data/tasks_repository.dart';

/// Plans an appointment: a task at a fixed time with a duration.
Future<void> showAppointmentSheet(
  BuildContext context, {
  required DateTime at,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AppointmentSheet(at: at),
  );
}

class _AppointmentSheet extends ConsumerStatefulWidget {
  const _AppointmentSheet({required this.at});

  final DateTime at;

  @override
  ConsumerState<_AppointmentSheet> createState() => _AppointmentSheetState();
}

class _AppointmentSheetState extends ConsumerState<_AppointmentSheet> {
  final _title = TextEditingController();
  late DateTime _at = widget.at;
  int _minutes = 30;
  String? _customerId;

  static const _durations = [15, 30, 45, 60, 90, 120];

  static String _durationLabel(int m) => switch (m) {
    60 => '1 h',
    90 => '1,5 h',
    120 => '2 h',
    _ => '$m min',
  };

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_at),
    );
    if (picked != null) {
      setState(
        () => _at = DateTime(
          _at.year,
          _at.month,
          _at.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) return;
    // Midnight would read as "no time"; nudge it by a minute.
    final at = _at.hour == 0 && _at.minute == 0
        ? _at.add(const Duration(minutes: 1))
        : _at;
    await ref
        .read(tasksRepositoryProvider)
        .createTask(
          TasksCompanion.insert(
            title: title,
            status: const Value(TaskStatus.planned),
            plannedDay: Value(at),
            estimateMin: Value(_minutes),
            customerId: Value(_customerId),
          ),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Termin planen', style: textTheme.titleLarge),
          Row(
            children: [
              Text(formatDate(_at)),
              TextButton.icon(
                icon: const Icon(Icons.schedule),
                label: Text('um ${formatTime(_at)}'),
                onPressed: _pickTime,
              ),
            ],
          ),
          TextField(
            controller: _title,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Was?',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          Text('Dauer', style: textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in _durations)
                ChoiceChip(
                  label: Text(_durationLabel(m)),
                  selected: _minutes == m,
                  onSelected: (_) => setState(() => _minutes = m),
                ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Termin speichern')),
        ],
      ),
    );
  }
}
