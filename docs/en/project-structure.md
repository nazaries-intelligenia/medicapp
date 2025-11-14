# MedicApp Project Structure

This document describes the organization of folders and files in the MedicApp project, a Flutter application for medication management and reminders.

## Directory Tree

### `lib/` Structure

```
lib/
├── main.dart
├── database/
│   └── database_helper.dart
├── models/
│   ├── person.dart
│   ├── medication.dart
│   ├── person_medication.dart
│   ├── dose_history_entry.dart
│   ├── medication_type.dart
│   └── treatment_duration_type.dart
├── screens/
│   ├── main_screen.dart
│   ├── medication_list_screen.dart
│   ├── medicine_cabinet_screen.dart
│   ├── dose_history_screen.dart
│   ├── settings_screen.dart
│   ├── medication_info_screen.dart
│   ├── medication_frequency_screen.dart
│   ├── medication_dosage_screen.dart
│   ├── medication_times_screen.dart
│   ├── medication_dates_screen.dart
│   ├── medication_duration_screen.dart
│   ├── medication_fasting_screen.dart
│   ├── medication_quantity_screen.dart
│   ├── medication_inventory_screen.dart
│   ├── medication_stock_screen.dart
│   ├── weekly_days_selector_screen.dart
│   ├── specific_dates_selector_screen.dart
│   ├── dose_action_screen.dart
│   ├── edit_medication_menu_screen.dart
│   ├── debug_notifications_screen.dart
│   ├── medication_list/
│   │   ├── medication_cache_manager.dart
│   │   ├── dialogs/
│   │   │   ├── dose_selection_dialog.dart
│   │   │   ├── extra_dose_confirmation_dialog.dart
│   │   │   ├── medication_options_sheet.dart
│   │   │   ├── notification_permission_dialog.dart
│   │   │   ├── debug_info_dialog.dart
│   │   │   └── edit_today_dose_dialog.dart
│   │   ├── services/
│   │   │   └── dose_calculation_service.dart
│   │   └── widgets/
│   │       ├── battery_optimization_banner.dart
│   │       ├── empty_medications_view.dart
│   │       ├── today_doses_section.dart
│   │       └── debug_menu.dart
│   ├── medicine_cabinet/
│   │   ├── medication_person_assignment_screen.dart
│   │   ├── dialogs/
│   │   └── widgets/
│   │       ├── medication_card.dart
│   │       ├── medication_options_modal.dart
│   │       ├── empty_cabinet_view.dart
│   │       └── no_search_results_view.dart
│   ├── dose_history/
│   │   ├── dialogs/
│   │   │   ├── delete_confirmation_dialog.dart
│   │   │   └── edit_entry_dialog.dart
│   │   └── widgets/
│   │       ├── dose_history_card.dart
│   │       ├── active_filters_chip.dart
│   │       ├── empty_history_view.dart
│   │       ├── filter_dialog.dart
│   │       ├── stat_card.dart
│   │       └── statistics_card.dart
│   ├── dose_action/
│   │   └── widgets/
│   │       ├── postpone_buttons.dart
│   │       ├── skip_dose_button.dart
│   │       └── take_dose_button.dart
│   ├── edit_medication_menu/
│   │   └── widgets/
│   │       └── edit_menu_option.dart
│   ├── edit_sections/
│   │   ├── edit_basic_info_screen.dart
│   │   ├── edit_frequency_screen.dart
│   │   ├── edit_schedule_screen.dart
│   │   ├── edit_duration_screen.dart
│   │   ├── edit_fasting_screen.dart
│   │   ├── edit_quantity_screen.dart
│   │   ├── edit_frequency/
│   │   │   └── widgets/
│   │   │       ├── frequency_options_list.dart
│   │   │       ├── custom_interval_config_card.dart
│   │   │       ├── specific_dates_config_card.dart
│   │   │       └── weekly_pattern_config_card.dart
│   │   ├── edit_duration/
│   │   │   └── widgets/
│   │   │       ├── duration_type_info_card.dart
│   │   │       └── treatment_dates_card.dart
│   │   └── edit_quantity/
│   │       └── widgets/
│   ├── medication_dates/
│   │   └── widgets/
│   │       ├── clear_date_button.dart
│   │       ├── date_selector_card.dart
│   │       ├── dates_help_info.dart
│   │       └── duration_summary.dart
│   ├── medication_dosage/
│   │   └── widgets/
│   │       ├── custom_doses_input_card.dart
│   │       ├── dosage_mode_option_card.dart
│   │       ├── dose_summary_info.dart
│   │       └── interval_input_card.dart
│   ├── medication_duration/
│   │   └── widgets/
│   │       ├── duration_option_card.dart
│   │       └── specific_dates_selector_card.dart
│   ├── medication_frequency/
│   │   └── widgets/
│   │       └── weekly_days_selector_card.dart
│   ├── medication_quantity/
│   │   └── widgets/
│   │       └── medication_summary_card.dart
│   ├── medication_stock/
│   │   └── widgets/
│   │       ├── empty_stock_view.dart
│   │       ├── medication_stock_card.dart
│   │       └── stock_summary_card.dart
│   ├── persons/
│   │   ├── add_edit_person_screen.dart
│   │   └── persons_management_screen.dart
│   ├── settings/
│   │   └── widgets/
│   │       ├── info_card.dart
│   │       ├── setting_option_card.dart
│   │       └── setting_switch_card.dart
│   ├── specific_dates_selector/
│   │   └── widgets/
│   │       ├── date_list_tile.dart
│   │       ├── instructions_card.dart
│   │       └── selected_dates_list_card.dart
│   └── weekly_days_selector/
│       └── widgets/
│           ├── day_selection_tile.dart
│           └── selection_count_info.dart
├── services/
│   ├── notification_service.dart
│   ├── dose_action_service.dart
│   ├── dose_history_service.dart
│   ├── preferences_service.dart
│   ├── notification_id_generator.dart
│   └── notifications/
│       ├── notification_config.dart
│       ├── notification_cancellation_manager.dart
│       ├── daily_notification_scheduler.dart
│       ├── weekly_notification_scheduler.dart
│       └── fasting_notification_scheduler.dart
├── widgets/
│   ├── action_buttons.dart
│   ├── medication_header_card.dart
│   └── forms/
│       ├── medication_info_form.dart
│       ├── frequency_option_card.dart
│       └── fasting_configuration_form.dart
├── utils/
│   ├── datetime_extensions.dart
│   ├── medication_sorter.dart
│   ├── number_utils.dart
│   └── platform_helper.dart
└── l10n/
    ├── app_es.arb
    ├── app_en.arb
    ├── app_ca.arb
    ├── app_eu.arb
    ├── app_gl.arb
    ├── app_fr.arb
    ├── app_de.arb
    ├── app_it.arb
    ├── app_localizations.dart (generated)
    └── app_localizations_*.dart (generated)
```

