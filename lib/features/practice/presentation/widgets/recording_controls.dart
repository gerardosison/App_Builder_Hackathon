import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Recording Controls with X button at the bottom middle to end the speech
class RecordingControlsWidget extends StatelessWidget {
  const RecordingControlsWidget({
    super.key,
    required this.onEndSpeech,
  });

  final VoidCallback onEndSpeech;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large circular X button to end speech
        GestureDetector(
          onTap: onEndSpeech,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.coral,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.coral.withValues(alpha: 0.45),
                  blurRadius: 18,
                  spreadRadius: 3,
                  offset: const Offset(0, 4),
                ),
                const BoxShadow(
                  color: Color(0x2214213D),
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'End Speech',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

