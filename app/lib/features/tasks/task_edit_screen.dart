import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/ui/date_field.dart';
import '../../core/ui/empty_state.dart';
import '../customers/data/customers_repository.dart';
import '../projects/data/projects_repository.dart';
import 'data/tasks_repository.dart';

class TaskEditScreen extends ConsumerStatefulWidget {
  const TaskEditScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends ConsumerState<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _estimate = TextEditingController();
  final _waitingFor = TextEditingController();
  final _tags = TextEditingController();
  TaskStatus _status = TaskStatus.inbox;
  bool _important = false;
  String? _customerId;
  String? _projectId;
  String? _milestoneId;
  DateTime? _plannedDay;
  DateTime? _due;
  DateTime? _followUp;
  TaskSource? _source;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final t = await ref.read(tasksRepositoryProvider).getTask(widget.taskId);
    if (!mounted) return;
    if (t != null) {
      _title.text = t.title;
      _estimate.text = t.estimateMin?.toString() ?? '';
      _waitingFor.text = t.waitingFor ?? '';
      _tags.text = decodeTags(t.tags).join(', ');
      _status = t.status;
      _important = t.important;
      _customerId = t.customerId;
      _projectId = t.projectId;
      _milestoneId = t.milestoneId;
      _plannedDay = t.plannedDay;
      _due = t.due;
      _followUp = t.followUpDate;
      _source = t.source;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _title.dispose();
    _estimate.dispose();
    _waitingFor.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final waiting = _status == TaskStatus.waitingFor;
    try {
      await ref
          .read(tasksRepositoryProvider)
          .saveTask(
            TasksCompanion(
              id: Value(widget.taskId),
              title: Value(_title.text.trim()),
              status: Value(_status),
              important: Value(_important),
              customerId: Value(_customerId),
              projectId: Value(_projectId),
              milestoneId: Value(_projectId == null ? null : _milestoneId),
              plannedDay: Value(_plannedDay),
              due: Value(_due),
              estimateMin: Value(int.tryParse(_estimate.text.trim())),
              source: Value(_source),
              tags: Value(encodeTags(_tags.text.split(','))),
              waitingFor: waiting
                  ? Value(_waitingFor.text.trim())
                  : const Value.absent(),
              followUpDate: waiting ? Value(_followUp) : const Value.absent(),
            ),
          );
      if (mounted) context.pop();
    } on TaskValidationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context, 'Aufgabe')) return;
    await ref.read(tasksRepositoryProvider).deleteTask(widget.taskId);
    if (!mounted) return;
    // Leave both the edit and the detail page.
    context.pop();
    if (context.canPop()) context.pop();
  }

  InputDecoration _deco(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(allCustomersProvider).value ?? const [];
    final projects = (ref.watch(projectListProvider(null)).value ?? const [])
        .where((p) => p.project.customerId == _customerId)
        .toList();
    final milestones = _projectId == null
        ? const <Milestone>[]
        : ref.watch(milestonesProvider(_projectId!)).value ?? const [];
    final projectKnown =
        _projectId == null || projects.any((p) => p.project.id == _projectId);
    final milestoneKnown =
        _milestoneId == null || milestones.any((m) => m.id == _milestoneId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufgabe bearbeiten'),
        actions: [
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
                    controller: _title,
                    decoration: _deco('Titel'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Bitte einen Titel eingeben'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskStatus>(
                    initialValue: _status,
                    decoration: _deco('Status'),
                    items: [
                      for (final s in TaskStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? _status),
                  ),
                  if (_status == TaskStatus.waitingFor) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _waitingFor,
                      decoration: _deco('Wartet auf (wen?)'),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Bitte angeben, auf wen du wartest'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DateField(
                      label: 'Nachfassen am',
                      value: _followUp,
                      onChanged: (d) => setState(() => _followUp = d),
                    ),
                  ],
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Wichtig'),
                    value: _important,
                    onChanged: (v) => setState(() => _important = v),
                  ),
                  DropdownButtonFormField<String?>(
                    initialValue: customers.any((c) => c.id == _customerId)
                        ? _customerId
                        : null,
                    decoration: _deco('Kunde'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Kein Kunde'),
                      ),
                      for (final c in customers)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                    ],
                    onChanged: (v) => setState(() {
                      _customerId = v;
                      _projectId = null;
                      _milestoneId = null;
                    }),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String?>(
                    key: ValueKey('project-$_customerId'),
                    initialValue: projectKnown ? _projectId : null,
                    decoration: _deco(
                      _customerId == null ? 'Internes Projekt' : 'Projekt',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Kein Projekt'),
                      ),
                      for (final p in projects)
                        DropdownMenuItem(
                          value: p.project.id,
                          child: Text(p.project.name),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      _projectId = v;
                      _milestoneId = null;
                    }),
                  ),
                  if (_projectId != null && milestones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      key: ValueKey('milestone-$_projectId'),
                      initialValue: milestoneKnown ? _milestoneId : null,
                      decoration: _deco('Meilenstein'),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Kein Meilenstein'),
                        ),
                        for (final m in milestones)
                          DropdownMenuItem(value: m.id, child: Text(m.title)),
                      ],
                      onChanged: (v) => setState(() => _milestoneId = v),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DateField(
                          label: 'Geplant für',
                          value: _plannedDay,
                          onChanged: (d) => setState(() => _plannedDay = d),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DateField(
                          label: 'Fällig',
                          value: _due,
                          onChanged: (d) => setState(() => _due = d),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _estimate,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _deco('Schätzung (min)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<TaskSource?>(
                          initialValue: _source,
                          decoration: _deco('Quelle'),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('–'),
                            ),
                            for (final s in TaskSource.values)
                              DropdownMenuItem(value: s, child: Text(s.label)),
                          ],
                          onChanged: (v) => setState(() => _source = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tags,
                    decoration: _deco('Schlagwörter (mit Komma getrennt)'),
                  ),
                ],
              ),
            ),
    );
  }
}
