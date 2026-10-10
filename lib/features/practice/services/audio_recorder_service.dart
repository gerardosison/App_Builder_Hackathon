import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Records mono 16 kHz PCM WAV audio for the bundled offline Whisper model.
class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  int _secondsElapsed = 0;
  Timer? _timer;
  String? _recordingPath;
  InputDevice? _selectedDevice;

  bool get isRecording => _isRecording;
  int get secondsElapsed => _secondsElapsed;
  bool get isPaused => _isPaused;
  bool _isPaused = false;

  Future<List<InputDevice>> listInputDevices() =>
      _recorder.listInputDevices();

  Future<bool> requestPermission() {
    // record supports runtime permission checks on mobile, web, and macOS.
    // Windows and Linux use OS/device-level access and don't implement this
    // method; asking there can produce MissingPluginException.
    final permissionCheckSupported = kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.windows &&
            defaultTargetPlatform != TargetPlatform.linux);
    return permissionCheckSupported
        ? _recorder.hasPermission()
        : Future<bool>.value(true);
  }

  Future<double> currentAmplitudeLevel() async {
    if (!_isRecording || _isPaused) return 0;
    try {
      final amplitude = await _recorder.getAmplitude();
      return ((amplitude.current + 60) / 60).clamp(0.0, 1.0);
    } catch (_) {
      return 0;
    }
  }

  void selectInputDevice(InputDevice? device) => _selectedDevice = device;

  Future<void> startRecording({InputDevice? device}) async {
    if (!await requestPermission()) {
      throw StateError('Microphone permission was not granted.');
    }
    final dir = await getApplicationDocumentsDirectory();
    _recordingPath = p.join(
      dir.path,
      'practice_${DateTime.now().millisecondsSinceEpoch}.wav',
    );
    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
        device: device ?? _selectedDevice,
      ),
      path: _recordingPath!,
    );
    _isRecording = true;
    _isPaused = false;
    _secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;
    });
  }

  Future<String?> stopAndGetPath() async {
    _timer?.cancel();
    _timer = null;
    if (!_isRecording) return _recordingPath;
    final path = await _recorder.stop();
    _isRecording = false;
    _isPaused = false;
    return path ?? _recordingPath;
  }

  Future<void> pauseRecording() async {
    if (!_isRecording || _isPaused) return;
    await _recorder.pause();
    _timer?.cancel();
    _timer = null;
    _isPaused = true;
  }

  Future<void> resumeRecording() async {
    if (!_isRecording || !_isPaused) return;
    await _recorder.resume();
    _isPaused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;
    });
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();
    _timer = null;
    if (_isRecording) await _recorder.cancel();
    _isRecording = false;
    _isPaused = false;
    _recordingPath = null;
    _secondsElapsed = 0;
  }

  Future<int> stopRecording() async {
    final duration = _secondsElapsed;
    await stopAndGetPath();
    _secondsElapsed = 0;
    return duration;
  }

  Future<void> dispose() async {
    _timer?.cancel();
    if (_isRecording) await _recorder.stop();
    _isRecording = false;
    _isPaused = false;
    await _recorder.dispose();
  }
}
