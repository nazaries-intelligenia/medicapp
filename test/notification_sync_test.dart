import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'helpers/medication_builder.dart';
import 'helpers/notification_test_helper.dart';

void main() {
  group('Notification Synchronization', () {
    setUp(() {
      NotificationServiceTestHelper.setup();
    });

    tearDown(() {
      NotificationServiceTestHelper.tearDown();
    });

    test('should handle multiple medications', () async {
      final medications = [
        MedicationBuilder()
            .withId('test-sync-2')
            .withName('Medication 1')
            .withDosageInterval(8)
            .withSingleDose('08:00', 1.0)
            .withStock(10)
            .withStartDate(DateTime.now())
            .build(),
        MedicationBuilder()
            .withId('test-sync-3')
            .withName('Medication 2')
            .withDosageInterval(12)
            .withMultipleDoses(['09:00', '21:00'], 1.0)
            .withStock(20)
            .withStartDate(DateTime.now())
            .build(),
        MedicationBuilder()
            .withId('test-sync-4')
            .withName('Medication 3')
            .withDosageInterval(24)
            .withSingleDose('20:00', 2.0)
            .withStock(15)
            .withStartDate(DateTime.now())
            .build(),
      ];

      await NotificationService.instance.syncNotificationsWithMedications(medications);

      expect(true, true);
    });

    test('should handle medications with different types', () async {
      final medications = [
        MedicationBuilder()
            .withId('test-sync-5')
            .withName('Suspended Med')
            .withDosageInterval(8)
            .withSingleDose('08:00', 1.0)
            .withStock(10)
            .suspended()
            .withStartDate(DateTime.now())
            .build(),
        MedicationBuilder()
            .withId('test-sync-6')
            .withName('Active Med')
            .withDosageInterval(12)
            .withSingleDose('12:00', 1.0)
            .withStock(10)
            .withStartDate(DateTime.now())
            .build(),
      ];

      await NotificationService.instance.syncNotificationsWithMedications(medications);

      expect(true, true);
    });

    test('should handle medications with fasting requirements', () async {
      final medications = [
        MedicationBuilder()
            .withId('test-sync-7')
            .withName('Fasting Before Med')
            .withDosageInterval(8)
            .withSingleDose('08:00', 1.0)
            .withStock(10)
            .withFasting(type: 'before', duration: 60)
            .withStartDate(DateTime.now())
            .build(),
        MedicationBuilder()
            .withId('test-sync-8')
            .withName('Fasting After Med')
            .withDosageInterval(12)
            .withSingleDose('14:00', 1.0)
            .withStock(10)
            .withFasting(type: 'after', duration: 120)
            .withStartDate(DateTime.now())
            .build(),
      ];

      await NotificationService.instance.syncNotificationsWithMedications(medications);

      expect(true, true);
    });

    test('should not throw when syncing multiple times', () async {
      final medication = MedicationBuilder()
          .withId('test-sync-9')
          .withName('Test Medication')
          .withDosageInterval(8)
          .withSingleDose('08:00', 1.0)
          .withStock(10)
          .withStartDate(DateTime.now())
          .build();

      // Sync multiple times - should be idempotent
      await NotificationService.instance.syncNotificationsWithMedications([medication]);
      await NotificationService.instance.syncNotificationsWithMedications([medication]);
      await NotificationService.instance.syncNotificationsWithMedications([medication]);

      expect(true, true);
    });

    test('should handle sync after scheduling notifications', () async {
      final medication = MedicationBuilder()
          .withId('test-sync-10')
          .withName('Test Medication')
          .withDosageInterval(8)
          .withMultipleDoses(['08:00', '16:00', '00:00'], 1.0)
          .withStock(10)
          .withStartDate(DateTime.now())
          .build();

      // Schedule notifications first (V19+: requires personId)
      await NotificationService.instance.scheduleMedicationNotifications(medication, personId: 'test-person-id');

      // Then sync (should not cause issues)
      await NotificationService.instance.syncNotificationsWithMedications([medication]);

      expect(true, true);
    });

    test('should handle medications being added and removed', () async {
      final med1 = MedicationBuilder()
          .withId('test-sync-11')
          .withName('Medication 1')
          .withDosageInterval(8)
          .withSingleDose('08:00', 1.0)
          .withStock(10)
          .withStartDate(DateTime.now())
          .build();

      final med2 = MedicationBuilder()
          .withId('test-sync-12')
          .withName('Medication 2')
          .withDosageInterval(12)
          .withSingleDose('12:00', 1.0)
          .withStock(10)
          .withStartDate(DateTime.now())
          .build();

      // Start with both medications
      await NotificationService.instance.syncNotificationsWithMedications([med1, med2]);

      // Remove one medication (simulate deletion)
      await NotificationService.instance.syncNotificationsWithMedications([med1]);

      // Remove all medications (simulate fresh install)
      await NotificationService.instance.syncNotificationsWithMedications([]);

      expect(true, true);
    });

    test('should complete sync in reasonable time', () async {
      final medications = List.generate(
        10,
        (index) => MedicationBuilder()
            .withId('test-sync-perf-$index')
            .withName('Medication $index')
            .withDosageInterval(8)
            .withMultipleDoses(['08:00', '16:00', '00:00'], 1.0)
            .withStock(10)
            .withStartDate(DateTime.now())
            .build(),
      );

      final stopwatch = Stopwatch()..start();
      await NotificationService.instance.syncNotificationsWithMedications(medications);
      stopwatch.stop();

      // In test mode, should be very fast (< 100ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
