import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../services/localization_service.dart';
import '../utils/date_formatter.dart';
import 'medication_list_screen.dart';
import 'medication_inventory_screen.dart';
import 'dose_history_screen.dart';
import 'settings_screen.dart';

/// Main screen with adaptive navigation
/// Uses NavigationBar (bottom) on mobile/portrait and NavigationRail (side) on tablets/landscape
/// Provides navigation between the main sections of the app:
/// - Medications: Main list of medications with today's doses
/// - Inventory: Unified view with tabs for Pill Organizer and Medicine Cabinet
/// - History: Complete dose history
/// - Settings: App configuration and backup/restore
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _settingsChanged = false; // Flag to track if we just left Settings

  // GlobalKeys to access screen states
  final _medicationListKey = GlobalKey<MedicationListScreenState>();
  final _doseHistoryKey = GlobalKey<DoseHistoryScreenState>();

  // Keep screen instances in memory
  late final Widget _medicationListScreen;
  late final Widget _medicationInventoryScreen;
  late final Widget _doseHistoryScreen;
  late final Widget _settingsScreen;

  @override
  void initState() {
    super.initState();

    // Initialize screen instances
    _medicationListScreen = MedicationListScreen(key: _medicationListKey);
    _medicationInventoryScreen = const MedicationInventoryScreen();
    _doseHistoryScreen = DoseHistoryScreen(key: _doseHistoryKey);
    _settingsScreen = const SettingsScreen();

    // Process any pending notifications after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Update LocalizationService and DateFormatter with the actual device locale
      LocalizationService.instance.updateFromContext(context);
      DateFormatter.setLocale(Localizations.localeOf(context));
      NotificationService.instance.processPendingNotification();
    });
  }

  void _onItemTapped(int index) {
    // Mark that we're leaving Settings - any screen visited after needs to check for changes
    if (_selectedIndex == 3 && index != 3) {
      _settingsChanged = true;
    }

    // Clear the flag when returning to Settings
    if (index == 3 && _settingsChanged) {
      _settingsChanged = false;
    }

    // If we just left Settings and are entering a screen, trigger reload
    if (_settingsChanged && index != 3) {
      if (index == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _medicationListKey.currentState?.reloadAfterSettingsChange();
        });
      } else if (index == 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _doseHistoryKey.currentState?.reloadAfterSettingsChange();
        });
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Use NavigationRail for tablets (>600px) or landscape mode
    final useNavigationRail = screenWidth > 600 || isLandscape;

    if (useNavigationRail) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              backgroundColor: Theme.of(context).colorScheme.surface,
              indicatorColor: Theme.of(context).colorScheme.primary,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.medical_services_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  selectedIcon: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                  ),
                  label: Text(l10n.navMedicationShort),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.inventory_2_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  selectedIcon: const Icon(
                    Icons.inventory_2,
                    color: Colors.white,
                  ),
                  label: Text(l10n.navInventoryShort),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.history_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  selectedIcon: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  label: Text(l10n.navHistoryShort),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  selectedIcon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  label: Text(l10n.navSettingsShort),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _medicationListScreen,
                  _medicationInventoryScreen,
                  _doseHistoryScreen,
                  _settingsScreen,
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Use NavigationBar for mobile/portrait with short labels
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _medicationListScreen,
          _medicationInventoryScreen,
          _doseHistoryScreen,
          _settingsScreen,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.medical_services_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            selectedIcon: const Icon(
              Icons.medical_services,
              color: Colors.white,
            ),
            label: l10n.navMedicationShort,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.inventory_2_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            selectedIcon: const Icon(
              Icons.inventory_2,
              color: Colors.white,
            ),
            label: l10n.navInventoryShort,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.history_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            selectedIcon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: l10n.navHistoryShort,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            selectedIcon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            label: l10n.navSettingsShort,
          ),
        ],
      ),
    );
  }
}
