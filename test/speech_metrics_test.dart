import 'package:flutter_test/flutter_test.dart';
import 'package:app_builder_hackathon/core/models/speech_metrics.dart';
import 'package:app_builder_hackathon/features/ai/speech/whisper_service.dart';
import 'package:app_builder_hackathon/features/ai/speech/speech_segmenter.dart';
import 'package:app_builder_hackathon/features/ai/speech/transcript_processor.dart';

void main() {
  group('Member 4: Speech Metrics & ASR Tests', () {
    late WhisperSpeechService whisperService;
    late SpeechSegmenter segmenter;
    late TranscriptProcessor processor;

    setUp(() {
      whisperService = WhisperSpeechService();
      segmenter = SpeechSegmenter();
      processor = TranscriptProcessor();
    });

    test('Speech metrics calculation computes accurate WPM', () {
      final transcription = TranscriptionResult(
        text: 'This is a test speech to verify the word per minute calculation logic.',
        durationSeconds: 10.0,
        isSuccess: true,
      );

      final metrics = whisperService.calculateMetrics(
        transcription: transcription,
        durationSeconds: 10.0,
      );

      expect(metrics.wordCount, equals(13));
      expect(metrics.wordsPerMinute, equals(78.0));
    });

    test('Speech Segmenter extracts pauses between segments', () {
      const segments = [
        TranscriptSegment(id: 1, startSeconds: 0.0, endSeconds: 2.0, text: 'First segment'),
        TranscriptSegment(id: 2, startSeconds: 3.5, endSeconds: 5.0, text: 'Second segment'),
      ];

      final pauses = segmenter.calculatePauses(segments);
      expect(pauses.length, equals(1));
      expect(pauses.first, equals(1.5));
    });

    test('Transcript Processor detects custom filler words', () {
      final fillers = processor.detectFillers('Good day um today uh we talk about ano and kwan');
      expect(fillers['um'], equals(1));
      expect(fillers['uh'], equals(1));
      expect(fillers['ano'], equals(1));
    });
  });
}
