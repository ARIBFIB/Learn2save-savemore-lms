import 'package:flutter/material.dart';

class AppColors {
  // 🌿 Primary Colors
  static const Color primary = Color(0xFFF97316); // Vibrant orange
  static const Color primaryDark = Color(0xFFEA580C); // Darker orange
  static const Color primaryLight = Color(0xFFFDAE73); // Soft orange tint

  // 🌊 Secondary Colors
  static const Color secondary = Color(0xFF0EA5E9); // Sky blue accent
  static const Color secondaryDark = Color(0xFF0369A1);
  static const Color secondaryLight = Color(0xFFBAE6FD);

  // ⚪ Neutral / Background
  static const Color background = Color(0xFF0B0C2A); // Deep navy background
  static const Color surface = Color(0xFF111233); // Slightly lighter navy
  static const Color cardBackground = Color(0xFF1E1F3F); // For elevated surfaces

  // 🖋️ Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textLight = Color(0xFF94A3B8);

  // ✅ Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // 🌈 Gradients (with glowing and shading effects)

  /// 🔥 Orange glow gradient
  static const List<Color> primaryGradient = [
    Color(0xFFFFA45B),
    Color(0xFFF97316),
    Color(0xFFEA580C),
  ];

  /// 🌊 Blue shine gradient
  static const List<Color> secondaryGradient = [
    Color(0xFF67E8F9),
    Color(0xFF0EA5E9),
    Color(0xFF0369A1),
  ];

  /// 💜 Purple + Pink neon gradient
  static const List<Color> violetGradient = [
    Color(0xFF9333EA),
    Color(0xFFE879F9),
    Color(0xFFF0ABFC),
  ];

  /// 💚 Green glow gradient
  static const List<Color> successGradient = [
    Color(0xFFA7F3D0),
    Color(0xFF34D399),
    Color(0xFF059669),
  ];

  /// ❤️ Red glow gradient
  static const List<Color> dangerGradient = [
    Color(0xFFFCA5A5),
    Color(0xFFEF4444),
    Color(0xFF991B1B),
  ];

  /// ☀️ Gold shimmer gradient
  static const List<Color> goldGradient = [
    Color(0xFFFFE29F),
    Color(0xFFFFA62B),
    Color(0xFFFF6B00),
  ];

  /// 🌌 Midnight blue gradient
  static const List<Color> darkGradient = [
    Color(0xFF1E293B),
    Color(0xFF0F172A),
    Color(0xFF020617),
  ];

  // 🧱 Material Color Swatch
  static const MaterialColor primaryMaterial = MaterialColor(
    0xFFF97316,
    <int, Color>{
      50: Color(0xFFFFEDD5),
      100: Color(0xFFFED7AA),
      200: Color(0xFFFDBA74),
      300: Color(0xFFFB923C),
      400: Color(0xFFF97316),
      500: Color(0xFFEA580C),
      600: Color(0xFFC2410C),
      700: Color(0xFF9A3412),
      800: Color(0xFF7C2D12),
      900: Color(0xFF431407),
    },
  );
}
