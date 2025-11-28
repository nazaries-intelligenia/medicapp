import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../models/medication_type.dart';
import '../models/treatment_duration_type.dart';
import '../services/snackbar_service.dart';
import 'medication_times_screen.dart';
import 'medication_dosage/widgets/dosage_mode_option_card.dart';
import 'medication_dosage/widgets/interval_input_card.dart';
import 'medication_dosage/widgets/custom_doses_input_card.dart';
import 'medication_dosage/widgets/dose_summary_info.dart';
import '../widgets/action_buttons.dart';

/// Screen 4: Dosage (same every day or different each day)
class MedicationDosageScreen extends StatefulWidget {
  final String medicationName;
  final MedicationType medicationType;
  final TreatmentDurationType durationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? specificDates;
  final List<int>? weeklyDays;
  final int? dayInterval;

  const MedicationDosageScreen({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.durationType,
    this.startDate,
    this.endDate,
    this.specificDates,
    this.weeklyDays,
    this.dayInterval,
  });

  @override
  State<MedicationDosageScreen> createState() => _MedicationDosageScreenState();
}

enum DosageMode {
  sameEveryDay,
  custom,
}

class _MedicationDosageScreenState extends State<MedicationDosageScreen> {
  DosageMode _selectedMode = DosageMode.sameEveryDay;
  final _intervalController = TextEditingController(text: '8');
  final _customDosesController = TextEditingController(text: '3');

  @override
  void dispose() {
    _intervalController.dispose();
    _customDosesController.dispose();
    super.dispose();
  }

  int _calculateDosesFromInterval() {
    final interval = int.tryParse(_intervalController.text) ?? 8;
    if (interval > 0 && 24 % interval == 0) {
      return 24 ~/ interval;
    }
    return 3; // Default
  }

  int _getDosesPerDay() {
    if (_selectedMode == DosageMode.sameEveryDay) {
      return _calculateDosesFromInterval();
    } else {
      return int.tryParse(_customDosesController.text) ?? 3;
    }
  }

  void _continueToNextStep() {
    final l10n = AppLocalizations.of(context)!;
    int dosageIntervalHours;
    int dosesPerDay;

    if (_selectedMode == DosageMode.sameEveryDay) {
      // Validate that the interval divides 24 exactly
      final interval = int.tryParse(_intervalController.text);

      if (interval == null || interval <= 0) {
        SnackBarService.showError(context, l10n.validationInvalidInterval);
        return;
      }

      if (interval > 24) {
        SnackBarService.showError(context, l10n.validationIntervalTooLarge);
        return;
      }

      if (24 % interval != 0) {
        SnackBarService.showError(context, l10n.validationIntervalNotDivisor);
        return;
      }

      dosageIntervalHours = interval;
      dosesPerDay = 24 ~/ interval;
    } else {
      // Custom mode
      final doses = int.tryParse(_customDosesController.text);

      if (doses == null || doses <= 0) {
        SnackBarService.showError(context, l10n.validationInvalidDoseCount);
        return;
      }

      if (doses > 24) {
        SnackBarService.showError(context, l10n.validationTooManyDoses);
        return;
      }

      // For custom mode, we use a fictitious interval
      // This is only for compatibility with the existing model
      dosageIntervalHours = 24 ~/ doses;
      dosesPerDay = doses;
    }

    // Continue to the schedules screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationTimesScreen(
          medicationName: widget.medicationName,
          medicationType: widget.medicationType,
          durationType: widget.durationType,
          startDate: widget.startDate,
          endDate: widget.endDate,
          specificDates: widget.specificDates,
          weeklyDays: widget.weeklyDays,
          dayInterval: widget.dayInterval,
          dosageIntervalHours: dosageIntervalHours,
          dosesPerDay: dosesPerDay,
          isCustomDosage: _selectedMode == DosageMode.custom,
        ),
      ),
    ).then((result) {
      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dosesPerDay = _getDosesPerDay();
    final currentStep = widget.durationType == TreatmentDurationType.specificDates ? 4 : 5;
    final totalSteps = widget.durationType == TreatmentDurationType.specificDates ? 6 : 7;
    final progressValue = widget.durationType == TreatmentDurationType.specificDates ? 4 / 6 : 5 / 7;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicationDosageTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                l10n.stepIndicator(currentStep, totalSteps),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 24),

              // Card with information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.medicationDosageTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.medicationDosageSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Mode options
                      DosageModeOptionCard(
                        mode: DosageMode.sameEveryDay,
                        selectedMode: _selectedMode,
                        icon: Icons.schedule,
                        title: l10n.dosageFixedTitle,
                        subtitle: l10n.dosageFixedDesc,
                        color: Colors.blue,
                        onTap: (mode) => setState(() => _selectedMode = mode),
                      ),
                      const SizedBox(height: 12),
                      DosageModeOptionCard(
                        mode: DosageMode.custom,
                        selectedMode: _selectedMode,
                        icon: Icons.tune,
                        title: l10n.dosageCustomTitle,
                        subtitle: l10n.dosageCustomDesc,
                        color: Colors.purple,
                        onTap: (mode) => setState(() => _selectedMode = mode),
                      ),
                    ],
                  ),
                ),
              ),

              // Controls according to the selected mode
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedMode == DosageMode.sameEveryDay) ...[
                        IntervalInputCard(
                          controller: _intervalController,
                          onChanged: () => setState(() {}),
                        ),
                      ] else ...[
                        CustomDosesInputCard(
                          controller: _customDosesController,
                          onChanged: () => setState(() {}),
                        ),
                      ],

                      // Dose summary
                      const SizedBox(height: 16),
                      DoseSummaryInfo(dosesPerDay: dosesPerDay),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ActionButtons(
                primaryLabel: l10n.btnContinue,
                primaryIcon: Icons.arrow_forward,
                onPrimaryPressed: _continueToNextStep,
                secondaryLabel: l10n.btnBack,
                secondaryIcon: Icons.arrow_back,
                onSecondaryPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
