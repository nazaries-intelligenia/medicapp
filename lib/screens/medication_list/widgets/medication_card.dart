import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/medication.dart';
import '../../../services/snackbar_service.dart';
import '../../../utils/datetime_extensions.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final Map<String, dynamic>? nextDoseInfo;
  final String? nextDoseText;
  final Map<String, dynamic>? asNeededDoseInfo;
  final Map<String, dynamic>? fastingPeriod;
  final Widget? todayDosesWidget;
  final VoidCallback onTap;
  final List<String>? personNames; // Optional: person names for mixed view

  const MedicationCard({
    super.key,
    required this.medication,
    this.nextDoseInfo,
    this.nextDoseText,
    this.asNeededDoseInfo,
    this.fastingPeriod,
    this.todayDosesWidget,
    required this.onTap,
    this.personNames,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Determine stock status icon and color
    IconData? stockIcon;
    Color? stockColor;
    if (medication.isStockEmpty) {
      stockIcon = Icons.error;
      stockColor = Colors.red;
    } else if (medication.isStockLow) {
      stockIcon = Icons.warning;
      stockColor = Colors.orange;
    }

    return Opacity(
      opacity: (medication.isFinished || medication.isSuspended) ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: medication.type.getColor(context).withValues(alpha: 0.2),
                child: Icon(
                  medication.type.icon,
                  color: medication.type.getColor(context),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      medication.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  // Show person chips in mixed view
                  if (personNames != null && personNames!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 4,
                      children: personNames!.map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show progress bar if treatment has dates
                  if (medication.progress != null) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: medication.progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          medication.isFinished
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  // Show suspended status
                  if (medication.isSuspended) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.pause_circle_outline,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.suspended,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                  // Show status description
                  if (!medication.isSuspended && medication.statusDescription.isNotEmpty) ...[
                    Text(
                      medication.statusDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: medication.isPending
                                ? Colors.orange
                                : medication.isFinished
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    medication.type.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: medication.type.getColor(context),
                        ),
                  ),
                  Text(
                    medication.durationDisplayText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  // Show next dose info for programmed medications
                  if (nextDoseInfo != null && nextDoseText != null) ...[
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final isPending = nextDoseInfo!['isPending'] as bool? ?? false;
                        final iconColor = isPending
                            ? Colors.orange
                            : Theme.of(context).colorScheme.primary;
                        final textColor = isPending
                            ? Colors.orange.shade700
                            : Theme.of(context).colorScheme.primary;

                        return Row(
                          children: [
                            Icon(
                              isPending ? Icons.warning_amber : Icons.alarm,
                              size: 18,
                              color: iconColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                nextDoseText!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ]
                  // Show "taken today" info for "as needed" medications
                  else if (asNeededDoseInfo != null) ...[
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final count = asNeededDoseInfo!['count'] as int;
                        final totalQuantity = asNeededDoseInfo!['totalQuantity'] as double;
                        final lastDoseTime = asNeededDoseInfo!['lastDoseTime'] as DateTime;
                        final unit = asNeededDoseInfo!['unit'] as String;

                        final lastDoseTimeStr = lastDoseTime.toTimeString();
                        final quantityStr = totalQuantity % 1 == 0
                            ? totalQuantity.toInt().toString()
                            : totalQuantity.toString();

                        final l10n = AppLocalizations.of(context)!;
                        final text = count == 1
                            ? l10n.takenTodaySingle(quantityStr, unit, lastDoseTimeStr)
                            : l10n.takenTodayMultiple(count, quantityStr, unit);

                        return Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 18,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                text,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  // Show fasting countdown if available
                  if (fastingPeriod != null) ...[
                    const SizedBox(height: 4),
                    _FastingCountdownWidget(
                      fastingPeriod: fastingPeriod!,
                    ),
                  ],
                ],
              ),
              trailing: stockIcon != null
                  ? GestureDetector(
                      onTap: () {
                        // Show stock information when tapping the indicator
                        final dailyDose = medication.totalDailyDose;
                        final daysLeft = dailyDose > 0
                            ? (medication.stockQuantity / dailyDose).floor()
                            : 0;

                        final message = medication.isStockEmpty
                            ? l10n.medicationStockInfo(medication.name, medication.stockDisplayText)
                            : l10n.durationEstimate(medication.name, medication.stockDisplayText, daysLeft);

                        if (medication.isStockEmpty) {
                          SnackBarService.showError(
                            context,
                            message,
                            duration: const Duration(seconds: 2),
                          );
                        } else {
                          SnackBarService.showWarning(
                            context,
                            message,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: stockColor!.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          stockIcon,
                          color: stockColor,
                          size: 18,
                        ),
                      ),
                    )
                  : null,
              onTap: onTap,
            ),
            // Today's doses section
            if (todayDosesWidget != null) todayDosesWidget!,
          ],
        ),
      ),
    );
  }
}

/// Widget with live countdown that updates every second
class _FastingCountdownWidget extends StatefulWidget {
  final Map<String, dynamic> fastingPeriod;

  const _FastingCountdownWidget({
    required this.fastingPeriod,
  });

  @override
  State<_FastingCountdownWidget> createState() => _FastingCountdownWidgetState();
}

class _FastingCountdownWidgetState extends State<_FastingCountdownWidget> {
  late DateTime _fastingEndTime;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _fastingEndTime = widget.fastingPeriod['fastingEndTime'] as DateTime;
    _isActive = widget.fastingPeriod['isActive'] as bool;
  }

  String _formatRemainingTime(Duration remaining) {
    if (remaining.isNegative) {
      return '00:00';
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    if (hours > 0) {
      // Format as HH:MM if hours remain
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else if (minutes > 0) {
      // Format as MM:SS if only minutes remain
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      // Format as Ss if only seconds remain (with 's' suffix)
      return '${seconds.toString().padLeft(2, '0')}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = _fastingEndTime.difference(now);

        // If fasting is finished (remaining is negative), show completion message
        if (remaining.isNegative) {
          return Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 18,
                color: Colors.green.shade700,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '¡Ya puedes comer!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }

        final timeText = _formatRemainingTime(remaining);
        final endTimeStr = _fastingEndTime.toTimeString();

        // Build text without using l10n for the countdown itself
        final text = _isActive
            ? 'Ayuno en curso: $timeText (hasta $endTimeStr)'
            : 'Próximo ayuno: $timeText (hasta $endTimeStr)';

        final iconColor = _isActive
            ? Colors.orange.shade700
            : Colors.blue.shade700;
        final textColor = _isActive
            ? Colors.orange.shade700
            : Colors.blue.shade700;

        return Row(
          children: [
            Icon(
              Icons.restaurant,
              size: 18,
              color: iconColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
