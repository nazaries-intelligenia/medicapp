import 'package:flutter/material.dart';

/// Paletas de colores disponibles en la aplicación
enum ColorPalette {
  /// Paleta "Sea Green" - Verde natural con tonos bosque
  seaGreen,

  /// Paleta Material 3 por defecto - Púrpura baseline de Material Design 3
  material3,

  /// Paleta "Alto Contraste" - Colores muy contrastados para personas con problemas de visión
  highContrast,
}

/// Extensión para obtener nombres localizados de las paletas
extension ColorPaletteExtension on ColorPalette {
  String get displayName {
    switch (this) {
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
      case ColorPalette.seaGreen:
        return 'Tonos verdes naturales inspirados en el bosque';
      case ColorPalette.material3:
        return 'Paleta púrpura por defecto de Material Design 3';
      case ColorPalette.highContrast:
        return 'Colores muy contrastados para mejorar la legibilidad';
    }
  }
}

/// Definición centralizada de temas de la aplicación
///
/// Paleta de colores "Sea Green" para tema claro:
/// - Primario (Marca): #2E8B57 - Verde "Sea Green" sólido
/// - Primario Variante: #3CB371 - Un poco más claro (hover/pressed)
/// - Acento/Interactivo: #00C853 - Verde vibrante para FAB y acciones
/// - Secundario/Soporte: #81C784 - Verde suave para elementos secundarios
/// - Éxito: #43A047 - Verde funcional para confirmaciones
/// - Texto Oscuro: #0D2E1C - Verde bosque muy profundo
/// - Texto Secundario: #577D6A - Subtítulos y texto de ayuda
/// - Superficie (Tarjetas): #C8E6C9 - Fondo menta suave
/// - Fondo Principal: #E8F5E9 - Casi blanco con tinte verde
/// - Divisor/Borde: #A5D6A7 - Líneas sutiles para separaciones
///
/// Paleta "Material 3" por defecto:
/// - Basada en el color seed púrpura #6750A4 de Material Design 3
/// - Genera automáticamente todos los tonos y variantes
/// - Sigue las especificaciones oficiales de Material Design 3
class AppTheme {
  // Constantes para TabBar
  static const double tabIndicatorWeight = 4.0;
  static const double tabFontSize = 14.0;
  static const double tabUnselectedOpacity = 0.5;
  static const double iconUnselectedOpacity = 0.5;
  // Colores principales - Tema claro "Sea Green"
  static const Color primaryLight = Color(0xFF2E8B57);
  static const Color primaryVariantLight = Color(0xFF3CB371);
  static const Color accentLight = Color(0xFF00C853);

