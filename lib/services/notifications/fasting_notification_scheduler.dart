import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import '../../models/medication.dart';
import '../../database/database_helper.dart';
import '../../utils/platform_helper.dart';
import '../notification_id_generator.dart';
import 'notification_config.dart';

/// Helper class to represent a fasting period
class _FastingPeriod {
  final tz.TZDateTime start;
  final tz.TZDateTime end;
  final String doseTime;
  final bool isBefore;

  _FastingPeriod({
    required this.start,
    required this.end,
    required this.doseTime,
    required this.isBefore,
  });
}

/// Handles scheduling of all fasting-related notifications (static and dynamic)
class FastingNotificationScheduler {
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin;
  final bool _isTestMode;

  /// Base ID for ongoing fasting countdown notifications
  /// Each person gets their own notification: baseId + hash(personId)
  static const int _ongoingFastingNotificationIdBase = 7000000;

  /// Track active ongoing notifications by personId
  final Set<String> _activeOngoingNotifications = {};

  FastingNotificationScheduler(this._notificationsPlugin, this._isTestMode);

  /// Generate unique notification ID for a person's ongoing fasting notification
  int _getOngoingNotificationId(String personId) {
    // Use hashCode to generate a consistent ID for each person
    // Ensure it stays within valid Android notification ID range
    return _ongoingFastingNotificationIdBase + (personId.hashCode & 0xFFFFFF);
  }

  /// Schedule fasting notifications for a medication
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> scheduleFastingNotifications(Medication medication, String personId) async {
    if (!medication.requiresFasting || !medication.notifyFasting) {
      return;
    }

    if (medication.fastingDurationMinutes == null || medication.fastingDurationMinutes! <= 0) {
      print('Invalid fasting duration for ${medication.name}');
      return;
    }

    if (medication.fastingType == null) {
      print('Fasting type not specified for ${medication.name}');
      return;
    }

    print('========================================');
    print('Scheduling fasting notifications for ${medication.name}');
    print('Fasting type: ${medication.fastingType}');
    print('Fasting duration: ${medication.fastingDurationMinutes} minutes');
    print('========================================');

    final now = tz.TZDateTime.now(tz.local);

    // V19+: Get person for notification body logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final personName = person?.name ?? 'Usuario';
    final isDefault = person?.isDefault ?? false;

    // Calculate fasting periods for each dose
    final fastingPeriods = <_FastingPeriod>[];

    for (final doseTime in medication.doseTimes) {
      final parts = doseTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create a reference datetime for today
      var doseDateTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If dose time has passed today, use tomorrow
      if (doseDateTime.isBefore(now)) {
        doseDateTime = doseDateTime.add(const Duration(days: 1));
      }

      // Calculate fasting period
      tz.TZDateTime fastingStart;
      tz.TZDateTime fastingEnd;

      if (medication.fastingType == 'before') {
        // Fasting before the dose
        fastingStart = doseDateTime.subtract(Duration(minutes: medication.fastingDurationMinutes!));
        fastingEnd = doseDateTime;
      } else {
        // Fasting after the dose
        fastingStart = doseDateTime;
        fastingEnd = doseDateTime.add(Duration(minutes: medication.fastingDurationMinutes!));
      }

      fastingPeriods.add(_FastingPeriod(
        start: fastingStart,
        end: fastingEnd,
        doseTime: doseTime,
        isBefore: medication.fastingType == 'before',
      ));
    }

    // Merge overlapping fasting periods to find the most restrictive times
    final mergedPeriods = _mergeOverlappingFastingPeriods(fastingPeriods);

    // Schedule notifications for each merged period
    for (int i = 0; i < mergedPeriods.length; i++) {
      final period = mergedPeriods[i];

      // Skip if the fasting start time has already passed
      if (period.start.isBefore(now)) {
        print('⏭️  Skipping past fasting period: ${period.start}');
        continue;
      }

      // Only schedule "before" fasting notifications automatically
      // "after" fasting notifications are scheduled dynamically when the dose is actually taken
      if (period.isBefore) {
        // Notify when to stop eating (before taking the medication)
        final title = '🍽️ Comenzar ayuno';
        // V19+: Only include person name for non-default users
        final body = isDefault
          ? 'Es hora de dejar de comer para ${medication.name}'
          : '$personName: Es hora de dejar de comer para ${medication.name}';
        final notificationTime = period.start;

        // Generate unique notification ID for fasting (V19+: includes personId)
        final notificationId = NotificationIdGenerator.generate(
          type: NotificationIdType.fasting,
          medicationId: medication.id,
          personId: personId,
          fastingTime: period.start,
          isBefore: period.isBefore,
        );

        print('Scheduling "before" fasting notification ID $notificationId for ${medication.name} at $notificationTime');

        await _scheduleOneTimeNotification(
          id: notificationId,
          title: title,
          body: body,
          scheduledDate: notificationTime,
          payload: '${medication.id}|fasting|$personId',
        );
      } else {
        // For "after" fasting: notification will be scheduled dynamically when dose is registered
        print('Skipping "after" fasting notification for ${medication.name} - will be scheduled dynamically when dose is taken');
      }
    }
  }

