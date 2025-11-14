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

    // Filter out periods that have already finished
    // Only keep periods where the fasting end time is in the future
    final now = DateTime.now();
    _activeFastingPeriods.removeWhere((period) {
      final endTime = period['fastingEndTime'] as DateTime;
      final hasEnded = endTime.isBefore(now);
      if (hasEnded) {
        print('   Removing finished period: ends at $endTime (${period['medicationName']} for ${period['personName']})');
      }
      return hasEnded;
    });

    print('🔄 After removing finished periods: ${_activeFastingPeriods.length} active periods');

    // Filter to keep only the LATEST ending fasting period per person
    // (If a person has multiple medications requiring fasting, show only the most restrictive one)
    final Map<String, Map<String, dynamic>> latestByPerson = {};
    for (final period in _activeFastingPeriods) {
      final personId = period['personId'] as String;
      final endTime = period['fastingEndTime'] as DateTime;

      if (!latestByPerson.containsKey(personId)) {
        // First fasting period for this person
        latestByPerson[personId] = period;
      } else {
        // Compare with existing period for this person
        final existingEndTime = latestByPerson[personId]!['fastingEndTime'] as DateTime;
        if (endTime.isAfter(existingEndTime)) {
          // This fasting period ends later, so it's more restrictive
          latestByPerson[personId] = period;
        }
      }
    }

    // Replace list with filtered results (one per person)
    _activeFastingPeriods.clear();
    _activeFastingPeriods.addAll(latestByPerson.values);

    print('🔄 After filtering: ${_activeFastingPeriods.length} periods (one per person)');

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

  // Track which persons currently have active ongoing notifications
  final Set<String> _personsWithActiveNotifications = {};

  /// Update or cancel the ongoing fasting notification based on current state
  Future<void> updateNotification() async {
    // Only show on Android and if both preferences are enabled
    if (!PlatformHelper.isAndroid ||
        !_showFastingCountdown ||
        !_showFastingNotification) {
      await NotificationService.instance.cancelOngoingFastingNotification();
      _personsWithActiveNotifications.clear();
      return;
    }

    // Track which persons should have notifications in this update cycle
    final Set<String> currentActivePersons = {};

    // Show notifications for ALL active fasting periods (one per person)
    if (_activeFastingPeriods.isNotEmpty) {
      for (final fastingPeriod in _activeFastingPeriods) {
        final personId = fastingPeriod['personId'] as String;
        final personName = fastingPeriod['personName'] as String;
        final medicationName = fastingPeriod['medicationName'] as String;
        final endTime = fastingPeriod['fastingEndTime'] as DateTime;
        final remainingMinutes = endTime.difference(DateTime.now()).inMinutes;

        // If fasting already ended, cancel notification for this person
        if (remainingMinutes < 0) {
          if (_personsWithActiveNotifications.contains(personId)) {
            print('⏰ Fasting ended for $personName - cancelling ongoing notification');
            await NotificationService.instance.cancelOngoingFastingNotificationForPerson(personId);
            _personsWithActiveNotifications.remove(personId);
          }
          continue;
        }

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

        currentActivePersons.add(personId);
      }

      // Update tracking set
      _personsWithActiveNotifications.clear();
      _personsWithActiveNotifications.addAll(currentActivePersons);
    } else {
      // No active fasting periods - cancel all notifications
      await NotificationService.instance.cancelOngoingFastingNotification();
      _personsWithActiveNotifications.clear();
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