### `test/` Structure

```
test/
├── helpers/
│   ├── test_helpers.dart
│   ├── database_test_helper.dart
│   ├── medication_builder.dart
│   ├── person_test_helper.dart
│   ├── notification_test_helper.dart
│   ├── widget_test_helpers.dart
│   └── test_constants.dart
├── integration/
│   ├── add_medication_test.dart
│   ├── app_startup_test.dart
│   ├── debug_menu_test.dart
│   ├── delete_medication_test.dart
│   ├── dose_registration_test.dart
│   ├── edit_medication_test.dart
│   ├── medication_modal_test.dart
│   ├── navigation_test.dart
│   └── stock_management_test.dart
├── as_needed_main_screen_display_test.dart
├── as_needed_stock_test.dart
├── database_export_import_test.dart
├── database_refill_test.dart
├── day_navigation_test.dart
├── day_navigation_ui_test.dart
├── deletion_cleanup_test.dart
├── dose_action_service_test.dart
├── dose_history_service_test.dart
├── dose_management_test.dart
├── early_dose_notification_test.dart
├── early_dose_with_fasting_test.dart
├── edit_duration_screen_test.dart
├── edit_fasting_screen_test.dart
├── edit_schedule_screen_test.dart
├── edit_screens_validation_test.dart
├── extra_dose_test.dart
├── fasting_countdown_test.dart
├── fasting_field_preservation_test.dart
├── fasting_notification_test.dart
├── fasting_test.dart
├── medication_model_test.dart
├── medication_sorting_test.dart
├── multiple_fasting_prioritization_test.dart
├── notification_actions_test.dart
├── notification_cancellation_test.dart
├── notification_limits_test.dart
├── notification_midnight_edge_cases_test.dart
├── notification_multi_person_test.dart
├── notification_person_title_test.dart
├── notification_service_test.dart
├── notification_sync_test.dart
├── preferences_service_test.dart
└── settings_screen_test.dart
```

### Important Root Files

