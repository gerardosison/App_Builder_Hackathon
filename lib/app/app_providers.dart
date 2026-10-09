import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../data/local/app_database.dart';
import '../data/repositories/progress_repository.dart';
import '../data/sync/progress_sync_controller.dart';

final appDatabase = AppDatabase();

final progressRepository = ProgressRepository(
  appDatabase,
  FirebaseFirestore.instance,
);

final registrationInProgress = ValueNotifier<bool>(false);

ProgressSyncController? currentSync;
