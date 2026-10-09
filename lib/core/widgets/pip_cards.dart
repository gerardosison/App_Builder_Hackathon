import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';

/// Standard 24dp-radius surface card with the navy-tinted ambient shadows
/// defined in DESIGN.md (shadows collapse to tonal surfaces in dark mode).
class PipCard extends StatelessWidget {
  const PipCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.elevationLevel = 1,
    this.color,
    this.border,
    this.onTap,
    this.radius = AppTheme.cardRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// 1 = default card, 2 = active feedback card, 3 = modal-like surface.
  final int elevationLevel;
  final Color? color;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        border: border ??
            (isDark
                ? Border.all(color: Colors.white.withValues(alpha: 0.06))
                : null),
        boxShadow: isDark ? null : AppColors.cardShadow(elevationLevel),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: card),
    );
  }
}

/// "Coach Pip" tip card — a pastel speech-bubble panel with an icon + label
/// header and an encouraging quote, as used across home/settings/profile.
class CoachTipCard extends StatelessWidget {
  const CoachTipCard({
    super.key,
    required this.label,
    required this.message,
    this.icon = Icons.tips_and_updates,
    this.trailing,
  });

  final String label;
  final String message;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface2
            : AppColors.secondaryFixed.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkSurface3
              : AppColors.secondaryFixedDim.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: isDark ? AppColors.secondaryFixed : AppColors.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: text.labelMedium?.copyWith(
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.secondaryFixed
                        : AppColors.secondary,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: text.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: isDark ? AppColors.darkOnSurface : AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section heading + optional trailing action ("View All").
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title,
                style: text.headlineSmall?.copyWith(color: scheme.primary),
                overflow: TextOverflow.ellipsis),
          ),
          if (action != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(action!,
                    style: text.labelMedium?.copyWith(
                        color: scheme.secondary, fontWeight: FontWeight.w800)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Rounded icon disc used at the start of list rows (44px per DESIGN.md).
class IconDisc extends StatelessWidget {
  const IconDisc({
    super.key,
    required this.icon,
    this.size = 44,
    this.background,
    this.foreground,
  });

  final IconData icon;
  final double size;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background ??
            scheme.secondaryContainer.withValues(alpha: 0.45),
      ),
      child: Icon(icon,
          size: size * 0.5,
          color: foreground ?? scheme.primary),
    );
  }
}
