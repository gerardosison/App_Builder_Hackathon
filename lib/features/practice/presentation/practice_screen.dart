import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_providers.dart';
import '../../../app/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/practice_session.dart';
import '../../../core/models/pose_metrics.dart';
import '../../../features/ai/feedback/local_llm_service.dart';
import '../services/audio_recorder_service.dart';
import '../services/pose_camera_session.dart';
import 'widgets/audience_character.dart';
import 'widgets/practice_timer.dart';
import 'widgets/recording_controls.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({
    super.key,
    this.speechTopic = 'Tell a story in 60 seconds',
    this.isCameraInitiallyOn = true,
    this.isMicInitiallyOn = true,
  });

  final String speechTopic;
  final bool isCameraInitiallyOn;
  final bool isMicInitiallyOn;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  // Step 2: Countdown state (10s to 0)
  bool _isCountingDown = true;
  int _countdownSeconds = 10;
  Timer? _countdownTimer;

  // Step 3: Live speech timer
  int _elapsedSpeechSeconds = 0;
  Timer? _speechTimer;

  final AudioRecorderService _audio = AudioRecorderService();
  final PoseCameraSession _poseSession = PoseCameraSession();
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    unawaited(_prepareCamera());
    _startCountdown();
  }

  Future<void> _prepareCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = PoseCameraSession.createCameraController(camera);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraController = controller;
        _cameraDescription = camera;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera unavailable: $error')),
        );
      }
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdownSeconds > 1) {
        setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
        _startLiveSpeech();
      }
    });
  }

  void _startLiveSpeech() {
    setState(() {
      _isCountingDown = false;
      _countdownSeconds = 0;
    });
    unawaited(_startRealCapture());

    // Start speech timer
    _speechTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _elapsedSpeechSeconds++);
    });

  }

  Future<void> _startRealCapture() async {
    try {
      await _audio.startRecording();
      final controller = _cameraController;
      final camera = _cameraDescription;
      if (controller != null && camera != null) {
        await _poseSession.start(controller, camera);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hindi masimulan ang recording/camera: $error')),
        );
      }
    }
  }

  void _skipCountdown() {
    _countdownTimer?.cancel();
    _startLiveSpeech();
  }

  // Step 4: The user can end the speech by clicking the X button at the bottom middle
  Future<void> _endSpeech() async {
    _speechTimer?.cancel();
    setState(() => _isAnalyzing = true);
    try {
      final seconds = _audio.secondsElapsed;
      final audioPath = await _audio.stopAndGetPath();
      PoseMetrics? poseMetrics;
      if (_poseSession.isRunning) {
        poseMetrics = await _poseSession.stop('practice-${DateTime.now().millisecondsSinceEpoch}');
      }
      if (audioPath == null || seconds < 1) {
        throw StateError('Magsalita muna nang kahit ilang segundo bago tapusin.');
      }

      final speechService = ref.read(speechRecognitionProvider);
      final transcription = await speechService.transcribe(audioPath);
      if (!transcription.isSuccess) {
        throw StateError(
          transcription.errorMessage ?? 'Hindi na-transcribe ang recording.',
        );
      }
      final speechMetrics = speechService.calculateMetrics(
        transcription: transcription,
        durationSeconds: seconds.toDouble(),
      );
      ref.read(lastSpeechMetricsProvider.notifier).state = speechMetrics;
      ref.read(lastPoseMetricsProvider.notifier).state = poseMetrics;

      final llm = LocalLlmService();
      if (!llm.isLoaded) await llm.initialize();
      final report = await ref.read(feedbackServiceProvider).generate(
            speech: speechMetrics,
            pose: poseMetrics,
            document: ref.read(lastDocAnalysisProvider),
            speakingGoal: widget.speechTopic,
          );
      ref.read(lastReportProvider.notifier).state = report;
      final session = PracticeSession(
        id: 'practice-${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        title: widget.speechTopic,
        duration: Duration(seconds: seconds),
        avgWpm: speechMetrics.wordsPerMinute.round(),
        fillerCount: speechMetrics.totalFillers,
        // Eye gaze is not tracked; keep this unset instead of relabeling posture.
        eyeContactPct: 0,
        paceScore: report.overallScore.round(),
        starsEarned: 0,
        improved: false,
        goal: widget.speechTopic,
      );
      if (mounted) context.pushReplacement(AppRoutes.rehearsalAnalysis, extra: session);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hindi natapos ang AI analysis: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _speechTimer?.cancel();
    unawaited(_audio.dispose());
    unawaited(_poseSession.dispose());
    unawaited(_cameraController?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCountingDown) {
      return _buildCountdownView();
    }
    return _buildLiveSpeechView();
  }

  // ---------------------------------------------------------------------------
  // STEP 2: PREPARE THE USER & COUNTDOWN WITH TIMER FROM 10 SECS TO 0
  // ---------------------------------------------------------------------------
  Widget _buildCountdownView() {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  onPressed: _skipCountdown,
                  icon: const Icon(Icons.fast_forward_rounded, color: AppColors.sky),
                  label: const Text(
                    'Skip to speech',
                    style: TextStyle(color: AppColors.sky),
                  ),
                ),
              ),
              const Spacer(),

              // Calming preparation instruction
              const Center(
                child: Text(
                  'PREPARE YOUR SPEECH',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Take a deep breath and stand tall.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Topic: "${widget.speechTopic}"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.sky,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),

              // Animated Countdown Timer Display (10 secs to 0)
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.blue,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x334F7CFF),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_countdownSeconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Your mock audience is seated and listening...',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: FULL-SCREEN BACKGROUND OF MOCK CARTOON AUDIENCE,
  // TIMER THAT KEEPS TRACK OF SPEECH TIME, INDICATOR OF VOICE LOUDNESS.
  // STEP 4: END SPEECH BY CLICKING THE X BUTTON AT BOTTOM MIDDLE.
  // ---------------------------------------------------------------------------
  Widget _buildLiveSpeechView() {
    if (_isAnalyzing) {
      return const Scaffold(
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Transcribing offline audio and preparing your Qwen feedback…'),
        ])),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Step 3: Full-screen background of mock cartoon audience
          const MockCartoonAudienceBackground(),

          // Top Overlay: Timer, Topic & PIP Self View
          Positioned(
            top: 44,
            left: 18,
            right: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Timer that keeps track of the speech time
                PracticeTimerWidget(
                  elapsedSeconds: _elapsedSpeechSeconds,
                ),

                // Self Camera PIP thumbnail
                Container(
                  width: 76,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white38, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x44000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_cameraController?.value.isInitialized == true)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CameraPreview(_cameraController!),
                        )
                      else
                        const Icon(
                          Icons.person_rounded,
                          color: Colors.white54,
                          size: 38,
                        ),
                      Positioned(
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Speech Prompt Capsule Banner
          Positioned(
            top: 110,
            left: 20,
            right: 106,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                'Prompt: ${widget.speechTopic}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Step 3: Indicator of voice loudness
          Positioned(
            left: 20,
            right: 20,
            bottom: 120,
            child: _buildVoiceLoudnessIndicator(),
          ),

          // Step 4: The user can end the speech by clicking the X button at the bottom middle
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: RecordingControlsWidget(
                onEndSpeech: _endSpeech,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a recording state without displaying simulated loudness readings.
  Widget _buildVoiceLoudnessIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(children: [
        Icon(Icons.mic_rounded, color: AppColors.yellow, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Audio is recording locally for offline Whisper transcription.',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ]),
    );
  }
}
