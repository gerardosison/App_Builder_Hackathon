package com.hawkabuild.app.ai

import android.content.Context
import java.io.BufferedInputStream

/**
 * Validates the optional Whisper asset.
 *
 * The current Android speech path is the live speech_to_text recognizer. We
 * refuse to return fabricated text when a native Whisper runtime is absent.
 */
class WhisperEngine(private val context: Context) {
    private var isLoaded = false
    private val modelPath = "models/whisper/ggml-base-q5_1.bin"

    fun initialize(): Boolean {
        isLoaded = try {
            context.assets.open(modelPath).use { raw ->
                BufferedInputStream(raw).use { input ->
                    input.available() >= 1024 * 1024
                }
            }
        } catch (_: Exception) {
            false
        }
        return isLoaded
    }

    fun transcribe(audioPath: String): String {
        throw UnsupportedOperationException(
            "Native Whisper runtime is not installed. Use the live Android speech recognizer."
        )
    }

    fun isReady(): Boolean = isLoaded
}
