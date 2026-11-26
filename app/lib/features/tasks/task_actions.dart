import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../customers/data/customers_repository.dart';
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
  await repo.setDone(taskId, true);
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