```
medicapp/
├── pubspec.yaml              # Project dependencies and configuration
├── l10n.yaml                 # Localization configuration
├── analysis_options.yaml     # Linting rules
├── android/
│   └── app/
│       └── build.gradle      # Android configuration
└── ios/
    └── Runner/
        └── Info.plist        # iOS configuration
```

## `lib/` Directory

### `lib/main.dart`

Application entry point. Responsibilities:

- Initialize notification service
- Request notification permissions
- Create default person ("Me") if it doesn't exist
- Configure MaterialApp with:
  - Accessible light and dark themes (larger fonts)
  - Localization support (8 languages)
  - GlobalKey for navigation from notifications
  - Navigation routes
- Re-schedule notifications in background on startup

### `lib/database/`

#### `database_helper.dart`

Singleton that manages all data persistence with SQLite. Responsibilities:

- Create and update database schema
- CRUD for persons (Person)
- CRUD for medications (Medication)
- CRUD for person-medication assignments (PersonMedication)
- CRUD for dose history (DoseHistoryEntry)
- Complex queries to get active medications by person
- Export and import database (backup/restore)
- Support for in-memory database (testing)

### `lib/models/`

Data models representing domain entities:

#### `person.dart`

Represents a person taking medications:

- `id`: Unique UUID
- `name`: Person's name
- `isDefault`: Indicates if it's the default person ("Me")
- JSON and Map conversion for SQLite

#### `medication.dart`

Represents a medication in the cabinet:

- Basic information: name, type, notes
- Quantity and stock
- Frequency: daily, weekly, custom interval, specific dates, as needed
- Dosing times
- Treatment duration: continuous, end date, number of doses
- Fasting configuration (optional)
- Methods to calculate next doses
- Completeness validations

#### `person_medication.dart`

Links medications with persons:

- `personId`: Person reference
- `medicationId`: Medication reference
- `isActive`: If it's active for the person
- Used to assign cabinet medications to specific persons

#### `dose_history_entry.dart`

Record of a dose taken, skipped, or postponed:

- `medicationId`: Associated medication
- `personId`: Person who took/skipped the dose
- `scheduledTime`: Originally scheduled time
- `actualTime`: Actual registration time
- `status`: taken, skipped, postponed
- `wasEarly`: If it was taken early
- `isExtraDose`: If it's an unscheduled extra dose
- `notes`: Optional notes

#### `medication_type.dart`

Medication type enumeration:

- Tablet, Capsule, Syrup, Injection
- Inhaler, Cream, Patch
- Bandage, Drop, Other

#### `treatment_duration_type.dart`

Treatment duration type enumeration:

- `continuous`: No end date
- `untilDate`: Until a specific date
- `numberOfDoses`: Limited number of doses

### `lib/screens/`

Application screens organized by functionality.

#### Main Screens

- **`main_screen.dart`**: Main navigation with BottomNavigationBar
- **`medication_list_screen.dart`**: List of person's active medications, today's doses
- **`medicine_cabinet_screen.dart`**: Shared cabinet with all medications
- **`dose_history_screen.dart`**: Dose history with filters and statistics
- **`settings_screen.dart`**: Settings, export/import DB, person management

#### Add Medication Flow (Wizard)

Sequential navigation to create a medication:

1. **`medication_info_screen.dart`**: Name, type, notes
2. **`medication_frequency_screen.dart`**: Frequency (daily, weekly, interval, dates)
3. **`medication_dosage_screen.dart`**: Dose per intake or interval between doses
4. **`medication_times_screen.dart`**: Dosing times
5. **`medication_dates_screen.dart`**: Start date (and optional end date)
6. **`medication_duration_screen.dart`**: Treatment duration type
7. **`medication_fasting_screen.dart`**: Fasting configuration (optional)
8. **`medication_quantity_screen.dart`**: Quantity per intake
9. **`medication_inventory_screen.dart`**: Initial stock and alert threshold

#### Edit Screens

Located in `edit_sections/`:

- **`edit_basic_info_screen.dart`**: Edit name, type, notes
- **`edit_frequency_screen.dart`**: Modify frequency
- **`edit_schedule_screen.dart`**: Change times
- **`edit_duration_screen.dart`**: Adjust treatment duration
- **`edit_fasting_screen.dart`**: Configure fasting
- **`edit_quantity_screen.dart`**: Modify quantity

Each section has its own folder with specific widgets.

#### Support Screens