  // Colores principales - Tema oscuro "Dark Forest"
  static const Color primaryDark = Color(0xFFA5D6A7);
  static const Color accentDark = Color(0xFF4CAF50);

  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF819CA9);

  // Colores de fondo
  static const Color backgroundLight = Color(0xFFE8F5E9);
  static const Color backgroundDark = Color(0xFF050A06);

  static const Color surfaceLight = Color(0xFFC8E6C9);
  static const Color surfaceDark = Color(0xFF0D1F14);

  // Colores de tarjetas
  static const Color cardLight = Color(0xFFC8E6C9);
  static const Color cardDark = Color(0xFF142B1E);

  // Colores de texto
  static const Color textPrimaryLight = Color(0xFF0D2E1C);
  static const Color textPrimaryDark = Color(0xFFE8F5E9);

  static const Color textSecondaryLight = Color(0xFF577D6A);
  static const Color textSecondaryDark = Color(0xFF819CA9);

  // Iconos inactivos
  static const Color inactiveIconLight = Color(0xFF577D6A);
  static const Color inactiveIconDark = Color(0xFF455A64);

  // Overlay y selección
  static const Color overlayLight = Color(0xFFE8F5E9);
  static const Color overlayDark = Color(0xFF1E3B28);

  // Resplandor/Glow
  static const Color glowDark = Color(0xFF004D40);

  // Colores de divisores y bordes
  static const Color dividerLight = Color(0xFFA5D6A7);
  static const Color dividerDark = Color(0xFF455A64);

  // Colores de estado
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Color seed de Material 3 (púrpura baseline)
  static const Color material3SeedColor = Color(0xFF6750A4);

  // ============================================================
  // Colores Alto Contraste - Tema Claro
  // ============================================================
  // Diseñado para máxima legibilidad con ratio de contraste WCAG AAA (7:1+)

  /// Primario: Azul oscuro puro - máximo contraste sobre blanco
  static const Color highContrastPrimaryLight = Color(0xFF0000CC);

  /// Primario variante: Azul más oscuro para estados hover/pressed
  static const Color highContrastPrimaryVariantLight = Color(0xFF000099);

  /// Acento: Naranja oscuro vibrante - visible y distinguible
  static const Color highContrastAccentLight = Color(0xFFCC5500);

  /// Secundario: Verde oscuro para elementos secundarios
  static const Color highContrastSecondaryLight = Color(0xFF006600);

  /// Fondo: Blanco puro
  static const Color highContrastBackgroundLight = Color(0xFFFFFFFF);

  /// Superficie: Blanco puro para tarjetas
  static const Color highContrastSurfaceLight = Color(0xFFFFFFFF);

  /// Tarjetas: Blanco con borde negro
  static const Color highContrastCardLight = Color(0xFFFFFFFF);

  /// Texto primario: Negro puro
  static const Color highContrastTextPrimaryLight = Color(0xFF000000);

  /// Texto secundario: Gris muy oscuro (aún con buen contraste)
  static const Color highContrastTextSecondaryLight = Color(0xFF333333);

  /// Divisor: Negro para máxima visibilidad
  static const Color highContrastDividerLight = Color(0xFF000000);

  // ============================================================
  // Colores Alto Contraste - Tema Oscuro
  // ============================================================
  // Diseñado para máxima legibilidad en fondo oscuro

  /// Primario: Amarillo brillante - máximo contraste sobre negro
  static const Color highContrastPrimaryDark = Color(0xFFFFFF00);

  /// Primario variante: Amarillo dorado para estados
  static const Color highContrastPrimaryVariantDark = Color(0xFFFFD700);

  /// Acento: Cian brillante - muy visible en oscuro
  static const Color highContrastAccentDark = Color(0xFF00FFFF);

  /// Secundario: Verde lima brillante
  static const Color highContrastSecondaryDark = Color(0xFF00FF00);

  /// Fondo: Negro puro
  static const Color highContrastBackgroundDark = Color(0xFF000000);

  /// Superficie: Negro puro
  static const Color highContrastSurfaceDark = Color(0xFF000000);

  /// Tarjetas: Negro con borde blanco
  static const Color highContrastCardDark = Color(0xFF000000);

  /// Texto primario: Blanco puro
  static const Color highContrastTextPrimaryDark = Color(0xFFFFFFFF);

  /// Texto secundario: Gris muy claro
  static const Color highContrastTextSecondaryDark = Color(0xFFCCCCCC);

  /// Divisor: Blanco para máxima visibilidad
  static const Color highContrastDividerDark = Color(0xFFFFFFFF);

  /// Obtiene el tema claro según la paleta seleccionada
  static ThemeData getLightTheme(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.seaGreen:
        return _buildSeaGreenLightTheme();
      case ColorPalette.material3:
        return _buildMaterial3LightTheme();
      case ColorPalette.highContrast:
        return _buildHighContrastLightTheme();
    }
  }

  /// Obtiene el tema oscuro según la paleta seleccionada
  static ThemeData getDarkTheme(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.seaGreen:
        return _buildSeaGreenDarkTheme();
      case ColorPalette.material3:
        return _buildMaterial3DarkTheme();
      case ColorPalette.highContrast:
        return _buildHighContrastDarkTheme();
    }
  }

  // Tema claro por defecto (Sea Green)
  static ThemeData get lightTheme {
    return getLightTheme(ColorPalette.seaGreen);
  }

  // Tema oscuro por defecto (Dark Forest)
  static ThemeData get darkTheme {
    return getDarkTheme(ColorPalette.seaGreen);
  }

  /// Construye el tema claro con la paleta Material 3
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

  /// Construye el tema oscuro con la paleta Material 3
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

  /// Construye el tema claro con la paleta Sea Green
  static ThemeData _buildSeaGreenLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
            return primaryLight.withOpacity(0.5);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),
    );
  }

  /// Construye el tema oscuro con la paleta Sea Green (Dark Forest)
  static ThemeData _buildSeaGreenDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.dark(
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
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
            return primaryDark.withOpacity(0.5);
          }
          return const Color(0xFF424242);
        }),
      ),
    );
  }

  /// Construye el tema claro de Alto Contraste
  /// Diseñado para personas mayores con problemas de visión
  /// Cumple con WCAG AAA (ratio de contraste 7:1 o superior)
  static ThemeData _buildHighContrastLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme - máximo contraste
      colorScheme: const ColorScheme.light(
        primary: highContrastPrimaryLight,
        secondary: highContrastSecondaryLight,
        surface: highContrastSurfaceLight,
        error: Color(0xFFCC0000), // Rojo oscuro para mejor contraste
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: highContrastTextPrimaryLight,
        onError: Colors.white,
      ),

      // Scaffolds
      scaffoldBackgroundColor: highContrastBackgroundLight,

      // AppBar - Alto contraste con fondo oscuro
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000), // Negro para máximo contraste
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22, // Ligeramente más grande
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 28, // Iconos más grandes
        ),
      ),

      // Cards - Con borde negro visible
      cardTheme: CardThemeData(
        color: highContrastCardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: highContrastDividerLight,
            width: 2, // Borde más grueso
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

      // Text theme - Tamaños más grandes y mayor peso
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

      // Input Decoration - Bordes más gruesos y visibles
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

      // Elevated Button - Más grande y visible
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
            decoration: TextDecoration.underline, // Subrayado para mejor visibilidad
          ),
        ),
      ),

      // Outlined Button - Borde más grueso
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

      // Chip - Mayor contraste
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

      // Dialog - Con bordes visibles
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

      // Divider - Más grueso y visible
      dividerTheme: const DividerThemeData(
        color: highContrastDividerLight,
        thickness: 2,
        space: 2,
      ),

      // Switch - Mayor tamaño visual
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryLight;
          }
          return const Color(0xFF666666);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return highContrastPrimaryLight.withOpacity(0.5);
          }
          return const Color(0xFFCCCCCC);
        }),
        trackOutlineColor: WidgetStateProperty.all(highContrastDividerLight),
      ),

      // Icon theme - Iconos más grandes
      iconTheme: const IconThemeData(
        color: highContrastTextPrimaryLight,
        size: 28,
      ),

      // ListTile - Mayor espaciado
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

  /// Construye el tema oscuro de Alto Contraste
  /// Diseñado para personas mayores con problemas de visión
  /// Utiliza amarillo sobre negro para máximo contraste
  static ThemeData _buildHighContrastDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme - máximo contraste en oscuro
      colorScheme: const ColorScheme.dark(
        primary: highContrastPrimaryDark,
        secondary: highContrastSecondaryDark,
        surface: highContrastSurfaceDark,
        error: Color(0xFFFF6666), // Rojo claro para modo oscuro
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

      // Cards - Con borde blanco visible
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

      // Text theme - Tamaños más grandes
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

      // Input Decoration - Bordes blancos visibles
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
            return highContrastPrimaryDark.withOpacity(0.5);
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
}
