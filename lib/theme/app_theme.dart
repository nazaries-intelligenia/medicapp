import 'package:flutter/material.dart';

/// Color palettes available in the application
enum ColorPalette {
  /// "Deep Emerald" palette - High contrast accessible green (DEFAULT)
  /// Designed for elderly users (Silver Surfers) with maximum legibility
  deepEmerald,

  /// "Sea Green" palette - Natural green with forest tones
  seaGreen,

  /// Default Material 3 palette - Material Design 3 baseline purple
  material3,

  /// "High Contrast" palette - Highly contrasted colors for people with vision problems
  highContrast,
}

/// Extension to get localized names of the palettes
extension ColorPaletteExtension on ColorPalette {
  String get displayName {
    switch (this) {
      case ColorPalette.deepEmerald:
        return 'Deep Emerald';
      case ColorPalette.seaGreen:
        return 'Sea Green';
      case ColorPalette.material3:
        return 'Material 3';
      case ColorPalette.highContrast:
        return 'Alto Contraste';
    }
  }

  String get description {
    switch (this) {
      case ColorPalette.deepEmerald:
        return 'Accessible high contrast green for maximum legibility';
      case ColorPalette.seaGreen:
        return 'Natural green tones inspired by the forest';
      case ColorPalette.material3:
        return 'Default purple palette from Material Design 3';
      case ColorPalette.highContrast:
        return 'Highly contrasted colors to improve readability';
    }
  }
}

/// Centralized definition of application themes
///
/// "Sea Green" color palette for light theme:
/// - Primary (Brand): #2E8B57 - Solid "Sea Green"
/// - Primary Variant: #3CB371 - Slightly lighter (hover/pressed)
/// - Accent/Interactive: #00C853 - Vibrant green for FAB and actions
/// - Secondary/Support: #81C784 - Soft green for secondary elements
/// - Success: #43A047 - Functional green for confirmations
/// - Dark Text: #0D2E1C - Very deep forest green
/// - Secondary Text: #577D6A - Subtitles and help text
/// - Surface (Cards): #C8E6C9 - Soft mint background
/// - Main Background: #E8F5E9 - Almost white with green tint
/// - Divider/Border: #A5D6A7 - Subtle lines for separations
///
/// Default "Material 3" palette:
/// - Based on Material Design 3 purple seed color #6750A4
/// - Automatically generates all tones and variants
/// - Follows official Material Design 3 specifications
class AppTheme {
  // Constants for TabBar
  static const double tabIndicatorWeight = 4.0;
  static const double tabFontSize = 14.0;
  static const double tabUnselectedOpacity = 0.5;
  static const double iconUnselectedOpacity = 0.5;
  // Main colors - "Sea Green" light theme
  static const Color primaryLight = Color(0xFF2E8B57);
  static const Color primaryVariantLight = Color(0xFF3CB371);
  static const Color accentLight = Color(0xFF00C853);

