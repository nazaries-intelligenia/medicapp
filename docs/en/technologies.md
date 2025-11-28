# MedicApp Technology Stack

This document details all technologies, frameworks, libraries, and tools used in MedicApp, including exact versions, justifications for choices, considered alternatives, and trade-offs of each technological decision.

---

## 1. Core Technologies

### Flutter 3.9.2+

**Version used:** `3.9.2+` (SDK compatible up to `3.35.7+`)

**Purpose:**
Flutter is the cross-platform framework that forms the foundation of MedicApp. It enables developing a native application for Android and iOS from a single Dart codebase, ensuring near-native performance and consistent user experience on both platforms.

**Why Flutter was chosen:**

1. **Efficient cross-platform development:** A single codebase for Android and iOS reduces development and maintenance costs by 60-70% compared to dual native development.

2. **Native performance:** Flutter compiles to native ARM code, doesn't use JavaScript bridges like React Native, resulting in smooth animations at 60/120 FPS and instant response times for critical operations like dose recording.

3. **Hot Reload:** Enables rapid iteration during development, visualizing changes in less than 1 second without losing application state. Essential for adjusting notification UI and multi-step flows.

4. **Native Material Design 3:** Complete and up-to-date implementation of Material Design 3 included in the SDK, without needing third-party libraries.

5. **Mature ecosystem:** Pub.dev has over 40,000 packages, including robust solutions for local notifications, SQLite database, and file management.

6. **Integrated testing:** Complete testing framework included in the SDK, with support for unit tests, widget tests, and integration tests. MedicApp achieves 432+ tests with 75-80% coverage.

**Considered alternatives:**

- **React Native:** Discarded due to inferior performance in long lists (dose history), issues with local background notifications, and inconsistent experience across platforms.
- **Kotlin Multiplatform Mobile (KMM):** Discarded due to ecosystem immaturity, need for platform-specific UI code, and steeper learning curve.
- **Native (Swift + Kotlin):** Discarded due to duplication of development effort, higher maintenance costs, and need for two specialized teams.

**Official documentation:** https://flutter.dev

---

### Dart 3.0+

**Version used:** `3.9.2+` (compatible with Flutter 3.9.2+)

**Purpose:**
Dart is the object-oriented programming language developed by Google that runs Flutter. It provides modern syntax, strong typing, null safety, and optimized performance.

**Features used in MedicApp:**

1. **Null Safety:** Type system that eliminates null reference errors at compile time. Critical for reliability of a medical system where a NullPointerException could prevent recording a vital dose.

2. **Async/Await:** Elegant asynchronous programming for database operations, notifications, and file operations without blocking the UI.

3. **Extension Methods:** Allows extending existing classes with custom methods, used for date formatting and model validations.

4. **Records and Pattern Matching (Dart 3.0+):** Immutable data structures for safely returning multiple values from functions.

5. **Strong Type System:** Static typing that detects errors at compile time, essential for critical operations like stock calculation and notification scheduling.

**Why Dart:**

- **Optimized for UI:** Dart was designed specifically for interface development, with garbage collection optimized to avoid pauses during animations.
- **AOT and JIT:** Ahead-of-Time compilation for production (native performance) and Just-in-Time for development (Hot Reload).
- **Familiar syntax:** Similar to Java, C#, JavaScript, reducing the learning curve.
- **Sound Null Safety:** Compile-time guarantee that non-nullable variables will never be null.

**Official documentation:** https://dart.dev

---

### Material Design 3

**Version:** Native implementation in Flutter 3.9.2+

**Purpose:**
Material Design 3 (Material You) is Google's design system that provides components, patterns, and guidelines for creating modern, accessible, and consistent interfaces.

**Implementation in MedicApp:**

```dart
useMaterial3: true
```

**Components used:**

1. **Dynamic Color Scheme:** Seed-based color system (`seedColor: Color(0xFF006B5A)` for light theme, `Color(0xFF00A894)` for dark theme) that automatically generates 30+ harmonic shades.

2. **FilledButton, OutlinedButton, TextButton:** Buttons with visual states (hover, pressed, disabled) and increased sizes (52dp minimum height) for accessibility.

3. **Card with adaptive elevation:** Cards with rounded corners (16dp) and subtle shadows for visual hierarchy.

4. **NavigationBar:** Bottom navigation bar with animated selection indicators and support for navigation between 3-5 main destinations.

5. **Extended FloatingActionButton:** FAB with descriptive text for primary action (add medication).

6. **ModalBottomSheet:** Modal sheets for contextual actions like quick dose recording.

7. **SnackBar with actions:** Temporary feedback for completed operations (dose recorded, medication added).

**Custom themes:**

MedicApp implements two complete themes (light and dark) with accessible typography:

- **Increased font sizes:** `titleLarge: 26sp`, `bodyLarge: 19sp` (higher than standard 22sp and 16sp respectively).
- **Enhanced contrast:** Text colors with 87% opacity on backgrounds to meet WCAG AA.
- **Large buttons:** 52dp minimum height (vs 40dp standard) to facilitate touch on mobile devices.

**Why Material Design 3:**

- **Integrated accessibility:** Components designed with screen reader support, minimum touch sizes, and WCAG contrast ratios.
- **Consistency with Android ecosystem:** Familiar appearance for Android 12+ users.
- **Flexible customization:** Design token system that allows adapting colors, typography, and shapes while maintaining consistency.
- **Automatic dark mode:** Native support for dark theme based on system configuration.

**Official documentation:** https://m3.material.io

---

## 2. Database and Persistence

### sqflite ^2.3.0

**Version used:** `^2.3.0` (compatible with `2.3.0` up to `< 3.0.0`)

**Purpose:**
sqflite is the SQLite plugin for Flutter that provides access to a local, relational, and transactional SQL database. MedicApp uses SQLite as the primary storage for all medication data, persons, schedule configurations, and dose history.

**MedicApp database architecture:**

```
medicapp.db
├── medications (main table)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   ├── type (TEXT)
│   ├── frequency (TEXT)
│   ├── times (TEXT JSON array)
│   ├── doses (TEXT JSON array)
│   ├── stock (REAL)
│   ├── fasting_before (INTEGER boolean)
│   ├── fasting_duration (INTEGER minutes)
│   └── ...
├── persons (V19+)
│   ├── id (TEXT PRIMARY KEY)
│   ├── name (TEXT)
│   └── is_default (INTEGER boolean)
├── person_medications (N:M relationship table)
│   ├── person_id (TEXT)
│   ├── medication_id (TEXT)
│   ├── custom_times (TEXT JSON)
│   ├── custom_doses (TEXT JSON)
│   └── PRIMARY KEY (person_id, medication_id)
└── dose_history
    ├── id (TEXT PRIMARY KEY)
    ├── medication_id (TEXT)
    ├── person_id (TEXT)
    ├── timestamp (INTEGER)
    ├── dose_amount (REAL)
    └── scheduled_time (TEXT)
```

**Critical operations:**

1. **ACID Transactions:** Atomicity guarantee for complex operations like dose recording + stock deduction + notification scheduling.

2. **Relational queries:** JOINs between `medications`, `persons`, and `person_medications` to get personalized configurations per user.

3. **Optimized indexes:** Indexes on `person_id` and `medication_id` in relationship tables for fast O(log n) queries.

4. **Versioned migrations:** Schema migration system from V1 to V19+ with data preservation.

**Why SQLite:**

1. **ACID compliance:** Transactional guarantees critical for medical data where integrity is fundamental.

2. **Complex SQL queries:** Ability to perform JOINs, aggregations, and subqueries for reports and advanced filters.

3. **Proven performance:** SQLite is the world's most deployed database, with 20+ years of optimizations.

4. **Zero-configuration:** Doesn't require server, configuration, or administration. The database is a single portable file.

5. **Simple export/import:** The `.db` file can be copied directly for backups or transfers between devices.

6. **Unlimited size:** SQLite supports databases up to 281 terabytes, more than enough for decades of dose history.

**Comparison with alternatives:**

