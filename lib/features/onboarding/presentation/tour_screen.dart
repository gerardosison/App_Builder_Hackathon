import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_mascot.dart';
import '../../../core/widgets/pip_misc.dart';

/// Welcome / Tour — 3-slide carousel matching the Stitch onboarding design.
class TourScreen extends StatefulWidget {
  const TourScreen({super.key});

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final _pages = PageController();
  int _index = 0;

  static const _slides = [
    (
      PipAsset.stage,
      'Speak with Confidence',
      'Step onto a friendly virtual stage and rehearse your speech with a supportive AI audience.',
      Icons.mic_external_on,
    ),
    (
      PipAsset.analysis,
      'Real-Time AI Feedback',
      'Pip tracks your pace, filler words, and eye contact — all analyzed privately on your device.',
      Icons.insights,
    ),
    (
      PipAsset.stars,
      'Level Up as an Orator',
      'Earn stars every time you improve, keep your streak alive, and unlock new coaching perks.',
      Icons.auto_stories,
    ),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _slides.length - 1) {
      _pages.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    } else {
      context.go(AppRoutes.personalize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final last = _index == _slides.length - 1;
    return Scaffold(
      body: Stack(children: [
        const AmbientBlobs(),
        SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: PipGhostButton(
                    label: 'Skip',
                    onPressed: () =>
                        context.go(AppRoutes.personalize)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PipMascot(asset: s.$1, size: 180, showBadge: false),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerLowest,
                            borderRadius:
                                BorderRadius.circular(AppTheme.cardRadius),
                            boxShadow: AppColors.cardShadow(2),
                          ),
                          child: Column(children: [
                            Text(s.$2,
                                textAlign: TextAlign.center,
                                style: text.headlineMedium
                                    ?.copyWith(color: scheme.primary)),
                            const SizedBox(height: 10),
                            Text(s.$3,
                                textAlign: TextAlign.center,
                                style: text.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    height: 1.5)),
                          ]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _index
                            ? scheme.primary
                            : scheme.outlineVariant
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                    label: last ? "Let's Start" : 'Next',
                    icon: Icons.arrow_forward,
                    onPressed: _next),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
