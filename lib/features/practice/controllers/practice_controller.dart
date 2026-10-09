import 'package:flutter/foundation.dart';

import '../services/session_orchestrator.dart';

class PracticeController extends ChangeNotifier {
  PracticeController({SessionOrchestrator? orchestrator})
      : _orchestrator = orchestrator ?? SessionOrchestrator();

  final SessionOrchestrator _orchestrator;
  bool _isSessionActive = false;

  bool get isSessionActive => _isSessionActive;

  Future<void> start() async {
    _isSessionActive = true;
    await _orchestrator.beginSession();
    notifyListeners();
  }

  Future<int> stop() async {
    _isSessionActive = false;
    final seconds = await _orchestrator.endSession();
    notifyListeners();
    return seconds;
  }
}

