import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/models/pose_metrics.dart';
import '../../ai/feedback/local_llm_service.dart';
import '../../ai/speech/whisper_service.dart';
import '../../ai/vision/mediapipe_pose_service.dart';
import '../../documents/services/pdf_extraction_service.dart';
import '../../practice/services/pose_camera_session.dart';

/// Temporary test UI for real local AI and camera flows.
class LocalAiTestScreen extends StatefulWidget {
  const LocalAiTestScreen({super.key});

  @override
  State<LocalAiTestScreen> createState() => _LocalAiTestScreenState();
}

class _LocalAiTestScreenState extends State<LocalAiTestScreen> {
  static const _accent = Color(0xFF39D6D0);

  final _llm = LocalLlmService();
  final _whisper = WhisperSpeechService();
  final _pdf = PdfExtractionService();
  final _pose = MediaPipePoseServiceImpl();
  final _prompt = TextEditingController(
    text: 'Give me one practical tip for speaking more confidently.',
  );

  String _qwenStatus = 'Not loaded';
  String _qwenOutput = '';
  bool _qwenBusy = false;
  String? _wavPath;
  String _whisperOutput = 'Choose a 16 kHz, 16-bit PCM WAV file.';
  bool _whisperBusy = false;
  String? _pdfPath;
  String _pdfOutput = 'Choose a PDF to extract and analyze on-device.';
  bool _pdfBusy = false;
  bool _pdfInitialized = false;
  String _poseOutput = 'Camera test is stopped.';
  bool _poseBusy = false;
  CameraController? _camera;
  PoseCameraSession? _cameraSession;

  @override
  void dispose() {
    _prompt.dispose();
    unawaited(_cleanupCamera());
    super.dispose();
  }

  Future<void> _loadQwen() async {
    if (_qwenBusy || _llm.isLoaded) return;
    setState(() {
      _qwenBusy = true;
      _qwenStatus = 'Preparing local model; first load copies about 484 MB…';
    });
    try {
      await _llm.initialize(
        onStatus: (message) {
          if (mounted) setState(() => _qwenStatus = message);
        },
      );
      if (mounted) {
        setState(() => _qwenStatus = 'Qwen is loaded on this device.');
      }
    } catch (error) {
      if (mounted) setState(() => _qwenStatus = 'Qwen load failed: $error');
    } finally {
      if (mounted) setState(() => _qwenBusy = false);
    }
  }

  Future<void> _runPrompt() async {
    if (_qwenBusy || _prompt.text.trim().isEmpty) return;
    if (!_llm.isLoaded) await _loadQwen();
    if (!_llm.isLoaded) {
      setState(
        () => _qwenOutput =
            'Cannot prompt Qwen: ${_llm.lastError.isEmpty ? _qwenStatus : _llm.lastError}',
      );
      return;
    }
    setState(() {
      _qwenBusy = true;
      _qwenOutput = 'Waiting for local Qwen response…';
    });
    try {
      final answer = await _llm.generateResponse(
        _prompt.text.trim(),
        maxTokens: 400,
      );
      if (mounted) setState(() => _qwenOutput = answer);
    } catch (error) {
      if (mounted) setState(() => _qwenOutput = 'Prompt failed: $error');
    } finally {
      if (mounted) setState(() => _qwenBusy = false);
    }
  }