  /// Schedule a dynamic fasting notification based on actual dose time
  /// This is called when a dose is registered (for "after" fasting type only)
  /// V19+: Now requires personId for per-person notification scheduling
  /// The notification will be scheduled for: actual time taken + fasting duration
  Future<void> scheduleDynamicFastingNotification({
    required Medication medication,
    required DateTime actualDoseTime,
    required String personId,
  }) async{
    // Skip in test mode
    if (_isTestMode) return;

    // Only schedule for "after" fasting type
    if (medication.fastingType != 'after') {
      return;
    }

    // Validate fasting configuration
    if (!medication.requiresFasting || !medication.notifyFasting) {
      return;
    }

    if (medication.fastingDurationMinutes == null || medication.fastingDurationMinutes! <= 0) {
      print('Invalid fasting duration for ${medication.name}');
      return;
    }

    print('========================================');
    print('Scheduling dynamic fasting notification for ${medication.name}');
    print('Actual dose time: $actualDoseTime');
    print('Fasting duration: ${medication.fastingDurationMinutes} minutes');
    print('========================================');

    // V19+: Get person for notification body logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final personName = person?.name ?? 'Usuario';
    final isDefault = person?.isDefault ?? false;

    // Convert actualDoseTime to TZDateTime in local timezone
    final actualDoseTZ = tz.TZDateTime.from(actualDoseTime, tz.local);

    // Calculate when fasting ends (actual time + fasting duration)
    final scheduledDate = actualDoseTZ.add(Duration(minutes: medication.fastingDurationMinutes!));

    print('Scheduled notification for: $scheduledDate');

    // Skip if the notification time has already passed (shouldn't happen but safety check)
    final now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now)) {
      print('⏭️  Skipping past fasting notification time: $scheduledDate');
      return;
    }

    // Generate unique notification ID for dynamic fasting (V19+: includes personId)
    final notificationId = NotificationIdGenerator.generate(
      type: NotificationIdType.dynamicFasting,
      medicationId: medication.id,
      personId: personId,
      actualDoseTime: actualDoseTime,
    );

    print('Scheduling dynamic fasting notification ID $notificationId for ${medication.name} at $scheduledDate');

    // Schedule the "you can eat now" notification
    // V19+: Only include person name for non-default users
    final body = isDefault
      ? 'Ya puedes volver a comer después de ${medication.name}'
      : '$personName: Ya puedes volver a comer después de ${medication.name}';

    await _scheduleOneTimeNotification(
      id: notificationId,
      title: '🍴 Fin del ayuno',
      body: body,
      scheduledDate: scheduledDate,
      payload: '${medication.id}|fasting-dynamic|$personId',
      isFastingCompletion: true,  // Use high-priority channel for fasting alerts
    );

    print('Successfully scheduled dynamic fasting notification');
  }

  /// Cancel today's fasting notification for a "before" fasting type medication
  /// This should be called when a dose is registered to prevent the fasting notification from firing
  /// V19+: Now requires personId to cancel the correct person-specific fasting notification
  Future<void> cancelTodaysFastingNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only cancel "before" fasting notifications (static scheduled ones)
    // "after" fasting notifications are dynamic and don't need cancellation
    if (medication.fastingType != 'before') {
      return;
    }

    // Check if medication requires fasting
    if (!medication.requiresFasting || !medication.notifyFasting) {
      return;
    }

    if (medication.fastingDurationMinutes == null || medication.fastingDurationMinutes! <= 0) {
      return;
    }

    print('Cancelling today\'s fasting notification for ${medication.name} at $doseTime (person: $personId)');

    // Parse dose time
    final parts = doseTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Calculate the dose datetime for today
    final now = DateTime.now();
    final doseDateTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Calculate when the fasting notification was scheduled (dose time - fasting duration)
    final fastingStartTime = doseDateTime.subtract(
      Duration(minutes: medication.fastingDurationMinutes!),
    );

    // Generate the notification ID using the same method used when scheduling (V19+: includes personId)
    final notificationId = NotificationIdGenerator.generate(
      type: NotificationIdType.fasting,
      medicationId: medication.id,
      personId: personId,
      fastingTime: fastingStartTime,
      isBefore: true,
    );

    // Cancel the notification
    await _notificationsPlugin.cancel(notificationId);
    print('Cancelled fasting notification ID $notificationId for ${medication.name}');
  }

  /// Show or update the ongoing fasting countdown notification
  /// This notification is persistent (cannot be dismissed by the user)
  /// and displays the remaining fasting time for a specific person's medication
  Future<void> showOngoingFastingNotification({
    required String personId,
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only show on Android (iOS doesn't support ongoing notifications)
    if (!PlatformHelper.isAndroid) return;

    try {
      final notificationId = _getOngoingNotificationId(personId);

      // Track this notification as active
      _activeOngoingNotifications.add(personId);

      // Android notification details with ongoing flag
      final androidDetails = fln.AndroidNotificationDetails(
        'fasting_ongoing',
        'Cuenta atrás de ayuno',
        channelDescription: 'Notificación fija que muestra el tiempo restante de ayuno',
        importance: fln.Importance.low,
        priority: fln.Priority.low,
        ongoing: true, // This makes the notification persistent
        autoCancel: false, // User cannot dismiss it
        showWhen: false, // Don't show the time when notification was posted
        playSound: false, // Don't play sound when showing/updating notification
        enableVibration: false, // Don't vibrate when showing/updating notification
        silent: true, // Make notification completely silent
        icon: '@mipmap/ic_launcher',
      );

      final platformDetails = fln.NotificationDetails(
        android: androidDetails,
      );

      // Format the notification body
      final body = '$medicationName • $timeRemaining restantes (hasta $endTime)';

      await _notificationsPlugin.show(
        notificationId,
        'Ayuno en curso',
        body,
        platformDetails,
      );

      print('Ongoing fasting notification ID $notificationId shown/updated for $medicationName (person: $personId)');
    } catch (e) {
      print('Error showing ongoing fasting notification: $e');
    }
  }

  /// Cancel ongoing fasting notification for a specific person
  Future<void> cancelOngoingFastingNotificationForPerson(String personId) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only relevant for Android
    if (!PlatformHelper.isAndroid) return;

    try {
      final notificationId = _getOngoingNotificationId(personId);
      await _notificationsPlugin.cancel(notificationId);
      _activeOngoingNotifications.remove(personId);
      print('Ongoing fasting notification ID $notificationId cancelled for person $personId');
    } catch (e) {
      print('Error cancelling ongoing fasting notification for person $personId: $e');
    }
  }

  /// Cancel all ongoing fasting countdown notifications
  Future<void> cancelOngoingFastingNotification() async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only relevant for Android
    if (!PlatformHelper.isAndroid) return;

    try {
      // Cancel all active ongoing notifications
      for (final personId in List.from(_activeOngoingNotifications)) {
        await cancelOngoingFastingNotificationForPerson(personId);
      }
      print('All ongoing fasting notifications cancelled');
    } catch (e) {
      print('Error cancelling ongoing fasting notifications: $e');
    }
  }

  /// Merge overlapping fasting periods to get the most restrictive times
  List<_FastingPeriod> _mergeOverlappingFastingPeriods(List<_FastingPeriod> periods) {
    if (periods.isEmpty) return [];

    // Sort periods by start time
    final sortedPeriods = List<_FastingPeriod>.from(periods)
      ..sort((a, b) => a.start.compareTo(b.start));

    final merged = <_FastingPeriod>[];
    var current = sortedPeriods[0];

    for (int i = 1; i < sortedPeriods.length; i++) {
      final next = sortedPeriods[i];

      // Check if periods overlap
      if (current.end.isAfter(next.start) || current.end.isAtSameMomentAs(next.start)) {
        // Merge: use earliest start and latest end
        current = _FastingPeriod(
          start: current.start.isBefore(next.start) ? current.start : next.start,
          end: current.end.isAfter(next.end) ? current.end : next.end,
          doseTime: current.doseTime,
          isBefore: current.isBefore,
        );
      } else {
        // No overlap, add current to merged list
        merged.add(current);
        current = next;
      }
    }

    // Add the last period
    merged.add(current);

    print('Merged ${periods.length} fasting periods into ${merged.length} non-overlapping periods');

    return merged;
  }

  /// Schedule a one-time notification (for fasting notifications)
  Future<void> _scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    bool isFastingCompletion = false,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Use special configuration for fasting completion notifications
    final notificationDetails = isFastingCompletion
        ? NotificationConfig.getFastingCompletionDetails()
        : NotificationConfig.getNotificationDetails();

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
