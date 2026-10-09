import 'dart:async';

/// Audio Recorder Service simulation for speech sessions
class AudioRecorderService {
  bool _isRecording = false;
  int _secondsElapsed = 0;
  Timer? _timer;

  bool get isRecording => _isRecording;
  int get secondsElapsed => _secondsElapsed;

  Future<void> startRecording() async {
    _isRecording = true;
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
    });
  }

  Future<int> stopRecording() async {
    _timer?.cancel();
    _isRecording = false;
    final totalSeconds = _secondsElapsed;
    _secondsElapsed = 0;
    return totalSeconds;
  }
}

