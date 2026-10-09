import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import '../repositories/progress_repository.dart';

enum ProgressSyncStatus { checking, offline, syncing, synced, waiting }

class ProgressSyncController extends ChangeNotifier
    with WidgetsBindingObserver {
  ProgressSyncController({required this.repository, required this.userId});

  final ProgressRepository repository;
  final String userId;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;
  Timer? _slowSyncTimer;

  bool _disposed = false;
  bool _running = false;
  bool _requestedAgain = false;
  bool _hasNetwork = false;

  ProgressSyncStatus status = ProgressSyncStatus.checking;

  String get message {
    switch (status) {
      case ProgressSyncStatus.checking:
        return 'Checking connection…';
      case ProgressSyncStatus.offline:
        return 'Offline — progress stays on this device.';
      case ProgressSyncStatus.syncing:
        return 'Syncing progress…';
      case ProgressSyncStatus.synced:
        return 'Synced with your account.';
      case ProgressSyncStatus.waiting:
        return 'Waiting to sync — local progress is retained.';
    }
  }

  void start() {
    WidgetsBinding.instance.addObserver(this);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        _applyConnection(results);

        if (_hasNetwork) {
          requestSync();
        }
      },
      onError: (Object error) {
        _setStatus(ProgressSyncStatus.waiting);
      },
    );

    // Retry while the app is active. Network availability does not
    // necessarily mean the internet or Firebase is reachable.
    _retryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final state = WidgetsBinding.instance.lifecycleState;

      if (state == null || state == AppLifecycleState.resumed) {
        requestSync();
      }
    });

    requestSync();
  }

  void _setStatus(ProgressSyncStatus next) {
    if (_disposed) return;

    status = next;
    notifyListeners();
  }

  void _applyConnection(List<ConnectivityResult> results) {
    _hasNetwork = results.any((result) => result != ConnectivityResult.none);

    if (!_hasNetwork) {
      _setStatus(ProgressSyncStatus.offline);
    } else if (_running) {
      _setStatus(ProgressSyncStatus.syncing);
    }
  }

  Future<void> requestSync() async {
    if (_disposed) return;

    // A record saved during an active sync needs another pass.
    if (_running) {
      _requestedAgain = true;
      return;
    }

    _running = true;
    var completed = false;

    try {
      final results = await _connectivity.checkConnectivity();
      if (_disposed) return;

      _applyConnection(results);
      if (!_hasNetwork) return;

      _setStatus(ProgressSyncStatus.syncing);

      // A slow Firestore write can wait for connectivity. Change the
      // displayed status without starting duplicate upload operations.
      _slowSyncTimer = Timer(const Duration(seconds: 15), () {
        _setStatus(
          _hasNetwork ? ProgressSyncStatus.waiting : ProgressSyncStatus.offline,
        );
      });

      await repository.sync(userId);

      if (_disposed) return;

      completed = true;
      _setStatus(
        _hasNetwork ? ProgressSyncStatus.synced : ProgressSyncStatus.offline,
      );
    } catch (_) {
      _setStatus(
        _hasNetwork ? ProgressSyncStatus.waiting : ProgressSyncStatus.offline,
      );
    } finally {
      _slowSyncTimer?.cancel();
      _slowSyncTimer = null;
      _running = false;

      final runAgain = _requestedAgain && completed;
      _requestedAgain = false;

      if (runAgain && !_disposed) {
        unawaited(requestSync());
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      requestSync();
    }
  }

  @override
  void dispose() {
    _disposed = true;

    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _retryTimer?.cancel();
    _slowSyncTimer?.cancel();

    super.dispose();
  }
}