  // Main colors - "Dark Forest" dark theme
  static const Color primaryDark = Color(0xFFA5D6A7);
  static const Color accentDark = Color(0xFF4CAF50);

  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF819CA9);

  // Background colors
  static const Color backgroundLight = Color(0xFFE8F5E9);
  static const Color backgroundDark = Color(0xFF050A06);

  static const Color surfaceLight = Color(0xFFC8E6C9);
  static const Color surfaceDark = Color(0xFF0D1F14);

  // Card colors
  static const Color cardLight = Color(0xFFC8E6C9);
  static const Color cardDark = Color(0xFF142B1E);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF0D2E1C);
  static const Color textPrimaryDark = Color(0xFFE8F5E9);

  static const Color textSecondaryLight = Color(0xFF577D6A);
  static const Color textSecondaryDark = Color(0xFF819CA9);

  // Inactive icons
  static const Color inactiveIconLight = Color(0xFF577D6A);
  static const Color inactiveIconDark = Color(0xFF455A64);

  // Overlay and selection
  static const Color overlayLight = Color(0xFFE8F5E9);
  static const Color overlayDark = Color(0xFF1E3B28);

  // Glow
  static const Color glowDark = Color(0xFF004D40);

  // Divider and border colors
  static const Color dividerLight = Color(0xFFA5D6A7);
  static const Color dividerDark = Color(0xFF455A64);

  // Status colors
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Material 3 seed color (baseline purple)
  static const Color material3SeedColor = Color(0xFF6750A4);

  // ============================================================
  // High Contrast Colors - Light Theme
  // ============================================================
  // Designed for maximum readability with WCAG AAA contrast ratio (7:1+)

  /// Primary: Pure dark blue - maximum contrast on white
  static const Color highContrastPrimaryLight = Color(0xFF0000CC);

  /// Primary variant: Darker blue for hover/pressed states
  static const Color highContrastPrimaryVariantLight = Color(0xFF000099);

  /// Accent: Vibrant dark orange - visible and distinguishable
  static const Color highContrastAccentLight = Color(0xFFCC5500);

  /// Secondary: Dark green for secondary elements
  static const Color highContrastSecondaryLight = Color(0xFF006600);

  /// Background: Pure white
  static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);

  /// Surface: Pure white for cards
  static const Color highContrastSurfaceLight = Color(0xFFFFFFFF);

  /// Cards: White with black border
  static const Color highContrastCardLight = Color(0xFFFFFFFF);

  /// Primary text: Pure black
  static const Color highContrastTextPrimaryLight = Color(0xFF000000);

  /// Secondary text: Very dark gray (still with good contrast)
  static const Color highContrastTextSecondaryLight = Color(0xFF333333);

  /// Divider: Black for maximum visibility
  static const Color highContrastDividerLight = Color(0xFF000000);

  // ============================================================
  // High Contrast Colors - Dark Theme
  // ============================================================
  // Designed for maximum readability on dark background

  /// Primary: Bright yellow - maximum contrast on black
  static const Color highContrastPrimaryDark = Color(0xFFFFFF00);

  /// Primary variant: Golden yellow for states
  static const Color highContrastPrimaryVariantDark = Color(0xFFFFD700);

  /// Accent: Bright cyan - very visible on dark
  static const Color highContrastAccentDark = Color(0xFF00FFFF);

  /// Secondary: Bright lime green
  static const Color highContrastSecondaryDark = Color(0xFF00FF00);

  /// Background: Pure black
  static const Color highContrastBackgroundDark = Color(0xFF000000);

  /// Surface: Pure black
  static const Color highContrastSurfaceDark = Color(0xFF000000);

  /// Cards: Black with white border
  static const Color highContrastCardDark = Color(0xFF000000);

  /// Primary text: Pure white
  static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);

  /// Secondary text: Very light gray
  static const Color highContrastTextSecondaryDark = Color(0xFFCCCCCC);

  /// Divider: White for maximum visibility
  static const Color highContrastDividerDark = Color(0xFFFFFFFF);

  // ============================================================
  // Deep Emerald Colors - Light Theme (Default for Silver Surfers)
  // ============================================================
  // Designed for maximum readability with WCAG AAA contrast ratio (19:1+)
  // Maintains brand green identity while maximizing legibility

  /// Primary: Deep emerald green - high contrast on white
  static const Color deepEmeraldPrimaryLight = Color(0xFF1B5E20);

  /// Primary variant: Slightly lighter for focus/selected states
  static const Color deepEmeraldPrimaryVariantLight = Color(0xFF2E7D32);

  /// Accent: Vibrant but solid green for FAB (not neon)
  static const Color deepEmeraldAccentLight = Color(0xFF00701A);

  /// Secondary: Dark green for secondary elements
  static const Color deepEmeraldSecondaryLight = Color(0xFF2E7D32);

  /// Background: Very light neutral gray (no green tint)
  static const Color deepEmeraldBackgroundLight = Color(0xFFF5F5F5);

  /// Surface: Pure white for cards (best for text readability)
  static const Color deepEmeraldSurfaceLight = Color(0xFFFFFFFF);

  /// Cards: Pure white with border
  static const Color deepEmeraldCardLight = Color(0xFFFFFFFF);

  /// Primary text: Almost black with imperceptible green touch (19:1 ratio)
  static const Color deepEmeraldTextPrimaryLight = Color(0xFF051F12);

  /// Secondary text: Dark blue-gray (readable for cataracts)
  static const Color deepEmeraldTextSecondaryLight = Color(0xFF37474F);

  /// Divider: Strong gray for clear separations
  static const Color deepEmeraldDividerLight = Color(0xFFBDBDBD);

  /// Border for elements: Primary color for touch zones
  static const Color deepEmeraldBorderLight = Color(0xFF1B5E20);

  /// Card border: Subtle gray for card definition
  static const Color deepEmeraldCardBorderLight = Color(0xFFE0E0E0);

  // Deep Emerald State Colors (Functional - darker for visibility)
  /// Success: Darker green for crisp check icons
  static const Color deepEmeraldSuccess = Color(0xFF1E7E34);

  /// Warning: Burnt orange (high visibility)
  static const Color deepEmeraldWarning = Color(0xFFE65100);

  /// Error: Deep serious red (avoids looking pink)
  static const Color deepEmeraldError = Color(0xFFC62828);

  /// Info: Strong blue (avoids light cyan that fades)
  static const Color deepEmeraldInfo = Color(0xFF0277BD);

  // ============================================================
  // Deep Emerald Colors - Dark Theme "Night Forest" (Accessible)
  // ============================================================
  // Designed for elderly users (Silver Surfers) with maximum legibility
  // Avoids pure black (#000000) to reduce eye strain
  // Uses illuminated borders to define spaces instead of shadows

  /// Primary (Brand): Light leaf green - luminous and easy to see
  /// Used for primary buttons and active states
  static const Color deepEmeraldPrimaryDark = Color(0xFF81C784);

  /// Primary variant: Slightly more saturated for focus/selected states
  static const Color deepEmeraldPrimaryVariantDark = Color(0xFF66BB6A);

  /// Accent/Interactive: For FABs and activated toggles
  static const Color deepEmeraldAccentDark = Color(0xFFA5D6A7);

  /// Text on Primary: CRUCIAL - Dark text on light buttons for legibility
  static const Color deepEmeraldOnPrimaryDark = Color(0xFF003300);

  /// Secondary: Light teal green
  static const Color deepEmeraldSecondaryDark = Color(0xFF80CBC4);

  /// Background: Standard dark gray (Material Design) - avoids OLED smearing
  static const Color deepEmeraldBackgroundDark = Color(0xFF121212);

  /// Surface (Cards): Dark greenish gray - slightly lighter with green tint
  static const Color deepEmeraldSurfaceDark = Color(0xFF1E2623);

  /// Cards: Same as surface for consistency
  static const Color deepEmeraldCardDark = Color(0xFF1E2623);

  /// Card Border: Essential for elderly - subtle gray border around cards
  static const Color deepEmeraldCardBorderDark = Color(0xFF424242);

  /// Primary text: Pearl gray (90% white) - readable but doesn't burn eyes
  static const Color deepEmeraldTextPrimaryDark = Color(0xFFE0E0E0);

  /// Secondary text: Light bluish gray - reads much better than dark gray
  static const Color deepEmeraldTextSecondaryDark = Color(0xFFB0BEC5);

  /// Divider: Higher contrast lines for separation
  static const Color deepEmeraldDividerDark = Color(0xFF555555);

  /// Focus border: Used as 1-2px stroke around active inputs
  static const Color deepEmeraldFocusBorderDark = Color(0xFF81C784);

  // Night Forest State Colors (Pastel versions for dark mode)
  // Dark colors don't show well on dark backgrounds - use pastel/desaturated versions

  /// Success: Same light green as primary
  static const Color deepEmeraldSuccessDark = Color(0xFF81C784);

  /// Warning: Light pastel orange - very visible
  static const Color deepEmeraldWarningDark = Color(0xFFFFB74D);

  /// Error: Soft pinkish red - pure red vibrates too much on dark and tires eyes
  static const Color deepEmeraldErrorDark = Color(0xFFE57373);

  /// Info: Light sky blue
  static const Color deepEmeraldInfoDark = Color(0xFF64B5F6);

  /// Gets the light theme according to the selected palette
  static ThemeData getLightTheme(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.deepEmerald:
        return _buildDeepEmeraldLightTheme();
      case ColorPalette.seaGreen:
        return _buildSeaGreenLightTheme();
      case ColorPalette.material3:
        return _buildMaterial3LightTheme();
      case ColorPalette.highContrast:
        return _buildHighContrastLightTheme();
    }
  }

  /// Gets the dark theme according to the selected palette
  static ThemeData getDarkTheme(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.deepEmerald:
        return _buildDeepEmeraldDarkTheme();
      case ColorPalette.seaGreen:
        return _buildSeaGreenDarkTheme();
      case ColorPalette.material3:
        return _buildMaterial3DarkTheme();
      case ColorPalette.highContrast:
        return _buildHighContrastDarkTheme();
    }
  }

  // Default light theme (Deep Emerald - accessible for Silver Surfers)
  static ThemeData get lightTheme {
    return getLightTheme(ColorPalette.deepEmerald);
  }

  // Default dark theme (Deep Emerald dark)
  static ThemeData get darkTheme {
    return getDarkTheme(ColorPalette.deepEmerald);
  }

  /// Builds the light theme with the Material 3 palette
  static ThemeData _buildMaterial3LightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: material3SeedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimaryContainer,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Builds the dark theme with the Material 3 palette
  static ThemeData _buildMaterial3DarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: material3SeedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Builds the light theme with the Sea Green palette
  static ThemeData _buildSeaGreenLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: secondaryLight,
        surface: surfaceLight,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
        onError: Colors.white,
      ),

      // Scaffolds
      scaffoldBackgroundColor: backgroundLight,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar (legacy)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: primaryLight,
        unselectedItemColor: textSecondaryLight,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryLight,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryLight,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        deleteIconColor: textSecondaryLight,
        labelStyle: const TextStyle(color: textPrimaryLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerLight,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLight;
          }
          return const Color(0xFFBDBDBD);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryLight.withValues(alpha: 0.5);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),

      // DropdownMenu - White background for better contrast
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: dividerLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: dividerLight),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),

      // PopupMenu - White background
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),

      // Menu - White background
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
    );
  }

  /// Builds the dark theme with the Sea Green palette (Dark Forest)
  static ThemeData _buildSeaGreenDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: secondaryDark,
        surface: surfaceDark,
        error: error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: textPrimaryDark,
        onError: Colors.white,
      ),

      // Scaffolds
      scaffoldBackgroundColor: backgroundDark,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: textPrimaryDark,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentDark,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryDark,
        unselectedItemColor: textSecondaryDark,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryDark,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryDark,
          side: const BorderSide(color: primaryDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: cardDark,
        deleteIconColor: textSecondaryDark,
        labelStyle: const TextStyle(color: textPrimaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardDark,
        contentTextStyle: const TextStyle(color: textPrimaryDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: dividerDark,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryDark;
          }
          return const Color(0xFF757575);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryDark.withValues(alpha: 0.5);
          }
          return const Color(0xFF424242);
        }),
      ),
    );
  }

  /// Builds the High Contrast light theme
  /// Designed for elderly people with vision problems
  /// Meets WCAG AAA (contrast ratio 7:1 or higher)
  static ThemeData _buildHighContrastLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme - maximum contrast
      colorScheme: const ColorScheme.light(
        primary: highContrastPrimaryLight,
        secondary: highContrastSecondaryLight,
        surface: highContrastSurfaceLight,
        error: Color(0xFFCC0000), // Dark red for better contrast
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: highContrastTextPrimaryLight,
        onError: Colors.white,
      ),

      // Scaffolds
      scaffoldBackgroundColor: highContrastBackgroundLight,

      // AppBar - High contrast with dark background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000), // Black for maximum contrast
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22, // Slightly larger
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 28, // Larger icons
        ),
      ),

      // Cards - With visible black border
      cardTheme: CardThemeData(
        color: highContrastCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: highContrastDividerLight,
            width: 2, // Thicker border
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: highContrastPrimaryLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: highContrastPrimaryLight,
        unselectedItemColor: highContrastTextSecondaryLight,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme - Larger sizes and greater weight
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: highContrastTextPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: highContrastTextSecondaryLight,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryLight,
        ),
      ),

      // Input Decoration - Thicker and more visible borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: highContrastSurfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastDividerLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastDividerLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastPrimaryLight, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCC0000), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryLight,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: highContrastTextSecondaryLight,
        ),
      ),

      // Elevated Button - Larger and more visible
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highContrastPrimaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: highContrastPrimaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline, // Underlined for better visibility
          ),
        ),
      ),

      // Outlined Button - Thicker border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: highContrastPrimaryLight,
          side: const BorderSide(color: highContrastPrimaryLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Chip - Greater contrast
      chipTheme: ChipThemeData(
        backgroundColor: highContrastSurfaceLight,
        deleteIconColor: highContrastTextPrimaryLight,
        labelStyle: const TextStyle(
          color: highContrastTextPrimaryLight,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: highContrastDividerLight, width: 2),
        ),
      ),

      // Dialog - With visible borders
      dialogTheme: DialogThemeData(
        backgroundColor: highContrastSurfaceLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: highContrastDividerLight, width: 2),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF000000),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider - Thicker and more visible
      dividerTheme: const DividerThemeData(
        color: highContrastDividerLight,
        thickness: 2,
        space: 2,
      ),

      // Switch - Larger visual size
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryLight;
          }
          return const Color(0xFF666666);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryLight.withValues(alpha: 0.5);
          }
          return const Color(0xFFCCCCCC);
        }),
        trackOutlineColor: WidgetStateProperty.all(highContrastDividerLight),
      ),

      // Icon theme - Larger icons
      iconTheme: const IconThemeData(
        color: highContrastTextPrimaryLight,
        size: 28,
      ),

      // ListTile - Greater spacing
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        minVerticalPadding: 12,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryLight,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 16,
          color: highContrastTextSecondaryLight,
        ),
      ),
    );
  }

  /// Builds the High Contrast dark theme
  /// Designed for elderly people with vision problems
  /// Uses yellow on black for maximum contrast
  static ThemeData _buildHighContrastDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme - maximum contrast in dark
      colorScheme: const ColorScheme.dark(
        primary: highContrastPrimaryDark,
        secondary: highContrastSecondaryDark,
        surface: highContrastSurfaceDark,
        error: Color(0xFFFF6666), // Light red for dark mode
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: highContrastTextPrimaryDark,
        onError: Colors.black,
      ),

      // Scaffolds
      scaffoldBackgroundColor: highContrastBackgroundDark,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000),
        foregroundColor: highContrastPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: highContrastPrimaryDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: highContrastPrimaryDark,
          size: 28,
        ),
      ),

      // Cards - With visible white border
      cardTheme: CardThemeData(
        color: highContrastCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: highContrastDividerDark,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: highContrastPrimaryDark,
        foregroundColor: Colors.black,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: highContrastPrimaryDark,
        unselectedItemColor: highContrastTextSecondaryDark,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme - Larger sizes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: highContrastTextPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: highContrastTextSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: highContrastTextPrimaryDark,
        ),
      ),

      // Input Decoration - Visible white borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: highContrastCardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastDividerDark, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastDividerDark, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: highContrastPrimaryDark, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFF6666), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryDark,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: highContrastTextSecondaryDark,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highContrastPrimaryDark,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: highContrastPrimaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: highContrastPrimaryDark,
          side: const BorderSide(color: highContrastPrimaryDark, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: highContrastCardDark,
        deleteIconColor: highContrastTextPrimaryDark,
        labelStyle: const TextStyle(
          color: highContrastTextPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: highContrastDividerDark, width: 2),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: highContrastCardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: highContrastDividerDark, width: 2),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: highContrastCardDark,
        contentTextStyle: const TextStyle(
          color: highContrastTextPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: highContrastDividerDark, width: 1),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: highContrastDividerDark,
        thickness: 2,
        space: 2,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryDark;
          }
          return const Color(0xFF999999);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryDark.withValues(alpha: 0.5);
          }
          return const Color(0xFF333333);
        }),
        trackOutlineColor: WidgetStateProperty.all(highContrastDividerDark),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: highContrastTextPrimaryDark,
        size: 28,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        minVerticalPadding: 12,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: highContrastTextPrimaryDark,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 16,
          color: highContrastTextSecondaryDark,
        ),
      ),
    );
  }

  /// Builds the Deep Emerald light theme
  /// Designed for elderly people (Silver Surfers) with maximum legibility
  /// Maintains green brand identity while maximizing contrast (WCAG AAA)
  static ThemeData _buildDeepEmeraldLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme - high contrast with green identity
      colorScheme: const ColorScheme.light(
        primary: deepEmeraldPrimaryLight,
        secondary: deepEmeraldSecondaryLight,
        surface: deepEmeraldSurfaceLight,
        error: deepEmeraldError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: deepEmeraldTextPrimaryLight,
        onError: Colors.white,
      ),

      // Scaffolds - neutral gray background
      scaffoldBackgroundColor: deepEmeraldBackgroundLight,

      // AppBar - Deep emerald for strong brand presence
      appBarTheme: const AppBarTheme(
        backgroundColor: deepEmeraldPrimaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 26,
        ),
      ),

      // Cards - White with subtle border for definition
      cardTheme: CardThemeData(
        color: deepEmeraldCardLight,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: deepEmeraldCardBorderLight,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button - Vibrant accent
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: deepEmeraldAccentLight,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: deepEmeraldPrimaryLight,
        unselectedItemColor: deepEmeraldTextSecondaryLight,
        selectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme - Clear and readable
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryLight,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryLight,
        ),
        displaySmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: deepEmeraldTextPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          color: deepEmeraldTextPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: deepEmeraldTextSecondaryLight,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryLight,
        ),
      ),

      // Input Decoration - Clear borders for touch zones
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldDividerLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldDividerLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldPrimaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldError, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: deepEmeraldTextSecondaryLight,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: deepEmeraldTextSecondaryLight,
        ),
      ),

      // Elevated Button - Solid and obvious
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepEmeraldPrimaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepEmeraldPrimaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button - Clear border for touch zone
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepEmeraldPrimaryLight,
          side: const BorderSide(color: deepEmeraldBorderLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        deleteIconColor: deepEmeraldTextSecondaryLight,
        labelStyle: const TextStyle(
          color: deepEmeraldTextPrimaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: deepEmeraldDividerLight),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: deepEmeraldCardBorderLight),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF323232),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider - Visible gray
      dividerTheme: const DividerThemeData(
        color: deepEmeraldDividerLight,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return deepEmeraldPrimaryLight;
          }
          return const Color(0xFFBDBDBD);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return deepEmeraldPrimaryLight.withValues(alpha: 0.5);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: deepEmeraldTextPrimaryLight,
        size: 24,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: deepEmeraldTextPrimaryLight,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: deepEmeraldTextSecondaryLight,
        ),
      ),

      // DropdownMenu - White background
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: deepEmeraldDividerLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: deepEmeraldDividerLight),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),

      // PopupMenu - White background
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),

      // Menu - White background
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
    );
  }

  /// Builds the Deep Emerald dark theme "Night Forest"
  /// Designed for elderly users (Silver Surfers) with maximum legibility
  /// Key differences from light theme:
  /// - Buttons are "lamps" (light background, dark text) instead of dark
  /// - Cards use borders instead of shadows (shadows don't work well in dark)
  /// - Uses pastel state colors that are visible on dark backgrounds
  /// - Avoids pure black to reduce eye strain on OLED screens
  static ThemeData _buildDeepEmeraldDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme - Night Forest accessible dark theme
      colorScheme: const ColorScheme.dark(
        primary: deepEmeraldPrimaryDark,
        secondary: deepEmeraldSecondaryDark,
        surface: deepEmeraldSurfaceDark,
        error: deepEmeraldErrorDark,
        onPrimary: deepEmeraldOnPrimaryDark, // Dark text on light buttons
        onSecondary: deepEmeraldOnPrimaryDark,
        onSurface: deepEmeraldTextPrimaryDark,
        onError: Colors.black,
      ),

      // Scaffolds - Standard dark gray, not pure black
      scaffoldBackgroundColor: deepEmeraldBackgroundDark,

      // AppBar - Dark greenish surface
      appBarTheme: const AppBarTheme(
        backgroundColor: deepEmeraldSurfaceDark,
        foregroundColor: deepEmeraldTextPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: deepEmeraldTextPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: deepEmeraldTextPrimaryDark,
          size: 26,
        ),
      ),

      // Cards - With visible border (essential for elderly in dark mode)
      // Shadows don't work well in dark mode, borders define the space
      cardTheme: CardThemeData(
        color: deepEmeraldCardDark,
        elevation: 0, // No shadow, use border instead
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: deepEmeraldCardBorderDark,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button - Light "lamp" button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: deepEmeraldAccentDark,
        foregroundColor: deepEmeraldOnPrimaryDark, // Dark text
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: deepEmeraldSurfaceDark,
        selectedItemColor: deepEmeraldPrimaryDark,
        unselectedItemColor: deepEmeraldTextSecondaryDark,
        selectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
        ),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Text theme - Pearl gray text (not pure white)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: deepEmeraldTextPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: deepEmeraldTextPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          color: deepEmeraldTextPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: deepEmeraldTextSecondaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: deepEmeraldTextPrimaryDark,
        ),
      ),

      // Input Decoration - With visible borders for touch zones
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: deepEmeraldCardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldCardBorderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldCardBorderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldFocusBorderDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldErrorDark, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: deepEmeraldErrorDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
          fontSize: 16,
          color: deepEmeraldTextSecondaryDark,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: deepEmeraldTextSecondaryDark,
        ),
      ),

      // Elevated Button - Light "lamp" button with dark text
      // In dark mode, buttons need to be light to stand out
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepEmeraldPrimaryDark, // Light green
          foregroundColor: deepEmeraldOnPrimaryDark, // Dark text
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepEmeraldPrimaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button - With visible border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepEmeraldPrimaryDark,
          side: const BorderSide(color: deepEmeraldPrimaryDark, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Chip - With border for definition
      chipTheme: ChipThemeData(
        backgroundColor: deepEmeraldCardDark,
        deleteIconColor: deepEmeraldTextSecondaryDark,
        labelStyle: const TextStyle(
          color: deepEmeraldTextPrimaryDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: deepEmeraldCardBorderDark),
        ),
      ),

      // Dialog - With border
      dialogTheme: DialogThemeData(
        backgroundColor: deepEmeraldCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: deepEmeraldCardBorderDark),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepEmeraldSurfaceDark,
        contentTextStyle: const TextStyle(
          color: deepEmeraldTextPrimaryDark,
          fontSize: 15,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: deepEmeraldCardBorderDark),
        ),
      ),

      // Divider - Higher contrast
      dividerTheme: const DividerThemeData(
        color: deepEmeraldDividerDark,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return deepEmeraldPrimaryDark;
          }
          return const Color(0xFF757575);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return deepEmeraldPrimaryDark.withValues(alpha: 0.5);
          }
          return const Color(0xFF424242);
        }),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: deepEmeraldTextPrimaryDark,
        size: 24,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: deepEmeraldTextPrimaryDark,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: deepEmeraldTextSecondaryDark,
        ),
      ),

      // DropdownMenu - With border
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: deepEmeraldCardDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: deepEmeraldCardBorderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: deepEmeraldCardBorderDark),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(deepEmeraldCardDark),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          side: WidgetStateProperty.all(
            const BorderSide(color: deepEmeraldCardBorderDark),
          ),
        ),
      ),

      // PopupMenu - With border
      popupMenuTheme: PopupMenuThemeData(
        color: deepEmeraldCardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: deepEmeraldCardBorderDark),
        ),
      ),

      // Menu - With border
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(deepEmeraldCardDark),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          side: WidgetStatePropertyAll(
            BorderSide(color: deepEmeraldCardBorderDark),
          ),
        ),
      ),
    );
  }
}
