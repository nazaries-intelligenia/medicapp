import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;
import '../models/medication.dart';
import '../models/treatment_duration_type.dart';
import '../screens/dose_action_screen.dart';
import '../database/database_helper.dart';
import '../main.dart' show navigatorKey;

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

class NotificationService {
  // Singleton pattern
  static final NotificationService instance = NotificationService._init();

  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  // Flag to disable notifications during testing
  bool _isTestMode = false;

  // Store pending notification data when context is not available
  String? _pendingMedicationId;
  String? _pendingDoseTime;
  String? _pendingPersonId; // V19+: Store pending personId

  NotificationService._init();

  /// Check if test mode is enabled
  bool get isTestMode => _isTestMode;

  /// Enable test mode (disables actual notifications)
  void enableTestMode() {
    _isTestMode = true;
  }

  /// Disable test mode (enables actual notifications)
  void disableTestMode() {
    _isTestMode = false;
  }

  /// Initialize the notification service
  Future<void> initialize() async {
    // Skip initialization in test mode
    if (_isTestMode) return;

    // Initialize timezone database
    tz.initializeTimeZones();

    // Try to use the device's local timezone, fallback to Europe/Madrid
    try {
      // Get device timezone name (this may not work on all platforms)
      final String timeZoneName = DateTime.now().timeZoneName;
      print('Device timezone name: $timeZoneName');

      // Common timezone mappings
      // For most cases, we'll use Europe/Madrid as it's a common timezone
      // but log the device timezone for debugging
      tz.setLocalLocation(tz.getLocation('Europe/Madrid'));
      print('Using timezone: Europe/Madrid');
    } catch (e) {
      print('Error setting timezone: $e');
      // Fallback to UTC if there's an error
      tz.setLocalLocation(tz.UTC);
      print('Using fallback timezone: UTC');
    }

    // Android initialization settings
    const androidSettings = fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iOSSettings = fln.DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const initSettings = fln.InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Request notification permissions (especially important for iOS and Android 13+)
  Future<bool> requestPermissions() async {
    // Skip in test mode
    if (_isTestMode) return true;

    bool granted = true;

    // For Android 13+ (API level 33+)
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final result = await androidPlugin.requestNotificationsPermission();
      granted = result ?? false;
      print('Android notification permission granted: $granted');
    }

    // For iOS
    final iOSPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        fln.IOSFlutterLocalNotificationsPlugin>();

    if (iOSPlugin != null) {
      final result = await iOSPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
      print('iOS notification permission granted: $granted');
    }

    return granted;
  }

  /// Check if notification permissions are granted
  Future<bool> areNotificationsEnabled() async {
    // Skip in test mode
    if (_isTestMode) return true;

    // For Android
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final result = await androidPlugin.areNotificationsEnabled();
      return result ?? false;
    }

