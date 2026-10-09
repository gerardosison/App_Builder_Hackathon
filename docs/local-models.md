# Local model files

Model weights are excluded from Git. Download them separately into these
Flutter asset folders before building the app:

| Model | File path | Download |
| --- | --- | --- |
| Qwen3 0.6B Q4_K_M | `assets/models/llm/qwen3-0.6b-q4_k_m.gguf` | [Hugging Face GGUF repository](https://huggingface.co/Qwen/Qwen3-0.6B-GGUF) |
| Whisper Base Q5_1 | `assets/models/whisper/ggml-base-q5_1.bin` | [Direct download](https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base-q5_1.bin?download=true) |

The Flutter asset declarations in `pubspec.yaml` package these files as
`assets/models/llm/...` and `assets/models/whisper/...`. Keep the downloaded
weights out of commits; `.gitignore` excludes both formats.

Whisper.cpp is built for Android `arm64-v8a` and `armeabi-v7a`. The current
Qwen plugin is ARM64-only, so Qwen local inference requires a 64-bit Android
runtime. Whisper input audio must be a 16 kHz, 16-bit PCM WAV file; see
[`whisper-android.md`](whisper-android.md) for the service call.
