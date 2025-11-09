import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
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
  int _previousIndex = 0;

  // GlobalKey to access MedicationListScreen state
  final _medicationListKey = GlobalKey<MedicationListScreenState>();

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
    _doseHistoryScreen = const DoseHistoryScreen();
    _settingsScreen = const SettingsScreen();

    // Process any pending notifications after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.processPendingNotification();
    });
  }

  void _onItemTapped(int index) {
    print('🔄 MainScreen._onItemTapped: from $_previousIndex to $index');

    // If returning to medication screen (0) from settings (3), trigger reload
    if (index == 0 && _previousIndex == 3) {
      print('✅ Returning from Settings to Medications, triggering reload');
      // Reload preferences in medication screen after returning from settings
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _medicationListKey.currentState?.reloadAfterSettingsChange();
      });
    }

    setState(() {
      _previousIndex = _selectedIndex;
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
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.medical_services_outlined),
                  selectedIcon: const Icon(Icons.medical_services),
                  label: Text(l10n.navMedicationShort),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.inventory_2_outlined),
                  selectedIcon: const Icon(Icons.inventory_2),
                  label: Text(l10n.navInventoryShort),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history),
                  label: Text(l10n.navHistoryShort),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings),
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.medical_services_outlined),
            selectedIcon: const Icon(Icons.medical_services),
            label: l10n.navMedicationShort,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: l10n.navInventoryShort,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistoryShort,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettingsShort,
          ),
        ],
      ),
    );
  }
}
