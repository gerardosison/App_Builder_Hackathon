import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PracticeOutcome { improved, noImprovement }

/// Lets the live-room demo choose which feedback variant to show.
/// TODO(backend): remove once real analysis decides the outcome.
final practiceOutcomeProvider =
    StateProvider<PracticeOutcome>((_) => PracticeOutcome.improved);

/// Camera/mic permission state for the practice flow (mocked).
enum PermissionState { unknown, granted, denied }

final permissionStateProvider =
    StateProvider<PermissionState>((_) => PermissionState.unknown);
