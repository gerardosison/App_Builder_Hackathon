import 'practice_session.dart';
import 'transcript_segment.dart';

/// Post-session analysis: headline scores + strengths, tips and the
/// annotated transcript. Business rules: stars are only earned when the
/// speech improved over the previous one; the first speech earns none.
class FeedbackReport {
  const FeedbackReport({
    required this.session,
    required this.overallScore,
    required this.wpm,
    required this.fillerCount,
    required this.eyeContactPct,
    required this.pausesScore,
    required this.strengths,
    required this.tips,
    required this.transcript,
    required this.improved,
    required this.isFirstSpeech,
    required this.starsEarned,
    required this.leveledUp,
  });

  final PracticeSession session;
  final int overallScore;
  final int wpm;
  final int fillerCount;
  final int eyeContactPct;
  final int pausesScore;
  final List<String> strengths;
  final List<String> tips;
  final List<TranscriptSegment> transcript;
  final bool improved;
  final bool isFirstSpeech;
  final int starsEarned;
  final bool leveledUp;
}
