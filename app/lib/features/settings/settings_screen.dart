import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/database_provider.dart';
import '../../core/database/sample_data.dart';
import '../../core/settings/view_settings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_settings.dart';
import '../templates/templates_screen.dart';

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
          const SizedBox(height: 28),
          Text('Standard-Ansichten', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Jetzt', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<NowView>(
            showSelectedIcon: false,
            segments: [
              for (final v in NowView.values)
                ButtonSegment(value: v, label: Text(v.label)),
            ],
            selected: {ref.watch(nowViewProvider).value ?? NowView.list},
            onSelectionChanged: (s) =>
                ref.read(nowViewProvider.notifier).set(s.first),
          ),
          const SizedBox(height: 28),
          Text('Aufgaben', style: textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bolt),
            title: const Text('Vorlagen'),
            subtitle: const Text('Titelmuster, Checklisten, Favoriten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(templatesRoute),
          ),
          const SizedBox(height: 20),
          Text('Daten', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.auto_awesome_outlined),
            label: const Text('Beispieldaten laden'),
            onPressed: () async {
              await insertSampleData(ref.read(databaseProvider));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Beispieldaten geladen: Kunden, Projekte, Aufgaben und '
                    'Vorlagen sind jetzt gefüllt.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'Fügt erfundene Kunden, Kontakte, Projekte, Aufgaben und '
            'Vorlagen zum Ausprobieren hinzu.',
            style: textTheme.bodySmall,
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
