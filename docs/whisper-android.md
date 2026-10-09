# Offline Whisper on Android

HawkABuild uses the upstream `whisper.cpp` Android JNI implementation on
`arm64-v8a` and `armeabi-v7a`. The model weights are intentionally excluded
from Git; download them separately for local builds.

## Model file

Place the multilingual Base Q5_1 model here:

```text
assets/models/whisper/ggml-base-q5_1.bin
```

The official download is
<https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base-q5_1.bin>.
Keep the downloaded file out of commits; `.gitignore` already excludes it.

## Audio input

`WhisperSpeechService.transcribe` accepts a local WAV file containing
uncompressed, 16-bit PCM audio at 16 kHz, mono or stereo. Stereo input is
converted to mono before inference. Other sample rates and compressed formats
must be converted before calling the service.

```dart
final whisper = WhisperSpeechService();
await whisper.initializeModel();
final result = await whisper.transcribe(recordingPath, language: 'auto');
```

Use `language: 'tl'` to force Tagalog, `language: 'en'` for English, or leave
it as `auto` for language detection. Model loading and transcription run on a
background native worker. The first load can take several seconds and uses
additional memory.

## Native source

The C/C++ sources are vendored under `third_party/whisper.cpp` from
<https://github.com/ggml-org/whisper.cpp>. `android/app/src/main/cpp/CMakeLists.txt`
builds the JNI library for both supported Android ARM ABIs.
