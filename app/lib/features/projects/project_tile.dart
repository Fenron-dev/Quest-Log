import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/router.dart';
import '../../core/ui/color_palette.dart';
import 'data/projects_repository.dart';

/// Progress ring in the project's colour with "done/total" in the middle.
class ProjectProgressRing extends StatelessWidget {
  const ProjectProgressRing(this.overview, {super.key, this.size = 44});

  final ProjectOverview overview;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = ColorPalette.resolve(overview.color);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: overview.progress ?? 0,
              strokeWidth: 5,
              color: color,
              backgroundColor: color.withValues(alpha: 0.18),
            ),
          ),
          Text(
            overview.milestonesTotal == 0
                ? '–'
                : '${overview.milestonesDone}/${overview.milestonesTotal}',
            style: TextStyle(
              fontSize: size * 0.24,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  const ProjectTile(this.overview, {super.key, this.showCustomer = true});

  final ProjectOverview overview;
  final bool showCustomer;

  @override
  Widget build(BuildContext context) {
    final p = overview.project;
    final parts = [
      if (showCustomer) overview.customer?.name ?? 'Intern',
      p.status.label,
      if (p.budgetAe != null) '${p.budgetAe} AE Budget',
    ];
    return ListTile(
      minTileHeight: 64,
      leading: ProjectProgressRing(overview),
      title: Text(p.name),
      subtitle: Text(parts.join(' · ')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('${AppRoutes.projects}/${p.id}'),
    );
  }
}
