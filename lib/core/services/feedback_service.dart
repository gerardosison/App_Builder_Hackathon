import '../models/speech_metrics.dart';
import '../models/pose_metrics.dart';
import '../models/feedback_report.dart';

/// Service interface for Member 4 Feedback Engine (Rule-based + optional Qwen LLM)
abstract class FeedbackService {
  /// Generate coaching feedback based on measured speech, pose, and document evidence
  Future<FeedbackReport> generate({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    DocumentResult? document,
    required String speakingGoal,
  });
}
