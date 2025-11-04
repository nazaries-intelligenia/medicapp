import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;

/// Shared configuration and factory methods for notification services
class NotificationConfig {
  /// Get standard Android notification details for medication reminders
  /// Pass [autoCancel] = true to auto-cancel the notification after user taps
  static fln.AndroidNotificationDetails getAndroidNotificationDetails({bool autoCancel = false}) {
    return fln.AndroidNotificationDetails(
      'medication_reminders', // channel ID
      'Recordatorios de Medicamentos', // channel name
      channelDescription: 'Notificaciones para recordarte tomar tus medicamentos',
      importance: fln.Importance.high,
      priority: fln.Priority.high,
      ticker: 'Recordatorio de medicamento',
      icon: '@drawable/ic_notification',
      enableVibration: true,
      playSound: true,
      autoCancel: autoCancel,
    );
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

  /// Create standard NotificationDetails for regular notifications
  static fln.NotificationDetails getNotificationDetails({bool autoCancel = false}) {
    return fln.NotificationDetails(
      android: getAndroidNotificationDetails(autoCancel: autoCancel),
      iOS: getDarwinNotificationDetails(),
    );
  }
}
