import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern Premium Theme for AI Persona App
class AppTheme {
  // 🎨 Color Palette
  static const Color primaryColor = Color(0xFF4F46E5); // Royal Blue
  static const Color primaryLight = Color(0xFF6366F1); // Lighter Royal Blue
  static const Color primaryDark = Color(0xFF3F3BDB); // Darker Royal Blue
  static const Color accentColor = Color(0xFF14B8A6); // Soft Teal
  static const Color backgroundColor = Color(0xFFF5F7FA); // Very light grey
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF1F2937); // Dark Grey
  static const Color textSecondary = Color(0xFF6B7280); // Medium Grey
  static const Color dividerColor = Color(0xFFE5E7EB); // Light Grey
  static const Color errorColor = Color(0xFFEF4444); // Red for errors

  // Message bubble colors
  static const Color userBubbleColor = Color(0xFF4F46E5); // Royal Blue
  static const Color aiBubbleColor = Color(0xFFF3F4F6); // Very light grey
  static const Color userTextColor = Color(0xFFFFFFFF); // White text on user bubble
  static const Color aiTextColor = Color(0xFF1F2937); // Dark text on AI bubble

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 📐 Border Radius
  static const double cardBorderRadius = 24.0;
  static const double inputBorderRadius = 24.0;
  static const double iconBorderRadius = 20.0;
  static const double smallBorderRadius = 12.0;

  // 📏 Spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 24.0;
  static const double paddingXXL = 32.0;

  // ✨ Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> inputShadow = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  /// Light Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      dividerColor: dividerColor,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        // Sliver AppBar large title
        displayLarge: GoogleFonts.poppins(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingXL,
            vertical: paddingMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(inputBorderRadius),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingLG,
          vertical: paddingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputBorderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  /// Dark Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: const Color(0xFF0B0B0E),
      cardColor: const Color(0xFF111216),
      dividerColor: const Color(0xFF222428),
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        secondary: accentColor,
        surface: const Color(0xFF0F1113),
        background: const Color(0xFF0B0B0E),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0F1113),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFB9BDC4),
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9AA0A6),
        ),
      ),
    );
  }

  /// Palette helper that adapts to the active theme (light/dark)
  static AppPalette of(BuildContext context) => AppPalette._(Theme.of(context));
}

class AppPalette {
  final ThemeData theme;
  late final Color primaryColor;
  late final Color accentColor;
  late final Color backgroundColor;
  late final Color surfaceColor;
  late final Color textPrimary;
  late final Color textSecondary;
  late final Color dividerColor;
  late final Color errorColor;
  late final Color userBubbleColor;
  late final Color aiBubbleColor;
  late final Color userTextColor;
  late final Color aiTextColor;
  late final LinearGradient primaryGradient;
  late final List<BoxShadow> cardShadow;

  AppPalette._(this.theme) {
    final cs = theme.colorScheme;
    final bright = theme.brightness == Brightness.light;
    primaryColor = cs.primary;
    accentColor = cs.secondary;
    backgroundColor = theme.scaffoldBackgroundColor;
    surfaceColor = cs.surface;
    dividerColor = theme.dividerColor;
    errorColor = cs.error;
    textPrimary = theme.textTheme.bodyLarge?.color ?? (bright ? const Color(0xFF1F2937) : Colors.white);
    textSecondary = theme.textTheme.bodySmall?.color ?? (bright ? const Color(0xFF6B7280) : const Color(0xFF9AA0A6));
    userBubbleColor = cs.primary;
    aiBubbleColor = bright ? const Color(0xFFF3F4F6) : const Color(0xFF111215);
    userTextColor = cs.onPrimary;
    aiTextColor = theme.textTheme.bodyMedium?.color ?? (bright ? const Color(0xFF1F2937) : const Color(0xFFB9BDC4));
    primaryGradient = LinearGradient(colors: [primaryColor, primaryColor.withOpacity(0.9)], begin: Alignment.topLeft, end: Alignment.bottomRight);
    cardShadow = [
      BoxShadow(
        color: bright ? const Color(0x1A000000) : Colors.black.withOpacity(0.6),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
