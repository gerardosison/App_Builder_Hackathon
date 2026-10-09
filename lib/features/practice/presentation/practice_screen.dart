import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/app_providers.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_chips.dart';
import '../../../core/widgets/pip_mascot.dart';
import 'widgets/audience_character.dart';
import 'widgets/live_meters.dart';
import 'widgets/practice_timer.dart';
import 'widgets/recording_controls.dart';
import 'widgets/waveform.dart';

/// Live Practice Room — virtual stage, cartoon audience, timer, live
/// pace/filler telemetry, teleprompter peek (Stitch `live_practice_room`).
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() =>
      _PracticeScreenState();
}

class _PracticeScreenState
    extends ConsumerState<PracticeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _ticker;
  int _elapsed = 0;
  bool _paused = false;
  bool _scriptVisible = true;

  // Simulated live telemetry (mock — real values come from Whisper/MediaPipe).
  int _wpm = 128;
  int _fillers = 0;
  final _rng = math.Random(7);

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused || !mounted) return;
      setState(() {
        _elapsed++;
        _wpm = (128 + _rng.nextInt(36) - 14).clamp(95, 175);
        if (_rng.nextDouble() < 0.08) _fillers++;
      });
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  String get _clock =>
      '${(_elapsed ~/ 60).toString().padLeft(2, '0')}:${(_elapsed % 60).toString().padLeft(2, '0')}';

  Future<void> _confirmStop() async {
    final stop = await showDialog<bool>(
      context: context,
      builder: (ctx) => _StopDialog(clock: _clock),
    );
    if (stop == true && mounted) context.push(AppRoutes.processing);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final goal = ref.watch(selectedGoalProvider);
    final goalLabel =
        kGoals.firstWhere((g) => g.id == goal, orElse: () => kGoals.first).label;

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCanvas
              : const Color(0xFFEAF1FB),
      body: SafeArea(
        child: Column(children: [
          // HUD header: timer + coach chip
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(children: [
              PracticeTimer(paused: _paused, clock: _clock),
              const Spacer(),
              PipBadge(
                  label: 'Pace check • $goalLabel',
                  icon: Icons.mic_external_on,
                  background:
                      AppColors.secondaryFixed.withValues(alpha: 0.7),
                  foreground: AppColors.onSecondaryFixedVariant),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Camera rehearsal mode',
                onPressed: () =>
                    context.pushReplacement(AppRoutes.practiceRehearsal),
                icon: Icon(Icons.switch_camera_outlined,
                    color: scheme.primary),
                style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48)),
              ),
            ]),
          ),

          // Stage: virtual podium + audience
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                const SizedBox(height: 6),
                // Stage backdrop
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryContainer
                              .withValues(alpha: 0.95),
                          AppColors.navyDeep,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.cardRadius),
                    ),
                    child: Stack(children: [
                      // Spotlight
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0, -0.6),
                              radius: 0.9,
                              colors: [
                                Colors.white.withValues(alpha: 0.14),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const PipMascot(
                                asset: PipAsset.stage,
                                size: 110,
                                showBadge: false),
                            const SizedBox(height: 8),
                            Text('Virtual Stage',
                                style: text.labelMedium?.copyWith(
                                    color: AppColors.secondaryFixed)),
                          ],
                        ),
                      ),
                      // Teleprompter peek
                      if (_scriptVisible)
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: 0.18)),
                            ),
                            child: Text(
                              '“Factories transformed cities — and the '
                              'people who lived in them. Let\'s look at why…”',
                              textAlign: TextAlign.center,
                              style: text.bodyMedium?.copyWith(
                                  color: Colors.white, height: 1.4),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
                const SizedBox(height: 12),
                // Audience strip
                AudienceStrip(
                    members: mockAudience(),
                    caption:
                        'Audience is engaged — keep that eye contact up!'),
                const SizedBox(height: 12),
                // Live telemetry
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius:
                          BorderRadius.circular(AppTheme.cardRadius),
                      boxShadow: AppColors.cardShadow(1),
                    ),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                          child: LiveMetricPill(
                              icon: Icons.speed,
                              value: '$_wpm',
                              label: 'WPM'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LiveMetricPill(
                              icon: Icons.bubble_chart,
                              value: '$_fillers',
                              label: 'Fillers',
                              tint: _fillers > 6
                                  ? AppColors.errorContainer
                                  : null),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LiveMetricPill(
                              icon: Icons.visibility,
                              value: '78%',
                              label: 'Eye contact',
                              tint: AppColors.secondaryFixed
                                  .withValues(alpha: 0.5)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LiveMeterBar(
                                label: 'Pace',
                                valueLabel: _wpm > 150
                                    ? 'A bit fast'
                                    : 'In the zone',
                                progress: (_wpm - 90) / 100,
                                color: _wpm > 150
                                    ? AppColors.amber
                                    : AppColors.mint),
                            LiveMeterBar(
                                label: 'Filler words',
                                valueLabel: '$_fillers so far',
                                progress: _fillers / 12,
                                color: _fillers > 6
                                    ? AppColors.error
                                    : AppColors.secondaryFixed),
                            Center(
                              child: VocalWaveform(
                                  animation: _pulse,
                                  height: 30,
                                  barCount: 28,
                                  color: AppColors.sky),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),

          // Bottom control dock
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: RecordingControls(
              scriptVisible: _scriptVisible,
              paused: _paused,
              onToggleScript: () =>
                  setState(() => _scriptVisible = !_scriptVisible),
              onTogglePause: () =>
                  setState(() => _paused = !_paused),
              onStop: _confirmStop,
            ),
          ),
        ]),
      ),
    );
  }
}

/// Stop-confirmation dialog (no Stitch design — matching style).
class _StopDialog extends StatelessWidget {
  const _StopDialog({required this.clock});
  final String clock;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('End this take?'),
      icon: const PipMascot(
          asset: PipAsset.happy, size: 72, showBadge: false),
      content: Text(
        'You\'ve been speaking for $clock. Pip will analyze your '
        'delivery and build your feedback report.',
        textAlign: TextAlign.center,
        style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryButton(
                label: 'End & Analyze',
                icon: Icons.auto_awesome,
                onPressed: () => Navigator.of(context).pop(true)),
            const SizedBox(height: 8),
            PipGhostButton(
                label: 'Keep speaking',
                onPressed: () => Navigator.of(context).pop(false)),
          ],
        ),
      ],
    );
  }
}
