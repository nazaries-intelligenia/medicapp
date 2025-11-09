import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import '../models/medication.dart';
import '../models/treatment_duration_type.dart';
import '../screens/dose_action_screen.dart';
import '../database/database_helper.dart';
import '../main.dart' show navigatorKey;
import 'notification_id_generator.dart';
import '../utils/datetime_extensions.dart';
import '../utils/platform_helper.dart';
import 'notifications/notification_config.dart';
import 'notifications/daily_notification_scheduler.dart';
import 'notifications/weekly_notification_scheduler.dart';
import 'notifications/fasting_notification_scheduler.dart';
import 'notifications/notification_cancellation_manager.dart';

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

  // Specialized services
  late DailyNotificationScheduler _dailyScheduler;
  late WeeklyNotificationScheduler _weeklyScheduler;
  late FastingNotificationScheduler _fastingScheduler;
  late NotificationCancellationManager _cancellationManager;

  NotificationService._init() {
    // Initialize specialized services
    _dailyScheduler = DailyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _weeklyScheduler = WeeklyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _fastingScheduler = FastingNotificationScheduler(_notificationsPlugin, _isTestMode);
    _cancellationManager = NotificationCancellationManager(_notificationsPlugin, _isTestMode);
  }

  /// Get standard Android notification details for medication reminders
  /// Pass [autoCancel] = true to auto-cancel the notification after user taps
  fln.AndroidNotificationDetails _getAndroidNotificationDetails({bool autoCancel = false}) {
    return NotificationConfig.getAndroidNotificationDetails(autoCancel: autoCancel);
  }

  /// Get standard iOS/Darwin notification details for medication reminders
  fln.DarwinNotificationDetails _getDarwinNotificationDetails() {
    return NotificationConfig.getDarwinNotificationDetails();
  }

  /// Check if test mode is enabled
  bool get isTestMode => _isTestMode;

  /// Enable test mode (disables actual notifications)
  void enableTestMode() {
    _isTestMode = true;
    // Recreate specialized services with test mode enabled
    _dailyScheduler = DailyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _weeklyScheduler = WeeklyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _fastingScheduler = FastingNotificationScheduler(_notificationsPlugin, _isTestMode);
    _cancellationManager = NotificationCancellationManager(_notificationsPlugin, _isTestMode);
  }

  /// Disable test mode (enables actual notifications)
  void disableTestMode() {
    _isTestMode = false;
    // Recreate specialized services with test mode disabled
    _dailyScheduler = DailyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _weeklyScheduler = WeeklyNotificationScheduler(_notificationsPlugin, _isTestMode);
    _fastingScheduler = FastingNotificationScheduler(_notificationsPlugin, _isTestMode);
    _cancellationManager = NotificationCancellationManager(_notificationsPlugin, _isTestMode);
  }

  /// Helper method to generate notification title based on person
  /// V19+: Only shows person name in title if person is not the default user
  String buildNotificationTitle(String? personName, bool isDefault, {String suffix = ''}) {
    return NotificationConfig.buildNotificationTitle(personName, isDefault, suffix: suffix);
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
    if (!PlatformHelper.isAndroid) {
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
    if (!PlatformHelper.isAndroid) {
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
    String? medicationName;
    String? personName;

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
          medicationName = medication.name;
          print('⚠️ Using fallback time $doseTime - DoseActionScreen will handle it');
        } else {
          doseTime = medication.doseTimes[doseIndex];
          medicationName = medication.name;
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

    // Get person name for logging
    try {
      final person = await DatabaseHelper.instance.getPerson(personId);
      personName = person?.name;
    } catch (e) {
      print('Error getting person name: $e');
    }

    // Log notification interaction for debugging
    if (medicationName != null && personName != null) {
      await logNotificationShown(
        medicationId: medicationId,
        medicationName: medicationName,
        doseTime: doseTime,
        personId: personId,
        personName: personName,
      );
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
        await _dailyScheduler.scheduleSpecificDatesNotifications(medication, personId);
        break;
      case TreatmentDurationType.weeklyPattern:
        await _weeklyScheduler.scheduleWeeklyPatternNotifications(medication, personId);
        break;
      default:
        // For everyday and untilFinished: use daily recurring notifications
        await _dailyScheduler.scheduleDailyNotifications(medication, personId, excludeToday: excludeToday);
        break;
    }

    // Schedule fasting notifications if required
    if (medication.requiresFasting && medication.notifyFasting) {
      await _fastingScheduler.scheduleFastingNotifications(medication, personId);
    }

    // Verify notifications were scheduled
    final pending = await getPendingNotifications();
    print('Total pending notifications after scheduling: ${pending.length}');
  }

  /// Cancel all notifications for a specific medication
  /// If [medication] is provided, uses smart cancellation based on actual dose count and type
  /// Otherwise, uses brute-force cancellation for safety
  /// V19+: Cancels notifications for ALL persons assigned to this medication
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
    await _cancellationManager.cancelMedicationNotifications(medicationId, medication: medication);
  }

  /// Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    await _cancellationManager.cancelAllNotifications();
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
    final notificationId = NotificationIdGenerator.generate(
      type: NotificationIdType.postponed,
      medicationId: medication.id,
      personId: personId,
      doseTime: originalDoseTime,
    );

    final newDateTime = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day, newTime.hour, newTime.minute);
    final newTimeString = newDateTime.toTimeString();

    print('Scheduling postponed notification ID $notificationId for ${medication.name} at $newTimeString on $scheduledDate');

    // Get standard notification details with auto-cancel enabled
    final androidDetails = _getAndroidNotificationDetails(autoCancel: true);
    final iOSDetails = _getDarwinNotificationDetails();

    final notificationDetails = fln.NotificationDetails(
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

  /// Cancel a specific postponed notification
  /// Call this when the user registers the dose or explicitly cancels the postponed reminder
  /// V19+: Now requires personId to cancel person-specific postponed notification
  Future<void> cancelPostponedNotification(String medicationId, String doseTime, String personId) async {
    await _cancellationManager.cancelPostponedNotification(medicationId, doseTime, personId);
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
    await _cancellationManager.cancelTodaysDoseNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );
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
    await _fastingScheduler.scheduleDynamicFastingNotification(
      medication: medication,
      actualDoseTime: actualDoseTime,
      personId: personId,
    );
  }

  /// Cancel today's fasting notification for a "before" fasting type medication
  /// This should be called when a dose is registered to prevent the fasting notification from firing
  /// V19+: Now requires personId to cancel the correct person-specific fasting notification
  Future<void> cancelTodaysFastingNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  }) async {
    await _fastingScheduler.cancelTodaysFastingNotification(
      medication: medication,
      doseTime: doseTime,
      personId: personId,
    );
  }

  /// Show or update the ongoing fasting countdown notification
  /// This notification is persistent (cannot be dismissed by the user)
  /// and displays the remaining fasting time for the most urgent medication
  Future<void> showOngoingFastingNotification({
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  }) async {
    await _fastingScheduler.showOngoingFastingNotification(
      medicationName: medicationName,
      timeRemaining: timeRemaining,
      endTime: endTime,
    );
  }

  /// Cancel the ongoing fasting countdown notification
  Future<void> cancelOngoingFastingNotification() async {
    await _fastingScheduler.cancelOngoingFastingNotification();
  }

  // ========== Notification History (Debug) ==========

  static const String _notificationHistoryKey = 'notification_history';
  static const int _historyDurationHours = 24;
  static const int _maxHistoryEntries = 100;

  /// Log a notification when it's shown to the user
  /// This is used for debugging purposes to track notification delivery
  Future<void> logNotificationShown({
    required String medicationId,
    required String medicationName,
    required String doseTime,
    required String personId,
    required String personName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getNotificationHistory();

      final entry = {
        'timestamp': DateTime.now().toIso8601String(),
        'medicationId': medicationId,
        'medicationName': medicationName,
        'doseTime': doseTime,
        'personId': personId,
        'personName': personName,
      };

      history.insert(0, entry);

      // Limit history size
      if (history.length > _maxHistoryEntries) {
        history.removeRange(_maxHistoryEntries, history.length);
      }

      // Clean old entries (older than 24h)
      _cleanOldHistoryEntries(history);

      // Save back to SharedPreferences
      final jsonList = history.map((e) => jsonEncode(e)).toList();
      await prefs.setStringList(_notificationHistoryKey, jsonList);
    } catch (e) {
      print('Error logging notification: $e');
    }
  }

  /// Get notification history from the last 24 hours
  /// Returns a list of notification entries sorted by timestamp (newest first)
  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_notificationHistoryKey) ?? [];

      final history = jsonList
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      // Clean old entries
      _cleanOldHistoryEntries(history);

      return history;
    } catch (e) {
      print('Error getting notification history: $e');
      return [];
    }
  }

  /// Clean notification history entries older than 24 hours
  void _cleanOldHistoryEntries(List<Map<String, dynamic>> history) {
    final cutoffTime = DateTime.now().subtract(Duration(hours: _historyDurationHours));

    history.removeWhere((entry) {
      try {
        final timestamp = DateTime.parse(entry['timestamp'] as String);
        return timestamp.isBefore(cutoffTime);
      } catch (e) {
        // Remove invalid entries
        return true;
      }
    });
  }

  /// Clear all notification history
  Future<void> clearNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationHistoryKey);
    } catch (e) {
      print('Error clearing notification history: $e');
    }
  }
}
