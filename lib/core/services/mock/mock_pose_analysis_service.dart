import '../../models/pose_metrics.dart';
import '../pose_analysis_service.dart';

/// TODO(backend): replace with MediaPipe pose landmarker pipeline.
class MockPoseAnalysisService implements PoseAnalysisService {
  @override
  Future<PoseMetrics> analyzePose(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return PoseMetrics(
      sessionId: sessionId,
      eyeContactPct: 78,
      postureScore: 82,
      headSteadinessPct: 71,
    );
  }
}
