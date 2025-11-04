import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/services/notification_service.dart';
import 'medication_builder.dart';

/// Helper para probar la programación de notificaciones de ayuno dinámicas.
///
/// Este helper simplifica los tests repetitivos que crean medicamentos y
/// programan notificaciones de ayuno dinámicas.
///
/// Ejemplo de uso:
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

/// Helper para probar la programación automática de notificaciones "before".
///
/// Este helper simplifica los tests que programan notificaciones automáticas
/// para medicamentos con ayuno tipo "before".
///
/// Ejemplo de uso:
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

/// Helper para probar casos de borde de medicamentos sin ayuno válido.
///
/// Este helper simplifica los tests que verifican el comportamiento cuando
/// el medicamento no tiene configuración de ayuno válida.
///
/// Ejemplo de uso:
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

/// Helper para probar múltiples duraciones de ayuno.
///
/// Este helper ejecuta tests con diferentes duraciones de ayuno para
/// verificar que el servicio maneja correctamente todos los casos.
///
/// Ejemplo de uso:
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
