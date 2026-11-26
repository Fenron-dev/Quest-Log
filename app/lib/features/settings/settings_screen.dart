import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(themeSettingsProvider).value ?? const ThemeSettings();
    final notifier = ref.read(themeSettingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Darstellung', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Text('Theme', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<ThemeChoice>(
            showSelectedIcon: false,
            segments: [
              for (final choice in ThemeChoice.values)
                ButtonSegment(value: choice, label: Text(choice.label)),
            ],
            selected: {settings.theme},
            onSelectionChanged: (s) => notifier.setTheme(s.first),
          ),
          const SizedBox(height: 20),
          Text('Akzentfarbe', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final accent in AccentChoice.values)
                _AccentButton(
                  accent: accent,
                  selected: accent == settings.accent,
                  onTap: () => notifier.setAccent(accent),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccentButton extends StatelessWidget {
  const _AccentButton({
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final AccentChoice accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor =
        ThemeData.estimateBrightnessForColor(accent.color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    // Selection is shown by a check mark and the label, not by colour alone.
    return Semantics(
      button: true,
      selected: selected,
      label: accent.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppTheme.minTapTarget,
                height: AppTheme.minTapTarget,
                decoration: BoxDecoration(
                  color: accent.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: selected ? 3 : 0,
                    style: selected ? BorderStyle.solid : BorderStyle.none,
                  ),
                ),
                child: selected ? Icon(Icons.check, color: onColor) : null,
              ),
              const SizedBox(height: 4),
              Text(
                accent.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: selected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
