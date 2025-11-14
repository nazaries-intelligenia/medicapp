# Troubleshooting Guide

## Introduction

### Document Purpose

This guide provides solutions to common problems that may arise during the development, compilation, and use of MedicApp. It is designed to help developers and users resolve issues quickly and effectively.

### How to Use This Guide

1. Identify your problem category in the index
2. Read the problem description to confirm it matches your situation
3. Follow the solution steps in order
4. If the problem persists, consult the "Getting Help" section

---

## Installation Issues

### Flutter SDK Not Found

**Description**: When running Flutter commands, the error "flutter: command not found" appears.

**Probable Cause**: Flutter is not installed or not in the system PATH.

**Solution**:

1. Verify if Flutter is installed:
```bash
which flutter
```

2. If not installed, download Flutter from [flutter.dev](https://flutter.dev)

3. Add Flutter to PATH:
```bash
# In ~/.bashrc, ~/.zshrc, or similar
export PATH="$PATH:/path/to/flutter/bin"
```

4. Restart your terminal and verify:
```bash
flutter --version
```

**References**: [Flutter installation documentation](https://docs.flutter.dev/get-started/install)

---

### Incorrect Flutter Version

**Description**: The installed Flutter version does not meet the project requirements.

**Probable Cause**: MedicApp requires Flutter 3.24.5 or higher.

**Solution**:

1. Check your current version:
```bash
flutter --version
```

2. Update Flutter:
```bash
flutter upgrade
```

3. If you need a specific version, use FVM:
```bash
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5
```

4. Verify the version after updating:
```bash
flutter --version
```

---

### Problems with flutter pub get

**Description**: Error when downloading dependencies with `flutter pub get`.

**Probable Cause**: Network issues, corrupted cache, or version conflicts.

**Solution**:

1. Clean the pub cache:
```bash
flutter pub cache repair
```

2. Delete the pubspec.lock file:
```bash
rm pubspec.lock
```

3. Try again:
```bash
flutter pub get
```

4. If it persists, check internet connection and proxy:
```bash
# Configure proxy if necessary
export HTTP_PROXY=http://proxy.example.com:8080
export HTTPS_PROXY=http://proxy.example.com:8080
```

---

### Problems with CocoaPods (iOS)

**Description**: CocoaPods-related errors during iOS compilation.

**Probable Cause**: Outdated CocoaPods or corrupted cache.

**Solution**:

1. Update CocoaPods:
```bash
sudo gem install cocoapods
```

2. Clean the pods cache:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
```

3. Reinstall the pods:
```bash
pod install --repo-update
```

4. If it persists, update the specs repository:
```bash
pod repo update
```

**References**: [CocoaPods Guides](https://guides.cocoapods.org/using/troubleshooting.html)

---

### Problems with Gradle (Android)

**Description**: Gradle-related compilation errors on Android.

**Probable Cause**: Corrupted Gradle cache or incorrect configuration.

**Solution**:

1. Clean the project:
```bash
cd android
./gradlew clean
```

2. Clean the Gradle cache:
```bash
./gradlew cleanBuildCache
rm -rf ~/.gradle/caches/
```

3. Sync the project:
```bash
./gradlew --refresh-dependencies
```

4. Invalidate cache in Android Studio:
   - File > Invalidate Caches / Restart

---

## Compilation Issues

### Dependency Errors

**Description**: Conflicts between package versions or missing dependencies.

**Probable Cause**: Incompatible versions in pubspec.yaml or conflicting transitive dependencies.

**Solution**:

1. Check the pubspec.yaml file for conflicting version constraints

2. Use the dependency analysis command:
```bash
flutter pub deps
```

3. Resolve conflicts by specifying compatible versions:
```yaml
dependency_overrides:
  conflicting_package: ^1.0.0
```

4. Update all dependencies to compatible versions:
```bash
flutter pub upgrade --major-versions
```

---

### Version Conflicts

**Description**: Two or more packages require incompatible versions of a common dependency.

**Probable Cause**: Very strict version constraints in dependencies.

**Solution**:

1. Identify the conflict:
```bash
flutter pub deps | grep "✗"
```

2. Use `dependency_overrides` temporarily:
```yaml
dependency_overrides:
  shared_dependency: ^2.0.0
```

3. Report the conflict to package maintainers

4. As a last resort, consider alternatives to conflicting packages

---

### l10n Generation Errors

**Description**: Failures when generating localization files.

**Probable Cause**: Syntax errors in .arb files or incorrect configuration.

**Solution**:

1. Verify the syntax of .arb files in `lib/l10n/`:
   - Ensure they are valid JSON
   - Verify that placeholders are consistent

2. Clean and regenerate:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

3. Verify the configuration in pubspec.yaml:
```yaml
flutter:
  generate: true
```

4. Review `l10n.yaml` for correct configuration

**References**: [Internationalization in Flutter](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

---

### Android Build Failed

**Description**: Android compilation fails with various errors.

**Probable Cause**: Gradle configuration, SDK version, or permission issues.

**Solution**:

1. Verify Java version (requires Java 17):
```bash
java -version
```

2. Clean the project completely:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

3. Verify settings in `android/app/build.gradle`:
   - `compileSdkVersion`: 34
   - `minSdkVersion`: 23
   - `targetSdkVersion`: 34

4. Build with detailed information:
```bash
flutter build apk --verbose
```

5. If the error mentions permissions, verify `android/app/src/main/AndroidManifest.xml`

---

### iOS Build Failed

**Description**: iOS compilation fails or cannot sign the app.

**Probable Cause**: Certificates, provisioning profiles, or Xcode configuration.

**Solution**:

1. Open the project in Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Verify signing configuration:
   - Select the Runner project
   - In "Signing & Capabilities", verify the Team and Bundle Identifier

3. Clean the Xcode build:
   - Product > Clean Build Folder (Shift + Cmd + K)

4. Update the pods:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

5. Build from terminal:
```bash
flutter build ios --verbose
```

---

## Database Issues

### Database is Locked

**Description**: "database is locked" error when attempting database operations.

**Probable Cause**: Multiple connections trying to write simultaneously or unclosed transaction.

**Solution**:

1. Ensure all connections are properly closed in the code

2. Verify there are no open transactions without commit/rollback

3. Restart the application completely

4. As a last resort, delete the database:
```bash
# Android
adb shell run-as com.medicapp.app rm -r /data/data/com.medicapp.app/databases/

# iOS - from Xcode, delete the app container
```

**References**: Review `lib/core/database/database_helper.dart` for transaction handling.

---

### Migration Errors

**Description**: Failures when updating the database schema.

**Probable Cause**: Incorrect migration script or inconsistent database version.

**Solution**:

1. Review the migration scripts in `DatabaseHelper`

2. Verify the current database version:
```dart
final db = await DatabaseHelper.instance.database;
print('Database version: ${await db.getVersion()}');
```

3. For development, reset the database:
   - Uninstall the app
   - Reinstall

4. For production, create a migration script that handles the specific case

5. Use the app's debug screen to verify the DB state

---

### Data Does Not Persist

**Description**: Entered data disappears after closing the app.

**Probable Cause**: Database operations do not complete or fail silently.

**Solution**:

1. Enable database logs in debug mode

2. Verify that insert/update operations return success:
```dart
final id = await db.insert('medications', medication.toMap());
print('Inserted medication with id: $id');
```

3. Ensure there are no silent exceptions

4. Verify write permissions on the device

5. Check that `await` is present in all async operations

---

### Database Corruption

**Description**: Errors when opening the database or inconsistent data.

**Probable Cause**: Unexpected app closure during write or file system issue.

**Solution**:

1. Try to repair the database using the sqlite3 command (requires root access):
```bash
sqlite3 /path/to/database.db "PRAGMA integrity_check;"
```

2. If corrupted, restore from backup if it exists

3. If there's no backup, reset the database:
   - Uninstall the app
   - Reinstall
   - Data will be lost

4. **Prevention**: Implement automatic periodic backups

---

### How to Reset Database

**Description**: You need to completely delete the database to start from scratch.

**Probable Cause**: Development, testing, or troubleshooting.

**Solution**:

**Option 1 - From the App (Development)**:
```dart
// In the debug screen
await DatabaseHelper.instance.deleteDatabase();
```

**Option 2 - Android**:
```bash
adb shell run-as com.medicapp.app rm /data/data/com.medicapp.app/databases/medicapp.db
```

**Option 3 - iOS**:
- Uninstall the app from the device/simulator
- Reinstall

**Option 4 - Both platforms**:
```bash
flutter clean
# Uninstall manually from the device
flutter run
```

---

## Notification Issues

### Notifications Do Not Appear

**Description**: Scheduled notifications are not shown.

**Probable Cause**: Permissions not granted, notifications disabled, or error in scheduling.

**Solution**:

1. Verify notification permissions:
   - Android 13+: Must request `POST_NOTIFICATIONS`
   - iOS: Must request authorization on first launch

2. Check device configuration:
   - Android: Settings > Apps > MedicApp > Notifications
   - iOS: Settings > Notifications > MedicApp

3. Verify that notifications are scheduled:
```dart
final pendingNotifications = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
print('Pending notifications: ${pendingNotifications.length}');
```

4. Review logs for scheduling errors

5. Use the app's debug screen to see scheduled notifications

---

### Denied Permissions (Android 13+)

**Description**: On Android 13+, notifications don't work even though the app requests them.

**Probable Cause**: The `POST_NOTIFICATIONS` permission was denied by the user.

**Solution**:

1. Verify that the permission is declared in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. The app must request the permission at runtime

3. If the user denied it, guide them to settings:
```dart
await openAppSettings();
```

4. Explain to the user why notifications are essential for the app

5. Never assume the permission is granted; always verify before scheduling

---

### Exact Alarms Do Not Work

**Description**: Notifications do not appear at the exact scheduled time.

**Probable Cause**: Missing `SCHEDULE_EXACT_ALARM` permission or battery restrictions.

**Solution**:

1. Verify permissions in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. For Android 12+, request the permission:
```dart
if (await Permission.scheduleExactAlarm.isDenied) {
  await Permission.scheduleExactAlarm.request();
}
```

3. Disable battery optimization for the app:
   - Settings > Battery > Battery optimization
   - Find MedicApp and select "Don't optimize"

4. Verify that you use `androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle`

---

### Notifications Do Not Sound

**Description**: Notifications appear but without sound.

**Probable Cause**: Notification channel without sound or device silent mode.

**Solution**:

1. Verify the notification channel configuration:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'medication_reminders',
  'Medication Reminders',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

2. Ensure the sound file exists in `android/app/src/main/res/raw/`

3. Verify device configuration:
   - Android: Settings > Apps > MedicApp > Notifications > Category
   - iOS: Settings > Notifications > MedicApp > Sounds

4. Check that the device is not in silent/do not disturb mode

---

### Notifications After Device Restart

**Description**: Notifications stop working after restarting the device.

**Probable Cause**: Scheduled notifications do not persist after restart.

**Solution**:

1. Add the `RECEIVE_BOOT_COMPLETED` permission in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

2. Implement a `BroadcastReceiver` to reschedule notifications:
```xml
<receiver android:name=".BootReceiver" android:enabled="true" android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

3. Implement the logic to reschedule all pending notifications

4. On iOS, local notifications persist automatically

**References**: Review `android/app/src/main/kotlin/.../MainActivity.kt`

---

## Performance Issues

### App Slow in Debug Mode

**Description**: The application has poor performance and is slow.

**Probable Cause**: Debug mode includes development tools that affect performance.

**Solution**:

1. **This is normal in debug mode**. To evaluate real performance, build in profile or release mode:
```bash
flutter run --profile
# or
flutter run --release
```

2. Use Flutter DevTools to identify bottlenecks:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

3. Verify there are no excessive `print()` statements in hot paths

4. Never evaluate performance in debug mode

---

### Excessive Battery Consumption

**Description**: The application consumes a lot of battery.

**Probable Cause**: Excessive use of notifications, background tasks, or frequent queries.

**Solution**:

1. Reduce the frequency of background checks

2. Optimize database queries:
   - Use appropriate indexes
   - Avoid unnecessary queries
   - Cache results when possible

3. Use `WorkManager` instead of frequent alarms when appropriate

4. Review the use of sensors or GPS (if applicable)

5. Profile battery usage with Android Studio:
   - View > Tool Windows > Energy Profiler

---

### Lag in Long Lists

**Description**: Scrolling in lists with many elements is slow or choppy.

**Probable Cause**: Inefficient widget rendering or lack of ListView optimization.

**Solution**:

1. Use `ListView.builder` instead of `ListView`:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

2. Implement `const` constructors where possible

3. Avoid heavy widgets in each list item

4. Use `RepaintBoundary` for complex widgets:
```dart
RepaintBoundary(
  child: ComplexWidget(),
)
```

5. Consider pagination for very long lists

6. Use `AutomaticKeepAliveClientMixin` to maintain item state

---

### Skipped Frames

**Description**: The UI feels choppy with dropped frames.

**Probable Cause**: Expensive operations on the main thread.

**Solution**:

1. Identify the problem with Flutter DevTools Performance tab

2. Move expensive operations to isolates:
```dart
final result = await compute(expensiveFunction, data);
```

3. Avoid heavy synchronous operations in the build method

4. Use `FutureBuilder` or `StreamBuilder` for async operations

5. Optimize large images:
   - Use compressed formats
   - Cache decoded images
   - Use thumbnails for previews

6. Check for animations with expensive listeners

---

## UI/UX Issues

### Text Does Not Translate

**Description**: Some texts appear in English or another incorrect language.

**Probable Cause**: Missing string in the .arb file or not using AppLocalizations.

**Solution**:

1. Verify that the string exists in `lib/l10n/app_es.arb`:
```json
{
  "yourKey": "Your translated text"
}
```

2. Ensure you use `AppLocalizations.of(context)`:
```dart
Text(AppLocalizations.of(context)!.yourKey)
```

3. Regenerate localization files:
```bash
flutter gen-l10n
```

4. If you added a new key, ensure it exists in all .arb files

5. Verify that the device locale is configured correctly

---

### Incorrect Colors

**Description**: Colors do not match the design or expected theme.

**Probable Cause**: Incorrect use of theme or hardcoded colors.

**Solution**:

1. Always use theme colors:
```dart
// Correct
color: Theme.of(context).colorScheme.primary

// Incorrect
color: Colors.blue
```

2. Verify the theme definition in `lib/core/theme/app_theme.dart`

3. Ensure the MaterialApp has the theme configured:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  // ...
)
```

4. For debugging, print current colors:
```dart
print('Primary: ${Theme.of(context).colorScheme.primary}');
```

---

### Broken Layout on Small Screens

**Description**: The UI overflows or looks bad on devices with small screens.

**Probable Cause**: Widgets with fixed sizes or lack of responsive design.

**Solution**:

1. Use flexible widgets instead of fixed sizes:
```dart
// Instead of
Container(width: 300, child: ...)

// Use
Expanded(child: ...)
// or
Flexible(child: ...)
```

2. Use `LayoutBuilder` for adaptive layouts:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else {
      return TabletLayout();
    }
  },
)
```

3. Use `MediaQuery` to get dimensions:
```dart
final screenWidth = MediaQuery.of(context).size.width;
```

4. Test on different screen sizes using the emulator

---

### Text Overflow

**Description**: The "overflow" warning appears with yellow and black stripes.

**Probable Cause**: Text too long for the available space.

**Solution**:

1. Wrap the text in `Flexible` or `Expanded`:
```dart
Flexible(
  child: Text('Long text...'),
)
```

2. Use `overflow` and `maxLines` in the Text widget:
```dart
Text(
  'Long text...',
  overflow: TextOverflow.ellipsis,
  maxLines: 2,
)
```

3. For very long texts, use `SingleChildScrollView`:
```dart
SingleChildScrollView(
  child: Text('Very long text...'),
)
```

4. Consider shortening the text or using a different format

---

## Multi-Person Issues

### Stock Not Shared Correctly

**Description**: Multiple people can create medications with the same name without sharing stock.

**Probable Cause**: Duplicate verification logic by person instead of global.

**Solution**:

1. Verify the existing medication search function in `MedicationRepository`

2. Ensure the search is global:
```dart
// Search by name without filtering by personId
final existing = await db.query(
  'medications',
  where: 'name = ?',
  whereArgs: [name],
);
```

3. When adding a dose, associate the dose with the person but not the medication

4. Review the logic in `AddMedicationScreen` to reuse existing medications

---

### Duplicate Medications

**Description**: Duplicate medications appear in the list.

**Probable Cause**: Multiple insertions of the same medication or lack of validation.

**Solution**:

1. Implement verification before inserting:
```dart
final existing = await getMedicationByName(name);
if (existing != null) {
  return existing.id;
}
```

2. Use UNIQUE constraints in the database:
```sql
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  -- ...
);
```

3. Review the medication creation logic in the repository

4. If duplicates already exist, create a migration script to consolidate them

---

### Incorrect Dose History

**Description**: History shows doses from other people or information is missing.

**Probable Cause**: Incorrect filtering by person or misconfigured joins.

**Solution**:

1. Verify the query that gets the history:
```dart
final doses = await db.query(
  'dose_history',
  where: 'personId = ?',
  whereArgs: [personId],
  orderBy: 'takenAt DESC',
);
```

2. Ensure all doses have associated `personId`

3. Review the filtering logic in `DoseHistoryScreen`

4. Verify that joins between tables include the person condition

---

### Default Person Does Not Change

**Description**: When changing the active person, the UI does not update correctly.

**Probable Cause**: State does not propagate correctly or missing rebuild.

**Solution**:

1. Verify that you use a global state (Provider, Bloc, etc.):
```dart
Provider.of<PersonProvider>(context, listen: true).currentPerson
```

2. Ensure the person change triggers `notifyListeners()`:
```dart
void setCurrentPerson(Person person) {
  _currentPerson = person;
  notifyListeners();
}
```

3. Verify that relevant widgets listen to changes

4. Consider using `Consumer` for specific rebuilds:
```dart
Consumer<PersonProvider>(
  builder: (context, provider, child) {
    return Text(provider.currentPerson.name);
  },
)
```

---

## Fasting Issues

### Fasting Notification Does Not Appear

**Description**: The ongoing fasting notification is not displayed.

**Probable Cause**: Permissions, channel configuration, or error creating the notification.

**Solution**:

1. Verify that the fasting notification channel is created:
```dart
const AndroidNotificationChannel fastingChannel = AndroidNotificationChannel(
  'fasting',
  'Fasting',
  importance: Importance.low,
  enableVibration: false,
);
```

2. Ensure you use `ongoing: true`:
```dart
const NotificationDetails(
  android: AndroidNotificationDetails(
    'fasting',
    'Fasting',
    ongoing: true,
    autoCancel: false,
  ),
)
```

3. Verify notification permissions

4. Review logs for errors when creating the notification

---

### Incorrect Countdown

**Description**: The remaining fasting time is incorrect or does not update.

**Probable Cause**: Incorrect time calculation or lack of periodic update.

**Solution**:

1. Verify the remaining time calculation:
```dart
final remaining = endTime.difference(DateTime.now());
```

2. Ensure the notification is updated periodically:
```dart
Timer.periodic(Duration(minutes: 1), (timer) {
  updateFastingNotification();
});
```

3. Verify that the fasting `endTime` is stored correctly

4. Use the debug screen to verify the current fasting state

---

### Fasting Does Not Cancel Automatically

**Description**: The fasting notification remains after the time ends.

**Probable Cause**: Missing logic to cancel the notification when completed.

**Solution**:

1. Implement verification when fasting ends:
```dart
if (DateTime.now().isAfter(fasting.endTime)) {
  await cancelFastingNotification();
  await markFastingAsCompleted(fasting.id);
}
```

2. Verify when the app opens:
```dart
@override
void initState() {
  super.initState();
  checkActiveFastings();
}
```

3. Schedule an alarm for when fasting ends to cancel the notification

4. Ensure the notification is cancelled in `onDidReceiveNotificationResponse`

**References**: Review `lib/features/fasting/` for the implementation.

---

## Testing Issues

### Tests Fail Locally

**Description**: Tests that pass in CI fail on your local machine.

**Probable Cause**: Environment differences, dependencies, or configuration.

**Solution**:

1. Clean and rebuild:
```bash
flutter clean
flutter pub get
```

2. Verify versions are the same:
```bash
flutter --version
dart --version
```

3. Run tests with more information:
```bash
flutter test --verbose
```

4. Ensure there are no tests that depend on previous state

5. Verify there are no tests with time dependencies (use `fakeAsync`)

---

### Problems with sqflite_common_ffi

**Description**: Database tests fail with sqflite errors.

**Probable Cause**: sqflite is not available in tests, you need to use sqflite_common_ffi.

**Solution**:

1. Ensure you have the dependency:
```yaml
dev_dependencies:
  sqflite_common_ffi: ^2.3.0
```

2. Initialize in test setup:
```dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('database test', () async {
    // ...
  });
}
```

3. Use in-memory databases for tests:
```dart
final db = await databaseFactoryFfi.openDatabase(
  inMemoryDatabasePath,
);
```

4. Clean the database after each test

---

### Timeouts in Tests

**Description**: Tests fail due to timeout.

**Probable Cause**: Slow operations or deadlocks in async tests.

**Solution**:

1. Increase timeout for specific tests:
```dart
test('slow test', () async {
  // ...
}, timeout: Timeout(Duration(seconds: 30)));
```

2. Verify there are no missing `await`

3. Use `fakeAsync` for tests with delays:
```dart
testWidgets('timer test', (tester) async {
  await tester.runAsync(() async {
    // test code with delays
  });
});
```

4. Mock slow operations like network calls

5. Check for infinite loops or race conditions

---

### Inconsistent Tests

**Description**: The same tests sometimes pass and sometimes fail.

**Probable Cause**: Tests with time dependencies, execution order, or shared state.

**Solution**:

1. Avoid depending on real time, use `fakeAsync` or mocks

2. Ensure each test is independent:
```dart
setUp(() {
  // Clean setup for each test
});

tearDown(() {
  // Cleanup after each test
});
```

3. Don't share mutable state between tests

4. Use `setUpAll` only for immutable setup

5. Run tests in random order to detect dependencies:
```bash
flutter test --test-randomize-ordering-seed=random
```

---

## Permission Issues

### POST_NOTIFICATIONS (Android 13+)

**Description**: Notifications don't work on Android 13 or higher.

**Probable Cause**: The POST_NOTIFICATIONS permission must be requested at runtime.

**Solution**:

1. Declare the permission in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

2. Request the permission at runtime:
```dart
if (Platform.isAndroid && await Permission.notification.isDenied) {
  final status = await Permission.notification.request();
  if (status.isDenied) {
    // Inform the user and offer to go to settings
  }
}
```

3. Verify the permission before scheduling notifications

4. Guide the user to settings if permanently denied

**References**: [Android 13 Notification Permission](https://developer.android.com/about/versions/13/changes/notification-permission)

---

### SCHEDULE_EXACT_ALARM (Android 12+)

**Description**: Exact alarms don't work on Android 12+.

**Probable Cause**: Requires special permission since Android 12.

**Solution**:

1. Declare the permission:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Verify and request if necessary:
```dart
if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt >= 31) {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }
}
```

3. Explain to the user why you need exact alarms

4. Consider using `USE_EXACT_ALARM` if you are an alarm/reminder app

---

### USE_EXACT_ALARM (Android 14+)

**Description**: You need exact alarms without requesting special permission.

**Probable Cause**: Android 14 introduces USE_EXACT_ALARM for alarm apps.

**Solution**:

1. If your app is primarily for alarms/reminders, use:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

2. This is an alternative to `SCHEDULE_EXACT_ALARM` that doesn't require the user to manually grant permission

3. Only use it if your app complies with [allowed use cases](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms)

4. The app must have alarms or reminders as its main functionality

---

### Background Notifications (iOS)

**Description**: Notifications don't work correctly on iOS.

**Probable Cause**: Permissions not requested or incorrect configuration.

**Solution**:

1. Request permissions when starting the app:
```dart
final settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

2. Verify `Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

3. Ensure you have the correct capabilities in Xcode:
   - Push Notifications
   - Background Modes

4. Verify that the user has not disabled notifications in Settings

---

## Common Errors and Solutions

### MissingPluginException

**Description**: Error "MissingPluginException(No implementation found for method...)"

**Probable Cause**: The plugin is not registered correctly or you need a hot restart.

**Solution**:

1. Do a full hot restart (not just hot reload):
```bash
# In the terminal where the app is running
r  # hot reload
R  # HOT RESTART (this is the one you need)
```

2. If it persists, rebuild completely:
```bash
flutter clean
flutter pub get
flutter run
```

3. Verify that the plugin is in `pubspec.yaml`

4. For iOS, reinstall the pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

---

### PlatformException

**Description**: "PlatformException" error with different codes.

**Probable Cause**: Depends on the specific error code.

**Solution**:

1. Read the complete error message and code

2. Common errors:
   - `permission_denied`: Verify permissions
   - `error`: Generic error, review native logs
   - `not_available`: Function not available on this platform

3. For Android, review logcat:
```bash
adb logcat | grep -i flutter
```

4. For iOS, review the Xcode console

5. Ensure you handle these errors gracefully:
```dart
try {
  await somePluginMethod();
} on PlatformException catch (e) {
  print('Error: ${e.code} - ${e.message}');
  // Handle appropriately
}
```

---

### DatabaseException

**Description**: Error when performing database operations.

**Probable Cause**: Invalid query, violated constraint, or corrupted database.

**Solution**:

1. Read the complete error message to identify the problem

2. Common errors:
   - `UNIQUE constraint failed`: Attempting to insert duplicate
   - `no such table`: Table doesn't exist, review migrations
   - `syntax error`: Invalid SQL query

3. Verify the SQL query:
```dart
try {
  await db.query('medications', where: 'id = ?', whereArgs: [id]);
} on DatabaseException catch (e) {
  print('Database error: ${e.toString()}');
}
```

4. Ensure migrations have been executed

5. As a last resort, reset the database

---

### StateError

**Description**: "Bad state: No element" error or similar.

**Probable Cause**: Attempting to access an element that doesn't exist.

**Solution**:

1. Identify the exact line of error in the stack trace

2. Use safe methods:
```dart
// Instead of
final item = list.first;  // Throws StateError if empty

// Use
final item = list.isNotEmpty ? list.first : null;
// or
final item = list.firstOrNull;  // Dart 3.0+
```

3. Always verify before accessing:
```dart
if (list.isNotEmpty) {
  final item = list.first;
  // use item
}
```

4. Use try-catch if necessary:
```dart
try {
  final item = list.single;
} on StateError {
  // Handle case where there isn't exactly one element
}
```

---

### Null Check Operator Used on Null Value

**Description**: Error when using the `!` operator on a null value.

**Probable Cause**: Nullable variable used with `!` when its value is null.

**Solution**:

1. Identify the exact line in the stack trace

2. Verify the value before using `!`:
```dart
// Instead of
final value = nullableValue!;

// Use
if (nullableValue != null) {
  final value = nullableValue;
  // use value
}
```

3. Use `??` operator for default values:
```dart
final value = nullableValue ?? defaultValue;
```

4. Use `?.` operator for safe access:
```dart
final length = nullableString?.length;
```

5. Check why the value is null when it shouldn't be

---

## Logging and Debugging

### How to Enable Logs

**Description**: You need to see detailed logs to debug a problem.

**Solution**:

1. **Flutter logs**:
```bash
flutter run --verbose
```

2. **App-only logs**:
```dart
import 'package:logging/logging.dart';

final logger = Logger('MedicApp');

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}
```

3. **Native Android logs**:
```bash
adb logcat | grep -i flutter
# or to see everything
adb logcat
```

4. **Native iOS logs**:
   - Open Console.app on macOS
   - Select your device/simulator
   - Filter by "flutter" or your bundle identifier

---

### Notification Logs

**Description**: You need to see logs related to notifications.

**Solution**:

1. Add logs in notification code:
```dart
print('Scheduling notification at: $scheduledTime');
await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledTime,
  notificationDetails,
);
print('Notification scheduled successfully');
```

2. List pending notifications:
```dart
final pending = await flutterLocalNotificationsPlugin
    .pendingNotificationRequests();
for (var notification in pending) {
  print('Pending: ${notification.id} - ${notification.title}');
}
```

3. Verify system logs:
   - Android: `adb logcat | grep -i notification`
   - iOS: Console.app with "notification" filter

---

### Database Logs

**Description**: You need to see executed database queries.

**Solution**:

1. Enable logging in sqflite:
```dart
import 'package:sqflite/sqflite.dart';

void main() {
  Sqflite.setDebugModeOn(true);
  runApp(MyApp());
}
```

2. Add logs in your queries:
```dart
print('Executing query: SELECT * FROM medications WHERE id = $id');
final result = await db.query('medications', where: 'id = ?', whereArgs: [id]);
print('Query returned ${result.length} rows');
```

3. Wrapper for automatic logging:
```dart
class LoggedDatabase {
  final Database db;
  LoggedDatabase(this.db);

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    print('Query: $table WHERE $where ARGS $whereArgs');
    final result = await db.query(table, where: where, whereArgs: whereArgs);
    print('Result: ${result.length} rows');
    return result;
  }
}
```

---

### Using the Debugger

**Description**: You need to pause execution and examine state.

**Solution**:

1. **In VS Code**:
   - Place a breakpoint by clicking next to the line number
   - Run in debug mode (F5)
   - When paused, use debug controls

2. **In Android Studio**:
   - Place a breakpoint by clicking in the margin
   - Run Debug (Shift + F9)
   - Use Debug panel to step over/into/out

3. **Programmatic debugger**:
```dart
import 'dart:developer';

void someFunction() {
  debugger();  // Pauses here if debugger is connected
  // code...
}
```

4. **Inspect variables**:
```dart
print('Value: $value');  // Simple logging
debugPrint('Value: $value');  // Logging that respects rate limits
```

---

### App Debug Screen

**Description**: MedicApp includes a useful debug screen.

**Solution**:

1. Access the debug screen from the settings menu

2. Available functions:
   - View database (tables, rows, content)
   - View scheduled notifications
   - View system state
   - Force notification update
   - Clean database
   - View recent logs

3. Use this screen to:
   - Verify data is saved correctly
   - Check pending notifications
   - Identify state issues

4. Only available in debug mode

---

## Resetting the Application

### Clear App Data

**Description**: You need to delete all data without uninstalling.

**Solution**:

**Android**:
```bash
adb shell pm clear com.medicapp.app
```

**iOS**:
- Settings > General > iPhone Storage
- Find MedicApp
- "Delete App" (not "Offload App")

**From the app** (debug only):
- Use the debug screen
- "Reset Database"

---

### Uninstall and Reinstall

**Description**: Complete clean installation.

**Solution**:

**Android**:
```bash
adb uninstall com.medicapp.app
flutter run
```

**iOS**:
```bash
# From device/simulator, long press the icon
# Select "Delete App"
flutter run
```

**From Flutter**:
```bash
flutter clean
rm -rf build/
flutter run
```

---

### Reset Database

**Description**: Delete only the database keeping the app.

**Solution**:

**From code** (debug only):
```dart
await DatabaseHelper.instance.deleteDatabase();
```

**Android - Manually**:
```bash
adb shell
run-as com.medicapp.app
cd databases
rm medicapp.db medicapp.db-shm medicapp.db-wal
exit
```

**iOS - Manually**:
- You need access to the app container
- It's easier to uninstall and reinstall

---

### Clean Flutter Cache

**Description**: Resolve compilation issues related to cache.

**Solution**:

1. Basic cleanup:
```bash
flutter clean
```

2. Complete cleanup:
```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

3. Clean pub cache:
```bash
flutter pub cache repair
```

4. Clean Gradle cache (Android):
```bash
cd android
./gradlew clean cleanBuildCache
rm -rf ~/.gradle/caches/
cd ..
```

5. Clean pods cache (iOS):
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
```

---

## Known Issues

### List of Known Bugs

1. **Notifications don't persist after restart on some Android devices**
   - Affects: Android 12+ with aggressive battery optimization
   - Workaround: Disable battery optimization for MedicApp

2. **Layout overflow on very small screens (<5")**
   - Affects: Devices with width < 320dp
   - Status: Fix planned for v1.1.0

3. **Choppy transition animation on low-end devices**
   - Affects: Devices with <2GB RAM
   - Workaround: Disable animations in settings

4. **Database can grow indefinitely**
   - Affects: Users with lots of history (>1 year)
   - Workaround: Implement periodic cleanup of old history
   - Status: Automatic archiving feature planned

---

### Temporary Workarounds

1. **If notifications don't sound on some devices**:
```dart
// Use maximum importance temporarily
importance: Importance.max,
priority: Priority.high,
```

2. **If there's lag in long lists**:
   - Limit visible history to last 30 days
   - Implement manual pagination

3. **If database locks frequently**:
   - Reduce concurrent operations
   - Use batch transactions for multiple inserts

---

### GitHub Issues

**How to search existing issues**:

1. Go to: https://github.com/your-username/medicapp/issues

2. Use filters:
   - `is:issue is:open` - Open issues
   - `label:bug` - Bugs only
   - `label:enhancement` - Requested features

3. Search by keywords: "notification", "database", etc.

**Before creating a new issue**:
- Search if a similar one already exists
- Check the list of known issues above
- Ensure it's not resolved in the latest version

---

## Getting Help

### Review Documentation

**Available resources**:

1. **Project documentation**:
   - `README.md` - General information and setup
   - `docs/es/ARCHITECTURE.md` - Project architecture
   - `docs/es/CONTRIBUTING.md` - Contribution guide
   - `docs/es/TESTING.md` - Testing guide

2. **Flutter documentation**:
   - [flutter.dev/docs](https://flutter.dev/docs)
   - [api.flutter.dev](https://api.flutter.dev)

3. **Package documentation**:
   - Review pub.dev for each dependency
   - Read the README and changelog of each package

---

### Search in GitHub Issues

**How to search effectively**:

1. Use advanced search:
```
repo:your-username/medicapp is:issue [keywords]
```

2. Search closed issues too:
```
is:issue is:closed notification not working
```

3. Search by labels:
```
label:bug label:android label:notifications
```

4. Search in comments:
```
commenter:username [keywords]
```

---

### Create New Issue with Template

**Before creating an issue**:

1. Confirm it's really a valid bug or feature request
2. Search for duplicate issues
3. Collect all necessary information

**Necessary information**:

**For bugs**:
- Clear problem description
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/videos if applicable
- Environment information (see below)
- Relevant logs

**For features**:
- Feature description
- Use case and benefits
- Implementation proposal (optional)
- Mockups or examples (optional)

**Issue template**:
```markdown
## Description
[Clear and concise problem description]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment Information
- OS: [Android 13 / iOS 16.5]
- Device: [Specific model]
- MedicApp Version: [v1.0.0]
- Flutter Version: [3.24.5]

## Logs
```
[Relevant logs]
```

## Screenshots
[If applicable]

## Additional Information
[Any other context]
```

---

### Necessary Information for Reporting

**Always include**:

1. **App version**:
```dart
// From pubspec.yaml
version: 1.0.0+1
```

2. **Device information**:
```dart
import 'package:device_info_plus/device_info_plus.dart';

final deviceInfo = DeviceInfoPlugin();
if (Platform.isAndroid) {
  final androidInfo = await deviceInfo.androidInfo;
  print('Android ${androidInfo.version.sdkInt}');
  print('Model: ${androidInfo.model}');
}
```

3. **Flutter version**:
```bash
flutter --version
```

4. **Complete logs**:
```bash
flutter run --verbose > logs.txt 2>&1
# Attach logs.txt to the issue
```

5. **Complete stack trace** if there's a crash

6. **Screenshots or videos** showing the problem

---

## Conclusion

This guide covers the most common issues in MedicApp. If you find an issue not listed here:

1. Review the complete project documentation
2. Search in GitHub Issues
3. Ask in repository discussions
4. Create a new issue with all necessary information

**Remember**: Providing detailed information and reproduction steps makes it much easier to resolve your problem quickly.

To contribute improvements to this guide, please open a PR or issue in the repository.

---

**Last updated**: 2025-11-14
**Document version**: 1.0.0
