import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Utilities for handling numbers with localized decimal separators
class NumberUtils {
  /// Parses a string to double accepting both comma and period as decimal separator
  ///
  /// Examples:
  /// - "2,5" -> 2.5
  /// - "2.5" -> 2.5
  /// - "1000,25" -> 1000.25
  /// - "1.000,25" -> 1000.25 (European format with thousands separator)
  /// - "1,000.25" -> 1000.25 (American format with thousands separator)
  static double? parseLocalizedDouble(String value) {
    if (value.isEmpty) return null;

    // Remove whitespace
    String normalized = value.trim();

    // Detect the format based on the last separator
    // If there's a comma after the last period, it's European format (1.000,25)
    // If there's a period after the last comma, it's American format (1,000.25)
    int lastComma = normalized.lastIndexOf(',');
    int lastDot = normalized.lastIndexOf('.');

    if (lastComma > lastDot) {
      // European format: comma is decimal, period is thousands separator
      // 1.000,25 -> 1000.25
      normalized = normalized.replaceAll('.', ''); // Remove thousands separator
      normalized = normalized.replaceAll(',', '.'); // Replace comma with period
    } else if (lastDot > lastComma) {
      // American format: period is decimal, comma is thousands separator
      // 1,000.25 -> 1000.25
      normalized = normalized.replaceAll(',', ''); // Remove thousands separator
      // The period is already the correct decimal separator
    } else if (lastComma >= 0 && lastDot < 0) {
      // Only comma present, assume it's decimal
      // 2,5 -> 2.5
      normalized = normalized.replaceAll(',', '.');
    }
    // If only period present, it's already in the correct format

    return double.tryParse(normalized);
  }

  /// Formats a double using the current locale
  ///
  /// For Spanish: 2.5 -> "2,5"
  /// For English: 2.5 -> "2.5"
  static String formatLocalizedDouble(double value, String locale, {int? decimalDigits}) {
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return format.format(value);
  }

  /// Gets the decimal separator for the given locale
  ///
  /// Spanish: ","
  /// English: "."
  static String getDecimalSeparator(String locale) {
    final format = NumberFormat.decimalPattern(locale);
    final symbols = format.symbols;
    return symbols.DECIMAL_SEP;
  }

  /// Gets the thousands separator for the given locale
  static String getGroupSeparator(String locale) {
    final format = NumberFormat.decimalPattern(locale);
    final symbols = format.symbols;
    return symbols.GROUP_SEP;
  }

  /// Formats a double intelligently: displays integers without decimals
  /// and decimals with the minimum necessary digits
  ///
  /// Examples in Spanish:
  /// - 10.0 -> "10"
  /// - 2.5 -> "2,5"
  /// - 2.50 -> "2,5"
  /// - 2.555 -> "2,56" (rounded)
  static String formatSmart(double value, String locale, {int maxDecimals = 2}) {
    // If it's an integer, display without decimals
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    // Format with the appropriate locale
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: maxDecimals,
    );

    String formatted = format.format(value);

    // Remove unnecessary trailing zeros after decimal separator
    final separator = getDecimalSeparator(locale);
    if (formatted.contains(separator)) {
      formatted = formatted.replaceAll(RegExp('0+\$'), '');
      if (formatted.endsWith(separator)) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }

    return formatted;
  }
}

/// TextInputFormatter that allows number input with localized decimal separator
///
/// Accepts both period and comma as decimal separators for greater flexibility
class LocalizedDecimalInputFormatter extends TextInputFormatter {
  final int? decimalDigits;
  final bool allowNegative;

  LocalizedDecimalInputFormatter({
    this.decimalDigits,
    this.allowNegative = false,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty text
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Build the regex pattern
    String pattern = r'^\d*[.,]?\d*$';
    if (allowNegative) {
      pattern = r'^-?\d*[.,]?\d*$';
    }

    // Validate basic format (digits, one decimal separator)
    if (!RegExp(pattern).hasMatch(newValue.text)) {
      return oldValue;
    }

    // Count decimal separators
    int commaCount = ','.allMatches(newValue.text).length;
    int dotCount = '.'.allMatches(newValue.text).length;

    // Only allow one decimal separator
    if (commaCount + dotCount > 1) {
      return oldValue;
    }

    // If there's a decimal limit, validate it
    if (decimalDigits != null) {
      int separatorIndex = newValue.text.lastIndexOf(RegExp('[.,]'));
      if (separatorIndex >= 0) {
        String decimals = newValue.text.substring(separatorIndex + 1);
        if (decimals.length > decimalDigits!) {
          return oldValue;
        }
      }
    }

    return newValue;
  }
}
