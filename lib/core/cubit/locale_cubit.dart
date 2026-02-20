import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_war/core/services/storage_service.dart';

enum LanguagePreference { system, en, vi }

class LocaleCubit extends Cubit<LanguagePreference> {
  LocaleCubit({required StorageService storageService})
      : _storageService = storageService,
        super(_parse(storageService.getLanguagePreference()));

  final StorageService _storageService;

  static LanguagePreference _parse(String raw) {
    switch (raw) {
      case 'en':
        return LanguagePreference.en;
      case 'vi':
        return LanguagePreference.vi;
      default:
        return LanguagePreference.system;
    }
  }

  Locale? get locale {
    switch (state) {
      case LanguagePreference.en:
        return const Locale('en');
      case LanguagePreference.vi:
        return const Locale('vi');
      case LanguagePreference.system:
        return null;
    }
  }

  Future<void> setPreference(LanguagePreference preference) async {
    if (state == preference) {
      return;
    }
    emit(preference);
    await _storageService.saveLanguagePreference(preference.name);
  }
}
