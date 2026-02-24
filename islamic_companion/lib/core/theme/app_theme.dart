// ============================================================
// app_theme.dart
// Dark emerald + gold Islamic geometric minimal theme.
// All UI components consume tokens from here – never hardcode
// colors or text styles inside widgets.
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  // ── Brand Palette ─────────────────────────────────────────
  static const Color emeraldDark = Color(0xFF0D2B1E);   // Deep background
  static const Color emeraldMid = Color(0xFF1B4332);    // Card background
  static const Color emeraldLight = Color(0xFF2D6A4F);  // Elevated elements
  static const Color emeraldAccent = Color(0xFF52B788); // Secondary accent

  static const Color gold = Color(0xFFD4AF37);          // Primary gold
  static const Color goldLight = Color(0xFFF4D03F);     // Highlight gold
  static const Color goldMuted = Color(0xFF9E7C1A);     // Muted gold

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F0);
  static const Color textSecondary = Color(0xFFB8C9BC);
  static const Color textMuted = Color(0xFF6B8E77);
  static const Color textArabic = Color(0xFFD4AF37);    // Arabic text always gold

  // ── Surface ───────────────────────────────────────────────
  static const Color cardBackground = Color(0xFF1B4332);
  static const Color cardBorder = Color(0xFF2D6A4F);
  static const Color divider = Color(0xFF2D6A4F);
  static const Color shimmer = Color(0xFF243B2E);

  // ── Status ────────────────────────────────────────────────
  static const Color success = Color(0xFF52B788);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color inactive = Color(0xFF4A6B57);

  // ── Gradient definitions ──────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    colors: [emeraldDark, emeraldMid],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldMuted, gold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1B4332), Color(0xFF243B2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  // Arabic font - uses system Noto Naskh for Urdu/Arabic
  static const String arabicFont = 'serif';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static const TextStyle arabicLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textArabic,
    height: 1.8,
  );

  static const TextStyle arabicMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textArabic,
    height: 1.6,
  );

  static const TextStyle goldLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 0.8,
  );

  static const TextStyle countdownTimer = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.gold,
    letterSpacing: 2.0,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.emeraldDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.emeraldAccent,
        surface: AppColors.emeraldMid,
        error: AppColors.error,
        onPrimary: AppColors.emeraldDark,
        onSecondary: AppColors.emeraldDark,
        onSurface: AppColors.textPrimary,
      ),

      // ── AppBar ──────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.emeraldDark,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.gold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.gold),
      ),

      // ── Bottom Navigation ────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.emeraldMid,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ── Cards ────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.emeraldMid,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),

      // ── Input Decoration ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.emeraldMid,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),

      // ── Elevated Button ──────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.emeraldDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── Text Button ──────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Checkbox ─────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.gold;
          return AppColors.emeraldMid;
        }),
        checkColor: WidgetStateProperty.all(AppColors.emeraldDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.gold, width: 1.5),
      ),

      // ── Switch ───────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.gold;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.goldMuted;
          return AppColors.emeraldLight;
        }),
      ),

      // ── Divider ──────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 16,
      ),

      // ── Icon ─────────────────────────────────────────────
      iconTheme: const IconThemeData(color: AppColors.gold, size: 22),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}

// ── Reusable decoration helpers ──────────────────────────────
class AppDecorations {
  static BoxDecoration get card => BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      );

  static BoxDecoration get goldCard => BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(16),
      );

  static BoxDecoration get header => BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      );

  static BoxDecoration circleIcon({double size = 48}) => BoxDecoration(
        color: AppColors.emeraldLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
      );
}
