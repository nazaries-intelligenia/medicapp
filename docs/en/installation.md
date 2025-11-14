# MedicApp Installation Guide

This comprehensive guide will help you set up the development environment and run MedicApp on your system.

---

## 1. Prerequisites

### 1.1 Operating System

MedicApp is compatible with the following operating systems:

- **Android:** 6.0 (API 23) or higher
- **iOS:** 12.0 or higher (requires macOS for development)
- **Development:**
  - Windows 10/11 (64-bit)
  - macOS 10.14 or higher
  - Linux (64-bit)

### 1.2 Flutter SDK

**Required version:** Flutter 3.9.2 or higher

Check if you already have Flutter installed:

```bash
flutter --version
```

If the version is lower than 3.9.2, you will need to upgrade:

```bash
flutter upgrade
```

### 1.3 Dart SDK

The Dart SDK is included with Flutter. The required version is:

- **Dart SDK:** 3.9.2 or higher

### 1.4 Recommended Code Editor

It is recommended to use one of the following editors:

#### Visual Studio Code (Recommended)
- **Download:** https://code.visualstudio.com/
- **Required extensions:**
  - Flutter (Dart Code)
  - Dart

#### Android Studio
- **Download:** https://developer.android.com/studio
- **Required plugins:**
  - Flutter
  - Dart

### 1.5 Git

Required to clone the repository:

- **Git 2.x or higher**
- **Download:** https://git-scm.com/downloads

Verify the installation:

```bash
git --version
```

### 1.6 Additional Platform-Specific Tools

#### For Android development:
- **Android SDK** (included with Android Studio)
- **Android SDK Platform-Tools**
- **Android SDK Build-Tools**
- **Java JDK 11** (included with Android Studio)

#### For iOS development (macOS only):
- **Xcode 13.0 or higher**
- **CocoaPods:**
  ```bash
  sudo gem install cocoapods
  ```

---

## 2. Flutter SDK Installation

### 2.1 Windows

1. Download the Flutter SDK:
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter ZIP file

2. Extract the file to a permanent location (e.g., `C:\src\flutter`)

3. Add Flutter to the PATH environment variables:
   - Search for "Environment Variables" in the start menu
   - Edit the user PATH variable
   - Add the path: `C:\src\flutter\bin`

4. Verify the installation:
   ```bash
   flutter doctor
   ```

### 2.2 macOS

1. Download the Flutter SDK:
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
   unzip flutter_macos_3.9.2-stable.zip
   ```

2. Add Flutter to the PATH by editing `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Reload the configuration:
   ```bash
   source ~/.zshrc
   ```

4. Verify the installation:
   ```bash
   flutter doctor
   ```

### 2.3 Linux

1. Download the Flutter SDK:
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
   tar xf flutter_linux_3.9.2-stable.tar.xz
   ```

2. Add Flutter to the PATH by editing `~/.bashrc` or `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```

3. Reload the configuration:
   ```bash
   source ~/.bashrc
   ```

4. Verify the installation:
   ```bash
   flutter doctor
   ```

### 2.4 Complete Environment Verification

Run the Flutter Doctor command to identify missing components:

```bash
flutter doctor -v
```

Resolve any issues marked with [✗] before continuing.

---

## 3. Repository Cloning

1. Open a terminal in the directory where you want to clone the project

2. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

3. Navigate to the project directory:
   ```bash
   cd medicapp
   ```

4. Verify you are on the correct branch:
   ```bash
   git branch
   ```

---

## 4. Dependencies Installation

### 4.1 Flutter Dependencies

Install all project dependencies:

```bash
flutter pub get
```

This command will install the following main dependencies:

- **sqflite:** ^2.3.0 - Local SQLite database
- **flutter_local_notifications:** ^19.5.0 - Notification system
- **timezone:** ^0.10.1 - Timezone handling
- **intl:** ^0.20.2 - Internationalization
- **android_intent_plus:** ^6.0.0 - Android intents
- **shared_preferences:** ^2.2.2 - Key-value storage
- **file_picker:** ^8.0.0+1 - File picker
- **share_plus:** ^10.1.4 - File sharing
- **path_provider:** ^2.1.5 - System directory access
- **uuid:** ^4.0.0 - Unique ID generation

### 4.2 Platform-Specific Dependencies

#### Android

No additional steps are required. Android dependencies will be downloaded automatically on the first build.

#### iOS (macOS only)

Install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

If you encounter errors, try updating the CocoaPods repository:

```bash
cd ios
pod repo update
pod install
cd ..
```

---

## 5. Environment Configuration

### 5.1 Environment Variables

MedicApp does not require special environment variables to run in development.

### 5.2 Android Permissions

The `android/app/src/main/AndroidManifest.xml` file already includes the necessary permissions:

```xml
<!-- Notification permissions -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Important for Android 13+ (API 33+):**