| Feature | SQLite (sqflite) | Hive | Isar | Drift |
|---------|------------------|------|------|-------|
| **Data model** | Relational SQL | NoSQL Key-Value | NoSQL Document | Relational SQL |
| **Query language** | Standard SQL | Dart API | Dart Query Builder | SQL + Dart |
| **ACID transactions** | ✅ Complete | ❌ Limited | ✅ Yes | ✅ Yes |
| **Migrations** | ✅ Robust manual | ⚠️ Basic manual | ⚠️ Semi-automatic | ✅ Automatic |
| **Read performance** | ⚡ Excellent | ⚡⚡ Superior | ⚡⚡ Superior | ⚡ Excellent |
| **Write performance** | ⚡ Very good | ⚡⚡ Excellent | ⚡⚡ Excellent | ⚡ Very good |
| **Disk size** | ⚠️ Larger | ✅ Compact | ✅ Very compact | ⚠️ Larger |
| **N:M relationships** | ✅ Native | ❌ Manual | ⚠️ References | ✅ Native |
| **Maturity** | ✅ 20+ years | ⚠️ 4 years | ⚠️ 3 years | ✅ 5+ years |
| **Portability** | ✅ Universal | ⚠️ Proprietary | ⚠️ Proprietary | ⚠️ Flutter-only |
| **External tools** | ✅ DB Browser, CLI | ❌ Limited | ❌ Limited | ❌ None |

**Justification for SQLite over alternatives:**

- **Hive:** Discarded due to lack of robust support for N:M relationships (multi-person architecture), absence of complete ACID transactions, and difficulty performing complex queries with JOINs.

- **Isar:** Discarded despite excellent performance due to immaturity (released in 2022), proprietary format that makes debugging with standard tools difficult, and limitations in complex relational queries.

- **Drift:** Seriously considered but discarded due to higher complexity (requires code generation), larger resulting application size, and less flexibility in migrations compared to direct SQL.

**SQLite trade-offs:**

- ✅ **Pros:** Proven stability, standard SQL, external tools, native relationships, trivial export.
- ❌ **Cons:** Slightly inferior performance to Hive/Isar in massive operations, larger file size, manual SQL boilerplate.

**Decision:** For MedicApp, the need for robust N:M relationships, complex migrations from V1 to V19+, and debugging capability with standard SQL tools amply justifies using SQLite over faster but less mature NoSQL alternatives.

**Official documentation:** https://pub.dev/packages/sqflite

---

### sqflite_common_ffi ^2.3.0

**Version used:** `^2.3.0` (dev_dependencies)

**Purpose:**
FFI (Foreign Function Interface) implementation of sqflite that allows running database tests in desktop/VM environments without needing Android/iOS emulators.

**Use in MedicApp:**

```dart
// test/helpers/database_test_helper.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
```

**Why it's necessary:**

- **60x faster tests:** Database tests run in local VM instead of Android emulators, reducing time from 120s to 2s for the complete suite.
- **CI/CD without emulators:** GitHub Actions can run tests without setting up emulators, simplifying pipelines.
- **Improved debugging:** Test `.db` files are directly accessible from the host file system.

**Official documentation:** https://pub.dev/packages/sqflite_common_ffi

---

### path ^1.8.3

**Version used:** `^1.8.3`

**Purpose:**
Cross-platform file path manipulation library that abstracts differences between file systems (Windows: `\`, Unix: `/`).

**Use in MedicApp:**

```dart
import 'package:path/path.dart' as path;

final dbPath = path.join(await getDatabasesPath(), 'medicapp.db');
```

**Official documentation:** https://pub.dev/packages/path

---

### path_provider ^2.1.5

**Version used:** `^2.1.5`

**Purpose:**
Plugin that provides access to operating system-specific directories in a cross-platform way (documents, cache, application support).

**Use in MedicApp:**

```dart
import 'package:path_provider/path_provider.dart';

// Get database directory
final dbDirectory = await getDatabasesPath(); // Android: /data/data/com.medicapp/databases/

// Get directory for exports
final documentsDirectory = await getApplicationDocumentsDirectory();
```

**Directories used:**

1. **getDatabasesPath():** For main `medicapp.db` file.
2. **getApplicationDocumentsDirectory():** For database exports that users can share.
3. **getTemporaryDirectory():** For temporary files during import.

**Official documentation:** https://pub.dev/packages/path_provider

---

## 3. Notifications

### flutter_local_notifications ^19.5.0

**Version used:** `^19.5.0`

**Purpose:**
Complete local notifications system (no server required) for Flutter, with support for scheduled, repeating, action-based, and platform-customized notifications.

**Implementation in MedicApp:**

MedicApp uses a sophisticated notification system that manages three types of notifications:

1. **Dose reminder notifications:**
   - Scheduled with exact times configured by the user.
   - Include title with person name (in multi-person) and dose details.
   - Support for quick actions: "Take", "Postpone", "Skip" (discarded in V20+ due to type limitations).
   - Custom sound and high priority channel on Android.

2. **Advanced dose notifications:**
   - Detect when a dose is taken before its scheduled time.
   - Automatically update the next notification if applicable.
   - Cancel obsolete notifications from the advanced schedule.

3. **End of fasting notifications:**
   - Ongoing (permanent) notification during fasting period with countdown.
   - Automatically canceled when fasting ends or when manually closed.
   - Includes visual progress (Android) and finish time.

**Platform-specific configuration:**

**Android:**
```dart
AndroidInitializationSettings('app_icon')
AndroidNotificationDetails(
  'medication_reminders',
  'Medication Reminders',
  importance: Importance.high,
  priority: Priority.high,
  showWhen: true,
  enableLights: true,
  enableVibration: true,
  playSound: true,
)
```

**iOS:**
```dart
DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
)
```

**Advanced features used:**

1. **Precise scheduling:** Notifications scheduled with second precision using `timezone`.
2. **Notification channels (Android 8+):** 3 separate channels for reminders, fasting, and system.
3. **Custom payload:** JSON data in payload to identify medication and person.
4. **Interaction callbacks:** Callbacks when user taps the notification.
5. **Permission management:** Request and verification of permissions on Android 13+ (Tiramisu).

**Limits and optimizations:**

- **Limit of 500 simultaneously scheduled notifications** (Android system limitation).
- MedicApp manages automatic prioritization when this limit is exceeded:
  - Prioritizes next 7 days.
  - Discards notifications for inactive medications.
  - Reorganizes when medications are added/removed.

**Why flutter_local_notifications:**

1. **Local vs remote notifications:** MedicApp doesn't require a backend server, so local notifications are the correct architecture.

2. **Complete functionality:** Support for scheduling, repetition, actions, platform customization, and permission management.

3. **Proven maturity:** Package with 5+ years of development, 3000+ stars on GitHub, used in production by thousands of applications.

4. **Exhaustive documentation:** Detailed examples for all common use cases.

**Why NOT Firebase Cloud Messaging (FCM):**

| Criterion | flutter_local_notifications | Firebase Cloud Messaging |
|-----------|----------------------------|--------------------------|
| **Requires server** | ❌ No | ✅ Yes (Firebase) |
| **Requires connection** | ❌ No | ✅ Yes (internet) |
| **Privacy** | ✅ All data local | ⚠️ Tokens in Firebase |
| **Latency** | ✅ Instant | ⚠️ Depends on network |
| **Cost** | ✅ Free | ⚠️ Limited free quota |
| **Setup complexity** | ✅ Minimal | ❌ High (Firebase, server) |
| **Works offline** | ✅ Always | ❌ No |
| **Precise scheduling** | ✅ Yes | ❌ No (approximate) |

**Decision:** For a medication management application where privacy is critical, doses must be notified punctually even without connection, and there's no need for server-client communication, local notifications are the correct and simpler architecture.

**Comparison with alternatives:**

- **awesome_notifications:** Discarded due to lower adoption (less mature), more complex APIs, and reported issues with scheduled notifications on Android 12+.

- **local_notifications (native):** Discarded for requiring platform-specific code (Kotlin/Swift), duplicating development effort.

**Official documentation:** https://pub.dev/packages/flutter_local_notifications

---

### timezone ^0.10.1

**Version used:** `^0.10.1`

**Purpose:**
Time zone management library that allows scheduling notifications at specific times of day considering daylight saving time (DST) changes and conversions between time zones.

**Use in MedicApp:**

```dart
import 'package:timezone/timezone.dart' as tz;

