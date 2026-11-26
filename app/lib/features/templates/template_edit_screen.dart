import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/empty_state.dart';
import '../customers/data/customers_repository.dart';
import 'data/templates_repository.dart';

class _StepDraft {
  _StepDraft(String label, {this.required = false})
    : controller = TextEditingController(text: label);

  final TextEditingController controller;
  bool required;
  final key = UniqueKey();
}

class TemplateEditScreen extends ConsumerStatefulWidget {
  const TemplateEditScreen({super.key, this.templateId});

  /// Null when creating a new template.
  final String? templateId;

  @override
  ConsumerState<TemplateEditScreen> createState() => _TemplateEditScreenState();
}

class _TemplateEditScreenState extends ConsumerState<TemplateEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _pattern = TextEditingController();
  final _estimate = TextEditingController();
  final _flatRate = TextEditingController();
  final _target = TextEditingController();
  final List<_StepDraft> _steps = [];
  String? _defaultCustomerId;
  bool _favorite = true;
  bool _loading = false;

  bool get _isNew => widget.templateId == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final t = await ref
        .read(templatesRepositoryProvider)
        .getTemplate(widget.templateId!);
    if (!mounted) return;
    if (t != null) {
      _name.text = t.name;
      _pattern.text = t.titlePattern;
      _estimate.text = t.estimate?.toString() ?? '';
      _flatRate.text = t.flatRateAe?.toString() ?? '';
      _target.text = t.targetMinutes?.toString() ?? '';
      _defaultCustomerId = t.defaultCustomerId;
      _favorite = t.isFavorite;
      _steps.addAll([
        for (final d in ChecklistDraft.decodeList(t.checklist))
          _StepDraft(d.label, required: d.required),
      ]);
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [_name, _pattern, _estimate, _flatRate, _target]) {
      c.dispose();
    }
    for (final s in _steps) {
      s.controller.dispose();
    }
    super.dispose();
  }

  int? _int(TextEditingController c) => int.tryParse(c.text.trim());

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _name.text.trim();
    final pattern = _pattern.text.trim();
    final steps = [
      for (final s in _steps)
        if (s.controller.text.trim().isNotEmpty)
          ChecklistDraft(s.controller.text.trim(), required: s.required),
    ];
    await ref
        .read(templatesRepositoryProvider)
        .saveTemplate(
          TemplatesCompanion(
            id: _isNew ? const Value.absent() : Value(widget.templateId!),
            name: Value(name),
            titlePattern: Value(pattern.isEmpty ? name : pattern),
            checklist: Value(
              steps.isEmpty ? null : ChecklistDraft.encodeList(steps),
            ),
            defaultCustomerId: Value(_defaultCustomerId),
            estimate: Value(_int(_estimate)),
            flatRateAe: Value(_int(_flatRate)),
            targetMinutes: Value(_int(_target)),
            isFavorite: Value(_favorite),
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context, 'Vorlage')) return;
    await ref
        .read(templatesRepositoryProvider)
        .deleteTemplate(widget.templateId!);
    if (mounted) context.pop();
  }

  InputDecoration _deco(String label, {String? helper}) => InputDecoration(
    labelText: label,
    helperText: helper,
    border: const OutlineInputBorder(),
  );

  Widget _numberField(TextEditingController c, String label) => TextFormField(
    controller: c,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: _deco(label),
  );

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'Neue Vorlage' : 'Vorlage bearbeiten'),
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
                    decoration: _deco('Name'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Bitte einen Namen eingeben'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pattern,
                    decoration: _deco(
                      'Titelmuster',
                      helper:
                          'Platzhalter: ${TitlePlaceholders.customer} und '
                          '${TitlePlaceholders.date}. Leer = Name.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    initialValue:
                        customers.any((c) => c.id == _defaultCustomerId)
                        ? _defaultCustomerId
                        : null,
                    decoration: _deco('Standard-Kunde'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Beim Start fragen'),
                      ),
                      for (final c in customers)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => setState(() => _defaultCustomerId = v),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _numberField(_estimate, 'Schätzung (min)'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _numberField(_flatRate, 'Pauschale (AE)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _numberField(_target, 'Sollzeit (min)'),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Favorit (Schnellstart beim Erfassen)'),
                    value: _favorite,
                    onChanged: (v) => setState(() => _favorite = v),
                  ),
                  SectionHeader(
                    'Checkliste',
                    trailing: IconButton(
                      tooltip: 'Schritt hinzufügen',
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          setState(() => _steps.add(_StepDraft(''))),
                    ),
                  ),
                  if (_steps.isEmpty)
                    const ListTile(title: Text('Noch keine Schritte')),
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorder: (oldIndex, newIndex) => setState(() {
                      if (newIndex > oldIndex) newIndex--;
                      _steps.insert(newIndex, _steps.removeAt(oldIndex));
                    }),
                    children: [
                      for (final (i, s) in _steps.indexed)
                        Padding(
                          key: s.key,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: s.controller,
                                  decoration: InputDecoration(
                                    hintText: 'Schritt ${i + 1}',
                                    isDense: true,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: s.required
                                    ? 'Pflichtschritt (antippen zum Entfernen)'
                                    : 'Als Pflicht markieren',
                                icon: Icon(
                                  s.required
                                      ? Icons.error
                                      : Icons.error_outline,
                                ),
                                onPressed: () =>
                                    setState(() => s.required = !s.required),
                              ),
                              IconButton(
                                tooltip: 'Schritt entfernen',
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => setState(() {
                                  _steps.removeAt(i).controller.dispose();
                                }),
                              ),
                              ReorderableDragStartListener(
                                index: i,
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.drag_handle),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
