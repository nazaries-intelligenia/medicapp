import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/locale_provider.dart';

/// Centralized date and time formatting utilities that respect the current locale.
///
/// Use this class for all user-facing date/time formatting to ensure consistency
/// and proper localization across the app.
class DateFormatter {
  DateFormatter._();

  /// Get the current locale string (e.g., 'en', 'es', 'de')
  static String _getLocale() {
    return LocaleProvider.supportedLanguages.keys
        .contains(_currentLocale?.languageCode)
        ? _currentLocale!.languageCode
        : 'en';
  }

  static Locale? _currentLocale;

  /// Update the current locale. Called when the app locale changes.
  static void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  /// Format time as HH:mm (e.g., "14:30" or "2:30 PM" depending on locale)
  /// For 24-hour format regardless of locale, use [formatTime24].
  static String formatTime(TimeOfDay time, {BuildContext? context}) {
    if (context != null) {
      return time.format(context);
    }
    // Fallback to 24-hour format if no context
    return formatTime24(time);
  }

  /// Format time as HH:mm in 24-hour format (e.g., "14:30")
  static String formatTime24(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Format DateTime time portion as HH:mm (e.g., "14:30")
  static String formatDateTime24(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format date according to locale (e.g., "15/03/2025" or "03/15/2025")
  static String formatDate(DateTime date) {
    final locale = _getLocale();
    return DateFormat.yMd(locale).format(date);
  }

  /// Format date as dd/MM/yyyy (European format, locale-independent)
  static String formatDateEuropean(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format date as short date without year (e.g., "15/03" or "Mar 15")
  static String formatDateShort(DateTime date) {
    final locale = _getLocale();
    return DateFormat.Md(locale).format(date);
  }

  /// Format date as day and month with time (e.g., "15/03 14:30")
  static String formatDateTimeShort(DateTime date) {
    return '${formatDateShort(date)} ${formatDateTime24(date)}';
  }

  /// Format date with full month name (e.g., "15 marzo 2025" or "March 15, 2025")
  static String formatDateLong(DateTime date) {
    final locale = _getLocale();
    return DateFormat.yMMMMd(locale).format(date);
  }

  /// Format date with abbreviated month (e.g., "15 mar 2025" or "Mar 15, 2025")
  static String formatDateMedium(DateTime date) {
    final locale = _getLocale();
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Format day name (e.g., "lunes" or "Monday")
  static String formatDayName(DateTime date) {
    final locale = _getLocale();
    return DateFormat.EEEE(locale).format(date);
  }

  /// Format abbreviated day name (e.g., "lun" or "Mon")
  static String formatDayNameShort(DateTime date) {
    final locale = _getLocale();
    return DateFormat.E(locale).format(date);
  }

  /// Format month name (e.g., "marzo" or "March")
  static String formatMonthName(DateTime date) {
    final locale = _getLocale();
    return DateFormat.MMMM(locale).format(date);
  }

  /// Format abbreviated month name (e.g., "mar" or "Mar")
  static String formatMonthNameShort(DateTime date) {
    final locale = _getLocale();
    return DateFormat.MMM(locale).format(date);
  }

  /// Format date for internal storage (yyyy-MM-dd)
  static String formatDateForStorage(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Format duration in hours and minutes (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Format countdown timer (e.g., "01:30:45" for hours:minutes:seconds)
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '0:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
