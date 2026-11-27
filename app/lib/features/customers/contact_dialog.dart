import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';

import '../../core/database/app_database.dart';

/// Shows a dialog to create or edit a contact. Returns the companion to save,
/// or null if cancelled.
Future<ContactsCompanion?> showContactDialog(
  BuildContext context, {
  required String customerId,
  Contact? contact,
}) {
  return showDialog<ContactsCompanion>(
    context: context,
    builder: (_) => _ContactDialog(customerId: customerId, contact: contact),
  );
}

class _ContactDialog extends StatefulWidget {
  const _ContactDialog({required this.customerId, this.contact});

  final String customerId;
  final Contact? contact;

  @override
  State<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<_ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.contact?.name);
  late final _role = TextEditingController(text: widget.contact?.role);
  late final _phone = TextEditingController(text: widget.contact?.phone);
  late final _email = TextEditingController(text: widget.contact?.email);

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Value<String?> _opt(TextEditingController c) =>
      Value(c.text.trim().isEmpty ? null : c.text.trim());

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ContactsCompanion(
        id: widget.contact == null
            ? const Value.absent()
            : Value(widget.contact!.id),
        customerId: Value(widget.customerId),
        name: Value(_name.text.trim()),
        role: _opt(_role),
        phone: _opt(_phone),
        email: _opt(_email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    return AlertDialog(
      title: Text(
        widget.contact == null ? 'Neuer Kontakt' : 'Kontakt bearbeiten',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: deco('Name'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Bitte einen Namen eingeben'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _role, decoration: deco('Rolle')),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: deco('Telefon'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: deco('E-Mail'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Speichern')),
      ],
    );
  }
}
