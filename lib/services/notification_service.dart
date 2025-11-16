import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import '../models/medication.dart';
import '../models/treatment_duration_type.dart';
import '../models/dose_history_entry.dart';
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
import 'logger_service.dart';

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
    _dailyScheduler = DailyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _weeklyScheduler = WeeklyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _fastingScheduler = FastingNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _cancellationManager = NotificationCancellationManager(
      _notificationsPlugin,
      _isTestMode,
    );
  }

  /// Get standard Android notification details for medication reminders
  /// Pass [autoCancel] = true to auto-cancel the notification after user taps
  fln.AndroidNotificationDetails _getAndroidNotificationDetails({
    bool autoCancel = false,
  }) {
    return NotificationConfig.getAndroidNotificationDetails(
      autoCancel: autoCancel,
    );
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
    _dailyScheduler = DailyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _weeklyScheduler = WeeklyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _fastingScheduler = FastingNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _cancellationManager = NotificationCancellationManager(
      _notificationsPlugin,
      _isTestMode,
    );
  }

  /// Disable test mode (enables actual notifications)
  void disableTestMode() {
    _isTestMode = false;
    // Recreate specialized services with test mode disabled
    _dailyScheduler = DailyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _weeklyScheduler = WeeklyNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _fastingScheduler = FastingNotificationScheduler(
      _notificationsPlugin,
      _isTestMode,
    );
    _cancellationManager = NotificationCancellationManager(
      _notificationsPlugin,
      _isTestMode,
    );
  }

  /// Helper method to generate notification title based on person
  /// V19+: Only shows person name in title if person is not the default user
  String buildNotificationTitle(
    String? personName,
    bool isDefault, {
    String suffix = '',
  }) {
    return NotificationConfig.buildNotificationTitle(
      personName,
      isDefault,
      suffix: suffix,
    );
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
      LoggerService.info('Device timezone name: $timeZoneName');

      // Common timezone mappings
      // For most cases, we'll use Europe/Madrid as it's a common timezone
      // but log the device timezone for debugging
      tz.setLocalLocation(tz.getLocation('Europe/Madrid'));
      LoggerService.info('Using timezone: Europe/Madrid');
    } catch (e) {
      LoggerService.error('Error setting timezone: $e', e);
      // Fallback to UTC if there's an error
      tz.setLocalLocation(tz.UTC);
      LoggerService.info('Using fallback timezone: UTC');
    }

    // Android initialization settings
    const androidSettings = fln.AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

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

    // Create notification channels explicitly (Android 8.0+)
    await _createNotificationChannels();
  }

  /// Create Android notification channels explicitly
  /// This ensures that notification actions work correctly on Android 8.0+ (API 26+)
  /// Note: Actions are defined per-notification in AndroidNotificationDetails, not at channel level
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          fln.AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Create medication reminders channel
      // Actions are configured in AndroidNotificationDetails (notification_config.dart)
      const medicationChannel = fln.AndroidNotificationChannel(
        'medication_reminders', // Must match the channel ID in NotificationConfig
        'Recordatorios de Medicamentos',
        description: 'Notificaciones para recordarte tomar tus medicamentos',
        importance: fln.Importance.high,
        playSound: true,
        enableVibration: true,
      );

      // Create fasting completion channel (no actions needed)
      const fastingChannel = fln.AndroidNotificationChannel(
        'fasting_completion',
        'Alertas de fin de ayuno',
        description:
            'Notificaciones importantes cuando termina el período de ayuno',
        importance: fln.Importance.max,
        playSound: true,
        enableVibration: true,
      );

      // Create both channels
      await androidPlugin.createNotificationChannel(medicationChannel);
      await androidPlugin.createNotificationChannel(fastingChannel);

      LoggerService.info('✅ Notification channels created successfully');
    }
  }

  /// Request notification permissions (especially important for iOS and Android 13+)
  Future<bool> requestPermissions() async {
    // Skip in test mode
    if (_isTestMode) return true;

    bool granted = true;

    // For Android 13+ (API level 33+)
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          fln.AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final result = await androidPlugin.requestNotificationsPermission();
      granted = result ?? false;
      LoggerService.info('Android notification permission granted: $granted');
    }

    // For iOS
    final iOSPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          fln.IOSFlutterLocalNotificationsPlugin
        >();

    if (iOSPlugin != null) {
      final result = await iOSPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = result ?? false;
      LoggerService.info('iOS notification permission granted: $granted');
    }

    return granted;
  }

  /// Check if notification permissions are granted
  Future<bool> areNotificationsEnabled() async {
    // Skip in test mode
    if (_isTestMode) return true;

    // For Android
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          fln.AndroidFlutterLocalNotificationsPlugin
        >();

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
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          fln.AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Try to check if we can schedule exact alarms
      // Note: This API is available in flutter_local_notifications 15.0.0+
      try {
        final result = await androidPlugin.canScheduleExactNotifications();
        return result ??
            true; // Return true if method not available (older Android)
      } catch (e) {
        LoggerService.error('Error checking exact alarm permission: $e', e);
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
      LoggerService.info('Exact alarm settings are only available on Android');
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
      LoggerService.info('Opened exact alarm settings');
    } catch (e) {
      LoggerService.error('Error opening exact alarm settings: $e', e);

      // Fallback: open general app settings
      try {
        const fallbackIntent = AndroidIntent(
          action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
          data: 'package:com.medicapp.medicapp',
        );
        await fallbackIntent.launch();
        LoggerService.info('Opened app settings as fallback');
      } catch (e2) {
        LoggerService.error('Error opening app settings: $e2', e2);
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
      LoggerService.info('Battery optimization settings are only available on Android');
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
      LoggerService.info('Opened app settings for battery configuration');
    } catch (e) {
      LoggerService.error('Error opening app settings: $e', e);

      // Fallback: open general settings
      try {
        const fallbackIntent = AndroidIntent(
          action: 'android.settings.SETTINGS',
        );
        await fallbackIntent.launch();
        LoggerService.info('Opened general settings as fallback');
      } catch (e2) {
        LoggerService.error('Error opening settings: $e2', e2);
      }
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(fln.NotificationResponse response) async {
    LoggerService.info('Notification tapped: ${response.payload}');
    LoggerService.info('Action ID: ${response.actionId}');

    if (response.payload == null || response.payload!.isEmpty) {
      LoggerService.info('No payload in notification');
      return;
    }

    // Parse payload: "medicationId|doseIndex|personId" (V19+)
    final parts = response.payload!.split('|');
    if (parts.length != 3) {
      LoggerService.warning('Invalid payload format (expected 3 parts): ${response.payload}');
      return;
    }

    final medicationId = parts[0];
    final doseIndexStr = parts[1];
    final personId = parts[2];

    // Handle quick actions (register, skip, snooze)
    if (response.actionId != null && response.actionId!.isNotEmpty) {
      await _handleNotificationAction(
        actionId: response.actionId!,
        medicationId: medicationId,
        doseIndexStr: doseIndexStr,
        personId: personId,
        notificationId: response.id ?? 0,
      );
      return; // Don't navigate to the screen if an action was pressed
    }

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
        LoggerService.warning('Invalid dose index: $doseIndexStr');
        return;
      }

      // Load medication to get the dose time (v19+ person-specific lookup)
      try {
        final medications = await DatabaseHelper.instance
            .getMedicationsForPerson(personId);
        final medication = medications
            .where((m) => m.id == medicationId)
            .firstOrNull;

        if (medication == null) {
          LoggerService.warning('⚠️ Medication not found for notification ID ${response.id}');
          // Cancel this orphaned notification to prevent future taps
          await _notificationsPlugin.cancel(response.id ?? 0);
          // Still try to navigate - DoseActionScreen will show an error message
          // Use a dummy time since we can't get the real dose time
          doseTime = '00:00';
          LoggerService.warning('⚠️ Using dummy time 00:00 - DoseActionScreen will show error');
        } else if (doseIndex >= medication.doseTimes.length) {
          LoggerService.warning(
            '⚠️ Invalid dose index $doseIndex for medication ${medication.name} (has ${medication.doseTimes.length} doses)',
          );
          await _notificationsPlugin.cancel(response.id ?? 0);
          // Use the first dose time as fallback
          doseTime = medication.doseTimes.isNotEmpty
              ? medication.doseTimes[0]
              : '00:00';
          medicationName = medication.name;
          LoggerService.warning(
            '⚠️ Using fallback time $doseTime - DoseActionScreen will handle it',
          );
        } else {
          doseTime = medication.doseTimes[doseIndex];
          medicationName = medication.name;
        }
      } catch (e) {
        LoggerService.error('❌ Error loading medication: $e', e);
        // Try to cancel the notification since something went wrong
        await _notificationsPlugin.cancel(response.id ?? 0);
        // Still try to navigate with a dummy time
        doseTime = '00:00';
        LoggerService.warning(
          '⚠️ Using dummy time 00:00 due to error - DoseActionScreen will show error',
        );
      }
    }

    // Get person name for logging
    try {
      final person = await DatabaseHelper.instance.getPerson(personId);
      personName = person?.name;
    } catch (e) {
      LoggerService.error('Error getting person name: $e', e);
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

  /// Handle notification action (register, skip, snooze)
  Future<void> _handleNotificationAction({
    required String actionId,
    required String medicationId,
    required String doseIndexStr,
    required String personId,
    required int notificationId,
  }) async {
    LoggerService.info('🎯 Handling action: $actionId for medication $medicationId');

    try {
      // Get medication and dose time
      final medications = await DatabaseHelper.instance.getMedicationsForPerson(
        personId,
      );
      final medication = medications
          .where((m) => m.id == medicationId)
          .firstOrNull;

      if (medication == null) {
        LoggerService.warning('❌ Medication not found');
        await _notificationsPlugin.cancel(notificationId);
        return;
      }

      // Parse dose index or time
      String doseTime;
      if (doseIndexStr.contains(':')) {
        doseTime = doseIndexStr; // Already a time string
      } else {
        final doseIndex = int.tryParse(doseIndexStr);
        if (doseIndex == null || doseIndex >= medication.doseTimes.length) {
          LoggerService.warning('❌ Invalid dose index');
          return;
        }
        doseTime = medication.doseTimes[doseIndex];
      }

      switch (actionId) {
        case 'register_dose':
          await _registerDoseFromNotification(
            medication,
            doseTime,
            personId,
            notificationId,
          );
          break;
        case 'skip_dose':
          await _skipDoseFromNotification(
            medication,
            doseTime,
            personId,
            notificationId,
          );
          break;
        case 'snooze_dose':
          await _snoozeDoseNotification(
            medication,
            doseTime,
            personId,
            notificationId,
          );
          break;
        default:
          LoggerService.warning('⚠️  Unknown action: $actionId');
      }
    } catch (e) {
      LoggerService.error('❌ Error handling notification action: $e', e);
    }
  }

  /// Register dose from notification action
  Future<void> _registerDoseFromNotification(
    Medication medication,
    String doseTime,
    String personId,
    int notificationId,
  ) async {
    LoggerService.info('✅ Registering dose for ${medication.name} at $doseTime');

    try {
      final doseQuantity = medication.getDoseQuantity(doseTime);

      // Check if there's enough stock
      if (medication.stockQuantity < doseQuantity) {
        LoggerService.warning('⚠️  Insufficient stock');

        // Get person information for notification
        final person = await DatabaseHelper.instance.getPerson(personId);
        final personName = person?.name ?? 'Usuario';

        // Show notification about insufficient stock
        await showLowStockNotification(
          medication: medication,
          personName: personName,
          isInsufficientForDose: true,
        );

        return;
      }

      // Update medication
      final updatedTakenDoses = List<String>.from(medication.takenDosesToday);
      if (!updatedTakenDoses.contains(doseTime)) {
        updatedTakenDoses.add(doseTime);
      }

      final updatedSkippedDoses = List<String>.from(
        medication.skippedDosesToday,
      );
      updatedSkippedDoses.remove(doseTime);

      final updatedMedication = medication.copyWith(
        stockQuantity: medication.stockQuantity - doseQuantity,
        takenDosesToday: updatedTakenDoses,
        skippedDosesToday: updatedSkippedDoses,
        takenDosesDate: DateTime.now().toDateString(),
      );

      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: personId,
      );

      // Create history entry
      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(doseTime.split(':')[0]),
        int.parse(doseTime.split(':')[1]),
      );

      final historyEntry = DoseHistoryEntry(
        id: '${medication.id}_${now.millisecondsSinceEpoch}',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: scheduledDateTime,
        registeredDateTime: now,
        status: DoseStatus.taken,
        quantity: doseQuantity,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Cancel notification
      await _notificationsPlugin.cancel(notificationId);

      // Schedule fasting notification if needed
      if (medication.requiresFasting && medication.fastingType == 'after') {
        await _fastingScheduler.scheduleDynamicFastingNotification(
          medication: medication,
          actualDoseTime: now,
          personId: personId,
        );
      }

      LoggerService.info('✅ Dose registered successfully');
    } catch (e) {
      LoggerService.error('❌ Error registering dose: $e', e);
    }
  }

  /// Skip dose from notification action
  Future<void> _skipDoseFromNotification(
    Medication medication,
    String doseTime,
    String personId,
    int notificationId,
  ) async {
    LoggerService.info('⏭️  Skipping dose for ${medication.name} at $doseTime');

    try {
      // Update medication
      final updatedSkippedDoses = List<String>.from(
        medication.skippedDosesToday,
      );
      if (!updatedSkippedDoses.contains(doseTime)) {
        updatedSkippedDoses.add(doseTime);
      }

      final updatedTakenDoses = List<String>.from(medication.takenDosesToday);
      updatedTakenDoses.remove(doseTime);

      final updatedMedication = medication.copyWith(
        skippedDosesToday: updatedSkippedDoses,
        takenDosesToday: updatedTakenDoses,
        takenDosesDate: DateTime.now().toDateString(),
      );

      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: personId,
      );

      // Create history entry
      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(doseTime.split(':')[0]),
        int.parse(doseTime.split(':')[1]),
      );

      final historyEntry = DoseHistoryEntry(
        id: '${medication.id}_${now.millisecondsSinceEpoch}',
        medicationId: medication.id,
        medicationName: medication.name,
        medicationType: medication.type,
        personId: personId,
        scheduledDateTime: scheduledDateTime,
        registeredDateTime: now,
        status: DoseStatus.skipped,
        quantity: 0.0,
      );

      await DatabaseHelper.instance.insertDoseHistory(historyEntry);

      // Cancel notification
      await _notificationsPlugin.cancel(notificationId);

      LoggerService.info('✅ Dose skipped successfully');
    } catch (e) {
      LoggerService.error('❌ Error skipping dose: $e', e);
    }
  }

  /// Snooze notification for 10 minutes
  Future<void> _snoozeDoseNotification(
    Medication medication,
    String doseTime,
    String personId,
    int notificationId,
  ) async {
    LoggerService.info('⏰ Snoozing notification for ${medication.name} at $doseTime');

    try {
      // Cancel current notification
      await _notificationsPlugin.cancel(notificationId);

      // Schedule new notification in 10 minutes
      final snoozeTime = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(minutes: 10));

      final person = await DatabaseHelper.instance.getPerson(personId);
      final isDefault = person?.isDefault ?? false;

      final notificationDetails = NotificationConfig.getNotificationDetails();

      await _notificationsPlugin.zonedSchedule(
        notificationId, // Reuse same ID
        NotificationConfig.buildNotificationTitle(person?.name, isDefault),
        '${medication.name} - ${medication.type.displayName}',
        snoozeTime,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        payload:
            '${medication.id}|$doseTime|$personId', // Use actual time instead of index
      );

      LoggerService.info('✅ Notification snoozed until ${snoozeTime.toString()}');
    } catch (e) {
      LoggerService.error('❌ Error snoozing notification: $e', e);
    }
  }

  /// Navigate to DoseActionScreen with retry logic for when app is starting
  /// V19+: Now includes personId parameter
  Future<void> _navigateWithRetry(
    String medicationId,
    String doseTime,
    String personId, {
    int attempt = 1,
  }) async {
    LoggerService.info(
      '📱 Attempting navigation (attempt $attempt) for medication $medicationId at $doseTime',
    );

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      LoggerService.info('✅ Context available, navigating to DoseActionScreen');
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
        LoggerService.info('✅ Navigation successful, screen was shown');
        return;
      } catch (e) {
        LoggerService.error('❌ Error navigating: $e', e);
        LoggerService.info('Stack trace: ${StackTrace.current}');
      }
    } else {
      LoggerService.info(
        '⏳ Context not available yet (context: $context, mounted: ${context?.mounted})',
      );
    }

    // If context is not available, retry with exponential backoff
    if (attempt <= 10) {
      // Increased from 5 to 10 attempts
      final delayMs =
          200 * attempt; // Increased delay: 200ms, 400ms, 600ms, ...
      LoggerService.info('⏳ Will retry in ${delayMs}ms (attempt ${attempt + 1} of 10)');
      await Future.delayed(Duration(milliseconds: delayMs));
      await _navigateWithRetry(
        medicationId,
        doseTime,
        personId,
        attempt: attempt + 1,
      ); // V19+: Pass personId in retry
    } else {
      // After 10 attempts, store as pending notification
      LoggerService.warning(
        '⚠️ Failed to navigate after 10 attempts, storing as pending notification',
      );
      _pendingMedicationId = medicationId;
      _pendingDoseTime = doseTime;
      _pendingPersonId = personId; // V19+: Store pending personId
    }
  }

  /// Process pending notification if any exists
  /// Should be called after the app is fully initialized
  /// V19+: Now includes personId handling
  Future<void> processPendingNotification() async {
    if (_pendingMedicationId != null &&
        _pendingDoseTime != null &&
        _pendingPersonId != null) {
      LoggerService.info(
        '🔔 Processing pending notification: $_pendingMedicationId | $_pendingDoseTime | $_pendingPersonId',
      );

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
        LoggerService.info('✅ Context available, navigating to pending DoseActionScreen');
        try{
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
          LoggerService.info('✅ Pending notification processed successfully');
        } catch (e) {
          LoggerService.error('❌ Error processing pending notification: $e', e);
          LoggerService.info('Stack trace: ${StackTrace.current}');
        }
      } else {
        LoggerService.warning(
          '❌ Context still not available for pending notification (context: $context, mounted: ${context?.mounted})',
        );
        // Try one more time with retry logic
        LoggerService.info('🔄 Attempting to navigate with retry logic...');
        await _navigateWithRetry(medicationId, doseTime, personId, attempt: 1);
      }
    } else {
      LoggerService.info('ℹ️ No pending notifications to process');
    }
  }

  /// Schedule notifications for a medication based on its dose times
  /// V19+: Now requires personId to schedule notifications for specific person
  /// If [excludeToday] is true, notifications will not be scheduled for today (useful when a dose was already taken)
  /// If [skipCancellation] is true, skips the automatic cancellation (useful when rescheduling multiple persons)
  Future<void> scheduleMedicationNotifications(
    Medication medication, {
    required String personId,
    bool excludeToday = false,
    bool skipCancellation = false,
  }) async {
    // Skip in test mode
    if (_isTestMode) return;

    if (medication.doseTimes.isEmpty) {
      LoggerService.info('No dose times for medication: ${medication.name}');
      return;
    }

    // Skip if medication is suspended
    if (medication.isSuspended) {
      LoggerService.info(
        'Skipping notifications for ${medication.name}: medication is suspended',
      );
      // Cancel any existing notifications for this medication
      await cancelMedicationNotifications(
        medication.id,
        medication: medication,
      );
      return;
    }

    // Check if exact alarms are allowed (Android 12+)
    final canScheduleExact = await canScheduleExactAlarms();
    if (!canScheduleExact) {
      LoggerService.warning(
        '⚠️ WARNING: Cannot schedule exact alarms. Notifications may not fire on time.',
      );
      LoggerService.warning(
        '   User needs to enable "Alarms & reminders" permission in app settings.',
      );
    }

    // Phase 2: Only schedule notifications for active treatments
    // Skip if treatment hasn't started (isPending) or has already finished (isFinished)
    if (!medication.isActive) {
      if (medication.isPending) {
        LoggerService.info(
          'Skipping notifications for ${medication.name}: treatment starts on ${medication.startDate}',
        );
      } else if (medication.isFinished) {
        LoggerService.info(
          'Skipping notifications for ${medication.name}: treatment ended on ${medication.endDate}',
        );
      }
      // Cancel any existing notifications for this medication
      await cancelMedicationNotifications(
        medication.id,
        medication: medication,
      );
      return;
    }

    LoggerService.info('========================================');
    LoggerService.info('Scheduling notifications for ${medication.name}');
    LoggerService.info('Current time: ${tz.TZDateTime.now(tz.local)}');
    LoggerService.info('Timezone: ${tz.local}');
    LoggerService.info('Dose times: ${medication.doseTimes}');
    LoggerService.info('Duration type: ${medication.durationType.name}');
    LoggerService.info('Is active: ${medication.isActive}');
    LoggerService.info('Start date: ${medication.startDate}');
    LoggerService.info('End date: ${medication.endDate}');
    LoggerService.info('========================================');

    // Cancel any existing notifications for this medication first
    // Pass the medication object for smart cancellation
    // Skip cancellation if explicitly requested (e.g., when bulk rescheduling)
    if (!skipCancellation) {
      await cancelMedicationNotifications(
        medication.id,
        medication: medication,
      );
    }

    // Different scheduling logic based on duration type
    switch (medication.durationType) {
      case TreatmentDurationType.specificDates:
        await _dailyScheduler.scheduleSpecificDatesNotifications(
          medication,
          personId,
        );
        break;
      case TreatmentDurationType.weeklyPattern:
        await _weeklyScheduler.scheduleWeeklyPatternNotifications(
          medication,
          personId,
        );
        break;
      default:
        // For everyday and untilFinished: use daily recurring notifications
        await _dailyScheduler.scheduleDailyNotifications(
          medication,
          personId,
          excludeToday: excludeToday,
        );
        break;
    }

    // Schedule fasting notifications if required
    if (medication.requiresFasting && medication.notifyFasting) {
      await _fastingScheduler.scheduleFastingNotifications(
        medication,
        personId,
      );
    }

    // Verify notifications were scheduled
    final pending = await getPendingNotifications();
    LoggerService.info('Total pending notifications after scheduling: ${pending.length}');
  }

  /// Cancel all notifications for a specific medication
  /// If [medication] is provided, uses smart cancellation based on actual dose count and type
  /// Otherwise, uses brute-force cancellation for safety
  /// V19+: Cancels notifications for ALL persons assigned to this medication
  Future<void> cancelMedicationNotifications(
    String medicationId, {
    Medication? medication,
  }) async {
    await _cancellationManager.cancelMedicationNotifications(
      medicationId,
      medication: medication,
    );
  }

  /// Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    await _cancellationManager.cancelAllNotifications();
  }

  /// Reschedule all notifications for all medications and persons
  /// This should be called when the app starts to ensure notifications are up to date
  /// OPTIMIZATION: Only schedules for next 2 days (today + tomorrow)
  Future<void> rescheduleAllMedicationNotifications() async {
    // Skip in test mode
    if (_isTestMode) return;

    LoggerService.info('🔄 Auto-rescheduling all medication notifications...');

    try {
      // Cancel all existing notifications first
      await cancelAllNotifications();

      // Get all persons
      final allPersons = await DatabaseHelper.instance.getAllPersons();

      int totalScheduled = 0;
      int medicationsProcessed = 0;

      // For each person, get their medications and schedule
      for (final person in allPersons) {
        final medications = await DatabaseHelper.instance
            .getMedicationsForPerson(person.id);

        for (final medication in medications) {
          // Only schedule if has dose times and is not suspended
          if (medication.doseTimes.isNotEmpty && !medication.isSuspended) {
            // Check if medication is active (has no dates, or within date range)
            final now = DateTime.now();
            final isActive =
                (medication.startDate == null ||
                    !now.isBefore(medication.startDate!)) &&
                (medication.endDate == null ||
                    !now.isAfter(medication.endDate!));

            if (isActive) {
              await scheduleMedicationNotifications(
                medication,
                personId: person.id,
                skipCancellation: true,
              );
              totalScheduled++;
            }
          }
          medicationsProcessed++;
        }
      }

      final pending = await getPendingNotifications();
      LoggerService.info(
        '✅ Rescheduling complete: $medicationsProcessed medications checked, $totalScheduled scheduled, ${pending.length} notifications in system',
      );
    } catch (e) {
      LoggerService.error('❌ Error rescheduling notifications: $e', e);
    }
  }

  /// Synchronize system notifications with database medications
  /// This cancels any orphaned notifications (from deleted medications)
  /// and ensures only active medications have scheduled notifications
  ///
  /// Call this during app initialization to clean up notifications from:
  /// - Deleted medications
  /// - Previous installations
  /// - Database imports/restores
  Future<void> syncNotificationsWithMedications(
    List<Medication> activeMedications,
  ) async {
    // Skip in test mode
    if (_isTestMode) return;

    LoggerService.info('========================================');
    LoggerService.info('Syncing notifications with database medications');
    LoggerService.info('Active medications: ${activeMedications.length}');
    LoggerService.info('========================================');

    // Get all pending notifications from the system
    final pendingNotifications = await getPendingNotifications();
    LoggerService.info(
      'Found ${pendingNotifications.length} pending notifications in system',
    );

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
            LoggerService.info(
              'Found orphaned notification ID ${notification.id} for deleted medication: $medicationId',
            );
          }
        }
      } else {
        // No payload - could be an orphaned notification, mark for cancellation
        orphanedNotificationIds.add(notification.id);
        LoggerService.info(
          'Found notification without payload ID ${notification.id}, marking for cancellation',
        );
      }
    }

    // Cancel all orphaned notifications
    if (orphanedNotificationIds.isNotEmpty) {
      LoggerService.info(
        'Cancelling ${orphanedNotificationIds.length} orphaned notifications',
      );
      for (final notificationId in orphanedNotificationIds) {
        await _notificationsPlugin.cancel(notificationId);
      }
      LoggerService.info('Successfully cancelled orphaned notifications');
    } else {
      LoggerService.info('No orphaned notifications found - system is clean');
    }

    LoggerService.info('Notification sync completed');
    LoggerService.info('========================================');
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

  /// Play a sound/vibration when fasting is completed
  Future<void> playFastingCompletedSound() async {
    // Skip in test mode
    if (_isTestMode) return;

    try {
      // Show a quick notification with sound to alert the user
      const androidDetails = fln.AndroidNotificationDetails(
        'fasting_completed',
        'Fasting Completed',
        channelDescription: 'Alert when fasting period ends',
        importance: fln.Importance.max,
        priority: fln.Priority.max,
        playSound: true,
        enableVibration: true,
        timeoutAfter: 3000, // Auto-dismiss after 3 seconds
      );

      const iOSDetails = fln.DarwinNotificationDetails(presentSound: true);

      const notificationDetails = fln.NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      await _notificationsPlugin.show(
        999999, // Unique ID for fasting completion alerts
        '¡Ayuno completado!',
        'Ya puedes comer',
        notificationDetails,
      );
    } catch (e) {
      LoggerService.error('Error playing fasting completed sound: $e', e);
    }
  }

  /// Test scheduled notification (1 minute in the future)
  Future<void> scheduleTestNotification() async {
    // Skip in test mode
    if (_isTestMode) return;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(minutes: 1));

    LoggerService.info(
      'Scheduling test notification for: $scheduledDate (1 minute from now)',
    );
    LoggerService.info('Current time: $now');
    LoggerService.info('Timezone: ${tz.local}');

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
      LoggerService.info('Test notification scheduled successfully for 1 minute from now');
    } catch (e) {
      LoggerService.error('Error scheduling test notification: $e', e);
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

    final newDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      newTime.hour,
      newTime.minute,
    );
    final newTimeString = newDateTime.toTimeString();

    LoggerService.info(
      'Scheduling postponed notification ID $notificationId for ${medication.name} at $newTimeString on $scheduledDate',
    );

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
        buildNotificationTitle(
          person?.name,
          isDefault,
          suffix: '(pospuesto)',
        ), // V19+: Conditional person name
        '${medication.name} - ${medication.type.displayName}',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
        // No matchDateTimeComponents - this is a one-time notification
        payload:
            '${medication.id}|$originalDoseTime|$personId', // V19+: Now includes personId
      );
      LoggerService.info('Successfully scheduled postponed notification ID $notificationId');
    } catch (e) {
      LoggerService.error('Failed to schedule postponed notification: $e', e);
    }
  }

  /// Cancel a specific postponed notification
  /// Call this when the user registers the dose or explicitly cancels the postponed reminder
  /// V19+: Now requires personId to cancel person-specific postponed notification
  Future<void> cancelPostponedNotification(
    String medicationId,
    String doseTime,
    String personId,
  ) async {
    await _cancellationManager.cancelPostponedNotification(
      medicationId,
      doseTime,
      personId,
    );
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
  }) async {
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

  /// Show or update the ongoing fasting countdown notification for a specific person
  /// This notification is persistent (cannot be dismissed by the user)
  /// and displays the remaining fasting time for that person's medication
  Future<void> showOngoingFastingNotification({
    required String personId,
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  }) async {
    await _fastingScheduler.showOngoingFastingNotification(
      personId: personId,
      medicationName: medicationName,
      timeRemaining: timeRemaining,
      endTime: endTime,
    );
  }

  /// Cancel ongoing fasting notification for a specific person
  Future<void> cancelOngoingFastingNotificationForPerson(
    String personId,
  ) async {
    await _fastingScheduler.cancelOngoingFastingNotificationForPerson(personId);
  }

  /// Cancel all ongoing fasting countdown notifications
  Future<void> cancelOngoingFastingNotification() async {
    await _fastingScheduler.cancelOngoingFastingNotification();
  }

  // ========== Low Stock Notifications ==========

  /// Show a notification when medication stock is low or insufficient
  Future<void> showLowStockNotification({
    required Medication medication,
    required String personName,
    bool isInsufficientForDose = false,
    int? daysRemaining,
  }) async {
    if (_isTestMode) return;

    try {
      // Generate a unique notification ID for low stock
      final notificationId = NotificationIdGenerator.generateLowStockId(
        medication.id,
      );

      final title = isInsufficientForDose
          ? '⚠️ Stock insuficiente: ${medication.name}'
          : '📦 Stock bajo: ${medication.name}';

      String body;
      if (isInsufficientForDose) {
        body = 'No hay suficiente ${medication.type.stockUnit} para la próxima dosis. Stock actual: ${medication.stockQuantity.toStringAsFixed(1)} ${medication.type.stockUnit}.';
      } else if (daysRemaining != null) {
        body = daysRemaining == 1
            ? 'Solo queda 1 día de stock (${medication.stockQuantity.toStringAsFixed(1)} ${medication.type.stockUnit}). Considera reabastecer hoy.'
            : 'Quedan aproximadamente $daysRemaining días de stock (${medication.stockQuantity.toStringAsFixed(1)} ${medication.type.stockUnit}). Considera reabastecer pronto.';
      } else {
        body = 'Quedan ${medication.stockQuantity.toStringAsFixed(1)} ${medication.type.stockUnit}. Considera reabastecer pronto.';
      }

      await _notificationsPlugin.show(
        notificationId,
        title,
        body,
        NotificationConfig.stockAlert(
          personName: personName,
          medicationName: medication.name,
        ),
      );

      LoggerService.info('📦 Low stock notification shown for ${medication.name} (days remaining: $daysRemaining)');
    } catch (e) {
      LoggerService.error('Error showing low stock notification: $e', e);
    }
  }

  /// Check all medications for low stock and send proactive notifications
  /// This should be called daily to alert users before they run out
  Future<void> checkLowStockForAllMedications() async {
    if (_isTestMode) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      const lastCheckKey = 'last_stock_check_date';
      final lastCheck = prefs.getString(lastCheckKey);

      // Only check once per day
      if (lastCheck == today) {
        LoggerService.info('📦 Stock already checked today, skipping');
        return;
      }

      LoggerService.info('📦 Checking low stock for all medications...');

      // Get all persons
      final persons = await DatabaseHelper.instance.getAllPersons();

      for (final person in persons) {
        // Get medications for this person
        final medications = await DatabaseHelper.instance.getMedicationsForPerson(person.id);

        for (final medication in medications) {
          // Skip suspended medications
          if (medication.isSuspended) continue;

          // Check if stock is low
          if (medication.isStockLow) {
            // Calculate days remaining
            int? daysRemaining;
            final dailyDose = medication.durationType == TreatmentDurationType.asNeeded
                ? medication.lastDailyConsumption
                : medication.totalDailyDose;

            if (dailyDose != null && dailyDose > 0) {
              daysRemaining = (medication.stockQuantity / dailyDose).floor();
            }

            // Show notification
            await showLowStockNotification(
              medication: medication,
              personName: person.name,
              isInsufficientForDose: false,
              daysRemaining: daysRemaining,
            );

            LoggerService.info('📦 Low stock alert sent for ${medication.name} (${person.name})');
          }
        }
      }

      // Save today's date to avoid duplicate checks
      await prefs.setString(lastCheckKey, today);
      LoggerService.info('📦 Stock check completed for today');
    } catch (e) {
      LoggerService.error('Error checking low stock: $e', e);
    }
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
      LoggerService.error('Error logging notification: $e', e);
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
      LoggerService.error('Error getting notification history: $e', e);
      return [];
    }
  }

  /// Clean notification history entries older than 24 hours
  void _cleanOldHistoryEntries(List<Map<String, dynamic>> history) {
    final cutoffTime = DateTime.now().subtract(
      const Duration(hours: _historyDurationHours),
    );

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
      LoggerService.error('Error clearing notification history: $e', e);
    }
  }
}
