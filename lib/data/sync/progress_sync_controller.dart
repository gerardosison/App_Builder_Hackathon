import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import '../repositories/progress_repository.dart';

class ProgressSyncController extends ChangeNotifier
    with WidgetsBindingObserver {
  ProgressSyncController({required this.repository, required this.userId});

  final ProgressRepository repository;
  final String userId;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;
  Timer? _slowTimer;

  bool _disposed = false;
  bool _started = false;
  bool _running = false;
  bool _requestedAgain = false;
  bool _online = false;

  String message = 'Checking connection…';

  void _setMessage(String value) {
    if (_disposed) return;
    message = value;
    notifyListeners();
  }

  void start() {
    if (_started || _disposed) return;
    _started = true;

    WidgetsBinding.instance.addObserver(this);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        _online = results.any((result) => result != ConnectivityResult.none);

        if (_online) {
          unawaited(requestSync());
        } else {
          _setMessage('Offline — changes stay on this device.');
        }
      },
      onError: (Object error) {
        _setMessage('Waiting to sync — local data retained.');
      },
    );

    _retryTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final state = WidgetsBinding.instance.lifecycleState;

      if (state == null || state == AppLifecycleState.resumed) {
        unawaited(requestSync());
      }
    });

    unawaited(requestSync());
  }

  Future<void> requestSync() async {
    if (_disposed) return;

    if (_running) {
      _requestedAgain = true;
      return;
    }

    _running = true;
    var completed = false;

    try {
      final results = await _connectivity.checkConnectivity();
      if (_disposed) return;

      _online = results.any((result) => result != ConnectivityResult.none);

      if (!_online) {
        _setMessage('Offline — changes stay on this device.');
        return;
      }

      _setMessage('Syncing…');

      _slowTimer = Timer(const Duration(seconds: 15), () {
        _setMessage('Waiting for connection — local data retained.');
      });

      await repository.sync(userId);

      completed = true;
      _setMessage(
        _online ? 'Synced' : 'Offline — changes stay on this device.',
      );
    } catch (_) {
      _setMessage(
        _online
            ? 'Sync pending — local data retained.'
            : 'Offline — changes stay on this device.',
      );
    } finally {
      _slowTimer?.cancel();
      _slowTimer = null;
      _running = false;

      final repeat = completed && _requestedAgain;
      _requestedAgain = false;

      if (repeat && !_disposed) {
        unawaited(requestSync());
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(requestSync());
    }
  }

  @override
  void dispose() {
    _disposed = true;

    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _retryTimer?.cancel();
    _slowTimer?.cancel();

    super.dispose();
  }
}
