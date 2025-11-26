import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../../utils/number_utils.dart';

/// Widget para entrada de números con soporte de localización de separadores decimales
///
/// Acepta tanto coma (,) como punto (.) como separadores decimales
/// y formatea el valor según el locale del usuario.
///
/// Ejemplo de uso:
/// ```dart
/// LocalizedNumberField(
///   controller: _controller,
///   label: 'Cantidad',
///   allowDecimals: true,
///   minValue: 0,
///   onChanged: (value) => print('Nuevo valor: $value'),
/// )
/// ```
class LocalizedNumberField extends StatefulWidget {
  /// Controller para el campo de texto
  final TextEditingController? controller;

  /// Etiqueta del campo
  final String? label;

  /// Hint text (placeholder)
  final String? hint;

  /// Texto de ayuda debajo del campo
  final String? helperText;

  /// Validador personalizado
  /// Recibe el valor parseado (double o null) y debe retornar un mensaje de error o null
  final String? Function(double?)? validator;

  /// Callback cuando cambia el valor
  /// Recibe el valor parseado (double o null)
  final void Function(double?)? onChanged;

  /// Valor inicial
  final double? initialValue;

  /// Permitir decimales
  final bool allowDecimals;

  /// Número de dígitos decimales permitidos (null = sin límite)
  final int? decimalDigits;

  /// Permitir números negativos
  final bool allowNegative;

  /// Validación: valor mínimo permitido
  final double? minValue;

  /// Validación: valor máximo permitido
  final double? maxValue;

  /// Si es requerido
  final bool required;

  /// Decoración personalizada
  final InputDecoration? decoration;

  /// Estilo del texto
  final TextStyle? style;

  /// Auto focus
  final bool autofocus;

  /// Habilitado
  final bool enabled;

  /// Número máximo de líneas
  final int? maxLines;

  /// Acción del teclado
  final TextInputAction? textInputAction;

  /// Callback al enviar
  final void Function(String)? onFieldSubmitted;

  const LocalizedNumberField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.allowDecimals = true,
    this.decimalDigits,
    this.allowNegative = false,
    this.minValue,
    this.maxValue,
    this.required = false,
    this.decoration,
    this.style,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<LocalizedNumberField> createState() => _LocalizedNumberFieldState();
}

class _LocalizedNumberFieldState extends State<LocalizedNumberField> {
  late TextEditingController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _isInternalController = true;
      _controller = TextEditingController();
      if (widget.initialValue != null) {
        // Formatear el valor inicial según el locale
        _controller.text = _formatInitialValue(widget.initialValue!);
      }
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  String _formatInitialValue(double value) {
    // Si no permite decimales o es un entero, mostrar sin decimales
    if (!widget.allowDecimals || value == value.toInt()) {
      return value.toInt().toString();
    }

    // Formatear con locale
    final locale = Localizations.localeOf(context).toString();
    return NumberUtils.formatSmart(value, locale, maxDecimals: widget.decimalDigits ?? 2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: _controller,
      keyboardType: widget.allowDecimals
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        if (widget.allowDecimals)
          LocalizedDecimalInputFormatter(
            decimalDigits: widget.decimalDigits,
            allowNegative: widget.allowNegative,
          )
        else if (widget.allowNegative)
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: widget.decoration ??
          InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.helperText,
            border: const OutlineInputBorder(),
          ),
      style: widget.style,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: (value) {
        // Validar campo requerido
        if (widget.required && (value == null || value.trim().isEmpty)) {
          return l10n.validationRequired;
        }

        // Si está vacío y no es requerido, es válido
        if (value == null || value.trim().isEmpty) {
          return null;
        }

        // Parsear el valor
        final parsedValue = NumberUtils.parseLocalizedDouble(value);

        // Validar que se pudo parsear
        if (parsedValue == null) {
          return l10n.validationInvalidNumber;
        }

        // Validar rango mínimo
        if (widget.minValue != null && parsedValue < widget.minValue!) {
          return l10n.validationMinValue(widget.minValue!);
        }

        // Validar rango máximo
        if (widget.maxValue != null && parsedValue > widget.maxValue!) {
          // Necesitaríamos agregar esta string en l10n
          return 'El valor debe ser menor o igual a ${widget.maxValue}';
        }

        // Validador personalizado
        if (widget.validator != null) {
          return widget.validator!(parsedValue);
        }

        return null;
      },
      onChanged: (value) {
        if (widget.onChanged != null) {
          final parsedValue = NumberUtils.parseLocalizedDouble(value);
          widget.onChanged!(parsedValue);
        }
      },
    );
  }
}

/// Extension helper para obtener el valor numérico de un TextEditingController
extension LocalizedNumberController on TextEditingController {
  /// Obtiene el valor parseado como double o null si no es válido
  double? get doubleValue => NumberUtils.parseLocalizedDouble(text);

  /// Obtiene el valor parseado como int o null si no es válido
  int? get intValue => doubleValue?.toInt();

  /// Establece el valor formateado según el locale
  void setLocalizedValue(double value, String locale, {int? decimalDigits}) {
    text = NumberUtils.formatSmart(value, locale, maxDecimals: decimalDigits ?? 2);
  }
}
