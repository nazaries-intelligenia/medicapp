import 'package:medicapp/models/medication.dart';
import 'package:medicapp/database/database_helper.dart';

/// Helper functions for managing persons in tests (V19+ requirement)
///
/// This file consolidates person-related test helpers that were duplicated
/// across multiple test files.

/// Inserts a medication and assigns it to the default person.
///
/// This is required in V19+ where all medications must be assigned to a person.
/// Ensure that [DatabaseTestHelper.ensureDefaultPerson()] has been called
/// before using this helper.
///
/// Example:
/// ```dart
/// final medication = MedicationBuilder()
///     .withId('med1')
///     .withSingleDose('08:00', 1.0)
///     .build();
/// await insertMedicationWithPerson(medication);
/// ```
Future<void> insertMedicationWithPerson(Medication medication) async {
  await DatabaseHelper.instance.insertMedication(medication);
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson != null) {
    await DatabaseHelper.instance.assignMedicationToPerson(
      personId: defaultPerson.id,
      medicationId: medication.id,
      scheduleData: medication,
    );
  }
}

/// Gets a medication for the default person by medication ID.
///
/// Returns the medication if it exists and is assigned to the default person,
/// otherwise returns null.
///
/// Example:
/// ```dart
/// final med = await getMedicationForDefaultPerson('med1');
/// expect(med?.stockQuantity, 10.0);
/// ```
Future<Medication?> getMedicationForDefaultPerson(String medicationId) async {
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson == null) return null;
  final medications = await DatabaseHelper.instance.getMedicationsForPerson(defaultPerson.id);
  return medications.where((m) => m.id == medicationId).firstOrNull;
}

/// Gets the ID of the default person.
///
/// Throws an exception if no default person is found.
/// Ensure that [DatabaseTestHelper.ensureDefaultPerson()] has been called
/// before using this helper.
///
/// Example:
/// ```dart
/// final personId = await getDefaultPersonId();
/// final historyEntry = DoseHistoryEntry(
///   personId: personId,
///   // ... other fields
/// );
/// ```
Future<String> getDefaultPersonId() async {
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson == null) throw Exception('No default person found');
  return defaultPerson.id;
}

/// Updates a medication for the default person.
///
/// This is a convenience wrapper around DatabaseHelper.updateMedicationForPerson
/// that automatically uses the default person's ID.
///
/// Example:
/// ```dart
/// final updatedMedication = MedicationBuilder.from(medication)
///     .withStock(newStock)
///     .build();
/// await updateMedicationForDefaultPerson(updatedMedication);
/// ```
Future<void> updateMedicationForDefaultPerson(Medication medication) async {
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson != null) {
    await DatabaseHelper.instance.updateMedicationForPerson(
      medication: medication,
      personId: defaultPerson.id,
    );
  }
}
