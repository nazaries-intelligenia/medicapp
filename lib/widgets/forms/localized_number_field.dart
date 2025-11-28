import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../../utils/number_utils.dart';

/// Widget for number input with localized decimal separator support
///
/// Accepts both comma (,) and period (.) as decimal separators
/// and formats the value according to the user's locale.
///
/// Usage example:
/// ```dart
/// LocalizedNumberField(
///   controller: _controller,
///   label: 'Amount',
///   allowDecimals: true,
///   minValue: 0,
///   onChanged: (value) => print('New value: $value'),
/// )
/// ```
class LocalizedNumberField extends StatefulWidget {
  /// Controller for the text field
  final TextEditingController? controller;

  /// Field label
  final String? label;

  /// Hint text (placeholder)
  final String? hint;

  /// Helper text below the field
  final String? helperText;

  /// Custom validator
  /// Receives the parsed value (double or null) and should return an error message or null
  final String? Function(double?)? validator;

  /// Callback when value changes
  /// Receives the parsed value (double or null)
  final void Function(double?)? onChanged;

  /// Initial value
  final double? initialValue;

  /// Allow decimals
  final bool allowDecimals;

  /// Number of allowed decimal digits (null = no limit)
  final int? decimalDigits;

  /// Allow negative numbers
  final bool allowNegative;

  /// Validation: minimum allowed value
  final double? minValue;

  /// Validation: maximum allowed value
  final double? maxValue;

  /// Whether it is required
  final bool required;

  /// Custom decoration
  final InputDecoration? decoration;

  /// Text style
  final TextStyle? style;

  /// Auto focus
  final bool autofocus;

  /// Enabled
  final bool enabled;

  /// Maximum number of lines
  final int? maxLines;

  /// Keyboard action
  final TextInputAction? textInputAction;

  /// Callback on submit
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
        // Format the initial value according to the locale
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
    // If decimals are not allowed or it's an integer, display without decimals
    if (!widget.allowDecimals || value == value.toInt()) {
      return value.toInt().toString();
    }

    // Format with locale
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
        // Validate required field
        if (widget.required && (value == null || value.trim().isEmpty)) {
          return l10n.validationRequired;
        }

        // If empty and not required, it's valid
        if (value == null || value.trim().isEmpty) {
          return null;
        }

        // Parse the value
        final parsedValue = NumberUtils.parseLocalizedDouble(value);

        // Validate that it could be parsed
        if (parsedValue == null) {
          return l10n.validationInvalidNumber;
        }

        // Validate minimum range
        if (widget.minValue != null && parsedValue < widget.minValue!) {
          return l10n.validationMinValue(widget.minValue!);
        }

        // Validate maximum range
        if (widget.maxValue != null && parsedValue > widget.maxValue!) {
          // We would need to add this string in l10n
          return 'The value must be less than or equal to ${widget.maxValue}';
        }

        // Custom validator
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

/// Extension helper to get the numeric value from a TextEditingController
extension LocalizedNumberController on TextEditingController {
  /// Gets the parsed value as double or null if invalid
  double? get doubleValue => NumberUtils.parseLocalizedDouble(text);

  /// Gets the parsed value as int or null if invalid
  int? get intValue => doubleValue?.toInt();

  /// Sets the value formatted according to the locale
  void setLocalizedValue(double value, String locale, {int? decimalDigits}) {
    text = NumberUtils.formatSmart(value, locale, maxDecimals: decimalDigits ?? 2);
  }
}
