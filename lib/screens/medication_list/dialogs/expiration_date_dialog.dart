import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

class ExpirationDateDialog {
  /// Shows a dialog to input expiration date in MM/YYYY format
  /// Returns the expiration date string if entered, null if cancelled or skipped
  static Future<String?> show(
    BuildContext context, {
    String? currentExpirationDate,
    bool isOptional = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    // Pre-fill with current date if available
    String? month;
    String? year;
    if (currentExpirationDate != null && currentExpirationDate.isNotEmpty) {
      final parts = currentExpirationDate.split('/');
      if (parts.length == 2) {
        month = parts[0];
        year = parts[1];
      }
    }

    final monthController = TextEditingController(text: month);
    final yearController = TextEditingController(text: year);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: AlertDialog(
          title: Text(l10n.expirationDateDialogTitle),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.expirationDateDialogMessage,
                  style: Theme.of(dialogContext).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Month input
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: monthController,
                        decoration: InputDecoration(
                          labelText: l10n.expirationDateLabel,
                          hintText: 'MM',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: (value) {
                          if (!isOptional && (value == null || value.isEmpty)) {
                            return l10n.expirationDateRequired;
                          }
                          if (value != null && value.isNotEmpty) {
                            final monthNum = int.tryParse(value);
                            if (monthNum == null || monthNum < 1 || monthNum > 12) {
                              return l10n.expirationDateInvalidMonth;
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Auto-focus year field when month is complete
                          if (value.length == 2) {
                            FocusScope.of(dialogContext).nextFocus();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('/', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    // Year input
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: yearController,
                        decoration: const InputDecoration(
                          hintText: 'YYYY',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (!isOptional && (value == null || value.isEmpty)) {
                            return l10n.expirationDateRequired;
                          }
                          if (value != null && value.isNotEmpty) {
                            final yearNum = int.tryParse(value);
                            if (yearNum == null || yearNum < 2000 || yearNum > 2100) {
                              return l10n.expirationDateInvalidYear;
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.expirationDateHint,
                  style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (isOptional)
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, ''),
                child: Text(l10n.btnSkip),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, null),
              child: Text(l10n.btnCancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final monthValue = monthController.text.trim();
                  final yearValue = yearController.text.trim();

                  // If both empty and optional, return empty string (skip)
                  if (monthValue.isEmpty && yearValue.isEmpty && isOptional) {
                    Navigator.pop(dialogContext, '');
                    return;
                  }

                  // If both provided, format and return
                  if (monthValue.isNotEmpty && yearValue.isNotEmpty) {
                    final formattedMonth = monthValue.padLeft(2, '0');
                    final expirationDate = '$formattedMonth/$yearValue';
                    Navigator.pop(dialogContext, expirationDate);
                  }
                }
              },
              child: Text(l10n.btnAccept),
            ),
          ],
          ),
        );
      },
    );
  }
}
