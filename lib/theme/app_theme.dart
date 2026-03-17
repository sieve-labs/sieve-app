import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Monochrome theme colors for Sieve app
class SieveColors {
  // Light theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0A0A0A);
  static const Color lightTextSecondary = Color(0xFF555555);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightGridLine = Color(0xFFE8E8E8);
  static const Color lightGridLineMajor = Color(0xFFD0D0D0);

  // Dark theme
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkTextPrimary = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFF888888);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkGridLine = Color(0xFF1E1E1E);
  static const Color darkGridLineMajor = Color(0xFF252525);

  // Accent (used in both themes)
  static const Color accent = Color(0xFF7085FF);
  static const Color accentText = Color(0xFFFFFFFF);
}

/// Theme extensions for easy access
extension SieveThemeExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;

  Color get sieveBackground =>
      isDark ? SieveColors.darkBackground : SieveColors.lightBackground;

  Color get sieveTextPrimary =>
      isDark ? SieveColors.darkTextPrimary : SieveColors.lightTextPrimary;

  Color get sieveTextSecondary =>
      isDark ? SieveColors.darkTextSecondary : SieveColors.lightTextSecondary;

  Color get sieveSurface =>
      isDark ? SieveColors.darkSurface : SieveColors.lightSurface;

  Color get sieveBorder =>
      isDark ? SieveColors.darkBorder : SieveColors.lightBorder;

  Color get sieveGridLine =>
      isDark ? SieveColors.darkGridLine : SieveColors.lightGridLine;

  Color get sieveGridLineMajor =>
      isDark ? SieveColors.darkGridLineMajor : SieveColors.lightGridLineMajor;

  Color get sieveAccent => SieveColors.accent;
  Color get sieveAccentText => SieveColors.accentText;
}

/// Creates the light theme for Sieve
ThemeData createSieveLightTheme() {
  final base = ThemeData.light();
  final jetbrainsMono = GoogleFonts.jetBrainsMono();

  return base.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: SieveColors.lightBackground,
    primaryColor: SieveColors.accent,
    colorScheme: const ColorScheme.light(
      primary: SieveColors.accent,
      onPrimary: SieveColors.accentText,
      secondary: SieveColors.accent,
      onSecondary: SieveColors.accentText,
      surface: SieveColors.lightSurface,
      onSurface: SieveColors.lightTextPrimary,
      background: SieveColors.lightBackground,
      onBackground: SieveColors.lightTextPrimary,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.jetBrainsMonoTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextSecondary,
        fontSize: 12,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: SieveColors.lightBackground,
      foregroundColor: SieveColors.lightTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    cardTheme: CardThemeData(
      color: SieveColors.lightSurface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.lightBorder),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SieveColors.accent,
        foregroundColor: SieveColors.accentText,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: SieveColors.accent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SieveColors.lightTextPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        side: const BorderSide(color: SieveColors.lightBorder),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SieveColors.accent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SieveColors.lightSurface,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.lightBorder),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.lightBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.accent),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextSecondary,
      ),
      hintStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextSecondary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: SieveColors.lightBackground,
      selectedItemColor: SieveColors.accent,
      unselectedItemColor: SieveColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 12),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SieveColors.lightBackground,
      indicatorColor: SieveColors.accent.withOpacity(0.1),
      iconTheme: MaterialStateProperty.all(
        IconThemeData(color: SieveColors.lightTextSecondary),
      ),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.jetBrainsMono(fontSize: 12),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: SieveColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.lightBorder),
      ),
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 14,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: SieveColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.lightBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: SieveColors.lightBorder,
      thickness: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: SieveColors.accent,
      linearTrackColor: SieveColors.lightGridLine,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: SieveColors.lightSurface,
      selectedColor: SieveColors.accent.withOpacity(0.1),
      labelStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 12,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.lightBorder),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: SieveColors.lightTextPrimary,
      iconColor: SieveColors.lightTextSecondary,
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextPrimary,
        fontSize: 16,
      ),
      subtitleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.lightTextSecondary,
        fontSize: 14,
      ),
    ),
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}

/// Creates the dark theme for Sieve
ThemeData createSieveDarkTheme() {
  final base = ThemeData.dark();
  final jetbrainsMono = GoogleFonts.jetBrainsMono();

  return base.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SieveColors.darkBackground,
    primaryColor: SieveColors.accent,
    colorScheme: const ColorScheme.dark(
      primary: SieveColors.accent,
      onPrimary: SieveColors.accentText,
      secondary: SieveColors.accent,
      onSecondary: SieveColors.accentText,
      surface: SieveColors.darkSurface,
      onSurface: SieveColors.darkTextPrimary,
      background: SieveColors.darkBackground,
      onBackground: SieveColors.darkTextPrimary,
      error: Colors.red,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.jetBrainsMonoTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextSecondary,
        fontSize: 12,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: SieveColors.darkBackground,
      foregroundColor: SieveColors.darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    cardTheme: CardThemeData(
      color: SieveColors.darkSurface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.darkBorder),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SieveColors.accent,
        foregroundColor: SieveColors.accentText,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: SieveColors.accent),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: SieveColors.darkTextPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        side: const BorderSide(color: SieveColors.darkBorder),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SieveColors.accent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        textStyle: GoogleFonts.jetBrainsMono(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SieveColors.darkSurface,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.darkBorder),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.darkBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: SieveColors.accent),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextSecondary,
      ),
      hintStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextSecondary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: SieveColors.darkBackground,
      selectedItemColor: SieveColors.accent,
      unselectedItemColor: SieveColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 12),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: SieveColors.darkBackground,
      indicatorColor: SieveColors.accent.withOpacity(0.1),
      iconTheme: MaterialStateProperty.all(
        IconThemeData(color: SieveColors.darkTextSecondary),
      ),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.jetBrainsMono(fontSize: 12),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: SieveColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.darkBorder),
      ),
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 14,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: SieveColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.darkBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: SieveColors.darkBorder,
      thickness: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: SieveColors.accent,
      linearTrackColor: SieveColors.darkGridLine,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: SieveColors.darkSurface,
      selectedColor: SieveColors.accent.withOpacity(0.1),
      labelStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 12,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: SieveColors.darkBorder),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: SieveColors.darkTextPrimary,
      iconColor: SieveColors.darkTextSecondary,
      titleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextPrimary,
        fontSize: 16,
      ),
      subtitleTextStyle: GoogleFonts.jetBrainsMono(
        color: SieveColors.darkTextSecondary,
        fontSize: 14,
      ),
    ),
    shadowColor: Colors.transparent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}
