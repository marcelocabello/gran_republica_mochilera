import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    const seed = Color(0xFF1E8A6A);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
        secondary: const Color(0xFFFD8A4E),
        tertiary: const Color(0xFF4DA1D9),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F9F6),
    );

    return base.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: base.cardTheme.copyWith(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: base.colorScheme.shadow.withOpacity(0.08),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    const seed = Color(0xFF1E8A6A);
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
        secondary: const Color(0xFFFD8A4E),
        tertiary: const Color(0xFF4DA1D9),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: base.cardTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
