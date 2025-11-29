import 'package:uuid/uuid.dart';
import '../models/medication.dart';
import '../models/dose_history_entry.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';
import '../services/widget_service.dart';
import '../utils/datetime_extensions.dart';

/// Service for handling dose registration actions (taken, skipped, manual)
/// This centralizes the logic to avoid duplication across multiple screens
class DoseActionService {
  /// Register a taken dose for a scheduled medication
  static Future<Medication> registerTakenDose({
    required Medication medication,
    required String doseTime,
  }) async {
    final doseQuantity = medication.getDoseQuantity(doseTime);

    // Validate stock
    if (medication.stockQuantity < doseQuantity) {
      throw InsufficientStockException(
        doseQuantity: doseQuantity,
        availableStock: medication.stockQuantity,
        unit: medication.type.stockUnit,
      );
    }

    final today = DateTime.now();
    final todayString = _getTodayString(today);

    // Update taken doses for today
    List<String> updatedTakenDoses;
    List<String> updatedSkippedDoses = List.from(medication.skippedDosesToday);

    if (medication.takenDosesDate == todayString) {
      updatedTakenDoses = List.from(medication.takenDosesToday);
      updatedTakenDoses.add(doseTime);
    } else {
      updatedTakenDoses = [doseTime];
      updatedSkippedDoses = [];
    }

    // Create updated medication
    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity - doseQuantity,
      takenDosesToday: updatedTakenDoses,
      skippedDosesToday: updatedSkippedDoses,
      takenDosesDate: todayString,
    );

