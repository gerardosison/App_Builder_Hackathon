import 'package:flutter/foundation.dart';

/// Feedback summary model
class SessionFeedbackData {
  const SessionFeedbackData({
    required this.topic,
    required this.durationSeconds,
    required this.wpm,
    required this.fillerWordCount,
    required this.overallScore,
    required this.eyeContactScore,
    required this.starsEarned,
  });

  final String topic;
  final int durationSeconds;
  final double wpm;
  final int fillerWordCount;
  final int overallScore;
  final int eyeContactScore;
  final int starsEarned;
}

class FeedbackProvider extends ChangeNotifier {
  SessionFeedbackData? _latestFeedback;

  SessionFeedbackData? get latestFeedback => _latestFeedback;

  void saveFeedback(SessionFeedbackData data) {
    _latestFeedback = data;
    notifyListeners();
  }
}

final feedbackProvider = FeedbackProvider();

