import 'package:flutter/material.dart';
import '../../models/medication.dart';
import '../../models/treatment_duration_type.dart';
import '../../models/dose_history_entry.dart';
import '../../models/person.dart';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../services/preferences_service.dart';
import '../../services/dose_action_service.dart';
import '../../utils/medication_sorter.dart';
import '../../utils/datetime_extensions.dart';
import 'medication_cache_manager.dart';
import 'fasting_state_manager.dart';
import 'services/dose_calculation_service.dart';

/// ViewModel for the medication list screen.
///
/// Handles all business logic including:
/// - Loading medications and persons
/// - Managing caches (doses, fasting periods)
/// - Dose registration (taken, skipped, manual, extra)
/// - Medication operations (suspend, delete, refill)
/// - Notification management
/// - User preferences
class MedicationListViewModel extends ChangeNotifier {
  // Test mode flag - prevents excessive notifyListeners calls during tests
  bool _isTestMode = false;
  bool _notificationPending = false;

  // Data state
  final List<Medication> _medications = [];
  List<Person> _persons = [];
  Person? _selectedPerson;
  bool _isLoading = true;

  // Managers
  final MedicationCacheManager _cacheManager = MedicationCacheManager();
  final FastingStateManager _fastingManager = FastingStateManager();

  // User preferences
  bool _showActualTime = false;
  bool _showFastingCountdown = false;
  bool _showFastingNotification = false;

  // Getters
  List<Medication> get medications => List.unmodifiable(_medications);
  List<Person> get persons => List.unmodifiable(_persons);
  Person? get selectedPerson => _selectedPerson;
  bool get isLoading => _isLoading;
  bool get showActualTime => _showActualTime;
  bool get showFastingCountdown => _showFastingCountdown;
  bool get showFastingNotification => _showFastingNotification;
  List<Map<String, dynamic>> get activeFastingPeriods =>
      _fastingManager.activeFastingPeriods;

  // Cache getters
  Map<String, dynamic>? getAsNeededDosesInfo(String medicationId) =>
      _cacheManager.getAsNeededDosesInfo(medicationId);
  Map<String, DateTime>? getActualDoseTimes(String medicationId) =>
      _cacheManager.getActualDoseTimes(medicationId);

  /// Helper method to safely notify listeners with test mode support
  /// In test mode, this reduces the frequency of notifications to prevent
  /// pumpAndSettle timeouts caused by continuous rebuilds
  void _safeNotify() {
    // Always notify immediately - the batching approach doesn't work well with pumpAndSettle
    // The real fix is ensuring we don't have continuous rebuild loops
    notifyListeners();
  }

  @override
  void dispose() {
    _fastingManager.dispose();
    super.dispose();
  }

  /// Initialize the ViewModel - load preferences and data
  Future<void> initialize({bool isTestMode = false}) async {
    _isTestMode = isTestMode;
    await _loadPreferences();
    _fastingManager.updatePreferences(
      showFastingCountdown: _showFastingCountdown,
      showFastingNotification: _showFastingNotification,
    );
    _fastingManager.startNotificationTimer(isTestMode: isTestMode);
    await initializePersonsAndTabs();
  }

  /// Load all user preferences
  Future<void> _loadPreferences() async {
    _showActualTime = await PreferencesService.getShowActualTimeForTakenDoses();
    _showFastingCountdown = await PreferencesService.getShowFastingCountdown();
    _showFastingNotification =
        await PreferencesService.getShowFastingNotification();
  }

