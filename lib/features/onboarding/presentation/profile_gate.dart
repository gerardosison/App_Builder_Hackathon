import 'package:flutter/material.dart';

import '../../../app/app_providers.dart';
import '../../../data/local/app_database.dart';
import '../../../data/sync/progress_sync_controller.dart';
import '../../home/presentation/home_screen.dart';
import 'welcome_screen.dart';

class ProfileGate extends StatefulWidget {
  const ProfileGate({super.key, required this.userId});

  final String userId;

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

    profileStream = progressRepository.profiles.watch(widget.userId);

    syncController = ProgressSyncController(
      repository: progressRepository,
      userId: widget.userId,
    );

    currentSync = syncController;
    syncController.start();

    prepare();
  }

  Future<void> prepare() async {
    try {
      await progressRepository
          .sync(widget.userId)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Local use remains available if cloud sync cannot complete.
    }

    if (mounted) {
      setState(() => finishedChecking = true);
    }
  }

  @override
  void dispose() {
    if (identical(currentSync, syncController)) {
      currentSync = null;
    }

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
            body: Center(child: Text('Local profile error: ${snapshot.error}')),
          );
        }

        final profile = snapshot.data;

        if (profile != null && profile.onboardingComplete) {
          return const HomeScreen();
        }

        if (!finishedChecking ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return WelcomeScreen(nickname: profile?.nickname ?? 'Speaker');
      },
    );
  }
}
