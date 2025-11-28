import 'package:flutter/material.dart';
import '../../models/medication.dart';
import '../../models/treatment_duration_type.dart';
import '../../models/dose_history_entry.dart';
import '../../models/person.dart';
import '../../database/database_helper.dart';
import '../../services/notification_service.dart';
import '../../services/preferences_service.dart';
import '../../services/dose_action_service.dart';
import '../../services/logger_service.dart';
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
  bool _showPersonTabs = true;

  // Map to associate medications with their assigned persons (for mixed view)
  final Map<String, List<Person>> _medicationPersons = {};

  // Getters
  List<Medication> get medications => List.unmodifiable(_medications);
  List<Person> get persons => List.unmodifiable(_persons);
  Person? get selectedPerson => _selectedPerson;
  bool get isLoading => _isLoading;
  bool get showActualTime => _showActualTime;
  bool get showFastingCountdown => _showFastingCountdown;
  bool get showFastingNotification => _showFastingNotification;
  bool get showPersonTabs => _showPersonTabs;
  List<Map<String, dynamic>> get activeFastingPeriods =>
      _fastingManager.activeFastingPeriods;

  /// Get persons assigned to a medication (useful when showPersonTabs = false)
  List<Person> getPersonsForMedication(String medicationId) {
    return _medicationPersons[medicationId] ?? [];
  }

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

  /// Helper: Get fresh medication data from database
  @visibleForTesting
  Future<Medication?> getFreshMedication(String medicationId) async {
    return _selectedPerson != null
        ? await DatabaseHelper.instance
            .getMedicationForPerson(medicationId, _selectedPerson!.id)
        : await DatabaseHelper.instance.getMedication(medicationId);
  }

  /// Helper: Get person ID for current context
  @visibleForTesting
  Future<String> getPersonId() async {
    final person = _selectedPerson ??
                   await DatabaseHelper.instance.getDefaultPerson();
    return person?.id ?? '';
  }

  /// Helper: Create dose history entry
  @visibleForTesting
  DoseHistoryEntry createDoseHistoryEntry({
    required Medication medication,
    required String doseTime,
    required String personId,
    required DoseStatus status,
    required double quantity,
  }) {
    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(doseTime.split(':')[0]),
      int.parse(doseTime.split(':')[1]),
    );

    return DoseHistoryEntry(
      id: '${medication.id}_${now.millisecondsSinceEpoch}',
      medicationId: medication.id,
      medicationName: medication.name,
      medicationType: medication.type,
      personId: personId,
      scheduledDateTime: scheduledDateTime,
      registeredDateTime: now,
      status: status,
      quantity: quantity,
    );
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
    _showPersonTabs = await PreferencesService.getShowPersonTabs();
  }

  /// Reload preferences and reinitialize if showPersonTabs changed or persons changed
  Future<void> reloadPreferences() async {
    final oldShowPersonTabs = _showPersonTabs;
    final oldShowFastingCountdown = _showFastingCountdown;
    final oldShowFastingNotification = _showFastingNotification;
    final oldPersonsCount = _persons.length;
    await _loadPreferences();

    // Update fasting manager preferences if they changed
    if (oldShowFastingCountdown != _showFastingCountdown ||
        oldShowFastingNotification != _showFastingNotification) {
      _fastingManager.updatePreferences(
        showFastingCountdown: _showFastingCountdown,
        showFastingNotification: _showFastingNotification,
      );
      // Reload fasting periods with new preferences
      await _fastingManager.loadFastingPeriods();
      // Update notification immediately
      await _fastingManager.updateNotification();
      // Notify UI to rebuild
      _safeNotify();
    }

    // Reload persons to check if the list changed
    final persons = await DatabaseHelper.instance.getAllPersons();
    persons.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });

    // If showPersonTabs preference changed OR person count changed, reinitialize
    if (oldShowPersonTabs != _showPersonTabs || oldPersonsCount != persons.length) {
      await initializePersonsAndTabs();
    }
  }

  /// Initialize persons and select the first one
  Future<void> initializePersonsAndTabs() async {
    // Skip migration in test mode to prevent database locks
    // In tests, migrations are handled by test setup
    if (!_isTestMode) {
      // Migrate any unassigned medications to default person
      await DatabaseHelper.instance
          .migrateUnassignedMedicationsToDefaultPerson();
    }

    final persons = await DatabaseHelper.instance.getAllPersons();

    // Sort persons: default person first, then alphabetically
    persons.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });

    _persons = persons;

    // Only select a person if person tabs are enabled
    // In mixed view mode, we don't need a selected person
    if (_showPersonTabs) {
      _selectedPerson = _persons.isNotEmpty ? _persons[0] : null;
    } else {
      _selectedPerson = null;
    }

    // Now that persons are loaded, load medications
    await loadMedications();
  }

  /// Change the selected person and reload medications
  Future<void> selectPerson(Person person) async {
    if (_selectedPerson?.id == person.id) return;
    _selectedPerson = person;
    _safeNotify();

    // Use optimized reload (fast, no notification sync)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();
  }

  /// Load medications for a specific date
  Future<void> loadMedicationsForDate(DateTime date) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    // If loading today's data, use the normal load method
    if (targetDate == today) {
      await loadMedications();
      return;
    }

    // Load historical data for past/future dates
    await _loadMedicationsForHistoricalDate(targetDate);
  }

  /// Reload medications without heavy operations (for quick UI updates)
  Future<void> _reloadMedicationsOnly() async {
    _isLoading = true;
    _safeNotify();

    try {
      // Load medications based on view mode
      List<Medication> allMedications;

      if (!_showPersonTabs) {
        // Mixed view: load all medications from all persons
        allMedications = await DatabaseHelper.instance.getAllMedications();

        // Build map of medication -> persons
        _medicationPersons.clear();
        for (final medication in allMedications) {
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(medication.id);
          _medicationPersons[medication.id] = persons;
        }
      } else if (_selectedPerson != null) {
        // Tab view: load medications for selected person only
        allMedications = await DatabaseHelper.instance
            .getMedicationsForPerson(_selectedPerson!.id);
      } else {
        // Fallback: load all medications
        allMedications = await DatabaseHelper.instance.getAllMedications();
      }

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

      // Sort medications by next dose proximity
      MedicationSorter.sortByNextDose(medications);

      // Update state
      _medications.clear();
      _medications.addAll(medications);
      _isLoading = false;
      _safeNotify();

      // Update fasting notification in background (non-blocking)
      _fastingManager.updateNotification().catchError((e) => LoggerService.error('Error updating fasting notification: $e', e));
    } catch (e) {
      _isLoading = false;
      _safeNotify();
      rethrow;
    }
  }

  /// Load medications for the selected person
  Future<void> loadMedications() async {
    _isLoading = true;
    _safeNotify();

    try{
      // Load medications based on view mode
      List<Medication> allMedications;

      if (!_showPersonTabs) {
        // Mixed view: load all medications from all persons
        allMedications = await DatabaseHelper.instance.getAllMedications();

        // Build map of medication -> persons
        _medicationPersons.clear();
        for (final medication in allMedications) {
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(medication.id);
          _medicationPersons[medication.id] = persons;
        }
      } else if (_selectedPerson != null) {
        // Tab view: load medications for selected person only
        allMedications = await DatabaseHelper.instance
            .getMedicationsForPerson(_selectedPerson!.id);
      } else {
        // Fallback: load all medications
        allMedications = await DatabaseHelper.instance.getAllMedications();
      }

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

      // Update fasting notification in background (non-blocking)
      _fastingManager.updateNotification().catchError((e) => LoggerService.error('Error updating fasting notification: $e', e));
    } catch (e) {
      _isLoading = false;
      _safeNotify();
      rethrow;
    }
  }

  /// Load medications for a historical date (not today)
  Future<void> _loadMedicationsForHistoricalDate(DateTime targetDate) async {
    _isLoading = true;
    _safeNotify();

    try {
      // Load all medications for selected person
      List<Medication> allMedications;
      if (_selectedPerson != null) {
        allMedications = await DatabaseHelper.instance
            .getMedicationsForPerson(_selectedPerson!.id);
      } else {
        allMedications = await DatabaseHelper.instance.getAllMedications();
      }

      // Load dose history for the target date
      final nextDay = targetDate.add(const Duration(days: 1));
      final historyEntries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: targetDate,
        endDate: nextDay,
      );

      // Filter by selected person if applicable
      final personFilteredEntries = _selectedPerson != null
          ? historyEntries.where((e) => e.personId == _selectedPerson!.id).toList()
          : historyEntries;

      // Group entries by medication ID
      final entriesByMedication = <String, List<DoseHistoryEntry>>{};
      for (final entry in personFilteredEntries) {
        entriesByMedication.putIfAbsent(entry.medicationId, () => []).add(entry);
      }

      // Build medications list with historical data
      final medications = <Medication>[];
      final dateString = targetDate.toDateString();

      for (final medication in allMedications) {
        // Skip suspended medications
        if (medication.isSuspended) continue;

        final entries = entriesByMedication[medication.id] ?? [];

        // For scheduled medications, show if they had any activity or were scheduled for that day
        if (medication.durationType != TreatmentDurationType.asNeeded) {
          // Build taken and skipped dose lists
          final takenDoses = entries
              .where((e) => e.status == DoseStatus.taken)
              .map((e) => e.scheduledTimeFormatted)
              .toList();
          final skippedDoses = entries
              .where((e) => e.status == DoseStatus.skipped)
              .map((e) => e.scheduledTimeFormatted)
              .toList();

          // Create a copy with the historical dose data
          final historicalMed = medication.copyWith(
            takenDosesToday: takenDoses,
            skippedDosesToday: skippedDoses,
            takenDosesDate: dateString,
          );

          medications.add(historicalMed);
        } else {
          // For as-needed medications, only show if they were taken that day
          if (entries.isNotEmpty) {
            medications.add(medication.copyWith(
              takenDosesDate: dateString,
            ));
          }
        }
      }

      // Load cache data for historical date
      await _loadCacheDataForHistoricalDate(medications, targetDate, entriesByMedication);

      // Sort medications by next dose proximity
      MedicationSorter.sortByNextDose(medications);

      // Update state
      _medications.clear();
      _medications.addAll(medications);
      _isLoading = false;
      _safeNotify();
    } catch (e) {
      _isLoading = false;
      _safeNotify();
      rethrow;
    }
  }

  /// Load cache data for medications on a historical date
  Future<void> _loadCacheDataForHistoricalDate(
    List<Medication> medications,
    DateTime targetDate,
    Map<String, List<DoseHistoryEntry>> entriesByMedication,
  ) async {
    _cacheManager.clearAll();

    // Load "as needed" doses information for historical date
    for (final med in medications) {
      if (med.durationType == TreatmentDurationType.asNeeded) {
        final entries = entriesByMedication[med.id] ?? [];
        if (entries.isNotEmpty) {
          final totalTaken = entries.length;
          final totalQuantity = entries.fold<double>(
            0.0,
            (sum, entry) => sum + entry.quantity,
          );
          _cacheManager.setAsNeededDosesInfo(med.id, {
            'count': totalTaken,
            'totalQuantity': totalQuantity,
          });
        }
      }
    }

    // Load actual dose times if preference is enabled
    if (_showActualTime) {
      for (final med in medications) {
        final entries = entriesByMedication[med.id] ?? [];
        if (entries.isNotEmpty) {
          final actualTimes = <String, DateTime>{};
          for (final entry in entries) {
            if (entry.status == DoseStatus.taken) {
              actualTimes[entry.scheduledTimeFormatted] = entry.registeredDateTime;
            }
          }
          if (actualTimes.isNotEmpty) {
            _cacheManager.setActualDoseTimes(med.id, actualTimes);
          }
        }
      }
    }
  }

  /// Load cache data for medications
  Future<void> _loadCacheData(List<Medication> medications) async {
    _cacheManager.clearAll();

    // Skip cache loading in test mode to prevent database lock issues
    // Tests don't need cached data and this significantly reduces DB queries
    if (_isTestMode) {
      return;
    }

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
  // ignore: unused_element
  void _scheduleNotificationsInBackground(List<Medication> medications) {
    // Skip background scheduling in test mode to prevent pumpAndSettle timeouts
    if (_isTestMode) return;

    Future.microtask(() async {
      for (final medication in medications) {
        try {
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(medication.id);

          // Cancel all existing notifications for this medication once before rescheduling
          await NotificationService.instance.cancelMedicationNotifications(
            medication.id,
            medication: medication,
          );

          // Then schedule for all persons with skipCancellation=true
          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              medication,
              personId: person.id,
              skipCancellation: true, // Already cancelled everything above
            );
          }
        } catch (e) {
          // Log error but don't block (silently ignore)
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
    final freshMedication = await getFreshMedication(medication.id);
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

    final updatedTakenDoses = freshMedication.takenDosesDate == todayString
        ? (List<String>.from(freshMedication.takenDosesToday)..add(doseTime))
        : [doseTime];

    final updatedSkippedDoses = freshMedication.takenDosesDate == todayString
        ? List<String>.from(freshMedication.skippedDosesToday)
        : <String>[];

    // Update medication
    final updatedMedication = freshMedication.copyWith(
      stockQuantity: freshMedication.stockQuantity - doseQuantity,
      takenDosesToday: updatedTakenDoses,
      skippedDosesToday: updatedSkippedDoses,
      takenDosesDate: todayString,
    );

    // Get person for updates
    final personId = await getPersonId();

    // Update in database
    final defaultPerson = _selectedPerson ??
                          await DatabaseHelper.instance.getDefaultPerson();
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    } else {
      await DatabaseHelper.instance.updateMedication(updatedMedication);
    }

    // Create and insert history entry
    final historyEntry = createDoseHistoryEntry(
      medication: freshMedication,
      doseTime: doseTime,
      personId: personId,
      status: DoseStatus.taken,
      quantity: doseQuantity,
    );
    await DatabaseHelper.instance.insertDoseHistory(historyEntry);

    // Reload medications FIRST (fast, UI-only)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();

    // Handle ALL notification operations in background (non-blocking)
    Future.microtask(() async {
      try {
        // Cancel today's notification
        await NotificationService.instance.cancelTodaysDoseNotification(
          medication: updatedMedication,
          doseTime: doseTime,
          personId: personId,
        );

        // Cancel fasting notification if needed
        await NotificationService.instance.cancelTodaysFastingNotification(
          medication: updatedMedication,
          doseTime: doseTime,
          personId: personId,
        );

        // Reschedule notifications
        await NotificationService.instance.scheduleMedicationNotifications(
          updatedMedication,
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
      } catch (e) {
        LoggerService.error('Error handling notifications in background: $e', e);
      }
    });

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
    final freshMedication = await getFreshMedication(medication.id);
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
    // Use selected person if available, otherwise default person
    final person = _selectedPerson ?? await DatabaseHelper.instance.getDefaultPerson();
    final personId = person?.id ?? '';

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

    // Reload medications FIRST (fast, UI-only)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();

    // Handle ALL notification operations in background (non-blocking)
    Future.microtask(() async {
      try {
        // Cancel next pending notification if applicable
        await _cancelNextPendingNotification(updatedMedication, personId);

        // Reschedule notifications
        await NotificationService.instance.scheduleMedicationNotifications(
          updatedMedication,
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
      } catch (e) {
        LoggerService.error('Error handling notifications in background: $e', e);
      }
    });

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

      // Cancel all existing notifications once before rescheduling
      await NotificationService.instance.cancelMedicationNotifications(
        updatedMedication.id,
        medication: updatedMedication,
      );

      // Then schedule for all persons with skipCancellation=true
      for (final person in persons) {
        await NotificationService.instance.scheduleMedicationNotifications(
          updatedMedication,
          personId: person.id,
          skipCancellation: true, // Already cancelled everything above
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

    // Use optimized reload (fast, no notification sync)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();

    return 'refill|$amount|${medication.type.stockUnit}|${updatedMedication.stockDisplayText}';
  }

  /// Delete a medication
  Future<void> deleteMedication(Medication medication) async {
    // 1. Delete from database
    await DatabaseHelper.instance.deleteMedication(medication.id);

    // 2. Update UI IMMEDIATELY (fast, non-blocking)
    _medications.remove(medication);
    _safeNotify();

    // 3. Cancel notifications in background (non-blocking)
    Future.microtask(() async {
      try {
        await NotificationService.instance
            .cancelMedicationNotifications(medication.id, medication: medication);
      } catch (e) {
        LoggerService.error('Error cancelling notifications after medication deletion: $e', e);
      }
    });
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

    // Get person for updates (use selected person or default)
    final defaultPerson =
        _selectedPerson ?? await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (use person-specific update method)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    } else {
      await DatabaseHelper.instance.updateMedication(updatedMedication);
    }

    // Delete from history (filter by personId to ensure we delete the correct entry)
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
          entry.scheduledDateTime.minute == scheduledDateTime.minute &&
          entry.personId == personId) {  // Filter by personId
        await DatabaseHelper.instance.deleteDoseHistory(entry.id);
        break;
      }
    }

    // Reload UI FIRST (fast, UI-only)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();

    // Handle notification operations in background (non-blocking)
    Future.microtask(() async {
      try {
        // Get fresh medication data
        final freshMedication = _selectedPerson != null
            ? await DatabaseHelper.instance
                .getMedicationForPerson(medication.id, _selectedPerson!.id)
            : await DatabaseHelper.instance.getMedication(medication.id);

        if (freshMedication != null) {
          // Reschedule notifications for all persons
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(freshMedication.id);

          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              freshMedication,
              personId: person.id,
            );
          }
        }
      } catch (e) {
        LoggerService.error('Error handling notifications after dose deletion: $e', e);
      }
    });
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

    // Get person for updates (use selected person or default)
    final defaultPerson =
        _selectedPerson ?? await DatabaseHelper.instance.getDefaultPerson();
    final personId = defaultPerson?.id ?? '';

    // Update in database (use person-specific update method)
    if (defaultPerson != null) {
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMedication,
        personId: defaultPerson.id,
      );
    } else {
      await DatabaseHelper.instance.updateMedication(updatedMedication);
    }

    // Update history entry (filter by personId to ensure we update the correct entry)
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
          entry.scheduledDateTime.minute == scheduledDateTime.minute &&
          entry.personId == personId) {  // Filter by personId
        final updatedEntry = entry.copyWith(
          status: wasTaken ? DoseStatus.skipped : DoseStatus.taken,
          registeredDateTime: DateTime.now(),
        );
        await DatabaseHelper.instance.insertDoseHistory(updatedEntry);
        break;
      }
    }

    // Reload UI FIRST (fast, UI-only)
    await _fastingManager.loadFastingPeriods();
    await _reloadMedicationsOnly();

    // Handle notification operations in background (non-blocking)
    Future.microtask(() async {
      try {
        // Get fresh medication data
        final freshMedication = _selectedPerson != null
            ? await DatabaseHelper.instance
                .getMedicationForPerson(medication.id, _selectedPerson!.id)
            : await DatabaseHelper.instance.getMedication(medication.id);

        if (freshMedication != null) {
          // Reschedule notifications for all persons
          final persons = await DatabaseHelper.instance
              .getPersonsForMedication(freshMedication.id);

          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              freshMedication,
              personId: person.id,
            );
          }
        }
      } catch (e) {
        LoggerService.error('Error handling notifications after toggle: $e', e);
      }
    });
  }

  /// Create a new medication for the current person
  Future<void> createMedication(Medication medication, {String? personId}) async {
    Person? targetPerson;

    // Use provided personId, or selected person, or default person
    if (personId != null) {
      targetPerson = await DatabaseHelper.instance.getPerson(personId);
    } else if (_selectedPerson != null) {
      targetPerson = _selectedPerson;
    } else {
      targetPerson = await DatabaseHelper.instance.getDefaultPerson();
    }

    if (targetPerson != null) {
      final personIdForNotifications = targetPerson.id;
      await DatabaseHelper.instance.createMedicationForPerson(
        medication: medication,
        personId: personIdForNotifications,
      );

      // Update UI IMMEDIATELY (fast, UI-only)
      await _fastingManager.loadFastingPeriods();
      await _reloadMedicationsOnly();

      // Schedule notifications in background (non-blocking)
      // This ensures notifications are created when medication is assigned to new person
      Future.microtask(() async {
        try {
          await NotificationService.instance.rescheduleAllMedicationNotifications();
        } catch (e) {
          LoggerService.error('Error rescheduling notifications after create: $e', e);
        }
      });
    }
  }

  /// Update an existing medication
  Future<void> updateMedication(Medication medication) async {
    Person? targetPerson = _selectedPerson;
    targetPerson ??= await DatabaseHelper.instance.getDefaultPerson();

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

          // STEP 1: Cancel all existing notifications for this medication once
          // This prevents the issue where cancellation happens per-person, leaving only the last person's notifications
          await NotificationService.instance.cancelMedicationNotifications(
            medication.id,
            medication: medication,
          );

          // STEP 2: Reschedule notifications for each person assigned to this medication
          // Use skipCancellation=true since we already cancelled everything above
          for (final person in persons) {
            await NotificationService.instance.scheduleMedicationNotifications(
              medication,
              personId: person.id,
              skipCancellation: true, // Already cancelled everything above
            );
          }
        } catch (e) {
          // Silently ignore errors
        }
      });
    }
  }

  /// Reschedule all notifications (debug function)
  /// Reprograms notifications for ALL users, not just the selected one
  Future<int> rescheduleAllNotifications() async {
    // Get all medications (not filtered by selected person)
    final allMedications = await DatabaseHelper.instance.getAllMedications();

    // STEP 1: Cancel all existing notifications once
    // This prevents the issue where cancellation happens per-person, leaving only the last person's notifications
    LoggerService.info('Cancelling all existing notifications before rescheduling...');
    await NotificationService.instance.cancelAllNotifications();

    // STEP 2: Reschedule notifications for each medication and each person assigned to it
    // Use skipCancellation=true since we already cancelled everything above
    for (final medication in allMedications) {
      if (medication.doseTimes.isNotEmpty && !medication.isSuspended) {
        final persons = await DatabaseHelper.instance
            .getPersonsForMedication(medication.id);
        for (final person in persons) {
          await NotificationService.instance.scheduleMedicationNotifications(
            medication,
            personId: person.id,
            skipCancellation: true, // Already cancelled everything above
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
