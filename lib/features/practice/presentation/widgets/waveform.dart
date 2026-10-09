import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Animated waveform bars for the vocal meter (driven by an
/// [AnimationController]).
class VocalWaveform extends StatelessWidget {
  const VocalWaveform({
    super.key,
    required this.animation,
    this.barCount = 24,
    this.height = 48,
    this.color = AppColors.mint,
  });

  final Animation<double> animation;
  final int barCount;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(barCount, (i) {
            final phase = animation.value * 2 * math.pi + i * 0.55;
            final h = (0.25 +
                    0.75 *
                        (0.5 +
                            0.5 *
                                math.sin(phase) *
                                math.cos(phase * 0.7))) *
                height;
            return Container(
              width: 4,
              height: h.clamp(6.0, height),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
