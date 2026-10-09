import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';

/// Live metric pill ("142 WPM", "3 fillers") shown in the practice
/// room HUD.
class LiveMetricPill extends StatelessWidget {
  const LiveMetricPill({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.tint,
    this.onTint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? tint;
  final Color? onTint;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = tint ??
        (isDark
            ? AppColors.darkSurface2
            : AppColors.tertiaryFixed.withValues(alpha: 0.5));
    final fg = onTint ?? (isDark ? AppColors.tertiaryFixed : AppColors.navy);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 4),
            Text(value,
                style:
                    text.labelLarge?.copyWith(color: fg, fontSize: 16)),
          ]),
          const SizedBox(height: 2),
          Text(label,
              style: text.labelSmall
                  ?.copyWith(color: fg.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

/// Chunky linear meter (pace / fillers) with a pastel fill.
class LiveMeterBar extends StatelessWidget {
  const LiveMeterBar({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.progress,
    this.color = AppColors.mint,
  });

  final String label;
  final String valueLabel;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: text.labelMedium
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            Text(valueLabel,
                style: text.labelMedium
                    ?.copyWith(color: scheme.primary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          child: SizedBox(
            height: 12,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: scheme.surfaceContainerHigh),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
