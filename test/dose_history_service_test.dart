import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/services/dose_history_service.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setup();

  setUp(() async {
    // Ensure default person exists (V19+ requirement)
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  group('DoseHistoryService - deleteHistoryEntry', () {
    test('should delete history entry from today and restore stock for taken dose', () async {
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      // Create medication with taken dose today
      final medication = MedicationBuilder()
          .withId('med1')
          .withMultipleDoses(['08:00', '16:00'], 1.0)
          .withStock(9.0) // Stock was reduced when dose was taken
          .withTakenDoses(['08:00'], todayString)
          .build();

      await insertMedicationWithPerson(medication);

      // Create history entry for today's taken dose
      final personId = await getDefaultPersonId();
      final scheduledTime = DateTime(today.year, today.month, today.day, 8, 0);
      final historyEntry = DoseHistoryEntry(
        id: 'entry1',
        medicationId: 'med1',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Delete the entry
      await DoseHistoryService.deleteHistoryEntry(historyEntry);

      // Verify entry was deleted from history
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med1');
      expect(history.length, 0);

      // Verify medication was updated
      final updatedMed = await getMedicationForDefaultPerson('med1');
      expect(updatedMed, isNotNull);
      expect(updatedMed!.stockQuantity, 10.0); // Stock restored
      expect(updatedMed.takenDosesToday, isEmpty); // Removed from taken list

      // Also test fractional dose quantities
      final medicationFractional = MedicationBuilder()
          .withId('med1_frac')
          .withSingleDose('08:00', 0.5)
          .withStock(9.5)
          .withTakenDoses(['08:00'], todayString)
          .build();

      await insertMedicationWithPerson(medicationFractional);

      final historyEntryFractional = DoseHistoryEntry(
        id: 'entry1_frac',
        medicationId: 'med1_frac',
        medicationName: 'Test Med Fractional',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 0.5,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntryFractional);
      await DoseHistoryService.deleteHistoryEntry(historyEntryFractional);

      final updatedMedFractional = await getMedicationForDefaultPerson('med1_frac');
      expect(updatedMedFractional!.stockQuantity, 10.0); // 9.5 + 0.5 = 10.0
    });

    test('should delete history entry from today and NOT restore stock for skipped dose', () async {
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final medication = MedicationBuilder()
          .withId('med2')
          .withSingleDose('08:00', 1.0)
          .withStock(10.0) // Stock unchanged because dose was skipped
          .withSkippedDoses(['08:00'], todayString)
          .build();

      await insertMedicationWithPerson(medication);

      final scheduledTime = DateTime(today.year, today.month, today.day, 8, 0);
      final personId = await getDefaultPersonId();
      final historyEntry = DoseHistoryEntry(
        id: 'entry2',
        medicationId: 'med2',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.skipped,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      await DoseHistoryService.deleteHistoryEntry(historyEntry);

      final updatedMed = await getMedicationForDefaultPerson('med2');
      expect(updatedMed!.stockQuantity, 10.0); // Stock unchanged
      expect(updatedMed.skippedDosesToday, isEmpty); // Removed from skipped list
    });

    test('should delete history entry from past without updating medication', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final medication = MedicationBuilder()
          .withId('med3')
          .withSingleDose('08:00', 1.0)
          .withStock(9.0)
          .withTakenDoses(['08:00'], todayString) // Today's dose
          .build();

      await insertMedicationWithPerson(medication);

      // Create history entry for yesterday
      final scheduledTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 0);
      final personId = await getDefaultPersonId();
      final historyEntry = DoseHistoryEntry(
        id: 'entry3',
        medicationId: 'med3',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      await DoseHistoryService.deleteHistoryEntry(historyEntry);

      // Entry should be deleted
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med3');
      expect(history.length, 0);

      // Medication should remain unchanged (no stock restoration, lists unchanged)
      final updatedMed = await getMedicationForDefaultPerson('med3');
      expect(updatedMed!.stockQuantity, 9.0); // Stock NOT restored
      expect(updatedMed.takenDosesToday, ['08:00']); // Today's list unchanged
    });

    test('should throw MedicationNotFoundException when medication does not exist', () async {
      final today = DateTime.now();
      final scheduledTime = DateTime(today.year, today.month, today.day, 8, 0);

      final personId = await getDefaultPersonId();
      final historyEntry = DoseHistoryEntry(
        id: 'entry4',
        medicationId: 'nonexistent',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      expect(
        () => DoseHistoryService.deleteHistoryEntry(historyEntry),
        throwsA(isA<MedicationNotFoundException>()),
      );
    });

    test('should handle multiple doses in taken list when deleting one', () async {
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final medication = MedicationBuilder()
          .withId('med5')
          .withMultipleDoses(['08:00', '16:00', '22:00'], 1.0)
          .withStock(7.0)
          .withTakenDoses(['08:00', '16:00', '22:00'], todayString)
          .build();

      await insertMedicationWithPerson(medication);

      final scheduledTime = DateTime(today.year, today.month, today.day, 16, 0);
      final personId = await getDefaultPersonId();
      final historyEntry = DoseHistoryEntry(
        id: 'entry5',
        medicationId: 'med5',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);
      await DoseHistoryService.deleteHistoryEntry(historyEntry);

      final updatedMed = await getMedicationForDefaultPerson('med5');
      expect(updatedMed!.stockQuantity, 8.0);
      expect(updatedMed.takenDosesToday, ['08:00', '22:00']); // Only 16:00 removed
      expect(updatedMed.takenDosesToday.length, 2);
    });
  });

  group('DoseHistoryService - changeEntryStatus', () {
    test('should change status from taken to skipped', () async {
      // Use a time in the past to ensure registeredDateTime is always after it
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry7',
        medicationId: 'med7',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      // Change status
      final updatedEntry = await DoseHistoryService.changeEntryStatus(
        originalEntry,
        DoseStatus.skipped,
      );

      // Verify updated entry
      expect(updatedEntry.id, originalEntry.id);
      expect(updatedEntry.status, DoseStatus.skipped);
      expect(updatedEntry.scheduledDateTime, scheduledTime);
      expect(
        updatedEntry.registeredDateTime.isAfter(scheduledTime) ||
            updatedEntry.registeredDateTime.isAtSameMomentAs(scheduledTime),
        true,
      );

      // Verify it was saved to database
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med7');
      expect(history.length, 1);
      expect(history.first.status, DoseStatus.skipped);
    });

    test('should change status from skipped to taken', () async {
      // Use a time in the past to ensure registeredDateTime is always after it
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry8',
        medicationId: 'med8',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.skipped,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeEntryStatus(
        originalEntry,
        DoseStatus.taken,
      );

      expect(updatedEntry.status, DoseStatus.taken);

      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med8');
      expect(history.first.status, DoseStatus.taken);
    });

    test('should update registeredDateTime when changing status', () async {
      // Use a time in the past to ensure registeredDateTime is always after it
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 5));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry9',
        medicationId: 'med9',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      // Small delay to ensure time difference
      await Future.delayed(const Duration(milliseconds: 100));

      final updatedEntry = await DoseHistoryService.changeEntryStatus(
        originalEntry,
        DoseStatus.skipped,
      );

      // Registered time should be updated (later than original)
      expect(updatedEntry.registeredDateTime.isAfter(originalRegisteredTime), true);
    });

    test('should preserve all other fields when changing status', () async {
      final today = DateTime.now();
      final scheduledTime = DateTime(today.year, today.month, today.day, 8, 0);

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry10',
        medicationId: 'med10',
        medicationName: 'Special Med',
        medicationType: MedicationType.injection,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: scheduledTime,
        status: DoseStatus.taken,
        quantity: 2.5,
        notes: 'Test notes',
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeEntryStatus(
        originalEntry,
        DoseStatus.skipped,
      );

      // Verify all fields except status and registeredDateTime are preserved
      expect(updatedEntry.id, originalEntry.id);
      expect(updatedEntry.medicationId, originalEntry.medicationId);
      expect(updatedEntry.medicationName, originalEntry.medicationName);
      expect(updatedEntry.medicationType, originalEntry.medicationType);
      expect(updatedEntry.scheduledDateTime, originalEntry.scheduledDateTime);
      expect(updatedEntry.quantity, originalEntry.quantity);
      expect(updatedEntry.notes, originalEntry.notes);
      expect(updatedEntry.status, DoseStatus.skipped); // Changed
    });
  });

  group('DoseHistoryService - changeRegisteredTime', () {
    test('should change registered time without changing other fields', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 10));
      final newRegisteredTime = scheduledTime.add(const Duration(minutes: 30));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry11',
        medicationId: 'med11',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      // Change registered time
      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      // Verify registered time was updated
      expect(updatedEntry.registeredDateTime, newRegisteredTime);
      expect(updatedEntry.registeredDateTime, isNot(originalRegisteredTime));

      // Verify all other fields remain unchanged
      expect(updatedEntry.id, originalEntry.id);
      expect(updatedEntry.medicationId, originalEntry.medicationId);
      expect(updatedEntry.medicationName, originalEntry.medicationName);
      expect(updatedEntry.medicationType, originalEntry.medicationType);
      expect(updatedEntry.personId, originalEntry.personId);
      expect(updatedEntry.scheduledDateTime, originalEntry.scheduledDateTime);
      expect(updatedEntry.status, originalEntry.status);
      expect(updatedEntry.quantity, originalEntry.quantity);

      // Verify it was saved to database
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med11');
      expect(history.length, 1);
      expect(history.first.registeredDateTime, newRegisteredTime);
    });

    test('should preserve status when changing registered time', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 5));
      final newRegisteredTime = scheduledTime.add(const Duration(minutes: 45));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry12',
        medicationId: 'med12',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      expect(updatedEntry.status, DoseStatus.taken); // Status unchanged
      expect(updatedEntry.registeredDateTime, newRegisteredTime);

      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med12');
      expect(history.first.status, DoseStatus.taken);
    });

    test('should preserve quantity and notes when changing registered time', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 10));
      final newRegisteredTime = scheduledTime.add(const Duration(minutes: 25));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry13',
        medicationId: 'med13',
        medicationName: 'Complex Med',
        medicationType: MedicationType.injection,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 2.5,
        notes: 'Important test notes',
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      expect(updatedEntry.quantity, 2.5);
      expect(updatedEntry.notes, 'Important test notes');
      expect(updatedEntry.registeredDateTime, newRegisteredTime);

      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med13');
      expect(history.first.quantity, 2.5);
      expect(history.first.notes, 'Important test notes');
    });

    test('should allow changing registered time to earlier time', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 30));
      final newRegisteredTime = scheduledTime.add(const Duration(minutes: 5)); // Earlier

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry14',
        medicationId: 'med14',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      expect(updatedEntry.registeredDateTime, newRegisteredTime);
      expect(updatedEntry.registeredDateTime.isBefore(originalRegisteredTime), true);
    });

    test('should allow changing registered time to later time', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 2));
      final originalRegisteredTime = scheduledTime.add(const Duration(minutes: 5));
      final newRegisteredTime = scheduledTime.add(const Duration(hours: 1)); // Later

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry15',
        medicationId: 'med15',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      expect(updatedEntry.registeredDateTime, newRegisteredTime);
      expect(updatedEntry.registeredDateTime.isAfter(originalRegisteredTime), true);
    });

    test('should work with extra doses', () async {
      final scheduledTime = DateTime.now().subtract(const Duration(hours: 1));
      final originalRegisteredTime = scheduledTime;
      final newRegisteredTime = scheduledTime.add(const Duration(minutes: 15));

      final personId = await getDefaultPersonId();
      final originalEntry = DoseHistoryEntry(
        id: 'entry16',
        medicationId: 'med16',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: personId,
        scheduledDateTime: scheduledTime,
        registeredDateTime: originalRegisteredTime,
        status: DoseStatus.taken,
        quantity: 1.0,
        isExtraDose: true,
      );

      await DatabaseHelper.instance.insertDoseHistory(originalEntry);

      final updatedEntry = await DoseHistoryService.changeRegisteredTime(
        originalEntry,
        newRegisteredTime,
      );

      expect(updatedEntry.isExtraDose, true); // Extra dose flag preserved
      expect(updatedEntry.registeredDateTime, newRegisteredTime);

      final history = await DatabaseHelper.instance.getDoseHistoryForMedication('med16');
      expect(history.first.isExtraDose, true);
    });
  });

  group('MedicationNotFoundException', () {
    test('should contain medication ID in exception', () {
      final exception = MedicationNotFoundException('test-id-123');
      expect(exception.medicationId, 'test-id-123');
    });

    test('should have descriptive toString', () {
      final exception = MedicationNotFoundException('test-id-123');
      expect(exception.toString(), contains('test-id-123'));
      expect(exception.toString(), contains('Medication not found'));
    });
  });
}