    // For iOS, we can't directly check, so we return true if we've initialized
    return true;
  }

  /// Check if exact alarm permission is granted (Android 12+)
  Future<bool> canScheduleExactAlarms() async {
    // Skip in test mode
    if (_isTestMode) return true;

    // For Android
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        fln.AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Try to check if we can schedule exact alarms
      // Note: This API is available in flutter_local_notifications 15.0.0+
      try {
        final result = await androidPlugin.canScheduleExactNotifications();
        return result ?? true; // Return true if method not available (older Android)
      } catch (e) {
        print('Error checking exact alarm permission: $e');
        return true; // Assume true if check fails
      }
    }

    // For iOS, exact timing is always available
    return true;
  }

  /// Open exact alarm settings (Android 12+)
  /// This opens the system settings where users can enable the "Alarms & reminders" permission
  Future<void> openExactAlarmSettings() async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only for Android
    if (!Platform.isAndroid) {
      print('Exact alarm settings are only available on Android');
      return;
    }

    try {
      // Android 12+ (API 31+): Open the app's alarm settings
      // This will take the user to Settings > Apps > MedicApp > Alarms & reminders
      const intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        data: 'package:com.medicapp.medicapp',
      );

      await intent.launch();
      print('Opened exact alarm settings');
    } catch (e) {
      print('Error opening exact alarm settings: $e');

      // Fallback: open general app settings
      try {
        const fallbackIntent = AndroidIntent(
          action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
          data: 'package:com.medicapp.medicapp',
        );
        await fallbackIntent.launch();
        print('Opened app settings as fallback');
      } catch (e2) {
        print('Error opening app settings: $e2');
      }
    }
  }

  /// Open battery optimization settings
  /// This allows users to disable battery restrictions for the app
  Future<void> openBatteryOptimizationSettings() async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only for Android
    if (!Platform.isAndroid) {
      print('Battery optimization settings are only available on Android');
      return;
    }

    try {
      // For Samsung/One UI and most Android devices, open app info directly
      // User can then navigate to Battery settings from there
      const intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.medicapp.medicapp',
      );

      await intent.launch();
      print('Opened app settings for battery configuration');
    } catch (e) {
      print('Error opening app settings: $e');

      // Fallback: open general settings
      try {
        const fallbackIntent = AndroidIntent(
          action: 'android.settings.SETTINGS',
        );
        await fallbackIntent.launch();
        print('Opened general settings as fallback');
      } catch (e2) {
        print('Error opening settings: $e2');
      }
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(fln.NotificationResponse response) async {
    print('Notification tapped: ${response.payload}');

    if (response.payload == null || response.payload!.isEmpty) {
      print('No payload in notification');
      return;
    }

    // Parse payload: "medicationId|doseIndex|personId" (V19+)
    final parts = response.payload!.split('|');
    if (parts.length != 3) {
      print('Invalid payload format (expected 3 parts): ${response.payload}');
      return;
    }

    final medicationId = parts[0];
    final doseIndexStr = parts[1];
    final personId = parts[2];

    // For postponed notifications, the format is "medicationId|doseTime"
    // where doseTime is the actual time string (HH:mm)
    String doseTime;
    if (doseIndexStr.contains(':')) {
      // This is a postponed notification with the actual time
      doseTime = doseIndexStr;
    } else {
      // This is a regular notification, need to get the dose time from medication
      final doseIndex = int.tryParse(doseIndexStr);
      if (doseIndex == null) {
        print('Invalid dose index: $doseIndexStr');
        return;
      }

      // Load medication to get the dose time (v19+ person-specific lookup)
      try {
        final medications = await DatabaseHelper.instance.getMedicationsForPerson(personId);
        final medication = medications.where((m) => m.id == medicationId).firstOrNull;

        if (medication == null) {
          print('⚠️ Medication not found for notification ID ${response.id}');
          // Cancel this orphaned notification to prevent future taps
          await _notificationsPlugin.cancel(response.id ?? 0);
          // Still try to navigate - DoseActionScreen will show an error message
          // Use a dummy time since we can't get the real dose time
          doseTime = '00:00';
          print('⚠️ Using dummy time 00:00 - DoseActionScreen will show error');
        } else if (doseIndex >= medication.doseTimes.length) {
          print('⚠️ Invalid dose index $doseIndex for medication ${medication.name} (has ${medication.doseTimes.length} doses)');
          await _notificationsPlugin.cancel(response.id ?? 0);
          // Use the first dose time as fallback
          doseTime = medication.doseTimes.isNotEmpty ? medication.doseTimes[0] : '00:00';
          print('⚠️ Using fallback time $doseTime - DoseActionScreen will handle it');
        } else {
          doseTime = medication.doseTimes[doseIndex];
        }
      } catch (e) {
        print('❌ Error loading medication: $e');
        // Try to cancel the notification since something went wrong
        await _notificationsPlugin.cancel(response.id ?? 0);
        // Still try to navigate with a dummy time
        doseTime = '00:00';
        print('⚠️ Using dummy time 00:00 due to error - DoseActionScreen will show error');
      }
    }

    // Try to navigate with retry logic (V19+: now includes personId)
    await _navigateWithRetry(medicationId, doseTime, personId);
  }

  /// Navigate to DoseActionScreen with retry logic for when app is starting
  /// V19+: Now includes personId parameter
  Future<void> _navigateWithRetry(String medicationId, String doseTime, String personId, {int attempt = 1}) async {
    print('📱 Attempting navigation (attempt $attempt) for medication $medicationId at $doseTime');

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      print('✅ Context available, navigating to DoseActionScreen');
      try {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoseActionScreen(
              medicationId: medicationId,
              doseTime: doseTime,
              personId: personId, // V19+: Pass personId to screen
            ),
          ),
        );
        // Clear pending notification since we successfully navigated
        _pendingMedicationId = null;
        _pendingDoseTime = null;
        _pendingPersonId = null; // V19+: Clear pending personId
        print('✅ Navigation successful, screen was shown');
        return;
      } catch (e) {
        print('❌ Error navigating: $e');
        print('Stack trace: ${StackTrace.current}');
      }
    } else {
      print('⏳ Context not available yet (context: $context, mounted: ${context?.mounted})');
    }

    // If context is not available, retry with exponential backoff
    if (attempt <= 10) { // Increased from 5 to 10 attempts
      final delayMs = 200 * attempt; // Increased delay: 200ms, 400ms, 600ms, ...
      print('⏳ Will retry in ${delayMs}ms (attempt ${attempt + 1} of 10)');
      await Future.delayed(Duration(milliseconds: delayMs));
      await _navigateWithRetry(medicationId, doseTime, personId, attempt: attempt + 1); // V19+: Pass personId in retry
    } else {
      // After 10 attempts, store as pending notification
      print('⚠️ Failed to navigate after 10 attempts, storing as pending notification');
      _pendingMedicationId = medicationId;
      _pendingDoseTime = doseTime;
      _pendingPersonId = personId; // V19+: Store pending personId
    }
  }

  /// Process pending notification if any exists
  /// Should be called after the app is fully initialized
  /// V19+: Now includes personId handling
  Future<void> processPendingNotification() async {
    if (_pendingMedicationId != null && _pendingDoseTime != null && _pendingPersonId != null) {
      print('🔔 Processing pending notification: $_pendingMedicationId | $_pendingDoseTime | $_pendingPersonId');

      final medicationId = _pendingMedicationId!;
      final doseTime = _pendingDoseTime!;
      final personId = _pendingPersonId!;

      // Clear pending state before attempting navigation
      _pendingMedicationId = null;
      _pendingDoseTime = null;
      _pendingPersonId = null; // V19+: Clear pending personId

      // Wait a bit longer to ensure the app is fully ready
      await Future.delayed(const Duration(milliseconds: 1000));

      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        print('✅ Context available, navigating to pending DoseActionScreen');
        try {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoseActionScreen(
                medicationId: medicationId,
                doseTime: doseTime,
                personId: personId, // V19+: Pass personId to screen
              ),
            ),
          );
          print('✅ Pending notification processed successfully');
        } catch (e) {
          print('❌ Error processing pending notification: $e');
          print('Stack trace: ${StackTrace.current}');
        }
      } else {
        print('❌ Context still not available for pending notification (context: $context, mounted: ${context?.mounted})');
        // Try one more time with retry logic
        print('🔄 Attempting to navigate with retry logic...');
        await _navigateWithRetry(medicationId, doseTime, personId, attempt: 1);
      }
    } else {
      print('ℹ️ No pending notifications to process');
    }
  }

  /// Schedule notifications for a medication based on its dose times
  /// V19+: Now requires personId to schedule notifications for specific person
  /// If [excludeToday] is true, notifications will not be scheduled for today (useful when a dose was already taken)
  Future<void> scheduleMedicationNotifications(
    Medication medication,
    {required String personId, bool excludeToday = false}
  ) async {
    // Skip in test mode
    if (_isTestMode) return;

    if (medication.doseTimes.isEmpty) {
      print('No dose times for medication: ${medication.name}');
      return;
    }

    // Skip if medication is suspended
    if (medication.isSuspended) {
      print('Skipping notifications for ${medication.name}: medication is suspended');
      // Cancel any existing notifications for this medication
      await cancelMedicationNotifications(medication.id, medication: medication);
      return;
    }

    // Check if exact alarms are allowed (Android 12+)
    final canScheduleExact = await canScheduleExactAlarms();
    if (!canScheduleExact) {
      print('⚠️ WARNING: Cannot schedule exact alarms. Notifications may not fire on time.');
      print('   User needs to enable "Alarms & reminders" permission in app settings.');
    }

    // Phase 2: Only schedule notifications for active treatments
    // Skip if treatment hasn't started (isPending) or has already finished (isFinished)
    if (!medication.isActive) {
      if (medication.isPending) {
        print('Skipping notifications for ${medication.name}: treatment starts on ${medication.startDate}');
      } else if (medication.isFinished) {
        print('Skipping notifications for ${medication.name}: treatment ended on ${medication.endDate}');
      }
      // Cancel any existing notifications for this medication
      await cancelMedicationNotifications(medication.id, medication: medication);
      return;
    }

    print('========================================');
    print('Scheduling notifications for ${medication.name}');
    print('Current time: ${tz.TZDateTime.now(tz.local)}');
    print('Timezone: ${tz.local}');
    print('Dose times: ${medication.doseTimes}');
    print('Duration type: ${medication.durationType.name}');
    print('Is active: ${medication.isActive}');
    print('Start date: ${medication.startDate}');
    print('End date: ${medication.endDate}');
    print('========================================');

    // Cancel any existing notifications for this medication first
    // Pass the medication object for smart cancellation
    await cancelMedicationNotifications(medication.id, medication: medication);

    // Different scheduling logic based on duration type
    switch (medication.durationType) {
      case TreatmentDurationType.specificDates:
        await _scheduleSpecificDatesNotifications(medication, personId);
        break;
      case TreatmentDurationType.weeklyPattern:
        await _scheduleWeeklyPatternNotifications(medication, personId);
        break;
      default:
        // For everyday and untilFinished: use daily recurring notifications
        await _scheduleDailyNotifications(medication, personId, excludeToday: excludeToday);
        break;
    }

    // Schedule fasting notifications if required
    if (medication.requiresFasting && medication.notifyFasting) {
      await _scheduleFastingNotifications(medication, personId);
    }

    // Verify notifications were scheduled
    final pending = await getPendingNotifications();
    print('Total pending notifications after scheduling: ${pending.length}');
  }

  /// Helper method to generate notification title based on person
  /// V19+: Only shows person name in title if person is not the default user
  String buildNotificationTitle(String? personName, bool isDefault, {String suffix = ''}) {
    if (isDefault) {
      // Default user: don't show name
      return suffix.isEmpty ? '💊 Hora de tomar medicamento' : '💊 Hora de tomar medicamento $suffix';
    } else {
      // Other users: show name in title
      final name = personName ?? 'Usuario';
      return suffix.isEmpty ? '💊 $name - Hora de tomar medicamento' : '💊 $name - Hora de tomar medicamento $suffix';
    }
  }

  /// Schedule daily recurring notifications (for everyday and untilFinished)
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> _scheduleDailyNotifications(Medication medication, String personId, {bool excludeToday = false}) async {
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
          final dateString = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
          final notificationId = _generateSpecificDateNotificationId(medication.id, dateString, i, personId);

          await _scheduleOneTimeNotification(
            id: notificationId,
            title: buildNotificationTitle(person?.name, isDefault), // V19+: Conditional person name
            body: '${medication.name} - ${medication.type.displayName}',
            scheduledDate: scheduledDate,
            payload: '${medication.id}|$i|$personId', // V19+: Now includes personId
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
        final notificationId = _generateNotificationId(medication.id, i, personId);

        print('Scheduling recurring notification ID $notificationId for ${medication.name} at $hour:$minute daily');

        await _scheduleNotification(
          id: notificationId,
          title: buildNotificationTitle(person?.name, isDefault), // V19+: Conditional person name
          body: '${medication.name} - ${medication.type.displayName}',
          hour: hour,
          minute: minute,
          payload: '${medication.id}|$i|$personId', // V19+: Now includes personId
          excludeToday: excludeToday,
        );
      }
    }
  }

  /// Schedule notifications for specific dates
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> _scheduleSpecificDatesNotifications(Medication medication, String personId) async {
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
        final notificationId = _generateSpecificDateNotificationId(medication.id, dateString, i, personId);

        print('Scheduling specific date notification ID $notificationId for ${medication.name} on $dateString at $hour:$minute');

        await _scheduleOneTimeNotification(
          id: notificationId,
          title: buildNotificationTitle(person?.name, isDefault), // V19+: Conditional person name
          body: '${medication.name} - ${medication.type.displayName}',
          scheduledDate: scheduledDate,
          payload: '${medication.id}|$i|$personId', // V19+: Now includes personId
        );
      }
    }
  }

  /// Schedule notifications for weekly pattern
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> _scheduleWeeklyPatternNotifications(Medication medication, String personId) async{
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
            final dateString = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
            final notificationId = _generateSpecificDateNotificationId(medication.id, dateString, i, personId);

            await _scheduleOneTimeNotification(
              id: notificationId,
              title: buildNotificationTitle(person?.name, isDefault), // V19+: Conditional person name
              body: '${medication.name} - ${medication.type.displayName}',
              scheduledDate: scheduledDate,
              payload: '${medication.id}|$i|$personId', // V19+: Now includes personId
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
          final notificationId = _generateWeeklyNotificationId(medication.id, weekday, i, personId);

          print('Scheduling weekly recurring notification ID $notificationId for ${medication.name} on weekday $weekday at $hour:$minute');

          await _scheduleWeeklyNotification(
            id: notificationId,
            title: buildNotificationTitle(person?.name, isDefault), // V19+: Conditional person name
            body: '${medication.name} - ${medication.type.displayName}',
            scheduledDate: scheduledDate,
            payload: '${medication.id}|$i|$personId', // V19+: Now includes personId
          );
        }
      }
    }
  }

  /// Schedule fasting notifications for a medication
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> _scheduleFastingNotifications(Medication medication, String personId) async {
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
        final notificationId = _generateFastingNotificationId(medication.id, period.start, period.isBefore, personId);

        print('Scheduling "before" fasting notification ID $notificationId for ${medication.name} at $notificationTime');

        await _scheduleOneTimeNotification(
          id: notificationId,
          title: title,
          body: body,
          scheduledDate: notificationTime,
          payload: '${medication.id}|fasting|$personId', // V19+: Now includes personId
        );
      } else {
        // For "after" fasting: notification will be scheduled dynamically when dose is registered
        print('Skipping "after" fasting notification for ${medication.name} - will be scheduled dynamically when dose is taken');
      }
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

  /// Generate a unique notification ID for fasting reminders
  /// V19+: Now includes personId to ensure each person gets their own notification
  int _generateFastingNotificationId(String medicationId, tz.TZDateTime fastingTime, bool isBefore, String personId) {
    // Create a combined hash of medication ID, fasting time, type, and person ID
    final timeString = '${fastingTime.year}-${fastingTime.month}-${fastingTime.day}-${fastingTime.hour}-${fastingTime.minute}';
    final combinedString = '$medicationId-fasting-$timeString-${isBefore ? "before" : "after"}-$personId';
    final hash = combinedString.hashCode.abs();
    // Use range 5000000+ for fasting notifications
    return 5000000 + (hash % 1000000);
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

    // Android notification details
    const androidDetails = fln.AndroidNotificationDetails(
      'medication_reminders', // channel ID
      'Recordatorios de Medicamentos', // channel name
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
    );

    // iOS notification details
    const iOSDetails = fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

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

  /// Cancel all notifications for a specific medication
  /// If [medication] is provided, uses smart cancellation based on actual dose count and type
  /// Otherwise, uses brute-force cancellation for safety
  /// V19+: Cancels notifications for ALL persons assigned to this medication
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
    // Skip in test mode
    if (_isTestMode) return;

    print('Cancelling all notifications for medication $medicationId (all persons)');

    // Determine the number of doses to cancel
    final maxDoses = medication?.doseTimes.length ?? 24;

    // V19+: Since personHash % 10 generates values 0-9, we iterate over 10 possible person variations
    // This ensures we cancel notifications for all persons who might have this medication assigned
    for (int personVariant = 0; personVariant < 10; personVariant++) {
      // Generate a dummy personId that will hash to this variant
      final dummyPersonId = 'person-$personVariant';

      // Cancel recurring daily notifications
      for (int i = 0; i < maxDoses; i++) {
        final notificationId = _generateNotificationId(medicationId, i, dummyPersonId);
        await _notificationsPlugin.cancel(notificationId);
      }
    }

    // Cancel any specific date notifications (for medications with end dates or specific dates)
    // V19+: Cancel for all possible person variants (0-9 based on personId hash modulo)
    if (medication == null || medication.endDate != null || medication.durationType == TreatmentDurationType.specificDates) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final daysToCheck = medication?.endDate != null
          ? medication!.endDate!.difference(today).inDays + 7 // Check a week after end date
          : 365; // If we don't know, check a year ahead

      for (int personVariant = 0; personVariant < 10; personVariant++) {
        final dummyPersonId = 'person-$personVariant';

        for (int day = 0; day < daysToCheck; day++) {
          final targetDate = today.add(Duration(days: day));
          final dateString = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

          for (int i = 0; i < maxDoses; i++) {
            final notificationId = _generateSpecificDateNotificationId(medicationId, dateString, i, dummyPersonId);
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
            final notificationId = _generateWeeklyNotificationId(medicationId, weekday, i, dummyPersonId);
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
          final timeString = '${hour.toString().padLeft(2, '0')}:00';
          final notificationId = _generatePostponedNotificationId(medicationId, timeString, dummyPersonId);
          await _notificationsPlugin.cancel(notificationId);
        }
      }
    }

    // Cancel any fasting notifications (static "before" fasting and dynamic "after" fasting)
    if (medication == null || medication.requiresFasting) {
      print('Cancelling fasting notifications for medication $medicationId');

      // Calculate date range for fasting notifications
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final daysToCheck = medication?.endDate != null
          ? medication!.endDate!.difference(today).inDays + 7
          : 365; // Default to checking a year ahead

      // If we have medication info with dose times, calculate exact fasting notification times
      // V19+: Cancel for all possible person variants
      if (medication != null && medication.doseTimes.isNotEmpty && medication.fastingDurationMinutes != null) {
        print('Using exact fasting times from medication data');

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
                final beforeId = _generateFastingNotificationId(medicationId, fastingStartTime, true, dummyPersonId);
                await _notificationsPlugin.cancel(beforeId);
              }

              // Cancel "after" fasting notification (for the dose time itself)
              if (medication.fastingType == 'after' || medication.fastingType == null) {
                final afterId = _generateFastingNotificationId(medicationId, doseDateTime, false, dummyPersonId);
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

                final dynamicId = _generateDynamicFastingNotificationId(medicationId, actualDoseTime, dummyPersonId);
                await _notificationsPlugin.cancel(dynamicId);
              }
            }
          }
        }
      } else {
        // No medication info or no dose times: use broader cancellation
        // V19+: Cancel for all possible person variants
        print('Using broad cancellation approach for fasting notifications');

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
                final beforeId = _generateFastingNotificationId(medicationId, fastingTime, true, dummyPersonId);
                final afterId = _generateFastingNotificationId(medicationId, fastingTime, false, dummyPersonId);
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
                final dynamicId = _generateDynamicFastingNotificationId(medicationId, doseTime, dummyPersonId);
                await _notificationsPlugin.cancel(dynamicId);
              }
            }
          }
        }
      }
    }

    print('Finished cancelling notifications for medication $medicationId');
  }

  /// Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    // Skip in test mode
    if (_isTestMode) return;

    await _notificationsPlugin.cancelAll();
  }

  /// Synchronize system notifications with database medications
  /// This cancels any orphaned notifications (from deleted medications)
  /// and ensures only active medications have scheduled notifications
  ///
  /// Call this during app initialization to clean up notifications from:
  /// - Deleted medications
  /// - Previous installations
  /// - Database imports/restores
  Future<void> syncNotificationsWithMedications(List<Medication> activeMedications) async {
    // Skip in test mode
    if (_isTestMode) return;

    print('========================================');
    print('Syncing notifications with database medications');
    print('Active medications: ${activeMedications.length}');
    print('========================================');

    // Get all pending notifications from the system
    final pendingNotifications = await getPendingNotifications();
    print('Found ${pendingNotifications.length} pending notifications in system');

    // Create a set of active medication IDs for fast lookup
    final activeMedicationIds = activeMedications.map((m) => m.id).toSet();

    // Track notifications to cancel (orphaned)
    final orphanedNotificationIds = <int>[];

    // Check each pending notification
    for (final notification in pendingNotifications) {
      // Extract medication ID from payload (format: "medicationId|doseIndex" or "medicationId|...")
      if (notification.payload != null && notification.payload!.isNotEmpty) {
        final parts = notification.payload!.split('|');
        if (parts.isNotEmpty) {
          final medicationId = parts[0];

          // If this medication is not in the active medications list, mark for cancellation
          if (!activeMedicationIds.contains(medicationId)) {
            orphanedNotificationIds.add(notification.id);
            print('Found orphaned notification ID ${notification.id} for deleted medication: $medicationId');
          }
        }
      } else {
        // No payload - could be an orphaned notification, mark for cancellation
        orphanedNotificationIds.add(notification.id);
        print('Found notification without payload ID ${notification.id}, marking for cancellation');
      }
    }

    // Cancel all orphaned notifications
    if (orphanedNotificationIds.isNotEmpty) {
      print('Cancelling ${orphanedNotificationIds.length} orphaned notifications');
      for (final notificationId in orphanedNotificationIds) {
        await _notificationsPlugin.cancel(notificationId);
      }
      print('Successfully cancelled orphaned notifications');
    } else {
      print('No orphaned notifications found - system is clean');
    }

    print('Notification sync completed');
    print('========================================');
  }

  /// Get list of pending notifications (for debugging)
  Future<List<fln.PendingNotificationRequest>> getPendingNotifications() async {
    // Return empty list in test mode
    if (_isTestMode) return [];

    return await _notificationsPlugin.pendingNotificationRequests();
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

    // Android notification details
    const androidDetails = fln.AndroidNotificationDetails(
      'medication_reminders', // channel ID
      'Recordatorios de Medicamentos', // channel name
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
    );

    // iOS notification details
    const iOSDetails = fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

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

    // Android notification details
    const androidDetails = fln.AndroidNotificationDetails(
      'medication_reminders', // channel ID
      'Recordatorios de Medicamentos', // channel name
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
    );

    // iOS notification details
    const iOSDetails = fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

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

  /// Generate a unique notification ID based on medication ID, dose index, and person ID
  /// V19+: Now includes personId to ensure each person gets their own notification
  int _generateNotificationId(String medicationId, int doseIndex, String personId) {
    // Use a combination of medication ID hash, person ID hash, and dose index
    // This ensures unique IDs for each dose of each medication for each person
    final medicationHash = medicationId.hashCode.abs();
    final personHash = personId.hashCode.abs();
    // Combine hashes: (medication % 10000) * 1000 + (person % 10) * 100 + doseIndex
    // This gives us unique IDs while keeping them within reasonable range
    return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
  }

  /// Generate a unique notification ID for specific dates
  /// V19+: Now includes personId to ensure each person gets their own notification
  int _generateSpecificDateNotificationId(String medicationId, String dateString, int doseIndex, String personId) {
    // Create a combined hash of medication ID, date, dose index, and person ID
    final combinedString = '$medicationId-$dateString-$doseIndex-$personId';
    final hash = combinedString.hashCode.abs();
    // Use range 3000000+ for specific date notifications
    return 3000000 + (hash % 1000000);
  }

  /// Generate a unique notification ID for weekly patterns
  /// V19+: Now includes personId to ensure each person gets their own notification
  int _generateWeeklyNotificationId(String medicationId, int weekday, int doseIndex, String personId) {
    // Create a combined hash of medication ID, weekday, dose index, and person ID
    final combinedString = '$medicationId-weekday$weekday-$doseIndex-$personId';
    final hash = combinedString.hashCode.abs();
    // Use range 4000000+ for weekly pattern notifications
    return 4000000 + (hash % 1000000);
  }

  /// Test notification (for debugging)
  Future<void> showTestNotification() async {
    // Skip in test mode
    if (_isTestMode) return;

    const androidDetails = fln.AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
    );

    const iOSDetails = fln.DarwinNotificationDetails();

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification from MedicApp',
      notificationDetails,
    );
  }

  /// Test scheduled notification (1 minute in the future)
  Future<void> scheduleTestNotification() async {
    // Skip in test mode
    if (_isTestMode) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    print('Scheduling test notification for: $scheduledDate (1 minute from now)');
    print('Current time: $now');
    print('Timezone: ${tz.local}');

    const androidDetails = fln.AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const iOSDetails = fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        999999, // Unique ID for test
        '⏰ Test Programmed Notification',
        'If you see this, scheduled notifications work!',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('Test notification scheduled successfully for 1 minute from now');
    } catch (e) {
      print('Error scheduling test notification: $e');
    }
  }

  /// Schedule a postponed dose notification (one-time, not recurring)
  /// V19+: Now requires personId for per-person notification scheduling
  Future<void> schedulePostponedDoseNotification({
    required Medication medication,
    required String originalDoseTime,
    required TimeOfDay newTime,
    required String personId,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // V19+: Get person for notification title logic
    final person = await DatabaseHelper.instance.getPerson(personId);
    final isDefault = person?.isDefault ?? false;

    // Get the current time
    final now = tz.TZDateTime.now(tz.local);

    // Schedule for today at the specified time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      newTime.hour,
      newTime.minute,
    );

    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Generate a unique notification ID for postponed doses (V19+: includes personId)
    // Using a different range to avoid conflicts with regular notifications
    final notificationId = _generatePostponedNotificationId(medication.id, originalDoseTime, personId);

    final newTimeString = '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';

    print('Scheduling postponed notification ID $notificationId for ${medication.name} at $newTimeString on $scheduledDate');

    // Android notification details
    const androidDetails = fln.AndroidNotificationDetails(
      'medication_reminders', // same channel as regular notifications
      'Recordatorios de Medicamentos',
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
      autoCancel: true, // Auto-cancel after user taps
    );

    // iOS notification details
    const iOSDetails = fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = fln.NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        notificationId,
        buildNotificationTitle(person?.name, isDefault, suffix: '(pospuesto)'), // V19+: Conditional person name
        '${medication.name} - ${medication.type.displayName}',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        // No matchDateTimeComponents - this is a one-time notification
        payload: '${medication.id}|$originalDoseTime|$personId', // V19+: Now includes personId
      );
      print('Successfully scheduled postponed notification ID $notificationId');
    } catch (e) {
      print('Failed to schedule postponed notification: $e');
    }
  }

  /// Generate a unique notification ID for postponed doses
  /// V19+: Now includes personId to ensure each person gets their own notification
  /// Uses a different range (2000000+) to avoid conflicts with regular notifications
  int _generatePostponedNotificationId(String medicationId, String doseTime, String personId) {
    // Create a combined hash of medication ID, dose time, and person ID
    final combinedString = '$medicationId-$doseTime-$personId';
    final hash = combinedString.hashCode.abs();
    // Use range 2000000+ for postponed notifications
    return 2000000 + (hash % 1000000);
  }

  /// Cancel a specific postponed notification
  /// Call this when the user registers the dose or explicitly cancels the postponed reminder
  /// V19+: Now requires personId to cancel person-specific postponed notification
  Future<void> cancelPostponedNotification(String medicationId, String doseTime, String personId) async {
    // Skip in test mode
    if (_isTestMode) return;

    final notificationId = _generatePostponedNotificationId(medicationId, doseTime, personId);
    await _notificationsPlugin.cancel(notificationId);

    print('Cancelled postponed notification ID $notificationId for medication $medicationId at $doseTime (person: $personId)');
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

    print('Cancelling today\'s dose notification for ${medication.name} at $doseTime (person: $personId)');

    // Find the dose index for this time
    final doseIndex = medication.doseTimes.indexOf(doseTime);
    if (doseIndex == -1) {
      print('Dose time $doseTime not found in medication dose times');
      return;
    }

    final now = DateTime.now();
    final todayString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Cancel different notification types based on treatment duration type
    switch (medication.durationType) {
      case TreatmentDurationType.specificDates:
        // For specific dates, cancel the specific date notification for today if today is a selected date
        if (medication.selectedDates?.contains(todayString) ?? false) {
          final notificationId = _generateSpecificDateNotificationId(medication.id, todayString, doseIndex, personId);
          await _notificationsPlugin.cancel(notificationId);
          print('Cancelled specific date notification ID $notificationId for $todayString at $doseTime');
        }
        break;

      case TreatmentDurationType.weeklyPattern:
        // For weekly patterns, check if medication has an end date
        if (medication.endDate != null) {
          // Individual occurrences scheduled, cancel today's specific date notification
          final notificationId = _generateSpecificDateNotificationId(medication.id, todayString, doseIndex, personId);
          await _notificationsPlugin.cancel(notificationId);
          print('Cancelled weekly pattern notification ID $notificationId for $todayString at $doseTime');
        } else {
          // Recurring weekly notifications, cancel by weekday
          final notificationId = _generateWeeklyNotificationId(medication.id, now.weekday, doseIndex, personId);
          await _notificationsPlugin.cancel(notificationId);
          print('Cancelled recurring weekly notification ID $notificationId for weekday ${now.weekday} at $doseTime');
        }
        break;

      default:
        // For everyday and untilFinished
        if (medication.endDate != null) {
          // Individual occurrences scheduled, cancel today's specific date notification
          final notificationId = _generateSpecificDateNotificationId(medication.id, todayString, doseIndex, personId);
          await _notificationsPlugin.cancel(notificationId);
          print('Cancelled specific date notification ID $notificationId for $todayString at $doseTime');
        } else {
          // Recurring daily notifications, cancel the recurring notification
          final notificationId = _generateNotificationId(medication.id, doseIndex, personId);
          await _notificationsPlugin.cancel(notificationId);
          print('Cancelled recurring daily notification ID $notificationId for $doseTime');
        }
        break;
    }

    // Also cancel any postponed notification for this dose
    // V19+: Pass personId to cancel person-specific postponed notification
    await cancelPostponedNotification(medication.id, doseTime, personId);
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

    // Calculate when fasting ends (actual time + fasting duration)
    final fastingEndTime = actualDoseTime.add(Duration(minutes: medication.fastingDurationMinutes!));

    // Convert to TZDateTime
    final scheduledDate = tz.TZDateTime(
      tz.local,
      fastingEndTime.year,
      fastingEndTime.month,
      fastingEndTime.day,
      fastingEndTime.hour,
      fastingEndTime.minute,
    );

    // Skip if the notification time has already passed (shouldn't happen but safety check)
    final now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now)) {
      print('⏭️  Skipping past fasting notification time: $scheduledDate');
      return;
    }

    // Generate unique notification ID for dynamic fasting (V19+: includes personId)
    final notificationId = _generateDynamicFastingNotificationId(
      medication.id,
      actualDoseTime,
      personId,
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
      payload: '${medication.id}|fasting-dynamic|$personId', // V19+: Now includes personId
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
    final notificationId = _generateFastingNotificationId(
      medication.id,
      fastingStartTime,
      true, // isBefore = true
      personId,
    );

    // Cancel the notification
    await _notificationsPlugin.cancel(notificationId);
    print('Cancelled fasting notification ID $notificationId for ${medication.name}');
  }

  /// Generate a unique notification ID for dynamic fasting reminders
  /// V19+: Now includes personId to ensure each person gets their own notification
  /// Uses a different range (6000000+) to avoid conflicts with scheduled fasting notifications
  int _generateDynamicFastingNotificationId(String medicationId, DateTime actualDoseTime, String personId) {
    // Create a combined hash of medication ID, actual dose time, and person ID
    final timeString = '${actualDoseTime.year}-${actualDoseTime.month}-${actualDoseTime.day}-${actualDoseTime.hour}-${actualDoseTime.minute}';
    final combinedString = '$medicationId-dynamic-fasting-$timeString-$personId';
    final hash = combinedString.hashCode.abs();
    // Use range 6000000+ for dynamic fasting notifications
    return 6000000 + (hash % 1000000);
  }

  /// Fixed ID for the ongoing fasting countdown notification
  /// Only one ongoing notification is shown at a time
  static const int _ongoingFastingNotificationId = 7000000;

  /// Show or update the ongoing fasting countdown notification
  /// This notification is persistent (cannot be dismissed by the user)
  /// and displays the remaining fasting time for the most urgent medication
  Future<void> showOngoingFastingNotification({
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only show on Android (iOS doesn't support ongoing notifications)
    if (!Platform.isAndroid) return;

    try {
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
        icon: '@mipmap/ic_launcher',
      );

      final platformDetails = fln.NotificationDetails(
        android: androidDetails,
      );

      // Format the notification body
      final body = '$medicationName • $timeRemaining restantes (hasta $endTime)';

      await _notificationsPlugin.show(
        _ongoingFastingNotificationId,
        'Ayuno en curso',
        body,
        platformDetails,
      );

      print('Ongoing fasting notification shown/updated for $medicationName');
    } catch (e) {
      print('Error showing ongoing fasting notification: $e');
    }
  }

  /// Cancel the ongoing fasting countdown notification
  Future<void> cancelOngoingFastingNotification() async {
    // Skip in test mode
    if (_isTestMode) return;

    // Only relevant for Android
    if (!Platform.isAndroid) return;

    try {
      await _notificationsPlugin.cancel(_ongoingFastingNotificationId);
      print('Ongoing fasting notification cancelled');
    } catch (e) {
      print('Error cancelling ongoing fasting notification: $e');
    }
  }
}
