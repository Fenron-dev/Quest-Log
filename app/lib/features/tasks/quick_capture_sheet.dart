import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../templates/data/templates_repository.dart';
import 'data/tasks_repository.dart';
import 'task_actions.dart';

/// Bottom sheet for capturing a task in a few seconds: type a title and
/// press enter, or pick a favourite template.
Future<void> showQuickCapture(
  BuildContext context, {
  String? customerId,
  String? projectId,
  bool planToday = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _QuickCaptureSheet(
      customerId: customerId,
      projectId: projectId,
      planToday: planToday,
    ),
  );
}

class _QuickCaptureSheet extends ConsumerStatefulWidget {
  const _QuickCaptureSheet({
    this.customerId,
    this.projectId,
    this.planToday = false,
  });

  final String? customerId;
  final String? projectId;

  /// Plans the new task for today so it appears on Jetzt.
  final bool planToday;

  @override
  ConsumerState<_QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends ConsumerState<_QuickCaptureSheet> {
  final _title = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final text = _title.text.trim();
    if (text.isEmpty || _busy) return;
    setState(() => _busy = true);
    final repo = ref.read(tasksRepositoryProvider);
    if (widget.planToday) {
      final now = DateTime.now();
      await repo.createTask(
        TasksCompanion.insert(
          title: text,
          customerId: Value(widget.customerId),
          projectId: Value(widget.projectId),
          status: const Value(TaskStatus.planned),
          plannedDay: Value(DateTime(now.year, now.month, now.day)),
        ),
      );
    } else if (widget.projectId == null) {
      await repo.capture(text, customerId: widget.customerId);
    } else {
      await repo.createTask(
        TasksCompanion.insert(
          title: text,
          customerId: Value(widget.customerId),
          projectId: Value(widget.projectId),
        ),
      );
    }
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('„$text“ erfasst')));
  }

  Future<void> _fromTemplate(Template template) async {
    var customerId = widget.customerId ?? template.defaultCustomerId;
    if (customerId == null) {
      final (picked, id) = await pickCustomer(context, ref);
      if (!picked) return;
      customerId = id;
    }
    final taskId = await ref
        .read(tasksRepositoryProvider)
        .createFromTemplate(
          template,
          customerId: customerId,
          projectId: widget.projectId,
        );
    if (!mounted) return;
    final navigator = Navigator.of(context);
    navigator.pop();
    openTask(navigator.context, taskId);
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(favoriteTemplatesProvider).value ?? const [];
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
          Text(
            widget.planToday ? 'Neue Aufgabe für heute' : 'Erfassen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _title,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Was ist zu tun?',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: 'Hinzufügen',
                icon: const Icon(Icons.send),
                onPressed: _capture,
              ),
            ),
            onSubmitted: (_) => _capture(),
          ),
          if (templates.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Aus Vorlage starten',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in templates)
                  ActionChip(
                    avatar: const Icon(Icons.bolt, size: 18),
                    label: Text(t.name),
                    onPressed: () => _fromTemplate(t),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
