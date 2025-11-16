import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

/// Debug test to diagnose the deletion issue
void main() {
  DatabaseTestHelper.setupAll();
  DatabaseTestHelper.setupEach();

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('DEBUG: Track what happens when deleting medication2', () async {
    print('\n=== STARTING DEBUG TEST ===\n');

    // Get default person
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    print('Default person ID: ${defaultPerson?.id}');
    print('Default person name: ${defaultPerson?.name}');

    // Create two medications
    final medication1 = MedicationBuilder()
        .withId('med-keep-1')
        .withName('Vitamin C')
        .withSingleDose('09:00', 1.0)
        .withStock(30.0)
        .withStartDate(DateTime.now())
        .build();

    final medication2 = MedicationBuilder()
        .withId('med-delete-1')
        .withName('Iron Supplement')
        .withSingleDose('21:00', 1.0)
        .withStock(30.0)
        .withStartDate(DateTime.now())
        .build();

    print('\nCreated medication1: ${medication1.id} - ${medication1.name}');
    print('Created medication2: ${medication2.id} - ${medication2.name}');

    // Insert both medications
    await insertMedicationWithPerson(medication1);
    print('\nInserted medication1 with person');

    await insertMedicationWithPerson(medication2);
    print('Inserted medication2 with person');

    // Verify both are in database
    final allMedsAfterInsert = await DatabaseHelper.instance.getMedicationsForPerson(defaultPerson!.id);
    print('\nMedications after insert: ${allMedsAfterInsert.length}');
    for (var med in allMedsAfterInsert) {
      print('  - ${med.id}: ${med.name}');
    }

    // Delete medication2
    print('\nDeleting medication2 (${medication2.id})...');
    final deleteResult = await DatabaseHelper.instance.deleteMedication(medication2.id);
    print('Delete result: $deleteResult rows affected');

    // Check what's left in database
    final allMedsAfterDelete = await DatabaseHelper.instance.getMedicationsForPerson(defaultPerson.id);
    print('\nMedications after delete: ${allMedsAfterDelete.length}');
    for (var med in allMedsAfterDelete) {
      print('  - ${med.id}: ${med.name}');
    }

    // Try to get medication1
    print('\nAttempting to get medication1 (${medication1.id})...');
    final remainingMed = await getMedicationForDefaultPerson(medication1.id);
    print('Result: ${remainingMed != null ? "${remainingMed.id} - ${remainingMed.name}" : "NULL"}');

    // Additional diagnostics
    print('\n=== ADDITIONAL DIAGNOSTICS ===');

    // Check medications table directly
    final db = await DatabaseHelper.instance.database;
    final medicationsTable = await db.query('medications');
    print('Rows in medications table: ${medicationsTable.length}');
    for (var row in medicationsTable) {
      print('  - ${row['id']}: ${row['name']}');
    }

    // Check person_medications table directly
    final personMedicationsTable = await db.query('person_medications');
    print('\nRows in person_medications table: ${personMedicationsTable.length}');
    for (var row in personMedicationsTable) {
      print('  - personId: ${row['personId']}, medicationId: ${row['medicationId']}');
    }

    print('\n=== END DEBUG TEST ===\n');

    // Assertions
    expect(remainingMed, isNotNull, reason: 'Medication1 should still exist after deleting medication2');
    expect(remainingMed?.id, medication1.id);
  });
}
