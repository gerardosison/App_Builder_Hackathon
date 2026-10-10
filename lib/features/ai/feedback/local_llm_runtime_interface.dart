import 'dart:async';

abstract interface class LocalLlmRuntime {
  bool get isSupported;
  bool get isLoaded;
  bool get isLoading;
  String get lastError;

  Future<void> initialize({void Function(String)? onStatus});

  Stream<String> generateStream({
    required String userMessage,
    required List<LocalChatMessage> conversationHistory,
    required String systemMessage,
    required int maxTokens,
    required double temperature,
  });

  Future<void> stopGeneration();
  Future<void> dispose();
}

class LocalChatMessage {
  const LocalChatMessage({required this.role, required this.content});

  final String role;
  final String content;
}
