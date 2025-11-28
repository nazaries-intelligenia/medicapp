import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/services/notification_service.dart';
import 'medication_builder.dart';

/// Helper to test dynamic fasting notification scheduling.
///
/// This helper simplifies repetitive tests that create medications and
/// schedule dynamic fasting notifications.
///
/// Usage example:
/// ```dart
/// await testNotificationScheduling(
///   medicationId: 'test_after_1',
///   fastingType: 'after',
///   fastingDuration: 120,
///   actualDoseTime: DateTime(2025, 10, 16, 10, 30),
/// );
/// ```
Future<void> testNotificationScheduling({
  required String medicationId,
  required String fastingType,
  required int fastingDuration,
  required DateTime actualDoseTime,
  String personId = 'test-person-id',
  String? medicationName,
  int dosageInterval = 12,
  String doseTime = '08:00',
  double doseQuantity = 1.0,
  bool notifyFasting = true,
}) async {
  final medication = MedicationBuilder()
      .withId(medicationId)
      .withName(medicationName ?? 'Test Medication $medicationId')
      .withDosageInterval(dosageInterval)
      .withSingleDose(doseTime, doseQuantity)
      .withFasting(type: fastingType, duration: fastingDuration, notify: notifyFasting)
      .build();

  await expectLater(
    NotificationService.instance.scheduleDynamicFastingNotification(
      medication: medication,
      actualDoseTime: actualDoseTime,
      personId: personId,
    ),
    completes,
  );
}

/// Helper to test automatic scheduling of "before" notifications.
///
/// This helper simplifies tests that schedule automatic notifications
/// for medications with "before" fasting type.
///
/// Usage example:
/// ```dart
/// await testBeforeNotificationScheduling(
///   medicationId: 'test_before_1',
///   fastingDuration: 60,
///   doseTime: '08:00',
/// );
/// ```
Future<void> testBeforeNotificationScheduling({
  required String medicationId,
  required int fastingDuration,
  String personId = 'test-person-id',
  String? medicationName,
  int dosageInterval = 24,
  String doseTime = '08:00',
  double doseQuantity = 1.0,
  Map<String, double>? doseSchedule,
  bool notifyFasting = true,
}) async {
  final builder = MedicationBuilder()
      .withId(medicationId)
      .withName(medicationName ?? 'Before Fasting Med')
      .withDosageInterval(dosageInterval)
      .withFasting(type: 'before', duration: fastingDuration, notify: notifyFasting);

  if (doseSchedule != null) {
    builder.withDoseSchedule(doseSchedule);
  } else {
    builder.withSingleDose(doseTime, doseQuantity);
  }

  final medication = builder.build();

  await NotificationService.instance.scheduleMedicationNotifications(
    medication,
    personId: personId,
  );
}

/// Helper to test edge cases of medications without valid fasting.
///
/// This helper simplifies tests that verify behavior when
/// the medication does not have a valid fasting configuration.
///
/// Usage example:
/// ```dart
/// await testInvalidFastingConfig(
///   medicationId: 'test_no_fasting',
///   requiresFasting: false,
///   actualDoseTime: DateTime(2025, 10, 16, 10, 30),
/// );
/// ```
Future<void> testInvalidFastingConfig({
  required String medicationId,
  required DateTime actualDoseTime,
  String personId = 'test-person-id',
  bool requiresFasting = false,
  String? fastingType,
  int? fastingDuration,
  bool notifyFasting = true,
  String doseTime = '08:00',
  double doseQuantity = 1.0,
}) async {
  final builder = MedicationBuilder()
      .withId(medicationId)
      .withSingleDose(doseTime, doseQuantity);

  late Medication medication;

  if (!requiresFasting) {
    medication = builder.withFastingDisabled().build();
  } else if (fastingDuration == null || fastingDuration == 0) {
    // Use edge case builder for invalid durations
    medication = builder
        .withFastingEdgeCase(
          type: fastingType ?? 'after',
          duration: fastingDuration,
          notify: notifyFasting,
        )
        .build();
  } else {
    medication = builder
        .withFasting(
          type: fastingType ?? 'after',
          duration: fastingDuration,
          notify: notifyFasting,
        )
        .build();
  }

  await expectLater(
    NotificationService.instance.scheduleDynamicFastingNotification(
      medication: medication,
      actualDoseTime: actualDoseTime,
      personId: personId,
    ),
    completes,
  );
}

/// Helper to test multiple fasting durations.
///
/// This helper runs tests with different fasting durations to
/// verify that the service correctly handles all cases.
///
/// Usage example:
/// ```dart
/// await testMultipleFastingDurations(
///   durations: [30, 60, 90, 120],
///   fastingType: 'after',
///   actualDoseTime: DateTime(2025, 10, 16, 10, 0),
/// );
/// ```
Future<void> testMultipleFastingDurations({
  required List<int> durations,
  required String fastingType,
  required DateTime actualDoseTime,
  String personId = 'test-person-id',
  String doseTime = '08:00',
  double doseQuantity = 1.0,
  bool verifyDuration = false,
}) async {
  for (final duration in durations) {
    final medication = MedicationBuilder()
        .withId('test_duration_$duration')
        .withName('Test Medication $duration min')
        .withSingleDose(doseTime, doseQuantity)
        .withFasting(type: fastingType, duration: duration)
        .build();

    if (verifyDuration) {
      expect(medication.fastingDurationMinutes, duration);
    }

    await expectLater(
      NotificationService.instance.scheduleDynamicFastingNotification(
        medication: medication,
        actualDoseTime: actualDoseTime,
        personId: personId,
      ),
      completes,
    );
  }
}
