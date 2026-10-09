package com.hawkabuild.app.ai

import android.content.Context
import java.io.BufferedInputStream
import java.io.File

/**
 * Validates the Qwen GGUF packaged in the Android app.
 *
 * Inference is owned by the llama_flutter_android Dart plugin. This class must
 * not return coaching text because that would bypass the real model.
 */
class LlamaEngine(private val context: Context) {
    private var isLoaded = false
    private val modelAsset = "models/llm/qwen3-0.6b-q4_k_m.gguf"

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

    /** Copies the bundled GGUF asset to a path llama.cpp can memory-map. */
    fun prepareModelFile(): String {
        val modelFile = File(context.filesDir, "llm/qwen3-0.6b-q4_k_m.gguf")
        if (modelFile.isFile && modelFile.length() > MIN_MODEL_BYTES) {
            return modelFile.absolutePath
        }

        val parent = modelFile.parentFile
            ?: throw IllegalStateException("Could not create the local model directory.")
        if (!parent.exists() && !parent.mkdirs()) {
            throw IllegalStateException("Could not create the local model directory.")
        }

        val temporaryFile = File(parent, "${modelFile.name}.tmp")
        context.assets.open(modelAsset).buffered().use { input ->
            temporaryFile.outputStream().buffered().use { output -> input.copyTo(output) }
        }
        if (temporaryFile.length() <= MIN_MODEL_BYTES) {
            temporaryFile.delete()
            throw IllegalStateException("The bundled Qwen GGUF is missing or incomplete.")
        }
        if (modelFile.exists() && !modelFile.delete()) {
            temporaryFile.delete()
            throw IllegalStateException("Could not replace the incomplete Qwen model file.")
        }
        if (!temporaryFile.renameTo(modelFile)) {
            temporaryFile.delete()
            throw IllegalStateException("Could not finalize the local Qwen model file.")
        }
        return modelFile.absolutePath
    }

    fun isReady(): Boolean = isLoaded

    private companion object {
        const val MIN_MODEL_BYTES = 1024L * 1024L
    }
}
