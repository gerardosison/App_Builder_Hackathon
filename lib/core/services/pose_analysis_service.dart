import '../models/pose_metrics.dart';

/// On-device pose/eye-contact analysis seam (MediaPipe on the backend).
abstract class PoseAnalysisService {
  Future<PoseMetrics> analyzePose(String sessionId);
}
