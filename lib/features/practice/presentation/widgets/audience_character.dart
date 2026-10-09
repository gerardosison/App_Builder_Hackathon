import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Simulated audience member for the live room.
enum AudienceMood { smiling, nodding, neutral, applauding, leaning }

class AudienceMember {
  const AudienceMember(this.emoji, this.mood, this.tint);
  final String emoji;
  final AudienceMood mood;
  final Color tint;
}

/// Horizontal strip of cartoon audience avatars that "react" to the
/// speech.
class AudienceStrip extends StatelessWidget {
  const AudienceStrip({
    super.key,
    required this.members,
    this.avatarSize = 40,
    this.caption,
  });

  final List<AudienceMember> members;
  final double avatarSize;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          SizedBox(
            height: avatarSize,
            width: math.min(
                members.length * (avatarSize * 0.72) + avatarSize * 0.3,
                160),
            child: Stack(
              children: [
                for (var i = 0; i < members.length; i++)
                  Positioned(
                    left: i * avatarSize * 0.72,
                    child: Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: members[i].tint,
                        border: Border.all(
                            color: scheme.surfaceContainerLowest,
                            width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(members[i].emoji,
                          style:
                              TextStyle(fontSize: avatarSize * 0.45)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (caption != null)
            Expanded(
              child: Text(caption!,
                  style: text.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ),
        ],
      ),
    );
  }
}

/// Default mock audience roster.
List<AudienceMember> mockAudience([int extra = 12]) => [
      const AudienceMember(
          '😊', AudienceMood.smiling, AppColors.secondaryFixed),
      const AudienceMember(
          '👀', AudienceMood.leaning, AppColors.tertiaryFixed),
      const AudienceMember('👏', AudienceMood.applauding,
          AppColors.secondaryContainer),
      const AudienceMember(
          '🙂', AudienceMood.nodding, AppColors.primaryFixed),
      AudienceMember('+$extra', AudienceMood.neutral,
          AppColors.primaryFixedDim),
    ];
