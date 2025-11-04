import 'package:flutter/material.dart';
import 'package:medicapp/l10n/app_localizations.dart';
import '../../models/medication.dart';
import '../../models/medication_type.dart';

/// Widget reutilizable para el formulario de información básica del medicamento
/// Usado tanto en creación como en edición de medicamentos
class MedicationInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final MedicationType selectedType;
  final ValueChanged<MedicationType> onTypeChanged;
  final List<Medication> existingMedications;
  final String? existingMedicationId;
  final bool showDescription;
  final ValueChanged<Medication?>? onMedicationSelected;
  final bool validateDuplicates;

  const MedicationInfoForm({
    super.key,
    required this.nameController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.existingMedications,
    this.existingMedicationId,
    this.showDescription = true,
    this.onMedicationSelected,
    this.validateDuplicates = false,
  });

  /// Get unique medication names (ignoring current medication being edited)
  List<String> _getUniqueMedicationNames() {
    final names = <String>{};
    for (final medication in existingMedications) {
      if (medication.id != existingMedicationId) {
        names.add(medication.name);
      }
    }
    return names.toList()..sort();
  }

  /// Get a medication by name (returns first match)
  Medication? _getMedicationByName(String name) {
    try {
      return existingMedications.firstWhere(
        (medication) =>
            medication.id != existingMedicationId &&
            medication.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDescription) ...[
          Text(
            l10n.medicationInfoTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.medicationInfoSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 24),
        ],

        // Campo de nombre con autocompletado
        if (!showDescription)
          Text(
            l10n.medicationNameLabel,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        if (!showDescription) const SizedBox(height: 16),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            final uniqueNames = _getUniqueMedicationNames();
            return uniqueNames.where((String name) {
              return name.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selectedName) {
            nameController.text = selectedName;
            // Notify parent that a medication was selected
            final medication = _getMedicationByName(selectedName);
            if (onMedicationSelected != null && medication != null) {
              onMedicationSelected!(medication);
              // Also update the type
              onTypeChanged(medication.type);
            }
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sync with the external controller
            if (nameController.text.isNotEmpty && fieldController.text.isEmpty) {
              fieldController.text = nameController.text;
            }

            // Keep both controllers in sync
            fieldController.addListener(() {
              if (fieldController.text != nameController.text) {
                nameController.text = fieldController.text;
              }
            });

            return TextFormField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: l10n.medicationNameLabel,
                hintText: l10n.medicationNameHint,
                prefixIcon: const Icon(Icons.medication),
                suffixIcon: fieldController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          fieldController.clear();
                          nameController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: showDescription,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.validationMedicationName;
                }

                // Check for duplicate medication names (case-insensitive)
                // Only validate duplicates in edit mode (not when adding new medications)
                if (validateDuplicates) {
                  final trimmedValue = value.trim();
                  final isDuplicate = existingMedications.any((medication) =>
                    medication.id != existingMedicationId &&
                    medication.name.toLowerCase() == trimmedValue.toLowerCase()
                  );

                  if (isDuplicate) {
                    return l10n.validationDuplicateMedication;
                  }
                }

                return null;
              },
              onFieldSubmitted: (value) => onFieldSubmitted(),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 400,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      final medication = _getMedicationByName(option);
                      return ListTile(
                        leading: Icon(
                          medication?.type.icon ?? Icons.medication,
                          color: medication?.type.getColor(context),
                        ),
                        title: Text(option),
                        subtitle: medication != null
                            ? Text(
                                medication.type.displayName,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : null,
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: showDescription ? 32 : 24),

        // Selector de tipo
        Text(
          l10n.medicationTypeLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: showDescription ? FontWeight.w600 : null,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final spacing = 8.0;
            final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: MedicationType.values.map((type) {
                final isSelected = selectedType == type;
                return InkWell(
                  onTap: () => onTypeChanged(type),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: itemWidth,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? type.getColor(context).withOpacity(0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? type.getColor(context)
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type.icon,
                          size: 32,
                          color: isSelected
                              ? type.getColor(context)
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? type.getColor(context)
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