// Initialization
await tz.initializeTimeZones();
final location = tz.getLocation('Europe/Madrid');
tz.setLocalLocation(location);

// Schedule notification at 08:00 local time
final scheduledDate = tz.TZDateTime(
  location,
  now.year,
  now.month,
  now.day,
  8, // hour
  0, // minutes
);

await flutterLocalNotificationsPlugin.zonedSchedule(
  id,
  title,
  body,
  scheduledDate,
  notificationDetails,
  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
```

**Why it's critical:**

- **Daylight saving time:** Without `timezone`, notifications would be offset by 1 hour during DST changes.
- **Consistency:** Users configure schedules in their local time zone, which must be respected regardless of device time zone changes.
- **Precision:** `zonedSchedule` guarantees notifications at the exact specified moment.

**Official documentation:** https://pub.dev/packages/timezone

---

### android_intent_plus ^6.0.0

**Version used:** `^6.0.0`

**Purpose:**
Plugin for launching Android Intents from Flutter, specifically used to open notification settings when permissions are disabled.

**Use in MedicApp:**

```dart
import 'package:android_intent_plus/android_intent.dart';

// Open app notification settings
final intent = AndroidIntent(
  action: 'android.settings.APP_NOTIFICATION_SETTINGS',
  arguments: {
    'android.provider.extra.APP_PACKAGE': packageName,
  },
);
await intent.launch();
```

**Use cases:**

1. **Guide the user:** When notification permissions are disabled, an explanatory dialog is shown with an "Open Settings" button that launches directly to MedicApp's notification settings screen.

2. **Improved UX:** Prevents the user from having to manually navigate: Settings > Applications > MedicApp > Notifications.

**Official documentation:** https://pub.dev/packages/android_intent_plus

---

### device_info_plus ^11.1.0

**Version used:** `^11.1.0`

**Purpose:**
Plugin to obtain device information, including the Android SDK version, device model, and other platform details. In MedicApp it is used to detect the Android version and enable/disable specific functionalities based on the operating system version.

**Usage in MedicApp:**

```dart
import 'package:device_info_plus/device_info_plus.dart';

// Check if the device supports notification channel settings
static Future<bool> canOpenNotificationSettings() async {
  if (!PlatformHelper.isAndroid) {
    return false;
  }
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  // Android 8.0 (API 26) is the minimum for notification channel settings
  return androidInfo.version.sdkInt >= 26;
}
```

**Use cases:**

1. **Android version detection:** Allows verifying if the device runs Android 8.0+ (API 26) to show or hide the notification sound configuration option, which is only available on versions that support notification channels.

2. **Conditional features:** Enables or disables specific UI features based on device capabilities.

**Official documentation:** https://pub.dev/packages/device_info_plus

---

## 4. Localization (i18n)

### flutter_localizations (SDK)

**Version used:** Included in Flutter SDK

**Purpose:**
Official Flutter package that provides localizations for Material and Cupertino widgets in 85+ languages, including translations of standard components (dialog buttons, pickers, etc.).

**Use in MedicApp:**

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate, // Material widgets
    GlobalWidgetsLocalizations.delegate,  // Generic widgets
    GlobalCupertinoLocalizations.delegate, // Cupertino (iOS)
  ],
  supportedLocales: [
    Locale('es'), // Spanish
    Locale('en'), // English
    Locale('de'), // German
    // ... 8 languages total
  ],
)
```

**What it provides:**

- Standard button translations: "OK", "Cancel", "Accept".
- Localized date and time formats: "15/11/2025" (es) vs "11/15/2025" (en).
- Date/time pickers in local language.
- Day and month names.

**Official documentation:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization

---

### intl ^0.20.2

**Version used:** `^0.20.2`

**Purpose:**
Dart internationalization library that provides date/number formatting, pluralization, and message translation through ARB files.

**Use in MedicApp:**

```dart
import 'package:intl/intl.dart';

// Date formatting
final formatted = DateFormat('dd/MM/yyyy').format(DateTime.now());

// Number formatting
final stock = NumberFormat.decimalPattern().format(25.5);

// Pluralization (from ARB)
// "{count, plural, =1{1 pill} other{{count} pills}}"
```

**Use cases:**

1. **Date formatting:** Display treatment start/end dates, dose history.
2. **Number formatting:** Display stock with decimals according to regional configuration.
3. **Smart pluralization:** Messages that change according to quantity ("1 pill" vs "5 pills").

**Official documentation:** https://pub.dev/packages/intl

---

### ARB System (Application Resource Bundle)

**Format used:** ARB (based on JSON)

**Purpose:**
Application resource file system that allows defining string translations in JSON format with support for placeholders, pluralization, and metadata.

**Configuration in MedicApp:**

**`l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

**File structure:**
```
lib/l10n/
├── app_es.arb (main template, Spanish)
├── app_en.arb (English translations)
├── app_de.arb (German translations)
├── app_fr.arb (French translations)
├── app_it.arb (Italian translations)
├── app_ca.arb (Catalan translations)
├── app_eu.arb (Basque translations)
└── app_gl.arb (Galician translations)
```

**ARB example with advanced features:**

**`app_es.arb`:**
```json
{
  "@@locale": "es",

  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Application title"
  },

  "medicationDose": "{count, plural, =1{1 {unit}} other{{count} {unit}}}",
  "@medicationDose": {
    "description": "Medication dose with pluralization",
    "placeholders": {
      "count": {
        "type": "num",
        "format": "decimalPattern"
      },
      "unit": {
        "type": "String"
      }
    }
  },

  "stockRemaining": "Remaining {stock} {unit, plural, =1{unit} other{units}}",
  "@stockRemaining": {
    "placeholders": {
      "stock": {"type": "num"},
      "unit": {"type": "String"}
    }
  }
}
```

**Automatic generation:**

Flutter automatically generates the `AppLocalizations` class with typed methods:

```dart
// Generated code in .dart_tool/flutter_gen/gen_l10n/app_localizations.dart
class AppLocalizations {
  String get appTitle => 'MedicApp';

  String medicationDose(num count, String unit) {
    return Intl.plural(
      count,
      one: '1 $unit',
      other: '$count $unit',
      name: 'medicationDose',
      args: [count, unit],
    );
  }
}

