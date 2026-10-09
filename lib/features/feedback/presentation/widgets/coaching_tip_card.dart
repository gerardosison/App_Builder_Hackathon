import 'package:flutter/material.dart';

import '../../../../core/widgets/pip_cards.dart';

/// A single coaching tip row — icon disc + body text, used inside the
/// "Pip's tips" / "What landed" cards on the feedback screens.
class CoachingTipCard extends StatelessWidget {
  const CoachingTipCard({
    super.key,
    required this.body,
    this.icon = Icons.lightbulb,
    this.iconTint,
    this.iconForeground,
  });

  final String body;
  final IconData icon;
  final Color? iconTint;
  final Color? iconForeground;

  /// "Coach Pip" banner variant (delegates to the shared widget).
  static Widget banner({
    required String label,
    required String message,
    IconData icon = Icons.auto_awesome,
  }) =>
      CoachTipCard(label: label, message: message, icon: icon);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconTint ?? scheme.secondaryContainer,
          ),
          child: Icon(icon,
              size: 16,
              color: iconForeground ?? scheme.onSecondaryContainer),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(body,
                style: text.bodyMedium
                    ?.copyWith(color: scheme.onSurface)),
          ),
        ),
      ]),
    );
  }
}
