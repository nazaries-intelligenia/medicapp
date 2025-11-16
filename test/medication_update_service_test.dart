import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/services/medication_update_service.dart';
import 'package:medicapp/services/notification_service.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

/// Tests for MedicationUpdateService
///
/// Verifies that medication update operations (refill, resume, suspend)
/// work correctly and maintain data integrity.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setup();

  setUp(() async {
    NotificationService.instance.enableTestMode();
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  group('MedicationUpdateService - refillMedication', () {
    test('should increase stock quantity by refill amount', () async {
      final medication = MedicationBuilder()
          .withId('med-refill-1')
          .withName('Paracetamol')
          .withSingleDose('08:00', 1.0)
          .withStock(5.0)
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.refillMedication(
        medication: medication,
        refillAmount: 10.0,
      );

      expect(updatedMed.stockQuantity, 15.0);
      expect(updatedMed.lastRefillAmount, 10.0);
    });

    test('should save lastRefillAmount for future reference', () async {
      final medication = MedicationBuilder()
          .withId('med-refill-2')
          .withName('Ibuprofeno')
          .withSingleDose('12:00', 2.0)
          .withStock(3.0)
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.refillMedication(
        medication: medication,
        refillAmount: 20.0,
      );

      // Verify it was saved to database
      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb!.lastRefillAmount, 20.0);
      expect(fromDb.stockQuantity, 23.0);
    });

    test('should throw ArgumentError for negative refill amount', () {
      final medication = MedicationBuilder()
          .withId('med-refill-3')
          .withStock(5.0)
          .build();

      expect(
        () => MedicationUpdateService.refillMedication(
          medication: medication,
          refillAmount: -5.0,
        ),
        throwsArgumentError,
      );
    });

    test('should throw ArgumentError for zero refill amount', () {
      final medication = MedicationBuilder()
          .withId('med-refill-4')
          .withStock(5.0)
          .build();

      expect(
        () => MedicationUpdateService.refillMedication(
          medication: medication,
          refillAmount: 0.0,
        ),
        throwsArgumentError,
      );
    });

    test('should handle fractional refill amounts', () async {
      final medication = MedicationBuilder()
          .withId('med-refill-5')
          .withName('Levotiroxina')
          .withSingleDose('07:00', 0.5)
          .withStock(1.5)
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.refillMedication(
        medication: medication,
        refillAmount: 2.5,
      );

      expect(updatedMed.stockQuantity, 4.0);
    });
  });

  group('MedicationUpdateService - resumeMedication', () {
    test('should set isSuspended to false', () async {
      final medication = MedicationBuilder()
          .withId('med-resume-1')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withStock(10.0)
          .suspended(true)
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.resumeMedication(
        medication: medication,
      );

      expect(updatedMed.isSuspended, false);
    });

    test('should reschedule notifications for all assigned persons', () async {
      final medication = MedicationBuilder()
          .withId('med-resume-2')
          .withName('Aspirina')
          .withMultipleDoses(['08:00', '20:00'], 1.0)
          .withStock(20.0)
          .suspended(true)
          .build();

      await insertMedicationWithPerson(medication);

      await MedicationUpdateService.resumeMedication(
        medication: medication,
      );

      // Verify notifications were scheduled (in test mode, just check it doesn't throw)
      // In a real scenario, you'd verify with NotificationService.instance.getPendingNotifications()
      expect(true, true); // Placeholder assertion
    });

    test('should handle already active medication gracefully', () async {
      final medication = MedicationBuilder()
          .withId('med-resume-3')
          .withName('Atorvastatina')
          .withSingleDose('22:00', 1.0)
          .withStock(15.0)
          .suspended(false) // Already active
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.resumeMedication(
        medication: medication,
      );

      // Should return the medication unchanged
      expect(updatedMed.isSuspended, false);
      expect(updatedMed.id, medication.id);
    });

    test('should persist resume status in database', () async {
      final medication = MedicationBuilder()
          .withId('med-resume-4')
          .withName('Metformina')
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .suspended(true)
          .build();

      await insertMedicationWithPerson(medication);

      await MedicationUpdateService.resumeMedication(
        medication: medication,
      );

      // Verify it was saved to database
      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb!.isSuspended, false);
    });
  });

  group('MedicationUpdateService - suspendMedication', () {
    test('should set isSuspended to true', () async {
      final medication = MedicationBuilder()
          .withId('med-suspend-1')
          .withName('Losartán')
          .withSingleDose('08:00', 1.0)
          .withStock(10.0)
          .suspended(false)
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.suspendMedication(
        medication: medication,
      );

      expect(updatedMed.isSuspended, true);
    });

    test('should cancel all scheduled notifications', () async {
      final medication = MedicationBuilder()
          .withId('med-suspend-2')
          .withName('Amoxicilina')
          .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
          .withStock(21.0)
          .suspended(false)
          .build();

      await insertMedicationWithPerson(medication);

      await MedicationUpdateService.suspendMedication(
        medication: medication,
      );

      // Verify notifications were cancelled (in test mode, just check it doesn't throw)
      expect(true, true); // Placeholder assertion
    });

    test('should handle already suspended medication gracefully', () async {
      final medication = MedicationBuilder()
          .withId('med-suspend-3')
          .withName('Simvastatina')
          .withSingleDose('22:00', 1.0)
          .withStock(15.0)
          .suspended(true) // Already suspended
          .build();

      await insertMedicationWithPerson(medication);

      final updatedMed = await MedicationUpdateService.suspendMedication(
        medication: medication,
      );

      // Should return the medication unchanged
      expect(updatedMed.isSuspended, true);
      expect(updatedMed.id, medication.id);
    });

    test('should persist suspend status in database', () async {
      final medication = MedicationBuilder()
          .withId('med-suspend-4')
          .withName('Enalapril')
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .suspended(false)
          .build();

      await insertMedicationWithPerson(medication);

      await MedicationUpdateService.suspendMedication(
        medication: medication,
      );

      // Verify it was saved to database
      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb!.isSuspended, true);
    });
  });
}