// Use in code
Text(AppLocalizations.of(context)!.medicationDose(2.5, 'pills'))
// Result: "2.5 pills"
```

**Advantages of ARB system:**

1. **Strong typing:** Translation errors detected at compile time.
2. **Safe placeholders:** Impossible to forget required parameters.
3. **CLDR pluralization:** Support for 200+ language pluralization rules according to Unicode CLDR.
4. **Useful metadata:** Descriptions and context for translators.
5. **Translation tools:** Compatible with Google Translator Toolkit, Crowdin, Lokalise.

**Translation process in MedicApp:**

1. Define strings in `app_es.arb` (template).
2. Run `flutter gen-l10n` to generate Dart code.
3. Translate to other languages by copying and modifying ARB files.
4. Review `untranslated_messages.json` to detect missing strings.

**Official documentation:** https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages

---

### 8 Supported Languages

MedicApp is fully translated into 8 languages:

| Code | Language | Main region | Speakers (millions) |
|------|----------|-------------|---------------------|
| `es` | Español | Spain, Latin America | 500M+ |
| `en` | English | Global | 1,500M+ |
| `de` | Deutsch | Germany, Austria, Switzerland | 130M+ |
| `fr` | Français | France, Canada, Africa | 300M+ |
| `it` | Italiano | Italy, Switzerland | 85M+ |
| `ca` | Català | Catalonia, Valencia, Balearics | 10M+ |
| `eu` | Euskara | Basque Country | 750K+ |
| `gl` | Galego | Galicia | 2.5M+ |

**Total coverage:** ~2,500 million potential speakers

**Total strings:** ~450 translations per language

**Translation quality:**
- Spanish: Native (template)
- English: Native
- German, French, Italian: Professional
- Catalan, Basque, Galician: Native (co-official languages of Spain)

**Justification for included languages:**

- **Spanish:** Developer's primary language and initial target market (Spain, Latin America).
- **English:** Universal language for global reach.
- **German, French, Italian:** Main Western European languages, markets with high demand for health apps.
- **Catalan, Basque, Galician:** Co-official languages in Spain (regions with 17M+ inhabitants), improves accessibility for elderly users more comfortable in their native language.

---

## 5. State Management

### No state management library (Vanilla Flutter)

**Decision:** MedicApp **DOES NOT use** any state management library (Provider, Riverpod, BLoC, Redux, GetX).

**Why state management is NOT used:**

1. **Database-based architecture:** The true state of the application resides in SQLite, not in memory. Each screen queries the database directly to get updated data.

2. **StatefulWidget + setState is sufficient:** For a medium-complexity application like MedicApp, `setState()` and `StatefulWidget` provide more than adequate local state management.

3. **Simplicity over frameworks:** Avoiding unnecessary dependencies reduces complexity, application size, and potential breaking changes in updates.

4. **Database streams:** For reactive data, `StreamBuilder` is used with direct streams from `DatabaseHelper`:

```dart
StreamBuilder<List<Medication>>(
  stream: DatabaseHelper.instance.watchMedications(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final medications = snapshot.data!;
    return ListView.builder(...);
  },
)
```

5. **Navigation with callbacks:** For communication between screens, traditional Flutter callbacks are used:

```dart
// Main screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddMedicationScreen(
      onMedicationAdded: () {
        setState(() {}); // Refresh list
      },
    ),
  ),
);
```

**Comparison with alternatives:**

| Solution | MedicApp (Vanilla) | Provider | BLoC | Riverpod |
|----------|-------------------|----------|------|----------|
| **Additional lines of code** | 0 | ~500 | ~1,500 | ~800 |
| **External dependencies** | 0 | 1 | 2+ | 2+ |
| **Learning curve** | ✅ Minimal | ⚠️ Medium | ❌ High | ⚠️ Medium-High |
| **Boilerplate** | ✅ None | ⚠️ Medium | ❌ High | ⚠️ Medium |
| **Testing** | ✅ Direct | ⚠️ Requires mocks | ⚠️ Requires setup | ⚠️ Requires setup |
| **Performance** | ✅ Excellent | ⚠️ Good | ⚠️ Good | ⚠️ Good |
| **APK size** | ✅ Minimal | +50KB | +150KB | +100KB |

**Why NOT Provider:**

- **Unnecessary:** Provider is designed to share state between deeply nested widgets. MedicApp obtains data from the database in each root screen, without needing to pass state downward.
- **Added complexity:** Requires `ChangeNotifier`, `MultiProvider`, context-awareness, and understanding the widget tree.
- **Over-engineering:** For an application with ~15 screens and state in database, Provider would be using a pneumatic hammer to drive a nail.

**Why NOT BLoC:**

- **Extreme complexity:** BLoC (Business Logic Component) requires understanding streams, sinks, events, states, and layered architecture.
- **Massive boilerplate:** Each feature requires 4-5 files (bloc, event, state, repository, test).
- **Over-engineering:** BLoC is excellent for enterprise applications with complex business logic and multiple developers. MedicApp is a medium-complexity application where simplicity is a priority.

**Why NOT Riverpod:**

- **Less mature:** Riverpod is relatively new (2020) compared to Provider (2018) and BLoC (2018).
- **Similar complexity to Provider:** Requires understanding providers, autoDispose, family, and declarative architecture.
- **No clear advantage:** For MedicApp, Riverpod offers no significant benefits over the current architecture.

**Why NOT Redux:**

- **Massive complexity:** Redux requires actions, reducers, middleware, store, and strict immutability.
- **Unsustainable boilerplate:** Even simple operations require multiple files and hundreds of lines of code.
- **Total overkill:** Redux is designed for SPA web applications with complex frontend state. MedicApp has state in SQLite, not in memory.

**Cases where state management WOULD be needed:**

- **Complex shared state in memory:** If multiple screens needed to share large objects in memory (doesn't apply to MedicApp).
- **Global authentication state:** If there were login/sessions (MedicApp is local, no accounts).
- **Real-time synchronization:** If there were real-time multi-user collaboration (doesn't apply).
- **Complex business logic:** If there were heavy calculations requiring memory caching (MedicApp does simple stock and date calculations).

**Final decision:**

For MedicApp, the **Database as Single Source of Truth + StatefulWidget + setState** architecture is the correct solution. It's simple, straightforward, easy to understand and maintain, and doesn't introduce unnecessary complexity. Adding Provider, BLoC, or Riverpod would be pure over-engineering without tangible benefits.

---

## 6. Logging and Debugging

### logger ^2.0.0

**Version used:** `^2.0.0` (compatible with `2.0.0` up to `< 3.0.0`)

**Purpose:**
logger is a professional logging library for Dart that provides a structured, configurable logging system with multiple severity levels. It replaces the use of `print()` statements with a robust logging system appropriate for production applications.

**Logging levels:**

MedicApp uses 6 log levels according to their severity:

1. **VERBOSE (trace):** Very detailed diagnostic information (development)
2. **DEBUG:** Information useful during development
3. **INFO:** Informational messages about application flow
4. **WARNING:** Warnings that don't prevent operation
5. **ERROR:** Errors requiring attention but the app can recover
6. **WTF (What a Terrible Failure):** Grave errors that shouldn't occur

**Implementation in MedicApp:**

**`lib/services/logger_service.dart`:**
```dart
import 'package:logger/logger.dart';

class LoggerService {
  LoggerService._();

  static Logger? _logger;
  static bool _isTestMode = false;

  static Logger get instance {
    _logger ??= _createLogger();
    return _logger!;
  }

  static Logger _createLogger() {
    return Logger(
      filter: _LogFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
      output: ConsoleOutput(),
    );
  }

  // Convenience methods
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.i(message, error: error, stackTrace: stackTrace);
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTestMode) {
      instance.e(message, error: error, stackTrace: stackTrace);
    }
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (LoggerService.isTestMode) return false;
    if (kReleaseMode) {
      return event.level.index >= Level.warning.index;
    }
    return true;
  }
}
```

**Usage in code:**

```dart
// BEFORE (with print)
print('Scheduling notification for ${medication.name}');
print('Error saving: $e');

// AFTER (with LoggerService)
LoggerService.info('Scheduling notification for ${medication.name}');
LoggerService.error('Error saving', e);
```

**Usage examples by level:**

```dart
// Normal flow information
LoggerService.info('Medication created: ${medication.name}');

// Debugging during development
LoggerService.debug('Query executed: SELECT * FROM medications WHERE id = ${id}');

// Non-critical warnings
LoggerService.warning('Low stock for ${medication.name}: ${stock} units');

// Recoverable errors
LoggerService.error('Error scheduling notification', e, stackTrace);

// Grave errors
LoggerService.wtf('Inconsistent state: medication without ID', error);
```

**Features used:**

1. **PrettyPrinter:** Readable format with colors, emojis, and timestamps:
```
💡 INFO 14:23:45 | Medication created: Ibuprofen
⚠️  WARNING 14:24:10 | Low stock: Paracetamol
❌ ERROR 14:25:33 | Error saving
```

2. **Automatic filtering:** In release mode, only shows warnings and errors:
```dart
// Debug mode: shows all logs
// Release mode: only WARNING, ERROR, WTF
```

3. **Test mode:** Suppresses all logs during testing:
```dart
LoggerService.enableTestMode();  // In test setUp
```

4. **Automatic stack traces:** For errors, prints complete stack trace:
```dart
LoggerService.error('Database error', e, stackTrace);
// Output includes formatted stack trace
```

5. **No BuildContext dependency:** Can be used anywhere in code:
```dart
// In services
class NotificationService {
  void scheduleNotification() {
    LoggerService.info('Scheduling notification...');
  }
}

