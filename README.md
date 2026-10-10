# PipSpeak (hawkabuild)

Frontend-only Flutter (Material 3) app that helps students practice public
speaking — converted from Google Stitch designs with mock data.

## Run

```sh
flutter pub get
flutter run
```

### Android emulator and device builds

Install the Android SDK, the NDK version selected by Flutter, and CMake 3.22.1
through Android Studio's SDK Manager, then verify the setup and accept the SDK
licenses:

```sh
flutter doctor -v
flutter doctor --android-licenses
```

List and start an emulator if needed, then run on a specific emulator or
connected phone (replace `EMULATOR_ID` and `DEVICE_ID` with IDs from the list):

```sh
flutter emulators
flutter emulators --launch EMULATOR_ID
flutter devices
flutter run -d DEVICE_ID
```

This builds native libraries for the selected target architecture. x64
emulators are supported for app and camera testing; the bundled local LLM
currently provides native code on ARM64 devices only. For a standalone debug
APK, choose the target explicitly to avoid compiling unneeded ABIs:

```sh
flutter build apk --debug --target-platform android-arm64  # ARM phones
flutter build apk --debug --target-platform android-x64     # x64 emulators
```

## Structure

- `lib/app/` — theme (`app_colors`, `app_typography`, `app_theme`), `app_router` (go_router), providers (Riverpod)
- `lib/core/models` — plain Dart data classes
- `lib/core/services` — service interfaces + mock implementations (auth, permissions, speech analysis, documents)
- `lib/core/widgets` — reusable Pip widgets (buttons, cards, chips, fields, mascot, live meters, star/level)
- `lib/features/*/presentation` — screens: auth, onboarding, home (bottom nav), practice, feedback, documents, progress, profile, settings
- `lib/data/`, `lib/features/ai/` — stub TODOs for backend/AI integration

## Mocked

Auth, camera/mic permissions, live telemetry, speech analysis (Whisper/MediaPipe/LLM),
document parsing, persistence. Swap the `Mock*Service` classes for real
implementations to go live.

## Notes

- Light & dark themes; ThemeMode switch in Settings.
- Business rule (mock): stars earned only on improvement; level n needs 10*n stars.

## Accounts, storage and sync

- Sign-in uses Firebase Authentication (email/password; usernames map to emails).
- Everything is saved on the device first in SQLite (Drift, `lib/data/local/app_database.dart`):
  profile, practice sessions with full feedback, analyzed documents and settings.
- Only profile fields and numeric session summaries sync to Firestore
  (`users/{uid}`, `users/{uid}/sessions/{id}`). Recordings, transcripts and documents stay local.
- Stars: the first session per goal/language is a baseline (0 stars); later sessions earn
  1/2/3 stars for beating the average of the last 3 compatible sessions by +2/+5/+10 points.
  Level n needs 10 × n more stars (Level 2 at 10, Level 3 at 30, Level 4 at 60 total).

See [DEPLOYMENT.md](DEPLOYMENT.md) for Firebase setup, rules deployment, builds and models.

### Checks

```bash
flutter analyze && flutter test
cd firestore-tests && npm install && npm test   # Firestore rules (emulator, Java 21+)
```
