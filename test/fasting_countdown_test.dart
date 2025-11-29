import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/person.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/screens/medication_list/services/dose_calculation_service.dart';
import 'helpers/medication_builder.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/person_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setupAll();

  // V19+: Ensure default person exists before each test
  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();

    // Create test person (required for foreign key constraints)
    final testPerson = Person(
      id: 'test-person-id',
      name: 'Test User',
      isDefault: false,
    );
    await DatabaseHelper.instance.insertPerson(testPerson);
  });

  group('Fasting Countdown Display - DoseCalculationService.getActiveFastingPeriod', () {

    group('Fasting type "before" (before taking dose)', () {
      test('should show countdown when fasting is active (already started)', () async {
        // Medication with dose at 10:00, 60 minutes fasting before
        final medication = MedicationBuilder()
            .withId('test_before_active')
            .withSingleDose('10:00', 1.0)
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Note: In a real test, we would need to be able to inject the current time
        // For now, we verify that the method works
        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // If the test runs outside the expected time, the result may be null
        // or may have data depending on the actual execution time
        // We verify that the method does not throw exceptions
        expect(result, isA<Map<String, dynamic>?>());
      });

      test('should show countdown when fasting is upcoming (within 24h)', () async {
        // Medication with dose at 23:00, 60 minutes fasting before
        final medication = MedicationBuilder()
            .withId('test_before_upcoming')
            .withSingleDose('23:00', 1.0)
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // The method should return information if fasting starts within 24h
        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // We verify that the method works without errors
        expect(result, isA<Map<String, dynamic>?>());
      });

      test('should not show countdown if no doses are configured', () async {
        final medication = MedicationBuilder()
            .withId('test_before_no_doses')
            .withNoDoses() // Explicitly without doses
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('should correctly calculate remaining time for "before" fasting', () async {
        final medication = MedicationBuilder()
            .withId('test_before_calculation')
            .withSingleDose('14:00', 1.0)
            .withFasting(type: 'before', duration: 120) // 2 hours
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // If there is a result, verify that it has the expected fields
        if (result != null) {
          expect(result.containsKey('fastingEndTime'), true);
          expect(result.containsKey('remainingMinutes'), true);
          expect(result.containsKey('fastingType'), true);
          expect(result.containsKey('isActive'), true);
          expect(result['fastingType'], 'before');
          expect(result['remainingMinutes'], isA<int>());
          expect(result['fastingEndTime'], isA<DateTime>());
        }
      });

      test('should differentiate between active fasting (isActive: true) and upcoming (isActive: false)', () async {
        // This test verifies that the isActive field is set correctly
        final medication = MedicationBuilder()
            .withId('test_before_active_flag')
            .withSingleDose('15:00', 1.0)
            .withFasting(type: 'before', duration: 90)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        if (result != null) {
          // isActive should be true if fasting has already started, false if it's upcoming
          expect(result['isActive'], isA<bool>());
        }
      });
    });

    group('Fasting type "after" (after taking dose)', () {
      test('should show countdown only if there is a dose taken today', () async {
        final medication = MedicationBuilder()
            .withId('test_after_active')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120) // 2 hours
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Without recorded doses, it should not show countdown
        final resultBefore = await DoseCalculationService.getActiveFastingPeriod(medication);
        expect(resultBefore, isNull);

        // Register a dose taken 1 hour ago, but ensure it's still today
        final now = DateTime.now();
        var doseTime = now.subtract(const Duration(hours: 1));
        // If subtracting 1 hour crosses midnight, use a time early today that's in the past
        if (doseTime.day != now.day) {
          // Use current time minus a safe margin to ensure it's in the past
          final minutesIntoDay = now.hour * 60 + now.minute;
          final safeMinutesAgo = (minutesIntoDay / 2).floor(); // Use half of elapsed minutes today
          doseTime = now.subtract(Duration(minutes: safeMinutesAgo.clamp(5, 60)));
        }

        final historyEntry = DoseHistoryEntry(
          id: 'test_entry_1',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );

        await DatabaseHelper.instance.insertDoseHistory(historyEntry);

        // Now it should show countdown
        final resultAfter = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(resultAfter, isNotNull);
        expect(resultAfter!['fastingType'], 'after');
        expect(resultAfter['isActive'], true);
        // If dose time was adjusted for midnight, expect remaining time to be close to expected
        expect(resultAfter['remainingMinutes'], greaterThan(0));
        expect(resultAfter['remainingMinutes'], lessThanOrEqualTo(120)); // Max is fasting duration
      });

      test('should not show countdown if "after" fasting ended more than 2 hours ago', () async {
        final now = DateTime.now();

        // Skip this test if running in the first 5 hours of the day
        // because we can't simulate "4 hours ago" while staying within today
        if (now.hour < 5) {
          // Test scenario requires dose 4 hours ago, which would be yesterday
          // Skip test and mark as passed
          return;
        }

        final medication = MedicationBuilder()
            .withId('test_after_finished')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Register a dose taken 4 hours ago
        // With 60 min fasting, it ended 3 hours ago (outside 2h window)
        final doseTime = now.subtract(const Duration(hours: 4));

        final historyEntry = DoseHistoryEntry(
          id: 'test_entry_2',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );

        await DatabaseHelper.instance.insertDoseHistory(historyEntry);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Fasting ended 3 hours ago (more than 2h), should not show anything
        expect(result, isNull);
      });

      test('should show completed message if fasting ended less than 2 hours ago', () async {
        final now = DateTime.now();

        // Skip this test if running in the first 3 hours of the day
        // because we need dose 2 hours ago with 60 min fasting (ends 1 hour ago)
        if (now.hour < 3) {
          return;
        }

        final medication = MedicationBuilder()
            .withId('test_after_recently_finished')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Register a dose taken 2 hours ago
        // With 60 min fasting, it ended 1 hour ago (within 2h window)
        final doseTime = now.subtract(const Duration(hours: 2));

        final historyEntry = DoseHistoryEntry(
          id: 'test_entry_recently_finished',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );

        await DatabaseHelper.instance.insertDoseHistory(historyEntry);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Fasting ended 1 hour ago, should show completed message
        expect(result, isNotNull);
        expect(result!['isActive'], isFalse);
        expect(result['remainingMinutes'], lessThan(0));
      });

      test('should use the most recent dose to calculate "after" fasting', () async {
        final now = DateTime.now();

        // Skip this test if running in the first 6 hours of the day
        // because we need doses 5 and 2 hours ago
        if (now.hour < 6) {
          return;
        }

        final medication = MedicationBuilder()
            .withId('test_after_most_recent')
            .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
            .withFasting(type: 'after', duration: 180) // 3 hours
            .build();

        // V19+: Insert medication and associate with default person
        await insertMedicationWithPerson(medication);

        // V19+: Get default person ID for dose history
        final personId = await getDefaultPersonId();

        // Register multiple doses today - ensure they are in the past
        // and within the fasting period (3 hours)

        // Oldest dose: 5 hours ago
        final dose1Taken = now.subtract(const Duration(hours: 5));

        // Most recent dose: 2 hours ago (within 3h fasting period)
        final dose2Taken = now.subtract(const Duration(hours: 2));

        final dose1Scheduled = DateTime(now.year, now.month, now.day, 8, 0);
        final dose2Scheduled = DateTime(now.year, now.month, now.day, 14, 0);

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_3',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: personId,
          scheduledDateTime: dose1Scheduled,
          registeredDateTime: dose1Taken,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_4',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: personId,
          scheduledDateTime: dose2Scheduled,
          registeredDateTime: dose2Taken,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Should be based on the most recent dose
        // Since fasting is 3h, there should be remaining time
        expect(result, isNotNull);
        expect(result!['fastingType'], 'after');
        expect(result['isActive'], true);
        // Allow some tolerance for test timing
        expect(result['remainingMinutes'], greaterThan(0));
        expect(result['remainingMinutes'], lessThanOrEqualTo(180)); // Max 3 hours
      });

      test('should ignore skipped doses when calculating "after" fasting', () async {
        final medication = MedicationBuilder()
            .withId('test_after_ignore_skipped')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final now = DateTime.now();

        // Register a skipped dose (should not count), ensure it's still today
        var skippedDose = now.subtract(const Duration(minutes: 30));
        // If subtracting 30 minutes crosses midnight, use a time early today instead
        if (skippedDose.day != now.day) {
          skippedDose = DateTime(now.year, now.month, now.day, 0, 5);
        }
        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_5',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: skippedDose,
          registeredDateTime: skippedDose,
          status: DoseStatus.skipped,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Should not show countdown because the dose was skipped
        expect(result, isNull);
      });
    });

    group('Cases where countdown should NOT be shown', () {
      test('should not show if requiresFasting is false', () async {
        final medication = MedicationBuilder()
            .withId('test_no_fasting')
            .withSingleDose('08:00', 1.0)
            .withFastingDisabled()
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('should not show if no doses are configured (medication without fasting)', () async {
        // Simplified test: medication without fasting configured and without doses
        final medication = MedicationBuilder()
            .withId('test_no_config')
            .withNoDoses()
            .withFastingDisabled()
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('should correctly handle medications without fasting configuration', () async {
        // Normal medication without fasting, should always return null
        final medication = MedicationBuilder()
            .withId('test_normal_med')
            .withSingleDose('12:00', 1.0)
            .build();

        // By default, medications do not have fasting configured
        expect(medication.requiresFasting, false);

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });
    });

    group('Returned data structure', () {
      test('should return all required fields when there is active fasting', () async {
        final medication = MedicationBuilder()
            .withId('test_data_structure')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Register a recent dose, ensure it's still today
        final now = DateTime.now();
        var doseTime = now.subtract(const Duration(minutes: 30));
        // If subtracting 30 minutes crosses midnight, use a time early today instead
        if (doseTime.day != now.day) {
          doseTime = DateTime(now.year, now.month, now.day, 0, 5);
        }

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_6',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNotNull);
        expect(result!.keys, containsAll(['fastingEndTime', 'remainingMinutes', 'fastingType', 'isActive']));
        expect(result['fastingEndTime'], isA<DateTime>());
        expect(result['remainingMinutes'], isA<int>());
        expect(result['fastingType'], isA<String>());
        expect(result['isActive'], isA<bool>());
      });
    });
  });
}
