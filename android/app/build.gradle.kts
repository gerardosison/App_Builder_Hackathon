import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Flutter passes the selected device architecture to Gradle when running on a
// connected phone or emulator. Build only that ABI for faster native CMake
// builds. The local LLM plugin currently ships native code for ARM64 only;
// x64 emulators can still run the app, but that plugin safely disables itself.
val abiByFlutterPlatform = mapOf(
    "android-arm" to "armeabi-v7a",
    "android-arm64" to "arm64-v8a",
    "android-x64" to "x86_64",
)
val targetPlatformAbis = providers.gradleProperty("target-platform")
    .orNull
    ?.split(",")
    ?.map { platform ->
        abiByFlutterPlatform[platform]
            ?: throw GradleException(
                "Unsupported Flutter Android target platform '$platform'. " +
                    "Use android-arm, android-arm64, or android-x64."
            )
    }
    ?.distinct()
    ?: listOf("arm64-v8a", "armeabi-v7a", "x86_64")

android {
    namespace = "com.hawkabuild.hawkabuild"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        // Must match the Android app registered in google-services.json.
        applicationId = "com.gerardosison.app_builder_hackathon"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters += targetPlatformAbis
        }

        externalNativeBuild {
            cmake {
                cppFlags += listOf("-std=c++17")
            }
        }
    }

    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.9.0")
}
