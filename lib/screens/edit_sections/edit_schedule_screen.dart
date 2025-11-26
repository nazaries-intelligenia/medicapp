import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../../models/medication.dart';
import '../../widgets/forms/dose_schedule_editor.dart';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/action_buttons.dart';

/// Pantalla para editar horarios y cantidades de las tomas
class EditScheduleScreen extends StatefulWidget {
  final Medication medication;
  final List<Medication>? allMedications; // For fasting conflict validation
  final String? personId; // Person context for validation

  const EditScheduleScreen({
    super.key,
    required this.medication,
    this.allMedications,
    this.personId,
  });

  @override
  State<EditScheduleScreen> createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  final _editorKey = GlobalKey<DoseScheduleEditorState>();
  bool _isSaving = false;

  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    final editorState = _editorKey.currentState;
    if (editorState == null) return;

    if (!editorState.allQuantitiesValid()) {
      SnackBarService.showError(context, l10n.editScheduleValidationQuantities);
      return;
    }

    if (editorState.hasDuplicateTimes()) {
      SnackBarService.showError(context, l10n.editScheduleValidationDuplicates);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final doseSchedule = editorState.getDoseSchedule();
      final dosageIntervalHours = editorState.getDosageIntervalHours();

      final updatedMedication = Medication(
        id: widget.medication.id,
        name: widget.medication.name,
        type: widget.medication.type,
        dosageIntervalHours: dosageIntervalHours,
        durationType: widget.medication.durationType,
        selectedDates: widget.medication.selectedDates,
        weeklyDays: widget.medication.weeklyDays,
        dayInterval: widget.medication.dayInterval,
        doseSchedule: doseSchedule,
        stockQuantity: widget.medication.stockQuantity,
        takenDosesToday: widget.medication.takenDosesToday,
        skippedDosesToday: widget.medication.skippedDosesToday,
        takenDosesDate: widget.medication.takenDosesDate,
        lastRefillAmount: widget.medication.lastRefillAmount,
        lowStockThresholdDays: widget.medication.lowStockThresholdDays,
        startDate: widget.medication.startDate,
        endDate: widget.medication.endDate,
        requiresFasting: widget.medication.requiresFasting,
        fastingType: widget.medication.fastingType,
        fastingDurationMinutes: widget.medication.fastingDurationMinutes,
        notifyFasting: widget.medication.notifyFasting,
        isSuspended: widget.medication.isSuspended,
        lastDailyConsumption: widget.medication.lastDailyConsumption,
      );

      await DatabaseHelper.instance.updateMedication(updatedMedication);

      // V19+: Reschedule notifications for all assigned persons with new times
      final persons = await DatabaseHelper.instance.getPersonsForMedication(
        updatedMedication.id,
      );

      // Cancel all existing notifications once before rescheduling
      await NotificationService.instance.cancelMedicationNotifications(
        updatedMedication.id,
        medication: updatedMedication,
      );

      // Then schedule for all persons with skipCancellation=true
      for (final person in persons) {
        await NotificationService.instance.scheduleMedicationNotifications(
          updatedMedication,
          personId: person.id,
          skipCancellation: true,
        );
      }

      if (!mounted) return;

      SnackBarService.showSuccess(
        context,
        l10n.editScheduleUpdated,
        duration: const Duration(seconds: 2),
      );

      Navigator.pop(context, updatedMedication);
    } catch (e) {
      if (!mounted) return;

      SnackBarService.showError(context, l10n.editScheduleError(e.toString()));
    } finally{
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _addDose() {
    _editorKey.currentState?.addDose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editScheduleTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDose,
            tooltip: l10n.editScheduleAddDose,
          ),
        ],
      ),
      body: Column(
        children: [
          // Dose schedule editor
          Expanded(
            child: DoseScheduleEditor(
              key: _editorKey,
              initialDoseCount: widget.medication.doseSchedule.length,
              initialSchedule: widget.medication.doseSchedule,
              medicationType: widget.medication.type,
              allowAddRemove: true,
              headerText: l10n.editScheduleDosesPerDay(
                widget.medication.doseSchedule.length,
              ),
              subtitleText: l10n.editScheduleAdjustTimeAndQuantity,
              // Enable fasting conflict validation if medications are provided
              allMedications: widget.allMedications,
              personId: widget.personId,
              medicationId: widget.medication.id,
            ),
          ),

          // Botones de acción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ActionButtons(
              primaryLabel: l10n.editBasicInfoSaveChanges,
              primaryIcon: Icons.check,
              onPrimaryPressed: _saveChanges,
              secondaryLabel: l10n.btnCancel,
              secondaryIcon: Icons.cancel,
              onSecondaryPressed: () => Navigator.pop(context),
              isLoading: _isSaving,
              loadingLabel: l10n.editBasicInfoSaving,
            ),
          ),
        ],
      ),
    );
  }
}
