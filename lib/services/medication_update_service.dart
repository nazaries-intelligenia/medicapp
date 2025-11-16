import '../models/medication.dart';
import '../database/database_helper.dart';
import 'notification_service.dart';

/// Service for medication update operations
///
/// Centralizes common medication update patterns to avoid code duplication
/// in UI components and ensure consistent behavior across the app.
class MedicationUpdateService {
  /// Refills medication stock
  ///
  /// Updates the medication's stock quantity by adding the refill amount
  /// and records the last refill amount for future reference.
  ///
  /// Returns the updated medication object.
  static Future<Medication> refillMedication({
    required Medication medication,
    required double refillAmount,
  }) async {
    if (refillAmount <= 0) {
      throw ArgumentError('Refill amount must be positive');
    }

    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity + refillAmount,
      lastRefillAmount: refillAmount,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);

    return updatedMedication;
  }

  /// Resumes a suspended medication
  ///
  /// Sets isSuspended to false and reschedules notifications for all persons
  /// assigned to this medication.
  ///
  /// Returns the updated medication object.
  static Future<Medication> resumeMedication({
    required Medication medication,
  }) async {
    if (!medication.isSuspended) {
      // Already active, nothing to do
      return medication;
    }

    final updatedMedication = medication.copyWith(
      isSuspended: false,
    );

    // V19+: Get all persons assigned to this medication and update each
    final persons = await DatabaseHelper.instance.getPersonsForMedication(
      medication.id,
    );

    // Update medication for each person (isSuspended is in person_medications table)
    for (final person in persons) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: person.id,
      );
    }

    // Cancel all existing notifications once before rescheduling
    await NotificationService.instance.cancelMedicationNotifications(
      updatedMedication.id,
      medication: updatedMedication,
    );

    // Then schedule for all persons with skipCancellation=true
    for (final person in persons) {
      await NotificationService.instance.scheduleMedicationNotifications(
        updatedMedication,
        personId: person.id,
        skipCancellation: true,
      );
    }

    return updatedMedication;
  }

  /// Suspends an active medication
  ///
  /// Sets isSuspended to true and cancels all scheduled notifications.
  ///
  /// Returns the updated medication object.
  static Future<Medication> suspendMedication({
    required Medication medication,
  }) async {
    if (medication.isSuspended) {
      // Already suspended, nothing to do
      return medication;
    }

    final updatedMedication = medication.copyWith(
      isSuspended: true,
    );

    // V19+: Get all persons assigned to this medication and update each
    final persons = await DatabaseHelper.instance.getPersonsForMedication(
      medication.id,
    );

    // Update medication for each person (isSuspended is in person_medications table)
    for (final person in persons) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: person.id,
      );
    }

    // Cancel all notifications
    await NotificationService.instance.cancelMedicationNotifications(
      updatedMedication.id,
      medication: updatedMedication,
    );

    return updatedMedication;
  }
}
