import '../models/speech_metrics.dart';

/// Service interface for Member 4 Speech AI (Whisper / Sherpa-ONNX)
abstract class SpeechRecognitionService {
  /// Transcribe a locally recorded audio file using on-device Whisper Base ASR
  Future<TranscriptionResult> transcribe(String audioPath);

  /// Check whether the ASR model file is loaded and ready
  Future<bool> isModelLoaded();

  /// Calculate speech delivery metrics from transcript and timing signal
  SpeechMetrics calculateMetrics({
    required TranscriptionResult transcription,
    required double durationSeconds,
  });
}
