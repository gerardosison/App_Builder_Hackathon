enum EvidenceStatus {
  excellent,
  good,
  needsWork,
  warning;

  String get label {
    switch (this) {
      case EvidenceStatus.excellent:
        return 'Excellent';
      case EvidenceStatus.good:
        return 'Good';
      case EvidenceStatus.needsWork:
        return 'Needs Work';
      case EvidenceStatus.warning:
        return 'Attention Needed';
    }
  }
}

class EvidencePoint {
  final String metricName;
  final String measuredValue;
  final String targetRange;
  final EvidenceStatus status;
  final String category; // 'pose', 'speech', 'system'

  const EvidencePoint({
    required this.metricName,
    required this.measuredValue,
    required this.targetRange,
    required this.status,
    required this.category,
  });
}

class FeedbackItem {
  final String id;
  final String title;
  final String description;
  final String category; // 'pose', 'speech', 'combined'
  final String measuredEvidence;
  final String actionableTip;
  final bool isStrength;

  const FeedbackItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.measuredEvidence,
    required this.actionableTip,
    required this.isStrength,
  });
}

class FeedbackReport {
  final double overallScore; // 0 - 100
  final String summary;
  final List<FeedbackItem> strengths;
  final List<FeedbackItem> improvements;
  final List<EvidencePoint> evidenceList;
  final List<String> limitations;
  final DateTime generatedAt;
  final String? localLlmPrompt;
  final String? llmResponse;
  final int starsEarned;
  final bool leveledUp;

  const FeedbackReport({
    required this.overallScore,
    required this.summary,
    required this.strengths,
    required this.improvements,
    required this.evidenceList,
    required this.limitations,
    required this.generatedAt,
    this.localLlmPrompt,
    this.llmResponse,
    this.starsEarned = 0,
    this.leveledUp = false,
  });

  factory FeedbackReport.empty() {
    return FeedbackReport(
      overallScore: 0.0,
      summary: 'No data analyzed.',
      strengths: const [],
      improvements: const [],
      evidenceList: const [],
      limitations: const ['No speech or pose metrics received.'],
      generatedAt: DateTime.now(),
      starsEarned: 0,
      leveledUp: false,
    );
  }
}
