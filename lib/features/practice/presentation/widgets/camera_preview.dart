import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_theme.dart';

/// Placeholder camera preview for the rehearsal room — a posture-frame
/// guide over a dark feed area. The real CameraController preview plugs
/// in here later; UI stays identical.
class CameraPreviewPlaceholder extends StatelessWidget {
  const CameraPreviewPlaceholder({super.key, required this.cameraOn});

  final bool cameraOn;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurface2,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
            color: AppColors.secondaryFixed.withValues(alpha: 0.25),
            width: 2),
      ),
      child: Stack(children: [
        Center(
          child:
              Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(
                cameraOn
                    ? Icons.videocam_outlined
                    : Icons.videocam_off_outlined,
                size: 64,
                color: AppColors.secondaryFixed
                    .withValues(alpha: 0.6)),
            const SizedBox(height: 8),
            Text(
              cameraOn ? 'Camera preview (mock)' : 'Camera off',
              style: text.labelMedium?.copyWith(
                  color: AppColors.secondaryFixed
                      .withValues(alpha: 0.8)),
            ),
          ]),
        ),
        // Posture frame guide
        Center(
          child: Container(
            width: 190,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: AppColors.tertiaryFixed
                      .withValues(alpha: 0.65),
                  width: 3),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      AppColors.tertiaryFixed.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('FRAME YOUR SHOULDERS',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onTertiaryFixed,
                        letterSpacing: 1)),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
