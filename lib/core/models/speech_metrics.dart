import 'transcript_segment.dart';
export 'transcript_segment.dart';

class TranscriptionResult {
  final String text;
  final double durationSeconds;
  final String detectedLanguage;
  final List<TranscriptSegment> segments;
  final bool isSuccess;
  final String? errorMessage;

  const TranscriptionResult({
    required this.text,
    required this.durationSeconds,
    this.detectedLanguage = 'en',
    this.segments = const [],
    this.isSuccess = true,
    this.errorMessage,
  });

  factory TranscriptionResult.failure(String error) {
    return TranscriptionResult(
      text: '',
      durationSeconds: 0,
      isSuccess: false,
      errorMessage: error,
    );
  }
}

class SpeechMetrics {
  final String transcript;
  final int wordCount;
  final double speechDurationSeconds;
  final double wordsPerMinute;
  final Map<String, int> fillerOccurrences;
  final int totalFillers;
  final int pauseCount;
  final double avgPauseDurationSeconds;

  const SpeechMetrics({
    required this.transcript,
    required this.wordCount,
    required this.speechDurationSeconds,
    required this.wordsPerMinute,
    required this.fillerOccurrences,
    required this.totalFillers,
    required this.pauseCount,
    required this.avgPauseDurationSeconds,
  });

  factory SpeechMetrics.empty() {
    return const SpeechMetrics(
      transcript: '',
      wordCount: 0,
      speechDurationSeconds: 0,
      wordsPerMinute: 0,
      fillerOccurrences: {},
      totalFillers: 0,
      pauseCount: 0,
      avgPauseDurationSeconds: 0,
    );
  }

  factory SpeechMetrics.sample({
    String? transcript,
    double wpm = 135.0,
    int fillers = 3,
    double duration = 60.0,
  }) {
    return SpeechMetrics(
      transcript: transcript ??
          'Good day everyone. Today I am presenting HawkABuild, an offline public speaking coach app. Um, we use local AI models on device.',
      wordCount: 22,
      speechDurationSeconds: duration,
      wordsPerMinute: wpm,
      fillerOccurrences: {'um': fillers, 'uh': 1, 'like': 0},
      totalFillers: fillers + 1,
      pauseCount: 4,
      avgPauseDurationSeconds: 1.1,
    );
  }
}
