import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../services/preferences_service.dart';
import '../services/snackbar_service.dart';
import '../services/notifications/notification_config.dart';
import '../services/locale_provider.dart';
import '../utils/platform_helper.dart';
import '../utils/responsive_helper.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/responsive/adaptive_grid.dart';
import 'settings/widgets/setting_option_card.dart';
import 'settings/widgets/setting_switch_card.dart';
import 'settings/widgets/info_card.dart';
import 'persons/persons_management_screen.dart';

/// Settings screen with backup/restore functionality
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  bool _showActualTime = false;
  bool _showFastingCountdown = false;
  bool _showFastingNotification = false;
  bool _showPersonTabs = true;
  int _personCount = 0;
  bool _canOpenNotificationSettings = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkNotificationSettingsAvailability();
  }

  /// Check if notification settings can be opened on this device
  Future<void> _checkNotificationSettingsAvailability() async {
    final canOpen = await NotificationConfig.canOpenNotificationSettings();
    if (mounted) {
      setState(() {
        _canOpenNotificationSettings = canOpen;
      });
    }
  }

  /// Load preferences from storage
  Future<void> _loadPreferences() async {
    final showActualTime = await PreferencesService.getShowActualTimeForTakenDoses();
    final showFastingCountdown = await PreferencesService.getShowFastingCountdown();
    final showFastingNotification = await PreferencesService.getShowFastingNotification();
    final showPersonTabs = await PreferencesService.getShowPersonTabs();

    // Load person count to determine if tabs setting should be shown
    final persons = await DatabaseHelper.instance.getAllPersons();

    if (mounted) {
      setState(() {
        _showActualTime = showActualTime;
        _showFastingCountdown = showFastingCountdown;
        _showFastingNotification = showFastingNotification;
        _showPersonTabs = showPersonTabs;
        _personCount = persons.length;
      });
    }
  }

  /// Handle show actual time toggle
  Future<void> _handleShowActualTimeChanged(bool value) async {
    await PreferencesService.setShowActualTimeForTakenDoses(value);
    if (mounted) {
      setState(() {
        _showActualTime = value;
      });
    }
  }

  /// Handle show fasting countdown toggle
  Future<void> _handleShowFastingCountdownChanged(bool value) async {
    await PreferencesService.setShowFastingCountdown(value);
    // If disabling countdown, also disable notification
    if (!value && _showFastingNotification) {
      await PreferencesService.setShowFastingNotification(false);
    }
    if (mounted) {
      setState(() {
        _showFastingCountdown = value;
        // If disabling countdown, also disable notification
        if (!value && _showFastingNotification) {
          _showFastingNotification = false;
        }
      });
    }
  }

  /// Handle show fasting notification toggle
  Future<void> _handleShowFastingNotificationChanged(bool value) async {
    await PreferencesService.setShowFastingNotification(value);
    if (mounted) {
      setState(() {
        _showFastingNotification = value;
      });
    }
  }

  /// Handle show person tabs toggle
  Future<void> _handleShowPersonTabsChanged(bool value) async {
    await PreferencesService.setShowPersonTabs(value);
    if (mounted) {
      setState(() {
        _showPersonTabs = value;
      });
    }
  }

  /// Navigate to persons management screen
  void _navigateToPersonsManagement() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonsManagementScreen(),
      ),
    );

    // Reload preferences when returning, in case person count changed
    _loadPreferences();
  }

  /// Export the database and share it
  Future<void> _exportDatabase() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isExporting = true;
    });

    try {
      // Export database to a temporary file
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      if (!mounted) return;

      // Share the file
      final result = await Share.shareXFiles(
        [XFile(exportPath)],
        text: l10n.settingsShareText,
      );

      if (!mounted) return;

      if (result.status == ShareResultStatus.success) {
        SnackBarService.showSuccess(context, l10n.settingsExportSuccess);
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarService.showError(context, l10n.settingsExportError(e.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  /// Import a database from a file
  Future<void> _importDatabase() async {
    final l10n = AppLocalizations.of(context)!;

    // Show confirmation dialog first
    final confirm = await _showConfirmDialog(
      l10n.settingsImportDialogTitle,
      l10n.settingsImportDialogMessage,
    );

    if (confirm != true) return;

    setState(() {
      _isImporting = true;
    });

    try {
      // Pick a file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isImporting = false;
        });
        return;
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception(l10n.settingsFilePathError);
      }

      // Import the database
      await DatabaseHelper.instance.importDatabase(filePath);

      if (!mounted) return;

      SnackBarService.showSuccess(context, l10n.settingsImportSuccess);

      // Show restart dialog
      _showRestartDialog();
    } catch (e) {
      if (!mounted) return;
      SnackBarService.showError(context, l10n.settingsImportError(e.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  /// Show a confirmation dialog
  Future<bool?> _showConfirmDialog(String title, String message) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.btnContinue),
          ),
        ],
      ),
    );
  }

  /// Show restart dialog after import
  void _showRestartDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsRestartDialogTitle),
        content: Text(l10n.settingsRestartDialogMessage),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to main screen
            },
            child: Text(l10n.settingsRestartDialogButton),
          ),
        ],
      ),
    );
  }

  /// Show color palette selection dialog
  void _showColorPaletteDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentPalette = themeProvider.colorPalette;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar paleta de colores'),
        content: RadioGroup<ColorPalette>(
          groupValue: currentPalette,
          onChanged: (ColorPalette? value) {
            if (value != null) {
              themeProvider.setColorPalette(value);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ColorPalette.values.map((palette) {
              final isSelected = palette == currentPalette;
              return RadioListTile<ColorPalette>(
                title: Text(palette.displayName),
                subtitle: Text(palette.description),
                value: palette,
                selected: isSelected,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Open notification channel settings (Android 8.0+ only)
  Future<void> _openNotificationSettings() async {
    try {
      await NotificationConfig.openNotificationChannelSettings();
    } catch (e) {
      if (!mounted) return;
      SnackBarService.showError(
        context,
        'No se pudo abrir los ajustes: ${e.toString()}',
      );
    }
  }

  /// Show language selection dialog
  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsLanguageTitle),
        content: SingleChildScrollView(
          child: RadioGroup<String?>(
            groupValue: currentLocale?.languageCode,
            onChanged: (String? value) {
              final deviceLocale = View.of(context).platformDispatcher.locale;
              if (value == null) {
                localeProvider.setLocale(null, deviceLocale: deviceLocale);
              } else {
                localeProvider.setLocale(Locale(value), deviceLocale: deviceLocale);
              }
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // System default option
                RadioListTile<String?>(
                  title: Text(l10n.settingsLanguageSystem),
                  value: null,
                ),
                const Divider(),
                // Language options
                ...LocaleProvider.supportedLanguages.entries.map((entry) {
                  return RadioListTile<String?>(
                    title: Text(entry.value),
                    value: entry.key,
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ContentContainer(
        maxWidth: context.formMaxWidth,
        child: ListView(
          children: [
          // Persons Management Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gestión de Personas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Manage Persons Card
          SettingOptionCard(
            icon: Icons.people,
            iconColor: theme.colorScheme.tertiary,
            title: 'Personas',
            subtitle: 'Gestiona las personas que usan la aplicación',
            isLoading: false,
            enabled: true,
            onTap: _navigateToPersonsManagement,
          ),

          const SizedBox(height: 16),

          // Appearance Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Apariencia',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Color Palette Card
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SettingOptionCard(
                icon: Icons.palette,
                iconColor: theme.colorScheme.primary,
                title: l10n.settingsColorPaletteTitle,
                subtitle: themeProvider.colorPalette.displayName,
                isLoading: false,
                enabled: true,
                onTap: _showColorPaletteDialog,
              );
            },
          ),

          // Language Card
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              final currentLanguage = localeProvider.locale?.languageCode;
              final languageName = currentLanguage != null
                  ? LocaleProvider.supportedLanguages[currentLanguage] ?? currentLanguage
                  : l10n.settingsLanguageSystem;
              return SettingOptionCard(
                icon: Icons.language,
                iconColor: theme.colorScheme.secondary,
                title: l10n.settingsLanguageTitle,
                subtitle: languageName,
                isLoading: false,
                enabled: true,
                onTap: _showLanguageDialog,
              );
            },
          ),

          // Notification Sound Card (Android 8.0+ only)
          if (_canOpenNotificationSettings)
            SettingOptionCard(
              icon: Icons.music_note,
              iconColor: theme.colorScheme.secondary,
              title: l10n.settingsNotificationSoundTitle,
              subtitle: l10n.settingsNotificationSoundSubtitle,
              isLoading: false,
              enabled: true,
              onTap: _openNotificationSettings,
            ),

          const SizedBox(height: 16),

          // Display Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.settingsDisplaySection,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Show Actual Time Switch
          SettingSwitchCard(
            icon: Icons.access_time,
            iconColor: theme.colorScheme.tertiary,
            title: l10n.settingsShowActualTimeTitle,
            subtitle: l10n.settingsShowActualTimeSubtitle,
            value: _showActualTime,
            onChanged: _handleShowActualTimeChanged,
          ),

          // Show Fasting Countdown Switch
          SettingSwitchCard(
            icon: Icons.restaurant,
            iconColor: theme.colorScheme.secondary,
            title: l10n.settingsShowFastingCountdownTitle,
            subtitle: l10n.settingsShowFastingCountdownSubtitle,
            value: _showFastingCountdown,
            onChanged: _handleShowFastingCountdownChanged,
          ),

          // Show Fasting Notification Switch (only on Android and if countdown is enabled)
          if (PlatformHelper.isAndroid && _showFastingCountdown)
            SettingSwitchCard(
              icon: Icons.notifications_active,
              iconColor: Colors.orange,
              title: l10n.settingsShowFastingNotificationTitle,
              subtitle: l10n.settingsShowFastingNotificationSubtitle,
              value: _showFastingNotification,
              onChanged: _handleShowFastingNotificationChanged,
            ),

          // Show Person Tabs Switch (only when there are 2+ persons)
          if (_personCount >= 2)
            SettingSwitchCard(
              icon: Icons.tab,
              iconColor: theme.colorScheme.tertiary,
              title: l10n.settingsShowPersonTabsTitle,
              subtitle: l10n.settingsShowPersonTabsSubtitle,
              value: _showPersonTabs,
              onChanged: _handleShowPersonTabsChanged,
            ),

          const SizedBox(height: 16),

          // Backup & Restore Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.settingsBackupSection,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Export Database Card
          SettingOptionCard(
            icon: Icons.upload_file,
            iconColor: theme.colorScheme.primary,
            title: l10n.settingsExportTitle,
            subtitle: l10n.settingsExportSubtitle,
            isLoading: _isExporting,
            enabled: !_isExporting && !_isImporting,
            onTap: _exportDatabase,
          ),

          // Import Database Card
          SettingOptionCard(
            icon: Icons.download_for_offline,
            iconColor: theme.colorScheme.secondary,
            title: l10n.settingsImportTitle,
            subtitle: l10n.settingsImportSubtitle,
            isLoading: _isImporting,
            enabled: !_isExporting && !_isImporting,
            onTap: _importDatabase,
          ),

          // Info Section
          const InfoCard(),
        ],
        ),
      ),
    );
  }
}
