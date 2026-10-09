import 'audio_recorder_service.dart';
import 'speech_metrics_calculator.dart';

/// Session Orchestrator managing recording, timer, and metrics flow
class SessionOrchestrator {
  SessionOrchestrator({
    AudioRecorderService? recorderService,
    SpeechMetricsCalculator? metricsCalculator,
  })  : recorderService = recorderService ?? AudioRecorderService(),
        metricsCalculator = metricsCalculator ?? const SpeechMetricsCalculator();

  final AudioRecorderService recorderService;
  final SpeechMetricsCalculator metricsCalculator;

  Future<void> beginSession() async {
    await recorderService.startRecording();
  }

  Future<int> endSession() async {
    return await recorderService.stopRecording();
  }
}

