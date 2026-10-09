import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'primary_button.dart';

export 'primary_button.dart' show PrimaryButton;

/// Sky-blue secondary action (light blue surface, navy text).
class PipSecondaryButton extends StatelessWidget {
  const PipSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? AppColors.darkSurface2
        : AppColors.secondaryFixed.withValues(alpha: 0.55);
    final fg = isDark ? AppColors.secondaryFixed : AppColors.navy;
    return PrimaryButton(
      label: label,
      icon: icon,
      expanded: expanded,
      onPressed: onPressed,
      color: bg,
      foreground: fg,
    );
  }
}

/// Transparent ghost action (tertiary) — navy label, no outline.
class PipGhostButton extends StatelessWidget {
  const PipGhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? Theme.of(context).colorScheme.primary;
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, size: 18, color: fg)
          : const SizedBox.shrink(),
      label: Text(label, style: TextStyle(color: fg)),
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: fg,
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
