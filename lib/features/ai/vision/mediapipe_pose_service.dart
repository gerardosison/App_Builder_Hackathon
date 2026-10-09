import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/models/pose_metrics.dart';
import '../../../core/services/pose_analysis_service.dart';

/// On-device pose detection for camera frames using Google ML Kit.
///
/// The camera screen should call [processImage] for each camera frame, then
/// call [finishSession] when the practice ends. No separate .task model asset
/// is used by this ML Kit implementation.
class MediaPipePoseServiceImpl implements PoseAnalysisService {
  bool _isInitialized = false;
  PoseDetector? _detector;
  final Map<String, List<PoseFrameData>> _sessions = {};
  final List<PoseFrameData> _activeFrames = [];

  @override
  Future<bool> isModelInitialized() async {
    return _isInitialized;
  }

  Future<void> initializeModel() async {
    _detector ??= PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );
    _isInitialized = _detector != null;
  }

  @override
  Future<PoseMetrics?> analyzeSession(String sessionId) async {
    final frames = _sessions.remove(sessionId);
    if (frames == null || frames.isEmpty) {
      return PoseMetrics.unavailable(
        reason: 'No camera frames were received for session "$sessionId".',
      );
    }
    return analyzeFrames(frames);
  }

  /// Starts collecting frame results for a practice session.
  void startSession() => _activeFrames.clear();

  /// Runs real on-device pose detection on one camera frame and stores its
  /// landmarks for session feedback. Construct [InputImage] from the camera
  /// frame using the camera plugin's image format, rotation, and row stride.
  Future<PoseFrameData> processImage(
    InputImage image, {
    int? timestampMs,
  }) async {
    await initializeModel();
    final size = image.metadata?.size;
    if (size == null || size.width <= 0 || size.height <= 0) {
      throw ArgumentError(
        'Camera InputImage metadata must include a valid frame size.',
      );
    }
    final poses = await _detector!.processImage(image);
    final frame = PoseFrameData(
      timestampMs: timestampMs ?? DateTime.now().millisecondsSinceEpoch,
      landmarks: poses.isEmpty
          ? const {}
          : _toMediaPipeIndices(poses.first, size.width, size.height),
      isPersonDetected: poses.isNotEmpty,
      hasMultiplePeople: poses.length > 1,
    );
    _activeFrames.add(frame);
    return frame;
  }

  /// Ends collection and returns measured posture, sway, and gesture metrics.
  Future<PoseMetrics> finishSession(String sessionId) async {
    final frames = List<PoseFrameData>.unmodifiable(_activeFrames);
    _sessions[sessionId] = frames;
    _activeFrames.clear();
    return (await analyzeSession(sessionId)) ??
        PoseMetrics.unavailable(
          reason: 'Pose analysis did not return a result.',
        );
  }

  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
    _isInitialized = false;
    _activeFrames.clear();
    _sessions.clear();
  }

  Map<int, PoseLandmarkPoint> _toMediaPipeIndices(
    Pose pose,
    double width,
    double height,
  ) {
    const indices = <PoseLandmarkType, int>{
      PoseLandmarkType.nose: 0,
      PoseLandmarkType.leftShoulder: 11,
      PoseLandmarkType.rightShoulder: 12,
      PoseLandmarkType.leftWrist: 15,
      PoseLandmarkType.rightWrist: 16,
    };
    final result = <int, PoseLandmarkPoint>{};
    for (final entry in indices.entries) {
      final landmark = pose.landmarks[entry.key];
      if (landmark == null) continue;
      result[entry.value] = PoseLandmarkPoint(
        x: (landmark.x / width).clamp(0.0, 1.0),
        y: (landmark.y / height).clamp(0.0, 1.0),
        z: landmark.z,
        visibility: landmark.likelihood,
      );
    }
    return result;
  }

  @override
  Future<PoseMetrics> analyzeFrames(List<PoseFrameData> frames) async {
    if (frames.isEmpty) {
      return PoseMetrics.unavailable(reason: 'No camera frames received.');
    }

    int totalFrames = frames.length;
    int validFrames = 0;
    int occludedFrames = 0;
    int multiplePeopleFrames = 0;
    int outOfFrameCount = 0;

    List<double> torsoXPositions = [];
    List<double> postureScores = [];
    List<double> handGestures = [];

    int leftCount = 0;
    int rightCount = 0;
    int centerCount = 0;

    for (var f in frames) {
      if (!f.isPersonDetected) {
        outOfFrameCount++;
        continue;
      }
      if (f.hasMultiplePeople) multiplePeopleFrames++;
      if (f.isOccluded) occludedFrames++;

      final lm = f.landmarks;
      final leftShoulder = lm[11];
      final rightShoulder = lm[12];
      final nose = lm[0];

      if (leftShoulder == null ||
          rightShoulder == null ||
          !leftShoulder.isVisible ||
          !rightShoulder.isVisible) {
        occludedFrames++;
        continue;
      }

      validFrames++;
      double torsoX = (leftShoulder.x + rightShoulder.x) / 2.0;
      torsoXPositions.add(torsoX);

      if (torsoX < 0.35) {
        leftCount++;
      } else if (torsoX > 0.65) {
        rightCount++;
      } else {
        centerCount++;
      }

      // Posture alignment
      double dx = rightShoulder.x - leftShoulder.x;
      double dy = rightShoulder.y - leftShoulder.y;
      double angleDeg = (math.atan2(dy, dx).abs() * 180 / math.pi);
      double framePosture = math.max(0.0, 100.0 - (angleDeg * 5.0));
      if (nose != null && nose.isVisible) {
        double headOff = (nose.x - torsoX).abs();
        framePosture = math.max(0.0, framePosture - (headOff * 80.0));
      }
      postureScores.add(framePosture);

      // Hand gesture estimation
      final leftWrist = lm[15];
      final rightWrist = lm[16];
      double gesture = 0.0;
      if (leftWrist != null &&
          leftWrist.isVisible &&
          leftWrist.y < leftShoulder.y + 0.15) {
        gesture += 50.0;
      }
      if (rightWrist != null &&
          rightWrist.isVisible &&
          rightWrist.y < rightShoulder.y + 0.15) {
        gesture += 50.0;
      }
      handGestures.add(gesture);
    }

    if (validFrames == 0) {
      return PoseMetrics.unavailable(
        reason: 'Person out of frame or occluded.',
      );
    }

    // Body Sway Calculation
    double meanX =
        torsoXPositions.reduce((a, b) => a + b) / torsoXPositions.length;
    double varX =
        torsoXPositions.fold(0.0, (s, x) => s + math.pow(x - meanX, 2)) /
        torsoXPositions.length;
    double swayCm = math.sqrt(varX) * 200.0;

    double avgPosture =
        postureScores.reduce((a, b) => a + b) / postureScores.length;
    double avgGesture =
        handGestures.reduce((a, b) => a + b) / handGestures.length;
    double upperBodyScore = (avgPosture * 0.4) + (avgGesture * 0.6);

    FramingStatus status = FramingStatus.centered;
    if (outOfFrameCount > totalFrames * 0.4) {
      status = FramingStatus.outOfFrame;
    } else if (multiplePeopleFrames > totalFrames * 0.3) {
      status = FramingStatus.multiplePeople;
    } else if (leftCount > centerCount && leftCount > rightCount) {
      status = FramingStatus.offCenterLeft;
    } else if (rightCount > centerCount && rightCount > leftCount) {
      status = FramingStatus.offCenterRight;
    }

    AnalysisQuality quality = AnalysisQuality.high;
    List<String> limitations = [];
    if (validFrames < totalFrames * 0.6) {
      quality = AnalysisQuality.low;
      limitations.add(
        'Fewer than 60% of frames contained full body landmarks.',
      );
    } else if (occludedFrames > 0) {
      quality = AnalysisQuality.medium;
      limitations.add('$occludedFrames frames had partial occlusion.');
    }

    if (swayCm > 8.0) {
      limitations.add(
        'Excessive side-to-side body sway observed (${swayCm.toStringAsFixed(1)} cm).',
      );
    }

    return PoseMetrics(
      totalFrames: totalFrames,
      validFrameCount: validFrames,
      framingStatus: status,
      bodySwayCm: double.parse(swayCm.toStringAsFixed(1)),
      upperBodyMovementScore: double.parse(
        upperBodyScore.clamp(0.0, 100.0).toStringAsFixed(1),
      ),
      postureScore: double.parse(
        avgPosture.clamp(0.0, 100.0).toStringAsFixed(1),
      ),
      handGestureActivityScore: double.parse(
        avgGesture.clamp(0.0, 100.0).toStringAsFixed(1),
      ),
      isPersonInFrame: validFrames > 0,
      analysisQuality: quality,
      qualityLimitations: limitations,
    );
  }
}
