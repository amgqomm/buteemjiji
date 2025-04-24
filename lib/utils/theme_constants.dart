import 'package:flutter/material.dart';

/// Custom theme constants for the app to maintain consistent styling
class AppTheme {
  // Primary colors
  static const Color darkBackground = Color(0xFF1C1C24);
  static const Color cardBackground = Color(0xFF252836);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryOrange = Color(0xFFFF8A65);
  static const Color accentPurple = Color(0xFFB388FF);

  // Stats colors
  static const Color healthRed = Color(0xFFE57373);
  static const Color expAmber = Color(0xFFFFD54F);
  static const Color coinOrange = Color(0xFFFFA726);

  // Task type colors
  static const Color habitBlue = Color(0xFF42A5F5);
  static const Color dailyPurple = Color(0xFF9575CD);
  static const Color todoTeal = Color(0xFF4DB6AC);
  static const Color rewardOrange = Color(0xFFFF8A65);

  // Other UI elements
  static const Color positiveGreen = Color(0xFF66BB6A);
  static const Color negativeRed = Color(0xFFEF5350);
  static const Color disabledGrey = Color(0xFF757575);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);

  // Border and input colors
  static const Color borderBlue = Color(0xFF0D47A1);
  static const Color inputFillDark = Color(0xFF2C2C34);

  // Task difficulty colors
  static const Color difficultyEasy = Color(0xFF81C784);
  static const Color difficultyMedium = Color(0xFFFFD54F);
  static const Color difficultyHard = Color(0xFFE57373);

  // Create a standardized card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
  );

  // Create a standardized input decoration
  static InputDecoration inputDecoration({String? labelText, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: inputFillDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
    );
  }
}