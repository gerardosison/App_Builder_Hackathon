import 'package:firebase_auth/firebase_auth.dart';

/// Thrown when the signed-in account changes during asynchronous work.
class AccountChangedException implements Exception {
  const AccountChangedException();

  @override
  String toString() => 'The signed-in account changed.';
}

/// Ensures cloud work only continues for the account that started it.
class AccountGuard {
  const AccountGuard(this._auth);

  final FirebaseAuth _auth;

  void check(String userId) {
    if (userId.isEmpty || _auth.currentUser?.uid != userId) {
      throw const AccountChangedException();
    }
  }
}
