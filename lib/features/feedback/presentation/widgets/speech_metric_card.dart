import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Small score tile used on the session report (icon disc + value +
/// label), e.g. "142 WPM pace".
class SpeechMetricCard extends StatelessWidget {
  const SpeechMetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow(1),
      ),
      child: Column(children: [
        Container(
          width: 36,
          height: 36,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: tint),
          child: Icon(icon, size: 18, color: AppColors.navy),
        ),
        const SizedBox(height: 6),
        Text(value,
            style: text.labelLarge
                ?.copyWith(fontSize: 18, color: scheme.onSurface)),
        Text(label,
            style: text.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant)),
      ]),
    );
  }
}