Users will need to grant notification permission at runtime. The application will automatically request this permission on first launch.

**Exact alarms (Android 12+):**

To schedule precise notifications, users must enable "Alarms and reminders" in the system settings:
- Settings > Apps > MedicApp > Alarms and reminders > Enable

### 5.3 iOS Configuration

#### Permissions in Info.plist

If you are developing for iOS, ensure that `ios/Runner/Info.plist` contains:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### Notification Capabilities

Notifications are automatically configured by the `flutter_local_notifications` plugin.

---

## 6. Running in Development

### 6.1 List Available Devices

Before running the application, list connected devices:

```bash
flutter devices
```

This will show:
- Android devices connected via USB
- Available Android emulators
- iOS simulators (macOS only)
- Available web browsers

### 6.2 Start an Emulator/Simulator

#### Android Emulator:
```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

#### iOS Simulator (macOS only):
```bash
open -a Simulator
```

### 6.3 Run the Application

#### Debug Mode (default):
```bash
flutter run
```

This mode includes:
- Hot reload
- Hot restart
- Full debugging
- Slower performance

**Useful shortcuts during execution:**
- `r` - Hot reload (reloads changed code)
- `R` - Hot restart (restarts the entire application)
- `q` - Exit the application

#### Release Mode:
```bash
flutter run --release
```

This mode includes:
- Optimized performance
- No debugging
- Reduced size

#### Profile Mode:
```bash
flutter run --profile
```

This mode is useful for:
- Performance analysis
- Performance debugging
- Timeline tools

### 6.4 Run on a Specific Device

If you have multiple devices connected:

```bash
flutter run -d <device-id>
```

Example:
```bash
flutter run -d emulator-5554
flutter run -d "iPhone 14 Pro"
```

### 6.5 Run with Detailed Logs

To see more detailed logs:

```bash
flutter run -v
```

---

## 7. Running Tests

MedicApp includes a comprehensive test suite with over 432 tests.

### 7.1 Run All Tests

```bash
flutter test
```

### 7.2 Run a Specific Test

```bash
flutter test test/filename_test.dart
```

Examples:
```bash
flutter test test/settings_screen_test.dart
flutter test test/notification_actions_test.dart
flutter test test/multiple_fasting_prioritization_test.dart
```

### 7.3 Run Tests with Coverage

To generate a code coverage report:

```bash
flutter test --coverage
```

The report will be generated in `coverage/lcov.info`.

### 7.4 View the Coverage Report

To visualize the coverage report in HTML:

```bash
# Install lcov (Linux/macOS)
sudo apt-get install lcov  # Linux
brew install lcov          # macOS

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open the report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### 7.5 Run Tests with Detailed Logs

```bash
flutter test --verbose
```

---

## 8. Production Build

### 8.1 Android

#### APK (for direct distribution):

```bash
flutter build apk --release
```

The APK will be generated in: `build/app/outputs/flutter-apk/app-release.apk`

#### APK Split per ABI (reduces size):

```bash
flutter build apk --split-per-abi --release
```

This generates multiple optimized APKs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

#### App Bundle (for Google Play Store):

```bash
flutter build appbundle --release
```

The App Bundle will be generated in: `build/app/outputs/bundle/release/app-release.aab`

**App Bundle advantages:**
- Optimized download size
- Google Play generates device-specific APKs
- Required for new applications on Play Store

#### Android Signing Configuration

For production builds, you need to configure app signing:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore ~/medicapp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias medicapp
   ```

2. Create the `android/key.properties` file:
   ```properties
   storePassword=<your-password>
   keyPassword=<your-password>
   keyAlias=medicapp
   storeFile=/path/to/medicapp-release-key.jks
   ```

3. Update `android/app/build.gradle.kts` to use the keystore (already configured in the project).

**IMPORTANT:** Do not include `key.properties` or the `.jks` file in version control.

### 8.2 iOS (macOS only)

#### Build for Testing:

```bash
flutter build ios --release
```

#### Build for App Store:

```bash
flutter build ipa --release
```

The IPA file will be generated in: `build/ios/ipa/medicapp.ipa`

#### iOS Signing Configuration

1. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configure the signing team:
   - Select the "Runner" project in the navigator
   - Go to "Signing & Capabilities"
   - Select your Apple development team
   - Configure a unique Bundle Identifier

3. Create a provisioning profile in Apple Developer

4. Archive and distribute from Xcode:
   - Product > Archive
   - Window > Organizer
   - Distribute App

---

## 9. Common Troubleshooting

### 9.1 Dependency Issues

#### Error: "Pub get failed"

**Solution:**
```bash
flutter clean
flutter pub get
```

#### Error: "Version solving failed"

**Solution:**
```bash
# Update Flutter
flutter upgrade

