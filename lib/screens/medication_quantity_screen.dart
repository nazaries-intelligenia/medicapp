import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../models/medication.dart';
import '../models/medication_type.dart';
import '../models/treatment_duration_type.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';
import 'medication_quantity/widgets/stock_input_card.dart';
import 'medication_quantity/widgets/medication_summary_card.dart';
import '../widgets/action_buttons.dart';
import '../utils/number_utils.dart';
import 'medication_list/dialogs/expiration_date_dialog.dart';

/// Pantalla 7: Cantidad de medicamentos (última pantalla del flujo)
class MedicationQuantityScreen extends StatefulWidget {
  final String medicationName;
  final MedicationType medicationType;
  final TreatmentDurationType durationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? specificDates;
  final List<int>? weeklyDays;
  final int? dayInterval;
  final int dosageIntervalHours;
  final Map<String, double> doseSchedule;
  final bool requiresFasting;
  final String? fastingType;
  final int? fastingDurationMinutes;
  final bool notifyFasting;

  const MedicationQuantityScreen({
    super.key,
    required this.medicationName,
    required this.medicationType,
    required this.durationType,
    this.startDate,
    this.endDate,
    this.specificDates,
    this.weeklyDays,
    this.dayInterval,
    required this.dosageIntervalHours,
    required this.doseSchedule,
    this.requiresFasting = false,
    this.fastingType,
    this.fastingDurationMinutes,
    this.notifyFasting = false,
  });

  @override
  State<MedicationQuantityScreen> createState() => _MedicationQuantityScreenState();
}

class _MedicationQuantityScreenState extends State<MedicationQuantityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stockController = TextEditingController(text: '0');
  final _lowStockThresholdController = TextEditingController(text: '3');
  bool _isSaving = false;
  bool _isLoadingExisting = true;
  Medication? _existingMedication;

  @override
  void initState() {
    super.initState();
    _loadExistingMedication();
  }

  Future<void> _loadExistingMedication() async {
    // Check if a medication with this name already exists
    // Use efficient query by name instead of loading all medications
    _existingMedication = await DatabaseHelper.instance.getMedicationByName(widget.medicationName);

    if (_existingMedication != null) {
      // Pre-fill stock with existing value
      _stockController.text = _existingMedication!.stockQuantity.toString();
      _lowStockThresholdController.text = _existingMedication!.lowStockThresholdDays.toString();
    }

    setState(() {
      _isLoadingExisting = false;
    });
  }

  @override
  void dispose() {
    _stockController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // For as-needed medications, ask for expiration date as the final step
    String? expirationDate;
    if (widget.durationType == TreatmentDurationType.asNeeded && mounted) {
      expirationDate = await ExpirationDateDialog.show(
        context,
        currentExpirationDate: _existingMedication?.expirationDate,
        isOptional: true,
      );

      // User cancelled the dialog
      if (expirationDate == null) {
        setState(() {
          _isSaving = false;
        });
        return;
      }
    }

    // Create medication object with schedule data
    // Note: If medication already exists, we reuse its ID and update stock
    final newMedication = Medication(
      id: _existingMedication?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: widget.medicationName,
      type: widget.medicationType,
      dosageIntervalHours: widget.dosageIntervalHours,
      durationType: widget.durationType,
      selectedDates: widget.specificDates,
      weeklyDays: widget.weeklyDays,
      dayInterval: widget.dayInterval,
      doseSchedule: widget.doseSchedule,
      stockQuantity: NumberUtils.parseLocalizedDouble(_stockController.text) ?? 0,
      lowStockThresholdDays: int.tryParse(_lowStockThresholdController.text) ?? 3,
      startDate: widget.startDate,
      endDate: widget.endDate,
      requiresFasting: widget.requiresFasting,
      fastingType: widget.fastingType,
      fastingDurationMinutes: widget.fastingDurationMinutes,
      notifyFasting: widget.notifyFasting,
      expirationDate: expirationDate?.isNotEmpty == true ? expirationDate : null,
    );

    // Don't save to database here - let the ViewModel handle it with createMedicationForPerson
    // which will reuse existing medication if name matches
    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    // Return the medication object (ViewModel will handle saving)
    Navigator.pop(context, newMedication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentStep = widget.durationType == TreatmentDurationType.asNeeded
        ? 2
        : widget.durationType == TreatmentDurationType.specificDates
            ? 7
            : 8;
    final totalSteps = widget.durationType == TreatmentDurationType.asNeeded
        ? 2
        : widget.durationType == TreatmentDurationType.specificDates
            ? 7
            : 8;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicationQuantityTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                l10n.stepIndicator(currentStep, totalSteps),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoadingExisting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Indicador de progreso
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1.0, // Always 100% since this is the last step
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 24),

                // Info banner if medication exists
                if (_existingMedication != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.msgUsingSharedStock(widget.medicationName),
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Card con información
                StockInputCard(
                  stockController: _stockController,
                  lowStockController: _lowStockThresholdController,
                  medicationType: widget.medicationType,
                ),

                const SizedBox(height: 16),

                // Resumen del medicamento
                MedicationSummaryCard(
                  medicationName: widget.medicationName,
                  medicationType: widget.medicationType,
                  durationType: widget.durationType,
                  doseSchedule: widget.doseSchedule,
                  specificDates: widget.specificDates,
                  weeklyDays: widget.weeklyDays,
                  dayInterval: widget.dayInterval,
                ),

                const SizedBox(height: 24),

                ActionButtons(
                  primaryLabel: l10n.saveMedicationButton,
                  primaryIcon: Icons.check,
                  onPrimaryPressed: _saveMedication,
                  secondaryLabel: l10n.btnBack,
                  secondaryIcon: Icons.arrow_back,
                  onSecondaryPressed: () => Navigator.pop(context),
                  isLoading: _isSaving,
                  loadingLabel: l10n.savingButton,
                  primaryButtonColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
