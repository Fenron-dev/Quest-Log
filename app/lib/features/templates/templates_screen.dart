import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/empty_state.dart';
import 'data/templates_repository.dart';

const templatesRoute = '/templates';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateListProvider);
    final repo = ref.read(templatesRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Vorlagen')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Vorlage anlegen',
        onPressed: () => context.push('$templatesRoute/new'),
        child: const Icon(Icons.add),
      ),
      body: templates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.bolt,
                message:
                    'Noch keine Vorlagen. Vorlagen mit Stern erscheinen beim '
                    'Erfassen als Schnellstart.',
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final t = list[i];
                  final steps = ChecklistDraft.decodeList(t.checklist).length;
                  final details = [
                    if (steps > 0) '$steps Schritte',
                    if (t.estimate != null) '${t.estimate} min',
                    if (t.flatRateAe != null) 'Pauschale ${t.flatRateAe} AE',
                  ];
                  return ListTile(
                    leading: const Icon(Icons.bolt),
                    title: Text(t.name),
                    subtitle: details.isEmpty
                        ? null
                        : Text(details.join(' · ')),
                    trailing: IconButton(
                      tooltip: t.isFavorite
                          ? 'Aus Favoriten entfernen'
                          : 'Zu Favoriten hinzufügen',
                      icon: Icon(t.isFavorite ? Icons.star : Icons.star_border),
                      onPressed: () => repo.setFavorite(t.id, !t.isFavorite),
                    ),
                    onTap: () => context.push('$templatesRoute/${t.id}'),
                  );
                },
              ),
      ),
    );
  }
}
