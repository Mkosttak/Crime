import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Modern tema renk paleti
class GameColors {
  static const primaryDark = Color(0xFF0A0E27);
  static const primary = Color(0xFF1A1F3A);
  static const primaryLight = Color(0xFF1A1F3A);
  static const accent = Color(0xFFD4AF37); // Altın sarısı
  static const accentSecondary = Color(0xFF8B0000); // Koyu kırmızı
  static const surface = Color(0xFF1E1E2E);
  static const surfaceVariant = Color(0xFF2A2A3A);
  static const onSurface = Color(0xFFE6E6E6);
  static const onSurfaceVariant = Color(0xFFB3B3B3);
  static const onPrimary = Color(0xFFE6E6E6);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFD32F2F);
  static const cardBackground = Color(0xFF1C1C2E);
  static const borderColor = Color(0xFF3A3A4A);
}

class GameTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: GameColors.accent,
        secondary: GameColors.accentSecondary,
        surface: GameColors.surface,
        surfaceVariant: GameColors.surfaceVariant,
        onSurface: GameColors.onSurface,
        onSurfaceVariant: GameColors.onSurfaceVariant,
        background: GameColors.primaryDark,
        onBackground: GameColors.onSurface,
      ),
      scaffoldBackgroundColor: GameColors.primaryDark,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: GameColors.onSurface,
        displayColor: GameColors.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: GameColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: GameColors.accent,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: GameColors.cardBackground,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.accent,
          foregroundColor: GameColors.primaryDark,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GameColors.accent,
          side: const BorderSide(color: GameColors.accent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GameColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GameColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GameColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GameColors.accent, width: 2),
        ),
        hintStyle: TextStyle(
          color: GameColors.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: GameColors.borderColor,
        thickness: 1,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: GameColors.primaryLight,
        secondary: GameColors.accent,
        surface: Colors.white,
        onSurface: GameColors.primaryDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
