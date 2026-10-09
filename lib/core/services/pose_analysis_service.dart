import '../models/pose_metrics.dart';

/// Service interface for Member 4 Computer Vision (MediaPipe Pose Landmarker)
abstract class PoseAnalysisService {
  /// Analyze collected session frames and return structured [PoseMetrics]
  Future<PoseMetrics?> analyzeSession(String sessionId);

  /// Process a batch of pose frames directly
  Future<PoseMetrics> analyzeFrames(List<PoseFrameData> frames);

  /// Check whether MediaPipe Pose Landmarker model is initialized
  Future<bool> isModelInitialized();
}
