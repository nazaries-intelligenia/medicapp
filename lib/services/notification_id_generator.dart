import 'package:timezone/timezone.dart' as tz;

/// Types of notification IDs that can be generated
/// Each type uses a different ID range to avoid conflicts
enum NotificationIdType {
  /// Daily recurring notifications (range: 0-10,999,999)
  daily,

  /// Postponed dose notifications (range: 2,000,000-2,999,999)
  postponed,

  /// Specific date notifications (range: 3,000,000-3,999,999)
  specificDate,

  /// Weekly pattern notifications (range: 4,000,000-4,999,999)
  weekly,

  /// Fasting notifications - before/after (range: 5,000,000-5,999,999)
  fasting,

  /// Dynamic fasting notifications (range: 6,000,000-6,999,999)
  dynamicFasting,
}

/// Unified notification ID generator for MedicApp
///
/// This class generates unique notification IDs for different types of medication
/// reminders while ensuring each person gets their own notifications.
///
/// The generator uses different ID ranges for each notification type to prevent
/// conflicts and make debugging easier.
class NotificationIdGenerator {
  /// Private constructor to prevent instantiation
  NotificationIdGenerator._();

  /// Generate a unique notification ID based on type and parameters
  ///
  /// Parameters:
  /// - [type]: The type of notification (determines the ID range)
  /// - [medicationId]: The unique ID of the medication
  /// - [personId]: The unique ID of the person (for multi-user support)
  /// - [doseIndex]: The index of the dose in the medication's dose times array
  /// - [doseTime]: The time of the dose (format: "HH:mm")
  /// - [specificDate]: The specific date for date-based notifications (format: "yyyy-MM-dd")
  /// - [weekday]: The weekday for weekly pattern notifications (1=Monday, 7=Sunday)
  /// - [fastingTime]: The fasting notification time (for fasting type)
  /// - [isBefore]: Whether this is a "before" fasting notification (for fasting type)
  /// - [actualDoseTime]: The actual time the dose was taken (for dynamic fasting)
  ///
  /// Returns: A unique integer ID for the notification
  static int generate({
    required NotificationIdType type,
    required String medicationId,
    required String personId,
    int? doseIndex,
    String? doseTime,
    String? specificDate,
    int? weekday,
    tz.TZDateTime? fastingTime,
    bool? isBefore,
    DateTime? actualDoseTime,
  }) {
    switch (type) {
      case NotificationIdType.daily:
        return _generateDailyId(medicationId, doseIndex!, personId);

      case NotificationIdType.postponed:
        return _generatePostponedId(medicationId, doseTime!, personId);

      case NotificationIdType.specificDate:
        return _generateSpecificDateId(medicationId, specificDate!, doseIndex!, personId);

      case NotificationIdType.weekly:
        return _generateWeeklyId(medicationId, weekday!, doseIndex!, personId);

      case NotificationIdType.fasting:
        return _generateFastingId(medicationId, fastingTime!, isBefore!, personId);

      case NotificationIdType.dynamicFasting:
        return _generateDynamicFastingId(medicationId, actualDoseTime!, personId);
    }
  }

  /// Generate ID for daily recurring notifications
  /// Range: 0-10,999,999
  ///
  /// Formula: (medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex
  /// This ensures unique IDs for each dose of each medication for each person
  static int _generateDailyId(String medicationId, int doseIndex, String personId) {
    final medicationHash = medicationId.hashCode.abs();
    final personHash = personId.hashCode.abs();
    return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
  }

  /// Generate ID for postponed dose notifications
  /// Range: 2,000,000-2,999,999
  ///
  /// Uses hash-based approach to ensure unique IDs
  static int _generatePostponedId(String medicationId, String doseTime, String personId) {
    final combinedString = '$medicationId-$doseTime-$personId';
    final hash = combinedString.hashCode.abs();
    return 2000000 + (hash % 1000000);
  }

  /// Generate ID for specific date notifications
  /// Range: 3,000,000-3,999,999
  ///
  /// Uses hash-based approach to ensure unique IDs
  static int _generateSpecificDateId(
    String medicationId,
    String dateString,
    int doseIndex,
    String personId,
  ) {
    final combinedString = '$medicationId-$dateString-$doseIndex-$personId';
    final hash = combinedString.hashCode.abs();
    return 3000000 + (hash % 1000000);
  }

  /// Generate ID for weekly pattern notifications
  /// Range: 4,000,000-4,999,999
  ///
  /// Uses hash-based approach to ensure unique IDs
  static int _generateWeeklyId(
    String medicationId,
    int weekday,
    int doseIndex,
    String personId,
  ) {
    final combinedString = '$medicationId-weekday$weekday-$doseIndex-$personId';
    final hash = combinedString.hashCode.abs();
    return 4000000 + (hash % 1000000);
  }

  /// Generate ID for fasting notifications (before/after)
  /// Range: 5,000,000-5,999,999
  ///
  /// Uses hash-based approach to ensure unique IDs
  static int _generateFastingId(
    String medicationId,
    tz.TZDateTime fastingTime,
    bool isBefore,
    String personId,
  ) {
    final timeString = '${fastingTime.year}-${fastingTime.month}-${fastingTime.day}-${fastingTime.hour}-${fastingTime.minute}';
    final combinedString = '$medicationId-fasting-$timeString-${isBefore ? "before" : "after"}-$personId';
    final hash = combinedString.hashCode.abs();
    return 5000000 + (hash % 1000000);
  }

  /// Generate ID for dynamic fasting notifications (when dose is actually taken)
  /// Range: 6,000,000-6,999,999
  ///
  /// Uses hash-based approach to ensure unique IDs
  static int _generateDynamicFastingId(
    String medicationId,
    DateTime actualDoseTime,
    String personId,
  ) {
    final timeString = '${actualDoseTime.year}-${actualDoseTime.month}-${actualDoseTime.day}-${actualDoseTime.hour}-${actualDoseTime.minute}';
    final combinedString = '$medicationId-dynamic-fasting-$timeString-$personId';
    final hash = combinedString.hashCode.abs();
    return 6000000 + (hash % 1000000);
  }
}
