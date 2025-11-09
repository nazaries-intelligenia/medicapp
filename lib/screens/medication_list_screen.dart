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
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // ViewModel
  late final MedicationListViewModel _viewModel;

  // UI-specific state only
  bool _debugMenuVisible = false;
  int _titleTapCount = 0;
  DateTime? _lastTapTime;
  bool _batteryBannerDismissed = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationListViewModel();
    WidgetsBinding.instance.addObserver(this);
    _loadBatteryBannerPreference();

    // Initialize ViewModel and UI after first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });

    _checkNotificationPermissions();
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initialize(
      isTestMode: NotificationService.instance.isTestMode,
    );

    // Initialize tab controller after persons are loaded
    if (mounted && _viewModel.persons.isNotEmpty) {
      setState(() {
        _tabController = TabController(
          length: _viewModel.persons.length,
          vsync: this,
        );
        _tabController?.addListener(_onTabChanged);
      });
    }

    // Listen to ViewModel changes
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _viewModel.loadMedications();
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
      await _viewModel.createMedication(newMedication);
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
          ...List.generate(_viewModel.activeFastingPeriods.length, (index) {
            final fasting = _viewModel.activeFastingPeriods[index];
            return _buildFastingCountdownRow(
              personName: fasting['personName'] as String,
              personIsDefault: fasting['personIsDefault'] as bool,
              medicationName: fasting['medicationName'] as String,
              fastingEndTime: fasting['fastingEndTime'] as DateTime,
              isLast: index == _viewModel.activeFastingPeriods.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFastingCountdownRow({
    required String personName,
    required bool personIsDefault,
    required String medicationName,
    required DateTime fastingEndTime,
    required bool isLast,
  }) {
    final now = DateTime.now();
    final remaining = fastingEndTime.difference(now);
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, isLast ? 12 : 8),
      decoration: BoxDecoration(
        border: isLast
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
              color: personIsDefault
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                personName[0].toUpperCase(),
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
                  personName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  medicationName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${hours}h ${minutes}m',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

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
      await _viewModel.deleteTodayDose(
        medication: medication,
        doseTime: doseTime,
        wasTaken: wasTaken,
      );

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

  Future<void> _toggleTodayDoseStatus(
      Medication medication, String doseTime, bool wasTaken) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _viewModel.toggleTodayDoseStatus(
        medication: medication,
        doseTime: doseTime,
        wasTaken: wasTaken,
      );

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

  Future<void> _changeRegisteredTime(Medication medication, String doseTime) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Find the history entry for this dose
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final entries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: today,
        endDate: tomorrow,
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

      // Show time picker with current registered time
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(entry.registeredDateTime),
        helpText: l10n.selectRegisteredTime,
      );

      if (picked == null) return;

      // Create new DateTime with picked time but keeping the same date
      final newRegisteredTime = DateTime(
        entry.registeredDateTime.year,
        entry.registeredDateTime.month,
        entry.registeredDateTime.day,
        picked.hour,
        picked.minute,
      );

      // Validate: registered time cannot be in the future
      if (newRegisteredTime.isAfter(now)) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.registeredTimeCannotBeFuture),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Update the entry
      await DoseHistoryService.changeRegisteredTime(entry, newRegisteredTime);

      // Reload data
      await _viewModel.loadMedications();

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        bottom: _tabController != null && _viewModel.persons.length > 1
            ? TabBar(
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
              )
            : null,
      ),
      body: _viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _viewModel.medications.isEmpty
              ? EmptyMedicationsView(onRefresh: _viewModel.loadMedications)
              : Column(
                  children: [
                    if (PlatformHelper.isAndroid && !_batteryBannerDismissed)
                      BatteryOptimizationBanner(onDismiss: _dismissBatteryBanner),
                    if (_viewModel.activeFastingPeriods.isNotEmpty)
                      _buildAllFastingCountdowns(),
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

                            return MedicationCard(
                              medication: medication,
                              nextDoseInfo: nextDoseInfo,
                              nextDoseText: nextDoseText,
                              asNeededDoseInfo: asNeededDoseInfo,
                              fastingPeriod: null,
                              todayDosesWidget: todayDosesWidget,
                              onTap: () => _showDeleteModal(medication),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMedication,
        child: const Icon(Icons.add),
      ),
    );
  }
}
