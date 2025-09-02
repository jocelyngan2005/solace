import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Updated color palette based on the uploaded palette image
  static const Color primaryColor = Color(0xFFA596F5); // Light purple from palette
  static const Color secondaryColor = Color(0xFF95A663); // Olive green from palette
  static const Color accentColor = Color(0xFFFD904E); // Orange from palette
  static const Color darkBrown = Color(0xFF4A3427); // Dark brown from palette
  static const Color lightGray = Color(0xFFC9C8D0); // Light gray from palette
  static const Color mutedPink = Color(0xFFB9998D); // Muted pink/brown from palette
  static const Color oliveGray = Color(0xFF848767); // Olive gray from palette
  static const Color mediumGray = Color(0xFFAAAAAD); // Gray from palette
  
  // Background colors from palette
  static const Color backgroundColor = Color(0xFFF7F3F1); // Light beige from palette
  static const Color surfaceColor = Color(0xFFFEFEFE); // Very light beige/white from palette
  
  // Text colors
  static const Color darkText = Color(0xFF4A3427); // Dark brown from palette
  static const Color mediumText = Color(0xFF848767); // Olive gray from palette
  static const Color lightText = Color(0xFFAAAAAD); // Gray from palette
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onSurface: darkText,
      onPrimary: surfaceColor,
      onSecondary: surfaceColor,
      tertiary: accentColor,
      outline: lightText,
      background: backgroundColor,
    ),
    
    scaffoldBackgroundColor: backgroundColor,
    
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: darkText),
      titleTextStyle: GoogleFonts.poppins(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: surfaceColor,
      shadowColor: darkBrown.withOpacity(0.1),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: surfaceColor,
      elevation: 4,
    ),
    
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: darkText,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: mediumText,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
    ),
    
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: mediumText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
    ),
  );

  // Mood colors using the palette colors
  static const Map<String, Color> moodColors = {
    'excited': primaryColor, // Light purple
    'joyful': accentColor,  // Orange
    'grateful': secondaryColor, // Olive green
    'energized': primaryColor, // Light purple
    'sensitive': lightGray, // Light gray
    'confused': mutedPink,  // Muted pink/brown
    'bored': secondaryColor,     // Olive green
    'stressed': oliveGray,  // Olive gray
    'angry': accentColor,     // Orange
    'insecure': mutedPink,  // Muted pink/brown
    'hurt': mediumGray,      // Gray
    'guilty': accentColor,    // Orange
  };

  // Get mood color by name
  static Color getMoodColor(String moodName) {
    return moodColors[moodName.toLowerCase()] ?? primaryColor;
  }
}
