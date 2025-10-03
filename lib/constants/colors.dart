import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A6FFF);
  static const MaterialColor primaryMaterialColor = MaterialColor(
    0xFF4A6FFF,
    <int, Color>{
      50: Color(0xFFEBF0FF),
      100: Color(0xFFD2E0FF),
      200: Color(0xFFB8CFFF),
      300: Color(0xFF9EBFFF),
      400: Color(0xFF8AAFFF),
      500: Color(0xFF4A6FFF),
      600: Color(0xFF3A5FEF),
      700: Color(0xFF2A4FDF),
      800: Color(0xFF1A3FCF),
      900: Color(0xFF0A2FBF),
    },
  );

  // Secondary colors
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color accent = Color(0xFF4ECDC4);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);

  // Background colors
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF48BB78);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFF56565);
  static const Color info = Color(0xFF4299E1);

  // Border colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF2F7);

  // Disabled colors
  static const Color disabledBackground = Color(0xFFF1F5F9);
  static const Color disabledText = Color(0xFFCBD5E0);

  // Shadow colors
  static const Color shadow = Color(0x1A000000);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF4A6FFF),
    Color(0xFF3A5FEF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFEE5A6F),
  ];
}