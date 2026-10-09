import '../../models/feedback_report.dart';
import '../../models/practice_session.dart';
import '../../models/transcript_segment.dart';
import '../feedback_service.dart';

/// TODO(backend): replace with real pipeline (Whisper + pose + LLM).
/// The mock returns a canned report; `improved` picks the variant.
class MockFeedbackService implements FeedbackService {
  @override
  Future<FeedbackReport> analyze({required bool improved}) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final session = PracticeSession(
      id: 's-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      title: 'History Presentation',
      duration: const Duration(minutes: 3, seconds: 24),
      avgWpm: 142,
      fillerCount: improved ? 3 : 9,
      eyeContactPct: improved ? 78 : 61,
      paceScore: improved ? 84 : 66,
      starsEarned: improved ? 3 : 0,
      improved: improved,
      goal: 'Class Presentation',
    );
    return FeedbackReport(
      session: session,
      overallScore: improved ? 84 : 62,
      wpm: 142,
      fillerCount: session.fillerCount,
      eyeContactPct: session.eyeContactPct,
      pausesScore: improved ? 76 : 58,
      strengths: const [
        'Clear articulation through the introduction',
        'Strong opening hook kept the audience leaning in',
        'Confident closing statement',
      ],
      tips: const [
        'Pause for a full breath after key points — let them land.',
        'Swap "um" for a silent beat; you had 3 in the middle section.',
        'Scan left-to-right to lift eye contact above 80%.',
      ],
      transcript: const [
        TranscriptSegment(
            text: 'Good morning everyone, today I want to talk about '),
        TranscriptSegment(text: 'um', isFiller: true),
        TranscriptSegment(text: ' the industrial revolution and '),
        TranscriptSegment(text: 'uh', isFiller: true),
        TranscriptSegment(text: ' how it changed the way we live. '),
        TranscriptSegment(text: '[long pause]', isPause: true),
        TranscriptSegment(text: 'Factories transformed cities, and '),
        TranscriptSegment(text: 'like, ', isFiller: true),
        TranscriptSegment(text: 'they reshaped entire economies…'),
      ],
      improved: improved,
      isFirstSpeech: false,
      starsEarned: improved ? 3 : 0,
      leveledUp: improved,
    );
  }

  @override
  List<PracticeSession> history() => [
        PracticeSession(
          id: 's1',
          date: DateTime.now().subtract(const Duration(days: 1)),
          title: 'History Presentation',
          duration: const Duration(minutes: 3, seconds: 24),
          avgWpm: 142,
          fillerCount: 3,
          eyeContactPct: 78,
          paceScore: 84,
          starsEarned: 3,
          improved: true,
          goal: 'Class Presentation',
        ),
        PracticeSession(
          id: 's2',
          date: DateTime.now().subtract(const Duration(days: 3)),
          title: 'English Book Talk',
          duration: const Duration(minutes: 2, seconds: 41),
          avgWpm: 151,
          fillerCount: 8,
          eyeContactPct: 66,
          paceScore: 71,
          starsEarned: 2,
          improved: true,
          goal: 'Class Presentation',
        ),
        PracticeSession(
          id: 's3',
          date: DateTime.now().subtract(const Duration(days: 5)),
          title: 'Science Fair Pitch',
          duration: const Duration(minutes: 4, seconds: 2),
          avgWpm: 168,
          fillerCount: 14,
          eyeContactPct: 54,
          paceScore: 55,
          starsEarned: 0,
          improved: false,
          goal: 'Competition',
        ),
        PracticeSession(
          id: 's4',
          date: DateTime.now().subtract(const Duration(days: 8)),
          title: 'Debate Club Opener',
          duration: const Duration(minutes: 2, seconds: 10),
          avgWpm: 138,
          fillerCount: 5,
          eyeContactPct: 72,
          paceScore: 79,
          starsEarned: 2,
          improved: true,
          goal: 'Debate',
        ),
      ];
}
