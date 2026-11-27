import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/ui/color_picker.dart';
import '../../core/ui/empty_state.dart';
import '../../core/ui/formatting.dart';
import '../customers/data/customers_repository.dart';
import 'data/projects_repository.dart';

class ProjectEditScreen extends ConsumerStatefulWidget {
  const ProjectEditScreen({super.key, this.projectId, this.customerId});

  /// Null when creating a new project.
  final String? projectId;

  /// Preselected customer for new projects.
  final String? customerId;

  @override
  ConsumerState<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends ConsumerState<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _budget = TextEditingController();
  final _warn = TextEditingController(text: '80');
  late String? _customerId = widget.customerId;
  int? _color;
  ProjectStatus _status = ProjectStatus.planned;
  DateTime? _start;
  DateTime? _due;
  bool _loading = false;

  bool get _isNew => widget.projectId == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final p = await ref
        .read(projectsRepositoryProvider)
        .getProject(widget.projectId!);
    if (!mounted) return;
    if (p != null) {
      _name.text = p.name;
      _budget.text = p.budgetAe?.toString() ?? '';
      _warn.text = p.warnPercent.toString();
      _customerId = p.customerId;
      _color = p.color;
      _status = p.status;
      _start = p.start;
      _due = p.due;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    _warn.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final entry = ProjectsCompanion(
      id: _isNew ? const Value.absent() : Value(widget.projectId!),
      name: Value(_name.text.trim()),
      customerId: Value(_customerId),
      color: Value(_color),
      status: Value(_status),
      start: Value(_start),
      due: Value(_due),
      budgetAe: Value(int.tryParse(_budget.text.trim())),
      warnPercent: Value(int.tryParse(_warn.text.trim()) ?? 80),
    );
    final id = await ref.read(projectsRepositoryProvider).saveProject(entry);
    if (!mounted) return;
    if (_isNew) {
      context.pushReplacement('${AppRoutes.projects}/$id');
    } else {
      context.pop();
    }
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context, 'Projekt')) return;
    await ref.read(projectsRepositoryProvider).deleteProject(widget.projectId!);
    if (mounted) context.go(AppRoutes.projects);
  }

  Future<void> _pickDate({required bool start}) async {
    final initial = (start ? _start : _due) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => start ? _start = picked : _due = picked);
    }
  }

  Widget _dateField(String label, DateTime? value, {required bool start}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: value == null
            ? null
            : IconButton(
                tooltip: '$label entfernen',
                icon: const Icon(Icons.clear),
                onPressed: () =>
                    setState(() => start ? _start = null : _due = null),
              ),
      ),
      child: InkWell(
        onTap: () => _pickDate(start: start),
        child: Text(value == null ? 'Kein Datum' : formatDate(value)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final knownCustomer =
        _customerId == null || customers.any((c) => c.id == _customerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'Neues Projekt' : 'Projekt bearbeiten'),
        actions: [
          if (!_isNew)
            IconButton(
              tooltip: 'Löschen',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: const Text('Speichern')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _name,
                    autofocus: _isNew,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Bitte einen Namen eingeben'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    initialValue: knownCustomer ? _customerId : null,
                    decoration: const InputDecoration(
                      labelText: 'Kunde',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Intern (kein Kunde)'),
                      ),
                      for (final c in customers)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => setState(() => _customerId = v),
                  ),
                  const SizedBox(height: 16),
                  Text('Farbe', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  ColorPicker(
                    value: _color,
                    inheritLabel: 'Vom Kunden',
                    onChanged: (v) => setState(() => _color = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProjectStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final s in ProjectStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? _status),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _dateField('Start', _start, start: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _dateField('Fällig', _due, start: false)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _budget,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Budget (AE)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _warn,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Warnschwelle (%)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            return n == null || n < 1 || n > 100
                                ? '1 bis 100'
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  if (!_isNew) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Meilensteine und Abschlusskriterien bearbeitest du in '
                      'der Projektansicht.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
