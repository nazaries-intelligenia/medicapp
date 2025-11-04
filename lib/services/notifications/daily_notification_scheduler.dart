import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import '../../models/medication.dart';
import '../../models/treatment_duration_type.dart';
import '../../database/database_helper.dart';
import '../notification_id_generator.dart';
import '../../utils/datetime_extensions.dart';
import 'notification_config.dart';

/// Handles scheduling of daily recurring medication notifications
class DailyNotificationScheduler {
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin;
  final bool _isTestMode;

  DailyNotificationScheduler(this._notificationsPlugin, this._isTestMode);

  /// Schedule daily recurring notifications (for everyday and untilFinished)
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> scheduleDailyNotifications(
    Medication medication,
    String personId,
    {bool excludeToday = false}
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    // V19+: Get person for notification title logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final isDefault = person?.isDefault ?? false;

    // Phase 2: If treatment has an end date, schedule individual notifications for each day
    // Otherwise, use recurring daily notifications
    if (medication.endDate != null) {
      final endDate = medication.endDate!;
      final today = DateTime(now.year, now.month, now.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      // Calculate how many days to schedule (from today to end date)
      final daysToSchedule = end.difference(today).inDays + 1;

      print('Scheduling ${medication.name} for $daysToSchedule days (until ${endDate.toString().split(' ')[0]})');

      // Schedule notifications for each day until end date
      for (int day = 0; day < daysToSchedule; day++) {
        final targetDate = today.add(Duration(days: day));

        // Skip today if excludeToday is true (dose already taken today)
        if (excludeToday && day == 0) {
          print('⏭️  Skipping today (dose already taken)');
          continue;
        }

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
            print('⏭️  Skipping past time: ${scheduledDate} (now: $now)');
            continue;
          }

          print('✅ Scheduling notification for: ${scheduledDate} (${doseTime})');

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
    } else {
      // No end date: use recurring daily notifications
      print('Scheduling ${medication.name} with recurring daily notifications (no end date)');

      for (int i = 0; i < medication.doseTimes.length; i++) {
        final doseTime = medication.doseTimes[i];
        final parts = doseTime.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        // Generate unique ID for this dose (V19+: includes personId)
        final notificationId = NotificationIdGenerator.generate(
          type: NotificationIdType.daily,
          medicationId: medication.id,
          personId: personId,
          doseIndex: i,
        );

        print('Scheduling recurring notification ID $notificationId for ${medication.name} at $hour:$minute daily');

        await _scheduleNotification(
          id: notificationId,
          title: NotificationConfig.buildNotificationTitle(person?.name, isDefault),
          body: '${medication.name} - ${medication.type.displayName}',
          hour: hour,
          minute: minute,
          payload: '${medication.id}|$i|$personId',
          excludeToday: excludeToday,
        );
      }
    }
  }

  /// Schedule notifications for specific dates
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> scheduleSpecificDatesNotifications(Medication medication, String personId) async {
    if (medication.selectedDates == null || medication.selectedDates!.isEmpty) {
      print('No specific dates selected for ${medication.name}');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    // V19+: Get person for notification title logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final isDefault = person?.isDefault ?? false;

    for (final dateString in medication.selectedDates!) {
      // Parse date (format: yyyy-MM-dd)
      final dateParts = dateString.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Only schedule if date is in the future or today
      final targetDate = DateTime(year, month, day);
      final today = DateTime(now.year, now.month, now.day);

      if (targetDate.isBefore(today)) {
        print('Skipping past date: $dateString');
        continue;
      }

      // Schedule notification for each dose time on this specific date
      for (int i = 0; i < medication.doseTimes.length; i++) {
        final doseTime = medication.doseTimes[i];
        final timeParts = doseTime.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        var scheduledDate = tz.TZDateTime(
          tz.local,
          year,
          month,
          day,
          hour,
          minute,
        );

        // Skip if the time has already passed
        if (scheduledDate.isBefore(now)) {
          print('Skipping past time: $dateString $doseTime');
          continue;
        }

        // Generate unique ID for this specific date and dose (V19+: includes personId)
        final notificationId = NotificationIdGenerator.generate(
          type: NotificationIdType.specificDate,
          medicationId: medication.id,
          personId: personId,
          specificDate: dateString,
          doseIndex: i,
        );

        print('Scheduling specific date notification ID $notificationId for ${medication.name} on $dateString at $hour:$minute');

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

  /// Schedule a single notification at a specific time daily
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    bool excludeToday = false,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Get the current time
    final now = tz.TZDateTime.now(tz.local);

    // Schedule for today at the specified time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If excludeToday is true (dose already taken today), always schedule for tomorrow
    if (excludeToday) {
      print('⏰ Excluding today (dose already taken), scheduling for tomorrow');
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    // Otherwise, if the scheduled time has already passed today, schedule for tomorrow
    else if (scheduledDate.isBefore(now)) {
      print('⏰ Time has passed for today, scheduling for tomorrow');
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('📅 Final scheduled date/time: $scheduledDate');

    final notificationDetails = NotificationConfig.getNotificationDetails();

    // Schedule the notification to repeat daily
    print('Attempting to schedule notification ID $id for $hour:$minute on $scheduledDate');

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: fln.DateTimeComponents.time, // Repeat daily at same time
        payload: payload,
      );
      print('Successfully scheduled notification ID $id with exactAllowWhileIdle');
    } catch (e) {
      // If exact alarms are not permitted, try with inexact alarms
      print('Failed to schedule exact alarm: $e');
      print('This may require SCHEDULE_EXACT_ALARM permission on Android 12+');
      print('Falling back to inexact alarm...');

      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          notificationDetails,
          androidScheduleMode: fln.AndroidScheduleMode.inexact,
          matchDateTimeComponents: fln.DateTimeComponents.time,
          payload: payload,
        );
        print('Successfully scheduled notification ID $id with inexact mode');
      } catch (e2) {
        print('Failed to schedule inexact alarm: $e2');
        // Don't throw - allow the app to continue without notifications
      }
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
