import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';

/// Persists the chosen theme on this device. Light is the default.
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(this._database) : super(ThemeMode.light) {
    _load();
  }

  static const settingKey = 'theme_mode';
  final AppDatabase _database;

  Future<void> _load() async {
    try {
      final saved = await _database.setting(settingKey);
      final mode = ThemeMode.values.where((m) => m.name == saved);
      if (mounted && mode.isNotEmpty) state = mode.first;
    } on Object {
      // Keep the light default if settings cannot be read.
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _database.setSetting(settingKey, mode.name);
  }
}
