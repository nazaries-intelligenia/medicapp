import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/dose_history_entry.dart';
import '../models/medication.dart';
import '../models/person.dart';
import '../database/database_helper.dart';
import '../services/dose_history_service.dart';
import 'dose_history/widgets/dose_history_card.dart';
import 'dose_history/widgets/filter_dialog.dart';
import 'dose_history/widgets/statistics_card.dart';
import 'dose_history/widgets/active_filters_chip.dart';
import 'dose_history/widgets/empty_history_view.dart';
import 'dose_history/dialogs/edit_entry_dialog.dart';
import 'dose_history/dialogs/delete_confirmation_dialog.dart';

class DoseHistoryScreen extends StatefulWidget {
  const DoseHistoryScreen({super.key});

  @override
  State<DoseHistoryScreen> createState() => _DoseHistoryScreenState();
}

class _DoseHistoryScreenState extends State<DoseHistoryScreen> with SingleTickerProviderStateMixin {
  List<DoseHistoryEntry> _historyEntries = [];
  List<Medication> _medications = [];
  List<Person> _persons = [];
  bool _isLoading = true;
  bool _hasChanges = false; // Track if any changes were made

  // Tab controller for person tabs
  TabController? _tabController;
  String? _selectedPersonId; // null means "All"

  // Filter state
  String? _selectedMedicationId;
  DateTime? _startDate;
  DateTime? _endDate;

