import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../../models/medication.dart';
import '../../models/medication_type.dart';
import '../../widgets/forms/medication_info_form.dart';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/action_buttons.dart';

/// Pantalla para editar información básica del medicamento (nombre y tipo)
class EditBasicInfoScreen extends StatefulWidget {
  final Medication medication;
  final List<Medication> existingMedications;

  const EditBasicInfoScreen({
    super.key,
    required this.medication,
    required this.existingMedications,
  });

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late MedicationType _selectedType;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication.name);
    _selectedType = widget.medication.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedMedication = Medication(
        id: widget.medication.id,
        name: _nameController.text.trim(),
        type: _selectedType,
        dosageIntervalHours: widget.medication.dosageIntervalHours,
        durationType: widget.medication.durationType,
        selectedDates: widget.medication.selectedDates,
        weeklyDays: widget.medication.weeklyDays,
        dayInterval: widget.medication.dayInterval,
        doseSchedule: widget.medication.doseSchedule,
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

      // V19+: Reprogramar notificaciones para todas las personas asignadas si el nombre cambió
      if (widget.medication.name != updatedMedication.name) {
        final persons = await DatabaseHelper.instance.getPersonsForMedication(updatedMedication.id);

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
      }

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      SnackBarService.showSuccess(
        context,
        l10n.editBasicInfoUpdated,
        duration: const Duration(seconds: 2),
      );

      Navigator.pop(context, updatedMedication);
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      SnackBarService.showError(context, l10n.editBasicInfoError(e.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editBasicInfoTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MedicationInfoForm(
                      nameController: _nameController,
                      selectedType: _selectedType,
                      onTypeChanged: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                      existingMedications: widget.existingMedications,
                      existingMedicationId: widget.medication.id,
                      showDescription: false,
                      validateDuplicates: true,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ActionButtons(
                  primaryLabel: l10n.editBasicInfoSaveChanges,
                  primaryIcon: Icons.check,
                  onPrimaryPressed: _saveChanges,
                  secondaryLabel: l10n.btnCancel,
                  secondaryIcon: Icons.cancel,
                  onSecondaryPressed: () => Navigator.pop(context),
                  isLoading: _isSaving,
                  loadingLabel: l10n.editBasicInfoSaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
