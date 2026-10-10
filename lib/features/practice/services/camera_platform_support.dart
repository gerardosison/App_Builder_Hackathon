import 'package:flutter/foundation.dart';

bool get cameraPluginSupportedOnCurrentPlatform =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

String get cameraPluginUnavailableMessage =>
    cameraPluginSupportedOnCurrentPlatform
        ? 'The camera plugin is not registered. Fully stop the app, run flutter pub get, and rebuild it.'
        : 'The camera plugin supports Android, iOS, and web, but not this desktop platform. Use a supported target or add a desktop camera plugin.';
