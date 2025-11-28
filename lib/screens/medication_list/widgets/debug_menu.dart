import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/notification_service.dart';
import '../../../utils/platform_helper.dart';

class DebugMenu extends StatelessWidget {
  final VoidCallback onTestNotification;
  final VoidCallback onTestScheduled;
  final VoidCallback onReschedule;
  final VoidCallback onShowDebugInfo;

  const DebugMenu({
    super.key,
    required this.onTestNotification,
    required this.onTestScheduled,
    required this.onReschedule,
    required this.onShowDebugInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'test') {
          onTestNotification();
        } else if (value == 'test_scheduled') {
          onTestScheduled();
        } else if (value == 'reschedule') {
          onReschedule();
        } else if (value == 'debug') {
          onShowDebugInfo();
        } else if (value == 'open_alarms') {
          NotificationService.instance.openExactAlarmSettings();
        } else if (value == 'open_battery') {
          NotificationService.instance.openBatteryOptimizationSettings();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'test',
          child: Row(
            children: [
              const Icon(Icons.notifications_active),
              const SizedBox(width: 8),
              Text(l10n.testNotification),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'test_scheduled',
          child: Row(
            children: [
              const Icon(Icons.alarm_add),
              const SizedBox(width: 8),
              Text(l10n.testScheduled1Min),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'reschedule',
          child: Row(
            children: [
              const Icon(Icons.refresh),
              const SizedBox(width: 8),
              Text(l10n.rescheduleNotifications),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'debug',
          child: Row(
            children: [
              const Icon(Icons.info_outline),
              const SizedBox(width: 8),
              Text(l10n.notificationsInfo),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'open_alarms',
          child: Row(
            children: [
              const Icon(Icons.alarm),
              const SizedBox(width: 8),
              Text(l10n.alarmsAndReminders),
            ],
          ),
        ),
        // Battery optimization is only available on Android
        if (PlatformHelper.isAndroid)
          PopupMenuItem(
            value: 'open_battery',
            child: Row(
              children: [
                const Icon(Icons.battery_full),
                const SizedBox(width: 8),
                Text(l10n.batteryOptimizationMenu),
              ],
            ),
          ),
      ],
    );
  }
}
