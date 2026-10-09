import '../../../core/models/speech_metrics.dart';
import '../../../core/models/pose_metrics.dart';

/// Member 4 - Local LLM Service (Qwen3-0.6B via llama.cpp GGUF runtime)
class LocalLlmService {
  final String modelName;
  final bool isEnabled;

  LocalLlmService({
    this.modelName = 'Qwen3-0.6B-GGUF (Q4_K_M)',
    this.isEnabled = true,
  });

  /// Build structured prompt for local GGUF Qwen3-0.6B inference without hallucinating data
  String buildCoachingPrompt({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    required String speakingGoal,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('<system>');
    buffer.writeln('You are HawkABuild AI Speech Coach running offline on device.');
    buffer.writeln('Rules: Never invent numerical metrics, timestamps or quotations.');
    buffer.writeln('Provide constructive, encouraging speech feedback based strictly on measured evidence.');
    buffer.writeln('</system>\n');

    buffer.writeln('<context>');
    buffer.writeln('Speaking Goal: $speakingGoal');
    buffer.writeln('Measured Speech Rate: ${speech.wordsPerMinute.toStringAsFixed(1)} WPM');
    buffer.writeln('Word Count: ${speech.wordCount}');
    buffer.writeln('Detected Filler Words: ${speech.totalFillers} (${speech.fillerOccurrences})');

    if (pose != null && pose.isPersonInFrame) {
      buffer.writeln('Measured Body Sway: ${pose.bodySwayCm.toStringAsFixed(1)} cm');
      buffer.writeln('Posture Score: ${pose.postureScore.toStringAsFixed(0)} / 100');
      buffer.writeln('Hand Gesture Score: ${pose.handGestureActivityScore.toStringAsFixed(0)} / 100');
    } else {
      buffer.writeln('Pose Metrics: Camera disabled or person out of frame.');
    }
    buffer.writeln('</context>\n');

    buffer.writeln('<instruction>');
    buffer.writeln('Write a concise 2-sentence encouragement for the student focused on improving their delivery.');
    buffer.writeln('</instruction>');

    return buffer.toString();
  }

  /// Execute local inference (simulated / native llama.cpp channel call)
  Future<String> generateResponse(String prompt) async {
    if (!isEnabled) return 'Local LLM feedback disabled.';
    await Future.delayed(const Duration(milliseconds: 400));

    return 'Great effort on your speech! Focus on maintaining your grounded stance while adding deliberate 1-second pauses to highlight your key messages.';
  }
}
