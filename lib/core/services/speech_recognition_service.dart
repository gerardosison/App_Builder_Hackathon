import '../models/transcript_segment.dart';

/// On-device speech-to-text seam (Whisper on the backend later).
abstract class SpeechRecognitionService {
  Future<List<TranscriptSegment>> transcribe(String sessionId);
}
