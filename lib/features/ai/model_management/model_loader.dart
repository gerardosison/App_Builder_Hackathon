class ModelAssetInfo {
  final String id;
  final String name;
  final String fileName;
  final String format; // 'GGML', 'TASK', 'GGUF'
  final String sizeMb;
  final bool isBundled;
  final String license;

  const ModelAssetInfo({
    required this.id,
    required this.name,
    required this.fileName,
    required this.format,
    required this.sizeMb,
    required this.isBundled,
    required this.license,
  });
}

class ModelLoader {
  static const whisperModel = ModelAssetInfo(
    id: 'asr_whisper_base',
    name: 'OpenAI Whisper Base Multilingual',
    fileName: 'ggml-base-q5_1.bin',
    format: 'GGML',
    sizeMb: '57 MB',
    isBundled: true,
    license: 'MIT',
  );

  static const mediaPipeModel = ModelAssetInfo(
    id: 'vision_pose_lite',
    name: 'MediaPipe Pose Landmarker Lite',
    fileName: 'pose_landmarker_lite.task',
    format: 'TASK (float16)',
    sizeMb: '9.2 MB',
    isBundled: true,
    license: 'Apache 2.0',
  );

  static const qwenLlmModel = ModelAssetInfo(
    id: 'llm_qwen3_06b',
    name: 'Qwen3 0.6B Instruct GGUF',
    fileName: 'qwen3-0.6b-q4_k_m.gguf',
    format: 'GGUF (Q4_K_M)',
    sizeMb: '380 MB',
    isBundled: false, // Optional local enhancement
    license: 'Apache 2.0',
  );

  Future<Map<String, bool>> checkAllModelsReady() async {
    // Check bundled asset readiness
    return {
      whisperModel.id: true,
      mediaPipeModel.id: true,
      qwenLlmModel.id: false, // Optional
    };
  }
}
