import '../../models/pose_metrics.dart';
import '../pose_analysis_service.dart';

/// Fixture implementation for UI previews; production uses on-device pose detection.
class MockPoseAnalysisService implements PoseAnalysisService {
  @override
  Future<bool> isModelInitialized() async => true;

  @override
  Future<PoseMetrics?> analyzeSession(String sessionId) async =>
      PoseMetrics.unavailable(reason: 'Preview mode has no camera measurements.');

  @override
  Future<PoseMetrics> analyzeFrames(List<PoseFrameData> frames) async =>
      PoseMetrics.unavailable(reason: 'Preview mode has no camera measurements.');
}
