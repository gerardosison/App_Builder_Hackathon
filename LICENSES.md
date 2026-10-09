## Whisper.cpp and GGML

The Android offline speech-to-text runtime vendors source from
[`ggml-org/whisper.cpp`](https://github.com/ggml-org/whisper.cpp), including
GGML. Upstream commit: `d1be6fde11ac6e0407606b4e42fe72d34add8037`.

The upstream project is distributed under the MIT License. Its license text
is retained in `third_party/whisper.cpp/LICENSE`.

The model weights are downloaded separately and are not part of the vendored
source.
