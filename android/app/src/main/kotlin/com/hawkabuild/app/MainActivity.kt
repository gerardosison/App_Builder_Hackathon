package com.hawkabuild.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.hawkabuild.app.ai.AiMethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.hawkabuild.app/ai"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler(AiMethodChannel(this))
    }
}
