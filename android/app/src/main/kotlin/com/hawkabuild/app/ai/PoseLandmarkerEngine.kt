package com.hawkabuild.app.ai

import android.content.Context
import java.io.BufferedInputStream

/**
 * Member 4 - MediaPipe Pose Landmarker Lite Engine Wrapper
 * Validates the MediaPipe pose model asset. Camera frame inference is handled
 * by the Flutter ML Kit camera pipeline.
 */
class PoseLandmarkerEngine(private val context: Context) {
    private var isInitialized = false
    private val modelAsset = "mediapipe/pose_landmarker_lite.task"

    fun initialize(): Boolean {
        isInitialized = try {
            context.assets.open(modelAsset).use { raw ->
                BufferedInputStream(raw).use { input ->
                    input.available() >= 1024
                }
            }
        } catch (_: Exception) {
            false
        }
        return isInitialized
    }

    fun isReady(): Boolean = isInitialized
}
