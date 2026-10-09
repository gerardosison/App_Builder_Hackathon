import '../../../core/models/user_profile.dart';

/// Auth seam — swap LocalAuthService for a real backend later.
abstract class AuthService {
  Future<UserProfile> login(String email, String password);
  Future<UserProfile> register(
      String name, String nickname, String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> logout();
}

/// Local mock auth — always succeeds with the canned user.
/// TODO(backend): real authentication.
class LocalAuthService implements AuthService {
  static const mockUser = UserProfile(
    name: 'Maya Chen',
    nickname: 'OratorMaya',
    email: 'maya.chen@school.edu',
    level: 2,
    stars: 7,
    streakDays: 4,
    totalSessions: 12,
    school: 'Riverside High',
  );

  @override
  Future<UserProfile> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return mockUser;
  }

  @override
  Future<UserProfile> register(
          String name, String nickname, String email, String password) async =>
      login(email, password);

  @override
  Future<void> sendPasswordReset(String email) async =>
      Future<void>.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> logout() async {}
}
