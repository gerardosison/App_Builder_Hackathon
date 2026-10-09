import 'dart:async';
import '../../../core/models/speech_metrics.dart';
import '../../../core/services/speech_recognition_service.dart';

/// Member 4 - Offline Whisper Speech-To-Text implementation using whisper.cpp / GGML Base Multilingual model
class WhisperSpeechService implements SpeechRecognitionService {
  bool _isLoaded = false;
  final String modelPath;

  WhisperSpeechService({this.modelPath = 'assets/models/whisper/ggml-base-q5_1.bin'});

  @override
  Future<bool> isModelLoaded() async {
    // Simulated native check / asset check
    return _isLoaded;
  }

  Future<void> initializeModel() async {
    // Simulates loading GGML Whisper Base model in offline memory
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoaded = true;
  }

  @override
  Future<TranscriptionResult> transcribe(String audioPath) async {
    if (!_isLoaded) {
      await initializeModel();
    }

    if (audioPath.isEmpty) {
      return TranscriptionResult.failure('Audio file path is empty.');
    }

    // Simulated offline Whisper ASR processing
    await Future.delayed(const Duration(milliseconds: 600));

    // Sample transcription output for testing/demo
    const sampleText =
        'Good day everyone. Welcome to HawkABuild public speaking practice. '
        'Um, today I will discuss our project strategy and key objectives. '
        'Uh, we aim to build an offline speaking coach using local AI on device.';

    final List<TranscriptSegment> segments = [
      const TranscriptSegment(id: 1, startSeconds: 0.0, endSeconds: 4.5, text: 'Good day everyone. Welcome to HawkABuild public speaking practice.'),
      const TranscriptSegment(id: 2, startSeconds: 5.0, endSeconds: 10.2, text: 'Um, today I will discuss our project strategy and key objectives.'),
      const TranscriptSegment(id: 3, startSeconds: 11.0, endSeconds: 16.8, text: 'Uh, we aim to build an offline speaking coach using local AI on device.'),
    ];

    return TranscriptionResult(
      text: sampleText,
      durationSeconds: 17.0,
      detectedLanguage: 'en',
      segments: segments,
      isSuccess: true,
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
