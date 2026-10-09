import '../../../core/models/speech_metrics.dart';
import '../../../core/models/pose_metrics.dart';

/// Member 4 - Feedback Prompt Builder for Qwen3-0.6B local LLM
class FeedbackPromptBuilder {
  String buildPrompt({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    required String speakingGoal,
  }) {
    final buf = StringBuffer();
    buf.writeln('<system>');
    buf.writeln('HawkABuild On-Device Speech Coach (Qwen3-0.6B).');
    buf.writeln('Never invent metrics, timestamps or quotations.');
    buf.writeln('</system>');

    buf.writeln('<context>');
    buf.writeln('Goal: $speakingGoal');
    buf.writeln('Speech Rate: ${speech.wordsPerMinute} WPM');
    buf.writeln('Fillers: ${speech.totalFillers}');
    if (pose != null && pose.isPersonInFrame) {
      buf.writeln('Body Sway: ${pose.bodySwayCm} cm');
      buf.writeln('Posture Score: ${pose.postureScore} / 100');
    }
    buf.writeln('</context>');

    buf.writeln('<instruction>Provide 2 supportive, actionable tips.</instruction>');
    return buf.toString();
  }
}
