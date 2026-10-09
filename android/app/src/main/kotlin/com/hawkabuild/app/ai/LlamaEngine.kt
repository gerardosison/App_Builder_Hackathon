package com.hawkabuild.app.ai

import android.content.Context
import java.io.BufferedInputStream

/**
 * Validates the Qwen GGUF packaged in the Android app.
 *
 * Inference is owned by the llama_flutter_android Dart plugin. This class must
 * not return coaching text because that would bypass the real model.
 */
class LlamaEngine(private val context: Context) {
    private var isLoaded = false
    private val modelAsset = "flutter_assets/assets/models/llm/qwen3-0.6b-q4_k_m.gguf"

    fun initialize(): Boolean {
        isLoaded = try {
            context.assets.open(modelAsset).use { raw ->
                BufferedInputStream(raw).use { input ->
                    val header = ByteArray(4)
                    val read = input.read(header)
                    read == 4 && String(header, Charsets.US_ASCII) == "GGUF"
                }
            }
        } catch (_: Exception) {
            false
        }
        return isLoaded
    }

    fun generateFeedback(prompt: String): String {
        throw UnsupportedOperationException(
            "Qwen inference is provided by llama_flutter_android on the Dart side."
        )
    }

    fun isReady(): Boolean = isLoaded
}