// In models
class Medication {
  void validate() {
    if (stock < 0) {
      LoggerService.warning('Negative stock: $stock');
    }
  }
}
```

**Why logger:**

1. **Professional:** Designed for production, not just development
2. **Configurable:** Different levels, filters, formats
3. **Performance:** Intelligent filtering in release mode
4. **Improved debugging:** Colors, emojis, timestamps, stack traces
5. **Testing friendly:** Test mode to suppress logs
6. **Zero configuration:** Works out-of-the-box with sensible defaults

**Migration from print() to LoggerService:**

MedicApp migrated **279 print() statements** in **15 files** to LoggerService:

| File | Prints migrated | Predominant level |
|------|----------------|-------------------|
| notification_service.dart | 112 | info, error, warning |
| database_helper.dart | 26 | debug, info, error |
| fasting_notification_scheduler.dart | 32 | info, warning |
| daily_notification_scheduler.dart | 25 | info, warning |
| dose_calculation_service.dart | 25 | debug, info |
| medication_list_viewmodel.dart | 7 | info, error |
| **Total** | **279** | - |

**Comparison with alternatives:**

| Feature | logger | print() | logging package | custom solution |
|---------|--------|---------|-----------------|-----------------|
| **Log levels** | ✅ 6 levels | ❌ None | ✅ 7 levels | ⚠️ Manual |
| **Colors** | ✅ Yes | ❌ No | ⚠️ Basic | ⚠️ Manual |
| **Timestamps** | ✅ Configurable | ❌ No | ✅ Yes | ⚠️ Manual |
| **Filtering** | ✅ Automatic | ❌ No | ✅ Manual | ⚠️ Manual |
| **Stack traces** | ✅ Automatic | ❌ Manual | ⚠️ Manual | ⚠️ Manual |
| **Pretty print** | ✅ Excellent | ❌ Basic | ⚠️ Basic | ⚠️ Manual |
| **Size** | ✅ ~50KB | ✅ 0KB | ⚠️ ~100KB | ✅ Variable |

**Why NOT print():**

- ❌ No differentiation between debug, info, warning, error
- ❌ No timestamps, makes debugging difficult
- ❌ No colors, difficult to read in console
- ❌ Can't filter in production
- ❌ Not appropriate for professional applications

**Why NOT logging package (dart:logging):**

- ⚠️ More complex to configure
- ⚠️ Pretty printing requires custom implementation
- ⚠️ Less ergonomic (more boilerplate)
- ⚠️ No colors/emojis by default

**Trade-offs of logger:**

- ✅ **Pros:** Simple setup, beautiful output, intelligent filtering, appropriate for production
- ❌ **Cons:** Adds ~50KB to APK (irrelevant), one more dependency

**Decision:** For MedicApp, where debugging and monitoring are critical (it's a medical app), logger provides the perfect balance between simplicity and professional functionality. The 50KB addition is insignificant compared to the debugging and maintainability benefits.

**Official documentation:** https://pub.dev/packages/logger

---

## 7. Local Storage

### shared_preferences ^2.2.2

**Version used:** `^2.2.2`

**Purpose:**
Persistent key-value storage for simple user preferences, application settings, and non-critical states. Uses `SharedPreferences` on Android and `UserDefaults` on iOS.

**Use in MedicApp:**

MedicApp uses `shared_preferences` to store lightweight settings that don't justify a SQL table:

**`lib/services/preferences_service.dart`:**
```dart
class PreferencesService {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyNotificationsEnabled = 'notifications_enabled';

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_keyThemeMode);
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == modeStr,
      orElse: () => ThemeMode.system,
    );
  }
}
```

**Stored data:**

1. **Application theme:**
   - Key: `theme_mode`
   - Values: `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Use: Persist theme preference between sessions.

2. **Selected language:**
   - Key: `locale`
   - Values: `es`, `en`, `de`, `fr`, `it`, `ca`, `eu`, `gl`
   - Use: Remember user-chosen language (override system language).

3. **Permission status:**
   - Key: `notifications_enabled`
   - Values: `true`, `false`
   - Use: Local cache of permission status to avoid repeated native calls.

4. **First run:**
   - Key: `first_run`
   - Values: `true`, `false`
   - Use: Show tutorial/onboarding only on first run.

**Why shared_preferences and not SQLite:**

- **Performance:** Instant O(1) access for simple values vs SQL query with overhead.
- **Simplicity:** Trivial API (`getString`, `setString`) vs preparing SQL queries.
- **Purpose:** User preferences vs relational data.
- **Size:** Small values (< 1KB) vs complex records.

**Limitations of shared_preferences:**

- ❌ Doesn't support relationships, JOINs, transactions.
- ❌ Not appropriate for data >100KB.
- ❌ Asynchronous access (requires `await`).
- ❌ Only primitive types (String, int, double, bool, List<String>).

**Trade-offs:**

- ✅ **Pros:** Simple API, excellent performance, correct purpose for preferences.
- ❌ **Cons:** Not appropriate for structured or voluminous data.

**Official documentation:** https://pub.dev/packages/shared_preferences

---

## 8. File Operations

### file_picker ^8.0.0+1

**Version used:** `^8.0.0+1`

**Purpose:**
Cross-platform plugin for selecting files from the device file system, with support for multiple platforms (Android, iOS, desktop, web).

**Use in MedicApp:**

MedicApp uses `file_picker` exclusively for the **database import** function, allowing users to restore a backup or migrate data from another device.

**Implementation:**

```dart
import 'package:file_picker/file_picker.dart';

Future<void> importDatabase() async {
  // Open file picker
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
    dialogTitle: 'Select database file',
  );

  if (result == null) return; // User canceled

  final file = result.files.single;
  final path = file.path!;

  // Validate and copy file
  await DatabaseHelper.instance.importDatabase(path);

  // Reload application
  setState(() {});
}
```

**Features used:**

1. **Extension filter:** Only allows selecting `.db` files to avoid user errors.
2. **Custom title:** Shows descriptive message in system dialog.
3. **Full path:** Gets absolute file path to copy it to the app location.

**Considered alternatives:**

- **image_picker:** Discarded because it's designed specifically for images/videos, not generic files.
- **Native code:** Discarded because it would require implementing `ActivityResultLauncher` (Android) and `UIDocumentPickerViewController` (iOS) manually.

**Official documentation:** https://pub.dev/packages/file_picker

---

### share_plus ^10.1.4

**Version used:** `^10.1.4`

**Purpose:**
Cross-platform plugin for sharing files, text, and URLs using the operating system's native share sheet (Android Share Sheet, iOS Share Sheet).

**Use in MedicApp:**

MedicApp uses `share_plus` for the **database export** function, allowing users to create a backup and share it via email, cloud storage (Drive, Dropbox), Bluetooth, or save it to local files.

**Implementation:**

```dart
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> exportDatabase() async {
  // Get current database path
  final dbPath = await DatabaseHelper.instance.getDatabasePath();

  // Create temporary copy in shareable directory
  final tempDir = await getTemporaryDirectory();
  final exportPath = '${tempDir.path}/medicapp_backup_${DateTime.now().millisecondsSinceEpoch}.db';

  // Copy database
  await File(dbPath).copy(exportPath);

  // Share file
  await Share.shareXFiles(
    [XFile(exportPath)],
    subject: 'MedicApp Backup',
    text: 'MedicApp database - ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
  );
}
```

**User flow:**

1. User taps "Export database" in settings menu.
2. MedicApp creates a copy of `medicapp.db` with timestamp in name.
3. OS native share sheet opens.
4. User chooses destination: Gmail (as attachment), Drive, Bluetooth, "Save to files", etc.
5. The `.db` file is shared/saved to the chosen destination.

**Advanced features:**

- **XFile:** Cross-platform file abstraction that works on Android, iOS, desktop, and web.
- **Metadata:** Includes descriptive filename and explanatory text.
- **Compatibility:** Works with all apps compatible with the OS share protocol.

**Why share_plus:**

- **Native UX:** Uses the share interface the user already knows, without reinventing the wheel.
- **Perfect integration:** Automatically integrates with all installed apps that can receive files.
- **Cross-platform:** Same code works on Android and iOS with native behavior on each.

**Considered alternatives:**

- **Write directly to public directory:** Discarded because on Android 10+ (Scoped Storage) it requires complex permissions and doesn't work consistently.
- **Direct email plugin:** Discarded because it limits the user to a single backup method (email), while `share_plus` allows any destination.

