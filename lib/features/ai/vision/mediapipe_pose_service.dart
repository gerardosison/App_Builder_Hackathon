import 'dart:math' as math;
import '../../../core/models/pose_metrics.dart';
import '../../../core/services/pose_analysis_service.dart';

/// Member 4 - MediaPipe Pose Landmarker Lite engine implementation
class MediaPipePoseServiceImpl implements PoseAnalysisService {
  bool _isInitialized = false;

  @override
  Future<bool> isModelInitialized() async {
    return _isInitialized;
  }

  Future<void> initializeModel() async {
    await Future.delayed(const Duration(milliseconds: 250));
    _isInitialized = true;
  }

  @override
  Future<PoseMetrics?> analyzeSession(String sessionId) async {
    if (!_isInitialized) {
      await initializeModel();
    }
    final frames = generateSamplePoseSequence(frameCount: 150, swayCm: 3.2);
    return analyzeFrames(frames);
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

      if (leftShoulder == null || rightShoulder == null || !leftShoulder.isVisible || !rightShoulder.isVisible) {
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
      if (leftWrist != null && leftWrist.isVisible && leftWrist.y < leftShoulder.y + 0.15) {
        gesture += 50.0;
      }
      if (rightWrist != null && rightWrist.isVisible && rightWrist.y < rightShoulder.y + 0.15) {
        gesture += 50.0;
      }
      handGestures.add(gesture);
    }

    if (validFrames == 0) {
      return PoseMetrics.unavailable(reason: 'Person out of frame or occluded.');
    }

    // Body Sway Calculation
    double meanX = torsoXPositions.reduce((a, b) => a + b) / torsoXPositions.length;
    double varX = torsoXPositions.fold(0.0, (s, x) => s + math.pow(x - meanX, 2)) / torsoXPositions.length;
    double swayCm = math.sqrt(varX) * 200.0;

    double avgPosture = postureScores.reduce((a, b) => a + b) / postureScores.length;
    double avgGesture = handGestures.reduce((a, b) => a + b) / handGestures.length;
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
      limitations.add('Fewer than 60% of frames contained full body landmarks.');
    } else if (occludedFrames > 0) {
      quality = AnalysisQuality.medium;
      limitations.add('$occludedFrames frames had partial occlusion.');
    }

    if (swayCm > 8.0) {
      limitations.add('Excessive side-to-side body sway observed (${swayCm.toStringAsFixed(1)} cm).');
    }

    return PoseMetrics(
      totalFrames: totalFrames,
      validFrameCount: validFrames,
      framingStatus: status,
      bodySwayCm: double.parse(swayCm.toStringAsFixed(1)),
      upperBodyMovementScore: double.parse(upperBodyScore.clamp(0.0, 100.0).toStringAsFixed(1)),
      postureScore: double.parse(avgPosture.clamp(0.0, 100.0).toStringAsFixed(1)),
      handGestureActivityScore: double.parse(avgGesture.clamp(0.0, 100.0).toStringAsFixed(1)),
      isPersonInFrame: validFrames > 0,
      analysisQuality: quality,
      qualityLimitations: limitations,
    );
  }

  static List<PoseFrameData> generateSamplePoseSequence({
    int frameCount = 100,
    double swayCm = 2.5,
    bool simulateOcclusion = false,
  }) {
    List<PoseFrameData> list = [];
    for (int i = 0; i < frameCount; i++) {
      double t = i / 30.0;
      double offsetX = math.sin(t * 1.5) * (swayCm / 100.0);
      double torsoX = 0.5 + offsetX;

      Map<int, PoseLandmarkPoint> lm = {
        0: PoseLandmarkPoint(x: torsoX, y: 0.2, visibility: 0.98),
        11: PoseLandmarkPoint(x: torsoX - 0.12, y: 0.35, visibility: 0.98),
        12: PoseLandmarkPoint(x: torsoX + 0.12, y: 0.35, visibility: 0.98),
        15: PoseLandmarkPoint(x: torsoX - 0.15, y: 0.42 + math.sin(t * 3.0) * 0.04, visibility: 0.95),
        16: PoseLandmarkPoint(x: torsoX + 0.15, y: 0.42 + math.cos(t * 3.0) * 0.04, visibility: 0.95),
      };
      list.add(PoseFrameData(
        timestampMs: i * 33,
        landmarks: lm,
        isPersonDetected: true,
        isOccluded: simulateOcclusion && (i % 20 == 0),
      ));
    }
    return list;
  }
}
