import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../models/medication.dart';
import '../models/dose_history_entry.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';
import '../services/dose_history_service.dart';
import '../utils/platform_helper.dart';
import 'medication_info_screen.dart';
import 'edit_medication_menu_screen.dart';
import 'medication_list/widgets/medication_card.dart';
import 'medication_list/widgets/battery_optimization_banner.dart';
import 'medication_list/widgets/empty_medications_view.dart';
import 'medication_list/widgets/today_doses_section.dart';
import 'medication_list/widgets/debug_menu.dart';
import 'medication_list/dialogs/medication_options_sheet.dart';
import 'medication_list/dialogs/dose_selection_dialog.dart';
import 'medication_list/dialogs/extra_dose_confirmation_dialog.dart';
import 'medication_list/dialogs/manual_dose_input_dialog.dart';
import 'medication_list/dialogs/refill_input_dialog.dart';
import 'medication_list/dialogs/edit_today_dose_dialog.dart';
import 'medication_list/dialogs/notification_permission_dialog.dart';
import 'debug_notifications_screen.dart';
import 'medication_list/services/dose_calculation_service.dart';
import 'medication_list/medication_list_viewmodel.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => MedicationListScreenState();
}

class MedicationListScreenState extends State<MedicationListScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ViewModel
  late final MedicationListViewModel _viewModel;

  // UI-specific state only
  bool _debugMenuVisible = false;
  int _titleTapCount = 0;
  DateTime? _lastTapTime;
  bool _batteryBannerDismissed = false;
  TabController? _tabController;

  // Fasting countdown state (persists across tab changes)
  final Set<String> _dismissedFastingPeriods = {};
  final Set<String> _soundPlayedFastingPeriods = {};

  // Day navigation
  static const int _centerPageIndex = 10000; // Centro para navegación "ilimitada"
  late final PageController _pageController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationListViewModel();
    _pageController = PageController(initialPage: _centerPageIndex);
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addObserver(this);
    _loadBatteryBannerPreference();

    // Initialize ViewModel and UI after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });

    _checkNotificationPermissions();
  }

  Future<void> _initializeViewModel() async {
    // Listen to ViewModel changes FIRST, before initialization
    _viewModel.addListener(_onViewModelChanged);

    // NOW initialize (this will trigger notifications that will be received)
    await _viewModel.initialize(
      isTestMode: NotificationService.instance.isTestMode,
    );

    // Initialize tab controller after persons are loaded (only if tabs are enabled)
    if (mounted && _viewModel.persons.isNotEmpty && _viewModel.showPersonTabs) {
      setState(() {
        _tabController = TabController(
          length: _viewModel.persons.length,
          vsync: this,
        );
        _tabController?.addListener(_onTabChanged);
      });
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      // Check if number of persons changed and update TabController if needed
      final shouldHaveTabs = _viewModel.showPersonTabs && _viewModel.persons.length > 1;
      final currentTabCount = _tabController?.length ?? 0;
      final newTabCount = _viewModel.persons.length;

      if (shouldHaveTabs && currentTabCount != newTabCount) {
        // Rebuild TabController with new length
        _tabController?.dispose();
        _tabController = TabController(
          length: newTabCount,
          vsync: this,
        );
        _tabController?.addListener(_onTabChanged);
      } else if (!shouldHaveTabs && _tabController != null) {
        // Remove TabController if tabs should not be shown
        _tabController?.dispose();
        _tabController = null;
      }

      setState(() {});
    }
  }

  void _onTabChanged() {
    if (_tabController == null || _tabController!.indexIsChanging) {
      return;
    }
    final selectedPerson = _viewModel.persons[_tabController!.index];
    _viewModel.selectPerson(selectedPerson);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _tabController?.dispose();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reschedule notifications when app returns from background
      // This ensures notifications for today + tomorrow are always up to date
      NotificationService.instance.rescheduleAllMedicationNotifications();

      // Reload data after settings change
      reloadAfterSettingsChange();
    }
  }

  Future<void> reloadAfterSettingsChange() async {
    // Check if showPersonTabs preference or person count changed
    final oldShowPersonTabs = _viewModel.showPersonTabs;
    final oldPersonsCount = _viewModel.persons.length;
    await _viewModel.reloadPreferences();
    final newShowPersonTabs = _viewModel.showPersonTabs;
    final newPersonsCount = _viewModel.persons.length;

    // If preference changed OR person count changed, rebuild tab controller
    if (oldShowPersonTabs != newShowPersonTabs || oldPersonsCount != newPersonsCount) {
      _tabController?.dispose();
      _tabController = null;

      if (newShowPersonTabs && _viewModel.persons.isNotEmpty) {
        setState(() {
          _tabController = TabController(
            length: _viewModel.persons.length,
            vsync: this,
          );
          _tabController?.addListener(_onTabChanged);
        });
      } else {
        setState(() {});
      }
    } else {
      // Just reload medications if nothing changed
      await _viewModel.loadMedications();
    }
  }

  Future<void> _loadBatteryBannerPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _batteryBannerDismissed =
              prefs.getBool('battery_banner_dismissed') ?? false;
        });
      }
    } catch (e) {
      print('Could not load battery banner preference: $e');
    }
  }

  Future<void> _dismissBatteryBanner() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('battery_banner_dismissed', true);
      if (mounted) {
        setState(() {
          _batteryBannerDismissed = true;
        });
      }
    } catch (e) {
      print('Could not save battery banner preference: $e');
      if (mounted) {
        setState(() {
          _batteryBannerDismissed = true;
        });
      }
    }
  }

  Future<void> _checkNotificationPermissions() async {
    await NotificationPermissionDialog.checkAndShowIfNeeded(
      context: context,
      hasMedications: _viewModel.medications.isNotEmpty,
    );
  }

  void _onTitleTap() {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    if (_lastTapTime == null ||
        now.difference(_lastTapTime!).inSeconds > 2) {
      _titleTapCount = 1;
    } else {
      _titleTapCount++;
    }

    _lastTapTime = now;

    if (_titleTapCount >= 5) {
      setState(() {
        _debugMenuVisible = !_debugMenuVisible;
        _titleTapCount = 0;
        _lastTapTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_debugMenuVisible
              ? l10n.debugMenuActivated
              : l10n.debugMenuDeactivated),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _navigateToAddMedication() async {
    String? selectedPersonId;

    // If person tabs are disabled, ask which person first
    if (!_viewModel.showPersonTabs && _viewModel.persons.length > 1) {
      final l10n = AppLocalizations.of(context)!;
      selectedPersonId = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.selectPerson),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: _viewModel.persons.map((person) {
                return ListTile(
                  leading: Icon(
                    person.isDefault ? Icons.person : Icons.person_outline,
                  ),
                  title: Text(person.name),
                  onTap: () => Navigator.pop(context, person.id),
                );
              }).toList(),
            ),
          );
        },
      );

      // User cancelled
      if (selectedPersonId == null) return;
    } else if (!_viewModel.showPersonTabs && _viewModel.persons.length == 1) {
      // Only one person, use it
      selectedPersonId = _viewModel.persons.first.id;
    }

    final allMedications = await DatabaseHelper.instance.getAllMedications();

    final newMedication = await Navigator.push<Medication>(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationInfoScreen(
          existingMedications: allMedications,
        ),
      ),
    );

    if (newMedication != null) {
      await _viewModel.createMedication(newMedication, personId: selectedPersonId);
    }
  }

  void _navigateToEditMedication(Medication medication) async {
    Navigator.pop(context);

    final updatedMedication = await Navigator.push<Medication>(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationMenuScreen(
          medication: medication,
          existingMedications: _viewModel.medications,
        ),
      ),
    );

    if (updatedMedication != null) {
      await _viewModel.updateMedication(updatedMedication);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.medicationUpdatedShort(updatedMedication.name)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _registerDose(Medication medication) async {
    final l10n = AppLocalizations.of(context)!;

    // Validate before closing modal
    if (medication.doseTimes.isEmpty) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.noScheduledTimes),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (medication.stockQuantity <= 0) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.medicineCabinetNoStockAvailable),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.pop(context);

    // Get fresh medication from database
    final freshMedication = _viewModel.selectedPerson != null
        ? await DatabaseHelper.instance.getMedicationForPerson(
            medication.id, _viewModel.selectedPerson!.id)
        : await DatabaseHelper.instance.getMedication(medication.id);

    if (freshMedication == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseActionMedicationNotFound),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final availableDoses = freshMedication.getAvailableDosesToday();

    String? selectedDoseTime;
    bool isExtraDose = false;

    if (availableDoses.isEmpty) {
      final confirmExtra = await ExtraDoseConfirmationDialog.show(
        context,
        medicationName: freshMedication.name,
      );

      if (confirmExtra == true) {
        isExtraDose = true;
      } else {
        return;
      }
    } else {
      selectedDoseTime = await DoseSelectionDialog.show(
        context,
        medicationName: freshMedication.name,
        availableDoses: availableDoses,
        showExtraOption: true,
      );

      if (selectedDoseTime == DoseSelectionDialog.extraDoseOption) {
        isExtraDose = true;
        selectedDoseTime = null;
      } else if (selectedDoseTime == null) {
        return;
      }
    }

    // Handle dose registration
    try {
      if (isExtraDose) {
        final result = await _viewModel.registerExtraDose(
          medication: freshMedication,
        );
        final parts = result.split('|');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.extraDoseRegistered(
                freshMedication.name,
                parts[1],
                parts[2],
              ),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (selectedDoseTime != null) {
        final result = await _viewModel.registerDose(
          medication: freshMedication,
          doseTime: selectedDoseTime,
        );
        final parts = result.split('|');
        final confirmationMessage = parts[0] == 'allComplete'
            ? '${l10n.doseRegisteredAtTime(freshMedication.name, selectedDoseTime, parts[1])}\n${l10n.allDosesCompletedToday}'
            : '${l10n.doseRegisteredAtTime(freshMedication.name, selectedDoseTime, parts[2])}\n${l10n.remainingDosesToday(int.parse(parts[1]))}';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(confirmationMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on InsufficientStockException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.insufficientStockForThisDose(
              e.doseQuantity.toString(),
              e.unit,
              freshMedication.stockDisplayText,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _registerManualDose(Medication medication) async {
    final l10n = AppLocalizations.of(context)!;
    Navigator.pop(context);

    if (medication.stockQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.medicineCabinetNoStockAvailable),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final doseQuantity = await ManualDoseInputDialog.show(
      context,
      medication: medication,
    );

    if (doseQuantity != null && doseQuantity > 0) {
      try {
        final result = await _viewModel.registerManualDose(
          medication: medication,
          quantity: doseQuantity,
        );
        final parts = result.split('|');
        final confirmationMessage = l10n.manualDoseRegistered(
          medication.name,
          parts[1],
          parts[2],
          parts[3],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(confirmationMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      } on InsufficientStockException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.insufficientStockForThisDose(
                e.doseQuantity.toString(),
                e.unit,
                medication.stockDisplayText,
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _toggleSuspendMedication(Medication medication) async {
    Navigator.pop(context);

    try {
      final result = await _viewModel.toggleSuspendMedication(medication);
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == 'suspended'
                ? l10n.medicationSuspended(medication.name)
                : l10n.medicationReactivated(medication.name),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _refillMedication(Medication medication) async {
    final l10n = AppLocalizations.of(context)!;
    Navigator.pop(context);

    final refillAmount = await RefillInputDialog.show(
      context,
      medication: medication,
    );

    if (refillAmount != null && refillAmount > 0) {
      final result = await _viewModel.refillMedication(
        medication: medication,
        amount: refillAmount,
      );
      final parts = result.split('|');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.stockRefilled(
              medication.name,
              parts[1],
              parts[2],
              parts[3],
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showDeleteModal(Medication medication) {
    MedicationOptionsSheet.show(
      context,
      medication: medication,
      onRegisterDose: () => _registerDose(medication),
      onRegisterManualDose: () => _registerManualDose(medication),
      onRefill: () => _refillMedication(medication),
      onToggleSuspend: () => _toggleSuspendMedication(medication),
      onEdit: () => _navigateToEditMedication(medication),
      onDelete: () async {
        final l10n = AppLocalizations.of(context)!;
        await _viewModel.deleteMedication(medication);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.medicationDeletedShort(medication.name)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  Widget _buildAllFastingCountdowns() {
    return _FastingCountdownPanel(
      activeFastingPeriods: _viewModel.activeFastingPeriods,
      dismissedPeriods: _dismissedFastingPeriods,
      soundPlayedPeriods: _soundPlayedFastingPeriods,
      onDismissPeriod: (key) {
        setState(() {
          _dismissedFastingPeriods.add(key);
        });
      },
      onSoundPlayed: (key) {
        setState(() {
          _soundPlayedFastingPeriods.add(key);
        });
      },
    );
  }

  // Method removed - now using _FastingCountdownPanel widget

  void _showDebugInfo() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugNotificationsScreen(
          medications: _viewModel.medications,
          persons: _viewModel.persons,
        ),
      ),
    );
  }

  void _testNotification() async {
    await NotificationService.instance.showTestNotification();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.testNotificationSent),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testScheduledNotification() async {
    await NotificationService.instance.scheduleTestNotification();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.scheduledNotificationInOneMin),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _rescheduleAllNotifications() async {
    final pendingCount = await _viewModel.rescheduleAllNotifications();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.notificationsRescheduled(pendingCount)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildTodayDosesSection(Medication medication) {
    return TodayDosesSection(
      medication: medication,
      onDoseTap: (doseTime, isTaken) =>
          _showEditTodayDoseDialog(medication, doseTime, isTaken),
      actualDoseTimes: _viewModel.getActualDoseTimes(medication.id),
      showActualTime: _viewModel.showActualTime,
    );
  }

  Future<void> _showEditTodayDoseDialog(
      Medication medication, String doseTime, bool isTaken) async {
    final result = await EditTodayDoseDialog.show(
      context,
      medicationName: medication.name,
      doseTime: doseTime,
      isTaken: isTaken,
      showChangeTimeOption: _viewModel.showActualTime,
    );

    if (result == 'delete') {
      await _deleteTodayDose(medication, doseTime, isTaken);
    } else if (result == 'toggle') {
      await _toggleTodayDoseStatus(medication, doseTime, isTaken);
    } else if (result == 'changeTime') {
      await _changeRegisteredTime(medication, doseTime);
    }
  }

  Future<void> _deleteTodayDose(
      Medication medication, String doseTime, bool wasTaken) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

      if (selectedDay == today) {
        // For today, use the ViewModel method which updates medication state
        await _viewModel.deleteTodayDose(
          medication: medication,
          doseTime: doseTime,
          wasTaken: wasTaken,
        );
      } else {
        // For historical dates, only delete from history
        await _deleteHistoricalDose(medication, doseTime);
        await _viewModel.loadMedicationsForDate(_selectedDate);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseDeletedAt(doseTime)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorDeleting(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _deleteHistoricalDose(Medication medication, String doseTime) async {
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final nextDay = selectedDay.add(const Duration(days: 1));

    final entries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
      startDate: selectedDay,
      endDate: nextDay,
      medicationId: medication.id,
    );

    final selectedPerson = _viewModel.selectedPerson;
    final entry = entries.where((e) {
      return e.scheduledTimeFormatted == doseTime &&
             (selectedPerson == null || e.personId == selectedPerson.id);
    }).firstOrNull;

    if (entry != null) {
      await DatabaseHelper.instance.deleteDoseHistory(entry.id);
    }
  }

  Future<void> _toggleTodayDoseStatus(
      Medication medication, String doseTime, bool wasTaken) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

      if (selectedDay == today) {
        // For today, use the ViewModel method which updates medication state
        await _viewModel.toggleTodayDoseStatus(
          medication: medication,
          doseTime: doseTime,
          wasTaken: wasTaken,
        );
      } else {
        // For historical dates, only update history
        await _toggleHistoricalDoseStatus(medication, doseTime, wasTaken);
        await _viewModel.loadMedicationsForDate(_selectedDate);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseMarkedAs(
              doseTime, wasTaken ? l10n.skippedStatus : l10n.takenStatus)),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      if (e is InsufficientStockException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.insufficientStockForDose),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorChangingStatus(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _toggleHistoricalDoseStatus(
      Medication medication, String doseTime, bool wasTaken) async {
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final nextDay = selectedDay.add(const Duration(days: 1));

    final entries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
      startDate: selectedDay,
      endDate: nextDay,
      medicationId: medication.id,
    );

    final selectedPerson = _viewModel.selectedPerson;
    final entry = entries.where((e) {
      return e.scheduledTimeFormatted == doseTime &&
             (selectedPerson == null || e.personId == selectedPerson.id);
    }).firstOrNull;

    if (entry != null) {
      final updatedEntry = entry.copyWith(
        status: wasTaken ? DoseStatus.skipped : DoseStatus.taken,
        registeredDateTime: DateTime.now(),
      );
      await DatabaseHelper.instance.insertDoseHistory(updatedEntry);
    }
  }

  Future<void> _changeRegisteredTime(Medication medication, String doseTime) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Find the history entry for this dose on the selected date
      final now = DateTime.now();
      final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final nextDay = selectedDay.add(const Duration(days: 1));

      final entries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: selectedDay,
        endDate: nextDay,
        medicationId: medication.id,
      );

      // Find entry matching the dose time and person
      final selectedPerson = _viewModel.selectedPerson;
      if (selectedPerson == null) return;

      final entry = entries.where((e) {
        return e.scheduledTimeFormatted == doseTime &&
               e.personId == selectedPerson.id &&
               e.status == DoseStatus.taken;
      }).firstOrNull;

      if (entry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorFindingDoseEntry),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      // Show time picker with validation loop
      late DateTime newRegisteredTime;
      TimeOfDay initialTime = TimeOfDay.fromDateTime(entry.registeredDateTime);

      while (true) {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: initialTime,
          helpText: l10n.selectRegisteredTime,
        );

        if (picked == null) return; // User cancelled

        // Create new DateTime with picked time but keeping the same date
        newRegisteredTime = DateTime(
          entry.registeredDateTime.year,
          entry.registeredDateTime.month,
          entry.registeredDateTime.day,
          picked.hour,
          picked.minute,
        );

        // Validate: registered time cannot be in the future
        if (newRegisteredTime.isAfter(now)) {
          if (!mounted) return;

          // Show error dialog
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.errorLabel),
              content: Text(l10n.registeredTimeCannotBeFuture),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.btnAccept),
                ),
              ],
            ),
          );

          // Keep the selected time for next iteration
          initialTime = picked;
          continue; // Show time picker again
        }

        // Valid time, exit loop
        break;
      }

      // Update the entry
      await DoseHistoryService.changeRegisteredTime(entry, newRegisteredTime);

      // Reload data for the selected date
      await _viewModel.loadMedicationsForDate(_selectedDate);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registeredTimeUpdated),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorUpdatingTime(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _onPageChanged(int page) {
    final dayOffset = page - _centerPageIndex;
    final newDate = DateTime.now().add(Duration(days: dayOffset));
    final normalizedDate = DateTime(newDate.year, newDate.month, newDate.day);

    setState(() {
      _selectedDate = normalizedDate;
    });

    // Reload data for the new date
    _viewModel.loadMedicationsForDate(_selectedDate);
  }

  String _getTodayDate() {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    // Si es hoy, mostrar "Hoy, día/mes/año"
    if (selectedDay == today) {
      return l10n.today(_selectedDate.day, _selectedDate.month, _selectedDate.year);
    }

    // Para otros días, mostrar solo la fecha
    return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  Future<void> _showDatePickerDialog() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final pickedNormalized = DateTime(picked.year, picked.month, picked.day);

      // Calcular offset desde hoy
      final dayOffset = pickedNormalized.difference(today).inDays;
      final targetPage = _centerPageIndex + dayOffset;

      // Navegar a la página
      await _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Actualizar estado (onPageChanged se llamará automáticamente)
    }
  }

  Future<void> _returnToToday() async {
    // Navegar de vuelta al centro (hoy)
    await _pageController.animateToPage(
      _centerPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final isToday = selectedDay == today;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Text(l10n.mainScreenTitle),
        ),
        actions: _debugMenuVisible
            ? [
                DebugMenu(
                  onTestNotification: _testNotification,
                  onTestScheduled: _testScheduledNotification,
                  onReschedule: _rescheduleAllNotifications,
                  onShowDebugInfo: _showDebugInfo,
                ),
              ]
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showDatePickerDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getTodayDate(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    if (!isToday)
                      FilledButton.icon(
                        onPressed: _returnToToday,
                        icon: const Icon(Icons.today, size: 20),
                        label: Text(
                          l10n.returnToToday,
                          style: const TextStyle(fontSize: 15),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Contador de ayuno (aparece encima de las pestañas)
          if (_viewModel.activeFastingPeriods.isNotEmpty)
            _buildAllFastingCountdowns(),
          // Pestañas de usuarios
          if (_viewModel.showPersonTabs &&
              _tabController != null &&
              _viewModel.persons.length > 1)
            TabBar(
              controller: _tabController,
              isScrollable: _viewModel.persons.length > 3,
              tabs: _viewModel.persons.map((person) {
                return Tab(
                  text: person.name,
                  icon: person.isDefault
                      ? const Icon(Icons.person)
                      : const Icon(Icons.person_outline),
                );
              }).toList(),
            ),
          // Contenido con navegación por días
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _viewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _viewModel.medications.isEmpty
                        ? EmptyMedicationsView(onRefresh: _viewModel.loadMedications)
                        : Column(
                            children: [
                              if (PlatformHelper.isAndroid && !_batteryBannerDismissed)
                                BatteryOptimizationBanner(onDismiss: _dismissBatteryBanner),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: _viewModel.loadMedications,
                                  child: ListView.builder(
                                    padding:
                                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                    itemCount: _viewModel.medications.length,
                                    itemBuilder: (context, index) {
                                      final medication = _viewModel.medications[index];
                                      final nextDoseInfo =
                                          DoseCalculationService.getNextDoseInfo(medication);
                                      final nextDoseText = nextDoseInfo != null
                                          ? DoseCalculationService.formatNextDose(
                                              nextDoseInfo, context)
                                          : null;
                                      final asNeededDoseInfo =
                                          _viewModel.getAsNeededDosesInfo(medication.id);
                                      final todayDosesWidget = (medication
                                                  .isTakenDosesDateToday &&
                                              (medication.takenDosesToday.isNotEmpty ||
                                                  medication.skippedDosesToday.isNotEmpty))
                                          ? _buildTodayDosesSection(medication)
                                          : null;

                                      // Get person names if in mixed view
                                      final personNames = !_viewModel.showPersonTabs
                                          ? _viewModel
                                              .getPersonsForMedication(medication.id)
                                              .map((p) => p.name)
                                              .toList()
                                          : null;

                                      // Get fasting period for this medication (filtered by selected person)
                                      Map<String, dynamic>? fastingPeriod;
                                      if (_viewModel.showFastingCountdown) {
                                        // Find fasting period that matches this medication and person
                                        for (final fp in _viewModel.activeFastingPeriods) {
                                          if (fp['medicationId'] == medication.id) {
                                            // If person tabs are enabled, filter by selected person
                                            if (_viewModel.showPersonTabs) {
                                              if (_viewModel.selectedPerson != null &&
                                                  fp['personId'] == _viewModel.selectedPerson!.id) {
                                                fastingPeriod = fp;
                                                break;
                                              }
                                            } else {
                                              // In mixed view, show first fasting period for this medication
                                              fastingPeriod = fp;
                                              break;
                                            }
                                          }
                                        }
                                      }

                                      return MedicationCard(
                                        medication: medication,
                                        nextDoseInfo: nextDoseInfo,
                                        nextDoseText: nextDoseText,
                                        asNeededDoseInfo: asNeededDoseInfo,
                                        fastingPeriod: fastingPeriod,
                                        todayDosesWidget: todayDosesWidget,
                                        personNames: personNames,
                                        onTap: () => _showDeleteModal(medication),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'medication_list_fab',
        onPressed: _navigateToAddMedication,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget for displaying active fasting countdowns with dismiss capability
class _FastingCountdownPanel extends StatelessWidget {
  final List<Map<String, dynamic>> activeFastingPeriods;
  final Set<String> dismissedPeriods;
  final Set<String> soundPlayedPeriods;
  final Function(String) onDismissPeriod;
  final Function(String) onSoundPlayed;

  const _FastingCountdownPanel({
    required this.activeFastingPeriods,
    required this.dismissedPeriods,
    required this.soundPlayedPeriods,
    required this.onDismissPeriod,
    required this.onSoundPlayed,
  });

  String _getPeriodKey(Map<String, dynamic> period) {
    // Include end time to make each fasting period unique
    final endTime = period['fastingEndTime'] as DateTime;
    return '${period['personId']}_${period['medicationId']}_${endTime.millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    // Filter out dismissed periods
    final visiblePeriods = activeFastingPeriods
        .where((period) => !dismissedPeriods.contains(_getPeriodKey(period)))
        .toList();

    if (visiblePeriods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.activeFastingPeriodsTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ...List.generate(visiblePeriods.length, (index) {
            final fasting = visiblePeriods[index];
            final periodKey = _getPeriodKey(fasting);
            return _FastingCountdownRow(
              personName: fasting['personName'] as String,
              personIsDefault: fasting['personIsDefault'] as bool,
              medicationName: fasting['medicationName'] as String,
              fastingEndTime: fasting['fastingEndTime'] as DateTime,
              isLast: index == visiblePeriods.length - 1,
              periodKey: periodKey,
              soundAlreadyPlayed: soundPlayedPeriods.contains(periodKey),
              onSoundPlayed: () => onSoundPlayed(periodKey),
              onDismiss: () => onDismissPeriod(periodKey),
            );
          }),
        ],
      ),
    );
  }
}

/// Individual row for fasting countdown with dismiss button
class _FastingCountdownRow extends StatefulWidget {
  final String personName;
  final bool personIsDefault;
  final String medicationName;
  final DateTime fastingEndTime;
  final bool isLast;
  final String periodKey;
  final bool soundAlreadyPlayed;
  final VoidCallback onSoundPlayed;
  final VoidCallback onDismiss;

  const _FastingCountdownRow({
    required this.personName,
    required this.personIsDefault,
    required this.medicationName,
    required this.fastingEndTime,
    required this.isLast,
    required this.periodKey,
    required this.soundAlreadyPlayed,
    required this.onSoundPlayed,
    required this.onDismiss,
  });

  @override
  State<_FastingCountdownRow> createState() => _FastingCountdownRowState();
}

class _FastingCountdownRowState extends State<_FastingCountdownRow> {
  bool _soundTriggered = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final remaining = widget.fastingEndTime.difference(now);
        final isFinished = remaining.inSeconds <= 0;

        // Play sound only once when fasting finishes
        if (isFinished && !widget.soundAlreadyPlayed && !_soundTriggered) {
          _soundTriggered = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Play system notification sound
            NotificationService.instance.playFastingCompletedSound();
            // Mark as played
            widget.onSoundPlayed();
          });
        }

        // Format time remaining
        String timeText;
        if (remaining.inSeconds <= 0) {
          timeText = '00:00';
        } else {
          final hours = remaining.inHours;
          final minutes = remaining.inMinutes % 60;
          final seconds = remaining.inSeconds % 60;

          if (hours > 0) {
            // Format as HH:MM if hours remain
            timeText = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
          } else if (minutes > 0) {
            // Format as MM:SS if only minutes remain
            timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          } else {
            // Format as Ss if only seconds remain (with 's' suffix)
            timeText = '${seconds.toString().padLeft(2, '0')}s';
          }
        }

        return Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, widget.isLast ? 12 : 8),
          decoration: BoxDecoration(
            border: widget.isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.personIsDefault
                      ? (isFinished
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary)
                      : (isFinished
                          ? Colors.green
                          : Theme.of(context).colorScheme.secondary),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isFinished
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          widget.personName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.personName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      widget.medicationName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              if (isFinished)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.fastingCompleted,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