**Official documentation:** https://pub.dev/packages/share_plus

---

## 9. Testing

### flutter_test (SDK)

**Version used:** Included in Flutter SDK

**Purpose:**
Official Flutter testing framework that provides all necessary tools for unit tests, widget tests, and integration tests.

**MedicApp testing architecture:**

MedicApp has **432+ tests** organized into 3 categories:

#### 1. Unit Tests (60% of tests)

Tests of pure business logic, models, services, and helpers without Flutter dependencies.

**Examples:**
- `test/medication_model_test.dart`: Data model validation.
- `test/dose_history_service_test.dart`: Dose history logic.
- `test/notification_service_test.dart`: Notification scheduling logic.
- `test/preferences_service_test.dart`: Preferences service.

**Typical structure:**
```dart
void main() {
  setUpAll(() async {
    // Initialize test database
    setupTestDatabase();
  });

  tearDown(() async {
    // Clean database after each test
    await DatabaseHelper.instance.close();
  });

  group('Medication Model', () {
    test('should create medication with valid data', () {
      final medication = Medication(
        id: 'test-id',
        name: 'Ibuprofen',
        type: MedicationType.pill,
      );

      expect(medication.id, 'test-id');
      expect(medication.name, 'Ibuprofen');
      expect(medication.type, MedicationType.pill);
    });

    test('should calculate next dose time correctly', () {
      final medication = Medication(
        id: 'test',
        name: 'Test',
        times: ['08:00', '20:00'],
      );

      final now = DateTime(2025, 1, 15, 10, 0); // 10:00 AM
      final nextDose = medication.getNextDoseTime(now);

      expect(nextDose.hour, 20); // Next dose at 20:00
    });
  });
}
```

#### 2. Widget Tests (30% of tests)

Tests of individual widgets, UI interactions, and navigation flows.

**Examples:**
- `test/settings_screen_test.dart`: Settings screen.
- `test/edit_schedule_screen_test.dart`: Schedule editor.
- `test/edit_duration_screen_test.dart`: Duration editor.
- `test/day_navigation_ui_test.dart`: Day navigation.

**Typical structure:**
```dart
void main() {
  testWidgets('should display medication list', (tester) async {
    // Arrange: Prepare test data
    final medications = [
      Medication(id: '1', name: 'Ibuprofen', type: MedicationType.pill),
      Medication(id: '2', name: 'Paracetamol', type: MedicationType.pill),
    ];

    // Act: Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: MedicationListScreen(medications: medications),
      ),
    );

    // Assert: Verify UI
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    // Interaction: Tap first medication
    await tester.tap(find.text('Ibuprofen'));
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.byType(MedicationDetailScreen), findsOneWidget);
  });
}
```

#### 3. Integration Tests (10% of tests)

End-to-end tests of complete flows involving multiple screens, database, and services.

**Examples:**
- `test/integration/add_medication_test.dart`: Complete add medication flow (8 steps).
- `test/integration/dose_registration_test.dart`: Dose recording and stock update.
- `test/integration/stock_management_test.dart`: Complete stock management (refill, depletion, alerts).
- `test/integration/app_startup_test.dart`: Application startup and data loading.

**Typical structure:**
```dart
void main() {
  testWidgets('complete add medication flow', (tester) async {
    // Start application
    await tester.pumpWidget(const MedicApp());
    await tester.pumpAndSettle();

    // Step 1: Open add medication screen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Step 2: Enter name
    await tester.enterText(find.byType(TextField).first, 'Ibuprofen 600mg');

    // Step 3: Select type
    await tester.tap(find.text('Pill'));
    await tester.pumpAndSettle();

    // Step 4: Next step
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // ... continue with 8 steps

    // Verify medication added
    expect(find.text('Ibuprofen 600mg'), findsOneWidget);

    // Verify in database
    final medications = await DatabaseHelper.instance.getMedications();
    expect(medications.length, 1);
    expect(medications.first.name, 'Ibuprofen 600mg');
  });
}
```

**Code coverage:**

- **Target:** 75-80%
- **Actual:** 75-80% (432+ tests)
- **Lines covered:** ~12,000 of ~15,000

**Areas with highest coverage:**
- Models: 95%+ (critical data logic)
- Services: 85%+ (notifications, database, doses)
- Screens: 65%+ (UI and navigation)

**Areas with lower coverage:**
- Helpers and utilities: 60%
- Initialization code: 50%

**Testing strategy:**

1. **Test-first for critical logic:** Tests written before code for dose, stock, schedule calculations.
2. **Test-after for UI:** Tests written after implementing screens to verify behavior.
3. **Regression tests:** Each bug found becomes a test to prevent regressions.

**Testing commands:**

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific tests
flutter test test/medication_model_test.dart

# Run integration tests
flutter test test/integration/
```

**Testing helpers:**

**`test/helpers/database_test_helper.dart`:**
```dart
void setupTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future<void> cleanDatabase() async {
  await DatabaseHelper.instance.close();
  await DatabaseHelper.instance.database; // Recreate clean
}
```

**`test/helpers/medication_factory.dart`:**
```dart
class MedicationFactory {
  static Medication createPill({String name = 'Test Medication'}) {
    return Medication(
      id: const Uuid().v4(),
      name: name,
      type: MedicationType.pill,
      stock: 30,
      times: ['08:00', '20:00'],
      doses: [1, 1],
    );
  }
}
```

**Official documentation:** https://docs.flutter.dev/testing

---

## 10. Development Tools

### flutter_launcher_icons ^0.14.4

**Version used:** `^0.14.4` (dev_dependencies)

**Purpose:**
Package that automatically generates application icons in all sizes and formats required by Android and iOS from a single source image.

**Configuration in MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  adaptive_icon_background: "#419e69"
  adaptive_icon_foreground: "assets/images/icon.png"
  min_sdk_android: 21
```

**Generated icons:**

**Android:**
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Adaptive icons for Android 8+ (separate foreground + background)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (20x20 to 1024x1024, 15+ variants)

**Generation command:**

```bash
flutter pub run flutter_launcher_icons
```

**Why this tool:**

- **Automation:** Manually generating 20+ icon files would be tedious and error-prone.
- **Adaptive icons (Android 8+):** Supports adaptive icon functionality that adjusts to different shapes according to the launcher.
- **Optimization:** Icons are generated in optimized PNG format.
- **Consistency:** Guarantees all sizes are generated from the same source.

**Official documentation:** https://pub.dev/packages/flutter_launcher_icons

---

### flutter_native_splash ^2.4.7

**Version used:** `^2.4.7` (dev_dependencies)

**Purpose:**
Package that generates native splash screens (initial loading screens) for Android and iOS, showing instantly while Flutter initializes.

**Configuration in MedicApp:**

**`pubspec.yaml`:**
```yaml
flutter_native_splash:
  color: "#419e69"  # Background color (MedicApp green)
  image: assets/images/icon.png  # Central image
  android: true
  ios: true
  fullscreen: true
  android_12:
    image: assets/images/icon.png
    color: "#419e69"
```

**Implemented features:**

1. **Unified splash:** Same appearance on Android and iOS.
2. **Brand color:** Green `#419e69` (MedicApp primary color).
3. **Centered logo:** MedicApp icon in center of screen.
4. **Full screen:** Hides status bar during splash.
5. **Android 12+ specific:** Special configuration to comply with Android 12's new splash system.

**Generated files:**

