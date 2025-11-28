import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:android_intent_plus/android_intent.dart';
import '../../utils/platform_helper.dart';

/// Shared configuration and factory methods for notification services
class NotificationConfig {
  /// Channel ID for medication reminders
  static const String medicationChannelId = 'medication_reminders';
  /// Get standard Android notification details for medication reminders
  /// Pass [autoCancel] = true to auto-cancel the notification after user taps
  /// Pass [includeActions] = true to include quick actions (Register, Skip, Snooze)
  static fln.AndroidNotificationDetails getAndroidNotificationDetails({
    bool autoCancel = false,
    bool includeActions = true,
  }) {
    // Define notification actions (icons removed as they're optional and causing type issues)
    final actions = includeActions ? <fln.AndroidNotificationAction>[
      const fln.AndroidNotificationAction(
        'register_dose',
        'Registrar',
        showsUserInterface: false,
      ),
      const fln.AndroidNotificationAction(
        'skip_dose',
        'No tomada',
        showsUserInterface: false,
      ),
      const fln.AndroidNotificationAction(
        'snooze_dose',
        'Posponer 10min',
        showsUserInterface: false,
      ),
    ] : null;

    return fln.AndroidNotificationDetails(
      medicationChannelId, // channel ID
      'Recordatorios de Medicamentos', // channel name
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
      autoCancel: autoCancel,
      actions: actions,
    );
  }

  /// Opens the notification settings for the app on Android
  /// This allows users to customize sound, vibration, and other notification settings
  /// Works on Android 8.0+ (API 26+) for channel settings, fallback for older versions
  /// Returns true if notification-specific settings were opened, false if only app settings
  static Future<bool> openNotificationChannelSettings() async {
    if (!PlatformHelper.isAndroid) {
      return false; // Only available on Android
    }

    const packageName = 'com.medicapp.medicapp';

    // Try notification-specific intents first (Android 8.0+)
    final notificationIntents = [
      // Approach 1: Channel-specific settings (Android 8.0+)
      AndroidIntent(
        action: 'android.settings.CHANNEL_NOTIFICATION_SETTINGS',
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE': packageName,
          'android.provider.extra.CHANNEL_ID': medicationChannelId,
        },
      ),
      // Approach 2: App notification settings (Android 8.0+)
      AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE': packageName,
        },
      ),
    ];

    // Try notification-specific intents
    for (final intent in notificationIntents) {
      try {
        final canResolve = await intent.canResolveActivity();
        if (canResolve == true) {
          await intent.launch();
          return true; // Opened notification settings
        }
      } catch (_) {
        continue;
      }
    }

    // Fallback: General app settings (works on all Android versions)
    try {
      final appSettingsIntent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:$packageName',
      );
      final canResolve = await appSettingsIntent.canResolveActivity();
      if (canResolve == true) {
        await appSettingsIntent.launch();
        return false; // Opened app settings, not notification-specific
      }
    } catch (_) {
      // Ignore
    }

    // If all approaches failed, throw an error
    throw Exception('No se pudo abrir los ajustes');
  }

  /// Get standard iOS/Darwin notification details for medication reminders
  static fln.DarwinNotificationDetails getDarwinNotificationDetails() {
    return const fln.DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }

  /// Helper method to generate notification title based on person
  /// V19+: Only shows person name in title if person is not the default user
  static String buildNotificationTitle(String? personName, bool isDefault, {String suffix = ''}) {
    if (isDefault) {
      // Default user: don't show name
      return suffix.isEmpty ? '💊 Hora de tomar medicamento' : '💊 Hora de tomar medicamento $suffix';
    } else {
      // Other users: show name in title
      final name = personName ?? 'Usuario';
      return suffix.isEmpty ? '💊 $name - Hora de tomar medicamento' : '💊 $name - Hora de tomar medicamento $suffix';
    }
  }

  /// Get Android notification details specifically for fasting completion alerts
  /// These should have maximum priority and sound to ensure user sees them
  static fln.AndroidNotificationDetails getFastingCompletionAndroidDetails() {
    return const fln.AndroidNotificationDetails(
      'fasting_completion', // Unique channel ID for fasting alerts
      'Alertas de fin de ayuno',
      channelDescription: 'Notificaciones importantes cuando termina el período de ayuno',
      importance: fln.Importance.max,  // Maximum importance
      priority: fln.Priority.max,      // Maximum priority
      ticker: 'Fin del ayuno',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
      autoCancel: true,  // Auto-dismiss when tapped
    );
  }

  /// Get NotificationDetails specifically for fasting completion notifications
  static fln.NotificationDetails getFastingCompletionDetails() {
    return fln.NotificationDetails(
      android: getFastingCompletionAndroidDetails(),
      iOS: getDarwinNotificationDetails(),
    );
  }

  /// Create standard NotificationDetails for regular notifications
  static fln.NotificationDetails getNotificationDetails({bool autoCancel = false}) {
    return fln.NotificationDetails(
      android: getAndroidNotificationDetails(autoCancel: autoCancel),
      iOS: getDarwinNotificationDetails(),
    );
  }

  /// Get Android notification details for low stock alerts
  static fln.AndroidNotificationDetails getStockAlertAndroidDetails() {
    return const fln.AndroidNotificationDetails(
      'stock_alerts', // Unique channel ID for stock alerts
      'Alertas de Stock Bajo',
      channelDescription: 'Notificaciones cuando el stock de medicamentos está bajo',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Stock bajo de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
    );
  }

  /// Create NotificationDetails for low stock alerts
  static fln.NotificationDetails stockAlert({
    required String personName,
    required String medicationName,
  }) {
    return fln.NotificationDetails(
      android: getStockAlertAndroidDetails(),
      iOS: getDarwinNotificationDetails(),
    );
  }
}
