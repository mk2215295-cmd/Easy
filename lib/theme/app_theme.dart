import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ════════════════════════════════════════════════════════════════════════════════
// AppColors — single source of truth for every colour token in the design.
// All screens must import this file; NEVER hard-code hex values elsewhere.
// ════════════════════════════════════════════════════════════════════════════════
abstract final class AppColors {
  // ── Backgrounds ─────────────────────────────────────────────────────────────
  /// Deep matte obsidian black — main scaffold background
  static const Color backgroundPrimary = Color(0xFF0D1117);

  /// Slightly lifted surface — cards, dialogs, side panels
  static const Color backgroundSurface = Color(0xFF161B22);

  /// Elevated surface — modals, dropdowns, tooltips
  static const Color backgroundElevated = Color(0xFF1C2333);

  /// Subtle border / divider on dark surfaces
  static const Color borderSubtle = Color(0xFF21262D);

  /// Interactive element background (hover state)
  static const Color backgroundHover = Color(0xFF1F2937);

  // ── Primary Accent — Electric / Neon Blue ────────────────────────────────
  /// Glowing electric blue — active nav items, primary CTA buttons, headers
  static const Color accentBlue = Color(0xFF007FFF);

  /// Lighter tint for hover / pressed states
  static const Color accentBlueLighter = Color(0xFF3399FF);

  /// Muted tint for disabled / secondary blue contexts
  static const Color accentBlueMuted = Color(0xFF1A3A5C);

  /// Glow / shadow colour for blue elements (box-shadow simulations)
  static const Color accentBlueGlow = Color(0x4D007FFF); // 30 % opacity

  // ── Secondary Accent — Vibrant Emerald Green ─────────────────────────────
  /// Match-% badges, status pills, active indicators
  static const Color accentGreen = Color(0xFF10B981);

  /// Lighter tint for hover / focus
  static const Color accentGreenLighter = Color(0xFF34D399);

  /// Muted fill for green-tinted chip backgrounds
  static const Color accentGreenMuted = Color(0xFF052E16);

  /// Glow for green elements
  static const Color accentGreenGlow = Color(0x4D10B981); // 30 % opacity

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Headlines, titles — near-white
  static const Color textPrimary = Color(0xFFF0F6FC);

  /// Body copy, labels
  static const Color textSecondary = Color(0xFF8B949E);

  /// Disabled / placeholder text
  static const Color textDisabled = Color(0xFF484F58);

  // ── Utility ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF4D4F);
  static const Color warning = Color(0xFFFFC107);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // ── Amber — ATS readiness warnings, restart CTA ───────────────────────────
  /// Warm amber for partial-completion warnings and restart actions
  static const Color accentAmber = Color(0xFFF59E0B);
}

// ════════════════════════════════════════════════════════════════════════════════
// AppTextStyles — pre-built TextStyle tokens keyed to the design system.
// Built on `Inter` (Latin UI) and `Tajawal` (Arabic / RTL).
// ════════════════════════════════════════════════════════════════════════════════
abstract final class AppTextStyles {
  // Inter — primary LTR font
  static TextStyle get _inter => GoogleFonts.inter(
        color: AppColors.textPrimary,
      ).copyWith(
        fontFamilyFallback: const ['Tajawal', 'sans-serif'],
      );

  /// Display / Hero — e.g. salary range "€2,500 – €3,000"
  static TextStyle get displayLarge => _inter.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  /// Section title / page header
  static TextStyle get headlineLarge => _inter.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );

  /// Card title / modal header
  static TextStyle get headlineMedium => _inter.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  /// Sub-section / label above form fields
  static TextStyle get titleMedium => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  /// Body copy — job descriptions, form helper text
  static TextStyle get bodyMedium => _inter.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  /// Micro labels — badges, timestamps, captions
  static TextStyle get labelSmall => _inter.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      );

  /// Navigation item (active)
  static TextStyle get navActive => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accentBlue,
      );

  /// Navigation item (inactive)
  static TextStyle get navInactive => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  /// Primary button label
  static TextStyle get buttonPrimary => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
        letterSpacing: 0.2,
      );

  /// Match-% badge
  static TextStyle get matchBadge => _inter.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );
}

