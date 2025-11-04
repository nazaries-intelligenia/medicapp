import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../models/medication.dart';

/// A card widget that displays medication header information.
///
/// This widget can be used in two modes:
/// - Simple mode: Shows medication name, type, and icon (when [doseTime] is null)
/// - Detailed mode: Additionally shows scheduled time and dose quantity (when [doseTime] is provided)
///
/// Usage examples:
/// ```dart
/// // Simple mode (for edit screens)
/// MedicationHeaderCard(medication: medication)
///
/// // Detailed mode (for dose action screens)
/// MedicationHeaderCard(
///   medication: medication,
///   doseTime: '08:00',
/// )
/// ```
class MedicationHeaderCard extends StatelessWidget {
  final Medication medication;
  final String? doseTime;

  const MedicationHeaderCard({
    super.key,
    required this.medication,
    this.doseTime,
  });

  @override
  Widget build(BuildContext context) {
    // Simple mode: minimal card for edit/view screens
    if (doseTime == null) {
      return Card(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    medication.type.icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      medication.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                medication.type.displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // Detailed mode: complete card for dose action screens
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  medication.type.icon,
                  size: 48,
                  color: medication.type.getColor(context),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication.type.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: medication.type.getColor(context),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            l10n.doseActionScheduledTime(doseTime!),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dose quantity prominently displayed
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication,
                    size: 28,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.doseActionThisDoseQuantity,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${medication.getDoseQuantity(doseTime!)} ${medication.type.stockUnitSingular}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
