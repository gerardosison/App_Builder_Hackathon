import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../practice/presentation/widgets/audience_character.dart';

/// Audience-reaction tile on the session report — the pose/eye-contact
/// story told through the simulated crowd.
class PoseFeedbackCard extends StatelessWidget {
  const PoseFeedbackCard({super.key, required this.members});

  final List<AudienceMember> members;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow(1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Audience reaction',
            style: text.labelMedium
                ?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 6),
        AudienceStrip(members: members, avatarSize: 30),
      ]),
    );
  }
}