- **`weekly_days_selector_screen.dart`**: Day of the week selector
- **`specific_dates_selector_screen.dart`**: Specific dates selector
- **`dose_action_screen.dart`**: Register dose (take, skip, postpone)
- **`edit_medication_menu_screen.dart`**: Menu to edit medication
- **`medication_stock_screen.dart`**: Medication stock management
- **`debug_notifications_screen.dart`**: Debug screen for notifications (development)

#### Person Screens

Located in `persons/`:

- **`persons_management_screen.dart`**: Person list and management
- **`add_edit_person_screen.dart`**: Create or edit person

#### Medicine Cabinet Screens

Located in `medicine_cabinet/`:

- **`medication_person_assignment_screen.dart`**: Assign medication to persons

#### Organization by Modules

Each complex screen has its own folder with:

- **`dialogs/`**: Screen-specific dialogs
- **`widgets/`**: Reusable widgets within the screen
- **`services/`**: Specific business logic (e.g., dose_calculation_service)

### `lib/services/`

Services that encapsulate business logic and complex operations.

#### `notification_service.dart`

Main notification service. Responsibilities:

- Initialize flutter_local_notifications
- Request notification permissions
- Schedule/cancel medication notifications
- Handle fasting notifications (ongoing)
- Manage notifications per person
- Respond to notification actions (take, skip)
- Limit notifications to 500 (Android maximum)

#### `dose_action_service.dart`

Manages dose actions:

- Register dose taken
- Skip dose
- Postpone dose
- Register extra dose
- Automatically update stock
- Re-schedule notifications after action

#### `dose_history_service.dart`

Operations on dose history:

- Get history filtered by date, medication, person
- Calculate statistics (adherence, doses taken/skipped)
- Edit history entries
- Delete entries

#### `preferences_service.dart`

Manages user preferences with SharedPreferences:

- Active person ID
- Notification settings
- UI preferences
- Last usage date

#### `notification_id_generator.dart`

Generates unique IDs for notifications based on:

- Medication ID
- Dose timestamp
- Avoids collisions between medications

#### `services/notifications/`

Subfolder with specific notification modules:

- **`notification_config.dart`**: Channel and sound configuration
- **`notification_cancellation_manager.dart`**: Intelligent notification cancellation
- **`daily_notification_scheduler.dart`**: Schedule daily notifications
- **`weekly_notification_scheduler.dart`**: Schedule weekly notifications
- **`fasting_notification_scheduler.dart`**: Schedule fasting notifications

### `lib/widgets/`

Reusable widgets throughout the application:

#### `action_buttons.dart`

Common action buttons (take, skip, postpone dose).

#### `medication_header_card.dart`

Header card with medication information.

#### `widgets/forms/`

Reusable forms:

- **`medication_info_form.dart`**: Basic information form
- **`frequency_option_card.dart`**: Frequency option card
- **`fasting_configuration_form.dart`**: Fasting configuration form

### `lib/utils/`

Utilities and extensions:

#### `datetime_extensions.dart`

DateTime extensions:

- Compare dates ignoring time
- Format dates
- Calculate days between dates
- Start/end of day operations

#### `medication_sorter.dart`

Medication sorting algorithms:

- By next dose
- By name
- By type
- By stock urgency

#### `number_utils.dart`

Number utilities:

- Format quantities
- Validate ranges
- Conversions

#### `platform_helper.dart`

Platform-specific helpers:

- Detect Android/iOS
- Open system settings
- Request platform-specific permissions

### `lib/l10n/`

Application localization (i18n) system.

#### ARB Files (Application Resource Bundle)

Translation files in JSON format:

- **`app_es.arb`**: Spanish (base template)
- **`app_en.arb`**: English
- **`app_ca.arb`**: Catalan
- **`app_eu.arb`**: Basque
- **`app_gl.arb`**: Galician
- **`app_fr.arb`**: French
- **`app_de.arb`**: German
- **`app_it.arb`**: Italian

Each file contains:

- Translation keys
- Translated values
- Placeholder metadata
- Descriptions for translators

#### Generated Files

Automatically generated by `flutter gen-l10n`:

- **`app_localizations.dart`**: Base localization class
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etc.: Language-specific implementations

Usage in the app:

```dart
AppLocalizations.of(context).medicationName
```

## `test/` Directory

Unit and integration tests to ensure code quality.

### `test/helpers/`

Shared utilities for testing:

#### `test_helpers.dart`

General helpers for tests:

- Test database setup
- Service mocks
- Initialization functions

#### `database_test_helper.dart`

Specific helpers for database tests:

- Create in-memory database
- Populate with test data
- Clean state between tests