**Android:**
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/values/styles.xml` (splash theme)
- `android/app/src/main/res/values-night/styles.xml` (dark theme)

**iOS:**
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

**Generation command:**

```bash
flutter pub run flutter_native_splash:create
```

**Why native splash:**

- **Professional UX:** Avoids white screen during 1-2 seconds of Flutter initialization.
- **Immediate branding:** Shows logo and brand colors from the first frame.
- **Speed perception:** Splash with branding feels faster than white screen.

**Official documentation:** https://pub.dev/packages/flutter_native_splash

---

### uuid ^4.0.0

**Version used:** `^4.0.0`

**Purpose:**
UUIDs (Universally Unique Identifiers) v4 generator for creating unique identifiers for medications, persons, and dose records.

**Use in MedicApp:**

```dart
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final medication = Medication(
  id: uuid.v4(), // Generates: "f47ac10b-58cc-4372-a567-0e02b2c3d479"
  name: 'Ibuprofen',
  type: MedicationType.pill,
);
```

**Why UUIDs:**

- **Global uniqueness:** Collision probability: 1 in 10³⁸ (practically impossible).
- **Offline generation:** Doesn't require coordination with server or database sequences.
- **Future synchronization:** If MedicApp adds cloud sync, UUIDs avoid ID conflicts.
- **Debugging:** Descriptive IDs in logs instead of generic integers (1, 2, 3).

**Considered alternative:**

- **Auto-increment integer:** Discarded because it would require managing sequences in SQLite and could cause conflicts in future synchronization.

**Official documentation:** https://pub.dev/packages/uuid

---

## 11. Platform Dependencies

### Android

**Build configuration:**

**`android/app/build.gradle.kts`:**
```kotlin
android {
    namespace = "com.medicapp.medicapp"
    compileSdk = 34
    minSdk = 21  // Android 5.0 Lollipop
    targetSdk = 34  // Android 14

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  // For modern APIs on Android < 26
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

**Tools:**

- **Gradle 8.0+:** Android build system.
- **Kotlin 1.9.0:** Language for Android native code (although MedicApp doesn't use custom Kotlin code).
- **AndroidX:** Modern support libraries (replacement for Support Library).

**Minimum versions:**

- **minSdk 21 (Android 5.0 Lollipop):** Coverage of 99%+ active Android devices.
- **targetSdk 34 (Android 14):** Latest Android version to leverage modern features.

**Required permissions:**

**`android/app/src/main/AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /> <!-- Android 13+ -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" /> <!-- Exact notifications -->
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" /> <!-- Reschedule notifications after reboot -->
```

**Official documentation:** https://developer.android.com

---

### iOS

**Build configuration:**

**`ios/Runner/Info.plist`:**
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

<key>NSUserNotificationsUsageDescription</key>
<string>MedicApp needs to send notifications to remind you to take your medications.</string>
```

**Tools:**

- **CocoaPods 1.11+:** iOS native dependency manager.
- **Xcode 14+:** IDE required to compile iOS apps.
- **Swift 5.0:** Language for iOS native code (although MedicApp uses default AppDelegate).

**Minimum versions:**

- **iOS 12.0+:** Coverage of 98%+ active iOS devices.
- **iPadOS 12.0+:** Full support for iPad.

**Required capabilities:**

- **Push Notifications:** Although MedicApp uses local notifications, this capability enables the notifications framework.
- **Background Fetch:** Allows updating notifications when the app is in the background.

**Official documentation:** https://developer.apple.com/documentation/

---

## 12. Versions and Compatibility

### Dependencies Table

| Dependency | Version | Purpose | Category |
|------------|---------|---------|----------|
| **Flutter SDK** | `3.9.2+` | Main framework | Core |
| **Dart SDK** | `3.9.2+` | Programming language | Core |
| **cupertino_icons** | `^1.0.8` | iOS icons | UI |
| **sqflite** | `^2.3.0` | SQLite database | Persistence |
| **path** | `^1.8.3` | Path manipulation | Utility |
| **flutter_local_notifications** | `^19.5.0` | Local notifications | Notifications |
| **timezone** | `^0.10.1` | Time zones | Notifications |
| **intl** | `^0.20.2` | Internationalization | i18n |
| **android_intent_plus** | `^6.0.0` | Android intents | Permissions |
| **device_info_plus** | `^11.1.0` | Device information | Platform |
| **shared_preferences** | `^2.2.2` | User preferences | Persistence |
| **file_picker** | `^8.0.0+1` | File picker | Files |
| **share_plus** | `^10.1.4` | Share files | Files |
| **path_provider** | `^2.1.5` | System directories | Persistence |
| **uuid** | `^4.0.0` | UUID generator | Utility |
| **logger** | `^2.0.0` | Professional logging system | Logging |
| **sqflite_common_ffi** | `^2.3.0` | SQLite testing | Testing (dev) |
| **flutter_launcher_icons** | `^0.14.4` | Icon generation | Tool (dev) |
| **flutter_native_splash** | `^2.4.7` | Splash screen | Tool (dev) |
| **flutter_lints** | `^6.0.0` | Static analysis | Tool (dev) |

**Total production dependencies:** 16
**Total development dependencies:** 4
**Total:** 20

---

### Platform Compatibility

| Platform | Minimum version | Target version | Coverage |
|----------|----------------|----------------|----------|
| **Android** | 5.0 (API 21) | 14 (API 34) | 99%+ devices |
| **iOS** | 12.0 | 17.0 | 98%+ devices |
| **iPadOS** | 12.0 | 17.0 | 98%+ devices |

**Not supported:** Web, Windows, macOS, Linux (MedicApp is exclusively mobile by design).

---

### Flutter Compatibility

| Flutter | Compatible | Notes |
|---------|------------|-------|
| 3.9.2 - 3.10.x | ✅ | Development version |
| 3.11.x - 3.19.x | ✅ | Compatible without changes |
| 3.20.x - 3.35.x | ✅ | Tested up to 3.35.7 |
| 3.36.x+ | ⚠️ | Likely compatible, not tested |
| 4.0.x | ❌ | Requires dependency updates |

---

## 13. Comparisons and Decisions

### 13.1. Database: SQLite vs Hive vs Isar vs Drift

**Decision:** SQLite (sqflite)

**Extended justification:**

**MedicApp requirements:**

1. **N:M (Many-to-Many) relationships:** A medication can be assigned to multiple persons, and a person can have multiple medications. This architecture is native in SQL but complex in NoSQL.

2. **Complex queries:** Getting all medications for a person with their personalized configurations requires JOINs between 3 tables:

```sql
SELECT m.*, pm.custom_times, pm.custom_doses
FROM medications m
JOIN person_medications pm ON m.id = pm.medication_id
JOIN persons p ON pm.person_id = p.id
WHERE p.id = ?
```

This is trivial in SQL but would require multiple queries and manual logic in NoSQL.

3. **Complex migrations:** MedicApp has evolved from V1 (simple medications table) to V19+ (multi-person with relationships). SQLite allows incremental SQL migrations that preserve data:

```sql
-- Migration V18 -> V19: Add multi-person
ALTER TABLE medications ADD COLUMN shared_stock REAL;
CREATE TABLE persons (...);
CREATE TABLE person_medications (...);
INSERT INTO persons (id, name, is_default) VALUES (?, 'Me', 1);
INSERT INTO person_medications SELECT ?, id, times, doses FROM medications;
```

**Hive:**

- ✅ **Pros:** Excellent performance, simple API, compact size.
- ❌ **Cons:**
  - **No native relationships:** Implementing N:M requires manually maintaining ID lists and making multiple queries.
  - **No complete ACID transactions:** Can't guarantee atomicity in complex operations (dose recording + stock deduction + notification).
  - **Manual migrations:** No schema versioning system, requires custom logic.
  - **Difficult debugging:** Proprietary binary format, can't inspect with standard tools.

**Isar:**

- ✅ **Pros:** Superior performance, fast indexing, elegant Dart syntax.
- ❌ **Cons:**
  - **Immaturity:** Released in 2022, less battle-tested than SQLite (20+ years).
  - **Limited relationships:** Supports relationships but not as flexible as SQL JOINs (limited to 1:1, 1:N, no direct M:N).
  - **Proprietary format:** Similar to Hive, makes debugging with external tools difficult.
  - **Lock-in:** Migrating from Isar to another solution would be costly.

**Drift:**

- ✅ **Pros:** Type-safe SQL, automatic migrations, generated APIs.
- ❌ **Cons:**
  - **Complexity:** Requires code generation, `.drift` files, and complex build_runner configuration.
  - **Boilerplate:** Even simple operations require defining tables in separate files.
  - **Size:** Increases APK size by ~200KB vs direct sqflite.
  - **Reduced flexibility:** Complex ad-hoc queries are more difficult than in direct SQL.

**Final result:**

For MedicApp, where N:M relationships are fundamental, migrations have been frequent (19 schema versions), and the ability to debug with DB Browser for SQLite has been invaluable during development, SQLite is the correct choice.

**Accepted trade-off:**
We sacrifice ~10-15% performance in massive operations (irrelevant for MedicApp use cases) in exchange for complete SQL flexibility, mature tools, and robust data architecture.

---

### 13.2. Notifications: flutter_local_notifications vs awesome_notifications vs Firebase

**Decision:** flutter_local_notifications

**Extended justification:**

**MedicApp requirements:**

1. **Temporal precision:** Notifications must arrive exactly at the scheduled time (08:00:00, not 08:00:30).
2. **Offline functionality:** Medications are taken regardless of internet connection.
3. **Privacy:** Medical data must never leave the device.
4. **Long-term scheduling:** Notifications scheduled for months in the future.

**flutter_local_notifications:**

- ✅ **Precise scheduling:** `zonedSchedule` with `androidScheduleMode: exactAllowWhileIdle` guarantees exact delivery even with Doze Mode.
- ✅ **Fully offline:** Notifications are scheduled locally, without server dependency.
- ✅ **Total privacy:** No data leaves the device.
- ✅ **Maturity:** 5+ years, 3000+ stars, used in production by thousands of medical apps.
- ✅ **Documentation:** Exhaustive examples for all use cases.

**awesome_notifications:**

- ✅ **Pros:** More customizable notification UI, animations, buttons with icons.
- ❌ **Cons:**
  - **Less mature:** 2+ years vs 5+ of flutter_local_notifications.
  - **Reported issues:** Issues with scheduled notifications on Android 12+ (WorkManager conflicts).
  - **Unnecessary complexity:** MedicApp doesn't require super-customized notifications.
  - **Lower adoption:** ~1500 stars vs 3000+ of flutter_local_notifications.

**Firebase Cloud Messaging (FCM):**

- ✅ **Pros:** Unlimited notifications, analytics, user segmentation.
- ❌ **Cons:**
  - **Requires server:** Would need backend to send notifications, increasing complexity and cost.
  - **Requires connection:** Notifications don't arrive if device is offline.
  - **Privacy:** Data (medication schedules, medication names) would be sent to Firebase.
  - **Latency:** Depends on network, doesn't guarantee exact delivery at scheduled time.
  - **Limited scheduling:** FCM doesn't support precise scheduling, only "approximate" delivery with delay.
  - **Complexity:** Requires configuring Firebase project, implementing server, managing tokens.

**Correct architecture for local medical applications:**

For apps like MedicApp (personal management, no multi-user collaboration, no backend), local notifications are architecturally superior to remote notifications:

- **Reliability:** Don't depend on internet connection or server availability.
- **Privacy:** GDPR and medical regulations compliant by design (data never leaves device).
- **Simplicity:** Zero backend configuration, zero server costs.
- **Precision:** Guarantee of delivery exact to the second.

**Final result:**

`flutter_local_notifications` is the obvious and correct choice for MedicApp. awesome_notifications would be over-engineering for UI we don't need, and FCM would be architecturally incorrect for a completely local application.

---

### 13.3. State Management: Vanilla Flutter vs Provider vs BLoC vs Riverpod

**Decision:** Vanilla Flutter (no state management library)

**Extended justification:**

**MedicApp architecture:**

```
┌─────────────┐
│  Screens    │ (StatefulWidget + setState)
└─────┬───────┘
      │ query()
      ↓
┌─────────────┐
│ DatabaseHelper │ (SQLite - Single Source of Truth)
└─────────────┘
```

In MedicApp, **the database IS the state**. There's no significant state in memory that needs to be shared between widgets.

**Typical screen pattern:**

```dart
class MedicationListScreen extends StatefulWidget {
  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> _medications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final medications = await DatabaseHelper.instance.getMedications();
    setState(() {
      _medications = medications;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return CircularProgressIndicator();

    return ListView.builder(
      itemCount: _medications.length,
      itemBuilder: (context, index) {
        return MedicationCard(medication: _medications[index]);
      },
    );
  }
}
```

**Why Provider would be unnecessary:**

Provider is designed to **share state between distant widgets in the tree**. Classic example:

```dart
// With Provider (unnecessary in MedicApp)
ChangeNotifierProvider(
  create: (_) => MedicationProvider(),
  child: MaterialApp(
    home: HomeScreen(),
  ),
)

// HomeScreen can access MedicationProvider
Provider.of<MedicationProvider>(context).medications

// DetailScreen can also access MedicationProvider
Provider.of<MedicationProvider>(context).addDose(...)
```

**Problem:** In MedicApp, screens DON'T need to share state in memory. Each screen queries the database directly:

```dart
// Screen 1: Medication list
final medications = await db.getMedications();

// Screen 2: Medication detail
final medication = await db.getMedication(id);

// Screen 3: Dose history
final history = await db.getDoseHistory(medicationId);
```

All get data directly from SQLite, which is the only source of truth. There's no need for `ChangeNotifier`, `MultiProvider`, or state propagation.

**Why BLoC would be over-engineering:**

BLoC (Business Logic Component) is designed for enterprise applications with **complex business logic** that must be **separated from UI** and **tested independently**.

Example BLoC architecture:

```dart
// medication_bloc.dart
class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final MedicationRepository repository;

  MedicationBloc(this.repository) : super(MedicationInitial()) {
    on<LoadMedications>(_onLoadMedications);
    on<AddMedication>(_onAddMedication);
    on<DeleteMedication>(_onDeleteMedication);
  }

  Future<void> _onLoadMedications(event, emit) async {
    emit(MedicationLoading());
    try {
      final medications = await repository.getMedications();
      emit(MedicationLoaded(medications));
    } catch (e) {
      emit(MedicationError(e.toString()));
    }
  }
  // ... more events
}

// medication_event.dart (separate events)
// medication_state.dart (separate states)
// medication_repository.dart (data layer)
```

**Problem:** This adds **4-5 files** per feature and hundreds of lines of boilerplate to implement what in Vanilla Flutter is:

```dart
final medications = await DatabaseHelper.instance.getMedications();
setState(() {
  _medications = medications;
});
```

**For MedicApp:**

- **Simple business logic:** Stock calculations (subtraction), date calculations (comparison), string formatting.
- **No complex business rules:** No credit card validations, financial calculations, OAuth authentication, etc.
- **Direct testing:** Services (DatabaseHelper, NotificationService) are tested directly without needing BLoC mocks.

**Why Riverpod would be unnecessary:**

Riverpod is an evolution of Provider that solves some problems (compile-time safety, doesn't depend on BuildContext), but it's still unnecessary for MedicApp for the same reasons as Provider.

**Cases where we WOULD need state management:**

1. **Application with authentication:** User/session state shared across all screens.
2. **Shopping cart:** Selected items state shared between products, cart, checkout.
3. **Real-time chat:** Incoming messages that must update multiple screens simultaneously.
4. **Collaborative application:** Multiple users editing the same document in real-time.

**MedicApp DOESN'T have any of these cases.**

**Final result:**

For MedicApp, `StatefulWidget + setState + Database as Source of Truth` is the correct architecture. It's simple, straightforward, easy to understand for any Flutter developer, and doesn't introduce unnecessary complexity.

Adding Provider, BLoC, or Riverpod would be purely **cargo cult programming** (using technology because it's popular, not because it solves a real problem).

---

## Conclusion

MedicApp uses a **simple, robust, and appropriate** technology stack for a local cross-platform medical application:

- **Flutter + Dart:** Cross-platform with native performance.
- **SQLite:** Mature relational database with ACID transactions.
- **Local notifications:** Total privacy and offline functionality.
- **ARB localization:** 8 languages with Unicode CLDR pluralization.
- **Vanilla Flutter:** No unnecessary state management.
- **Logger package:** Professional logging system with 6 levels and smart filtering.
- **432+ tests:** 75-80% coverage with unit, widget, and integration tests.

Each technological decision is **justified by real requirements**, not by hype or trends. The result is a maintainable, reliable application that does exactly what it promises without artificial complexity.

**Guiding principle:** *"Simplicity when possible, complexity when necessary."*
