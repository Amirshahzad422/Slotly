import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary Brand Colors
  static const Color primary = Color(0xFF7C5CFC); // Primary vibrant purple
  static const Color primaryDark = Color(0xFF6344E0);
  static const Color primaryLight = Color(0xFFECE7FF);
  
  static const Color darkPill = Color(0xFF18181B); // Dark capsule button & header pill
  static const Color background = Color(0xFFFAF8F5); // Soft warm off-white canvas
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Dark charcoal text
  static const Color textSecondary = Color(0xFF6B7280); // Muted slate gray
  static const Color textLight = Color(0xFF9CA3AF);

  // Soft Pastel Card Background Palette (as seen in visual reference)
  static const List<Color> pastelPalette = [
    Color(0xFFFFEBF2), // Soft Pink
    Color(0xFFFFF1E6), // Soft Peach / Warm Cream
    Color(0xFFEAE8FF), // Soft Lavender
    Color(0xFFE1F5FE), // Soft Sky Blue
    Color(0xFFDCF5E7), // Soft Mint Green
    Color(0xFFFFFDE7), // Soft Cream Yellow
  ];

  static const Color softPink = Color(0xFFFFEBF2);
  static const Color softPeach = Color(0xFFFFF1E6);
  static const Color softLavender = Color(0xFFEAE8FF);
  static const Color softSkyBlue = Color(0xFFE1F5FE);
  static const Color softMint = Color(0xFFDCF5E7);

  // Status & Badges
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color border = Color(0xFFE5E7EB);
}
