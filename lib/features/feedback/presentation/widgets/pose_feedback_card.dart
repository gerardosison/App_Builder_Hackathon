import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Reusable card displaying body language insights (eye contact, posture, gestures)
class PoseFeedbackCard extends StatelessWidget {
  const PoseFeedbackCard({
    super.key,
    required this.eyeContactScore,
    required this.postureEvaluation,
    required this.gestureEvaluation,
  });

  final int eyeContactScore;
  final String postureEvaluation;
  final String gestureEvaluation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.accessibility_new_rounded,
                  color: AppColors.brandForeground(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Body Language & Posture',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandForeground(context),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 1.2),
                ),
                child: const Text(
                  'Strong Presence',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Eye contact bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eye Contact Engagement',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Text(
                '$eyeContactScore%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentForeground(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: eyeContactScore / 100.0,
              minHeight: 6,
              backgroundColor: AppColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.accentForeground(context),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Posture evaluation row
        _buildDetailRow(
          context,
            icon: Icons.airline_seat_recline_normal_rounded,
            title: 'Posture & Head Stability',
            subtitle: postureEvaluation,
          ),
          const SizedBox(height: 10),

          // Gesture evaluation row
        _buildDetailRow(
          context,
            icon: Icons.pan_tool_outlined,
            title: 'Hand & Arm Gestures',
            subtitle: gestureEvaluation,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.secondaryText(context)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText(context),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

