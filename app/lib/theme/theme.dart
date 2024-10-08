import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType { light, dark, system }

class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = true;
  ThemeModeType _themeMode = ThemeModeType.light;

  ThemeModel() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeModeType get themeMode => _themeMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void changeThemeMode(ThemeModeType mode) {
    _themeMode = mode;
    saveThemeModePreference(mode);
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkModeEnabled') ?? true;
    _themeMode = _getSavedThemeMode(prefs.getString('themeMode'));
    notifyListeners();
  }

  void saveThemeModePreference(ThemeModeType mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.toString());
  }

  ThemeModeType _getSavedThemeMode(String? mode) {
    switch (mode) {
      case 'ThemeModeType.light':
        return ThemeModeType.light;
      case 'ThemeModeType.dark':
        return ThemeModeType.dark;
      case 'ThemeModeType.system':
        return ThemeModeType.system;
      default:
        return ThemeModeType.system;
    }
  }
}