import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Utilidades para manejo de números con localización de separadores decimales
class NumberUtils {
  /// Parsea un string a double aceptando tanto coma como punto como separador decimal
  ///
  /// Ejemplos:
  /// - "2,5" -> 2.5
  /// - "2.5" -> 2.5
  /// - "1000,25" -> 1000.25
  /// - "1.000,25" -> 1000.25 (formato europeo con separador de miles)
  /// - "1,000.25" -> 1000.25 (formato americano con separador de miles)
  static double? parseLocalizedDouble(String value) {
    if (value.isEmpty) return null;

    // Eliminar espacios en blanco
    String normalized = value.trim();

    // Detectar el formato basándose en el último separador
    // Si hay coma después del último punto, es formato europeo (1.000,25)
    // Si hay punto después de la última coma, es formato americano (1,000.25)
    int lastComma = normalized.lastIndexOf(',');
    int lastDot = normalized.lastIndexOf('.');

    if (lastComma > lastDot) {
      // Formato europeo: coma es decimal, punto es separador de miles
      // 1.000,25 -> 1000.25
      normalized = normalized.replaceAll('.', ''); // Eliminar separador de miles
      normalized = normalized.replaceAll(',', '.'); // Reemplazar coma por punto
    } else if (lastDot > lastComma) {
      // Formato americano: punto es decimal, coma es separador de miles
      // 1,000.25 -> 1000.25
      normalized = normalized.replaceAll(',', ''); // Eliminar separador de miles
      // El punto ya es el separador decimal correcto
    } else if (lastComma >= 0 && lastDot < 0) {
      // Solo hay coma, asumimos que es decimal
      // 2,5 -> 2.5
      normalized = normalized.replaceAll(',', '.');
    }
    // Si solo hay punto, ya está en formato correcto

    return double.tryParse(normalized);
  }

  /// Formatea un double usando el locale actual
  ///
  /// Para español: 2.5 -> "2,5"
  /// Para inglés: 2.5 -> "2.5"
  static String formatLocalizedDouble(double value, String locale, {int? decimalDigits}) {
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return format.format(value);
  }

  /// Obtiene el separador decimal para el locale dado
  ///
  /// Español: ","
  /// Inglés: "."
  static String getDecimalSeparator(String locale) {
    final format = NumberFormat.decimalPattern(locale);
    final symbols = format.symbols;
    return symbols.DECIMAL_SEP;
  }

  /// Obtiene el separador de miles para el locale dado
  static String getGroupSeparator(String locale) {
    final format = NumberFormat.decimalPattern(locale);
    final symbols = format.symbols;
    return symbols.GROUP_SEP;
  }

  /// Formatea un double de manera inteligente: muestra enteros sin decimales
  /// y decimales con el mínimo de dígitos necesarios
  ///
  /// Ejemplos en español:
  /// - 10.0 -> "10"
  /// - 2.5 -> "2,5"
  /// - 2.50 -> "2,5"
  /// - 2.555 -> "2,56" (redondeado)
  static String formatSmart(double value, String locale, {int maxDecimals = 2}) {
    // Si es un número entero, mostrar sin decimales
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    // Formatear con el locale apropiado
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: maxDecimals,
    );

    String formatted = format.format(value);

    // Eliminar ceros finales innecesarios después del separador decimal
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

/// TextInputFormatter que permite entrada de números con separador decimal localizado
///
/// Acepta tanto punto como coma como separadores decimales para mayor flexibilidad
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
    // Permitir texto vacío
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Construir el patrón regex
    String pattern = r'^\d*[.,]?\d*$';
    if (allowNegative) {
      pattern = r'^-?\d*[.,]?\d*$';
    }

    // Validar formato básico (dígitos, un separador decimal)
    if (!RegExp(pattern).hasMatch(newValue.text)) {
      return oldValue;
    }

    // Contar separadores decimales
    int commaCount = ','.allMatches(newValue.text).length;
    int dotCount = '.'.allMatches(newValue.text).length;

    // Solo permitir un separador decimal
    if (commaCount + dotCount > 1) {
      return oldValue;
    }

    // Si hay límite de decimales, validarlo
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
