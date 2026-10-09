class TranscriptSegment {
  final int id;
  final double startSeconds;
  final double endSeconds;
  final String text;

  const TranscriptSegment({
    required this.id,
    required this.startSeconds,
    required this.endSeconds,
    required this.text,
  });

  double get durationSeconds => endSeconds - startSeconds;
}
