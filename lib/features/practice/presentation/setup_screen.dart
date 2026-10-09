import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pip_misc.dart';
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
  bool _isListening = false;
  String _selectedMicrophone = 'Built-in Microphone (Default)';
  String _selectedCamera = 'Front Camera (Wide HD)';
  String _transcript = '';
  CameraController? _cameraController;
  final _speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    unawaited(_initializeCamera());
    unawaited(_initializeSpeech());
  }

  @override
  void dispose() {
    if (_isListening) unawaited(_speech.stop());
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _cameraController = controller);
    } on CameraException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Camera unavailable: ${error.description ?? error.code}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _initializeSpeech() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (mounted && (status == 'done' || status == 'notListening')) {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _isMicOn = false;
          });
        }
      },
    );
    if (!available && mounted) {
      setState(() => _isMicOn = false);
    }
  }

  Future<void> _toggleMicrophone(bool enabled) async {
    if (!enabled) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final initialized = await _speech.initialize();
    if (!initialized || !mounted) {
      if (mounted) {
        setState(() => _isMicOn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Speech recognition is not available. Enable Google Voice '
              'Typing or install a speech recognition service.',
            ),
          ),
        );
      }
      return;
    }

    final locales = await _speech.locales();
    final preferred = locales.where(
      (locale) =>
          locale.localeId.toLowerCase().startsWith('fil') ||
          locale.localeId.toLowerCase().startsWith('en'),
    );
    setState(() {
      _isListening = true;
      _isMicOn = true;
      _transcript = '';
    });
    await _speech.listen(
      onResult: _onSpeechResult,
      listenOptions: SpeechListenOptions(
        localeId: preferred.isNotEmpty ? preferred.first.localeId : null,
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 4),
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      _transcript = result.recognizedWords;
      if (result.finalResult) _isListening = false;
    });
  }

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
      appBar: pipAppBar(context, title: 'Practice Setup'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),

              // Live camera & mic preview
              CameraPreviewWidget(
                isCameraOn: _isCameraOn,
                isMicOn: _isMicOn,
                controller: _cameraController,
                onToggleCamera: (val) => setState(() => _isCameraOn = val),
                onToggleMic: (val) {
                  setState(() => _isMicOn = val);
                  unawaited(_toggleMicrophone(val));
                },
              ),
              if (_transcript.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _isListening ? Icons.graphic_eq : Icons.check_circle,
                        color: _isListening
                            ? AppColors.secondary
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _transcript,
                          style: const TextStyle(color: AppColors.ink),
                        ),
                      ),
                    ],
                  ),
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
                      text:
                          'Keep your device at eye level for confident contact',
                    ),
                    SizedBox(height: 6),
                    _ChecklistItem(
                      text:
                          'Speak in a quiet space with minimal background echo',
                    ),
                    SizedBox(height: 6),
                    _ChecklistItem(
                      text:
                          '10-second countdown gives you time to breathe and focus',
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
