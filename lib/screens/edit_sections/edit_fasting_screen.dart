import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/medication.dart';
import '../../widgets/forms/fasting_configuration_form.dart';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/action_buttons.dart';

/// Pantalla para editar la configuración de ayuno
class EditFastingScreen extends StatefulWidget {
  final Medication medication;

  const EditFastingScreen({
    super.key,
    required this.medication,
  });

  @override
  State<EditFastingScreen> createState() => _EditFastingScreenState();
}

class _EditFastingScreenState extends State<EditFastingScreen> {
  late bool _requiresFasting;
  late String? _fastingType;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late bool _notifyFasting;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _requiresFasting = widget.medication.requiresFasting;
    _fastingType = widget.medication.fastingType;
    _notifyFasting = widget.medication.notifyFasting;

    // Parse hours and minutes from fastingDurationMinutes
    final totalMinutes = widget.medication.fastingDurationMinutes ?? 0;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  int? get _fastingDurationMinutes {
    if (!_requiresFasting) return null;

    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;
    return (hours * 60) + minutes;
  }

  bool _isValid() {
    if (!_requiresFasting) return true;

    // Check if fasting type is selected
    if (_fastingType == null) return false;

    // Check if duration is valid (at least 1 minute)
    final duration = _fastingDurationMinutes;
    if (duration == null || duration < 1) return false;

    return true;
  }

  Future<void> _saveChanges() async {
    if (!_isValid()) {
      String message = 'Por favor, completa todos los campos';
      if (_fastingType == null) {
        message = 'Por favor, selecciona cuándo es el ayuno';
      } else if (_fastingDurationMinutes == null || _fastingDurationMinutes! < 1) {
        message = 'La duración del ayuno debe ser al menos 1 minuto';
      }

      SnackBarService.showError(context, message);
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedMedication = Medication(
        id: widget.medication.id,
        name: widget.medication.name,
        type: widget.medication.type,
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
        requiresFasting: _requiresFasting,
        fastingType: _fastingType,
        fastingDurationMinutes: _fastingDurationMinutes,
        notifyFasting: _notifyFasting,
      );

      await DatabaseHelper.instance.updateMedication(updatedMedication);

      // V19+: Always reschedule notifications for all assigned persons when fasting settings change
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

      if (!mounted) return;

      SnackBarService.showSuccess(
        context,
        l10n.editFastingUpdated,
        duration: const Duration(seconds: 2),
      );

      Navigator.pop(context, updatedMedication);
    } catch (e) {
      if (!mounted) return;

      SnackBarService.showError(context, l10n.editFastingError(e.toString()));
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
        title: const Text('Editar Configuración de Ayuno'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FastingConfigurationForm(
                    requiresFasting: _requiresFasting,
                    fastingType: _fastingType,
                    hoursController: _hoursController,
                    minutesController: _minutesController,
                    notifyFasting: _notifyFasting,
                    onRequiresFastingChanged: (value) {
                      setState(() {
                        _requiresFasting = value;
                        if (!value) {
                          _fastingType = null;
                          _notifyFasting = false;
                        }
                      });
                    },
                    onFastingTypeChanged: (value) {
                      setState(() {
                        _fastingType = value;
                      });
                    },
                    onNotifyFastingChanged: (value) {
                      setState(() {
                        _notifyFasting = value;
                      });
                    },
                    showDescription: false,
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
    );
  }
}
