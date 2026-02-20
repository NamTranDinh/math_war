import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_war/core/services/storage_service.dart';

enum ThemePreference { system, light, dark }

class ThemeCubit extends Cubit<ThemePreference> {
  ThemeCubit({required StorageService storageService})
      : _storageService = storageService,
        super(_parsePreference(storageService.getThemePreference()));

  final StorageService _storageService;

  static ThemePreference _parsePreference(String raw) {
    switch (raw) {
      case 'light':
        return ThemePreference.light;
      case 'dark':
        return ThemePreference.dark;
      default:
        return ThemePreference.system;
    }
  }

  ThemeMode get themeMode {
    switch (state) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  Future<void> setPreference(ThemePreference preference) async {
    if (preference == state) {
      return;
    }
    emit(preference);
    await _storageService.saveThemePreference(preference.name);
  }
}
