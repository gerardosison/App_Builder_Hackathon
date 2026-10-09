/// Camera + microphone gate before entering the practice room.
/// Implemented by MockPermissionService today; swap for a real
/// permission plugin later.
abstract class PermissionService {
  Future<bool> requestCameraAndMic();
}
