import '../models/feedback_report.dart';
import '../models/practice_session.dart';

/// Turns a recorded take into a FeedbackReport (speech + pose metrics +
/// coaching tips). Mocked today; real impl combines Whisper, MediaPipe
/// and the local LLM.
abstract class FeedbackService {
  Future<FeedbackReport> analyze({required bool improved});
  List<PracticeSession> history();
}
