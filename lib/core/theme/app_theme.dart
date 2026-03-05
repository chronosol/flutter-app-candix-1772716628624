import 'package:flutter/material.dart';

// Custom MaterialColor for a candy-like primary color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

final MaterialColor _primaryCandyColor = createMaterialColor(const Color(0xFFF48FB1)); // Pinkish candy color

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryCandyColor,
      brightness: Brightness.light,
      surface: Colors.white, // Replaced background
      onSurface: Colors.black, // Replaced onBackground
      primary: _primaryCandyColor,
      onPrimary: Colors.white,
      secondary: Colors.deepPurpleAccent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surfaceContainerHighest: Colors.grey.shade200, // Replaced surfaceVariant
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryCandyColor.shade700, // Using shade
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
    ),
    cardTheme: CardThemeData( // Fixed CardTheme to CardThemeData
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryCandyColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryCandyColor,
      brightness: Brightness.dark,
      surface: Colors.grey.shade900, // Replaced background
      onSurface: Colors.white, // Replaced onBackground
      primary: _primaryCandyColor.shade200, // Using shade
      onPrimary: Colors.black,
      secondary: Colors.deepPurpleAccent.shade100,
      onSecondary: Colors.black,
      error: Colors.red.shade700,
      onError: Colors.white,
      surfaceContainerHighest: Colors.grey.shade800, // Replaced surfaceVariant
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryCandyColor.shade900, // Using shade
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: true,
    ),
    cardTheme: CardThemeData( // Fixed CardTheme to CardThemeData
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade800,
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryCandyColor.shade200,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    ),
  );
}
