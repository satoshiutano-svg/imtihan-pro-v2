import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/preferences_service.dart';

/// Manages Light (default), Dark, and System theme selection with persistence.
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ref.read(preferencesServiceProvider).getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await ref.read(preferencesServiceProvider).setThemeMode(mode);
  }

  Future<void> toggleLightDark(Brightness currentPlatformBrightness) async {
    final bool currentlyDark = state == ThemeMode.dark ||
        (state == ThemeMode.system &&
            currentPlatformBrightness == Brightness.dark);
    await setThemeMode(currentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);
