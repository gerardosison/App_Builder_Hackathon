import 'package:flutter/material.dart';

import '../../../data/local/app_database.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../data/sync/progress_sync_controller.dart';
import 'personalization_screen.dart';

class ProfileGate extends StatefulWidget {
  const ProfileGate({
    super.key,
    required this.userId,
    required this.repository,
    required this.child,
  });

  final String userId;
  final ProgressRepository repository;
  final Widget child;

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  late final Stream<LocalProfile?> profileStream;
  late final ProgressSyncController syncController;

  bool finishedChecking = false;

  @override
  void initState() {
    super.initState();

    profileStream = widget.repository.profiles.watch(widget.userId);

    syncController = ProgressSyncController(
      repository: widget.repository,
      userId: widget.userId,
    );

    prepare();
  }

  Future<void> prepare() async {
    // Try cloud sync before presenting onboarding on a new device.
    // A slow or unavailable connection must not block local use forever.
    try {
      await widget.repository
          .sync(widget.userId)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Pending local records remain stored for later retry.
    }

    if (!mounted) return;

    syncController.start();
    setState(() => finishedChecking = true);
  }

  @override
  void dispose() {
    syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalProfile?>(
      stream: profileStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Could not read profile: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data;

        // Existing local profiles can open immediately, even offline.
        if (profile != null && profile.onboardingComplete) {
          return widget.child;
        }

        if (!finishedChecking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return PersonalizationScreen(
          userId: widget.userId,
          repository: widget.repository.profiles,
        );
      },
    );
  }
}