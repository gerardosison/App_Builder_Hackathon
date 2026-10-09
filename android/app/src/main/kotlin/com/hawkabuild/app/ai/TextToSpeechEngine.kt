package com.hawkabuild.app.ai

import android.content.Context
import android.speech.tts.TextToSpeech
import java.util.Locale

/** Android system text-to-speech used by the local AI test screen. */
class TextToSpeechEngine(context: Context) {
    private val appContext = context.applicationContext
    private val lock = Object()
    private var engine: TextToSpeech? = null
    @Volatile private var initializationStatus: Int? = null

    fun speak(text: String): Boolean {
        require(text.isNotBlank()) { "Text to read aloud is empty." }
        val tts = getEngine()
        val deviceLocale = Locale.getDefault()
        val languageStatus = tts.isLanguageAvailable(deviceLocale)
        val selectedLocale = if (languageStatus >= TextToSpeech.LANG_AVAILABLE) {
            deviceLocale
        } else {
            Locale.US
        }
        check(tts.isLanguageAvailable(selectedLocale) >= TextToSpeech.LANG_AVAILABLE) {
            "No supported speech voice is installed. Install or enable a voice in Android Text-to-speech settings."
        }
        tts.language = selectedLocale
        val result = tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, UTTERANCE_ID)
        check(result != TextToSpeech.ERROR) { "Android text-to-speech could not start." }
        return true
    }

    fun stop() {
        synchronized(lock) { engine }?.stop()
    }

    private fun getEngine(): TextToSpeech {
        synchronized(lock) {
            if (engine == null) {
                engine = TextToSpeech(appContext) { status ->
                    synchronized(lock) {
                        initializationStatus = status
                        lock.notifyAll()
                    }
                }
            }

            val deadline = System.currentTimeMillis() + INIT_TIMEOUT_MS
            while (initializationStatus == null) {
                val remaining = deadline - System.currentTimeMillis()
                if (remaining <= 0) {
                    throw IllegalStateException("Android text-to-speech initialization timed out.")
                }
                lock.wait(remaining)
            }
            check(initializationStatus == TextToSpeech.SUCCESS) {
                "Android text-to-speech initialization failed."
            }
            return checkNotNull(engine)
        }
    }

    private companion object {
        const val INIT_TIMEOUT_MS = 15_000L
        const val UTTERANCE_ID = "hawkabuild-test-tts"
    }
}
