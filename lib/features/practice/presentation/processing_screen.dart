import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_mascot.dart';

/// Processing / Analyzing — Pip crunches the take, then routes to the
/// Session Report (no Stitch design — matching style).
class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});

  @override
  ConsumerState<ProcessingScreen> createState() =>
      _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;
  int _step = 0;

  static const _steps = [
    'Listening to your delivery…',
    'Counting pace & pauses…',
    'Spotting filler words…',
    'Writing your feedback…',
  ];

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
    _run();
  }

  Future<void> _run() async {
    final outcome = ref.read(practiceOutcomeProvider);
    final report = await ref.read(feedbackServiceProvider).analyze(
        improved: outcome == PracticeOutcome.improved);
    for (var i = 1; i < _steps.length && mounted; i++) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (mounted) setState(() => _step = i);
    }
    if (!mounted) return;
    ref.read(lastReportProvider.notifier).state = report;
    context.pushReplacement(AppRoutes.sessionReport);
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(alignment: Alignment.center, children: [
              RotationTransition(
                turns: _spin,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.secondaryFixed
                            .withValues(alpha: 0.9),
                        width: 4,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    gradient: const SweepGradient(colors: [
                      AppColors.secondaryFixed,
                      Colors.transparent,
                      AppColors.tertiaryFixed,
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              const PipMascot(
                  asset: PipAsset.analysis,
                  size: 120,
                  showBadge: false),
            ]),
            const SizedBox(height: 28),
            Text('Analyzing your speech…',
                style: text.headlineMedium
                    ?.copyWith(color: scheme.primary)),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(_steps[_step],
                  key: ValueKey(_step),
                  style: text.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.pillRadius),
              child: SizedBox(
                width: 220,
                child: LinearProgressIndicator(
                  value: (_step + 1) / _steps.length,
                  minHeight: 10,
                  backgroundColor: scheme.surfaceContainerHigh,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.secondary),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
