import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../l10n/app_localizations.dart';
import '../utils/date_formatter.dart';
import 'preferences_service.dart';
import 'localization_service.dart';

/// Provider for managing the app locale with persistence.
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  bool _initialized = false;

  /// Current locale. Null means use system locale.
  Locale? get locale => _locale;

  /// Whether the provider has been initialized
  bool get initialized => _initialized;

  /// List of supported locales with their native names
  static const Map<String, String> supportedLanguages = {
    'ca': 'Català',
    'de': 'Deutsch',
    'en': 'English',
    'es': 'Español',
    'eu': 'Euskara',
    'fr': 'Français',
    'gl': 'Galego',
    'it': 'Italiano',
  };

  /// Initialize the provider by loading saved preference
  Future<void> initialize() async {
    // Initialize date formatting for all supported locales
    await _initializeDateFormatting();

    final savedLanguage = await PreferencesService.getLanguage();
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      // Update LocalizationService for background services
      await LocalizationService.instance.setLocale(_locale!);
      // Update DateFormatter with the locale
      DateFormatter.setLocale(_locale!);
    }
    _initialized = true;
    notifyListeners();
  }

  /// Initialize date formatting for all supported locales
  Future<void> _initializeDateFormatting() async {
    for (final localeCode in supportedLanguages.keys) {
      await initializeDateFormatting(localeCode, null);
    }
  }

  /// Set the locale and persist the preference
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    await PreferencesService.setLanguage(locale?.languageCode);

    // Update LocalizationService for background services
    if (locale != null) {
      await LocalizationService.instance.setLocale(locale);
      // Update DateFormatter with the locale
      DateFormatter.setLocale(locale);
    }

    notifyListeners();
  }

  /// Resolve the locale to use based on preference and system locale
  Locale resolveLocale(Locale? deviceLocale) {
    // If user has set a preference, use it
    if (_locale != null) {
      return _locale!;
    }

    // Otherwise, try to use device locale if supported
    if (deviceLocale != null) {
      for (final supportedLocale in AppLocalizations.supportedLocales) {
        if (supportedLocale.languageCode == deviceLocale.languageCode) {
          return supportedLocale;
        }
      }
    }

    // Fallback to English
    return const Locale('en');
  }
}
