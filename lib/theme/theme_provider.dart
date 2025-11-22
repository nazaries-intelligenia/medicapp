import 'package:flutter/material.dart';
import 'package:medicapp/services/preferences_service.dart';
import 'package:medicapp/services/logger_service.dart';

/// Provider para gestionar el tema de la aplicación
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

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
      LoggerService.info('Theme initialized: $savedTheme');
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
}
