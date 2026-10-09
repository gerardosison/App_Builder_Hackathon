package com.hawkabuild.app.ai

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Member 4 - Flutter Platform Method Channel Handler for On-Device AI Models
 */
class AiMethodChannel(private val context: Context) : MethodChannel.MethodCallHandler {
    private val whisperEngine = WhisperEngine(context)
    private val poseEngine = PoseLandmarkerEngine(context)
    private val llamaEngine = LlamaEngine(context)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "transcribe" -> {
                val audioPath = call.argument<String>("audioPath") ?: ""
                try {
                    result.success(whisperEngine.transcribe(audioPath))
                } catch (error: UnsupportedOperationException) {
                    result.error("WHISPER_UNAVAILABLE", error.message, null)
                }
            }
            "checkModelStatus" -> {
                val statusMap = mapOf(
                    "whisper" to whisperEngine.initialize(),
                    "pose" to poseEngine.initialize(),
                    "llm" to llamaEngine.initialize()
                )
                result.success(statusMap)
            }
            else -> result.notImplemented()
        }
    }
}
