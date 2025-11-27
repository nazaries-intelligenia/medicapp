import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/notification_service.dart';
import '../../../services/logger_service.dart';

class NotificationPermissionDialog {
  static Future<void> checkAndShowIfNeeded({
    required BuildContext context,
    required bool hasMedications,
  }) async {
    // Skip permission checks in test mode to avoid timer issues
    if (NotificationService.instance.isTestMode) {
      return;
    }

    // Wait a bit for the screen to load
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;

    // First, request basic notification permissions (this shows Android's system dialog)
    await NotificationService.instance.requestPermissions();

    // Wait for the system dialog to close
    await Future.delayed(const Duration(milliseconds: 500));

    if (!context.mounted) return;

    // Now check if exact alarms are allowed (critical for Android 12+)
    final canScheduleExact = await NotificationService.instance.canScheduleExactAlarms();

    LoggerService.info('🔔 Checking permissions - canScheduleExact: $canScheduleExact');

    if (!canScheduleExact && hasMedications) {
      // Show warning dialog for exact alarms only
      if (!context.mounted) return;
      await _showPermissionDialog(context);
    }
  }

  static Future<void> _showPermissionDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Flexible(child: Text(l10n.permissionRequired)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notificationsWillNotWork,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.alarm, size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.activateAlarmsPermission,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.alarmsPermissionDescription,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.notNowButton),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await NotificationService.instance.openExactAlarmSettings();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings, size: 16),
                const SizedBox(width: 6),
                Text(l10n.openSettingsButton),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
