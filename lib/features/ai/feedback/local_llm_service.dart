import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:llama_flutter_android/llama_flutter_android.dart';
import '../../../core/models/speech_metrics.dart';
import '../../../core/models/pose_metrics.dart';

/// Real on-device GGUF inference using llama_flutter_android (llama.cpp).
/// Model: Qwen3-0.6B-Q4_K_M — must be placed at:
///   android/app/src/main/assets/models/llm/qwen3-0.6b-q4_k_m.gguf
/// Download: https://huggingface.co/Qwen/Qwen3-0.6B-GGUF
class LocalLlmService {
  static final LocalLlmService _instance = LocalLlmService._internal();
  factory LocalLlmService({
    String modelName = 'Qwen3-0.6B-GGUF (Q4_K_M)',
    bool isEnabled = true,
  }) => _instance;
  LocalLlmService._internal();

  final LlamaController _controller = LlamaController();
  bool _isLoaded = false;
  bool _isLoading = false;
  String _lastError = '';

  static const String _assetPath = 'assets/models/llm/qwen3-0.6b-q4_k_m.gguf';
  static const String _modelFileName = 'qwen3-0.6b-q4_k_m.gguf';
  static const MethodChannel _nativeChannel = MethodChannel(
    'com.hawkabuild.app/ai',
  );

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;
  String get lastError => _lastError;

