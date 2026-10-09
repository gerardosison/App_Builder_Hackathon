import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Interactive live camera & microphone setup preview
class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({
    super.key,
    this.isCameraOn = true,
    this.isMicOn = true,
    this.onToggleCamera,
    this.onToggleMic,
  });

  final bool isCameraOn;
  final bool isMicOn;
  final ValueChanged<bool>? onToggleCamera;
  final ValueChanged<bool>? onToggleMic;

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.navy, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1814213D),
            offset: Offset(4, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Camera feed simulation or "Camera Off" state
            Positioned.fill(
              child: widget.isCameraOn
                  ? _buildCameraFeed()
                  : _buildCameraOffState(),
            ),

            // Face positioning guideline oval
            if (widget.isCameraOn)
              Center(
                child: Container(
                  width: 140,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Center face here',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

            // Top Status Bar: Camera & Mic Indicators
            Positioned(
              top: 14,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.isCameraOn ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isCameraOn ? 'Video: Live HD' : 'Video: Off',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                          size: 14,
                          color: widget.isMicOn ? AppColors.yellow : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isMicOn ? 'Mic: Active' : 'Mic: Muted',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Audio Meter and Toggles
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.graphic_eq_rounded,
                      color: AppColors.yellow,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    // Live audio frequency bars
                    Expanded(
                      child: widget.isMicOn
                          ? AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, _) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(14, (index) {
                                  final phase = (index / 14) * math.pi;
                                  final animVal = math.sin(
                                    _pulseController.value * math.pi + phase,
                                  ).abs();
                                  final barHeight = 4.0 + (animVal * 16.0);
                                  return Container(
                                    width: 3.5,
                                    height: barHeight,
                                    decoration: BoxDecoration(
                                      color: index > 10
                                          ? AppColors.coral
                                          : (index > 7
                                              ? AppColors.yellow
                                              : Colors.greenAccent),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              ),
                            )
                          : const Text(
                              'Microphone muted',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Camera Toggle
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        widget.isCameraOn
                            ? Icons.videocam_rounded
                            : Icons.videocam_off_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () =>
                          widget.onToggleCamera?.call(!widget.isCameraOn),
                      tooltip: 'Toggle Camera',
                    ),
                    const SizedBox(width: 4),
                    // Mic Toggle
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      icon: Icon(
                        widget.isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () =>
                          widget.onToggleMic?.call(!widget.isMicOn),
                      tooltip: 'Toggle Mic',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraFeed() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 48,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Speaker Camera Preview',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraOffState() {
    return Container(
      color: const Color(0xFF111827),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off_rounded, size: 48, color: Colors.white38),
            SizedBox(height: 8),
            Text(
              'Camera is turned off',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

