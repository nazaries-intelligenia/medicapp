import 'package:flutter/material.dart';
import 'package:medicapp/services/preferences_service.dart';
import 'package:medicapp/services/logger_service.dart';
import 'package:medicapp/theme/app_theme.dart';

/// Provider para gestionar el tema de la aplicación
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ColorPalette _colorPalette = ColorPalette.seaGreen;

  ThemeMode get themeMode => _themeMode;
  ColorPalette get colorPalette => _colorPalette;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // En modo sistema, detectamos el brillo del sistema
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Inicializa el tema desde las preferencias guardadas
  Future<void> initialize() async {
    try {
      final savedTheme = await PreferencesService.getThemeMode();
      _themeMode = _themeModeFromString(savedTheme);

      final savedPalette = await PreferencesService.getColorPalette();
      _colorPalette = _colorPaletteFromString(savedPalette);

      LoggerService.info('Theme initialized: $savedTheme, Palette: $savedPalette');
      notifyListeners();
    } catch (e) {
      LoggerService.error('Error initializing theme: $e');
    }
  }

  /// Cambia el modo del tema
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      await PreferencesService.setThemeMode(_themeModeToString(mode));
      LoggerService.info('Theme changed to: ${_themeModeToString(mode)}');
      notifyListeners();
    } catch (e) {
      LoggerService.error('Error setting theme mode: $e');
    }
  }

  /// Alterna entre tema claro y oscuro (ignorando sistema)
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Cambia la paleta de colores
  Future<void> setColorPalette(ColorPalette palette) async {
    try {
      _colorPalette = palette;
      await PreferencesService.setColorPalette(_colorPaletteToString(palette));
      LoggerService.info('Color palette changed to: ${_colorPaletteToString(palette)}');
      notifyListeners();
    } catch (e) {
      LoggerService.error('Error setting color palette: $e');
    }
  }

  /// Convierte string a ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convierte ThemeMode a string
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  /// Convierte string a ColorPalette
  ColorPalette _colorPaletteFromString(String value) {
    switch (value) {
      case 'seaGreen':
        return ColorPalette.seaGreen;
      case 'material3':
        return ColorPalette.material3;
      default:
        return ColorPalette.seaGreen;
    }
  }

  /// Convierte ColorPalette a string
  String _colorPaletteToString(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.seaGreen:
        return 'seaGreen';
      case ColorPalette.material3:
        return 'material3';
    }
  }
}
