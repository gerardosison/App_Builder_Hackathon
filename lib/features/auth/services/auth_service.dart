import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/profile_repository.dart';

/// User-facing authentication error.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Firebase email/password authentication. Firebase keeps the session on
/// the device, so a signed-in user can reopen the app offline.
class AuthService {
  AuthService({
    required this.auth,
    required this.firestore,
    required this.profiles,
    required this.database,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProfileRepository profiles;
  final AppDatabase database;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) =>
      _emailPattern.hasMatch(value.trim());

  /// Signs in with an email address or a registered username.
  Future<User> signIn(String identifier, String password) async {
    final id = identifier.trim();
    if (id.isEmpty || password.isEmpty) {
      throw const AuthFailure('Enter your email or username and password.');
    }
    var email = id;
    if (!id.contains('@')) {
      try {
        email = await profiles.emailForUsername(id) ?? '';
      } on FirebaseException catch (error) {
        debugPrint('emailForUsername failed: ${error.code} ${error.message}');
        throw const AuthFailure(
          'Could not look up that username. Check your connection or sign '
          'in with your email.',
        );
      }
      if (email.isEmpty) {
        throw const AuthFailure('No account uses that username.');
      }
    }
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await _ensureLocalProfile(user);
      return user;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    }
  }

  Future<User> register({
    required String fullName,
    required String nickname,
    required String username,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (fullName.trim().isEmpty) {
      throw const AuthFailure('Enter your full name.');
    }
    if (!isValidEmail(cleanEmail)) {
      throw const AuthFailure('Enter a valid email address.');
    }
    if (!ProfileRepository.isValidUsername(username)) {
      throw const AuthFailure(
        'Usernames use 3–20 lowercase letters, numbers, dots or underscores.',
      );
    }
    if (password.length < 8) {
      throw const AuthFailure('Use at least 8 characters for your password.');
    }

    final UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      debugPrint('createUser failed: ${error.code} ${error.message}');
      throw AuthFailure(_message(error));
    }
    final user = credential.user!;
    try {
      await profiles.reserveUsername(
        userId: user.uid,
        username: username,
        email: cleanEmail,
      );
    } on Object catch (error, stack) {
      // Shows the real cause in the terminal (e.g. permission-denied).
      debugPrint('reserveUsername failed: $error\n$stack');
      // Roll back the account so the user can retry with another username.
      await user.delete().catchError((_) {});
      if (error is UsernameTakenException) {
        throw const AuthFailure('That username is already taken.');
      }
      if (error is FirebaseException) {
        throw AuthFailure(
          'Could not reserve your username (${error.code}). '
          'Check your connection and retry.',
        );
      }
      throw const AuthFailure(
        'Could not reserve your username. Check your connection and retry.',
      );
    }
    await user.updateDisplayName(fullName.trim()).catchError((_) {});
    await profiles.save(
      userId: user.uid,
      fullName: fullName,
      nickname: nickname,
      language: 'English (US)',
      practicePurpose: 'Class Presentation',
      onboardingComplete: false,
      username: username,
      email: cleanEmail,
    );
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    if (!isValidEmail(email)) {
      throw const AuthFailure('Enter the email address for your account.');
    }
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    }
  }

  Future<void> changePassword(String current, String next) async {
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthFailure('Sign in again to change your password.');
    }
    if (next.length < 8) {
      throw const AuthFailure('Use at least 8 characters for your password.');
    }
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: current),
      );
      await user.updatePassword(next);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    }
  }

  /// Deletes cloud data, the Firebase account and this device's local data.
  /// Requires a network connection and the current password.
  Future<void> deleteAccount(String password) async {
    final user = auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthFailure('Sign in again to delete your account.');
    }
    final uid = user.uid;
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: password),
      );
      final userDoc = firestore.collection('users').doc(uid);
      final sessions = await userDoc.collection('sessions').get();
      final batch = firestore.batch();
      for (final doc in sessions.docs) {
        batch.delete(doc.reference);
      }
      final profile = await profiles.get(uid);
      final username = profile?.username ?? '';
      if (username.isNotEmpty) {
        batch.delete(firestore.collection('usernames').doc(username));
      }
      batch.delete(userDoc);
      await batch.commit();
      await user.delete();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_message(error));
    } on FirebaseException catch (error) {
      throw AuthFailure(
        'Could not delete cloud data (${error.code}). Check your '
        'connection and try again.',
      );
    }
    await database.deleteAccountData(uid);
  }

  Future<void> signOut() => auth.signOut();

  Future<void> _ensureLocalProfile(User user) async {
    final existing = await profiles.get(user.uid);
    if (existing != null) return;
    try {
      await profiles.sync(user.uid);
    } on Object {
      // Offline: fall back to Firebase account details below.
    }
    if (await profiles.get(user.uid) != null) return;
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : (user.email ?? 'Speaker').split('@').first;
    await profiles.save(
      userId: user.uid,
      fullName: name,
      nickname: name.split(' ').first,
      language: 'English (US)',
      practicePurpose: 'Class Presentation',
      onboardingComplete: false,
      email: user.email,
    );
  }

  static String _message(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email/username or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'network-request-failed':
        return 'No connection. Connect to the internet and try again.';
      case 'requires-recent-login':
        return 'Please sign in again and retry.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled for this Firebase '
            'project.';
      default:
        return error.message ?? 'Authentication failed (${error.code}).';
    }
  }
}