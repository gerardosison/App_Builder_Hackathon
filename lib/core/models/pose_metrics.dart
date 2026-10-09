/// Pose/eye-contact metrics captured by MediaPipe during a take.
/// TODO(ai): populated by the pose landmarker pipeline.
class PoseMetrics {
  const PoseMetrics({
    required this.sessionId,
    required this.eyeContactPct,
    required this.postureScore,
    required this.headSteadinessPct,
  });

  final String sessionId;
  final int eyeContactPct;
  final int postureScore;
  final int headSteadinessPct;
}
