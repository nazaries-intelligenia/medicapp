import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/medication.dart';
import '../../../models/treatment_duration_type.dart';
import '../../../database/database_helper.dart';
import '../../../services/dose_action_service.dart';
import '../../../services/medication_update_service.dart';
import '../../../services/snackbar_service.dart';
import '../../../utils/medication_action_handler.dart';
import '../../../widgets/medication_status_badge.dart';
import '../../edit_medication_menu_screen.dart';
import 'medication_options_modal.dart';
import '../../medication_list/dialogs/refill_input_dialog.dart';
import '../../medication_list/dialogs/manual_dose_input_dialog.dart';
import '../../medication_list/dialogs/expiration_date_dialog.dart';
import '../medication_person_assignment_screen.dart';

class MedicationCard extends StatefulWidget {
  final Medication medication;
  final VoidCallback onMedicationUpdated;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onMedicationUpdated,
  });

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> with MedicationActionHandler {
  void _showMedicationModal() {
    MedicationOptionsModal.show(
      context,
      medication: widget.medication,
      onResume: widget.medication.isSuspended ? _resumeMedication : null,
      onRegisterDose: widget.medication.durationType == TreatmentDurationType.asNeeded &&
                      !widget.medication.isSuspended
          ? _registerManualDose
          : null,
      onRefill: _refillMedication,
      onEdit: _editMedication,
      onAssignPersons: _assignPersons,
      onDelete: _deleteMedication,
    );
  }

  void _assignPersons() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationPersonAssignmentScreen(
          medication: widget.medication,
        ),
      ),
    );
    // Reload medications after assignment
    widget.onMedicationUpdated();
  }

  void _refillMedication() async {
    final l10n = AppLocalizations.of(context)!;

    final refillAmount = await RefillInputDialog.show(
      context,
      medication: widget.medication,
    );

    if (refillAmount != null && refillAmount > 0) {
      try {
        // Use service to refill medication
        final updatedMedication = await MedicationUpdateService.refillMedication(
          medication: widget.medication,
          refillAmount: refillAmount,
        );

        // Reload medications
        widget.onMedicationUpdated();

        if (!mounted) return;

        // Show confirmation
        SnackBarService.showSuccess(
          context,
          l10n.medicineCabinetRefillSuccess(
            widget.medication.name,
            refillAmount.toString(),
            widget.medication.type.getStockUnit(l10n),
            updatedMedication.stockDisplayText,
          ),
        );

        // For as-needed medications, ask for expiration date after refill
        if (widget.medication.allowsManualDoseRegistration && mounted) {
          final expirationDate = await ExpirationDateDialog.show(
            context,
            currentExpirationDate: widget.medication.expirationDate,
            isOptional: true,
          );

          // If user provided or updated expiration date, update medication
          if (expirationDate != null &&
              expirationDate.isNotEmpty &&
              expirationDate != widget.medication.expirationDate) {
            final updatedMedicationWithExpiration = updatedMedication.copyWith(
              expirationDate: expirationDate,
            );
            await DatabaseHelper.instance.updateMedication(updatedMedicationWithExpiration);
            widget.onMedicationUpdated();
          }
        }
      } catch (e) {
        if (!mounted) return;
        SnackBarService.showError(context, e.toString());
      }
    }
  }

  void _registerManualDose() async {
    final l10n = AppLocalizations.of(context)!;

    // Check if there's any stock available
    if (widget.medication.stockQuantity <= 0) {
      SnackBarService.showError(
        context,
        l10n.medicineCabinetNoStockAvailable,
      );
      return;
    }

    // Show dialog to input dose quantity
    final doseQuantity = await ManualDoseInputDialog.show(
      context,
      medication: widget.medication,
    );

    if (doseQuantity != null && doseQuantity > 0) {
      try {
        // Calculate daily consumption if needed
        double? lastDailyConsumption;
        if (widget.medication.durationType == TreatmentDurationType.asNeeded) {
          final existingConsumption = await DoseActionService.calculateDailyConsumption(
            medicationId: widget.medication.id,
          );
          lastDailyConsumption = existingConsumption + doseQuantity;
        }

        // Use service to register the dose
        final updatedMedication = await DoseActionService.registerManualDose(
          medication: widget.medication,
          quantity: doseQuantity,
          lastDailyConsumption: lastDailyConsumption,
        );

        // Reload medications
        widget.onMedicationUpdated();

        if (!mounted) return;

        // Show confirmation
        SnackBarService.showSuccess(
          context,
          l10n.medicineCabinetDoseRegistered(
            widget.medication.name,
            doseQuantity.toString(),
            widget.medication.type.getStockUnit(l10n),
            updatedMedication.stockDisplayText,
          ),
        );
      } on InsufficientStockException catch (e) {
        if (!mounted) return;
        SnackBarService.showError(
          context,
          l10n.medicineCabinetInsufficientStock(
            e.doseQuantity.toString(),
            e.unit,
            widget.medication.stockDisplayText,
          ),
        );
      }
    }
  }

  void _deleteMedication() async {
    final l10n = AppLocalizations.of(context)!;
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.medicineCabinetDeleteConfirmTitle),
          content: Text(
            l10n.medicineCabinetDeleteConfirmMessage(widget.medication.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.btnCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.btnDelete),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await executeMedicationAction(
        action: () async {
          await DatabaseHelper.instance.deleteMedication(widget.medication.id);
          await DatabaseHelper.instance.deleteDoseHistoryForMedication(widget.medication.id);
        },
        successMessage: l10n.medicineCabinetDeleteSuccess(widget.medication.name),
        onSuccess: widget.onMedicationUpdated,
      );
    }
  }

  void _editMedication() async {
    // Load all medications to check for duplicates
    final allMedications = await DatabaseHelper.instance.getAllMedications();

    if (!mounted) return;

    // Navigate to edit medication menu
    // Note: personId is null here - medicine cabinet should be refactored to be person-aware
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationMenuScreen(
          medication: widget.medication,
          existingMedications: allMedications,
          personId: null, // TODO: Get person context from medicine cabinet
        ),
      ),
    );

    // Reload medications after editing
    widget.onMedicationUpdated();
  }

  void _resumeMedication() async {
    final l10n = AppLocalizations.of(context)!;

    await executeMedicationAction(
      action: () async {
        await MedicationUpdateService.resumeMedication(
          medication: widget.medication,
        );
      },
      successMessage: l10n.medicineCabinetResumeSuccess(widget.medication.name),
      onSuccess: widget.onMedicationUpdated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stockColor = widget.medication.isStockEmpty
        ? Colors.red
        : widget.medication.isStockLow
            ? Colors.orange
            : Colors.green;

    final isAsNeeded = widget.medication.durationType == TreatmentDurationType.asNeeded;

    return Opacity(
      opacity: widget.medication.isSuspended ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          onTap: _showMedicationModal,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(
            backgroundColor: widget.medication.type.getColor(context).withValues(alpha: 0.2),
            child: Icon(
              widget.medication.type.icon,
              color: widget.medication.type.getColor(context),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.medication.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (widget.medication.isSuspended) ...[
                const SizedBox(width: 8),
                MedicationStatusBadge.suspended(
                  label: l10n.medicineCabinetSuspended,
                ),
              ],
              // Expiration badge
              if (widget.medication.isExpired) ...[
                const SizedBox(width: 8),
                MedicationStatusBadge.expired(
                  label: l10n.expirationDateExpired,
                ),
              ] else if (widget.medication.isNearExpiration) ...[
                const SizedBox(width: 8),
                MedicationStatusBadge.nearExpiration(
                  label: l10n.expirationDateNearExpiration,
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medication.type.getDisplayName(l10n),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.medication.type.getColor(context),
                    ),
              ),
              if (isAsNeeded && !widget.medication.isSuspended) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.indigo,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 12,
                        color: Colors.indigo.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.medicineCabinetTapToRegister,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Stock quantity
              Text(
                widget.medication.stockDisplayText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: stockColor,
                    ),
              ),
              const SizedBox(height: 4),
              // Stock indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: stockColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.medication.isStockEmpty
                      ? Icons.error
                      : widget.medication.isStockLow
                          ? Icons.warning
                          : Icons.check_circle,
                  size: 14,
                  color: stockColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
