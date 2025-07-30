import 'package:flutter/material.dart';

class AppTheme {
  static final Color surface = Color(0xFF1E1B17);
  static final Color background = Color(0xFF2B2621);
  static final Color accent = Color(0xFF81D4B0);
  static final Color pill = Color(0xFF3A332D);
  static final Color textPrimary = Color(0xFFF8F1E7);
  static final Color textSecondary = Color(0xFFB8ADA2);
  static final Color button = Color(0xFF4B4035);
  static final Color buttonText = Color(0xFFF8F1E7);
  static final Color danger = Color(0xFFEF5350);
  static final Color income = Color(0xFF66BB6A);
  static final Color expense = Color(0xFFEF5350);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: accent,
    colorScheme: ColorScheme.dark(
      background: background,
      surface: surface,
      primary: accent,
      secondary: accent,
      error: danger,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: button,
        foregroundColor: buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
