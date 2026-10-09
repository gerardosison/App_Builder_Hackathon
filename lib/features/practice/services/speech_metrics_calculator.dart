/// Speech Metrics Calculator for analyzing pacing, filler words, and delivery
class SpeechMetricsCalculator {
  const SpeechMetricsCalculator();

  /// Calculates words per minute (WPM)
  double calculateWordsPerMinute({
    required int wordCount,
    required int durationSeconds,
  }) {
    if (durationSeconds <= 0) return 0.0;
    return (wordCount / durationSeconds) * 60.0;
  }

  /// Counts occurrences of common filler words
  int countFillerWords(String transcript) {
    if (transcript.isEmpty) return 0;
    final lower = transcript.toLowerCase();
    final fillers = [
      'um',
      'uh',
      'like',
      'you know',
      'sort of',
      'basically',
      'actually',
    ];
    int count = 0;
    for (final filler in fillers) {
      final matches = RegExp(r'\b' + RegExp.escape(filler) + r'\b')
          .allMatches(lower);
      count += matches.length;
    }
    return count;
  }

  /// Calculates delivery confidence score (0 to 100)
  int calculateDeliveryScore({
    required double wpm,
    required int fillerWordCount,
    required int durationSeconds,
  }) {
    int score = 100;

    // Ideal WPM range is 120 - 150
    if (wpm < 100 || wpm > 170) {
      score -= 15;
    } else if (wpm < 120 || wpm > 150) {
      score -= 5;
    }

    // Deduct for excessive filler words
    score -= (fillerWordCount * 3).clamp(0, 30);

    return score.clamp(50, 98);
  }
}

