import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/initials_avatar.dart';
import 'data/customers_repository.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _query = '';
  CustomerFilter _filter = CustomerFilter.all;

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(
      customerListProvider((query: _query, filter: _filter)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Kunden')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Kunde anlegen',
        onPressed: () => context.push('${AppRoutes.customers}/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Name, Ort oder Ansprechpartner',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<CustomerFilter>(
                showSelectedIcon: false,
                segments: [
                  for (final f in CustomerFilter.values)
                    ButtonSegment(value: f, label: Text(f.label)),
                ],
                selected: {_filter},
                onSelectionChanged: (s) => setState(() => _filter = s.first),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: customers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
              data: (list) => list.isEmpty
                  ? EmptyState(
                      icon: Icons.business_outlined,
                      message: _query.isEmpty && _filter == CustomerFilter.all
                          ? 'Noch keine Kunden. Lege einen an oder lade '
                                'Beispieldaten in den Einstellungen.'
                          : 'Keine Treffer.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: 72),
                      itemBuilder: (context, i) => _CustomerTile(list[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTile extends ConsumerWidget {
  const _CustomerTile(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      minTileHeight: 64,
      leading: InitialsAvatar(name: customer.name, color: customer.color),
      title: Text(customer.name),
      subtitle: customer.address == null || customer.address!.isEmpty
          ? null
          : Text(
              customer.address!.replaceAll('\n', ', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: IconButton(
        tooltip: customer.isFavorite
            ? 'Aus Favoriten entfernen'
            : 'Zu Favoriten hinzufügen',
        icon: Icon(customer.isFavorite ? Icons.star : Icons.star_border),
        onPressed: () => ref
            .read(customersRepositoryProvider)
            .setFavorite(customer.id, !customer.isFavorite),
      ),
      onTap: () => context.push('${AppRoutes.customers}/${customer.id}'),
    );
  }
}
