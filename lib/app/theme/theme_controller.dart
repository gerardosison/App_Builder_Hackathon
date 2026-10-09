import 'package:flutter/material.dart';

import '../app_providers.dart';

final appThemeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

Future<void> loadTheme() async {
  final savedTheme = await appDatabase.setting('theme');

  appThemeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
}

Future<void> setAppThemeMode(ThemeMode mode) async {
  await appDatabase.setSetting(
    'theme',
    mode == ThemeMode.dark ? 'dark' : 'light',
  );

  appThemeMode.value = mode;
}
