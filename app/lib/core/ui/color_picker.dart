import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import 'color_palette.dart';

/// Grid of palette swatches. If [inheritLabel] is set, an extra option that
/// represents `null` (e.g. "inherit from customer") is shown first.
class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.inheritLabel,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final String? inheritLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (inheritLabel != null)
          _Swatch(
            label: inheritLabel!,
            color: null,
            selected: value == null,
            onTap: () => onChanged(null),
          ),
        for (final c in ColorPalette.colors)
          _Swatch(
            label: c.label,
            color: c.color,
            selected: value == c.value,
            onTap: () => onChanged(c.value),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = color ?? scheme.surface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppTheme.minTapTarget,
                  height: AppTheme.minTapTarget,
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? scheme.onSurface : scheme.outline,
                      width: selected ? 3 : 1,
                    ),
                  ),
                  child: selected
                      ? Icon(
                          Icons.check,
                          color: color == null
                              ? scheme.onSurface
                              : ColorPalette.onColor(fill),
                        )
                      : (color == null
                            ? Icon(Icons.link, color: scheme.onSurfaceVariant)
                            : null),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontWeight: selected ? FontWeight.bold : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
