import 'dart:math' as math;
import '../../../core/models/speech_metrics.dart';
import '../../../core/models/pose_metrics.dart';
import '../../../core/models/feedback_report.dart';
import '../../../core/services/feedback_service.dart';
import 'local_llm_service.dart';

/// Member 4 - Rule-based AI Feedback Engine + Optional Local LLM Integration
class RuleBasedFeedbackEngine implements FeedbackService {
  final LocalLlmService? llmService;

  RuleBasedFeedbackEngine({this.llmService});

  @override
  Future<FeedbackReport> generate({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    DocumentResult? document,
    required String speakingGoal,
  }) async {
    List<FeedbackItem> strengths = [];
    List<FeedbackItem> improvements = [];
    List<EvidencePoint> evidenceList = [];
    List<String> limitations = [];

    double totalScorePoints = 0;
    double maxScorePoints = 0;

    // --- 1. SPEECH METRICS EVALUATION ---
    if (speech.wordCount > 0) {
      // WPM Evaluation (Target: 120 - 160 WPM)
      double wpm = speech.wordsPerMinute;
      maxScorePoints += 30;
      if (wpm >= 120 && wpm <= 160) {
        totalScorePoints += 30;
        evidenceList.add(EvidencePoint(
          metricName: 'Speaking Rate',
          measuredValue: '${wpm.toStringAsFixed(1)} WPM',
          targetRange: '120 - 160 WPM',
          status: EvidenceStatus.excellent,
          category: 'speech',
        ));
        strengths.add(FeedbackItem(
          id: 'speech_wpm_good',
          title: 'Ideal Pacing',
          description: 'Your speaking pace is steady and easy for the audience to follow.',
          category: 'speech',
          measuredEvidence: 'Measured rate: ${wpm.toStringAsFixed(1)} WPM (Ideal range: 120-160 WPM).',
          actionableTip: 'Maintain this conversational pace during key points.',
          isStrength: true,
        ));
      } else if (wpm > 160) {
        totalScorePoints += 15;
        evidenceList.add(EvidencePoint(
          metricName: 'Speaking Rate',
          measuredValue: '${wpm.toStringAsFixed(1)} WPM',
          targetRange: '120 - 160 WPM',
          status: EvidenceStatus.needsWork,
          category: 'speech',
        ));
        improvements.add(FeedbackItem(
          id: 'speech_wpm_fast',
          title: 'Rapid Pacing',
          description: 'Your speaking pace is slightly fast, which can make key points harder to digest.',
          category: 'speech',
          measuredEvidence: 'Measured rate: ${wpm.toStringAsFixed(1)} WPM (Threshold: >160 WPM).',
          actionableTip: 'Insert deliberate 1-2 second pauses between main ideas.',
          isStrength: false,
        ));
      } else {
        totalScorePoints += 15;
        evidenceList.add(EvidencePoint(
          metricName: 'Speaking Rate',
          measuredValue: '${wpm.toStringAsFixed(1)} WPM',
          targetRange: '120 - 160 WPM',
          status: EvidenceStatus.needsWork,
          category: 'speech',
        ));
        improvements.add(FeedbackItem(
          id: 'speech_wpm_slow',
          title: 'Slow Pacing',
          description: 'Your pace is below the recommended range, which may reduce speech momentum.',
          category: 'speech',
          measuredEvidence: 'Measured rate: ${wpm.toStringAsFixed(1)} WPM (Ideal: 120-160 WPM).',
          actionableTip: 'Practice reading sentences with active forward energy.',
          isStrength: false,
        ));
      }

      // Filler Words Evaluation
      maxScorePoints += 25;
      int fillers = speech.totalFillers;
      if (fillers <= 2) {
        totalScorePoints += 25;
        evidenceList.add(EvidencePoint(
          metricName: 'Filler Words',
          measuredValue: '$fillers detected',
          targetRange: '0 - 2 fillers',
          status: EvidenceStatus.excellent,
          category: 'speech',
        ));
        strengths.add(FeedbackItem(
          id: 'speech_fillers_low',
          title: 'Clean Articulation',
          description: 'Very few vocal fillers were detected in your delivery.',
          category: 'speech',
          measuredEvidence: 'Detected fillers: $fillers count (${speech.fillerOccurrences}).',
          actionableTip: 'Keep using silent pauses instead of filler words.',
          isStrength: true,
        ));
      } else {
        totalScorePoints += math.max(0, 25 - (fillers * 5));
        evidenceList.add(EvidencePoint(
          metricName: 'Filler Words',
          measuredValue: '$fillers detected',
          targetRange: '0 - 2 fillers',
          status: EvidenceStatus.needsWork,
          category: 'speech',
        ));
        improvements.add(FeedbackItem(
          id: 'speech_fillers_high',
          title: 'Frequent Filler Words',
          description: 'Noticed vocal placeholders such as "um" or "uh" during transitions.',
          category: 'speech',
          measuredEvidence: 'Detected fillers: $fillers count (${speech.fillerOccurrences}).',
          actionableTip: 'Pause silently when planning your next sentence instead of uttering placeholders.',
          isStrength: false,
        ));
      }
    } else {
      limitations.add('Speech audio was empty or unreadable; speech metrics were skipped.');
    }

    // --- 2. POSE METRICS EVALUATION ---
    if (pose != null && pose.isPersonInFrame && pose.analysisQuality != AnalysisQuality.unavailable) {
      // Body Sway Evaluation (Target: < 4.0 cm)
      maxScorePoints += 25;
      double sway = pose.bodySwayCm;
      if (sway <= 4.0) {
        totalScorePoints += 25;
        evidenceList.add(EvidencePoint(
          metricName: 'Body Stability',
          measuredValue: '${sway.toStringAsFixed(1)} cm sway',
          targetRange: '< 4.0 cm sway',
          status: EvidenceStatus.excellent,
          category: 'pose',
        ));
        strengths.add(FeedbackItem(
          id: 'pose_sway_stable',
          title: 'Grounded Stance',
          description: 'Your posture remained stable with minimal side-to-side body sway.',
          category: 'pose',
          measuredEvidence: 'Measured torso displacement: ${sway.toStringAsFixed(1)} cm sway.',
          actionableTip: 'Maintain balanced weight distribution on both feet.',
          isStrength: true,
        ));
      } else {
        totalScorePoints += 10;
        evidenceList.add(EvidencePoint(
          metricName: 'Body Stability',
          measuredValue: '${sway.toStringAsFixed(1)} cm sway',
          targetRange: '< 4.0 cm sway',
          status: EvidenceStatus.warning,
          category: 'pose',
        ));
        improvements.add(FeedbackItem(
          id: 'pose_sway_high',
          title: 'Torso Swaying',
          description: 'Observable side-to-side torso movement was detected during speech.',
          category: 'pose',
          measuredEvidence: 'Measured torso displacement: ${sway.toStringAsFixed(1)} cm sway (Threshold: 4.0 cm).',
          actionableTip: 'Plant both feet shoulder-width apart to create a solid physical base.',
          isStrength: false,
        ));
      }

      // Upper Body Movement & Gesture Activity
      maxScorePoints += 20;
      double gesture = pose.handGestureActivityScore;
      if (gesture >= 40.0) {
        totalScorePoints += 20;
        evidenceList.add(EvidencePoint(
          metricName: 'Hand Gestures',
          measuredValue: '${gesture.toStringAsFixed(0)} / 100 activity',
          targetRange: '40 - 80 score',
          status: EvidenceStatus.good,
          category: 'pose',
        ));
        strengths.add(FeedbackItem(
          id: 'pose_gesture_active',
          title: 'Natural Hand Gestures',
          description: 'You effectively used hand gestures to emphasize points.',
          category: 'pose',
          measuredEvidence: 'Measured gesture activity score: ${gesture.toStringAsFixed(0)} / 100.',
          actionableTip: 'Continue gesturing naturally above waist level.',
          isStrength: true,
        ));
      } else {
        totalScorePoints += 10;
        evidenceList.add(EvidencePoint(
          metricName: 'Hand Gestures',
          measuredValue: '${gesture.toStringAsFixed(0)} / 100 activity',
          targetRange: '40 - 80 score',
          status: EvidenceStatus.needsWork,
          category: 'pose',
        ));
        improvements.add(FeedbackItem(
          id: 'pose_gesture_low',
          title: 'Restrained Gesture Activity',
          description: 'Hand movements remained static or below waist height.',
          category: 'pose',
          measuredEvidence: 'Measured gesture activity score: ${gesture.toStringAsFixed(0)} / 100.',
          actionableTip: 'Bring your hands up to chest level to illustrate key concepts visually.',
          isStrength: false,
        ));
      }

      limitations.addAll(pose.qualityLimitations);
    } else {
      limitations.add('Camera video was disabled or unreadable; pose analysis was omitted (Partial analysis mode).');
    }

    // Combined Rule Evaluation (e.g. Fast Speech + Excessive Sway)
    if (speech.wordsPerMinute > 160 && pose != null && pose.bodySwayCm > 5.0) {
      improvements.add(const FeedbackItem(
        id: 'combined_pace_sway',
        title: 'High Physical & Vocal Pace',
        description: 'Both your speaking rate and physical sway are elevated simultaneously.',
        category: 'combined',
        measuredEvidence: 'WPM > 160 and body sway > 5.0 cm observed.',
        actionableTip: 'Take a deep breath, ground your feet, and slow down your first sentence.',
        isStrength: false,
      ));
    }

    double finalScore = maxScorePoints > 0 ? (totalScorePoints / maxScorePoints) * 100.0 : 70.0;
    finalScore = double.parse(finalScore.clamp(0.0, 100.0).toStringAsFixed(1));

    String summaryText;
    if (finalScore >= 85) {
      summaryText = 'Excellent presentation delivery! Clear pace, good posture, and confident delivery for "$speakingGoal".';
    } else if (finalScore >= 70) {
      summaryText = 'Solid practice session. Good foundation with minor areas for pacing or body stability refinement.';
    } else {
      summaryText = 'Good effort! Focus on slowing your delivery rate and keeping a grounded stance during practice.';
    }

    // Optional LLM Enhancement (Qwen3-0.6B)
    String? promptText;
    String? llmExplanation;
    if (llmService != null) {
      promptText = llmService!.buildCoachingPrompt(
        speech: speech,
        pose: pose,
        speakingGoal: speakingGoal,
      );
      llmExplanation = await llmService!.generateResponse(promptText);
    }

    return FeedbackReport(
      overallScore: finalScore,
      summary: summaryText,
      strengths: strengths,
      improvements: improvements,
      evidenceList: evidenceList,
      limitations: limitations,
      generatedAt: DateTime.now(),
      localLlmPrompt: promptText,
      llmResponse: llmExplanation,
    );
  }
}
