import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../models/medication.dart';
import '../models/medication_type.dart';
import '../widgets/forms/medication_info_form.dart';
import 'medication_duration_screen.dart';
import '../widgets/action_buttons.dart';

/// Pantalla 1: Información básica del medicamento (nombre y tipo)
class MedicationInfoScreen extends StatefulWidget {
  final List<Medication> existingMedications;

  const MedicationInfoScreen({
    super.key,
    required this.existingMedications,
  });

  @override
  State<MedicationInfoScreen> createState() => _MedicationInfoScreenState();
}

class _MedicationInfoScreenState extends State<MedicationInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  MedicationType _selectedType = MedicationType.pill;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continueToNextStep() async {
    if (_formKey.currentState!.validate()) {
      // Pasar datos a la siguiente pantalla
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicationDurationScreen(
            medicationName: _nameController.text.trim(),
            medicationType: _selectedType,
          ),
        ),
      );

      // Si se completó el flujo, retornar el medicamento creado
      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addMedicationTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                l10n.stepIndicator(1, 6),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Indicador de progreso
                LinearProgressIndicator(
                  value: 1 / 6,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 24),

                // Card con formulario
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
                      showDescription: true,
                      onMedicationSelected: (medication) {
                        // Callback when user selects existing medication
                        // Currently only updates the type, but could be extended
                        // to copy other settings in the future
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botones de navegación
                ActionButtons(
                  primaryLabel: l10n.specificDatesSelectorContinue,
                  primaryIcon: Icons.arrow_forward,
                  onPrimaryPressed: _continueToNextStep,
                  secondaryLabel: l10n.btnCancel,
                  secondaryIcon: Icons.cancel,
                  onSecondaryPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
