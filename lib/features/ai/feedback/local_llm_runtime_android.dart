import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:llama_flutter_android/llama_flutter_android.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'local_llm_runtime_interface.dart';

LocalLlmRuntime createLocalLlmRuntime() => _AndroidLocalLlmRuntime();

class _AndroidLocalLlmRuntime implements LocalLlmRuntime {
  final LlamaController _controller = LlamaController();
  static const String _modelFileName = 'qwen3-0.6b-q4_k_m.gguf';
  static const MethodChannel _nativeChannel = MethodChannel(
    'com.hawkabuild.app/ai',
  );

  bool _isLoaded = false;
  bool _isLoading = false;
  String _lastError = '';
  Future<void>? _loadFuture;

  @override
  bool get isSupported => Platform.isAndroid;

  @override
  bool get isLoaded => _isLoaded;

  @override
  bool get isLoading => _isLoading;

  @override
  String get lastError => _lastError;

  Future<String> _ensureModelOnDisk() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelFile = File(p.join(directory.path, 'llm', _modelFileName));
    if (modelFile.existsSync() && modelFile.lengthSync() > 1024 * 1024) {
      return modelFile.path;
    }

    final nativePath = await _nativeChannel.invokeMethod<String>(
      'prepareQwenModel',
    );
    if (nativePath == null) {
      throw StateError('The bundled Qwen model path was not returned.');
    }
    final nativeFile = File(nativePath);
    if (!nativeFile.existsSync() || nativeFile.lengthSync() <= 1024 * 1024) {
      throw StateError('The bundled Qwen model is missing or incomplete.');
    }
    return nativeFile.path;
  }

  @override
  Future<void> initialize({void Function(String)? onStatus}) {
    if (!Platform.isAndroid) {
      const message =
          'The bundled Qwen runtime is currently available in the Android app.';
      _lastError = message;
      return Future<void>.error(UnsupportedError(message));
    }
    if (_isLoaded) return Future<void>.value();
    return _loadFuture ??= _load(onStatus).whenComplete(() {
      _loadFuture = null;
    });
  }

  Future<void> _load(void Function(String)? onStatus) async {
    _isLoading = true;
    _lastError = '';
    try {
      onStatus?.call('Preparing the on-device Qwen model…');
      final modelPath = await _ensureModelOnDisk();
      onStatus?.call('Loading Qwen into memory…');
      final gpu = await _controller.detectGpu();
      final availableRamMb = gpu.freeRamBytes / 1024 / 1024;
      // Keep the small model responsive on lower-memory devices. GPU
      // offloading remains automatic when the device reports suitable RAM.
      final gpuLayers = availableRamMb < 900 ? 0 : gpu.recommendedGpuLayers;
      await _controller.loadModel(
        modelPath: modelPath,
        threads: 4,
        contextSize: 2048,
        gpuLayers: gpuLayers,
      );
      _isLoaded = true;
      onStatus?.call('AI Coach is ready on this device.');
    } catch (error) {
      _lastError = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  @override
  Stream<String> generateStream({
    required String userMessage,
    required List<LocalChatMessage> conversationHistory,
    required String systemMessage,
    required int maxTokens,
    required double temperature,
  }) {
    if (!_isLoaded) {
      return Stream.error(
        StateError('Load the on-device Qwen model before prompting it.'),
      );
    }
    return _controller.generateChat(
      messages: [
        ChatMessage(role: 'system', content: systemMessage),
        ...conversationHistory.map(
          (message) => ChatMessage(
            role: message.role,
            content: message.content,
          ),
        ),
        ChatMessage(role: 'user', content: userMessage),
      ],
      template: 'chatml',
      maxTokens: maxTokens,
      temperature: temperature,
      topP: 0.9,
      repeatPenalty: 1.1,
    );
  }

  @override
  Future<void> stopGeneration() => _controller.stop();

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    _isLoaded = false;
  }
}
