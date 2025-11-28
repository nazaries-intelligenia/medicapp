import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../models/medication_type.dart';
import '../models/treatment_duration_type.dart';
import '../services/snackbar_service.dart';
import '../widgets/forms/frequency_option_card.dart';
import 'weekly_days_selector_screen.dart';
import 'medication_dosage_screen.dart';
import 'medication_frequency/widgets/weekly_days_selector_card.dart';
import '../widgets/action_buttons.dart';

/// Screen 3: Frequency (how many days to take the medication)
/// Skipped if specific dates were selected
class MedicationFrequencyScreen extends StatefulWidget {
  final String medicationName;
  final MedicationType medicationType;
  final TreatmentDurationType durationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? specificDates;
  final bool skipFrequencyScreen;

  const MedicationFrequencyScreen({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.durationType,
    this.startDate,
    this.endDate,
    this.specificDates,
    this.skipFrequencyScreen = false,
  });

  @override
  State<MedicationFrequencyScreen> createState() => _MedicationFrequencyScreenState();
}

enum FrequencyMode {
  everyday,
  alternateDays,
  weeklyDays,
}

class _MedicationFrequencyScreenState extends State<MedicationFrequencyScreen> {
  FrequencyMode _selectedMode = FrequencyMode.everyday;
  List<int>? _weeklyDays;

  @override
  void initState() {
    super.initState();

    // If we should skip this screen, go directly to the next one
    if (widget.skipFrequencyScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNextScreen(
          durationType: widget.durationType,
          weeklyDays: null,
          dayInterval: null,
        );
      });
    }
  }

  Future<void> _selectWeeklyDays() async {
    final result = await Navigator.push<List<int>>(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyDaysSelectorScreen(
          initialSelectedDays: _weeklyDays,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _weeklyDays = result;
      });
    }
  }

  void _continueToNextStep() async {
    final l10n = AppLocalizations.of(context)!;

    // Validate according to the selected mode
    if (_selectedMode == FrequencyMode.weeklyDays) {
      if (_weeklyDays == null || _weeklyDays!.isEmpty) {
        SnackBarService.showError(context, l10n.validationSelectWeekdays);
        return;
      }
    }

    // Determine duration type based on frequency
    TreatmentDurationType durationType;
    List<int>? weeklyDays;
    int? dayInterval;

    switch (_selectedMode) {
      case FrequencyMode.everyday:
        durationType = TreatmentDurationType.everyday;
        weeklyDays = null;
        dayInterval = null;
        break;
      case FrequencyMode.alternateDays:
        // Alternate days: every 2 days from the start date
        durationType = TreatmentDurationType.intervalDays;
        weeklyDays = null;
        dayInterval = 2;
        break;
      case FrequencyMode.weeklyDays:
        durationType = TreatmentDurationType.weeklyPattern;
        weeklyDays = _weeklyDays;
        dayInterval = null;
        break;
    }

    // If it was originally "until finished", keep it
    if (widget.durationType == TreatmentDurationType.untilFinished) {
      durationType = TreatmentDurationType.untilFinished;
    }

    _navigateToNextScreen(
      durationType: durationType,
      weeklyDays: weeklyDays,
      dayInterval: dayInterval,
    );
  }

  void _navigateToNextScreen({
    required TreatmentDurationType durationType,
    required List<int>? weeklyDays,
    required int? dayInterval,
  }) async {
    // Continue to the dosage screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationDosageScreen(
          medicationName: widget.medicationName,
          medicationType: widget.medicationType,
          durationType: durationType,
          startDate: widget.startDate,
          endDate: widget.endDate,
          specificDates: widget.specificDates,
          weeklyDays: weeklyDays,
          dayInterval: dayInterval,
        ),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we should skip this screen, show a loading indicator
    if (widget.skipFrequencyScreen) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicationFrequencyTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                l10n.stepIndicator(4, 7),
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
                value: 4 / 7,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 24),

              // Information card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.medicationFrequencyTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.medicationFrequencySubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Frequency options
                      FrequencyOptionCard<FrequencyMode>(
                        value: FrequencyMode.everyday,
                        selectedValue: _selectedMode,
                        icon: Icons.calendar_today,
                        title: l10n.frequencyDailyTitle,
                        subtitle: l10n.frequencyDailyDesc,
                        color: Colors.blue,
                        onTap: (value) => setState(() => _selectedMode = value),
                      ),
                      const SizedBox(height: 12),
                      FrequencyOptionCard<FrequencyMode>(
                        value: FrequencyMode.alternateDays,
                        selectedValue: _selectedMode,
                        icon: Icons.repeat,
                        title: l10n.frequencyAlternateTitle,
                        subtitle: l10n.frequencyAlternateDesc,
                        color: Colors.orange,
                        onTap: (value) => setState(() => _selectedMode = value),
                      ),
                      const SizedBox(height: 12),
                      FrequencyOptionCard<FrequencyMode>(
                        value: FrequencyMode.weeklyDays,
                        selectedValue: _selectedMode,
                        icon: Icons.date_range,
                        title: l10n.frequencyWeeklyTitle,
                        subtitle: l10n.frequencyWeeklyDesc,
                        color: Colors.teal,
                        onTap: (value) => setState(() => _selectedMode = value),
                      ),
                    ],
                  ),
                ),
              ),

              // Day selector if "weeklyDays" was chosen
              if (_selectedMode == FrequencyMode.weeklyDays) ...[
                const SizedBox(height: 16),
                WeeklyDaysSelectorCard(
                  weeklyDays: _weeklyDays,
                  onSelectDays: _selectWeeklyDays,
                ),
              ],

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
