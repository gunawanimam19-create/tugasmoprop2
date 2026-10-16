import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFE65100);
  static const Color primaryOrangeLight = Color(0xFFFF8A50);
  static const Color secondaryGreen = Color(0xFF00897B);
  static const Color accentRed = Color(0xFFE53935);
  static const Color warmCream = Color(0xFFFFF8E7);
  static const Color bgLight = Color(0xFFF9F7F3);
  static const Color cardLight = Colors.white;

  static const Color bgDark = Color(0xFF141517);
  static const Color cardDark = Color(0xFF212327);
  static const Color surfaceDark = Color(0xFF2A2D32);

  // Rupiah Formatter Helper
  static String formatRupiah(int amount) {
    String str = amount.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result = str.replaceAllMapped(reg, (Match match) => '${match[1]}.');
    return 'Rp $result';
  }

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryOrange,
    scaffoldBackgroundColor: bgLight,
    colorScheme: const ColorScheme.light(
      primary: primaryOrange,
      onPrimary: Colors.white,
      secondary: secondaryGreen,
      onSecondary: Colors.white,
      tertiary: accentRed,
      surface: cardLight,
      surfaceTint: Colors.transparent,
      error: accentRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardLight,
      foregroundColor: Color(0xFF1F2937),
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: const BorderSide(color: primaryOrange, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF3F4F6),
      selectedColor: primaryOrange,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryOrangeLight,
    scaffoldBackgroundColor: bgDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryOrangeLight,
      onPrimary: Colors.black,
      secondary: Color(0xFF26A69A),
      onSecondary: Colors.black,
      tertiary: Color(0xFFEF5350),
      surface: cardDark,
      surfaceTint: Colors.transparent,
      error: Color(0xFFEF5350),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF374151), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrangeLight,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrangeLight,
        side: const BorderSide(color: primaryOrangeLight, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4B5563)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF374151)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryOrangeLight, width: 2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceDark,
      selectedColor: primaryOrangeLight,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
  );
}
