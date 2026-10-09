import 'dart:math' as math;

/// Member 4 - Pose Metrics Calculator for MediaPipe landmarks
class PoseMetricsCalculator {
  /// Computes body sway deviation in cm from torso center coordinates
  double calculateBodySwayCm(List<double> torsoXPositions) {
    if (torsoXPositions.isEmpty) return 0.0;
    double mean = torsoXPositions.reduce((a, b) => a + b) / torsoXPositions.length;
    double variance = torsoXPositions.fold(0.0, (s, x) => s + math.pow(x - mean, 2)) / torsoXPositions.length;
    double stdDev = math.sqrt(variance);
    return double.parse((stdDev * 282.8).toStringAsFixed(1));
  }

  /// Calculates posture alignment score from shoulder & head landmarks
  double calculatePostureScore({
    required double shoulderDx,
    required double shoulderDy,
    required double headOffset,
  }) {
    double angleDeg = (math.atan2(shoulderDy, shoulderDx).abs() * 180 / math.pi);
    double score = math.max(0.0, 100.0 - (angleDeg * 5.0) - (headOffset * 80.0));
    return double.parse(score.clamp(0.0, 100.0).toStringAsFixed(1));
  }
}
