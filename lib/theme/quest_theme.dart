import 'package:flutter/material.dart';

/// Clear action rows from LifeUp, chapter navigation from reading apps.
/// An original ink/paper palette connects the three story worlds.
class QuestTheme {
  static ThemeData build(Brightness brightness, {String? cosmetic}) {
    final dark = brightness == Brightness.dark;
    final tide = cosmetic == 'theme_tide_postoffice';
    final accent = switch (cosmetic) {
      'theme_tide_postoffice' =>
        dark ? const Color(0xFFA0DFD1) : const Color(0xFF186356),
      'theme_royal_gold' =>
        dark ? const Color(0xFFF4D38A) : const Color(0xFF785400),
      'theme_neon_cyberpunk' =>
        dark ? const Color(0xFFFFA2DC) : const Color(0xFF9E246A),
      _ => dark ? const Color(0xFFE8C58E) : const Color(0xFF79531C),
    };
    final background = dark
        ? Color(tide ? 0xFF101D20 : 0xFF101619)
        : Color(tide ? 0xFFF0F6F2 : 0xFFF7F4ED);
    final surface = dark ? Color(tide ? 0xFF192C30 : 0xFF1B2428) : Colors.white;
    final foreground = dark ? const Color(0xFFF4F0E7) : const Color(0xFF202B30);
    final muted = dark ? const Color(0xFFAFBBB9) : const Color(0xFF5C6867);
    final border = dark ? const Color(0xFF374344) : const Color(0xFFDCDDD3);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: brightness,
        ).copyWith(
          primary: accent,
          onPrimary: dark ? const Color(0xFF35240C) : Colors.white,
          surface: surface,
          onSurface: foreground,
          onSurfaceVariant: muted,
          secondary: dark ? const Color(0xFFAAD0BD) : const Color(0xFF3D6C59),
          outline: border,
          outlineVariant: border,
        );
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'NotoSansKR',
      scaffoldBackgroundColor: background,
      primaryColor: accent,
    );
    return base.copyWith(
      textTheme: base.textTheme
          .apply(bodyColor: foreground, displayColor: foreground)
          .copyWith(
            headlineMedium: TextStyle(
              fontSize: 29,
              height: 1.3,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: foreground,
            ),
            titleLarge: TextStyle(
              fontSize: 21,
              height: 1.4,
              fontWeight: FontWeight.w700,
              letterSpacing: -.6,
              color: foreground,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -.3,
              color: foreground,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: foreground,
            ),
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
          color: foreground,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: accent.withValues(alpha: .14),
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'NotoSansKR',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, space: 1, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: const TextStyle(
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark
            ? const Color(0xFF273B50)
            : const Color(0xFF173B4A),
        contentTextStyle: const TextStyle(
          fontFamily: 'NotoSansKR',
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: border,
      ),
    );
  }
}
