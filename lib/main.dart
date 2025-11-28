import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'l10n/app_localizations.dart';
import 'screens/main_screen.dart';
import 'services/notification_service.dart';
import 'services/logger_service.dart';
import 'services/localization_service.dart';
import 'services/locale_provider.dart';
import 'database/database_helper.dart';
import 'models/person.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

// Global navigator key to enable navigation from notification callbacks
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization service with default locale
  await LocalizationService.instance.setLocale(const Locale('en'));

  // Initialize notification service
  try {
    await NotificationService.instance.initialize();
    LoggerService.info('Notification service initialized successfully');

    // Request notification permissions
    final granted = await NotificationService.instance.requestPermissions();
    LoggerService.info('Notification permissions granted: $granted');

    if (!granted) {
      LoggerService.warning('WARNING: Notification permissions were not granted!');
    }

    // Verify notifications are enabled
    final enabled = await NotificationService.instance.areNotificationsEnabled();
    LoggerService.info('Notifications enabled: $enabled');
  } catch (e) {
    LoggerService.error('Error initializing notifications: $e', e);
  }

  // Initialize default person if needed
  try {
    await _initializeDefaultPerson();
    LoggerService.info('Default person initialized successfully');
  } catch (e) {
    LoggerService.error('Error initializing default person: $e', e);
  }

  // Run app immediately for fast startup
  runApp(const MedicApp());

  // Reschedule notifications in background (non-blocking)
  // This ensures notifications are up to date without blocking app startup
  Future.microtask(() async {
    try {
      await NotificationService.instance.rescheduleAllMedicationNotifications();
      LoggerService.info('Notifications rescheduled successfully');
    } catch (e) {
      LoggerService.error('Error rescheduling notifications: $e', e);
    }
  });
}

/// Initialize default person if it doesn't exist
Future<void> _initializeDefaultPerson() async {
  final hasDefaultPerson = await DatabaseHelper.instance.hasDefaultPerson();

  if (!hasDefaultPerson) {
    final defaultPerson = Person(
      id: const Uuid().v4(),
      name: 'Me',
      isDefault: true,
    );

    await DatabaseHelper.instance.insertPerson(defaultPerson);
    LoggerService.info('Default person created with name: ${defaultPerson.name}');
  } else {
    LoggerService.info('Default person already exists');
  }
}

class MedicApp extends StatefulWidget {
  const MedicApp({super.key});

  @override
  State<MedicApp> createState() => _MedicAppState();
}

class _MedicAppState extends State<MedicApp> {
  final ThemeProvider _themeProvider = ThemeProvider();
  final LocaleProvider _localeProvider = LocaleProvider();

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    await _themeProvider.initialize();
    await _localeProvider.initialize();
    // The Consumers will automatically handle rebuilds
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    _localeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
        ChangeNotifierProvider<LocaleProvider>.value(value: _localeProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'MedicApp',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeProvider.locale,
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              return localeProvider.resolveLocale(deviceLocale);
            },
            theme: AppTheme.getLightTheme(themeProvider.colorPalette),
            darkTheme: AppTheme.getDarkTheme(themeProvider.colorPalette),
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
