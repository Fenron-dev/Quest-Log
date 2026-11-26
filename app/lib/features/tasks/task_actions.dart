import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/time_settings.dart';
import '../customers/data/customers_repository.dart';
import '../notes/data/notes_repository.dart';
import '../templates/data/templates_repository.dart';
import '../time/data/time_repository.dart';
import '../time/engine/time_math.dart';
import 'data/tasks_repository.dart';

String taskRoute(String id) => '/tasks/$id';

/// Marks a task done; asks first if required checklist steps are open.
Future<void> completeTask(
  BuildContext context,
  WidgetRef ref,
  String taskId,
) async {
  final repo = ref.read(tasksRepositoryProvider);
  final open = await repo.openRequiredItems(taskId);
  if (open.isNotEmpty) {
    if (!context.mounted) return;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pflichtschritte offen'),
        content: Text(
          'Noch nicht erledigt:\n${open.map((i) => '• ${i.label}').join('\n')}'
          '\n\nTrotzdem abschließen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Abschließen'),
          ),
        ],
      ),
    );
    if (proceed != true) return;
  }
  if (!context.mounted) return;

  final time = ref.read(timeRepositoryProvider);
  final settings = ref.read(currentTimeSettingsProvider);
  final task = await repo.getTask(taskId);
  if (task == null) return;
  final spent = await time.allocatedForTask(
    taskId,
    backgroundWeight: settings.backgroundWeight,
  );
  final template = task.templateId == null
      ? null
      : await ref
            .read(templatesRepositoryProvider)
            .getTemplate(task.templateId!);
  final customer = task.customerId == null
      ? null
      : await ref
            .read(customersRepositoryProvider)
            .getCustomer(task.customerId!);
  if (!context.mounted) return;

  final result = await showDialog<_CompletionResult>(
    context: context,
    builder: (_) => _CompletionDialog(
      title: task.title,
      customerName: customer?.name,
      spent: spent,
      aeMinutes: settings.aeMinutes,
      flatRateAe: template?.flatRateAe,
      targetMinutes: template?.targetMinutes,
    ),
  );
  if (result == null) return;

  await time.stop(taskId);
  if (result.note.isNotEmpty) {
    await ref
        .read(notesRepositoryProvider)
        .addText(NoteParentType.task, taskId, result.note, isSolution: true);
  }
  if (result.needsReview) {
    await repo.saveTask(
      TasksCompanion(
        id: Value(taskId),
        tags: Value(encodeTags([...decodeTags(task.tags), reviewTimeTag])),
      ),
    );
  }
  await repo.setDone(taskId, true);
}

/// Tag set on tasks whose recorded time exceeds the template's target.
const reviewTimeTag = 'Zeit prüfen';

class _CompletionResult {
  const _CompletionResult(this.note, this.needsReview);
  final String note;
  final bool needsReview;
}

class _CompletionDialog extends StatefulWidget {
  const _CompletionDialog({
    required this.title,
    required this.customerName,
    required this.spent,
    required this.aeMinutes,
    this.flatRateAe,
    this.targetMinutes,
  });

  final String title;
  final String? customerName;
  final Duration spent;
  final int aeMinutes;
  final int? flatRateAe;
  final int? targetMinutes;

  @override
  State<_CompletionDialog> createState() => _CompletionDialogState();
}

class _CompletionDialogState extends State<_CompletionDialog> {
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _overTarget =>
      widget.targetMinutes != null &&
      exceedsTarget(widget.spent, targetMinutes: widget.targetMinutes!);

  @override
  Widget build(BuildContext context) {
    final ae = roundUpAe(widget.spent, aeMinutes: widget.aeMinutes);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Abschließen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Kunde: ${widget.customerName ?? 'kein Kunde (intern)'}'),
            Text('Erfasst: ${formatHm(widget.spent)} h · $ae AE'),
            if (widget.flatRateAe != null)
              Text('Berechnet: Pauschale ${widget.flatRateAe} AE'),
            if (_overTarget) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.warning_amber, color: scheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mehr als 30 % über der Sollzeit '
                      '(${widget.targetMinutes} min). Die Aufgabe wird mit '
                      '„$reviewTimeTag“ markiert.',
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Abschlussnotiz (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _CompletionResult(_note.text.trim(), _overTarget),
          ),
          child: const Text('Abschließen'),
        ),
      ],
    );
  }
}

/// Lets the user pick a customer (or none). Returns `(picked, customerId)`;
/// `picked` is false if the dialog was dismissed.
Future<(bool, String?)> pickCustomer(
  BuildContext context,
  WidgetRef ref,
) async {
  final customers = await ref
      .read(customersRepositoryProvider)
      .watchCustomers()
      .first;
  if (!context.mounted) return (false, null);
  final sorted = [
    ...customers.where((c) => c.isFavorite),
    ...customers.where((c) => !c.isFavorite),
  ];
  const none = '\u0000none';
  final result = await showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Für welchen Kunden?'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, none),
          child: const ListTile(
            leading: Icon(Icons.block),
            title: Text('Ohne Kunde'),
          ),
        ),
        for (final Customer c in sorted)
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, c.id),
            child: ListTile(
              leading: Icon(
                c.isFavorite ? Icons.star : Icons.business_outlined,
              ),
              title: Text(c.name),
            ),
          ),
      ],
    ),
  );
  if (result == null) return (false, null);
  return (true, result == none ? null : result);
}

void openTask(BuildContext context, String id) => context.push(taskRoute(id));
