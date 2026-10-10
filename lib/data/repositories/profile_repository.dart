import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import 'account_guard.dart';

class UsernameTakenException implements Exception {
  const UsernameTakenException();

  @override
  String toString() => 'That username is already taken.';
}

/// Local-first profile storage with revision-checked Firestore sync.
class ProfileRepository {
  ProfileRepository({
    required this.database,
    required this.firestore,
    required this.guard,
  });

  final AppDatabase database;
  final FirebaseFirestore firestore;
  final AccountGuard guard;

  static final _usernamePattern = RegExp(r'^[a-z0-9_.]{3,20}$');

  static String normalizeUsername(String value) => value.trim().toLowerCase();

  static bool isValidUsername(String value) =>
      _usernamePattern.hasMatch(normalizeUsername(value));

  Stream<LocalProfile?> watch(String userId) {
    return (database.select(
      database.userProfiles,
    )..where((row) => row.userId.equals(userId))).watchSingleOrNull();
  }

  Future<LocalProfile?> get(String userId) {
    return (database.select(
      database.userProfiles,
    )..where((row) => row.userId.equals(userId))).getSingleOrNull();
  }

  /// Saves the profile locally and marks it for upload.
  Future<void> save({
    required String userId,
    required String fullName,
    required String nickname,
    required String language,
    required String practicePurpose,
    required bool onboardingComplete,
    String? username,
    String? email,
    String? school,
    Value<String?> photoPath = const Value.absent(),
  }) async {
    final name = fullName.trim();
    final nick = nickname.trim();
    if (userId.isEmpty || name.isEmpty || name.length > 80) {
      throw ArgumentError('Enter your full name (up to 80 characters).');
    }
    if (nick.length > 40) {
      throw ArgumentError('Nickname must be 40 characters or fewer.');
    }
    await database
        .into(database.userProfiles)
        .insertOnConflictUpdate(
          UserProfilesCompanion(
            userId: Value(userId),
            fullName: Value(name),
            nickname: Value(nick.isEmpty ? name.split(' ').first : nick),
            language: Value(language),
            practicePurpose: Value(practicePurpose),
            onboardingComplete: Value(onboardingComplete),
            revision: Value(const Uuid().v4()),
            needsUpload: const Value(true),
            username: username == null
                ? const Value.absent()
                : Value(normalizeUsername(username)),
            email: email == null ? const Value.absent() : Value(email),
            school: school == null
                ? const Value.absent()
                : Value(school.trim()),
            photoPath: photoPath,
          ),
        );
  }

  /// Updates device-local fields that are never uploaded.
  Future<void> setPhotoPath(String userId, String? path) async {
    await (database.update(database.userProfiles)
          ..where((row) => row.userId.equals(userId)))
        .write(UserProfilesCompanion(photoPath: Value(path)));
  }

  Future<void> sync(String userId) async {
    guard.check(userId);
    final document = firestore.collection('users').doc(userId);
    final local = await get(userId);

    if (local != null && local.needsUpload) {
      final data = <String, Object?>{
        'fullName': local.fullName,
        'nickname': local.nickname,
        'username': local.username,
        'language': local.language,
        'practicePurpose': local.practicePurpose,
        'school': local.school,
        'onboardingComplete': local.onboardingComplete,
        'revision': local.revision,
        'updatedAt': FieldValue.serverTimestamp(),
      }..removeWhere((_, value) => value == null);
      await document.set(data);
      // Only clear the flag if no newer local edit happened meanwhile.
      await (database.update(database.userProfiles)..where(
            (row) =>
                row.userId.equals(userId) & row.revision.equals(local.revision),
          ))
          .write(const UserProfilesCompanion(needsUpload: Value(false)));
      return;
    }

    final snapshot = await document.get(
      const GetOptions(source: Source.server),
    );
    guard.check(userId);
    final data = snapshot.data();
    if (data == null) return;
    final latest = await get(userId);
    if (latest != null && latest.needsUpload) return;

    String text(String key, [String fallback = '']) =>
        data[key] is String ? data[key] as String : fallback;
    final fullName = text('fullName');
    final revision = text('revision');
    if (fullName.isEmpty || revision.isEmpty) return;
    await database
        .into(database.userProfiles)
        .insertOnConflictUpdate(
          UserProfilesCompanion(
            userId: Value(userId),
            fullName: Value(fullName),
            nickname: Value(text('nickname', fullName)),
            username: Value(text('username')),
            language: Value(text('language', 'English (US)')),
            practicePurpose: Value(
              text('practicePurpose', 'Class Presentation'),
            ),
            school: Value(text('school')),
            onboardingComplete: Value(data['onboardingComplete'] == true),
            revision: Value(revision),
            needsUpload: const Value(false),
          ),
        );
  }

  /// Claims `usernames/{username}` for [userId]. The username document maps
  /// a public username to the account email so it can be used to sign in.
  Future<void> reserveUsername({
    required String userId,
    required String username,
    required String email,
  }) async {
    final name = normalizeUsername(username);
    if (!isValidUsername(name)) {
      throw ArgumentError(
        'Usernames use 3–20 lowercase letters, numbers, dots or underscores.',
      );
    }
    final ref = firestore.collection('usernames').doc(name);
    await firestore.runTransaction((transaction) async {
      final existing = await transaction.get(ref);
      if (existing.exists) {
        if (existing.data()?['uid'] == userId) return;
        throw const UsernameTakenException();
      }
      transaction.set(ref, {'uid': userId, 'email': email});
    });
  }

  Future<bool> isUsernameAvailable(String username) async {
    final name = normalizeUsername(username);
    if (!isValidUsername(name)) return false;
    final snapshot = await firestore.collection('usernames').doc(name).get();
    return !snapshot.exists;
  }

  Future<String?> emailForUsername(String username) async {
    final name = normalizeUsername(username);
    if (!isValidUsername(name)) return null;
    final snapshot = await firestore.collection('usernames').doc(name).get();
    final email = snapshot.data()?['email'];
    return email is String ? email : null;
  }
}
