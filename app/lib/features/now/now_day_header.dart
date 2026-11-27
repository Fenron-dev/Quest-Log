import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../time/day_bar.dart' show gapColor;
import '../time/day_summary.dart';

/// Pill switch between Jetzt and Mein Tag, with a dot when today has
/// unassigned gaps, and the settings gear.
class NowDayHeader extends ConsumerWidget {
  const NowDayHeader({super.key, required this.showingDay});

  final bool showingDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(daySummaryProvider(ref.watch(todayProvider)));
    final hasGaps = summary?.gaps.isNotEmpty ?? false;
    final scheme = Theme.of(context).colorScheme;

    Widget segment(String label, bool selected, String route, {Widget? badge}) {
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          child: Material(
            color: selected ? scheme.surface : Colors.transparent,
            elevation: selected ? 1 : 0,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: selected ? null : () => context.go(route),
              child: SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    if (badge != null) ...[const SizedBox(width: 8), badge],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                segment('Jetzt', !showingDay, AppRoutes.now),
                segment(
                  'Mein Tag',
                  showingDay,
                  AppRoutes.myDay,
                  badge: hasGaps
                      ? Semantics(
                          label: 'offene Lücken',
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: gapColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: 'Einstellungen',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.go('${AppRoutes.now}/settings'),
        ),
      ],
    );
  }
}
