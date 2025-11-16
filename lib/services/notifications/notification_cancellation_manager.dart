import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import '../../models/medication.dart';
import '../../models/treatment_duration_type.dart';
import '../notification_id_generator.dart';
import '../../utils/datetime_extensions.dart';
import '../logger_service.dart';

/// Handles cancellation of all notification types
class NotificationCancellationManager {
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin;
  final bool _isTestMode;

  NotificationCancellationManager(this._notificationsPlugin, this._isTestMode);

  /// Cancel all notifications for a specific medication
  /// If [medication] is provided, uses smart cancellation based on actual dose count and type
  /// Otherwise, uses brute-force cancellation for safety
  /// V19+: Cancels notifications for ALL persons assigned to this medication
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
    // Skip in test mode
    if (_isTestMode) return;

    LoggerService.info('Cancelling all notifications for medication $medicationId (all persons)');

    // Determine the number of doses to cancel
    final maxDoses = medication?.doseTimes.length ?? 24;

    // V19+: Since personHash % 10 generates values 0-9, we iterate over 10 possible person variations
    // This ensures we cancel notifications for all persons who might have this medication assigned
    for (int personVariant = 0; personVariant < 10; personVariant++) {
      // Generate a dummy personId that will hash to this variant
      final dummyPersonId = 'person-$personVariant';

      // Cancel recurring daily notifications
      for (int i = 0; i < maxDoses; i++) {
        final notificationId = NotificationIdGenerator.generate(
          type: NotificationIdType.daily,
          medicationId: medicationId,
          personId: dummyPersonId,
          doseIndex: i,
        );
        await _notificationsPlugin.cancel(notificationId);
      }
    }

    // Cancel any specific date notifications (for medications with end dates or specific dates)
    // V19+: Cancel for all possible person variants (0-9 based on personId hash modulo)
    // OPTIMIZATION: Limit cancellation to 3 days (today + tomorrow + 1 buffer) to match scheduling window
    if (medication == null || medication.endDate != null || medication.durationType == TreatmentDurationType.specificDates) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      // Limit to 3 days to match our scheduling window (today + tomorrow + buffer)
      int daysToCheck = 3; // Default to 3 days
      if (medication?.endDate != null) {
        final calculatedDays = medication!.endDate!.difference(today).inDays + 1;
        daysToCheck = calculatedDays < 0 ? 0 : (calculatedDays > 3 ? 3 : calculatedDays);
      }

