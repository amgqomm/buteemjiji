import 'package:flutter/material.dart';

class AppTheme {
  static const primaryBlueLight = Color(0xFF64B5F6);
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

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
  );

  static InputDecoration inputDecoration({
    String? labelText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
    );
  }
}

ThemeData appTheme = ThemeData.dark().copyWith(
  primaryColor: AppTheme.primaryBlue,
  scaffoldBackgroundColor: AppTheme.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppTheme.darkBackground,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: AppTheme.cardBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size(double.infinity, 48),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBlue),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white60,
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppTheme.cardBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.borderBlue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.borderBlue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
    ),
    labelStyle: const TextStyle(color: AppTheme.textSecondary),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppTheme.primaryBlue;
      }
      return AppTheme.disabledGrey;
    }),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppTheme.primaryBlue,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: AppTheme.textSecondary),
  ),
);
