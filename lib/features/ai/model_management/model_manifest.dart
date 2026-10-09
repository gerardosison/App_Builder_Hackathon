import 'model_loader.dart';

/// Member 4 - AI Model Manifest Registry
class ModelManifest {
  static final List<ModelAssetInfo> allModels = [
    ModelLoader.whisperModel,
    ModelLoader.mediaPipeModel,
    ModelLoader.qwenLlmModel,
  ];

  static ModelAssetInfo? getById(String id) {
    try {
      return allModels.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