    // Get default person for history entry and updates
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (V19+: updates person-specific schedule)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    }

    // Save to history
    final scheduledDateTime = _parseDoseDateTime(today, doseTime);

    final historyEntry = DoseHistoryEntry(
      id: const Uuid().v4(),
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: scheduledDateTime,
      registeredDateTime: DateTime.now(),
      status: DoseStatus.taken,
      quantity: doseQuantity,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Handle notifications (V19+: pass personId)
    await _handleTakenDoseNotifications(updatedMedication, doseTime, DateTime.now(), personId);

    // Update home screen widget
    await WidgetService.instance.updateWidget();

    return updatedMedication;
  }

  /// Register a skipped dose for a scheduled medication
  static Future<Medication> registerSkippedDose({
    required Medication medication,
    required String doseTime,
  }) async {
    final today = DateTime.now();
    final todayString = _getTodayString(today);
    final doseQuantity = medication.getDoseQuantity(doseTime);

    // Update skipped doses for today
    List<String> updatedSkippedDoses;
    List<String> updatedTakenDoses = List.from(medication.takenDosesToday);

    if (medication.takenDosesDate == todayString) {
      updatedSkippedDoses = List.from(medication.skippedDosesToday);
      updatedSkippedDoses.add(doseTime);
    } else {
      updatedSkippedDoses = [doseTime];
      updatedTakenDoses = [];
    }

    // Create updated medication
    final updatedMedication = medication.copyWith(
      takenDosesToday: updatedTakenDoses,
      skippedDosesToday: updatedSkippedDoses,
      takenDosesDate: todayString,
    );

    // Get default person for history entry and updates
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (V19+: updates person-specific schedule)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    }

    // Save to history
    final scheduledDateTime = _parseDoseDateTime(today, doseTime);

    final historyEntry = DoseHistoryEntry(
      id: const Uuid().v4(),
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: scheduledDateTime,
      registeredDateTime: DateTime.now(),
      status: DoseStatus.skipped,
      quantity: doseQuantity,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Handle notifications (V19+: pass personId)
    await _handleSkippedDoseNotifications(updatedMedication, doseTime, personId);

    // Update home screen widget
    await WidgetService.instance.updateWidget();

    return updatedMedication;
  }

  /// Calculates the total daily consumption for a medication on a specific date
  ///
  /// This is particularly useful for "as needed" medications to track
  /// how much was consumed in a given day.
  ///
  /// Parameters:
  /// - [medicationId]: The medication ID to query
  /// - [date]: The date to calculate consumption for (defaults to today)
  ///
  /// Returns the total quantity consumed on that date
  static Future<double> calculateDailyConsumption({
    required String medicationId,
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final endOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);

    final historyEntries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
      medicationId: medicationId,
      startDate: startOfDay,
      endDate: endOfDay,
    );

    // Sum all taken doses for the day
    return historyEntries
        .where((entry) => entry.status == DoseStatus.taken)
        .fold<double>(0.0, (sum, entry) => sum + entry.quantity);
  }

  /// Register a manual dose for "as needed" medications
  static Future<Medication> registerManualDose({
    required Medication medication,
    required double quantity,
    double? lastDailyConsumption,
  }) async {
    // Validate stock
    if (medication.stockQuantity < quantity) {
      throw InsufficientStockException(
        doseQuantity: quantity,
        availableStock: medication.stockQuantity,
        unit: medication.type.stockUnit,
      );
    }

    // Create updated medication with reduced stock
    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity - quantity,
      lastDailyConsumption: lastDailyConsumption,
    );

    // Save to history
    final now = DateTime.now();

    // Get default person for history entry and updates
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (V19+: updates person-specific schedule)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    }

    final historyEntry = DoseHistoryEntry(
      id: const Uuid().v4(),
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: now,
      registeredDateTime: now,
      status: DoseStatus.taken,
      quantity: quantity,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Handle fasting notifications
    if (updatedMedication.requiresFasting &&
        updatedMedication.fastingType == 'after' &&
        updatedMedication.notifyFasting) {
      await NotificationService.instance.scheduleDynamicFastingNotification(
        medication: updatedMedication,
        actualDoseTime: now,
        personId: personId, // V19+: Pass personId
      );
    }

    // Update home screen widget
    await WidgetService.instance.updateWidget();

    return updatedMedication;
  }

  /// Register an extra dose for scheduled medications (outside of regular schedule)
  static Future<Medication> registerExtraDose({
    required Medication medication,
    required double quantity,
  }) async {
    // Validate stock
    if (medication.stockQuantity < quantity) {
      throw InsufficientStockException(
        doseQuantity: quantity,
        availableStock: medication.stockQuantity,
        unit: medication.type.stockUnit,
      );
    }

    final now = DateTime.now();
    final todayString = _getTodayString(now);
    final currentTime = now.toTimeString();

    // Update extra doses for today
    List<String> updatedExtraDoses;
    List<String> updatedTakenDoses = List.from(medication.takenDosesToday);
    List<String> updatedSkippedDoses = List.from(medication.skippedDosesToday);

    if (medication.takenDosesDate == todayString) {
      updatedExtraDoses = List.from(medication.extraDosesToday);
      updatedExtraDoses.add(currentTime);
    } else {
      // New day, reset all lists
      updatedExtraDoses = [currentTime];
      updatedTakenDoses = [];
      updatedSkippedDoses = [];
    }

    // Create updated medication with reduced stock
    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity - quantity,
      takenDosesToday: updatedTakenDoses,
      skippedDosesToday: updatedSkippedDoses,
      extraDosesToday: updatedExtraDoses,
      takenDosesDate: todayString,
    );

    // Get default person for history entry and updates
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (V19+: updates person-specific schedule)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    }

    // Save to history with isExtraDose=true
    final historyEntry = DoseHistoryEntry(
      id: const Uuid().v4(),
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: now, // For extra doses, scheduled time = actual time
      registeredDateTime: now,
      status: DoseStatus.taken,
      quantity: quantity,
      isExtraDose: true,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Handle fasting notifications for "after" type
    if (updatedMedication.requiresFasting &&
        updatedMedication.fastingType == 'after' &&
        updatedMedication.notifyFasting) {
      await NotificationService.instance.scheduleDynamicFastingNotification(
        medication: updatedMedication,
        actualDoseTime: now,
        personId: personId, // V19+: Pass personId
      );
    }

    // Update home screen widget
    await WidgetService.instance.updateWidget();

    return updatedMedication;
  }

  // Private helper methods

  static String _getTodayString(DateTime date) {
    return date.toDateString();
  }

  static DateTime _parseDoseDateTime(DateTime date, String timeString) {
    final parts = timeString.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static Future<void> _handleTakenDoseNotifications(
    Medication medication,
    String doseTime,
    DateTime actualDoseTime,
    String personId, // V19+: Add personId parameter
  ) async {
    // Cancel today's notification for this specific dose
    // V19+: Pass personId to cancel person-specific notification
    await NotificationService.instance.cancelTodaysDoseNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );

    // Reschedule medication notifications to restore future notifications
    // Use excludeToday: true to prevent rescheduling for today (dose already taken)
    // V19+: Pass personId for per-person scheduling
    await NotificationService.instance.scheduleMedicationNotifications(
      medication,
      personId: personId,
      excludeToday: true,
    );

    // Cancel today's fasting notification if needed
    // V19+: Pass personId to cancel person-specific fasting notification
    await NotificationService.instance.cancelTodaysFastingNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );

    // Schedule dynamic fasting notification if required
    // V19+: Pass personId for per-person scheduling
    if (medication.requiresFasting &&
        medication.fastingType == 'after' &&
        medication.notifyFasting) {
      await NotificationService.instance.scheduleDynamicFastingNotification(
        medication: medication,
        actualDoseTime: actualDoseTime,
        personId: personId,
      );
    }
  }

  static Future<void> _handleSkippedDoseNotifications(
    Medication medication,
    String doseTime,
    String personId, // V19+: Add personId parameter
  ) async {
    // Cancel today's notification for this specific dose
    // V19+: Pass personId to cancel person-specific notification
    await NotificationService.instance.cancelTodaysDoseNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );

    // Reschedule medication notifications
    // Use excludeToday: true to prevent rescheduling for today (dose already skipped)
    // V19+: Pass personId for per-person scheduling
    await NotificationService.instance.scheduleMedicationNotifications(
      medication,
      personId: personId,
      excludeToday: true,
    );

    // Cancel today's fasting notification
    // V19+: Pass personId to cancel person-specific fasting notification
    await NotificationService.instance.cancelTodaysFastingNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );
  }
}

/// Exception thrown when there's insufficient stock for a dose
class InsufficientStockException implements Exception {
  final double doseQuantity;
  final double availableStock;
  final String unit;

  InsufficientStockException({
    required this.doseQuantity,
    required this.availableStock,
    required this.unit,
  });

  @override
  String toString() =>
      'Insufficient stock: need $doseQuantity $unit, but only $availableStock $unit available';
}
