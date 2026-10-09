/// Time-series speech metrics captured during a take.
/// TODO(ai): populated by Whisper + the speech metrics calculator.
class SpeechMetrics {
  const SpeechMetrics({
    required this.sessionId,
    required this.avgWpm,
    required this.peakWpm,
    required this.fillerCount,
    required this.longPauses,
  });

  final String sessionId;
  final int avgWpm;
  final int peakWpm;
  final int fillerCount;
  final int longPauses;
}