  /// Initialize persons and select the first one
  Future<void> initializePersonsAndTabs() async {
    // Migrate any unassigned medications to default person
    await DatabaseHelper.instance
        .migrateUnassignedMedicationsToDefaultPerson();

    final persons = await DatabaseHelper.instance.getAllPersons();

    // Sort persons: default person first, then alphabetically
    persons.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });

    _persons = persons;
    _selectedPerson = _persons.isNotEmpty ? _persons[0] : null;

    // Now that persons are loaded, load medications
    await loadMedications();
  }

  /// Change the selected person and reload medications
  Future<void> selectPerson(Person person) async {
    if (_selectedPerson?.id == person.id) return;
    _selectedPerson = person;
    _safeNotify();
    await loadMedications();
  }

  /// Load medications for the selected person
  Future<void> loadMedications() async {
    _isLoading = true;
    _safeNotify();

    try{
      // Load medications for selected person
      List<Medication> allMedications;
      if (_selectedPerson != null) {
        allMedications = await DatabaseHelper.instance
            .getMedicationsForPerson(_selectedPerson!.id);
      } else {
        allMedications = await DatabaseHelper.instance.getAllMedications();
      }

      // Synchronize system notifications with database medications
      await NotificationService.instance
          .syncNotificationsWithMedications(allMedications);

      // Get medication IDs that have doses registered today
      final medicationIdsWithDosesToday =
          await DatabaseHelper.instance.getMedicationIdsWithDosesToday();

      // Filter medications for display
      final medications = allMedications.where((m) {
        if (m.isSuspended) return false;
        if (m.durationType != TreatmentDurationType.asNeeded) return true;
        return medicationIdsWithDosesToday.contains(m.id);
      }).toList();

      // Load cache data
      await _loadCacheData(medications);

      // Load fasting periods
      await _fastingManager.loadFastingPeriods();

      // Sort medications by next dose proximity
      MedicationSorter.sortByNextDose(medications);

      // Update state
      _medications.clear();
      _medications.addAll(medications);
      _isLoading = false;
      _safeNotify();

      // Update fasting notification
      await _fastingManager.updateNotification();

      // Schedule notifications in background
      _scheduleNotificationsInBackground(medications);
    } catch (e) {
      _isLoading = false;
      _safeNotify();
      rethrow;
    }
  }

  /// Load cache data for medications
  Future<void> _loadCacheData(List<Medication> medications) async {
    _cacheManager.clearAll();

    // Load "as needed" doses information
    for (final med in medications) {
      if (med.durationType == TreatmentDurationType.asNeeded) {
        final dosesInfo = await DoseCalculationService.getAsNeededDosesInfo(med);
        if (dosesInfo != null) {
          _cacheManager.setAsNeededDosesInfo(med.id, dosesInfo);
        }
      }
    }

    // Load actual dose times if preference is enabled
    if (_showActualTime) {
      for (final med in medications) {
        if (med.isTakenDosesDateToday && med.takenDosesToday.isNotEmpty) {
          final actualTimes =
              await DoseCalculationService.getActualDoseTimes(med);
          if (actualTimes.isNotEmpty) {
            _cacheManager.setActualDoseTimes(med.id, actualTimes);
          }
        }
      }
    }
  }

  /// Schedule notifications in background
  void _scheduleNotificationsInBackground(List<Medication> medications) {
    // Skip background scheduling in test mode to prevent pumpAndSettle timeouts
    if (_isTestMode) return;

    Future.microtask(() async {
      for (final medication in medications) {
        try {
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(medication.id);
          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              medication,
              personId: person.id,
            );
          }
        } catch (e) {
          // Log error but don't block
          print('Error scheduling notifications for ${medication.name}: $e');
        }
      }
    });
  }

  /// Register a scheduled dose
  Future<String> registerDose({
    required Medication medication,
    required String doseTime,
  }) async {
    // Get fresh medication data
    final freshMedication = _selectedPerson != null
        ? await DatabaseHelper.instance
            .getMedicationForPerson(medication.id, _selectedPerson!.id)
        : await DatabaseHelper.instance.getMedication(medication.id);

    if (freshMedication == null) {
      throw Exception('Medication not found');
    }

    final doseQuantity = freshMedication.getDoseQuantity(doseTime);

    // Check stock
    if (freshMedication.stockQuantity < doseQuantity) {
      throw InsufficientStockException(
        doseQuantity: doseQuantity,
        availableStock: freshMedication.stockQuantity,
        unit: freshMedication.type.stockUnit,
      );
    }

    // Update taken doses
    final today = DateTime.now();
    final todayString = today.toDateString();

    List<String> updatedTakenDoses;
    List<String> updatedSkippedDoses;

    if (freshMedication.takenDosesDate == todayString) {
      updatedTakenDoses = List.from(freshMedication.takenDosesToday);
      updatedTakenDoses.add(doseTime);
      updatedSkippedDoses = List.from(freshMedication.skippedDosesToday);
    } else {
      updatedTakenDoses = [doseTime];
      updatedSkippedDoses = [];
    }

    // Update medication
    final updatedMedication = freshMedication.copyWith(
      stockQuantity: freshMedication.stockQuantity - doseQuantity,
      takenDosesToday: updatedTakenDoses,
      skippedDosesToday: updatedSkippedDoses,
      takenDosesDate: todayString,
    );

    // Get person for updates
    final defaultPerson =
        _selectedPerson ?? await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    } else {
      await DatabaseHelper.instance.updateMedication(updatedMedication);
    }

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
      id: '${freshMedication.id}_${now.millisecondsSinceEpoch}',
      medicationId: freshMedication.id,
      medicationName: freshMedication.name,
      medicationType: freshMedication.type,
      personId: personId,
      scheduledDateTime: scheduledDateTime,
      registeredDateTime: now,
      status: DoseStatus.taken,
      quantity: doseQuantity,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Cancel today's notification
    await NotificationService.instance.cancelTodaysDoseNotification(
      medication: updatedMedication,
      doseTime: doseTime,
      personId: personId,
    );

    // Reschedule notifications
    await NotificationService.instance.scheduleMedicationNotifications(
      updatedMedication,
      personId: personId,
    );

    // Cancel fasting notification if needed
    await NotificationService.instance.cancelTodaysFastingNotification(
      medication: updatedMedication,
      doseTime: doseTime,
      personId: personId,
    );

    // Schedule dynamic fasting notification if needed
    if (updatedMedication.requiresFasting &&
        updatedMedication.fastingType == 'after' &&
        updatedMedication.notifyFasting) {
      await NotificationService.instance.scheduleDynamicFastingNotification(
        medication: updatedMedication,
        actualDoseTime: DateTime.now(),
        personId: personId,
      );
    }

    // Reload medications
    await loadMedications();

    // Return confirmation message data
    final remainingDoses = updatedMedication.getAvailableDosesToday();
    return remainingDoses.isEmpty
        ? 'allComplete|${updatedMedication.stockDisplayText}'
        : 'remaining|${remainingDoses.length}|${updatedMedication.stockDisplayText}';
  }

  /// Register an extra dose
  Future<String> registerExtraDose({
    required Medication medication,
  }) async {
    // Get fresh medication data
    final freshMedication = _selectedPerson != null
        ? await DatabaseHelper.instance
            .getMedicationForPerson(medication.id, _selectedPerson!.id)
        : await DatabaseHelper.instance.getMedication(medication.id);

    if (freshMedication == null) {
      throw Exception('Medication not found');
    }

    // Get default dose quantity
    final doseQuantity = freshMedication.doseSchedule.values.first;

    // Register extra dose using service
    final updatedMedication = await DoseActionService.registerExtraDose(
      medication: freshMedication,
      quantity: doseQuantity,
    );

    // Reload medications
    await loadMedications();

    // Return success message data
    final now = DateTime.now();
    final currentTime = now.toTimeString();
    return 'extraDose|$currentTime|${updatedMedication.stockDisplayText}';
  }

  /// Register a manual dose (for "as needed" medications)
  Future<String> registerManualDose({
    required Medication medication,
    required double quantity,
  }) async {
    // Check stock
    if (medication.stockQuantity < quantity) {
      throw InsufficientStockException(
        doseQuantity: quantity,
        availableStock: medication.stockQuantity,
        unit: medication.type.stockUnit,
      );
    }

    // Update medication
    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity - quantity,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);

    // Create history entry
    final now = DateTime.now();
    final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    final historyEntry = DoseHistoryEntry(
      id: '${medication.id}_${now.millisecondsSinceEpoch}',
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: now,
      registeredDateTime: now,
      status: DoseStatus.taken,
      quantity: quantity,
    );

    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Cancel next pending notification if applicable
    await _cancelNextPendingNotification(updatedMedication, personId);

    // Schedule dynamic fasting notification if needed
    if (updatedMedication.requiresFasting &&
        updatedMedication.fastingType == 'after' &&
        updatedMedication.notifyFasting) {
      await NotificationService.instance.scheduleDynamicFastingNotification(
        medication: updatedMedication,
        actualDoseTime: now,
        personId: personId,
      );
    }

    // Reload medications
    await loadMedications();

    return 'manualDose|$quantity|${medication.type.stockUnit}|${updatedMedication.stockDisplayText}';
  }

  /// Cancel next pending notification after manual dose
  Future<void> _cancelNextPendingNotification(
      Medication medication, String personId) async {
    if (medication.doseTimes.isEmpty) return;

    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    String? nextDoseTime;
    for (final doseTime in medication.doseTimes) {
      final parts = doseTime.split(':');
      final doseTimeOfDay = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );

      final doseMinutes = doseTimeOfDay.hour * 60 + doseTimeOfDay.minute;
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;

      if (doseMinutes > currentMinutes &&
          !medication.takenDosesToday.contains(doseTime)) {
        nextDoseTime = doseTime;
        break;
      }
    }

    if (nextDoseTime != null) {
      await NotificationService.instance.cancelTodaysDoseNotification(
        medication: medication,
        doseTime: nextDoseTime,
        personId: personId,
      );
      await NotificationService.instance.scheduleMedicationNotifications(
        medication,
        personId: personId,
      );
    }
  }

  /// Toggle medication suspension status
  Future<String> toggleSuspendMedication(Medication medication) async {
    final updatedMedication = medication.copyWith(
      isSuspended: !medication.isSuspended,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);

    if (updatedMedication.isSuspended) {
      await NotificationService.instance.cancelMedicationNotifications(
        medication.id,
        medication: updatedMedication,
      );
    } else {
      final persons = await DatabaseHelper.instance
          .getPersonsForMedication(updatedMedication.id);
      for (final person in persons) {
        await NotificationService.instance.scheduleMedicationNotifications(
          updatedMedication,
          personId: person.id,
        );
      }
    }

    await loadMedications();

    return updatedMedication.isSuspended ? 'suspended' : 'reactivated';
  }

  /// Refill medication stock
  Future<String> refillMedication({
    required Medication medication,
    required double amount,
  }) async {
    final updatedMedication = medication.copyWith(
      stockQuantity: medication.stockQuantity + amount,
      lastRefillAmount: amount,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);
    await loadMedications();

    return 'refill|$amount|${medication.type.stockUnit}|${updatedMedication.stockDisplayText}';
  }

  /// Delete a medication
  Future<void> deleteMedication(Medication medication) async {
    await DatabaseHelper.instance.deleteMedication(medication.id);
    await NotificationService.instance
        .cancelMedicationNotifications(medication.id, medication: medication);
    _medications.remove(medication);
    _safeNotify();
  }

  /// Delete a dose from today's history
  Future<void> deleteTodayDose({
    required Medication medication,
    required String doseTime,
    required bool wasTaken,
  }) async {
    List<String> takenDoses = List.from(medication.takenDosesToday);
    List<String> skippedDoses = List.from(medication.skippedDosesToday);

    if (wasTaken) {
      takenDoses.remove(doseTime);
    } else {
      skippedDoses.remove(doseTime);
    }

    double newStock = medication.stockQuantity;
    if (wasTaken) {
      final doseQuantity = medication.getDoseQuantity(doseTime);
      newStock += doseQuantity;
    }

    final updatedMedication = medication.copyWith(
      stockQuantity: newStock,
      takenDosesToday: takenDoses,
      skippedDosesToday: skippedDoses,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);

    // Delete from history
    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(doseTime.split(':')[0]),
      int.parse(doseTime.split(':')[1]),
    );

    final historyEntries =
        await DatabaseHelper.instance.getDoseHistoryForMedication(medication.id);
    for (final entry in historyEntries) {
      if (entry.scheduledDateTime.year == scheduledDateTime.year &&
          entry.scheduledDateTime.month == scheduledDateTime.month &&
          entry.scheduledDateTime.day == scheduledDateTime.day &&
          entry.scheduledDateTime.hour == scheduledDateTime.hour &&
          entry.scheduledDateTime.minute == scheduledDateTime.minute) {
        await DatabaseHelper.instance.deleteDoseHistory(entry.id);
        break;
      }
    }

    await loadMedications();
  }

  /// Toggle dose status between taken and skipped
  Future<void> toggleTodayDoseStatus({
    required Medication medication,
    required String doseTime,
    required bool wasTaken,
  }) async {
    List<String> takenDoses = List.from(medication.takenDosesToday);
    List<String> skippedDoses = List.from(medication.skippedDosesToday);

    double newStock = medication.stockQuantity;
    final doseQuantity = medication.getDoseQuantity(doseTime);

    if (wasTaken) {
      takenDoses.remove(doseTime);
      skippedDoses.add(doseTime);
      newStock += doseQuantity;
    } else {
      skippedDoses.remove(doseTime);
      takenDoses.add(doseTime);
      if (newStock < doseQuantity) {
        throw InsufficientStockException(
          doseQuantity: doseQuantity,
          availableStock: newStock,
          unit: medication.type.stockUnit,
        );
      }
      newStock -= doseQuantity;
    }

    final updatedMedication = medication.copyWith(
      stockQuantity: newStock,
      takenDosesToday: takenDoses,
      skippedDosesToday: skippedDoses,
    );

    await DatabaseHelper.instance.updateMedication(updatedMedication);

    // Update history entry
    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(doseTime.split(':')[0]),
      int.parse(doseTime.split(':')[1]),
    );

    final historyEntries =
        await DatabaseHelper.instance.getDoseHistoryForMedication(medication.id);
    for (final entry in historyEntries) {
      if (entry.scheduledDateTime.year == scheduledDateTime.year &&
          entry.scheduledDateTime.month == scheduledDateTime.month &&
          entry.scheduledDateTime.day == scheduledDateTime.day &&
          entry.scheduledDateTime.hour == scheduledDateTime.hour &&
          entry.scheduledDateTime.minute == scheduledDateTime.minute) {
        final updatedEntry = entry.copyWith(
          status: wasTaken ? DoseStatus.skipped : DoseStatus.taken,
          registeredDateTime: DateTime.now(),
        );
        await DatabaseHelper.instance.insertDoseHistory(updatedEntry);
        break;
      }
    }

    await loadMedications();
  }

  /// Create a new medication for the current person
  Future<void> createMedication(Medication medication) async {
    Person? targetPerson = _selectedPerson;
    if (targetPerson == null) {
      targetPerson = await DatabaseHelper.instance.getDefaultPerson();
    }

    if (targetPerson != null) {
      await DatabaseHelper.instance.createMedicationForPerson(
        medication: medication,
        personId: targetPerson.id,
      );
    }

    await loadMedications();
  }

  /// Update an existing medication
  Future<void> updateMedication(Medication medication) async {
    Person? targetPerson = _selectedPerson;
    if (targetPerson == null) {
      targetPerson = await DatabaseHelper.instance.getDefaultPerson();
    }

    if (targetPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: medication,
        personId: targetPerson.id,
      );
    }

    await loadMedications();

    // Reschedule notifications in background (skip in test mode)
    if (!_isTestMode) {
      Future.microtask(() async {
        try {
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(medication.id);
          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              medication,
              personId: person.id,
            );
          }
        } catch (e) {
          print('Error rescheduling notifications for ${medication.name}: $e');
        }
      });
    }
  }

  /// Reschedule all notifications (debug function)
  Future<int> rescheduleAllNotifications() async {
    for (final medication in _medications) {
      if (medication.doseTimes.isNotEmpty) {
        final persons = await DatabaseHelper.instance
            .getPersonsForMedication(medication.id);
        for (final person in persons) {
          await NotificationService.instance.scheduleMedicationNotifications(
            medication,
            personId: person.id,
          );
        }
      }
    }

    final pending =
        await NotificationService.instance.getPendingNotifications();
    return pending.length;
  }
}

/// Exception thrown when there's insufficient stock for a dose
class InsufficientStockException implements Exception {
  final double doseQuantity;
  final double availableStock;
  final String unit;

  InsufficientStockException({
    required this.doseQuantity,
    required this.availableStock,
    required this.unit,
  });
}
