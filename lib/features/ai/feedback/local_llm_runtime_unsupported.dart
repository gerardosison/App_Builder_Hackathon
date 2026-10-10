import 'dart:async';

import 'local_llm_runtime_interface.dart';

LocalLlmRuntime createLocalLlmRuntime() => _UnsupportedLocalLlmRuntime();

class _UnsupportedLocalLlmRuntime implements LocalLlmRuntime {
  @override
  bool get isSupported => false;

  static const _message =
      'The bundled Qwen runtime is available in the Android app. Browser-based '
      'local inference is not configured, so no data was sent to a server.';

  @override
  bool get isLoaded => false;

  @override
  bool get isLoading => false;

  @override
  String get lastError => _message;

  @override
  Future<void> initialize({void Function(String)? onStatus}) async {
    onStatus?.call(_message);
    throw UnsupportedError(_message);
  }

  @override
  Stream<String> generateStream({
    required String userMessage,
    required List<LocalChatMessage> conversationHistory,
    required String systemMessage,
    required int maxTokens,
    required double temperature,
  }) => Stream.error(UnsupportedError(_message));

  @override
  Future<void> stopGeneration() async {}

  @override
  Future<void> dispose() async {}
}