  // Statistics
  Map<String, dynamic> _statistics = {
    'total': 0,
    'taken': 0,
    'skipped': 0,
    'adherence': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load persons for tabs
    var persons = await DatabaseHelper.instance.getAllPersons();

    // Sort persons: default person first, then alphabetically by name
    persons.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });

    // Initialize tab controller if not already done or if person count changed
    if (_tabController == null || _tabController!.length != persons.length + 1) {
      _tabController?.dispose();
      _tabController = TabController(
        length: persons.length + 1, // +1 for "All" tab
        vsync: this,
      );
      _tabController!.addListener(_onTabChanged);
      _selectedPersonId = null; // Start with "All" tab
    }

    // Load medications for filter dropdown
    final medications = await DatabaseHelper.instance.getAllMedications();

    // Load history entries - filter by selected person
    List<DoseHistoryEntry> allEntries;
    if (_startDate != null && _endDate != null) {
      allEntries = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: _startDate!,
        endDate: _endDate!,
        medicationId: _selectedMedicationId,
      );
    } else if (_selectedMedicationId != null) {
      allEntries = await DatabaseHelper.instance.getDoseHistoryForMedication(_selectedMedicationId!);
    } else {
      allEntries = await DatabaseHelper.instance.getAllDoseHistory();
    }

    // Filter entries by selected person (if not "All")
    final entries = _selectedPersonId == null
        ? allEntries
        : allEntries.where((e) => e.personId == _selectedPersonId).toList();

    // Load statistics - filter by selected person
    final stats = await DatabaseHelper.instance.getDoseStatistics(
      medicationId: _selectedMedicationId,
      startDate: _startDate,
      endDate: _endDate,
      personId: _selectedPersonId, // Filter stats by person
    );

    if (mounted) {
      setState(() {
        _persons = persons;
        _medications = medications;
        _historyEntries = entries;
        _statistics = stats;
        _isLoading = false;
      });
    }
  }

  void _onTabChanged() {
    if (!_tabController!.indexIsChanging) {
      // Tab index 0 = "All", Tab index 1+ = specific person
      final newPersonId = _tabController!.index == 0 ? null : _persons[_tabController!.index - 1].id;
      if (newPersonId != _selectedPersonId) {
        setState(() {
          _selectedPersonId = newPersonId;
        });
        _loadData();
      }
    }
  }

  void _showFilterDialog() {
    FilterDialog.show(
      context: context,
      medications: _medications,
      selectedMedicationId: _selectedMedicationId,
      startDate: _startDate,
      endDate: _endDate,
      onApply: (selectedMedId, startDate, endDate) {
        setState(() {
          _selectedMedicationId = selectedMedId;
          _startDate = startDate;
          _endDate = endDate;
        });
        _loadData();
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedMedicationId = null;
      _startDate = null;
      _endDate = null;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasFilters = _selectedMedicationId != null || _startDate != null || _endDate != null;

    return Scaffold(
      appBar: AppBar(
        // Only show back button if there's a previous route in the navigation stack
        // When accessed via NavigationRail, there's no previous route
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop(_hasChanges);
                },
              )
            : null,
        title: Text(l10n.doseHistoryTitle),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Icon(
              hasFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: hasFilters ? Theme.of(context).colorScheme.primary : null,
            ),
            tooltip: 'Filtrar',
          ),
        ],
        bottom: _tabController == null || _persons.length <= 1
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Todos'), // "All" tab
                  ..._persons.map((person) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (person.isDefault)
                              const Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(Icons.person, size: 16),
                              ),
                            Text(person.name),
                          ],
                        ),
                      )),
                ],
              ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistics card
                StatisticsCard(statistics: _statistics),

                // Active filters chip
                if (hasFilters)
                  ActiveFiltersChip(
                    filterDescription: _getFilterDescription(l10n),
                    onClear: _clearFilters,
                  ),

                // History list
                Expanded(
                  child: _historyEntries.isEmpty
                      ? EmptyHistoryView(
                          message: hasFilters
                              ? l10n.emptyDosesWithFilters
                              : l10n.emptyDoses,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _historyEntries.length,
                          itemBuilder: (context, index) {
                            final entry = _historyEntries[index];
                            return DoseHistoryCard(
                              entry: entry,
                              onTap: () => _showEditEntryDialog(entry),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showEditEntryDialog(DoseHistoryEntry entry) async {
    final action = await EditEntryDialog.show(
      context: context,
      entry: entry,
    );

    if (action == null) return;

    switch (action) {
      case EditEntryAction.markAsTaken:
        _changeEntryStatus(entry, DoseStatus.taken);
        break;
      case EditEntryAction.markAsSkipped:
        _changeEntryStatus(entry, DoseStatus.skipped);
        break;
      case EditEntryAction.delete:
        _confirmDeleteEntry(entry);
        break;
      case EditEntryAction.changeRegisteredTime:
        _changeEntryRegisteredTime(entry);
        break;
    }
  }

  Future<void> _changeEntryStatus(DoseHistoryEntry entry, DoseStatus newStatus) async {
    final l10n = AppLocalizations.of(context)!;

    // Use service to change status
    await DoseHistoryService.changeEntryStatus(entry, newStatus);

    // Reload data
    await _loadData();

    if (!mounted) return;

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.statusUpdatedTo(newStatus.displayName),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _changeEntryRegisteredTime(DoseHistoryEntry entry) async {
    final l10n = AppLocalizations.of(context)!;

    try {
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
      final now = DateTime.now();
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
      await _loadData();
      setState(() {
        _hasChanges = true;
      });

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

  void _confirmDeleteEntry(DoseHistoryEntry entry) async {
    final confirmed = await DeleteConfirmationDialog.show(context);
    if (confirmed) {
      _deleteHistoryEntry(entry);
    }
  }

  Future<void> _deleteHistoryEntry(DoseHistoryEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Use service to delete the entry
      await DoseHistoryService.deleteHistoryEntry(entry);

      // Mark that changes were made
      _hasChanges = true;

      // Reload data
      await _loadData();

      if (!mounted) return;

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseHistoryRecordDeleted),
          duration: const Duration(seconds: 2),
        ),
      );
    } on MedicationNotFoundException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseActionMedicationNotFound),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doseHistoryDeleteError(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getFilterDescription(AppLocalizations l10n) {
    final parts = <String>[];

    if (_selectedMedicationId != null) {
      final medication = _medications.firstWhere((m) => m.id == _selectedMedicationId);
      parts.add(medication.name);
    }

    if (_startDate != null && _endDate != null) {
      parts.add('${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}');
    } else if (_startDate != null) {
      parts.add(l10n.filterFrom('${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'));
    } else if (_endDate != null) {
      parts.add(l10n.filterTo('${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'));
    }

    return parts.join(' • ');
  }
}

