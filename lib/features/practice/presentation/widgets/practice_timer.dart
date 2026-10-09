import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Floating Speech Timer widget that keeps track of the speech time (MM:SS)
class PracticeTimerWidget extends StatelessWidget {
  const PracticeTimerWidget({
    super.key,
    required this.elapsedSeconds,
  });

  final int elapsedSeconds;

  String get _formattedTime {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blinking red recording indicator dot
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.coral,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.timer_outlined,
            size: 16,
            color: Colors.white70,
          ),
          const SizedBox(width: 6),
          Text(
            _formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 1.2,
              fontFeatures: [],
            ),
          ),
        ],
      ),
    );
  }
}

