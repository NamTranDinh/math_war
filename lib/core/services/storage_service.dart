import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_config.dart';

/// Service for persisting game data
class StorageService {
  static const String _keyBestScore = 'best_score';
  static const String _keyTotalScore = 'total_score';
  static const String _keyGameConfig = 'game_config';
  static const String _keyThemePreference = 'theme_preference';
  static const String _keyLanguagePreference = 'language_preference';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize storage service
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Save best score
  Future<void> saveBestScore(int score) async {
    await _prefs.setInt(_keyBestScore, score);
  }

  /// Get best score
  int getBestScore() {
    return _prefs.getInt(_keyBestScore) ?? 0;
  }

  /// Save total score
  Future<void> saveTotalScore(int score) async {
    await _prefs.setInt(_keyTotalScore, score);
  }

  /// Get total score
  int getTotalScore() {
    return _prefs.getInt(_keyTotalScore) ?? 0;
  }

  /// Save game configuration
  Future<void> saveGameConfig(GameConfig config) async {
    final jsonString = jsonEncode(config.toJson());
    await _prefs.setString(_keyGameConfig, jsonString);
  }

  /// Get game configuration
  GameConfig getGameConfig() {
    final jsonString = _prefs.getString(_keyGameConfig);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return GameConfig.fromJson(json);
      } catch (e) {
        return GameConfig.defaultConfig();
      }
    }
    return GameConfig.defaultConfig();
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// Save theme preference: system | light | dark
  Future<void> saveThemePreference(String value) async {
    await _prefs.setString(_keyThemePreference, value);
  }

  /// Get theme preference
  String getThemePreference() {
    return _prefs.getString(_keyThemePreference) ?? 'system';
  }

  /// Save language preference: system | en | vi
  Future<void> saveLanguagePreference(String value) async {
    await _prefs.setString(_keyLanguagePreference, value);
  }

  /// Get language preference
  String getLanguagePreference() {
    return _prefs.getString(_keyLanguagePreference) ?? 'system';
  }
}
