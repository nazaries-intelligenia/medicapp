import 'dart:async';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../utils/datetime_extensions.dart';
import '../../utils/platform_helper.dart';
import 'services/dose_calculation_service.dart';

/// Manages fasting periods and notifications across all persons.
///
/// This class handles:
/// - Loading active fasting periods from all persons
/// - Sorting fasting periods by urgency (end time)
/// - Managing the ongoing fasting notification
/// - Periodic updates of the fasting notification
class FastingStateManager {
  // Cache for fasting periods - stores list of all active fasting periods across all persons
  final List<Map<String, dynamic>> _activeFastingPeriods = [];

  // Timer for updating ongoing fasting notification
  Timer? _fastingNotificationTimer;

  // User preferences
  bool _showFastingCountdown = false;
  bool _showFastingNotification = false;

  /// Get all active fasting periods (sorted by end time, soonest first)
  List<Map<String, dynamic>> get activeFastingPeriods =>
      List.unmodifiable(_activeFastingPeriods);

  /// Check if there are any active fasting periods
  bool get hasActiveFastingPeriods => _activeFastingPeriods.isNotEmpty;

  /// Update user preferences
  void updatePreferences({
    required bool showFastingCountdown,
    required bool showFastingNotification,
  }) {
    _showFastingCountdown = showFastingCountdown;
    _showFastingNotification = showFastingNotification;
  }

  /// Load fasting periods from ALL persons (not just selected tab)
  Future<void> loadFastingPeriods() async {
    _activeFastingPeriods.clear();

    if (!_showFastingCountdown) {
      return;
    }

    // Load all persons to check their fasting periods
    final allPersons = await DatabaseHelper.instance.getAllPersons();

    for (final person in allPersons) {
      // Load medications for this person
      final personMeds =
          await DatabaseHelper.instance.getMedicationsForPerson(person.id);

      for (final med in personMeds) {
        if (med.requiresFasting) {
          final fastingInfo =
              await DoseCalculationService.getActiveFastingPeriod(med);
          if (fastingInfo != null) {
            // Add fasting period with person information
            _activeFastingPeriods.add({
              'personId': person.id,
              'personName': person.name,
              'personIsDefault': person.isDefault,
              'medicationId': med.id,
              'medicationName': med.name,
              ...fastingInfo, // includes: fastingEndTime, fastingType, medicationName
            });
          }
        }
      }
    }

    // Sort by fasting end time (soonest first)
    _activeFastingPeriods.sort((a, b) {
      final aTime = a['fastingEndTime'] as DateTime;
      final bTime = b['fastingEndTime'] as DateTime;
      return aTime.compareTo(bTime);
    });
  }

  /// Start timer to update ongoing fasting notification every minute
  void startNotificationTimer({bool isTestMode = false}) {
    // Don't start timer in test mode to prevent pumpAndSettle from timing out
    if (isTestMode) return;

    _fastingNotificationTimer?.cancel();
    _fastingNotificationTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => updateNotification(),
    );
    // Update immediately
    updateNotification();
  }

  /// Update or cancel the ongoing fasting notification based on current state
  Future<void> updateNotification() async {
    // Only show on Android and if both preferences are enabled
    if (!PlatformHelper.isAndroid ||
        !_showFastingCountdown ||
        !_showFastingNotification) {
      await NotificationService.instance.cancelOngoingFastingNotification();
      return;
    }

    // Show or cancel notification based on active fasting periods
    if (_activeFastingPeriods.isNotEmpty) {
      // Get the most urgent fasting period (already sorted by end time)
      final mostUrgent = _activeFastingPeriods.first;
      final endTime = mostUrgent['fastingEndTime'] as DateTime;
      final remainingMinutes = endTime.difference(DateTime.now()).inMinutes;

      // Format time remaining
      String timeRemaining;
      if (remainingMinutes < 60) {
        timeRemaining = '$remainingMinutes min';
      } else {
        final hours = remainingMinutes ~/ 60;
        final minutes = remainingMinutes % 60;
        if (minutes == 0) {
          timeRemaining = '${hours}h';
        } else {
          timeRemaining = '${hours}h ${minutes}m';
        }
      }

      // Format end time
      final endTimeFormatted = endTime.toTimeString();

      // Extract info from mostUrgent map
      final personName = mostUrgent['personName'] as String;
      final medicationName = mostUrgent['medicationName'] as String;

      await NotificationService.instance.showOngoingFastingNotification(
        medicationName: '$medicationName ($personName)',
        timeRemaining: timeRemaining,
        endTime: endTimeFormatted,
      );
    } else {
      await NotificationService.instance.cancelOngoingFastingNotification();
    }
  }

  /// Stop the notification timer
  void stopNotificationTimer() {
    _fastingNotificationTimer?.cancel();
    _fastingNotificationTimer = null;
  }

  /// Dispose of resources
  void dispose() {
    stopNotificationTimer();
  }
}
