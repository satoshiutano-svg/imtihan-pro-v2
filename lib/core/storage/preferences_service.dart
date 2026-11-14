import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/kpk_boards.dart';

/// App-wide key-value persistence abstraction backed by [SharedPreferences].
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyThemeMode = 'imtihan_theme_mode';
  static const String _keyOnboardingComplete = 'imtihan_onboarding_complete';
  static const String _keySelectedClass = 'imtihan_selected_class';
  static const String _keySelectedBoard = 'imtihan_selected_board';
  static const String _keySelectedGroup = 'imtihan_selected_group';
  static const String _keyStudentName = 'imtihan_student_name';

  /// Light theme is the required default when no preference has been saved.
  ThemeMode getThemeMode() {
    final String? stored = _prefs.getString(_keyThemeMode);
    switch (stored) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_keyThemeMode, value);
  }

  bool isOnboardingComplete() => _prefs.getBool(_keyOnboardingComplete) ?? false;

  Future<void> setOnboardingComplete(bool completed) =>
      _prefs.setBool(_keyOnboardingComplete, completed);

  ClassLevel? getSelectedClass() =>
      ClassLevel.fromId(_prefs.getString(_keySelectedClass));

  Future<void> setSelectedClass(ClassLevel level) =>
      _prefs.setString(_keySelectedClass, level.id);

  KpkBoard? getSelectedBoard() =>
      KpkBoard.fromId(_prefs.getString(_keySelectedBoard));

  Future<void> setSelectedBoard(KpkBoard board) =>
      _prefs.setString(_keySelectedBoard, board.id);

  AcademicGroup? getSelectedGroup() =>
      AcademicGroup.fromId(_prefs.getString(_keySelectedGroup));

  Future<void> setSelectedGroup(AcademicGroup group) =>
      _prefs.setString(_keySelectedGroup, group.id);

  String getStudentName() => _prefs.getString(_keyStudentName) ?? 'Student';

  Future<void> setStudentName(String name) =>
      _prefs.setString(_keyStudentName, name.trim());

  Future<void> clearOnboarding() async {
    await _prefs.remove(_keyOnboardingComplete);
    await _prefs.remove(_keySelectedClass);
    await _prefs.remove(_keySelectedBoard);
    await _prefs.remove(_keySelectedGroup);
  }
}

/// Must be overridden in [ProviderScope] at app startup.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError(
    'preferencesServiceProvider must be overridden in main.dart',
  );
});
