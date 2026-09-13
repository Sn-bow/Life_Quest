import 'package:flutter/material.dart';

/// Reference direction: ARISE's dark/value contrast, LifeUp's clear action rows,
/// and Material's accessible controls. No third-party game artwork is bundled.
class QuestTheme {
  static ThemeData build(Brightness brightness, {String? cosmetic}) {
    final dark = brightness == Brightness.dark;
    final accent = switch (cosmetic) {
      'theme_royal_gold' =>
        dark ? const Color(0xFFF4D38A) : const Color(0xFF785400),
      'theme_neon_cyberpunk' =>
        dark ? const Color(0xFFFFA2DC) : const Color(0xFF9E246A),
      _ => dark ? const Color(0xFF78E3EE) : const Color(0xFF006D80),
    };
    final background = dark ? const Color(0xFF080F1B) : const Color(0xFFF5F7FB);
    final surface = dark ? const Color(0xFF111C2D) : Colors.white;
    final foreground = dark ? const Color(0xFFEDF4FA) : const Color(0xFF172337);
    final muted = dark ? const Color(0xFF9DACBF) : const Color(0xFF596579);
    final border = dark ? const Color(0xFF27364C) : const Color(0xFFD9E2EC);
    final scheme =
        ColorScheme.fromSeed(seedColor: accent, brightness: brightness)
            .copyWith(
      primary: accent,
      onPrimary: dark ? const Color(0xFF072B33) : Colors.white,
      surface: surface,
      onSurface: foreground,
      onSurfaceVariant: muted,
      secondary: dark ? const Color(0xFFBDB0F4) : const Color(0xFF67529B),
      outline: border,
      outlineVariant: border,
    );
    final base = ThemeData(
        brightness: brightness,
        useMaterial3: true,
        colorScheme: scheme,
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: background,
        primaryColor: accent);
    return base.copyWith(
      textTheme: base.textTheme
          .apply(bodyColor: foreground, displayColor: foreground)
          .copyWith(
            headlineMedium: TextStyle(
                fontSize: 29,
                height: 1.3,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: foreground),
            titleLarge: TextStyle(
                fontSize: 21,
                height: 1.4,
                fontWeight: FontWeight.w700,
                letterSpacing: -.6,
                color: foreground),
            titleMedium: TextStyle(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -.3,
                color: foreground),
            bodyMedium:
                TextStyle(fontSize: 14, height: 1.55, color: foreground),
            bodySmall: TextStyle(fontSize: 12, height: 1.5, color: muted),
          ),
      appBarTheme: AppBarTheme(
          backgroundColor: background,
          foregroundColor: foreground,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontFamily: 'NotoSansKR',
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: foreground)),
      cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: border))),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: background,
          indicatorColor: accent.withValues(alpha: .14),
          height: 76,
          labelTextStyle: WidgetStatePropertyAll(TextStyle(
              fontFamily: 'NotoSansKR',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground))),
      dividerTheme: DividerThemeData(color: border, space: 1, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              minimumSize: const Size(48, 48),
              textStyle: const TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w700,
                  fontSize: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              minimumSize: const Size(48, 48),
              side: BorderSide(color: border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)))),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48))),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: background,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: border))),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: surface,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          showDragHandle: true),
      dialogTheme: DialogThemeData(
          backgroundColor: surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
      snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              dark ? const Color(0xFF273B50) : const Color(0xFF173B4A),
          contentTextStyle: const TextStyle(
              fontFamily: 'NotoSansKR', color: Colors.white, fontSize: 14)),
      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: accent, linearTrackColor: border),
    );
  }
}
