/// Theme Provider
/// Manages application theme state and persistence
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

/// Theme provider for managing theme changes
class ThemeProvider extends ChangeNotifier {
  ThemeType _currentTheme = ThemeType.defaultTheme;
  static const String _themeKey = 'app_theme';

  ThemeProvider() {
    _loadTheme();
  }

  /// Get current theme type
  ThemeType get currentTheme => _currentTheme;

  /// Get current theme data
  ThemeData get themeData => AppThemes.getTheme(_currentTheme);

  /// Get current theme name
  String get themeName => AppThemes.getThemeName(_currentTheme);

  /// Load theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null && themeIndex < ThemeType.values.length) {
        _currentTheme = ThemeType.values[themeIndex];
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, use default theme
      _currentTheme = ThemeType.defaultTheme;
    }
  }

  /// Set theme and persist to shared preferences
  Future<void> setTheme(ThemeType theme) async {
    if (_currentTheme == theme) return;

    _currentTheme = theme;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Toggle to next theme (for demo/testing purposes)
  Future<void> toggleTheme() async {
    final currentIndex = _currentTheme.index;
    final nextIndex = (currentIndex + 1) % ThemeType.values.length;
    await setTheme(ThemeType.values[nextIndex]);
  }
}
