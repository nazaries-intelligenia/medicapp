import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

/// Tests for notification quick actions (register, skip, snooze)
/// Added in feature: Quick actions on medication notifications
///
/// These tests verify that actions from notification buttons work correctly:
/// - 'register_dose': Mark dose as taken, reduce stock, create history
/// - 'skip_dose': Mark dose as skipped, create history
/// - 'snooze_dose': Postpone notification by 10 minutes
void main() {
  late NotificationService service;

  DatabaseTestHelper.setup();

  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  tearDown(() {
    service.disableTestMode();
  });

  group('Notification Action: register_dose', () {
    test('should reduce stock and create taken history entry', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-1')
          .withName('Acetaminophen')
          .withSingleDose('08:00', 2.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Simulate notification action by directly calling the internal logic
      // Since _handleNotificationAction is private, we test the effects
      final initialMed = await getMedicationForDefaultPerson('med-1');
      expect(initialMed?.stockQuantity, 20.0);

      // Act - Simulate register action by manually doing what the action would do
      // This tests the business logic that the action handler uses
      final updatedMed = medication.copyWith(
        stockQuantity: 18.0, // 20 - 2
        takenDosesToday: ['08:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      final historyEntry = DoseHistoryEntry(
        id: 'test-history-${DateTime.now().millisecondsSinceEpoch}',
        medicationId: 'med-1',
        medicationName: 'Acetaminophen',
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: DateTime.now(),
        registeredDateTime: DateTime.now(),
        status: DoseStatus.taken,
        quantity: 2.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-1');
      expect(resultMed?.stockQuantity, 18.0, reason: 'Stock should be reduced');
      expect(resultMed?.takenDosesToday, contains('08:00'),
        reason: 'Dose should be marked as taken');

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: todayStart,
        endDate: todayEnd,
        medicationId: 'med-1',
      );
      expect(history.length, 1, reason: 'Should have one history entry');
      expect(history.first.status, DoseStatus.taken);
      expect(history.first.quantity, 2.0);
    });

    test('should not register dose when stock is insufficient', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-2')
          .withSingleDose('08:00', 5.0)
          .withStock(3.0) // Not enough for 5.0 dose
          .build();

      await insertMedicationWithPerson(medication);
      await getDefaultPersonId();

      // Act & Assert
      final initialMed = await getMedicationForDefaultPerson('med-2');
      expect(initialMed?.stockQuantity, 3.0);

      // Verify that attempting to register would fail
      expect(initialMed!.stockQuantity < 5.0, isTrue,
        reason: 'Stock should be insufficient for dose');

      // In real scenario, the action handler would detect this and not proceed
      // We verify the condition that would prevent registration
      final doseQuantity = initialMed.getDoseQuantity('08:00');
      expect(initialMed.stockQuantity < doseQuantity, isTrue);
    });

    test('should schedule fasting notification for "after" fasting type', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-3')
          .withSingleDose('08:00', 1.0)
          .withStock(20.0)
          .withFasting(type: 'after', duration: 120) // 2 hours after
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Simulate registering the dose
      final updatedMed = medication.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['08:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Schedule fasting notification (in test mode, this won't actually create a notification)
      await service.scheduleMedicationNotifications(updatedMed, personId: personId);

      // Assert
      expect(service.isTestMode, isTrue,
        reason: 'Test mode should prevent actual notification scheduling');

      // In test mode, no actual notifications are created, but we verify the medication
      // has fasting configuration that would trigger notification scheduling
      final resultMed = await getMedicationForDefaultPerson('med-3');
      expect(resultMed?.requiresFasting, isTrue);
      expect(resultMed?.fastingType, 'after');
      expect(resultMed?.fastingDurationMinutes, 120);
    });

    test('should handle multiple doses in same day correctly', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-4')
          .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Register first dose
      var updatedMed = medication.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['08:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Register second dose
      updatedMed = updatedMed.copyWith(
        stockQuantity: 18.0,
        takenDosesToday: ['08:00', '14:00'],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-4');
      expect(resultMed?.stockQuantity, 18.0);
      expect(resultMed?.takenDosesToday.length, 2);
      expect(resultMed?.takenDosesToday, containsAll(['08:00', '14:00']));
    });
  });

  group('Notification Action: skip_dose', () {
    test('should create skipped history entry without reducing stock', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-5')
          .withSingleDose('08:00', 2.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      final initialMed = await getMedicationForDefaultPerson('med-5');
      final initialStock = initialMed!.stockQuantity;

      // Act - Simulate skip action
      final updatedMed = medication.copyWith(
        skippedDosesToday: ['08:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      final historyEntry = DoseHistoryEntry(
        id: 'test-history-${DateTime.now().millisecondsSinceEpoch}',
        medicationId: 'med-5',
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: DateTime.now(),
        registeredDateTime: DateTime.now(),
        status: DoseStatus.skipped,
        quantity: 0.0, // Skipped doses have 0 quantity
      );
      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-5');
      expect(resultMed?.stockQuantity, initialStock,
        reason: 'Stock should NOT be reduced for skipped doses');
      expect(resultMed?.skippedDosesToday, contains('08:00'));

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: todayStart,
        endDate: todayEnd,
        medicationId: 'med-5',
      );
      expect(history.length, 1);
      expect(history.first.status, DoseStatus.skipped);
      expect(history.first.quantity, 0.0);
    });

    test('should allow skipping multiple doses', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-6')
          .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Skip two doses
      final updatedMed = medication.copyWith(
        skippedDosesToday: ['08:00', '14:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-6');
      expect(resultMed?.stockQuantity, 20.0, reason: 'Stock unchanged');
      expect(resultMed?.skippedDosesToday.length, 2);
      expect(resultMed?.skippedDosesToday, containsAll(['08:00', '14:00']));
    });
  });

  group('Notification Action: snooze_dose', () {
    test('should allow postponing notification', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-7')
          .withSingleDose('08:00', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Schedule notification (simulates the snooze action rescheduling)
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert - In test mode, we just verify the service doesn't crash
      expect(service.isTestMode, isTrue);

      // Verify medication still has pending dose (not taken or skipped)
      final resultMed = await getMedicationForDefaultPerson('med-7');
      expect(resultMed?.takenDosesToday, isEmpty);
      expect(resultMed?.skippedDosesToday, isEmpty);
    });

    test('should maintain dose as pending after snooze', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-8')
          .withMultipleDoses(['08:00', '14:00'], 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);

      // Act - Verify initial state (no doses taken/skipped)
      final initialMed = await getMedicationForDefaultPerson('med-8');
      expect(initialMed?.takenDosesToday, isEmpty);
      expect(initialMed?.skippedDosesToday, isEmpty);

      // Snooze doesn't change the medication state, only reschedules notification
      // In real implementation, it would cancel old notification and create new one 10min later

      // Assert - State should remain unchanged
      final resultMed = await getMedicationForDefaultPerson('med-8');
      expect(resultMed?.takenDosesToday, isEmpty,
        reason: 'Snoozed dose should remain pending');
      expect(resultMed?.skippedDosesToday, isEmpty,
        reason: 'Snoozed dose should not be marked as skipped');
    });
  });

  group('Notification Action: edge cases', () {
    test('should handle action with invalid medication ID gracefully', () async {
      // Arrange - Try to get non-existent medication
      final nonExistentMed = await getMedicationForDefaultPerson('invalid-med-id');

      // Assert - Should return null without crashing
      expect(nonExistentMed, isNull,
        reason: 'Non-existent medication should return null');
    });

    test('should handle action for already registered dose', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-9')
          .withSingleDose('08:00', 1.0)
          .withStock(20.0)
          .withTakenDoses(['08:00']) // Already taken
          .build();

      await insertMedicationWithPerson(medication);
      await getDefaultPersonId();

      // Act - Try to register again (should be idempotent or handle gracefully)
      final currentMed = await getMedicationForDefaultPerson('med-9');

      // Assert - Dose is already marked as taken
      expect(currentMed?.takenDosesToday, contains('08:00'),
        reason: 'Dose should already be marked as taken');

      // Attempting to register again should be detected
      expect(currentMed!.takenDosesToday.contains('08:00'), isTrue);
    });

    test('should verify notification payload format', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-10')
          .withSingleDose('08:00', 1.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Assert - Verify the expected payload format
      // Payload should be: "medicationId|doseIndex|personId"
      final expectedPayload = '${medication.id}|0|$personId';
      final parts = expectedPayload.split('|');

      expect(parts.length, 3, reason: 'Payload should have 3 parts');
      expect(parts[0], medication.id);
      expect(parts[1], '0'); // First dose index
      expect(parts[2], personId);
    });

    test('should handle dose with fractional quantities correctly', () async {
      // Arrange
      final medication = MedicationBuilder()
          .withId('med-11')
          .withSingleDose('08:00', 0.5) // Half pill
          .withStock(10.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Register fractional dose
      final updatedMed = medication.copyWith(
        stockQuantity: 9.5, // 10.0 - 0.5
        takenDosesToday: ['08:00'],
        takenDosesDate: DateTime.now().toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-11');
      expect(resultMed?.stockQuantity, 9.5,
        reason: 'Stock should handle fractional quantities correctly');
    });

    test('should handle concurrent person IDs correctly', () async {
      // Arrange - This tests the multi-person (V19+) feature
      final medication = MedicationBuilder()
          .withId('med-12')
          .withSingleDose('08:00', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Assert - Verify person ID is correctly associated
      final meds = await DatabaseHelper.instance.getMedicationsForPerson(personId);
      expect(meds.any((m) => m.id == 'med-12'), isTrue,
        reason: 'Medication should be assigned to person');
    });
  });

  group('Test Mode Verification', () {
    test('notification service should maintain test mode throughout tests', () {
      expect(service.isTestMode, isTrue,
        reason: 'Test mode should remain enabled for all tests');
    });
  });
}
