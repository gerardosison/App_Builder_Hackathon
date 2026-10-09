/// One span of a speech transcript, flagged when it's a filler word or
/// a long pause (Whisper output on the real backend).
class TranscriptSegment {
  const TranscriptSegment({
    required this.text,
    this.isFiller = false,
    this.isPause = false,
  });

  final String text;
  final bool isFiller;
  final bool isPause;
}
