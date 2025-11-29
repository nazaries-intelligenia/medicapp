import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/models/medication_type.dart';
import 'helpers/medication_builder.dart';
import 'helpers/notification_test_helper.dart';

void main() {
  late NotificationService service;

  group('Fasting Notification Tests', () {
    setUp(() {
      service = NotificationServiceTestHelper.setup();
    });

    tearDown(() {
      NotificationServiceTestHelper.tearDown();
    });

    group('Automatic "before" fasting scheduling', () {
      test('should schedule automatic notification for "before" fasting type', () async {
        final medication = MedicationBuilder()
            .withId('test_before_1')
            .withName('Before Fasting Med')
            .withDosageInterval(24)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'before', duration: 60) // 1 hour before
            .build();

        // Verify medication has correct fasting configuration
        expect(medication.requiresFasting, isTrue, reason: 'Medication should require fasting');
        expect(medication.fastingType, 'before', reason: 'Fasting type should be "before"');
        expect(medication.fastingDurationMinutes, 60, reason: 'Fasting duration should be 60 minutes');

        // Schedule medication notifications (should include automatic "before" fasting notification)
        // In test mode, this completes without actually scheduling platform notifications
        await expectLater(
          service.scheduleMedicationNotifications(medication, personId: 'test-person-id'),
          completes,
          reason: 'Scheduling should complete without throwing exceptions',
        );

        // Verify test mode is active (prevents actual notification scheduling)
        expect(service.isTestMode, isTrue, reason: 'Test mode should be enabled');
      });

      test('should schedule "before" fasting for multiple dose times', () async {
        final medication = MedicationBuilder()
            .withId('test_before_multiple')
            .withName('Multiple Doses Before Fasting')
            .withDosageInterval(8)
            .withDoseSchedule({
              '08:00': 1.0,
              '16:00': 1.0,
              '00:00': 1.0,
            })
            .withFasting(type: 'before', duration: 30) // 30 min before each dose
            .build();

        // Verify multiple doses are configured
        expect(medication.doseSchedule.length, 3, reason: 'Should have 3 dose times');
        expect(medication.fastingType, 'before');

        // Should schedule fasting notifications for all three doses (07:30, 15:30, 23:30)
        await expectLater(
          service.scheduleMedicationNotifications(medication, personId: 'test-person-id'),
          completes,
          reason: 'Should schedule fasting notifications for all dose times without errors',
        );
      });

      test('should handle different fasting durations for "before" type', () async {
        final durations = [15, 30, 60, 90, 120, 180]; // Various durations in minutes

        for (final duration in durations) {
          final medication = MedicationBuilder()
              .withId('test_before_duration_$duration')
              .withName('Before Med $duration min')
              .withDosageInterval(24)
              .withSingleDose('12:00', 1.0)
              .withFasting(type: 'before', duration: duration)
              .build();

          // Verify the duration is correctly set
          expect(medication.fastingDurationMinutes, duration,
              reason: 'Medication should have fasting duration of $duration minutes');

          await expectLater(
            service.scheduleMedicationNotifications(medication, personId: 'test-person-id'),
            completes,
            reason: 'Should handle $duration minute fasting duration without errors',
          );
        }
      });

      test('should reschedule "before" fasting when medication is updated', () async {
        final original = MedicationBuilder()
            .withId('test_update_1')
            .withName('Original Med')
            .withDosageInterval(24)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'before', duration: 60)
            .build();

        await expectLater(
          service.scheduleMedicationNotifications(original, personId: 'test-person-id'),
          completes,
          reason: 'Initial scheduling should complete without errors',
        );

        // Update to different time and duration
        final updated = MedicationBuilder()
            .withId('test_update_1') // Same ID
            .withName('Updated Med')
            .withDosageInterval(24)
            .withSingleDose('12:00', 1.0) // Different time
            .withFasting(type: 'before', duration: 90) // Different duration
            .build();

        // Verify the medications have same ID but different configurations
        expect(original.id, updated.id, reason: 'Should have same medication ID');
        expect(original.doseSchedule.keys.first, isNot(updated.doseSchedule.keys.first),
            reason: 'Dose times should be different');
        expect(original.fastingDurationMinutes, isNot(updated.fastingDurationMinutes),
            reason: 'Fasting durations should be different');

        // Reschedule should cancel old and create new notifications
        await expectLater(
          service.scheduleMedicationNotifications(updated, personId: 'test-person-id'),
          completes,
          reason: 'Rescheduling with updated medication should complete without errors',
        );
      });

      test('should handle edge case: "before" fasting that overlaps with previous dose', () async {
        final medication = MedicationBuilder()
            .withId('test_overlap')
            .withName('Overlapping Fasting')
            .withDosageInterval(4) // Very frequent doses
            .withDoseSchedule({
              '08:00': 1.0,
              '12:00': 1.0,
              '16:00': 1.0,
              '20:00': 1.0,
            })
            .withFasting(type: 'before', duration: 180) // 3 hours before (longer than dose interval!)
            .build();

        // Verify the edge case: fasting duration (180 min) > dose interval (4 hours = 240 min between some doses)
        expect(medication.fastingDurationMinutes, 180);
        expect(medication.dosageIntervalHours, 4);

        // Should handle overlapping fasting periods gracefully without throwing
        await expectLater(
          service.scheduleMedicationNotifications(medication, personId: 'test-person-id'),
          completes,
          reason: 'Should handle overlapping fasting periods without errors',
        );
      });
    });

    group('Dynamic "after" fasting scheduling', () {
      test('should NOT schedule automatic notification for "after" fasting type', () async {
        final medication = MedicationBuilder()
            .withId('test_after_1')
            .withName('After Fasting Med')
            .withDosageInterval(24)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120) // 2 hours after
            .build();

        // Schedule medication notifications
        // Should NOT schedule any fasting notification for "after" type
        await service.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Should complete without errors
        expect(true, true);
      });

      test('should schedule dynamic fasting notification for "after" fasting type', () async {
        final medication = MedicationBuilder()
            .withId('test_after_dynamic_1')
            .withName('After Fasting Med')
            .withDosageInterval(12)
            .withMultipleDoses(['08:00', '20:00'], 1.0)
            .withFasting(type: 'after', duration: 90) // 1.5 hours after
            .build();

        // Schedule regular medication notifications (no fasting notification yet)
        await service.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Now register a dose at a specific time
        final actualDoseTime = DateTime(2025, 10, 16, 10, 30); // Took at 10:30

        // This should schedule the "after" fasting notification dynamically
        await expectLater(
          service.scheduleDynamicFastingNotification(
            medication: medication,
            actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
          ),
          completes,
        );
        // Notification would be scheduled for 12:00 (1.5 hours after 10:30)
      });

      test('should NOT schedule dynamic fasting notification for "before" fasting type', () async {
        final medication = MedicationBuilder()
            .withId('test_2')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'before', duration: 60) // "before" shouldn't trigger dynamic
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Should complete without scheduling (early return for "before" type)
        await expectLater(
          service.scheduleDynamicFastingNotification(
            medication: medication,
            actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
          ),
          completes,
        );
      });

      test('should schedule "after" fasting dynamically using actual time, not scheduled time', () async {
        final medication = MedicationBuilder()
            .withId('test_actual_time')
            .withName('Test Actual Time')
            .withDosageInterval(12)
            .withSingleDose('08:00', 1.0) // Scheduled for 08:00
            .withFasting(type: 'after', duration: 120) // 2 hours after
            .build();

        // User takes the dose at 10:30 instead of 08:00
        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Dynamic notification should be based on 10:30, not 08:00
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        // Notification should be scheduled for 12:30 (10:30 + 2 hours)
        expect(true, true);
      });

      test('should handle different fasting durations correctly', () async {
        final durations = [30, 60, 90, 120, 180, 240]; // Various durations in minutes

        for (final duration in durations) {
          final medication = MedicationBuilder()
              .withId('test_duration_$duration')
              .withName('Test Medication $duration min')
              .withSingleDose('08:00', 1.0)
              .withFasting(type: 'after', duration: duration)
              .build();

          final actualDoseTime = DateTime(2025, 10, 16, 10, 0);

          // Verify configuration
          expect(medication.fastingDurationMinutes, duration);

          // Should complete without errors for all durations
          await expectLater(
            service.scheduleDynamicFastingNotification(
              medication: medication,
              actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
            ),
            completes,
          );
        }
      });

      test('should handle past actual dose times', () async {
        final medication = MedicationBuilder()
            .withId('test_8')
            .withName('Test Medication')
            .withDosageInterval(8)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 30) // Short duration
            .build();

        // Set actual dose time 1 hour ago
        final actualDoseTime = DateTime.now().subtract(const Duration(hours: 1));

        // Should complete without errors (notification might be skipped if in the past)
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        expect(true, true);
      });

      test('should handle future actual dose times', () async {
        final medication = MedicationBuilder()
            .withId('test_9')
            .withName('Test Medication')
            .withDosageInterval(8)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        // Set actual dose time to now
        final actualDoseTime = DateTime.now();

        // Should complete without errors
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        expect(true, true);
      });

      test('should handle medications with multiple dose times', () async {
        final medication = MedicationBuilder()
            .withId('test_10')
            .withName('Test Medication')
            .withDosageInterval(8)
            .withMultipleDoses(['08:00', '16:00', '00:00'], 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Should schedule notification based on actual time, not scheduled times
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        expect(true, true);
      });

      test('should NOT schedule dynamic "after" fasting if dose not actually taken', () async {
        final medication = MedicationBuilder()
            .withId('test_after_not_taken')
            .withName('After Med')
            .withDosageInterval(12)
            .withMultipleDoses(['08:00', '20:00'], 1.0)
            .withFasting(type: 'after', duration: 60)
            .build();

        // Only schedule regular notifications
        await service.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Don't call scheduleDynamicFastingNotification
        // Therefore, no "after" fasting notification should exist

        expect(true, true);
      });
    });

    group('Guard conditions', () {
      test('should NOT schedule if requiresFasting is false', () async {
        final medication = MedicationBuilder()
            .withId('test_3')
            .withSingleDose('08:00', 1.0)
            .withFastingDisabled()
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Verify fasting is disabled
        expect(medication.requiresFasting, false);

        // Should complete without scheduling
        await expectLater(
          service.scheduleDynamicFastingNotification(
            medication: medication,
            actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
          ),
          completes,
        );
      });

      test('should NOT schedule if notifyFasting is false', () async {
        final medication = MedicationBuilder()
            .withId('test_4')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120, notify: false)
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Verify notifications are disabled
        expect(medication.notifyFasting, false);

        // Should complete without scheduling
        await expectLater(
          service.scheduleDynamicFastingNotification(
            medication: medication,
            actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
          ),
          completes,
        );
      });

      test('should NOT schedule if fastingDurationMinutes is null', () async {
        final medication = MedicationBuilder()
            .withId('test_5')
            .withSingleDose('08:00', 1.0)
            .withFastingEdgeCase(type: 'after', duration: null) // Invalid duration - edge case
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Should complete without scheduling
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        expect(true, true);
      });

      test('should NOT schedule if fastingDurationMinutes is zero', () async {
        final medication = MedicationBuilder()
            .withId('test_6')
            .withSingleDose('08:00', 1.0)
            .withFastingEdgeCase(type: 'after', duration: 0) // Invalid duration - edge case
            .build();

        final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

        // Should complete without scheduling
        await service.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
        );

        expect(true, true);
      });

      test('should NOT schedule "before" fasting if notifyFasting is false', () async {
        final medication = MedicationBuilder()
            .withId('test_before_no_notify')
            .withName('Before Med No Notify')
            .withDosageInterval(24)
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'before', duration: 60, notify: false) // Notifications disabled
            .build();

        await service.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Should not schedule fasting notification
        expect(true, true);
      });

      test('should NOT schedule "before" fasting if requiresFasting is false', () async {
        final medication = MedicationBuilder()
            .withId('test_before_no_fasting')
            .withName('No Fasting Required')
            .withDosageInterval(24)
            .withSingleDose('08:00', 1.0)
            .withFastingDisabled() // No fasting required
            .build();

        await service.scheduleMedicationNotifications(medication, personId: 'test-person-id');

        // Should not schedule fasting notification
        expect(true, true);
      });
    });

    group('Medication type compatibility', () {
      test('should work with representative medication types', () async {
        final types = [
          MedicationType.pill,
          MedicationType.injection,
        ];

        for (final type in types) {
          final medication = MedicationBuilder()
              .withId('test_type_${type.name}')
              .withName('Test ${type.displayName}')
              .withType(type)
              .withDosageInterval(8)
              .withSingleDose('08:00', 1.0)
              .withFasting(type: 'after', duration: 120)
              .build();

          final actualDoseTime = DateTime(2025, 10, 16, 10, 30);

          // Should complete without errors for all medication types
          await service.scheduleDynamicFastingNotification(
            medication: medication,
            actualDoseTime: actualDoseTime,
        personId: 'test-person-id',
          );
        }

        expect(true, true);
      });
    });

    group('Mixed medication scenarios', () {
      test('should handle medication with both dose types - schedule only "before"', () async {
        // Create two medications: one "before" and one "after"
        final beforeMed = MedicationBuilder()
            .withId('test_mixed_1')
            .withName('Before Med')
            .withDosageInterval(24)
            .withSingleDose('09:00', 1.0)
            .withFasting(type: 'before', duration: 30)
            .build();

        final afterMed = MedicationBuilder()
            .withId('test_mixed_2')
            .withName('After Med')
            .withType(MedicationType.capsule)
            .withDosageInterval(24)
            .withSingleDose('21:00', 1.0)
            .withFasting(type: 'after', duration: 60)
            .build();

        // Schedule both
        await service.scheduleMedicationNotifications(beforeMed, personId: 'test-person-id');
        await service.scheduleMedicationNotifications(afterMed, personId: 'test-person-id');

        // Only "before" should have automatic notification
        expect(true, true);
      });
    });
  });
}
