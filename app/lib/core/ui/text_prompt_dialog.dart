import 'package:material_ui/material_ui.dart';

/// Result of [showTextPrompt]: the entered text and, if offered, whether the
/// checkbox was ticked.
typedef TextPromptResult = ({String text, bool checked});

/// Asks for a single line of text. The controller lives in the dialog's
/// state, so it stays valid during the closing animation.
Future<TextPromptResult?> showTextPrompt(
  BuildContext context, {
  required String title,
  required String label,
  String submitLabel = 'Hinzufügen',
  String? checkboxLabel,
}) {
  return showDialog<TextPromptResult>(
    context: context,
    builder: (_) => _TextPromptDialog(
      title: title,
      label: label,
      submitLabel: submitLabel,
      checkboxLabel: checkboxLabel,
    ),
  );
}

class _TextPromptDialog extends StatefulWidget {
  const _TextPromptDialog({
    required this.title,
    required this.label,
    required this.submitLabel,
    this.checkboxLabel,
  });

  final String title;
  final String label;
  final String submitLabel;
  final String? checkboxLabel;

  @override
  State<_TextPromptDialog> createState() => _TextPromptDialogState();
}

class _TextPromptDialogState extends State<_TextPromptDialog> {
  final _controller = TextEditingController();
  bool _checked = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    Navigator.pop(
      context,
      text.isEmpty ? null : (text: text, checked: _checked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (widget.checkboxLabel != null)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(widget.checkboxLabel!),
              value: _checked,
              onChanged: (v) => setState(() => _checked = v ?? false),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(onPressed: _submit, child: Text(widget.submitLabel)),
      ],
    );
  }
}
