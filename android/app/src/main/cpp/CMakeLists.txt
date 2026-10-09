cmake_minimum_required(VERSION 3.22.1)
project(hawkabuild_whisper LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Vendored upstream whisper.cpp source. Keep the relative path so teammates
# can build from a fresh checkout without machine-specific SDK paths.
set(WHISPER_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../../../third_party/whisper.cpp")

# The app builds whisper.cpp directly instead of adding its complete upstream
# CMake project, so mirror the upstream version macro required by whisper.cpp.
foreach(component MAJOR MINOR PATCH)
    file(STRINGS "${WHISPER_ROOT}/CMakeLists.txt" WHISPER_VERSION_${component}_LINE
        REGEX "^set\\(WHISPER_VERSION_${component} [0-9]+\\)")
    string(REGEX REPLACE "^set\\(WHISPER_VERSION_${component} ([0-9]+)\\).*" "\\1"
        WHISPER_VERSION_${component} "${WHISPER_VERSION_${component}_LINE}")
endforeach()
set(WHISPER_VERSION "${WHISPER_VERSION_MAJOR}.${WHISPER_VERSION_MINOR}.${WHISPER_VERSION_PATCH}")

# Small, portable CPU build for 32-bit and 64-bit ARM Android devices.
set(GGML_NATIVE OFF CACHE BOOL "Disable build-host CPU tuning" FORCE)
set(GGML_OPENMP OFF CACHE BOOL "Avoid an extra OpenMP runtime" FORCE)
set(GGML_VULKAN OFF CACHE BOOL "Use CPU inference for Whisper" FORCE)
set(GGML_LLAMAFILE OFF CACHE BOOL "Disable unsupported Android backend" FORCE)
set(GGML_CUDA OFF CACHE BOOL "Disable CUDA on Android" FORCE)
# llama_flutter_android bundles its own shared libggml*.so libraries. Build
# Whisper's GGML as hidden static code inside libwhisper.so so it cannot
# replace or interpose on the GGML libraries Qwen needs at runtime.
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Keep Whisper GGML private to libwhisper" FORCE)
set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
set(WHISPER_BUILD_TESTS OFF CACHE BOOL "Disable Whisper tests" FORCE)
set(WHISPER_BUILD_EXAMPLES OFF CACHE BOOL "Disable Whisper examples" FORCE)
set(WHISPER_BUILD_SERVER OFF CACHE BOOL "Disable Whisper server" FORCE)
set(WHISPER_FFMPEG OFF CACHE BOOL "Audio is decoded by the Android app" FORCE)

add_subdirectory("${WHISPER_ROOT}/ggml" "${CMAKE_CURRENT_BINARY_DIR}/ggml")

find_library(ANDROID_LOG_LIB log)

add_library(whisper SHARED
    "${WHISPER_ROOT}/src/whisper.cpp"
    "${WHISPER_ROOT}/src/aneforge/whisper-aneforge.cpp"
    jni.c
)

target_include_directories(whisper PRIVATE
    "${WHISPER_ROOT}/include"
    "${WHISPER_ROOT}/ggml/include"
    "${WHISPER_ROOT}/ggml/src"
    "${WHISPER_ROOT}/ggml/src/ggml-cpu"
)

target_compile_definitions(whisper PRIVATE GGML_USE_CPU WHISPER_VERSION="${WHISPER_VERSION}")
target_link_libraries(whisper PRIVATE ggml android "${ANDROID_LOG_LIB}")