// ════════════════════════════════════════════════════════════════════════════════
// AppTheme — the single exported ThemeData.
// Pass `AppTheme.dark` to `MaterialApp.theme`.
// ════════════════════════════════════════════════════════════════════════════════
abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      // ── Scaffold ──────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.backgroundPrimary,

      // ── Colour Scheme ─────────────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        // primary = electric blue
        primary: AppColors.accentBlue,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.accentBlueMuted,
        onPrimaryContainer: AppColors.accentBlueLighter,
        // secondary = emerald green
        secondary: AppColors.accentGreen,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.accentGreenMuted,
        onSecondaryContainer: AppColors.accentGreenLighter,
        // surfaces
        surface: AppColors.backgroundSurface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.backgroundElevated,
        onSurfaceVariant: AppColors.textSecondary,
        // outlines
        outline: AppColors.borderSubtle,
        outlineVariant: AppColors.backgroundHover,
        // error
        error: AppColors.error,
        onError: AppColors.white,
        // background (deprecated field kept for M2 compatibility)
        // ignore: deprecated_member_use
        background: AppColors.backgroundPrimary,
        // ignore: deprecated_member_use
        onBackground: AppColors.textPrimary,
      ),

      // ── Typography ────────────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleMedium: AppTextStyles.titleMedium,
        bodyMedium: AppTextStyles.bodyMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.borderSubtle,
        titleTextStyle: AppTextStyles.headlineMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textSecondary),
        toolbarHeight: 64,
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.backgroundSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button (Primary CTA) ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.accentBlueMuted,
          disabledForegroundColor: AppColors.textDisabled,
          elevation: 0,
          shadowColor: AppColors.accentBlueGlow,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonPrimary,
        ),
      ),

      // ── Outlined Button (Secondary CTA) ──────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          side: const BorderSide(color: AppColors.accentBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            color: AppColors.accentBlue,
          ),
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          textStyle: AppTextStyles.buttonPrimary.copyWith(
            color: AppColors.accentBlue,
          ),
        ),
      ),

      // ── Input / Form Fields ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
        labelStyle: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTextStyles.titleMedium.copyWith(
          color: AppColors.accentBlue,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.accentBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),

      // ── Chip ──────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundElevated,
        disabledColor: AppColors.backgroundHover,
        selectedColor: AppColors.accentBlueMuted,
        secondarySelectedColor: AppColors.accentGreenMuted,
        labelStyle: AppTextStyles.labelSmall,
        secondaryLabelStyle: AppTextStyles.labelSmall,
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── Tooltip ───────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        textStyle: AppTextStyles.bodyMedium,
      ),

      // ── Scrollbar ─────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.borderSubtle),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(4),
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundElevated,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        titleTextStyle: AppTextStyles.headlineMedium,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // ── Progress Indicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accentBlue,
        linearTrackColor: AppColors.backgroundElevated,
        circularTrackColor: AppColors.backgroundElevated,
      ),

      // ── Drawer ────────────────────────────────────────────────────────────
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.backgroundSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
      ),

      // ── ListTile ──────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: AppColors.transparent,
        selectedTileColor: AppColors.accentBlueMuted,
        selectedColor: AppColors.accentBlue,
        textColor: AppColors.textSecondary,
        iconColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),

      // ── Icon ──────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 20,
      ),

      // ── Tab Bar ───────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.accentBlue,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.accentBlue,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTextStyles.navActive,
        unselectedLabelStyle: AppTextStyles.navInactive,
        dividerColor: AppColors.borderSubtle,
      ),

      // ── Data Table ────────────────────────────────────────────────────────
      dataTableTheme: DataTableThemeData(
        headingTextStyle: AppTextStyles.titleMedium,
        dataTextStyle: AppTextStyles.bodyMedium,
        headingRowColor: WidgetStateProperty.all(AppColors.backgroundElevated),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.backgroundHover;
          }
          return AppColors.transparent;
        }),
        dividerThickness: 1,
        decoration: const BoxDecoration(color: AppColors.backgroundSurface),
        columnSpacing: 24,
        horizontalMargin: 16,
        headingRowHeight: 48,
        dataRowMinHeight: 44,
        dataRowMaxHeight: 56,
      ),
    );
  }
}