# Clean cache
flutter pub cache repair

# Reinstall dependencies
flutter clean
flutter pub get
```

#### Error: "CocoaPods not installed" (iOS)

**Solution:**
```bash
sudo gem install cocoapods
pod setup
```

### 9.2 Permission Issues

#### Android: Notifications not working

**Check:**
1. The POST_NOTIFICATIONS permission is in AndroidManifest.xml
2. The user has granted notification permissions on Android 13+
3. Exact alarms are enabled in Settings

**Programmatic solution:**
The app requests permissions automatically. If the user denied them:
```dart
// The app includes a button to open settings
// Settings > Permissions > Notifications
```

#### Android: Exact alarms not working

**Symptoms:**
- Notifications arrive late
- Notifications don't arrive at the exact time

**Solution:**
1. Open system Settings
2. Apps > MedicApp > Alarms and reminders
3. Enable the option

The app includes a help button that directs the user to this setting.

### 9.3 Database Issues

#### Error: "Database locked" or "Cannot open database"

**Cause:** The SQLite database is being accessed by multiple processes.

**Solution:**
```bash
# Reinstall the application
flutter clean
flutter run
```

#### Error: Database migrations fail

**Check:**
1. The database version number in `database_helper.dart`
2. Migration scripts are complete

**Solution:**
```bash
# Uninstall the application from the device
adb uninstall com.medicapp.medicapp  # Android
# Reinstall
flutter run
```

### 9.4 Notification Issues

#### Notifications are not rescheduled after reboot

**Check:**
1. The RECEIVE_BOOT_COMPLETED permission is in AndroidManifest.xml
2. The boot receiver is registered

**Solution:**
The `AndroidManifest.xml` file already includes the necessary configuration:
```xml
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>
```

#### Notifications don't make sound/vibration

**Check:**
1. The device volume is not muted
2. "Do not disturb" mode is disabled
3. Vibration permissions are granted

### 9.5 Build Issues

#### Error: "Gradle build failed"

**Solution:**
```bash
# Clean project
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Error: "Execution failed for task ':app:processDebugResources'"

**Cause:** Duplicate resources or conflicts.

**Solution:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Error: SDK version mismatch

**Check:**
1. Flutter version: `flutter --version`
2. The `pubspec.yaml` file requires: `sdk: ^3.9.2`

**Solution:**
```bash
flutter upgrade
flutter doctor
```

### 9.6 Performance Issues

#### The application is slow in debug mode

**Explanation:**
This is normal. Debug mode includes development tools that reduce performance.

**Solution:**
Test in release mode to evaluate actual performance:
```bash
flutter run --release
```

#### Hot reload doesn't work

**Solution:**
```bash
# Restart the application
# In the terminal where you ran 'flutter run', press:
R  # (uppercase) for hot restart
```

### 9.7 Device Connectivity Issues

#### Device doesn't appear in `flutter devices`

**Android:**
```bash
# Check ADB connection
adb devices

# Restart ADB server
adb kill-server
adb start-server

# Check again
flutter devices
```

**iOS:**
```bash
# Check connected devices
instruments -s devices

# Trust the computer from the iOS device
```

---

## 10. Additional Resources

### Official Documentation

- **Flutter:** https://docs.flutter.dev/
- **Dart:** https://dart.dev/guides
- **Material Design 3:** https://m3.material.io/

### Used Plugins

- **sqflite:** https://pub.dev/packages/sqflite
- **flutter_local_notifications:** https://pub.dev/packages/flutter_local_notifications
- **timezone:** https://pub.dev/packages/timezone
- **intl:** https://pub.dev/packages/intl

### Community and Support

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **GitHub Issues:** (Project repository)

---

## 11. Next Steps

Once the installation is complete:

1. **Explore the code:**
   - Review the project structure in `lib/`
   - Examine the tests in `test/`

2. **Run the application:**
   ```bash
   flutter run
   ```

3. **Run the tests:**
   ```bash
   flutter test
   ```

4. **Read the additional documentation:**
   - [README.md](../README.md)
   - [Project Architecture](architecture.md) (if exists)
   - [Contribution Guide](contributing.md) (if exists)

---

## Contact and Help

If you encounter issues not covered in this guide, please:

1. Review existing issues in the repository
2. Run `flutter doctor -v` and share the output
3. Include complete error logs
4. Describe the steps to reproduce the problem

---

**Last updated:** November 2024
**Document version:** 1.0.0
**MedicApp version:** 1.0.0+1
