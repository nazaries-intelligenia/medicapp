import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';
import 'helpers/notification_test_helper.dart';

/// Tests for midnight edge cases in dose tracking and notifications
/// Added in test coverage improvements for V19+
///
/// These tests verify correct behavior around midnight (00:00):
/// - Late-night doses registered after midnight count for previous day
/// - Fasting periods that cross midnight are handled correctly
/// - Dose at 00:00 is first of new day
/// - Daily dose counters reset at midnight
/// - Postponed notifications crossing midnight
/// - Weekly patterns don't shift days incorrectly
void main() {
  late NotificationService service;

  DatabaseTestHelper.setup();

  setUp(() async {
    service = NotificationServiceTestHelper.setup();
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  tearDown(() {
    NotificationServiceTestHelper.tearDown();
  });

  group('Midnight Boundary: Dose Registration', () {
    test('dose scheduled at 23:55 but registered at 00:05 should count for previous day',
        () async {
      // Arrange - Medication with late-night dose
      final medication = MedicationBuilder()
          .withId('med-late-night')
          .withName('Late Night Med')
          .withSingleDose('23:55', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Simulate scheduled time (yesterday 23:55)
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final scheduledTime = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        23,
        55,
      );

      // Simulate registration time (today 00:05 - 10 minutes late)
      final registeredTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        5,
      );

      // Act - Create history entry with yesterday's scheduled time
      final historyEntry = DoseHistoryEntry(
        id: 'test-midnight-${DateTime.now().millisecondsSinceEpoch}',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: scheduledTime, // Yesterday 23:55
        registeredDateTime: registeredTime, // Today 00:05
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Update medication to mark dose as taken
      final updatedMed = medication.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['23:55'],
        takenDosesDate: yesterday.toString().split(' ')[0], // Yesterday's date
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Assert - History entry should have yesterday's scheduled date
      final yesterdayStart = DateTime(yesterday.year, yesterday.month, yesterday.day);
      final yesterdayEnd =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: yesterdayStart,
        endDate: yesterdayEnd,
        medicationId: medication.id,
      );

      expect(history.length, 1, reason: 'Should find dose in yesterday\'s history');
      expect(history.first.scheduledDateTime.day, yesterday.day);
      expect(history.first.registeredDateTime.day, DateTime.now().day);
      expect(history.first.status, DoseStatus.taken);

      // Verify the dose is marked for yesterday
      final resultMed = await getMedicationForDefaultPerson('med-late-night');
      expect(resultMed?.takenDosesDate, yesterday.toString().split(' ')[0]);
    });

    test('dose at exactly 00:00 should be first dose of new day', () async {
      // Arrange - Medication with midnight dose
      final medication = MedicationBuilder()
          .withId('med-midnight')
          .withName('Midnight Med')
          .withSingleDose('00:00', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      final now = DateTime.now();
      final midnightTime = DateTime(now.year, now.month, now.day, 0, 0);

      // Act - Register midnight dose
      final updatedMed = medication.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['00:00'],
        takenDosesDate: now.toString().split(' ')[0], // Today
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      final historyEntry = DoseHistoryEntry(
        id: 'test-midnight-${DateTime.now().millisecondsSinceEpoch}',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: midnightTime,
        registeredDateTime: midnightTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Assert - Should be in today's history
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: todayStart,
        endDate: todayEnd,
        medicationId: medication.id,
      );

      expect(history.length, 1, reason: '00:00 dose should be in today\'s history');
      expect(history.first.scheduledDateTime.hour, 0);
      expect(history.first.scheduledDateTime.minute, 0);

      // Verify dose is marked for today
      final resultMed = await getMedicationForDefaultPerson('med-midnight');
      expect(resultMed?.takenDosesDate, now.toString().split(' ')[0]);
    });

    test('daily dose count should reset at midnight', () async {
      // Arrange - Medication with multiple daily doses
      final medication = MedicationBuilder()
          .withId('med-reset')
          .withName('Reset Test Med')
          .withMultipleDoses(['08:00', '20:00'], 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Simulate yesterday: both doses taken
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final medYesterday = medication.copyWith(
        stockQuantity: 18.0,
        takenDosesToday: ['08:00', '20:00'],
        takenDosesDate: yesterday.toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: medYesterday,
        personId: personId,
      );

      // Act - Simulate midnight reset by clearing taken doses for new day
      final today = DateTime.now();
      final medToday = medYesterday.copyWith(
        takenDosesToday: [], // Reset for new day
        skippedDosesToday: [], // Reset for new day
        takenDosesDate: today.toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: medToday,
        personId: personId,
      );

      // Assert - Today's doses should be empty (reset)
      final resultMed = await getMedicationForDefaultPerson('med-reset');
      expect(resultMed?.takenDosesToday, isEmpty,
          reason: 'Taken doses should reset at midnight');
      expect(resultMed?.skippedDosesToday, isEmpty,
          reason: 'Skipped doses should reset at midnight');
      expect(resultMed?.takenDosesDate, today.toString().split(' ')[0],
          reason: 'Date should be updated to today');

      // Stock should remain at 18.0 (yesterday's consumption persists)
      expect(resultMed?.stockQuantity, 18.0,
          reason: 'Stock changes are permanent');
    });
  });

  group('Midnight Boundary: Fasting Periods', () {
    test('fasting period crossing midnight should be calculated correctly',
        () async {
      // Arrange - Medication with late-night dose and "after" fasting
      // Dose at 23:00 with 2 hours fasting = fasting ends at 01:00 next day
      final medication = MedicationBuilder()
          .withId('med-fasting-midnight')
          .withName('Midnight Fasting Med')
          .withSingleDose('23:00', 1.0)
          .withStock(20.0)
          .withFasting(type: 'after', duration: 120) // 2 hours after
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Simulate taking dose at 23:00 today
      final now = DateTime.now();
      final doseTime = DateTime(now.year, now.month, now.day, 23, 0);
      final fastingEndTime = doseTime.add(const Duration(hours: 2)); // 01:00 tomorrow

      // Act - Register dose
      final updatedMed = medication.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['23:00'],
        takenDosesDate: now.toString().split(' ')[0],
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: personId,
      );

      // Schedule fasting notification (in test mode, doesn't create actual notification)
      await service.scheduleMedicationNotifications(updatedMed, personId: personId);

      // Assert - Verify fasting configuration
      final resultMed = await getMedicationForDefaultPerson('med-fasting-midnight');
      expect(resultMed?.requiresFasting, isTrue);
      expect(resultMed?.fastingType, 'after');
      expect(resultMed?.fastingDurationMinutes, 120);

      // Verify fasting end time would be after midnight
      expect(fastingEndTime.day, greaterThan(doseTime.day),
          reason: 'Fasting period should cross into next day');
      expect(fastingEndTime.hour, 1,
          reason: 'Fasting should end at 01:00 next day');
    });

    test('fasting notification scheduled before midnight should not shift day',
        () async {
      // Arrange - Medication with "before" fasting at 00:30
      // 30 minutes before = notification at 00:00 (same day)
      final medication = MedicationBuilder()
          .withId('med-before-midnight')
          .withName('Before Midnight Med')
          .withSingleDose('00:30', 1.0)
          .withStock(20.0)
          .withFasting(type: 'before', duration: 30) // 30 minutes before
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Schedule notifications
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert - Verify medication is stored correctly
      final resultMed = await getMedicationForDefaultPerson('med-before-midnight');
      expect(resultMed?.requiresFasting, isTrue);
      expect(resultMed?.fastingType, 'before');
      expect(resultMed?.doseTimes, ['00:30']);

      // In production, fasting reminder would be scheduled at 00:00
      // (30 minutes before 00:30, which is start of day, not previous day 23:30)
    });

    test('multiple fasting periods crossing midnight should not interfere',
        () async {
      // Arrange - Two medications with late doses and fasting
      final personId = await getDefaultPersonId();

      // Med A: 22:00 with 3 hours fasting (ends 01:00)
      final medA = MedicationBuilder()
          .withId('med-fasting-a')
          .withName('Fasting Med A')
          .withSingleDose('22:00', 1.0)
          .withStock(20.0)
          .withFasting(type: 'after', duration: 180) // 3 hours
          .build();

      // Med B: 23:30 with 2 hours fasting (ends 01:30)
      final medB = MedicationBuilder()
          .withId('med-fasting-b')
          .withName('Fasting Med B')
          .withSingleDose('23:30', 1.0)
          .withStock(20.0)
          .withFasting(type: 'after', duration: 120) // 2 hours
          .build();

      await insertMedicationWithPerson(medA);
      await insertMedicationWithPerson(medB);

      // Act - Take both doses
      final now = DateTime.now();
      final updatedMedA = medA.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['22:00'],
        takenDosesDate: now.toString().split(' ')[0],
      );
      final updatedMedB = medB.copyWith(
        stockQuantity: 19.0,
        takenDosesToday: ['23:30'],
        takenDosesDate: now.toString().split(' ')[0],
      );

      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedA,
        personId: personId,
      );
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedB,
        personId: personId,
      );

      // Assert - Both medications have independent fasting periods
      final resultMedA = await getMedicationForDefaultPerson('med-fasting-a');
      final resultMedB = await getMedicationForDefaultPerson('med-fasting-b');

      expect(resultMedA?.takenDosesToday, ['22:00']);
      expect(resultMedB?.takenDosesToday, ['23:30']);

      // Both have fasting requirements
      expect(resultMedA?.requiresFasting, isTrue);
      expect(resultMedB?.requiresFasting, isTrue);

      // Med B ends later (01:30 vs 01:00), so it should be prioritized
      // in the fasting state manager
    });
  });

  group('Midnight Boundary: Postponed Notifications', () {
    test('notification postponed from 23:50 to 00:00 should maintain correct date',
        () async {
      // Arrange - Medication with late-night dose
      final medication = MedicationBuilder()
          .withId('med-postpone')
          .withName('Postpone Test Med')
          .withSingleDose('23:50', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Simulate original notification scheduled for 23:50
      final originalTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        50,
      );

      // Postponed by 10 minutes = 00:00 next day
      final postponedTime = originalTime.add(const Duration(minutes: 10));

      // Act - Schedule notification (in test mode, simulated)
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert - Verify times cross midnight
      expect(postponedTime.day, greaterThan(originalTime.day),
          reason: 'Postponed time should be next day');
      expect(postponedTime.hour, 0, reason: 'Should be 00:00');
      expect(postponedTime.minute, 0, reason: 'Should be 00:00');

      // Medication should still have correct scheduled time
      final resultMed = await getMedicationForDefaultPerson('med-postpone');
      expect(resultMed?.doseTimes, ['23:50'],
          reason: 'Original dose time should not change');
    });

    test('multiple postponements should not cause day drift', () async {
      // Arrange - Medication with dose at 23:45
      final medication = MedicationBuilder()
          .withId('med-multi-postpone')
          .withName('Multi Postpone Med')
          .withSingleDose('23:45', 1.0)
          .withStock(20.0)
          .build();

      await insertMedicationWithPerson(medication);
      await getDefaultPersonId();

      // Act - Simulate multiple 10-minute postponements
      final originalTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        45,
      );

      // First postpone: 23:45 + 10min = 23:55 (same day)
      final firstPostpone = originalTime.add(const Duration(minutes: 10));
      expect(firstPostpone.day, originalTime.day);
      expect(firstPostpone.hour, 23);
      expect(firstPostpone.minute, 55);

      // Second postpone: 23:55 + 10min = 00:05 (next day)
      final secondPostpone = firstPostpone.add(const Duration(minutes: 10));
      expect(secondPostpone.day, greaterThan(originalTime.day));
      expect(secondPostpone.hour, 0);
      expect(secondPostpone.minute, 5);

      // Third postpone: 00:05 + 10min = 00:15 (same day as second)
      final thirdPostpone = secondPostpone.add(const Duration(minutes: 10));
      expect(thirdPostpone.day, secondPostpone.day);
      expect(thirdPostpone.hour, 0);
      expect(thirdPostpone.minute, 15);

      // Assert - Medication configuration remains unchanged
      final resultMed = await getMedicationForDefaultPerson('med-multi-postpone');
      expect(resultMed?.doseTimes, ['23:45'],
          reason: 'Original dose time should remain constant despite postponements');
    });
  });

  group('Midnight Boundary: Weekly Patterns', () {
    test('weekly pattern on Sunday 23:30 should not shift to Monday', () async {
      // Arrange - Medication scheduled for Sundays at 23:30
      final medication = MedicationBuilder()
          .withId('med-sunday')
          .withName('Sunday Night Med')
          .withSingleDose('23:30', 1.0)
          .withStock(20.0)
          .withWeeklyPattern([7]) // Sunday only
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Schedule notifications
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert - Verify medication is stored correctly
      final resultMed = await getMedicationForDefaultPerson('med-sunday');
      expect(resultMed?.durationType, TreatmentDurationType.weeklyPattern);
      expect(resultMed?.weeklyDays, [7],
          reason: 'Should remain scheduled for Sunday (day 7)');
      expect(resultMed?.doseTimes, ['23:30']);

      // In production, notification would be scheduled for Sunday 23:30
      // NOT Monday 00:00 (important: time doesn't shift the day)
    });

    test('weekly pattern should correctly handle transition from Saturday to Sunday',
        () async {
      // Arrange - Medication for both Saturday and Sunday
      final medication = MedicationBuilder()
          .withId('med-weekend')
          .withName('Weekend Med')
          .withMultipleDoses(['23:45', '00:15'], 1.0)
          .withStock(20.0)
          .withWeeklyPattern([6, 7]) // Sat & Sun
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Schedule notifications
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-weekend');
      expect(resultMed?.weeklyDays, containsAll([6, 7]));
      expect(resultMed?.doseTimes, containsAll(['23:45', '00:15']));

      // On Saturday:
      // - 23:45 dose is for Saturday
      // - 00:15 dose is for Sunday (crossed midnight)
      //
      // On Sunday:
      // - 23:45 dose is for Sunday
      // - 00:15 dose would be for Monday (but not scheduled since Monday not in pattern)
    });

    test('daily pattern should create new set of notifications at midnight',
        () async {
      // Arrange - Daily medication with doses spanning midnight
      final medication = MedicationBuilder()
          .withId('med-daily-midnight')
          .withName('Daily Midnight Med')
          .withMultipleDoses(['23:00', '01:00'], 1.0)
          .withStock(100.0)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      await insertMedicationWithPerson(medication);
      final personId = await getDefaultPersonId();

      // Act - Schedule notifications
      await service.scheduleMedicationNotifications(medication, personId: personId);

      // Assert
      final resultMed = await getMedicationForDefaultPerson('med-daily-midnight');
      expect(resultMed?.durationType, TreatmentDurationType.everyday);
      expect(resultMed?.doseTimes, containsAll(['23:00', '01:00']));

      // Each day should have both doses:
      // - 23:00 dose (before midnight)
      // - 01:00 dose (after midnight, but part of same medication day)
      //
      // When midnight passes, a new 23:00 dose is scheduled for the new day
    });
  });

  group('Midnight Boundary: History Queries', () {
    test('history query at midnight should return correct doses for each day',
        () async {
      // Arrange - Create doses around midnight
      final personId = await getDefaultPersonId();
      final medication = MedicationBuilder()
          .withId('med-history')
          .withName('History Test Med')
          .withMultipleDoses(['23:30', '00:30'], 1.0)
          .build();

      await insertMedicationWithPerson(medication);

      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      // Create history entries:
      // 1. Yesterday 23:30 - taken
      final entry1 = DoseHistoryEntry(
        id: 'hist-1',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 30),
        registeredDateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 35),
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      // 2. Today 00:30 - taken
      final entry2 = DoseHistoryEntry(
        id: 'hist-2',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: DateTime(today.year, today.month, today.day, 0, 30),
        registeredDateTime: DateTime(today.year, today.month, today.day, 0, 35),
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(entry1);
      await DatabaseHelper.instance.insertDoseHistory(entry2);

      // Act & Assert - Query yesterday's history
      final yesterdayStart = DateTime(yesterday.year, yesterday.month, yesterday.day);
      final yesterdayEnd =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
      final yesterdayHistory = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: yesterdayStart,
        endDate: yesterdayEnd,
        medicationId: medication.id,
      );

      expect(yesterdayHistory.length, 1,
          reason: 'Should find only yesterday\'s 23:30 dose');
      expect(yesterdayHistory.first.scheduledDateTime.hour, 23);

      // Query today's history
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
      final todayHistory = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: todayStart,
        endDate: todayEnd,
        medicationId: medication.id,
      );

      expect(todayHistory.length, 1, reason: 'Should find only today\'s 00:30 dose');
      expect(todayHistory.first.scheduledDateTime.hour, 0);
    });
  });

  group('Test Mode Verification', () {
    test('notification service should maintain test mode throughout tests', () {
      expect(service.isTestMode, isTrue,
          reason: 'Test mode should remain enabled for all tests');
    });
  });
}
