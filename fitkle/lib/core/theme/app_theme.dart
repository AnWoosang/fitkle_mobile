import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const Color background = Color(0xFFF9FAF7); // #f9faf7 - 은은한 올리브 톤 배경
  static const Color foreground = Color(0xFF1A1A1A); // #1a1a1a - 진한 회색 텍스트
  static const Color card = Color(0xFFFFFFFF); // #ffffff - 순백색 카드
  static const Color cardForeground = Color(0xFF1A1A1A); // #1a1a1a

  // Primary Sage Green Theme
  static const Color primary = Color(0xFF9EB384); // #9eb384
  static const Color primaryForeground = Color(0xFFFFFFFF); // #ffffff
  static const Color accentSage = Color(0xFFC8D5B9); // #c8d5b9
  static const Color accentRose = Color(0xFFE8C4C4); // #e8c4c4
  static const Color accentRoseDark = Color(0xFFD4999B); // #d4999b

  // Secondary & Accents
  static const Color secondary = Color(0xFFF9F5FC); // #f9f5fc
  static const Color secondaryForeground = Color(0xFF1A1A1A); // #1a1a1a
  static const Color muted = Color(0xFFF5F2F7); // #f5f2f7
  static const Color mutedForeground = Color(0xFF6B6B6B); // #6b6b6b
  static const Color accent = Color(0xFFFFF0F7); // #fff0f7
  static const Color accentForeground = Color(0xFF1A1A1A); // #1a1a1a

  // Destructive
  static const Color destructive = Color(0xFFD4183D); // #d4183d
  static const Color destructiveForeground = Color(0xFFFFFFFF); // #ffffff

  // Borders & Inputs
  static const Color border = Color(0xFFEFE8F3); // #efe8f3
  static const Color inputBackground = Color(0xFFFFFFFF); // #ffffff
  static const Color ring = Color(0xFF9EB384); // #9eb384
  static const Color inputCursor = Color(0xFF4A4A4A); // #4a4a4a - 입력 커서 색상
  static const Color inputFocusBorder = Color(0xFF666666); // #666666 - 입력 폼 포커스 테두리 (진한 회색)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: primaryForeground,
        secondary: secondary,
        onSecondary: secondaryForeground,
        error: destructive,
        onError: destructiveForeground,
        surface: card,
        onSurface: foreground,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: foreground),
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // var(--radius): 0.75rem
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ring, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: foreground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: foreground,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mutedForeground,
        ),
      ),
    );
  }
}
