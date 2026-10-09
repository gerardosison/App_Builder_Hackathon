import 'package:flutter_test/flutter_test.dart';
import 'package:app_builder_hackathon/core/models/speech_metrics.dart';
import 'package:app_builder_hackathon/core/models/pose_metrics.dart';
import 'package:app_builder_hackathon/features/ai/feedback/rule_based_feedback.dart';
import 'package:app_builder_hackathon/features/ai/feedback/feedback_validator.dart';

void main() {
  group('Member 4: Feedback Validation Tests', () {
    late RuleBasedFeedbackEngine engine;
    late FeedbackValidator validator;

    setUp(() {
      engine = RuleBasedFeedbackEngine();
      validator = FeedbackValidator();
    });

    test('Feedback Report generates valid scores and items without forbidden words', () async {
      final report = await engine.generate(
        speech: SpeechMetrics.sample(wpm: 140.0, fillers: 1),
        pose: PoseMetrics.sampleGood(),
        speakingGoal: 'Project Pitch',
      );

      expect(report.overallScore, greaterThanOrEqualTo(0));
      expect(report.overallScore, lessThanOrEqualTo(100));
      expect(validator.validateReport(report), isTrue);
    });
  });
}
