import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Full-screen mock cartoon audience widget representing auditorium viewers
class MockCartoonAudienceBackground extends StatefulWidget {
  const MockCartoonAudienceBackground({super.key});

  @override
  State<MockCartoonAudienceBackground> createState() =>
      _MockCartoonAudienceBackgroundState();
}

class _MockCartoonAudienceBackgroundState
    extends State<MockCartoonAudienceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swayController;

  @override
  void initState() {
    super.initState();
    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _swayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Auditorium background with spotlight gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.2,
              colors: [
                Color(0xFF2E3E5C), // warm spotlight center
                Color(0xFF14213D), // deep auditorium navy
                Color(0xFF0A0F1D), // auditorium shadows
              ],
            ),
          ),
        ),

        // Auditorium seating rows & cartoon audience characters
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _swayController,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Row 3 (Back row - smaller characters)
                  Transform.translate(
                    offset: Offset(
                      math.sin(_swayController.value * math.pi) * 3,
                      0,
                    ),
                    child: _buildAudienceRow(
                      scale: 0.72,
                      opacity: 0.7,
                      characters: const [
                        _AudienceMember(
                          hairColor: Color(0xFF6B4226),
                          skinColor: Color(0xFFF3C5A5),
                          shirtColor: AppColors.coral,
                          hasGlasses: true,
                          expression: '😊',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF222222),
                          skinColor: Color(0xFFC68642),
                          shirtColor: AppColors.blue,
                          hasGlasses: false,
                          expression: '🧐',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFFD4AF37),
                          skinColor: Color(0xFFFFDFC4),
                          shirtColor: AppColors.mint,
                          hasGlasses: false,
                          expression: '👏',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF8B4513),
                          skinColor: Color(0xFF8D5524),
                          shirtColor: AppColors.yellow,
                          hasGlasses: true,
                          expression: '💡',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF1A1A1A),
                          skinColor: Color(0xFFE0AC69),
                          shirtColor: Color(0xFF9370DB),
                          hasGlasses: false,
                          expression: '📝',
                        ),
                      ],
                    ),
                  ),

                  // Auditorium seat divider 2
                  _buildSeatRowBar(color: const Color(0xFF1E293B)),

                  // Row 2 (Middle row)
                  Transform.translate(
                    offset: Offset(
                      math.cos(_swayController.value * math.pi) * 4,
                      0,
                    ),
                    child: _buildAudienceRow(
                      scale: 0.88,
                      opacity: 0.88,
                      characters: const [
                        _AudienceMember(
                          hairColor: Color(0xFF1F2937),
                          skinColor: Color(0xFFF1C27D),
                          shirtColor: AppColors.yellow,
                          hasGlasses: false,
                          expression: '👀',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFFB45309),
                          skinColor: Color(0xFFFFDBAC),
                          shirtColor: AppColors.mint,
                          hasGlasses: true,
                          expression: '😃',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF111827),
                          skinColor: Color(0xFF8D5524),
                          shirtColor: AppColors.sky,
                          hasGlasses: false,
                          expression: '✨',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF4B5563),
                          skinColor: Color(0xFFE0AC69),
                          shirtColor: AppColors.coral,
                          hasGlasses: true,
                          expression: '👂',
                        ),
                      ],
                    ),
                  ),

                  // Auditorium seat divider 1
                  _buildSeatRowBar(color: const Color(0xFF0F172A)),

                  // Row 1 (Front row - prominent cartoon audience)
                  Transform.translate(
                    offset: Offset(
                      math.sin((1 - _swayController.value) * math.pi) * 5,
                      0,
                    ),
                    child: _buildAudienceRow(
                      scale: 1.08,
                      opacity: 1.0,
                      characters: const [
                        _AudienceMember(
                          hairColor: Color(0xFF78350F),
                          skinColor: Color(0xFFFFDFC4),
                          shirtColor: AppColors.blue,
                          hasGlasses: false,
                          expression: '🎯',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFF0F172A),
                          skinColor: Color(0xFFC68642),
                          shirtColor: AppColors.yellow,
                          hasGlasses: true,
                          expression: '👍',
                        ),
                        _AudienceMember(
                          hairColor: Color(0xFFD97706),
                          skinColor: Color(0xFFF5D0C5),
                          shirtColor: AppColors.mint,
                          hasGlasses: false,
                          expression: '🌟',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 70), // space above bottom controls
                ],
              );
            },
          ),
        ),

        // Stage lighting warm highlight at bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 90,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.navy.withValues(alpha: 0.95),
                  AppColors.navy.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudienceRow({
    required double scale,
    required double opacity,
    required List<_AudienceMember> characters,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: characters,
        ),
      ),
    );
  }

  Widget _buildSeatRowBar({required Color color}) {
    return Container(
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

/// Cartoon Audience Member individual widget
class _AudienceMember extends StatelessWidget {
  const _AudienceMember({
    required this.hairColor,
    required this.skinColor,
    required this.shirtColor,
    required this.hasGlasses,
    required this.expression,
  });

  final Color hairColor;
  final Color skinColor;
  final Color shirtColor;
  final bool hasGlasses;
  final String expression;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Character Head with Hair and Face
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Hair background/shape
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: hairColor,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            // Face
            Positioned(
              top: 8,
              child: Container(
                width: 42,
                height: 40,
                decoration: BoxDecoration(
                  color: skinColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26, width: 1.2),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Eyes or Glasses
                      if (hasGlasses)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.navy, width: 2),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white24,
                          ),
                          child: const Text('👓', style: TextStyle(fontSize: 10)),
                        )
                      else
                        Text(expression, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // Shoulders / Shirt
        Container(
          width: 68,
          height: 38,
          decoration: BoxDecoration(
            color: shirtColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.black26, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 14,
              height: 8,
              decoration: BoxDecoration(
                color: skinColor,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

