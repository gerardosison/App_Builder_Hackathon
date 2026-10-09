import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    super.key,
    required this.isCameraOn,
    required this.isMicOn,
    required this.onToggleCamera,
    required this.onToggleMic,
  });

  final bool isCameraOn;
  final bool isMicOn;
  final ValueChanged<bool> onToggleCamera;
  final ValueChanged<bool> onToggleMic;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.videocam_off_outlined, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Demo preview — no camera or microphone capture',
              textAlign: TextAlign.center,
            ),
            SwitchListTile(
              title: const Text('Preview camera setting'),
              value: isCameraOn,
              onChanged: onToggleCamera,
            ),
            SwitchListTile(
              title: const Text('Preview microphone setting'),
              value: isMicOn,
              onChanged: onToggleMic,
            ),
          ],
        ),
      ),
    );
  }
}
