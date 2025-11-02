/// Application Themes
/// Defines multiple UI themes: GitHub High Contrast, JetBrains IDE, and Xcode styles
/// Student: HE HUALIANG (230263367)

import 'package:flutter/material.dart';

/// Theme types available in the application
enum ThemeType {
  defaultTheme,
  githubHighContrast,
  jetbrains,
  xcode,
}

/// Application themes manager
class AppThemes {
  /// Default theme (original Material Design 3)
  static ThemeData get defaultTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color.fromARGB(255, 207, 183, 105),
      brightness: Brightness.light,
    );
  }

  /// GitHub High Contrast Theme
  /// Based on GitHub's high contrast color scheme
  static ThemeData get githubHighContrast {
    const primaryColor = Color(0xFF0969DA); // GitHub blue
    const backgroundColor = Color(0xFF0D1117); // GitHub dark background
    const surfaceColor = Color(0xFF161B22); // GitHub surface
    const textColor = Color(0xFFF0F6FC); // GitHub text
    const accentColor = Color(0xFF58A6FF); // GitHub accent
    const errorColor = Color(0xFFFF7B72); // GitHub error
    const successColor = Color(0xFF3FB950); // GitHub success

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFF30363D), width: 1),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF30363D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: successColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      
      // Navigation rail theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: const IconThemeData(color: accentColor),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF8B949E)),
        selectedLabelTextStyle: const TextStyle(color: textColor),
        unselectedLabelTextStyle: const TextStyle(color: Color(0xFF8B949E)),
      ),
      
      // Text theme
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// JetBrains IDE Theme (IntelliJ IDEA style)
  /// Based on JetBrains' Darcula theme
  static ThemeData get jetbrains {
    const primaryColor = Color(0xFF4B93E5); // IntelliJ blue
    const backgroundColor = Color(0xFF2B2B2B); // Darcula background
    const surfaceColor = Color(0xFF3C3F41); // Darcula surface
    const textColor = Color(0xFFA9B7C6); // Darcula text
    const accentColor = Color(0xFFFFC66D); // IntelliJ yellow
    const errorColor = Color(0xFFFF6B68); // IntelliJ error
    const successColor = Color(0xFF6A8759); // IntelliJ green

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: backgroundColor,
        onSurface: textColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFF535353), width: 1),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF535353)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF535353)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      
      // Navigation rail theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: const IconThemeData(color: accentColor),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF787878)),
        selectedLabelTextStyle: const TextStyle(color: accentColor),
        unselectedLabelTextStyle: const TextStyle(color: Color(0xFF787878)),
      ),
      
      // Text theme with JetBrains Mono-style font
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Xcode Theme (macOS developer tools style)
  /// Based on Xcode's default light theme
  static ThemeData get xcode {
    const primaryColor = Color(0xFF007AFF); // iOS blue
    const backgroundColor = Color(0xFFFFFFFF); // White background
    const surfaceColor = Color(0xFFF5F5F5); // Light gray surface
    const textColor = Color(0xFF000000); // Black text
    const accentColor = Color(0xFF5856D6); // iOS purple
    const errorColor = Color(0xFFFF3B30); // iOS red
    const successColor = Color(0xFF34C759); // iOS green

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D1D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D1D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Navigation rail theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: const IconThemeData(color: primaryColor),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF8E8E93)),
        selectedLabelTextStyle: const TextStyle(color: primaryColor),
        unselectedLabelTextStyle: const TextStyle(color: Color(0xFF8E8E93)),
      ),
      
      // Text theme with San Francisco-style font
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Get theme by type
  static ThemeData getTheme(ThemeType type) {
    switch (type) {
      case ThemeType.defaultTheme:
        return defaultTheme;
      case ThemeType.githubHighContrast:
        return githubHighContrast;
      case ThemeType.jetbrains:
        return jetbrains;
      case ThemeType.xcode:
        return xcode;
    }
  }

  /// Get theme name
  static String getThemeName(ThemeType type) {
    switch (type) {
      case ThemeType.defaultTheme:
        return 'Default';
      case ThemeType.githubHighContrast:
        return 'GitHub High Contrast';
      case ThemeType.jetbrains:
        return 'JetBrains IDE';
      case ThemeType.xcode:
        return 'Xcode';
    }
  }

  /// Get all available themes
  static List<ThemeType> get allThemes => ThemeType.values;
}
