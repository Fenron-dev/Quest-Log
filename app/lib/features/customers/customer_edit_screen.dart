import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/routing/router.dart';
import '../../core/ui/color_palette.dart';
import '../../core/ui/color_picker.dart';
import '../../core/ui/empty_state.dart';
import 'data/customers_repository.dart';

class CustomerEditScreen extends ConsumerStatefulWidget {
  const CustomerEditScreen({super.key, this.customerId});

  /// Null when creating a new customer.
  final String? customerId;

  @override
  ConsumerState<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends ConsumerState<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _contingent = TextEditingController();
  final _notes = TextEditingController();
  int? _color = ColorPalette.colors.first.value;
  bool _favorite = false;
  bool _loading = false;

  bool get _isNew => widget.customerId == null;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final c = await ref
        .read(customersRepositoryProvider)
        .getCustomer(widget.customerId!);
    if (!mounted) return;
    if (c != null) {
      _name.text = c.name;
      _address.text = c.address ?? '';
      _contingent.text = c.contingentAePerMonth?.toString() ?? '';
      _notes.text = c.notes ?? '';
      _color = c.color;
      _favorite = c.isFavorite;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _contingent.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final entry = CustomersCompanion(
      id: _isNew ? const Value.absent() : Value(widget.customerId!),
      name: Value(_name.text.trim()),
      address: Value(_nullIfEmpty(_address.text)),
      notes: Value(_nullIfEmpty(_notes.text)),
      contingentAePerMonth: Value(int.tryParse(_contingent.text.trim())),
      color: Value(_color),
      isFavorite: Value(_favorite),
    );
    final id = await ref.read(customersRepositoryProvider).saveCustomer(entry);
    if (!mounted) return;
    if (_isNew) {
      context.pushReplacement('${AppRoutes.customers}/$id');
    } else {
      context.pop();
    }
  }

  Future<void> _delete() async {
    if (!await confirmDelete(context, 'Kunde')) return;
    await ref
        .read(customersRepositoryProvider)
        .deleteCustomer(widget.customerId!);
    if (mounted) context.go(AppRoutes.customers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'Neuer Kunde' : 'Kunde bearbeiten'),
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
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Bitte einen Namen eingeben'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Farbe', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  ColorPicker(
                    value: _color,
                    onChanged: (v) => setState(() => _color = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _address,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Adresse',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contingent,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Kontingent (AE pro Monat)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Favorit'),
                    value: _favorite,
                    onChanged: (v) => setState(() => _favorite = v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notes,
                    minLines: 3,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Notizen',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
