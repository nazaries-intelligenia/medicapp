import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import '../../models/medication.dart';
import '../../database/database_helper.dart';
import '../notification_id_generator.dart';
import '../../utils/datetime_extensions.dart';
import 'notification_config.dart';

/// Handles scheduling of weekly pattern medication notifications
class WeeklyNotificationScheduler {
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin;
  final bool _isTestMode;

  WeeklyNotificationScheduler(this._notificationsPlugin, this._isTestMode);

  /// Schedule notifications for weekly pattern
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> scheduleWeeklyPatternNotifications(Medication medication, String personId) async{
    if (medication.weeklyDays == null || medication.weeklyDays!.isEmpty) {
      print('No weekly days selected for ${medication.name}');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    // V19+: Get person for notification title logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final isDefault = person?.isDefault ?? false;

    // Phase 2: If treatment has an end date, schedule individual occurrences until end date
    // Otherwise, use recurring weekly notifications
    if (medication.endDate != null) {
      final endDate = medication.endDate!;
      final today = DateTime(now.year, now.month, now.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      print('Scheduling ${medication.name} weekly pattern until ${endDate.toString().split(' ')[0]}');

      // Schedule individual occurrences for each week until end date
      final daysToSchedule = end.difference(today).inDays + 1;

      for (int day = 0; day < daysToSchedule; day++) {
        final targetDate = today.add(Duration(days: day));

        // Check if this day matches one of the selected weekdays
        if (medication.weeklyDays!.contains(targetDate.weekday)) {
          for (int i = 0; i < medication.doseTimes.length; i++) {
            final doseTime = medication.doseTimes[i];
            final parts = doseTime.split(':');
            final hour = int.parse(parts[0]);
            final minute = int.parse(parts[1]);

            var scheduledDate = tz.TZDateTime(
              tz.local,
              targetDate.year,
              targetDate.month,
              targetDate.day,
              hour,
              minute,
            );

            // Skip if the time has already passed
            if (scheduledDate.isBefore(now)) {
              continue;
            }

            // Generate unique ID for this specific date and dose (V19+: includes personId)
            final dateString = DateTime(targetDate.year, targetDate.month, targetDate.day).toDateString();
            final notificationId = NotificationIdGenerator.generate(
              type: NotificationIdType.specificDate,
              medicationId: medication.id,
              personId: personId,
              specificDate: dateString,
              doseIndex: i,
            );

            await _scheduleOneTimeNotification(
              id: notificationId,
              title: NotificationConfig.buildNotificationTitle(person?.name, isDefault),
              body: '${medication.name} - ${medication.type.displayName}',
              scheduledDate: scheduledDate,
              payload: '${medication.id}|$i|$personId',
            );
          }
        }
      }
    } else {
      // No end date: use recurring weekly notifications (original behavior)
      for (final weekday in medication.weeklyDays!) {
        for (int i = 0; i < medication.doseTimes.length; i++) {
          final doseTime = medication.doseTimes[i];
          final parts = doseTime.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          // Find the next occurrence of this weekday
          var scheduledDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // Adjust to the target weekday
          final currentWeekday = scheduledDate.weekday;
          final daysUntilTarget = (weekday - currentWeekday) % 7;

          if (daysUntilTarget > 0) {
            scheduledDate = scheduledDate.add(Duration(days: daysUntilTarget));
          } else if (daysUntilTarget == 0 && scheduledDate.isBefore(now)) {
            // If it's the same day but time has passed, schedule for next week
            scheduledDate = scheduledDate.add(const Duration(days: 7));
          }

          // Generate unique ID for this weekday and dose (V19+: includes personId)
          final notificationId = NotificationIdGenerator.generate(
            type: NotificationIdType.weekly,
            medicationId: medication.id,
            personId: personId,
            weekday: weekday,
            doseIndex: i,
          );

          print('Scheduling weekly recurring notification ID $notificationId for ${medication.name} on weekday $weekday at $hour:$minute');

          await _scheduleWeeklyNotification(
            id: notificationId,
            title: NotificationConfig.buildNotificationTitle(person?.name, isDefault),
            body: '${medication.name} - ${medication.type.displayName}',
            scheduledDate: scheduledDate,
            payload: '${medication.id}|$i|$personId',
          );
        }
      }
    }
  }

  /// Schedule a weekly recurring notification (for weekly patterns)
  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    final notificationDetails = NotificationConfig.getNotificationDetails();

    print('Scheduling weekly notification ID $id for $scheduledDate (recurring weekly)');

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: fln.DateTimeComponents.dayOfWeekAndTime, // Repeat weekly on the same day and time
        payload: payload,
      );
      print('Successfully scheduled weekly notification ID $id');
    } catch (e) {
      print('Failed to schedule weekly notification: $e');
    }
  }

  /// Schedule a one-time notification (for specific dates)
  Future<void> _scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    final notificationDetails = NotificationConfig.getNotificationDetails();

    print('Scheduling one-time notification ID $id for $scheduledDate');

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        // No matchDateTimeComponents - this is a one-time notification
        payload: payload,
      );
      print('Successfully scheduled one-time notification ID $id');
    } catch (e) {
      print('Failed to schedule one-time notification: $e');
    }
  }
}
