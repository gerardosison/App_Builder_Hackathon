import '../../models/document_result.dart';
import '../../models/feedback_report.dart';
import '../../models/pose_metrics.dart';
import '../../models/speech_metrics.dart';
import '../feedback_service.dart';

/// Fixture implementation for UI previews; production uses RuleBasedFeedbackEngine.
class MockFeedbackService implements FeedbackService {
  @override
  Future<FeedbackReport> generate({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    DocumentResult? document,
    required String speakingGoal,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return FeedbackReport(
      overallScore: 0,
      summary: 'Preview only. Complete a recorded session for real feedback.',
      strengths: const [],
      improvements: const [],
      evidenceList: const [],
      limitations: const ['Fixture data; no real analysis was performed.'],
      generatedAt: DateTime.now(),
    );
  }
}
