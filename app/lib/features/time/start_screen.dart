import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/settings/time_settings.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/empty_state.dart';
import '../customers/data/customers_repository.dart';
import '../tasks/data/tasks_repository.dart';
import '../templates/data/templates_repository.dart';
import 'data/time_repository.dart';

/// Start a timer in three taps: customer, what, start.
class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  final _customerSearch = TextEditingController();
  final _what = TextEditingController();
  Customer? _customer;
  bool _customerChosen = false;
  Template? _template;
  TaskView? _existing;
  bool? _pauseOthers;
  bool _busy = false;

  @override
  void dispose() {
    _customerSearch.dispose();
    _what.dispose();
    super.dispose();
  }

  String get _whatLabel =>
      _existing?.task.title ??
      _template?.name ??
      (_what.text.trim().isEmpty ? '' : _what.text.trim());

  bool get _canStart => _customerChosen && _whatLabel.isNotEmpty && !_busy;

  Future<void> _start() async {
    setState(() => _busy = true);
    final pauseOthers =
        _pauseOthers ?? ref.read(currentTimeSettingsProvider).pauseOthers;
    final tasks = ref.read(tasksRepositoryProvider);
    final String taskId;
    if (_existing != null) {
      taskId = _existing!.task.id;
    } else if (_template != null) {
      taskId = await tasks.createFromTemplate(
        _template!,
        customerId: _customer?.id,
      );
    } else {
      final now = DateTime.now();
      taskId = await tasks.createTask(
        TasksCompanion.insert(
          title: _what.text.trim(),
          customerId: Value(_customer?.id),
          status: const Value(TaskStatus.planned),
          plannedDay: Value(DateTime(now.year, now.month, now.day)),
        ),
      );
    }
    await ref
        .read(timeRepositoryProvider)
        .start(taskId, pauseOthers: pauseOthers);
    if (mounted) context.pop();
  }

  Widget _choice({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
    IconData? icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary : scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: selected ? scheme.primary : scheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              if (color != null)
                Container(
                  width: 10,
                  height: 28,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    icon,
                    size: 18,
                    color: selected ? scheme.onPrimary : scheme.onSurface,
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? scheme.onPrimary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check, size: 18, color: scheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _grid(int columns, List<Widget> children) => GridView.count(
    crossAxisCount: columns,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: columns == 3 ? 2.0 : 3.0,
    children: children,
  );

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final templates = ref.watch(favoriteTemplatesProvider).value ?? const [];
    final query = _customerSearch.text.trim().toLowerCase();
    final favorites = customers.where((c) => c.isFavorite).take(5).toList();
    final matches = query.isEmpty
        ? const <Customer>[]
        : customers
              .where((c) => c.name.toLowerCase().contains(query))
              .take(6)
              .toList();
    final openTasks =
        ref
            .watch(
              taskListProvider((
                filter: TaskFilter.open,
                customerId: _customer?.id,
                projectId: null,
              )),
            )
            .value ??
        const [];
    final whatQuery = _what.text.trim().toLowerCase();
    final taskMatches = whatQuery.isEmpty
        ? const <TaskView>[]
        : openTasks
              .where(
                (t) =>
                    (_customer == null || t.task.customerId == _customer!.id) &&
                    t.task.title.toLowerCase().contains(whatQuery),
              )
              .take(5)
              .toList();
    final pauseOthers =
        _pauseOthers ?? ref.watch(currentTimeSettingsProvider).pauseOthers;
    final textTheme = Theme.of(context).textTheme;

    final startLabel = _canStart
        ? '$_whatLabel · ${_customer?.name ?? 'ohne Kunde'} starten'
        : 'Kunde und Tätigkeit wählen';

    return Scaffold(
      appBar: AppBar(title: const Text('Starten')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
            onPressed: _canStart ? _start : null,
            icon: const Icon(Icons.play_arrow),
            label: Text(
              startLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('1. Kunde', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          _grid(3, [
            for (final c in favorites)
              _choice(
                label: c.name,
                color: ColorPalette.resolve(c.color),
                selected: _customerChosen && _customer?.id == c.id,
                onTap: () => setState(() {
                  _customer = c;
                  _customerChosen = true;
                  _existing = null;
                }),
              ),
            _choice(
              label: 'Ohne Kunde',
              icon: Icons.block,
              selected: _customerChosen && _customer == null,
              onTap: () => setState(() {
                _customer = null;
                _customerChosen = true;
                _existing = null;
              }),
            ),
          ]),
          const SizedBox(height: 8),
          TextField(
            controller: _customerSearch,
            decoration: const InputDecoration(
              hintText: 'Alle Kunden durchsuchen',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => setState(() {}),
          ),
          for (final c in matches)
            ListTile(
              leading: Icon(
                Icons.circle,
                color: ColorPalette.resolve(c.color),
                size: 14,
              ),
              title: Text(c.name),
              selected: _customer?.id == c.id,
              onTap: () => setState(() {
                _customer = c;
                _customerChosen = true;
                _existing = null;
                _customerSearch.clear();
              }),
            ),
          if (_customerChosen &&
              _customer != null &&
              !favorites.contains(_customer))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Chip(
                avatar: const Icon(Icons.check, size: 18),
                label: Text(_customer!.name),
              ),
            ),
          const SizedBox(height: 24),
          Text('2. Was', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          if (templates.isNotEmpty)
            _grid(2, [
              for (final t in templates.take(4))
                _choice(
                  label: t.name,
                  icon: Icons.bolt,
                  selected: _template?.id == t.id,
                  onTap: () => setState(() {
                    _template = _template?.id == t.id ? null : t;
                    _existing = null;
                    _what.clear();
                  }),
                ),
            ]),
          const SizedBox(height: 8),
          TextField(
            controller: _what,
            decoration: const InputDecoration(
              hintText: 'Neue Aufgabe oder offene suchen',
              prefixIcon: Icon(Icons.edit_outlined),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => setState(() {
              _template = null;
              _existing = null;
            }),
          ),
          for (final t in taskMatches)
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(t.task.title),
              subtitle: t.customer == null ? null : Text(t.customer!.name),
              selected: _existing?.task.id == t.task.id,
              onTap: () => setState(() {
                _existing = t;
                _template = null;
              }),
            ),
          if (_existing != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Chip(
                avatar: const Icon(Icons.check, size: 18),
                label: Text('Vorhandene Aufgabe: ${_existing!.task.title}'),
              ),
            ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Andere pausieren'),
            subtitle: const Text(
              'Laufende aktive Timer werden pausiert und können danach '
              'fortgesetzt werden.',
            ),
            value: pauseOthers,
            onChanged: (v) => setState(() => _pauseOthers = v),
          ),
          if (customers.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: EmptyState(
                icon: Icons.business_outlined,
                message: 'Noch keine Kunden angelegt.',
              ),
            ),
        ],
      ),
    );
  }
}
