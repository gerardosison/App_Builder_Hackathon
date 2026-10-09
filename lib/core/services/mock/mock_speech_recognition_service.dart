import '../../models/transcript_segment.dart';
import '../speech_recognition_service.dart';

/// TODO(backend): replace with Whisper-backed implementation.
class MockSpeechRecognitionService implements SpeechRecognitionService {
  @override
  Future<List<TranscriptSegment>> transcribe(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      TranscriptSegment(
          text: 'Good morning everyone, today I want to talk about '),
      TranscriptSegment(text: 'um', isFiller: true),
      TranscriptSegment(text: ' the industrial revolution and '),
      TranscriptSegment(text: 'uh', isFiller: true),
      TranscriptSegment(text: ' how it changed the way we live. '),
      TranscriptSegment(text: '[long pause]', isPause: true),
      TranscriptSegment(text: 'Factories transformed cities, and '),
      TranscriptSegment(text: 'like, ', isFiller: true),
      TranscriptSegment(text: 'they reshaped entire economies…'),
    ];
  }
}
