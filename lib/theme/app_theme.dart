import 'package:flutter/material.dart';

class AppTheme {
  // Pastel color palette
  static const Color pastelBlue = Color(0xFFB8E0D2);
  static const Color softLavender = Color(0xFFD6B2FF);
  static const Color warmBeige = Color(0xFFF5F5DC);
  static const Color softMint = Color(0xFFB8F2E6);
  static const Color paleRose = Color(0xFFFFD3E1);
  static const Color lightPeach = Color(0xFFFFE5CC);
  
  // Text colors
  static const Color darkGray = Color(0xFF2C3E50);
  static const Color mediumGray = Color(0xFF7F8C8D);
  static const Color lightGray = Color(0xFFECF0F1);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    
    colorScheme: const ColorScheme.light(
      primary: pastelBlue,
      secondary: softLavender,
      surface: Colors.white,
      onSurface: darkGray,
      onPrimary: darkGray,
      onSecondary: darkGray,
      tertiary: softMint,
      outline: lightGray,
    ),
    
    scaffoldBackgroundColor: Colors.white,
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: darkGray),
      titleTextStyle: TextStyle(
        color: darkGray,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: pastelBlue,
        foregroundColor: darkGray,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: softLavender,
      foregroundColor: darkGray,
      elevation: 4,
    ),
    
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkGray,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkGray,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkGray,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: mediumGray,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkGray,
      ),
    ),
    
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: pastelBlue,
      unselectedItemColor: mediumGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    ),
  );
}
