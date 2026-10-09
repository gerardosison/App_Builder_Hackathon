/// Result of parsing + analyzing an uploaded speech script
/// (PDF/DOCX/TXT). Produced by the document services on-device.
class DocumentResult {
  const DocumentResult({
    required this.fileName,
    required this.overallScore,
    required this.readability,
    required this.estimatedMinutes,
    required this.wordCount,
    required this.sections,
    required this.strengths,
    required this.missingConcepts,
    required this.tips,
  });

  final String fileName;
  final int overallScore;
  final String readability;
  final double estimatedMinutes;
  final int wordCount;
  final List<DocSection> sections;
  final List<String> strengths;
  final List<String> missingConcepts;
  final List<String> tips;
}

class DocSection {
  const DocSection(this.name, this.score, this.note);
  final String name;
  final int score;
  final String note;
}