  /// Removes private reasoning blocks that some local models emit.
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
    // Streaming tokens can split a tag between chunks. Do not render a
    // partial tag that is waiting for the next token.
    cleaned = cleaned.replaceFirst(
      RegExp(r'<\/?think\b[^>]*$', caseSensitive: false),
      '',
    );
    return cleaned.trim();
  }

  // ── MODEL SETUP ─────────────────────────────────────────────────────────────

  /// Copies the GGUF model from Flutter assets to app-documents directory
  /// because llama.cpp needs a real filesystem path, not an asset URI.
  Future<String> _ensureModelOnDisk() async {
    final dir = await getApplicationDocumentsDirectory();
    final modelFile = File(p.join(dir.path, 'llm', _modelFileName));

    // If already copied and > 1 MB, skip copy
    if (modelFile.existsSync() && modelFile.lengthSync() > 1024 * 1024) {
      return modelFile.path;
    }

    await modelFile.parent.create(recursive: true);

    // On Android, copy the bundled native asset to app storage. llama.cpp
    // needs a real path for the local GGUF model.
    try {
      final nativePath = await _nativeChannel.invokeMethod<String>(
        'prepareQwenModel',
      );
      if (nativePath != null) {
        final nativeFile = File(nativePath);
        if (nativeFile.existsSync() && nativeFile.lengthSync() > 1024 * 1024) {
          return nativeFile.path;
        }
      }
    } on MissingPluginException {
      // Fall through to Flutter asset loading on non-Android platforms.
    } on PlatformException catch (error) {
      _lastError = error.message ?? 'Could not copy the bundled Qwen model.';
    }

    try {
      final data = await rootBundle.load(_assetPath);
      final bytes = data.buffer.asUint8List();

      if (bytes.length >= 1024 * 1024) {
        await modelFile.writeAsBytes(bytes, flush: true);
        return modelFile.path;
      }
    } catch (_) {}

    throw Exception(
      'Qwen GGUF model is missing or incomplete. Ensure the real model file '
      'is at android/app/src/main/assets/models/llm/$_modelFileName. '
      '${_lastError.isEmpty ? '' : _lastError}',
    );
  }

  /// Initialize (load) the Qwen3 model into llama.cpp.
  Future<void> initialize({void Function(String)? onStatus}) async {
    if (_isLoaded) return;
    if (_isLoading) return;
    _isLoading = true;
    _lastError = '';

    try {
      onStatus?.call('📂 Copying model to app storage...');
      final modelPath = await _ensureModelOnDisk();

      onStatus?.call('🔍 Detecting GPU capabilities...');
      final gpu = await _controller.detectGpu();

      onStatus?.call(
        '⚙️ Loading model on ${gpu.gpuName}...\n'
        'GPU layers: ${gpu.recommendedGpuLayers}, '
        'Free RAM: ${(gpu.freeRamBytes / 1024 / 1024).toStringAsFixed(0)} MB',
      );

      await _controller.loadModel(
        modelPath: modelPath,
        threads: 4,
        contextSize: 2048,
        gpuLayers: gpu.recommendedGpuLayers,
      );

      _isLoaded = true;
      onStatus?.call('✅ Qwen3-0.6B ready! Ask me anything.');
    } catch (e) {
      _lastError = e.toString();
      _isLoading = false;
      rethrow;
    }

    _isLoading = false;
  }

  // ── INFERENCE ────────────────────────────────────────────────────────────────

  /// Build a structured coaching prompt from measured speech/pose metrics.
  String buildCoachingPrompt({
    required SpeechMetrics speech,
    PoseMetrics? pose,
    required String speakingGoal,
  }) {
    final buf = StringBuffer();
    buf.writeln(
      'You are HawkABuild AI Speech Coach running offline on this Android device.',
    );
    buf.writeln(
      'Rules: Only use the measured data below. Never invent numbers.',
    );
    buf.writeln('Speaking Goal: $speakingGoal');
    buf.writeln(
      'Measured Speech Rate: ${speech.wordsPerMinute.toStringAsFixed(1)} WPM',
    );
    buf.writeln('Word Count: ${speech.wordCount}');
    buf.writeln(
      'Filler Words: ${speech.totalFillers} (${speech.fillerOccurrences})',
    );
    if (pose != null && pose.isPersonInFrame) {
      buf.writeln('Body Sway: ${pose.bodySwayCm.toStringAsFixed(1)} cm');
      buf.writeln('Posture Score: ${pose.postureScore.toStringAsFixed(0)}/100');
      buf.writeln(
        'Hand Gesture Score: ${pose.handGestureActivityScore.toStringAsFixed(0)}/100',
      );
    }
    buf.writeln(
      '\nProvide a focused 2-3 sentence coaching tip for improving delivery.',
    );
    return buf.toString();
  }

  /// Stream tokens from Qwen3 for any prompt (chat mode with ChatML template).
  Stream<String> generateStream({
    required String userMessage,
    List<ChatMessage> conversationHistory = const [],
    String systemMessage =
        'You are HawkABuild AI, a helpful on-device assistant. Answer the '
        'latest user message directly and stay on its exact topic. Start with '
        'the answer to what was asked; do not substitute generic advice or '
        'repeat earlier answers. Give public-speaking coaching only when the '
        'user asks for it. Use the same language as the user, including '
        'Filipino or Taglish. Be concise and do not invent details. '
        'Answer directly without showing chain-of-thought. /no_think',
    int maxTokens = 512,
    double temperature = 0.7,
  }) {
    if (!_isLoaded) {
      return Stream.error(
        Exception('Model not loaded. Call initialize() first.'),
      );
    }

    return _controller.generateChat(
      messages: [
        ChatMessage(role: 'system', content: systemMessage),
        ...conversationHistory,
        ChatMessage(role: 'user', content: userMessage),
      ],
      template: 'chatml',
      maxTokens: maxTokens,
      temperature: temperature,
      topP: 0.9,
      repeatPenalty: 1.1,
    );
  }

  /// Collect the full streaming response into one string.
  Future<String> generateResponse(
    String prompt, {
    List<ChatMessage> conversationHistory = const [],
    int maxTokens = 512,
  }) async {
    if (!_isLoaded) {
      return 'Local LLM is not loaded yet. Please initialize the model first.';
    }

    final buf = StringBuffer();
    final completer = Completer<String>();

    generateStream(
      userMessage: prompt,
      conversationHistory: conversationHistory,
      maxTokens: maxTokens,
    ).listen(
      buf.write,
      onDone: () {
        if (!completer.isCompleted) {
          completer.complete(stripThinking(buf.toString()));
        }
      },
      onError: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
    );

    return completer.future;
  }

  Future<void> stopGeneration() => _controller.stop();

  Future<void> dispose() async {
    await _controller.dispose();
    _isLoaded = false;
  }
}
