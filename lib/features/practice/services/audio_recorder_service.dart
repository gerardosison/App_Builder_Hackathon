import 'dart:async';

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

  bool get isRecording => _isRecording;
  int get secondsElapsed => _secondsElapsed;

  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) {
      throw StateError('Microphone permission was not granted.');
    }
    final dir = await getApplicationDocumentsDirectory();
    _recordingPath = p.join(
      dir.path,
      'practice_${DateTime.now().millisecondsSinceEpoch}.wav',
    );
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: _recordingPath!,
    );
    _isRecording = true;
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
    return path ?? _recordingPath;
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
    await _recorder.dispose();
  }
}
