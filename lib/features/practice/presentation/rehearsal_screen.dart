import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_buttons.dart';
import '../../../core/widgets/pip_chips.dart';
import 'widgets/audience_character.dart';
import 'widgets/camera_preview.dart';
import 'widgets/live_meters.dart';
import 'widgets/waveform.dart';

/// Live Rehearsal Room — camera-preview variant with mute/camera toggles
/// and "End & Analyze" CTA (Stitch `live_practice_rehearsal_room`).
/// The camera feed is a placeholder; real preview plugs into
/// `PermissionService`/camera controller later.
class RehearsalScreen extends StatefulWidget {
  const RehearsalScreen({super.key});

  @override
  State<RehearsalScreen> createState() => _RehearsalScreenState();
}

class _RehearsalScreenState extends State<RehearsalScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _ticker;
  int _elapsed = 0;
  bool _muted = false;
  bool _cameraOn = true;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _ticker = Timer.periodic(
        const Duration(seconds: 1), (_) => setState(() => _elapsed++));
  }

  @override
  void dispose() {
    _pulse.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  String get _clock =>
      '${(_elapsed ~/ 60).toString().padLeft(2, '0')}:${(_elapsed % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: SafeArea(
        child: Column(children: [
          // Header: recording state + switch to stage view
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(children: [
              PipBadge(
                  label: 'LIVE • $_clock',
                  icon: Icons.fiber_manual_record,
                  background: AppColors.errorContainer,
                  foreground: AppColors.error),
              const Spacer(),
              const PipBadge(
                  label: 'Rehearsal Room',
                  icon: Icons.videocam,
                  background: AppColors.secondaryFixed,
                  foreground: AppColors.navy),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Switch to virtual stage',
                onPressed: () =>
                    context.pushReplacement(AppRoutes.practiceLive),
                icon: const Icon(Icons.theater_comedy,
                    color: AppColors.secondaryFixed),
                style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48)),
              ),
            ]),
          ),

          // Camera preview placeholder
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(children: [
                Positioned.fill(
                    child:
                    const Center(
                      child: Text(
                        'Camera Preview',
                        style: TextStyle(
                          color: AppColors.navySoft,
                          fontSize: 18,
                        ),
                      ),
                    )),
                // Mini waveform overlay
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: _muted
                      ? const SizedBox.shrink()
                      : VocalWaveform(
                          animation: _pulse,
                          height: 26,
                          barCount: 32,
                          color: AppColors.mint),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),

          // Audience + telemetry row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
             
              const SizedBox(height: 10),
              const Row(children: [
                Expanded(
                    child: LiveMetricPill(
                        icon: Icons.speed,
                        value: '134',
                        label: 'WPM',
                        tint: AppColors.darkSurface3,
                        onTint: AppColors.mint)),
                SizedBox(width: 8),
                Expanded(
                    child: LiveMetricPill(
                        icon: Icons.bubble_chart,
                        value: '2',
                        label: 'Fillers',
                        tint: AppColors.darkSurface3,
                        onTint: AppColors.secondaryFixed)),
                SizedBox(width: 8),
                Expanded(
                    child: LiveMetricPill(
                        icon: Icons.front_hand,
                        value: 'Good',
                        label: 'Posture',
                        tint: AppColors.darkSurface3,
                        onTint: AppColors.mint)),
              ]),
            ]),
          ),
          const SizedBox(height: 14),

          // Control dock: mute, camera flip, end & analyze
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(children: [
              _roundToggle(
                icon: _muted ? Icons.mic_off : Icons.mic,
                label: _muted ? 'Unmute' : 'Mute',
                active: _muted,
                onTap: () => setState(() => _muted = !_muted),
              ),
              const SizedBox(width: 10),
              _roundToggle(
                icon: _cameraOn ? Icons.videocam : Icons.videocam_off,
                label: _cameraOn ? 'Cam on' : 'Cam off',
                active: !_cameraOn,
                onTap: () => setState(() => _cameraOn = !_cameraOn),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'End & Analyze',
                  icon: Icons.auto_awesome,
                  color: AppColors.secondaryFixed,
                  foreground: AppColors.navy,
                  onPressed: () => context.push(AppRoutes.processing),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _roundToggle(
      {required IconData icon,
      required String label,
      required bool active,
      required VoidCallback onTap}) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.errorContainer
                  : AppColors.darkSurface3,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon,
                  size: 20,
                  color: active
                      ? AppColors.error
                      : AppColors.secondaryFixed),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: active
                          ? AppColors.error
                          : AppColors.secondaryFixed)),
            ]),
          ),
        ),
      ),
    );
  }
}
