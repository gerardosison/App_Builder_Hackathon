import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

class ProfileRepository {
  ProfileRepository(this.database, this.firestore);

  final AppDatabase database;
  final FirebaseFirestore firestore;

  Stream<LocalProfile?> watch(String userId) {
    return (database.select(database.userProfiles)
          ..where((row) => row.userId.equals(userId)))
        .watchSingleOrNull();
  }

  Future<LocalProfile?> read(String userId) {
    return (database.select(database.userProfiles)
          ..where((row) => row.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> save({
    required String userId,
    required String fullName,
    required String nickname,
    required String language,
    required String practicePurpose,
  }) async {
    if (userId.isEmpty ||
        fullName.trim().isEmpty ||
        nickname.trim().isEmpty ||
        language.trim().isEmpty ||
        practicePurpose.trim().isEmpty) {
      throw ArgumentError('Complete all profile fields.');
    }

    await database.into(database.userProfiles).insertOnConflictUpdate(
      UserProfilesCompanion.insert(
        userId: userId,
        fullName: fullName.trim(),
        nickname: nickname.trim(),
        language: language,
        practicePurpose: practicePurpose,
        onboardingComplete: const Value(true),
        revision: const Uuid().v4(),
        needsUpload: const Value(true),
      ),
    );
  }

  Future<void> sync(String userId) async {
    final document = firestore.collection('users').doc(userId);
    final local = await read(userId);

    if (local != null && local.needsUpload) {
      await document.set({
        'profile': {
          'fullName': local.fullName,
          'nickname': local.nickname,
          'language': local.language,
          'practicePurpose': local.practicePurpose,
          'onboardingComplete': local.onboardingComplete,
          'revision': local.revision,
        },
        'profileUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // If the user edited while uploading, keep the newer edit pending.
      await (database.update(database.userProfiles)
            ..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.revision.equals(local.revision),
            ))
          .write(
        const UserProfilesCompanion(needsUpload: Value(false)),
      );
    }

    final cloud = await document.get(
      const GetOptions(source: Source.server),
    );

    final value = cloud.data()?['profile'];

    // Existing test documents may contain XP but no profile.
    if (value == null) return;

    if (value is! Map) {
      throw StateError('Invalid cloud profile.');
    }

    final fullName = value['fullName'];
    final nickname = value['nickname'];
    final language = value['language'];
    final purpose = value['practicePurpose'];
    final complete = value['onboardingComplete'];
    final revision = value['revision'];

    if (fullName is! String ||
        nickname is! String ||
        language is! String ||
        purpose is! String ||
        complete is! bool ||
        revision is! String) {
      throw StateError('Invalid cloud profile fields.');
    }

    await database.transaction(() async {
      final current = await read(userId);

      // Never replace an unsynced local edit with downloaded data.
      if (current != null && current.needsUpload) return;

      await database.into(database.userProfiles).insertOnConflictUpdate(
        UserProfilesCompanion.insert(
          userId: userId,
          fullName: fullName,
          nickname: nickname,
          language: language,
          practicePurpose: purpose,
          onboardingComplete: Value(complete),
          revision: revision,
          needsUpload: const Value(false),
        ),
      );
    });
  }
}