#### `medication_builder.dart`

Builder pattern to create test medications:

```dart
final medication = MedicationBuilder()
  .withName('Aspirin')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Simplifies creating medications with different configurations.

#### `person_test_helper.dart`

Helpers to create test persons:

- Create default person
- Create multiple persons
- Manage person-medication relationships

#### `notification_test_helper.dart`

Mocks and helpers for notification tests:

- NotificationService mock
- Verify scheduled notifications
- Simulate notification actions

#### `widget_test_helpers.dart`

Helpers for widget tests:

- Create widgets with full context
- Pump widgets with localization
- Custom finders

#### `test_constants.dart`

Shared constants between tests:

- Test IDs
- Fixed dates and times
- Default values

### Unit Tests (`test/` root)

34 unit test files organized by functionality:

#### Database Tests

- `database_export_import_test.dart`: Export/import DB
- `database_refill_test.dart`: Stock refill

#### Model Tests

- `medication_model_test.dart`: Medication model validation

#### Service Tests

- `notification_service_test.dart`: Notification service
- `dose_action_service_test.dart`: Dose actions
- `dose_history_service_test.dart`: Dose history
- `preferences_service_test.dart`: User preferences

#### Notification Tests

- `notification_sync_test.dart`: Notification synchronization
- `notification_cancellation_test.dart`: Notification cancellation
- `notification_person_title_test.dart`: Titles with person name
- `notification_multi_person_test.dart`: Multi-person notifications
- `notification_actions_test.dart`: Notification actions
- `notification_limits_test.dart`: 500 notification limit
- `notification_midnight_edge_cases_test.dart`: Midnight edge cases
- `early_dose_notification_test.dart`: Early doses
- `early_dose_with_fasting_test.dart`: Early doses with fasting

#### Fasting Tests

- `fasting_test.dart`: Fasting logic
- `fasting_notification_test.dart`: Fasting notifications
- `fasting_countdown_test.dart`: Fasting countdown
- `fasting_field_preservation_test.dart`: Fasting field preservation

#### Dose Tests

- `dose_management_test.dart`: Dose management
- `extra_dose_test.dart`: Extra doses
- `deletion_cleanup_test.dart`: Deletion cleanup
- `multiple_fasting_prioritization_test.dart`: Prioritization with multiple fasting

#### Stock Tests

- `as_needed_stock_test.dart`: Stock for as-needed medications

#### UI Tests

- `day_navigation_test.dart`: Day navigation
- `day_navigation_ui_test.dart`: Day navigation UI
- `medication_sorting_test.dart`: Medication sorting
- `as_needed_main_screen_display_test.dart`: As-needed display

#### Screen Tests

- `settings_screen_test.dart`: Settings screen
- `edit_duration_screen_test.dart`: Edit duration
- `edit_fasting_screen_test.dart`: Edit fasting
- `edit_schedule_screen_test.dart`: Edit schedule
- `edit_screens_validation_test.dart`: Edit validations

### Integration Tests (`test/integration/`)

9 integration test files testing complete flows:

- **`app_startup_test.dart`**: Application startup
- **`add_medication_test.dart`**: Complete add medication flow
- **`edit_medication_test.dart`**: Medication edit flow
- **`delete_medication_test.dart`**: Medication deletion
- **`medication_modal_test.dart`**: Medication options modal
- **`dose_registration_test.dart`**: Dose registration
- **`stock_management_test.dart`**: Stock management
- **`navigation_test.dart`**: Screen navigation
- **`debug_menu_test.dart`**: Debug menu

### Test Naming Pattern

- **`*_test.dart`**: All tests end with `_test.dart`
- **`integration/*_test.dart`**: Integration tests in subfolder
- Descriptive names of tested functionality
- Grouped by feature/module

## Configuration Files

### `pubspec.yaml`

Main Flutter configuration file. Contains:

#### Main Dependencies

- **`sqflite`**: SQLite database
- **`flutter_local_notifications`**: Local notifications
- **`timezone`**: Timezone handling
- **`intl`**: Internationalization and date formatting
- **`shared_preferences`**: Key-value storage
- **`file_picker`**: File selection
- **`share_plus`**: File sharing
- **`path_provider`**: System directory access
- **`uuid`**: Unique ID generation
- **`android_intent_plus`**: Android intents

#### Assets

- Launcher icons (Android/iOS)
- Splash screen
- Localization files (automatic)

#### Configuration

- Minimum SDK: Dart ^3.9.2
- Version: 1.0.0+1

### `l10n.yaml`

Localization system configuration:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: ARB files directory
- **`template-arb-file`**: Template file (Spanish)
- **`output-localization-file`**: Generated file
- **`untranslated-messages-file`**: Missing translations report

### `analysis_options.yaml`

Linting and static analysis rules:

- Flutter recommended rule set
- Additional custom rules
- Exclusions for generated files
- Warning severity configuration

### `android/app/build.gradle`

Android build configuration:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Notification permissions
- Adaptive icon configuration

### `ios/Runner/Info.plist`

iOS configuration:

- Notification permissions
- Background modes configuration
- App Transport Security
- Icons and splash screen

## Modularization Results

Code refactoring has resulted in a significant reduction in lines of code per file, improving maintainability:

| Screen/File | Lines Before | Lines After | Reduction |
|------------------|--------------|----------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (module) | 950 | 1450 | +52.6% (distributed across 10 files) |
| `medicine_cabinet` (module) | 850 | 875 | +2.9% (distributed across 5 files) |
| `dose_history` (module) | 780 | 920 | +17.9% (distributed across 8 files) |
| **Total** | **2580** | **1260** | **-39.3%** (main files) |

### Benefits

- Smaller, focused files (< 400 lines)
- Single responsibility per file
- Separate reusable widgets
- Easier to find and modify code
- Better organization by feature
- More specific and isolated tests

## Organization Patterns

### Layer Separation (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI and presentation              │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Business logic                   │
│  - Complex operations               │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistence                      │
│  - Data models                      │
└─────────────────────────────────────┘
```

### Naming Conventions

#### Files

- **Screens**: `*_screen.dart` (e.g., `medication_list_screen.dart`)
- **Widgets**: `*_widget.dart` or descriptive name (e.g., `medication_card.dart`)
- **Dialogs**: `*_dialog.dart` (e.g., `dose_selection_dialog.dart`)
- **Services**: `*_service.dart` (e.g., `notification_service.dart`)
- **Models**: singular name (e.g., `person.dart`, `medication.dart`)
- **Helpers**: `*_helper.dart` (e.g., `database_helper.dart`)
- **Tests**: `*_test.dart` (e.g., `fasting_test.dart`)

#### Classes

- **Screens**: `*Screen` (e.g., `MedicationListScreen`)
- **Widgets**: descriptive name (e.g., `MedicationCard`, `DoseHistoryCard`)
- **Services**: `*Service` (e.g., `NotificationService`)
- **Models**: singular name in PascalCase (e.g., `Person`, `Medication`)

#### Variables

- **camelCase** for variables and methods
- **UPPER_SNAKE_CASE** for constants
- **Descriptive names** reflecting purpose

### Reusable Widget Location

#### Global Widgets (`lib/widgets/`)

Widgets used across multiple screens:

- Generic UI components
- Shared forms
- Common action buttons

#### Screen Widgets (`lib/screens/*/widgets/`)

Screen-specific widgets:

- Unique UI components
- Widgets dependent on screen context
- Not reused in other screens

#### Dialogs (`lib/screens/*/dialogs/`)

Screen-specific dialogs:

- Confirmation modals
- Option sheets (bottom sheets)
- Data input dialogs

### Helpers and Utilities

#### `lib/utils/`

Pure functions and extensions:

- Stateless
- No external dependencies
- Reusable throughout the app

#### `test/helpers/`

Testing-specific utilities:

- Test object builders
- Service mocks
- Test environment setup

## Assets and Resources

### Launcher Icons

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (multiple resolutions)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Platform Configuration Files

#### Android

- `android/app/src/main/AndroidManifest.xml`: Permissions and configuration
- `android/app/build.gradle`: Build and dependencies
- `android/gradle.properties`: Gradle properties
- `android/local.properties`: Local paths (not versioned)

#### iOS

- `ios/Runner/Info.plist`: App configuration
- `ios/Podfile`: CocoaPods dependencies
- `ios/Runner.xcodeproj/`: Xcode project

## Project Statistics

- **Total Dart files in `lib/`**: 131
- **Total test files**: 43 (34 unit + 9 integration)
- **Lines of code (approximate)**: ~15,000 lines
- **Test coverage**: High (critical services 100%)
- **Supported languages**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Data models**: 6
- **Main screens**: 20+
- **Services**: 5 main + 5 notification modules
- **Reusable widgets**: 50+

---

This document provides a complete overview of the MedicApp project structure, facilitating code navigation and understanding for new and existing developers.
