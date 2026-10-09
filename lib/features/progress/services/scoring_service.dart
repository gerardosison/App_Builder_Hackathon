import '../../../core/models/practice_session.dart';

/// Business rule (mock): stars are earned only when a speech improves
/// over the previous one; the first speech earns none.
class ScoringService {
  const ScoringService();

  /// Stars to award for [session] vs. its predecessor.
  int starsFor(PracticeSession session, PracticeSession? previous) {
    if (previous == null || !session.improved) return 0;
    // Simple heuristic: 1–3 stars by pace score.
    if (session.paceScore >= 85) return 3;
    if (session.paceScore >= 70) return 2;
    return 1;
  }
}
