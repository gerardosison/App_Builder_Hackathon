class DocumentResult {
  final String documentId;
  final String title;
  final String extractedText;
  final bool isReadable;
  final List<String> keySections;
  final String? rejectionReason;

  const DocumentResult({
    required this.documentId,
    required this.title,
    required this.extractedText,
    this.isReadable = true,
    this.keySections = const [],
    this.rejectionReason,
  });

  factory DocumentResult.empty() {
    return const DocumentResult(
      documentId: '',
      title: '',
      extractedText: '',
      isReadable: false,
      rejectionReason: 'No document uploaded',
    );
  }
}
