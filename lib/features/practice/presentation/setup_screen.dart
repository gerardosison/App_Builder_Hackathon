import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'practice_screen.dart';
import 'widgets/camera_preview.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    super.key,
    this.speechTopic = 'Tell a story in 60 seconds',
  });

  final String speechTopic;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _isCameraOn = true;
  bool _isMicOn = true;
  String _selectedMicrophone = 'Built-in Microphone (Default)';
  String _selectedCamera = 'Front Camera (Wide HD)';

  void _proceedToCountdown() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PracticeScreen(
          speechTopic: widget.speechTopic,
          isCameraInitiallyOn: _isCameraOn,
          isMicInitiallyOn: _isMicOn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setup Video & Mic',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Topic Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.navy, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.record_voice_over_rounded,
                        color: AppColors.navy,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT SPEECH TOPIC',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.blue,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.speechTopic,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Step 1 Guide text
              const Text(
                'Step 1: Video & Mic Setup',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check your framing and audio before going live',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 16),

              // Live camera & mic preview
              CameraPreviewWidget(
                isCameraOn: _isCameraOn,
                isMicOn: _isMicOn,
                onToggleCamera: (val) => setState(() => _isCameraOn = val),
                onToggleMic: (val) => setState(() => _isMicOn = val),
              ),
              const SizedBox(height: 20),

              // Device Selector Cards
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  children: [
                    // Camera device
                    Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCamera,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Front Camera (Wide HD)',
                                  child: Text('Front Camera (Wide HD)'),
                                ),
                                DropdownMenuItem(
                                  value: 'Back Camera',
                                  child: Text('Back Camera'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCamera = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: AppColors.line),
                    // Microphone device
                    Row(
                      children: [
                        const Icon(
                          Icons.mic_none_rounded,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedMicrophone,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Built-in Microphone (Default)',
                                  child: Text('Built-in Microphone (Default)'),
                                ),
                                DropdownMenuItem(
                                  value: 'Bluetooth Headset Mic',
                                  child: Text('Bluetooth Headset Mic'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedMicrophone = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Preparation Guidelines Checklist
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRE-SPEECH CHECKLIST',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navySoft,
                        letterSpacing: 0.6,
                      ),
                    ),
                    SizedBox(height: 8),
                    _ChecklistItem(
                      text: 'Keep your device at eye level for confident contact',
                    ),
                    SizedBox(height: 6),
                    _ChecklistItem(
                      text: 'Speak in a quiet space with minimal background echo',
                    ),
                    SizedBox(height: 6),
                    _ChecklistItem(
                      text: '10-second countdown gives you time to breathe and focus',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Proceed button
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _proceedToCountdown,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text(
                    'Proceed to Countdown',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}

