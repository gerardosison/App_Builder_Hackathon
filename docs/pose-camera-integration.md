# Live pose tracking

Pose tracking uses the bundled Google ML Kit Pose Detection plugin. It runs
on-device and does not use the placeholder `pose_landmarker_lite.task` under
Android native assets. The camera adapter is
`lib/features/practice/services/pose_camera_session.dart`.

The practice UI owns the camera preview and should use the same controller for
streaming and preview:

```dart
final cameras = await availableCameras();
final camera = cameras.firstWhere(
  (item) => item.lensDirection == CameraLensDirection.front,
);
final controller = PoseCameraSession.createCameraController(camera);
await controller.initialize();

final poseSession = PoseCameraSession();
await poseSession.start(controller, camera);
// Show CameraPreview(controller) during the practice.

final metrics = await poseSession.stop(sessionId);
// Pass metrics to the feedback flow.
await poseSession.dispose();
await controller.dispose();
```

On Android, frames must be NV21; the factory configures that format. Frames
are throttled to one inference at a time so slow devices skip frames instead
of queuing camera work. `stop()` waits for the current inference before
calculating the session metrics. The screen should handle camera permission,
camera selection, and display `lastFrameError` if image conversion fails.
