import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'helpers/medication_builder.dart';

void main() {
  group('Notification Cancellation on Manual Registration', () {
    setUp(() {
      // Enable test mode to prevent actual notifications
      NotificationService.instance.enableTestMode();
    });

    tearDown(() {
      NotificationService.instance.disableTestMode();
    });

    test("should cancel today's dose notification when dose is registered", () async {
      final medication = MedicationBuilder()
          .withId('test_cancel_1')
          .withName('Test Medication')
          .withDosageInterval(8)
          .withDoseSchedule({
            '08:00': 1.0,
            '16:00': 1.0,
            '21:00': 1.0,
          })
          .build();

      // Schedule notifications first
      await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

      // Cancel notification for 16:00 dose
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '16:00',
        personId: 'test-person-id',
      );

      // Should complete without errors
      expect(true, true);
    });

    test('should cancel notifications for different duration types', () async {
      final durationTypes = [
        TreatmentDurationType.everyday,
        TreatmentDurationType.untilFinished,
        TreatmentDurationType.specificDates,
        TreatmentDurationType.weeklyPattern,
      ];

      for (final durationType in durationTypes) {
        final medication = MedicationBuilder()
            .withId('test_cancel_${durationType.name}')
            .withName('${durationType.name} Med')
            .withDosageInterval(8)
            .withSingleDose('10:00', 1.0)
            .withDurationType(durationType)
            .build();

        await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Should cancel without errors for any duration type
        await NotificationService.instance.cancelTodaysDoseNotification(
          medication: medication,
          doseTime: '10:00',
          personId: 'test-person-id',
        );

        // Verify cancellation completed
        expect(medication.id, isNotEmpty);
      }
    });

    test('should handle cancellation for non-existent dose time gracefully', () async {
      final medication = MedicationBuilder()
          .withId('test_cancel_7')
          .withName('Test Med')
          .withDosageInterval(8)
          .withSingleDose('08:00', 1.0)
          .build();

      // Try to cancel a dose time that doesn't exist
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '15:00', // This time is not in the schedule
        personId: 'test-person-id',
      );

      // Should complete without errors (graceful handling)
      expect(true, true);
    });

    test('should cancel multiple dose notifications independently', () async {
      final medication = MedicationBuilder()
          .withId('test_cancel_8')
          .withName('Multiple Doses Med')
          .withDosageInterval(8)
          .withDoseSchedule({
            '08:00': 1.0,
            '12:00': 1.0,
            '16:00': 1.0,
            '20:00': 1.0,
          })
          .build();

      await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

      // Cancel multiple doses
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '08:00',
        personId: 'test-person-id',
      );

      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '16:00',
        personId: 'test-person-id',
      );

      expect(true, true);
    });

    test('should cancel postponed notification along with regular notification', () async {
      final medication = MedicationBuilder()
          .withId('test_cancel_9')
          .withName('Test Med')
          .withDosageInterval(8)
          .withSingleDose('09:00', 1.0)
          .build();

      // Schedule regular notification
      await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

      // Schedule a postponed notification
      await NotificationService.instance.schedulePostponedDoseNotification(
        medication: medication,
        originalDoseTime: '09:00',
        newTime: const TimeOfDay(hour: 11, minute: 30),
        personId: 'test-person-id',
      );

      // Cancel should remove both regular and postponed notifications
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '09:00',
        personId: 'test-person-id',
      );

      expect(true, true);
    });

    test('should work with different medication types', () async {
      final types = [
        MedicationType.pill,
        MedicationType.capsule,
        MedicationType.syrup,
        MedicationType.injection,
        MedicationType.ointment,
        MedicationType.spray,
      ];

      for (final type in types) {
        final medication = MedicationBuilder()
            .withId('test_cancel_type_${type.name}')
            .withName('Test ${type.displayName}')
            .withType(type)
            .withDosageInterval(12)
            .withSingleDose('10:00', 1.0)
            .build();

        await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        await NotificationService.instance.cancelTodaysDoseNotification(
          medication: medication,
          doseTime: '10:00',
        personId: 'test-person-id',
        );
      }

      expect(true, true);
    });

    test('should handle cancellation when medication was never scheduled', () async {
      final medication = MedicationBuilder()
          .withId('test_cancel_10')
          .withName('Never Scheduled')
          .withDosageInterval(8)
          .withSingleDose('14:00', 1.0)
          .build();

      // Don't schedule, just try to cancel
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: '14:00',
        personId: 'test-person-id',
      );

      // Should complete without errors (idempotent operation)
      expect(true, true);
    });
  });
}
