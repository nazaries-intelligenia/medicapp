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
    print('🔄 Loading fasting periods...');
    _activeFastingPeriods.clear();

    if (!_showFastingCountdown) {
      print('❌ Fasting countdown is disabled in settings - skipping load');
      return;
    }

    print('✅ Fasting countdown is enabled - proceeding with load');

    // Load all persons to check their fasting periods
    final allPersons = await DatabaseHelper.instance.getAllPersons();
    print('   Found ${allPersons.length} persons');

    for (final person in allPersons) {
      print('   Checking person: ${person.name} (${person.id})');
      // Load medications for this person
      final personMeds =
          await DatabaseHelper.instance.getMedicationsForPerson(person.id);
      print('      Medications for this person: ${personMeds.length}');

      for (final med in personMeds) {
        print('      Medication: ${med.name}, requiresFasting: ${med.requiresFasting}');
        if (med.requiresFasting) {
          // Pass personId to filter doses for this specific person
          final fastingInfo =
              await DoseCalculationService.getActiveFastingPeriod(
            med,
            personId: person.id,
          );
          if (fastingInfo != null) {
            print('      ✅ Found active fasting period for ${med.name}');
            // Add fasting period with person information
            _activeFastingPeriods.add({
              'personId': person.id,
              'personName': person.name,
              'personIsDefault': person.isDefault,
              'medicationId': med.id,
              'medicationName': med.name,
              ...fastingInfo, // includes: fastingEndTime, fastingType, medicationName
            });
          } else {
            print('      ❌ No active fasting period for ${med.name}');
          }
        }
      }
    }

    print('🔄 Loaded ${_activeFastingPeriods.length} active fasting periods');

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

    // Show notifications for ALL active fasting periods (one per person)
    if (_activeFastingPeriods.isNotEmpty) {
      // Track which persons have active fasting
      final Set<String> activePersons = {};

      for (final fastingPeriod in _activeFastingPeriods) {
        final personId = fastingPeriod['personId'] as String;
        final personName = fastingPeriod['personName'] as String;
        final medicationName = fastingPeriod['medicationName'] as String;
        final endTime = fastingPeriod['fastingEndTime'] as DateTime;
        final remainingMinutes = endTime.difference(DateTime.now()).inMinutes;

        // Skip if fasting already ended
        if (remainingMinutes < 0) continue;

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

        // Show notification for this person
        await NotificationService.instance.showOngoingFastingNotification(
          personId: personId,
          medicationName: '$medicationName ($personName)',
          timeRemaining: timeRemaining,
          endTime: endTimeFormatted,
        );

        activePersons.add(personId);
      }

      // Cancel notifications for persons who are no longer fasting
      // (This handles the case where a fasting period just ended)
      // TODO: Track previously active persons to cancel their notifications
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
