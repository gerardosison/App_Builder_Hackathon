import '../../models/speech_metrics.dart';
import '../speech_recognition_service.dart';

/// Fixture implementation for UI previews; production uses local Whisper.
class MockSpeechRecognitionService implements SpeechRecognitionService {
  @override
  Future<bool> isModelLoaded() async => true;

  @override
  Future<TranscriptionResult> transcribe(String audioPath, {String language = 'auto'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const TranscriptionResult(
      text: 'Preview transcript only.',
      durationSeconds: 1,
      detectedLanguage: 'en',
    );
  }

  @override
  SpeechMetrics calculateMetrics({
    required TranscriptionResult transcription,
    required double durationSeconds,
  }) {
    final words = transcription.text.trim().split(RegExp(r'\s+'));
    final count = transcription.text.trim().isEmpty ? 0 : words.length;
    return SpeechMetrics(
      transcript: transcription.text,
      wordCount: count,
      speechDurationSeconds: durationSeconds,
      wordsPerMinute: durationSeconds > 0 ? count * 60 / durationSeconds : 0,
      fillerOccurrences: const {},
      totalFillers: 0,
      pauseCount: 0,
      avgPauseDurationSeconds: 0,
    );
  }
}
