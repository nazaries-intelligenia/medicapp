import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/medication.dart';
import '../models/person.dart';
import '../services/notification_service.dart';
import '../services/preferences_service.dart';
import '../database/database_helper.dart';

class DebugNotificationsScreen extends StatefulWidget {
  final List<Medication> medications;
  final List<Person> persons;

  const DebugNotificationsScreen({
    super.key,
    required this.medications,
    required this.persons,
  });

  @override
  State<DebugNotificationsScreen> createState() => _DebugNotificationsScreenState();
}

class _DebugNotificationsScreenState extends State<DebugNotificationsScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  bool _isLoading = true;
  bool _notificationsEnabled = false;
  bool _canScheduleExact = false;
  bool _showPersonTabs = true; // User preference for showing person tabs
  List<dynamic> _pendingNotifications = [];
  Map<String, List<Map<String, dynamic>>> _notificationsByPerson = {};
  final Map<String, String> _medicationPersonsMap = {};
  List<Map<String, dynamic>> _notificationHistory = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadNotificationData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Reload when app returns to foreground (e.g., from Settings)
      _reloadAfterSettingsChange();
    }
  }

  Future<void> _reloadAfterSettingsChange() async {
    // Check if showPersonTabs preference changed
    final oldShowPersonTabs = _showPersonTabs;
    final newShowPersonTabs = await PreferencesService.getShowPersonTabs();

    // If preference changed, reload everything
    if (oldShowPersonTabs != newShowPersonTabs) {
      await _loadNotificationData();
    }
  }

  Future<void> _loadNotificationData() async {
    setState(() => _isLoading = true);

    // Load preference
    _showPersonTabs = await PreferencesService.getShowPersonTabs();

    // Dispose old tab controller if exists
    _tabController?.dispose();
    _tabController = null;

    // Initialize tab controller only if tabs are enabled
    if (_showPersonTabs && widget.persons.length > 1) {
      _tabController = TabController(length: widget.persons.length, vsync: this);
    }

    _notificationsEnabled = await NotificationService.instance.areNotificationsEnabled();
    _canScheduleExact = await NotificationService.instance.canScheduleExactAlarms();
    _pendingNotifications = await NotificationService.instance.getPendingNotifications();
    _notificationHistory = await NotificationService.instance.getNotificationHistory();

    // Get all persons assigned to medications for display
    for (final medication in widget.medications) {
      final persons = await DatabaseHelper.instance.getPersonsForMedication(medication.id);
      if (persons.isNotEmpty) {
        _medicationPersonsMap[medication.id] = persons.map((p) => p.name).join(', ');
      }
    }

    // Build notification info with medication data
    final notificationInfoList = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (final notification in _pendingNotifications) {
      final notificationInfo = await _buildNotificationInfo(notification, now);
      notificationInfoList.add(notificationInfo);
    }

    // Group notifications by person
    _notificationsByPerson = {};
    for (final person in widget.persons) {
      _notificationsByPerson[person.id] = [];
    }

    // Assign notifications to persons
    for (final notificationInfo in notificationInfoList) {
      final notification = notificationInfo['notification'];
      if (notification.payload != null && notification.payload!.isNotEmpty) {
        final parts = notification.payload!.split('|');
        if (parts.isNotEmpty) {
          final medicationId = parts[0];
          final medication = widget.medications.firstWhere(
            (m) => m.id == medicationId,
            orElse: () => widget.medications.first,
          );

          if (medication.id == medicationId) {
            // Get persons for this medication
            final persons = await DatabaseHelper.instance.getPersonsForMedication(medicationId);
            for (final person in persons) {
              if (_notificationsByPerson.containsKey(person.id)) {
                _notificationsByPerson[person.id]!.add(notificationInfo);
              }
            }
          }
        }
      }
    }

    setState(() => _isLoading = false);
  }

  Future<Map<String, dynamic>> _buildNotificationInfo(dynamic notification, DateTime now) async {
    final l10n = AppLocalizations.of(context)!;
    String? medicationName;
    String? scheduledTime;
    String? scheduledDate;
    String? notificationType;
    bool isPastDue = false;

    // Determine notification type based on ID range
    final id = notification.id;
    if (id >= 6000000) {
      notificationType = l10n.notificationTypeDynamicFasting;
    } else if (id >= 5000000) {
      notificationType = l10n.notificationTypeScheduledFasting;
    } else if (id >= 4000000) {
      notificationType = l10n.notificationTypeWeeklyPattern;
    } else if (id >= 3000000) {
      notificationType = l10n.notificationTypeSpecificDate;
    } else if (id >= 2000000) {
      notificationType = l10n.notificationTypePostponed;
    } else {
      notificationType = l10n.notificationTypeDailyRecurring;
    }

    // Try to parse payload to get medication info
    if (notification.payload != null && notification.payload!.isNotEmpty) {
      final parts = notification.payload!.split('|');
      if (parts.isNotEmpty) {
        final medicationId = parts[0];
        final medication = widget.medications.firstWhere(
          (m) => m.id == medicationId,
          orElse: () => widget.medications.first,
        );

        if (medication.id == medicationId) {
          medicationName = medication.name;

          // Check if this is a fasting notification
          if (parts.length > 1 && (parts[1].contains('fasting'))) {
            final isDynamic = parts[1].contains('dynamic');
            final fastingType = medication.fastingType == 'before' ? l10n.beforeTaking : l10n.afterTaking;
            final duration = medication.fastingDurationMinutes ?? 0;

            scheduledTime = '$fastingType ($duration min)';

            if (isDynamic) {
              scheduledDate = '${l10n.basedOnActualDose} - ${l10n.todayOrLater}';
            } else {
              if (medication.doseTimes.isNotEmpty) {
                final firstDoseTime = medication.doseTimes.first;
                final timeParts = firstDoseTime.split(':');
                final schedHour = int.parse(timeParts[0]);
                final schedMin = int.parse(timeParts[1]);
                final currentMinutes = now.hour * 60 + now.minute;
                final scheduledMinutes = schedHour * 60 + schedMin;

                if (scheduledMinutes > currentMinutes) {
                  scheduledDate = '${l10n.basedOnSchedule} - ${l10n.today(now.day, now.month, now.year)}';
                } else {
                  final tomorrow = now.add(const Duration(days: 1));
                  scheduledDate = '${l10n.basedOnSchedule} - ${l10n.tomorrow(tomorrow.day, tomorrow.month, tomorrow.year)}';
                }
              } else {
                scheduledDate = l10n.basedOnSchedule;
              }
            }
          } else if (parts.length > 1) {
            // Regular dose notification
            final doseIndexOrTime = parts[1];

            if (doseIndexOrTime.contains(':')) {
              scheduledTime = doseIndexOrTime;
            } else {
              final doseIndex = int.tryParse(doseIndexOrTime);
              if (doseIndex != null && doseIndex < medication.doseTimes.length) {
                scheduledTime = medication.doseTimes[doseIndex];
              }
            }

            if (scheduledTime != null) {
              final timeParts = scheduledTime.split(':');
              final schedHour = int.parse(timeParts[0]);
              final schedMin = int.parse(timeParts[1]);

              if (notificationType == l10n.notificationTypeDailyRecurring) {
                final currentMinutes = now.hour * 60 + now.minute;
                final scheduledMinutes = schedHour * 60 + schedMin;

                if (scheduledMinutes > currentMinutes) {
                  scheduledDate = l10n.today(now.day, now.month, now.year);
                  isPastDue = false;
                } else {
                  final tomorrow = now.add(const Duration(days: 1));
                  scheduledDate = l10n.tomorrow(tomorrow.day, tomorrow.month, tomorrow.year);
                  isPastDue = false;
                }
              } else if (notificationType == l10n.notificationTypeSpecificDate || notificationType == l10n.notificationTypeWeeklyPattern) {
                if (medication.selectedDates != null && medication.selectedDates!.isNotEmpty) {
                  final today = DateTime(now.year, now.month, now.day);
                  for (final dateString in medication.selectedDates!) {
                    final dateParts = dateString.split('-');
                    final date = DateTime(
                      int.parse(dateParts[0]),
                      int.parse(dateParts[1]),
                      int.parse(dateParts[2]),
                    );

                    if (date.isAfter(today) || date.isAtSameMomentAs(today)) {
                      scheduledDate = '${date.day}/${date.month}/${date.year}';

                      if (date.isAtSameMomentAs(today)) {
                        final currentMinutes = now.hour * 60 + now.minute;
                        final scheduledMinutes = schedHour * 60 + schedMin;
                        isPastDue = scheduledMinutes < currentMinutes;
                      }
                      break;
                    }
                  }
                } else if (medication.weeklyDays != null && medication.weeklyDays!.isNotEmpty) {
                  for (int i = 0; i <= 7; i++) {
                    final checkDate = now.add(Duration(days: i));
                    if (medication.weeklyDays!.contains(checkDate.weekday)) {
                      scheduledDate = '${checkDate.day}/${checkDate.month}/${checkDate.year}';

                      if (i == 0) {
                        final currentMinutes = now.hour * 60 + now.minute;
                        final scheduledMinutes = schedHour * 60 + schedMin;
                        isPastDue = scheduledMinutes < currentMinutes;
                      }
                      break;
                    }
                  }
                } else {
                  scheduledDate = l10n.todayOrLater;
                }
              } else if (notificationType == l10n.notificationTypePostponed) {
                final currentMinutes = now.hour * 60 + now.minute;
                final scheduledMinutes = schedHour * 60 + schedMin;

                if (scheduledMinutes > currentMinutes) {
                  scheduledDate = l10n.today(now.day, now.month, now.year);
                } else {
                  final tomorrow = now.add(const Duration(days: 1));
                  scheduledDate = l10n.tomorrow(tomorrow.day, tomorrow.month, tomorrow.year);
                }
              } else {
                final currentMinutes = now.hour * 60 + now.minute;
                final scheduledMinutes = schedHour * 60 + schedMin;

                if (scheduledMinutes > currentMinutes) {
                  scheduledDate = l10n.today(now.day, now.month, now.year);
                  isPastDue = false;
                } else {
                  final tomorrow = now.add(const Duration(days: 1));
                  scheduledDate = l10n.tomorrow(tomorrow.day, tomorrow.month, tomorrow.year);
                  isPastDue = false;
                }
              }
            }
          }
        }
      }
    }

    String? personNames;
    if (notification.payload != null && notification.payload!.isNotEmpty) {
      final parts = notification.payload!.split('|');
      if (parts.isNotEmpty) {
        final medicationId = parts[0];
        personNames = _medicationPersonsMap[medicationId];
      }
    }

    return {
      'notification': notification,
      'medicationName': medicationName,
      'scheduledTime': scheduledTime,
      'scheduledDate': scheduledDate,
      'notificationType': notificationType,
      'isPastDue': isPastDue,
      'personNames': personNames,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationDebugTitle),
        bottom: _showPersonTabs && widget.persons.length > 1 && _tabController != null
            ? TabBar(
                controller: _tabController!,
                isScrollable: widget.persons.length > 3,
                tabs: widget.persons.map((person) => Tab(text: person.name)).toList(),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // General information section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.notificationPermissions(_notificationsEnabled ? l10n.yesText : l10n.noText),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.exactAlarmsAndroid12(_canScheduleExact ? l10n.yesText : l10n.noText),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _canScheduleExact ? Colors.green : Colors.red,
                        ),
                      ),
                      if (!_canScheduleExact) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.importantWarning,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                l10n.withoutPermissionNoNotifications,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(l10n.pendingNotificationsCount(_pendingNotifications.length)),
                      const SizedBox(height: 4),
                      Text(l10n.medicationsWithSchedules(
                        widget.medications.where((m) => m.doseTimes.isNotEmpty).length,
                        widget.medications.length,
                      )),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Notification history section (last 24h)
                if (_notificationHistory.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.notificationHistory,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_notificationHistory.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.last24Hours,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _notificationHistory.length,
                            itemBuilder: (context, index) {
                              final entry = _notificationHistory[index];
                              return _buildHistoryCard(entry);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
                // Tabs content or mixed view
                Expanded(
                  child: widget.persons.isEmpty
                      ? Center(child: Text(l10n.noScheduledNotifications))
                      : _showPersonTabs && widget.persons.length > 1 && _tabController != null
                          ? TabBarView(
                              controller: _tabController!,
                              children: widget.persons.map((person) {
                                final notifications = _notificationsByPerson[person.id] ?? [];
                                return _buildNotificationsList(notifications, person);
                              }).toList(),
                            )
                          : _buildMixedNotificationsList(),
                ),
              ],
            ),
    );
  }

  /// Build mixed view with all persons' notifications together
  Widget _buildMixedNotificationsList() {
    final l10n = AppLocalizations.of(context)!;

    // Collect all notifications with person info
    final allNotifications = <Map<String, dynamic>>[];
    for (final person in widget.persons) {
      final personNotifications = _notificationsByPerson[person.id] ?? [];
      for (final notification in personNotifications) {
        allNotifications.add({
          ...notification,
          'personName': person.name,
          'isDefault': person.isDefault,
        });
      }
    }

    // Get all medications for this view
    final allMedications = widget.medications;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.scheduledNotifications,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (allNotifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l10n.noScheduledNotifications,
              style: const TextStyle(color: Colors.orange),
            ),
          )
        else
          ...allNotifications.map((info) => _buildNotificationCard(info)),
        const SizedBox(height: 24),
        Text(
          l10n.medicationsAndSchedules,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ...allMedications.map((medication) => _buildMedicationCard(medication)),
      ],
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications, Person person) {
    final l10n = AppLocalizations.of(context)!;

    // Get medications for this person
    final personMedications = widget.medications.where((medication) {
      // We need to check if this medication belongs to this person
      // For now, we'll filter based on notifications
      return notifications.any((notif) {
        final notification = notif['notification'];
        if (notification.payload != null && notification.payload!.isNotEmpty) {
          final parts = notification.payload!.split('|');
          if (parts.isNotEmpty) {
            return parts[0] == medication.id;
          }
        }
        return false;
      });
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.scheduledNotifications,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        if (notifications.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              l10n.noScheduledNotifications,
              style: const TextStyle(color: Colors.orange),
            ),
          )
        else
          ...notifications.map((info) => _buildNotificationCard(info)),
        const SizedBox(height: 24),
        Text(
          l10n.medicationsAndSchedules,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ...personMedications.map((medication) => _buildMedicationCard(medication)),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> info) {
    final l10n = AppLocalizations.of(context)!;
    final notification = info['notification'];
    final medicationName = info['medicationName'] as String?;
    final scheduledTime = info['scheduledTime'] as String?;
    final scheduledDate = info['scheduledDate'] as String?;
    final notificationType = info['notificationType'] as String?;
    final isPastDue = info['isPastDue'] as bool;
    final personName = info['personName'] as String?;
    final isDefault = info['isDefault'] as bool?;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isPastDue ? 4 : 2,
        color: isPastDue ? Colors.red.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPastDue ? const BorderSide(color: Colors.red, width: 2) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'ID: ${notification.id}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isPastDue ? Colors.red : null,
                    ),
                  ),
                  if (isPastDue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.pastDueWarning,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (medicationName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.medicationInfo(medicationName),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (personName != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDefault == true ? Icons.person : Icons.person_outline,
                              size: 14,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              personName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (scheduledDate != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPastDue ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.scheduleDate(scheduledDate),
                    style: TextStyle(
                      fontSize: 13,
                      color: isPastDue ? Colors.red.shade800 : Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              if (notificationType != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.notificationType(notificationType),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (scheduledTime != null) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.scheduleTime(scheduledTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: isPastDue ? Colors.red.shade700 : Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                notification.title ?? l10n.noTitle,
                style: const TextStyle(fontSize: 13),
              ),
              if (notification.body != null) ...[
                const SizedBox(height: 2),
                Text(
                  notification.body!,
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              if (medication.doseTimes.isEmpty)
                Text(
                  l10n.noSchedulesConfiguredWarning,
                  style: const TextStyle(fontSize: 13, color: Colors.orange),
                )
              else
                ...medication.doseTimes.map((time) => Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Text('• $time', style: const TextStyle(fontSize: 13)),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> entry) {
    final timestamp = DateTime.parse(entry['timestamp'] as String);
    final medicationName = entry['medicationName'] as String;
    final doseTime = entry['doseTime'] as String;
    final personName = entry['personName'] as String;

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Hace unos segundos';
    } else if (difference.inMinutes < 60) {
      timeAgo = 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      timeAgo = 'Hace ${difference.inHours} h';
    } else {
      timeAgo = '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      medicationName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    doseTime,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      personName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
