import '../../../core/models/transcript_segment.dart';

/// Member 4 - Speech Segmenter: Breaks ASR outputs into timestamped segments and identifies pauses
class SpeechSegmenter {
  /// Extract pause durations between adjacent segments
  List<double> calculatePauses(List<TranscriptSegment> segments) {
    if (segments.length < 2) return [];
    List<double> pauses = [];
    for (int i = 0; i < segments.length - 1; i++) {
      double pauseDuration = segments[i + 1].startSeconds - segments[i].endSeconds;
      if (pauseDuration > 0.3) {
        pauses.add(double.parse(pauseDuration.toStringAsFixed(2)));
      }
    }
    return pauses;
  }
}
