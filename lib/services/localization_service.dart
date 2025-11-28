import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

/// Service providing localization support without needing a BuildContext.
/// This is useful for services that run in the background (notifications, etc.)
///
/// Usage:
/// 1. Initialize in main.dart: LocalizationService.instance.setLocale(locale);
/// 2. Use anywhere: LocalizationService.instance.l10n.someString
class LocalizationService {
  LocalizationService._();

  static final LocalizationService instance = LocalizationService._();

  AppLocalizations? _l10n;
  Locale _locale = const Locale('en');

  /// Get the current AppLocalizations instance.
  /// Falls back to English if not initialized.
  AppLocalizations get l10n {
    if (_l10n == null) {
      _initializeDefault();
    }
    return _l10n!;
  }

  /// Get the current locale
  Locale get locale => _locale;

  /// Set the locale and update localization strings.
  /// Call this when the app locale changes.
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    _l10n = await AppLocalizations.delegate.load(locale);
  }

  /// Initialize with the default locale (English)
  void _initializeDefault() {
    // Use synchronous initialization for the default case
    _l10n = lookupAppLocalizations(_locale);
  }

  /// Update from a BuildContext (useful for initial setup)
  void updateFromContext(BuildContext context) {
    final newL10n = AppLocalizations.of(context);
    if (newL10n != null) {
      _l10n = newL10n;
      _locale = Localizations.localeOf(context);
    }
  }
}
