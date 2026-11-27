import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../../core/ui/empty_state.dart';
import 'data/projects_repository.dart';
import 'project_tile.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectListProvider(null));
    return Scaffold(
      appBar: AppBar(title: const Text('Projekte')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Projekt anlegen',
        onPressed: () => context.push('${AppRoutes.projects}/new'),
        child: const Icon(Icons.add),
      ),
      body: projects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.folder_outlined,
              message:
                  'Noch keine Projekte. Lege eines an oder lade '
                  'Beispieldaten in den Einstellungen.',
            );
          }
          final internal = list.where((p) => p.isInternal).toList();
          final customer = list.where((p) => !p.isInternal).toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              if (internal.isNotEmpty) ...[
                const SectionHeader('Intern'),
                for (final p in internal) ProjectTile(p, showCustomer: false),
              ],
              if (customer.isNotEmpty) ...[
                const SectionHeader('Kundenprojekte'),
                for (final p in customer) ProjectTile(p),
              ],
            ],
          );
        },
      ),
    );
  }
}