      for (int personVariant = 0; personVariant < 10; personVariant++) {
        final dummyPersonId = 'person-$personVariant';

        for (int day = 0; day < daysToCheck; day++) {
          final targetDate = today.add(Duration(days: day));
          final dateString = targetDate.toDateString();

          for (int i = 0; i < maxDoses; i++) {
            final notificationId = NotificationIdGenerator.generate(
              type: NotificationIdType.specificDate,
              medicationId: medicationId,
              personId: dummyPersonId,
              specificDate: dateString,
              doseIndex: i,
            );
            await _notificationsPlugin.cancel(notificationId);
          }
        }
      }
    }

    // Cancel any weekly pattern notifications
    // V19+: Cancel for all possible person variants
    if (medication == null || medication.durationType == TreatmentDurationType.weeklyPattern) {
      for (int personVariant = 0; personVariant < 10; personVariant++) {
        final dummyPersonId = 'person-$personVariant';

        for (int weekday = 1; weekday <= 7; weekday++) {
          for (int i = 0; i < maxDoses; i++) {
            final notificationId = NotificationIdGenerator.generate(
              type: NotificationIdType.weekly,
              medicationId: medicationId,
              personId: dummyPersonId,
              weekday: weekday,
              doseIndex: i,
            );
            await _notificationsPlugin.cancel(notificationId);
          }
        }
      }
    }

    // Cancel any postponed notifications (always check these, they're rare)
    // V19+: Cancel for all possible person variants
    for (int personVariant = 0; personVariant < 10; personVariant++) {
      final dummyPersonId = 'person-$personVariant';

      for (int i = 0; i < maxDoses; i++) {
        for (int hour = 0; hour < 24; hour++) {
          final timeString = DateTime(2000, 1, 1, hour, 0).toTimeString();
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.postponed,
            medicationId: medicationId,
            personId: dummyPersonId,
            doseTime: timeString,
          );
          await _notificationsPlugin.cancel(notificationId);
        }
      }
    }

    // Cancel any fasting notifications (static "before" fasting and dynamic "after" fasting)
    if (medication == null || medication.requiresFasting) {
      LoggerService.info('Cancelling fasting notifications for medication $medicationId');

      // Calculate date range for fasting notifications
      // OPTIMIZATION: Limit to 3 days to match scheduling window
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int daysToCheck = 3; // Default to 3 days (today + tomorrow + buffer)
      if (medication?.endDate != null) {
        final calculatedDays = medication!.endDate!.difference(today).inDays + 1;
        daysToCheck = calculatedDays < 0 ? 0 : (calculatedDays > 3 ? 3 : calculatedDays);
      }

      // If we have medication info with dose times, calculate exact fasting notification times
      // V19+: Cancel for all possible person variants
      if (medication != null && medication.doseTimes.isNotEmpty && medication.fastingDurationMinutes != null) {
        LoggerService.info('Using exact fasting times from medication data');

        for (int personVariant = 0; personVariant < 10; personVariant++) {
          final dummyPersonId = 'person-$personVariant';

          for (int day = 0; day < daysToCheck; day++) {
            final targetDate = today.add(Duration(days: day));

            // For each dose time, calculate the exact fasting notification time
            for (final doseTime in medication.doseTimes) {
              final parts = doseTime.split(':');
              final hour = int.parse(parts[0]);
              final minute = int.parse(parts[1]);

              final doseDateTime = tz.TZDateTime(
                tz.local,
                targetDate.year,
                targetDate.month,
                targetDate.day,
                hour,
                minute,
              );

              // Cancel "before" fasting notification
              if (medication.fastingType == 'before' || medication.fastingType == null) {
                final fastingStartTime = doseDateTime.subtract(
                  Duration(minutes: medication.fastingDurationMinutes!),
                );
                final beforeId = NotificationIdGenerator.generate(
                  type: NotificationIdType.fasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  fastingTime: fastingStartTime,
                  isBefore: true,
                );
                await _notificationsPlugin.cancel(beforeId);
              }

              // Cancel "after" fasting notification (for the dose time itself)
              if (medication.fastingType == 'after' || medication.fastingType == null) {
                final afterId = NotificationIdGenerator.generate(
                  type: NotificationIdType.fasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  fastingTime: doseDateTime,
                  isBefore: false,
                );
                await _notificationsPlugin.cancel(afterId);
              }

              // Cancel dynamic fasting notifications (these can be at any minute when dose was taken)
              // Check a window around the dose time (e.g., ±30 minutes)
              for (int minuteOffset = -30; minuteOffset <= 30; minuteOffset++) {
                final actualDoseTime = DateTime(
                  targetDate.year,
                  targetDate.month,
                  targetDate.day,
                  hour,
                  minute,
                ).add(Duration(minutes: minuteOffset));

                final dynamicId = NotificationIdGenerator.generate(
                  type: NotificationIdType.dynamicFasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  actualDoseTime: actualDoseTime,
                );
                await _notificationsPlugin.cancel(dynamicId);
              }
            }
          }
        }
      } else {
        // No medication info or no dose times: use broader cancellation
        // V19+: Cancel for all possible person variants
        LoggerService.info('Using broad cancellation approach for fasting notifications');

        for (int personVariant = 0; personVariant < 10; personVariant++) {
          final dummyPersonId = 'person-$personVariant';

          // Check common intervals throughout the day (every hour)
          for (int day = -1; day < daysToCheck; day++) { // Include yesterday for edge cases
            final targetDate = today.add(Duration(days: day));

            for (int hour = 0; hour < 24; hour++) {
              // Check every 5 minutes (compromise between thoroughness and performance)
              for (int minute = 0; minute < 60; minute += 5) {
                final fastingTime = tz.TZDateTime(
                  tz.local,
                  targetDate.year,
                  targetDate.month,
                  targetDate.day,
                  hour,
                  minute,
                );

                // Cancel both "before" and "after" fasting notification IDs
                final beforeId = NotificationIdGenerator.generate(
                  type: NotificationIdType.fasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  fastingTime: fastingTime,
                  isBefore: true,
                );
                final afterId = NotificationIdGenerator.generate(
                  type: NotificationIdType.fasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  fastingTime: fastingTime,
                  isBefore: false,
                );
                await _notificationsPlugin.cancel(beforeId);
                await _notificationsPlugin.cancel(afterId);

                // Cancel dynamic fasting notifications
                final doseTime = DateTime(
                  targetDate.year,
                  targetDate.month,
                  targetDate.day,
                  hour,
                  minute,
                );
                final dynamicId = NotificationIdGenerator.generate(
                  type: NotificationIdType.dynamicFasting,
                  medicationId: medicationId,
                  personId: dummyPersonId,
                  actualDoseTime: doseTime,
                );
                await _notificationsPlugin.cancel(dynamicId);
              }
            }
          }
        }
      }
    }

    LoggerService.info('Finished cancelling notifications for medication $medicationId');
  }

  /// Cancel a specific postponed notification
  /// Call this when the user registers the dose or explicitly cancels the postponed reminder
  /// V19+: Now requires personId to cancel person-specific postponed notification
  Future<void> cancelPostponedNotification(String medicationId, String doseTime, String personId) async {
    // Skip in test mode
    if (_isTestMode) return;

    final notificationId = NotificationIdGenerator.generate(
      type: NotificationIdType.postponed,
      medicationId: medicationId,
      personId: personId,
      doseTime: doseTime,
    );
    await _notificationsPlugin.cancel(notificationId);

    LoggerService.info('Cancelled postponed notification ID $notificationId for medication $medicationId at $doseTime (person: $personId)');
  }

  /// Cancel a specific dose notification for today
  /// This cancels the notification for a specific dose time on the current date
  /// Call this when the user registers a dose (taken or skipped) to prevent the notification from firing
  /// V19+: Now requires personId to cancel the correct person-specific notification
  Future<void> cancelTodaysDoseNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    LoggerService.info('Cancelling today\'s dose notification for ${medication.name} at $doseTime (person: $personId)');

    // Find the dose index for this time
    final doseIndex = medication.doseTimes.indexOf(doseTime);
    if (doseIndex == -1) {
      LoggerService.warning('Dose time $doseTime not found in medication dose times');
      return;
    }

    final now = DateTime.now();
    final todayString = now.toDateString();

    // Cancel different notification types based on treatment duration type
    switch (medication.durationType) {
      case TreatmentDurationType.specificDates:
        // For specific dates, cancel the specific date notification for today if today is a selected date
        if (medication.selectedDates?.contains(todayString) ?? false) {
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.specificDate,
            medicationId: medication.id,
            personId: personId,
            specificDate: todayString,
            doseIndex: doseIndex,
          );
          await _notificationsPlugin.cancel(notificationId);
          LoggerService.info('Cancelled specific date notification ID $notificationId for $todayString at $doseTime');
        }
        break;

      case TreatmentDurationType.weeklyPattern:
        // For weekly patterns, check if medication has an end date
        if (medication.endDate != null) {
          // Individual occurrences scheduled, cancel today's specific date notification
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.specificDate,
            medicationId: medication.id,
            personId: personId,
            specificDate: todayString,
            doseIndex: doseIndex,
          );
          await _notificationsPlugin.cancel(notificationId);
          LoggerService.info('Cancelled weekly pattern notification ID $notificationId for $todayString at $doseTime');
        } else {
          // Recurring weekly notifications, cancel by weekday
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.weekly,
            medicationId: medication.id,
            personId: personId,
            weekday: now.weekday,
            doseIndex: doseIndex,
          );
          await _notificationsPlugin.cancel(notificationId);
          LoggerService.info('Cancelled recurring weekly notification ID $notificationId for weekday ${now.weekday} at $doseTime');
        }
        break;

      default:
        // For everyday and untilFinished
        if (medication.endDate != null) {
          // Individual occurrences scheduled, cancel today's specific date notification
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.specificDate,
            medicationId: medication.id,
            personId: personId,
            specificDate: todayString,
            doseIndex: doseIndex,
          );
          await _notificationsPlugin.cancel(notificationId);
          LoggerService.info('Cancelled specific date notification ID $notificationId for $todayString at $doseTime');
        } else {
          // Recurring daily notifications, cancel the recurring notification
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.daily,
            medicationId: medication.id,
            personId: personId,
            doseIndex: doseIndex,
          );
          await _notificationsPlugin.cancel(notificationId);
          LoggerService.info('Cancelled recurring daily notification ID $notificationId for $doseTime');
        }
        break;
    }

    // Also cancel any postponed notification for this dose
    // V19+: Pass personId to cancel person-specific postponed notification
    await cancelPostponedNotification(medication.id, doseTime, personId);
  }

  /// Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    // Skip in test mode
    if (_isTestMode) return;

    await _notificationsPlugin.cancelAll();
  }
}
