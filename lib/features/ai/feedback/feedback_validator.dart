import '../../../core/models/feedback_report.dart';

/// Member 4 - Feedback Validator: Ensures AI outputs do not hallucinate numbers or infer forbidden states
class FeedbackValidator {
  bool validateReport(FeedbackReport report) {
    if (report.overallScore < 0 || report.overallScore > 100) return false;
    for (var item in [...report.strengths, ...report.improvements]) {
      // Forbidden words according to Member 4 prompt rules
      final lowerDesc = item.description.toLowerCase();
      if (lowerDesc.contains('anxiety') || lowerDesc.contains('nervousness') || lowerDesc.contains('personality')) {
        return false;
      }
    }
    return true;
  }
}
