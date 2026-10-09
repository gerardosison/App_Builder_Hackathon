import 'dart:async';
import 'dart:io';
import 'dart:ui' show Size;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../core/models/pose_metrics.dart';
import '../../ai/vision/mediapipe_pose_service.dart';

/// Bridges a live Flutter camera image stream into on-device ML Kit pose
/// detection. The camera screen owns the preview/controller and calls start
/// and stop around a practice session.
class PoseCameraSession {
  PoseCameraSession({MediaPipePoseServiceImpl? poseService})
    : _poseService = poseService ?? MediaPipePoseServiceImpl();

  final MediaPipePoseServiceImpl _poseService;
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  bool _processingFrame = false;
  bool _isRunning = false;

  String? lastFrameError;

  bool get isRunning => _isRunning;

  /// Creates a camera controller with the single-plane format ML Kit accepts.
  /// Keep this controller for the preview and give the same instance to
  /// [start].
  static CameraController createCameraController(CameraDescription camera) =>
      CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

  Future<void> start(
    CameraController controller,
    CameraDescription camera,
  ) async {
    if (_isRunning) throw StateError('Pose camera session is already running.');
    if (!controller.value.isInitialized) {
      throw StateError('Initialize the camera before starting pose tracking.');
    }
    if (!controller.supportsImageStreaming()) {
      throw StateError('This camera does not support image streaming.');
    }

    _cameraController = controller;
    _cameraDescription = camera;
    _processingFrame = false;
    lastFrameError = null;
    _poseService.startSession();
    await _poseService.initializeModel();
    _isRunning = true;
    try {
      await controller.startImageStream(_onCameraImage);
    } catch (_) {
      _isRunning = false;
      _cameraController = null;
      _cameraDescription = null;
      rethrow;
    }
  }

  /// Stops camera-frame collection and returns the computed practice metrics.
  /// The camera preview controller itself remains owned by the caller.
  Future<PoseMetrics> stop(String sessionId) async {
    final controller = _cameraController;
    if (controller != null && controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    _isRunning = false;
    _cameraController = null;
    _cameraDescription = null;
    while (_processingFrame) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    return _poseService.finishSession(sessionId);
  }

  Future<void> dispose() async {
    if (_isRunning && _cameraController?.value.isStreamingImages == true) {
      await _cameraController!.stopImageStream();
    }
    _isRunning = false;
    _cameraController = null;
    _cameraDescription = null;
    await _poseService.dispose();
  }

  void _onCameraImage(CameraImage image) {
    if (!_isRunning || _processingFrame) return;
    final inputImage = _toInputImage(image);
    if (inputImage == null) {
      lastFrameError =
          'Camera image format is unsupported; Android requires NV21.';
      return;
    }

    _processingFrame = true;
    unawaited(_process(inputImage));
  }

  Future<void> _process(InputImage image) async {
    try {
      await _poseService.processImage(image);
    } catch (error) {
      lastFrameError = error.toString();
    } finally {
      _processingFrame = false;
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final camera = _cameraDescription;
    final controller = _cameraController;
    if (camera == null || controller == null || image.planes.length != 1) {
      return null;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    const orientationDegrees = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    final deviceRotation =
        orientationDegrees[controller.value.deviceOrientation];
    if (deviceRotation == null) return null;

    final rotationDegrees = camera.lensDirection == CameraLensDirection.front
        ? (camera.sensorOrientation + deviceRotation) % 360
        : (camera.sensorOrientation - deviceRotation + 360) % 360;
    final rotation = InputImageRotationValue.fromRawValue(rotationDegrees);
    if (rotation == null) return null;

    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
