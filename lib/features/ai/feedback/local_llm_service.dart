import 'dart:async';

import 'local_llm_runtime_interface.dart';
import 'local_llm_runtime_unsupported.dart'
    if (dart.library.io) 'local_llm_runtime_android.dart' as runtime;

import '../../../core/models/pose_metrics.dart';
import '../../../core/models/speech_metrics.dart';

/// Lazy, on-device Qwen access shared by the AI Coach and analysis flows.
/// The Android backend uses llama.cpp; unsupported targets fail clearly rather
/// than substituting generated or canned coaching text.
class LocalLlmService {
  static final LocalLlmService _instance = LocalLlmService._internal();
  factory LocalLlmService({
    String modelName = 'Qwen3-0.6B-GGUF (Q4_K_M)',
    bool isEnabled = true,
  }) =>
      _instance;
  LocalLlmService._internal() : _runtime = runtime.createLocalLlmRuntime();

  final LocalLlmRuntime _runtime;
  static const _systemMessage =
      'You are the PipSpeak AI Coach running locally on this device. Answer '
      'the latest user message directly and stay on its exact topic. Start '
      'with the answer to what was asked; do not substitute generic advice '
      'or repeat earlier answers. Give public-speaking coaching only when '
      'the user asks for it. Use the same language as the user, including '
      'Filipino or Taglish. Be concise and do not invent details. Answer '
      'directly without showing chain-of-thought. /no_think';

  bool get isSupported => _runtime.isSupported;
  bool get isLoaded => _runtime.isLoaded;
  bool get isLoading => _runtime.isLoading;
  String get lastError => _runtime.lastError;

  static String stripThinking(String response) {
    var cleaned = response;
    final completeBlock = RegExp(
      r'<think\b[^>]*>[\s\S]*?</think\s*>',
      caseSensitive: false,
    );
    while (completeBlock.hasMatch(cleaned)) {
      cleaned = cleaned.replaceFirst(completeBlock, '');
    }
    cleaned = cleaned.replaceFirst(
      RegExp(r'<think\b[^>]*>[\s\S]*$', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'</think\s*>', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceFirst(
      RegExp(r'<\/?think\b[^>]*$', caseSensitive: false),
      '',
    );
    return cleaned.trim();
  }

  Future<void> initialize({void Function(String)? onStatus}) =>
      _runtime.initialize(onStatus: onStatus);

  String buildCoachingPrompt({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    required String speakingGoal,
  }) {
    final buffer = StringBuffer()
      ..writeln('Speaking goal: $speakingGoal')
      ..writeln('Measured speech rate: ${speech.wordsPerMinute} WPM')
      ..writeln('Word count: ${speech.wordCount}')
      ..writeln(
        'Filler words: ${speech.totalFillers} (${speech.fillerOccurrences})',
      );
    if (pose != null && pose.isPersonInFrame) {
      buffer
        ..writeln('Body sway: ${pose.bodySwayCm.toStringAsFixed(1)} cm')
        ..writeln('Posture score: ${pose.postureScore.toStringAsFixed(0)}/100')
        ..writeln(
          'Hand gesture score: '
          '${pose.handGestureActivityScore.toStringAsFixed(0)}/100',
        );
    }
    buffer.write(
      '\nUse only these measured values. Give a focused 2–3 sentence tip.',
    );
    return buffer.toString();
  }

  Stream<String> generateStream({
    required String userMessage,
    List<LocalChatMessage> conversationHistory = const [],
    String systemMessage = _systemMessage,
    int maxTokens = 512,
    double temperature = 0.7,
  }) {
    if (!isLoaded) {
      return Stream.error(
        StateError('The on-device Qwen model has not been loaded.'),
      );
    }
    return _runtime.generateStream(
      userMessage: userMessage,
      conversationHistory: conversationHistory,
      systemMessage: systemMessage,
      maxTokens: maxTokens,
      temperature: temperature,
    );
  }

  Future<String> generateResponse(
    String prompt, {
    List<LocalChatMessage> conversationHistory = const [],
    int maxTokens = 512,
  }) async {
    if (!isLoaded) {
      throw StateError('The on-device Qwen model has not been loaded.');
    }
    final response = StringBuffer();
    await for (final token in generateStream(
      userMessage: prompt,
      conversationHistory: conversationHistory,
      maxTokens: maxTokens,
    )) {
      response.write(token);
    }
    final cleaned = stripThinking(response.toString());
    if (cleaned.isEmpty) {
      throw StateError('The on-device Qwen model returned an empty response.');
    }
    return cleaned;
  }

  Future<void> stopGeneration() async {
    try {
      await _runtime.stopGeneration();
    } on Object {
      // Cancellation is best-effort when inference has not started yet.
    }
  }

  Future<void> dispose() => _runtime.dispose();
}
