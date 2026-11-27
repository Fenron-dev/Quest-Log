import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/initials_avatar.dart';
import '../projects/data/projects_repository.dart';
import '../projects/project_tile.dart';
import '../tasks/data/tasks_repository.dart';
import '../tasks/quick_capture_sheet.dart';
import '../tasks/task_widgets.dart';
import '../time/data/time_repository.dart';
import 'contact_dialog.dart';
import 'data/customers_repository.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider(customerId));
    return customer.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Fehler: $e'))),
      data: (c) => c == null
          ? Scaffold(
              appBar: AppBar(),
              body: const EmptyState(
                icon: Icons.business_outlined,
                message: 'Kunde nicht gefunden.',
              ),
            )
          : _CustomerDetail(customer: c),
    );
  }
}

class _CustomerDetail extends ConsumerWidget {
  const _CustomerDetail({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: customer.isFavorite
                  ? 'Aus Favoriten entfernen'
                  : 'Zu Favoriten hinzufügen',
              icon: Icon(customer.isFavorite ? Icons.star : Icons.star_border),
              onPressed: () => ref
                  .read(customersRepositoryProvider)
                  .setFavorite(customer.id, !customer.isFavorite),
            ),
            IconButton(
              tooltip: 'Bearbeiten',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('${AppRoutes.customers}/${customer.id}/edit'),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(112),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      InitialsAvatar(
                        name: customer.name,
                        color: customer.color,
                        size: 52,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          customer.name,
                          style: textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Übersicht'),
                    Tab(text: 'Projekte'),
                    Tab(text: 'Aufgaben'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(customer: customer),
            _ProjectsTab(customer: customer),
            _TasksTab(customer: customer),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider(customer.id));
    final repo = ref.read(customersRepositoryProvider);

    Future<void> editContact([Contact? contact]) async {
      final entry = await showContactDialog(
        context,
        customerId: customer.id,
        contact: contact,
      );
      if (entry != null) await repo.saveContact(entry);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SectionHeader('Adresse'),
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(
            customer.address?.isNotEmpty == true
                ? customer.address!
                : 'Keine Adresse hinterlegt',
          ),
        ),
        const SectionHeader('AE diesen Monat'),
        _ContingentTile(customer: customer),
        SectionHeader(
          'Kontakte',
          trailing: IconButton(
            tooltip: 'Kontakt hinzufügen',
            icon: const Icon(Icons.person_add_alt),
            onPressed: editContact,
          ),
        ),
        ...contacts.when(
          loading: () => const [LinearProgressIndicator()],
          error: (e, _) => [Text('Fehler: $e')],
          data: (list) => list.isEmpty
              ? const [ListTile(title: Text('Noch keine Kontakte'))]
              : [
                  for (final k in list)
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(k.name),
                      subtitle: Text(
                        [
                          k.role,
                          k.phone,
                          k.email,
                        ].whereType<String>().join(' · '),
                      ),
                      onTap: () => editContact(k),
                      trailing: IconButton(
                        tooltip: 'Kontakt löschen',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (await confirmDelete(context, 'Kontakt')) {
                            await repo.deleteContact(k.id);
                          }
                        },
                      ),
                    ),
                ],
        ),
        if (customer.notes?.isNotEmpty == true) ...[
          const SectionHeader('Notizen'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(customer.notes!),
          ),
        ],
      ],
    );
  }
}

class _ProjectsTab extends ConsumerWidget {
  const _ProjectsTab({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider(customer.id));
    final newButton = OutlinedButton.icon(
      onPressed: () =>
          context.push('${AppRoutes.projects}/new?customer=${customer.id}'),
      icon: const Icon(Icons.add),
      label: const Text('Projekt anlegen'),
    );
    return projects.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (list) => list.isEmpty
          ? EmptyState(
              icon: Icons.folder_outlined,
              message: 'Noch keine Projekte für diesen Kunden.',
              action: newButton,
            )
          : ListView(
              children: [
                for (final p in list) ProjectTile(p, showCustomer: false),
                Padding(padding: const EdgeInsets.all(16), child: newButton),
              ],
            ),
    );
  }
}

class _TasksTab extends ConsumerWidget {
  const _TasksTab({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(
      taskListProvider((
        filter: TaskFilter.open,
        customerId: customer.id,
        projectId: null,
      )),
    );
    final newButton = OutlinedButton.icon(
      onPressed: () => showQuickCapture(context, customerId: customer.id),
      icon: const Icon(Icons.add),
      label: const Text('Aufgabe erfassen'),
    );
    return tasks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (list) => list.isEmpty
          ? EmptyState(
              icon: Icons.task_alt,
              message: 'Keine offenen Aufgaben für diesen Kunden.',
              action: newButton,
            )
          : ListView(
              children: [
                for (final t in list)
                  TaskListItem(
                    t,
                    key: ValueKey(t.task.id),
                    showCustomer: false,
                  ),
                Padding(padding: const EdgeInsets.all(16), child: newButton),
              ],
            ),
    );
  }
}

class _ContingentTile extends ConsumerWidget {
  const _ContingentTile({required this.customer});

  final Customer customer;

  /// Share of the contingent from which a warning is shown.
  static const warnShare = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final used = ref.watch(customerMonthAeProvider(customer.id)).value ?? 0;
    final contingent = customer.contingentAePerMonth;
    final scheme = Theme.of(context).colorScheme;
    if (contingent == null || contingent <= 0) {
      return ListTile(
        leading: const Icon(Icons.timelapse_outlined),
        title: Text('$used AE verbraucht'),
        subtitle: const Text('Kein Kontingent hinterlegt'),
      );
    }
    final share = used / contingent;
    final warn = share >= warnShare;
    return ListTile(
      leading: Icon(
        warn ? Icons.warning_amber : Icons.timelapse_outlined,
        color: warn ? scheme.error : null,
      ),
      title: Text('$used von $contingent AE'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: share.clamp(0, 1).toDouble(),
            color: warn ? scheme.error : null,
          ),
          if (warn) ...[
            const SizedBox(height: 4),
            Text(
              share >= 1
                  ? 'Kontingent überschritten'
                  : 'Kontingent fast aufgebraucht',
              style: TextStyle(color: scheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
