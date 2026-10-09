import 'dart:io';
import '../../../core/models/speech_metrics.dart';
import '../../../core/services/speech_recognition_service.dart';

/// Speech metrics service.
///
/// The live Android practice screen uses the device speech recognizer directly.
/// This class deliberately does not fabricate a transcript when a native
/// Whisper runtime is unavailable.
class WhisperSpeechService implements SpeechRecognitionService {
  bool _isLoaded = false;
  final String modelPath;

  WhisperSpeechService({this.modelPath = 'assets/models/whisper/ggml-base-q5_1.bin'});

  @override
  Future<bool> isModelLoaded() async {
    return _isLoaded;
  }

  Future<void> initializeModel() async {
    final model = File(modelPath);
    if (!model.existsSync() || model.lengthSync() < 1024 * 1024) {
      throw StateError(
        'Whisper model is not available at "$modelPath". '
        'Use the live Android speech recognizer or install a real Whisper '
        'native runtime before calling this service.',
      );
    }
    _isLoaded = true;
  }

  @override
  Future<TranscriptionResult> transcribe(String audioPath) async {
    if (audioPath.isEmpty) {
      return TranscriptionResult.failure('Audio file path is empty.');
    }
    return TranscriptionResult.failure(
      'Offline Whisper transcription is not wired to a native runtime. '
      'The Android practice screen uses live device speech recognition instead.',
    );
  }

  @override
  SpeechMetrics calculateMetrics({
    required TranscriptionResult transcription,
    required double durationSeconds,
  }) {
    if (!transcription.isSuccess || transcription.text.isEmpty) {
      return SpeechMetrics.empty();
    }

    final words = transcription.text.trim().split(RegExp(r'\s+'));
    final int wordCount = words.length;
    final double durationMin = durationSeconds > 0 ? durationSeconds / 60.0 : 0.5;
    final double wpm = durationMin > 0 ? wordCount / durationMin : 0.0;

    // Count filler words
    final lowerText = transcription.text.toLowerCase();
    final RegExp umRegex = RegExp(r'\bum\b');
    final RegExp uhRegex = RegExp(r'\buh\b');
    final RegExp likeRegex = RegExp(r'\blike\b');

    int umCount = umRegex.allMatches(lowerText).length;
    int uhCount = uhRegex.allMatches(lowerText).length;
    int likeCount = likeRegex.allMatches(lowerText).length;

    int totalFillers = umCount + uhCount + likeCount;

    return SpeechMetrics(
      transcript: transcription.text,
      wordCount: wordCount,
      speechDurationSeconds: durationSeconds,
      wordsPerMinute: double.parse(wpm.toStringAsFixed(1)),
      fillerOccurrences: {
        'um': umCount,
        'uh': uhCount,
        'like': likeCount,
      },
      totalFillers: totalFillers,
      pauseCount: transcription.segments.length > 1 ? transcription.segments.length - 1 : 1,
      avgPauseDurationSeconds: 1.2,
    );
  }
}