  Future<String?> _pickPath(String extension) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [extension],
    );
    return files.isEmpty ? null : files.first.path;
  }

  Future<void> _pickWav() async {
    final path = await _pickPath('wav');
    if (path != null && mounted) setState(() => _wavPath = path);
  }

  Future<void> _transcribe() async {
    final path = _wavPath;
    if (path == null || _whisperBusy) return;
    setState(() {
      _whisperBusy = true;
      _whisperOutput = 'Loading Whisper and transcribing locally…';
    });
    try {
      final result = await _whisper.transcribe(path, language: 'auto');
      if (!result.isSuccess) {
        throw StateError(result.errorMessage ?? 'Transcription failed.');
      }
      if (mounted) {
        setState(
          () => _whisperOutput =
              '${result.text}\n\n${result.durationSeconds.toStringAsFixed(1)} seconds · ${result.detectedLanguage}',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _whisperOutput = 'Whisper failed: $error');
    } finally {
      if (mounted) setState(() => _whisperBusy = false);
    }
  }

  Future<void> _pickPdf() async {
    final path = await _pickPath('pdf');
    if (path != null && mounted) setState(() => _pdfPath = path);
  }

  Future<void> _analyzePdf() async {
    final path = _pdfPath;
    if (path == null || _pdfBusy) return;
    setState(() {
      _pdfBusy = true;
      _pdfOutput = 'Preparing PDF reader…';
    });
    try {
      if (!_pdfInitialized) {
        await pdfrxFlutterInitialize();
        _pdfInitialized = true;
      }
      if (mounted) {
        setState(() => _pdfOutput = 'Extracting PDF text and OCR locally…');
      }
      final extracted = await _pdf.extractFile(path);
      if (extracted.text.trim().length < 40) {
        throw StateError(
          'Too little readable text was found. Try a clearer PDF.',
        );
      }
      if (!_llm.isLoaded) await _loadQwen();
      if (!_llm.isLoaded) {
        throw StateError(_llm.lastError.isEmpty ? _qwenStatus : _llm.lastError);
      }
      final excerpt = extracted.text.substring(
        0,
        math.min(extracted.text.length, 6500),
      );
      final analysis = await _llm.generateResponse(
        'Review this student speech or presentation. Give a brief summary, key '
        'concepts present, missing or weak concepts, and three specific improvements. '
        'Use only the document text below.\n\nDOCUMENT:\n$excerpt',
        maxTokens: 500,
      );
      if (mounted) {
        setState(
          () => _pdfOutput =
              'Pages: ${extracted.pageCount} · OCR pages: ${extracted.ocrPageCount}\n\n$analysis',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _pdfOutput = 'PDF analysis failed: $error');
    } finally {
      if (mounted) setState(() => _pdfBusy = false);
    }
  }

  Future<void> _startCamera() async {
    if (_poseBusy) return;
    setState(() {
      _poseBusy = true;
      _poseOutput = 'Opening back camera…';
    });
    CameraController? controller;
    PoseCameraSession? session;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera was found.');
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      controller = PoseCameraSession.createCameraController(backCamera);
      await controller.initialize();
      session = PoseCameraSession(poseService: _pose);
      await session.start(controller, backCamera);
      if (!mounted) {
        await session.dispose();
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _cameraSession = session;
        _poseOutput =
            'Back camera is tracking pose. Keep your upper body in frame.';
      });
    } catch (error) {
      await session?.dispose();
      await controller?.dispose();
      if (mounted) setState(() => _poseOutput = 'Camera test failed: $error');
    } finally {
      if (mounted) setState(() => _poseBusy = false);
    }
  }

  Future<void> _stopCamera() async {
    final session = _cameraSession;
    final controller = _camera;
    if (session == null || controller == null || _poseBusy) return;
    setState(() => _poseBusy = true);
    try {
      final metrics = await session.stop(
        'test-${DateTime.now().millisecondsSinceEpoch}',
      );
      final note = session.lastFrameError;
      await session.dispose();
      await controller.dispose();
      if (mounted) {
        setState(() {
          _cameraSession = null;
          _camera = null;
          _poseOutput = _poseResults(metrics, note);
        });
      }
    } catch (error) {
      if (mounted) setState(() => _poseOutput = 'Pose test failed: $error');
    } finally {
      if (mounted) setState(() => _poseBusy = false);
    }
  }

  String _poseResults(PoseMetrics metrics, String? note) {
    if (!metrics.isPersonInFrame) {
      return 'No usable pose detected.${note == null ? '' : '\nCamera input: $note'}';
    }
    return 'Pose detection succeeded.\n'
        'Frames: ${metrics.validFrameCount}/${metrics.totalFrames}\n'
        'Posture: ${metrics.postureScore.toStringAsFixed(0)}/100\n'
        'Hand movement: ${metrics.handGestureActivityScore.toStringAsFixed(0)}/100\n'
        'Framing: ${metrics.framingStatus.label}\n'
        'Quality: ${metrics.analysisQuality.label}';
  }

  Future<void> _cleanupCamera() async {
    final session = _cameraSession;
    final controller = _camera;
    if (session != null) await session.dispose();
    if (controller != null) await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        title: const Text('HawkABuild · AI Test Screen'),
        backgroundColor: const Color(0xFF0B0F19),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const Text(
            'Run each test and inspect its real output.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          _card(
            'Camera pose tracking',
            'Live back-camera frames are analyzed on-device.',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_camera != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _camera!.value.aspectRatio,
                      child: CameraPreview(_camera!),
                    ),
                  ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: _poseBusy
                      ? null
                      : (_camera == null ? _startCamera : _stopCamera),
                  icon: Icon(_camera == null ? Icons.camera_alt : Icons.stop),
                  label: Text(
                    _camera == null
                        ? 'Start back camera test'
                        : 'Stop and show pose results',
                  ),
                ),
                _output(_poseOutput),
              ],
            ),
          ),
          _card(
            'AI prompting · Qwen',
            _qwenStatus,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _prompt,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Prompt to Qwen',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: _qwenBusy ? null : _loadQwen,
                      child: const Text('Load model'),
                    ),
                    FilledButton.icon(
                      onPressed: _qwenBusy ? null : _runPrompt,
                      icon: const Icon(Icons.send),
                      label: const Text('Send prompt'),
                    ),
                  ],
                ),
                if (_qwenBusy) const LinearProgressIndicator(minHeight: 2),
                if (_qwenOutput.isNotEmpty) _output(_qwenOutput),
              ],
            ),
          ),
          _card(
            'Whisper · speech to text',
            'Choose a 16 kHz, 16-bit PCM WAV file for offline transcription.',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _whisperBusy ? null : _pickWav,
                  icon: const Icon(Icons.audio_file),
                  label: Text(
                    _wavPath == null ? 'Choose WAV' : _fileName(_wavPath!),
                  ),
                ),
                FilledButton(
                  onPressed: _whisperBusy || _wavPath == null
                      ? null
                      : _transcribe,
                  child: const Text('Transcribe locally'),
                ),
                if (_whisperBusy) const LinearProgressIndicator(minHeight: 2),
                _output(_whisperOutput),
              ],
            ),
          ),
          _card(
            'PDF import and analysis',
            'Extractable text and OCR are processed locally, then Qwen analyzes the content.',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _pdfBusy ? null : _pickPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: Text(
                    _pdfPath == null ? 'Choose PDF' : _fileName(_pdfPath!),
                  ),
                ),
                FilledButton.icon(
                  onPressed: _pdfBusy || _pdfPath == null ? null : _analyzePdf,
                  icon: const Icon(Icons.manage_search),
                  label: const Text('Extract and analyze'),
                ),
                if (_pdfBusy) const LinearProgressIndicator(minHeight: 2),
                _output(_pdfOutput),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fileName(String path) => path.split(Platform.pathSeparator).last;

  Widget _card(String title, String subtitle, Widget child) => Card(
    color: const Color(0xFF171F2E),
    margin: const EdgeInsets.only(bottom: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _accent,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );

  Widget _output(String text) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 9),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: SelectableText(
      text,
      style: const TextStyle(color: Colors.white70, height: 1.4),
    ),
  );
}
