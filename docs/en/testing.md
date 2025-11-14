# Testing Guide - MedicApp

## Table of Contents

1. [Testing Overview](#testing-overview)
2. [Test Structure](#test-structure)
3. [Unit Tests](#unit-tests)
4. [Widget Tests](#widget-tests)
5. [Integration Tests](#integration-tests)
6. [Testing Helpers](#testing-helpers)
7. [Test Coverage](#test-coverage)
8. [Covered Edge Cases](#covered-edge-cases)
9. [Running Tests](#running-tests)
10. [Guide to Writing Tests](#guide-to-writing-tests)
11. [Database Testing](#database-testing)
12. [CI/CD and Automated Testing](#cicd-and-automated-testing)
13. [Next Steps](#next-steps)

---

## Testing Overview

MedicApp has a robust and well-structured test suite that ensures code quality and stability:

- **369+ automated tests** distributed across 50 files
- **75-80% code coverage** in critical areas
- **Multiple test types**: unit, widget, and integration
- **Test-Driven Development (TDD)** for new features

### Testing Philosophy

Our testing strategy is based on:

1. **Tests as documentation**: Tests document the expected behavior of the system
2. **Smart coverage**: Focus on critical areas (notifications, fasting, dose management)
3. **Fast feedback**: Quick tests that run in memory
4. **Isolation**: Each test is independent and does not affect others
5. **Realism**: Integration tests that simulate real user flows

### Test Types

```
test/
├── unitarios/          # Tests for services, models, and business logic
├── widgets/            # Tests for individual components and screens
└── integration/        # End-to-end tests for complete flows
```

---

## Test Structure

The test directory is organized in a clear and logical manner:

```
test/
├── helpers/                              # Shared utilities between tests
│   ├── medication_builder.dart           # Builder pattern for creating medications
│   ├── database_test_helper.dart         # Database setup and cleanup
│   ├── widget_test_helpers.dart          # Helpers for widget tests
│   ├── person_test_helper.dart           # Helpers for person management
│   ├── notification_test_helper.dart     # Helpers for notification tests
│   ├── test_constants.dart               # Shared constants
│   └── test_helpers.dart                 # General helpers
│
├── integration/                          # Integration tests (9 files)
│   ├── add_medication_test.dart          # Complete flow for adding medication
│   ├── edit_medication_test.dart         # Editing flow
│   ├── delete_medication_test.dart       # Deletion flow
│   ├── dose_registration_test.dart       # Dose registration
│   ├── stock_management_test.dart        # Stock management
│   ├── medication_modal_test.dart        # Details modal
│   ├── navigation_test.dart              # Screen navigation
│   ├── app_startup_test.dart             # Application startup
│   └── debug_menu_test.dart              # Debug menu
│
└── [41 unit/widget test files]
```

### Test Files by Category

#### Service Tests (13 files)
- `notification_service_test.dart` - Notification service
- `dose_action_service_test.dart` - Dose actions
- `dose_history_service_test.dart` - Dose history
- `preferences_service_test.dart` - User preferences
- And more...

#### Core Functionality Tests (18 files)
- `medication_model_test.dart` - Medication model
- `dose_management_test.dart` - Dose management
- `extra_dose_test.dart` - Extra doses
- `database_refill_test.dart` - Stock refills
- `database_export_import_test.dart` - Export/import
- And more...

#### Fasting Tests (6 files)
- `fasting_test.dart` - Fasting logic
- `fasting_notification_test.dart` - Fasting notifications
- `fasting_countdown_test.dart` - Fasting countdown
- `fasting_field_preservation_test.dart` - Field preservation
- `early_dose_with_fasting_test.dart` - Early dose with fasting
- `multiple_fasting_prioritization_test.dart` - Multiple prioritization

#### Screen Tests (14 files)
- `edit_schedule_screen_test.dart` - Schedule editing screen
- `edit_duration_screen_test.dart` - Duration editing screen
- `edit_fasting_screen_test.dart` - Fasting editing screen
- `edit_screens_validation_test.dart` - Validations
- `settings_screen_test.dart` - Settings screen
- `day_navigation_ui_test.dart` - Day navigation
- And more...

---

## Unit Tests

Unit tests verify the behavior of individual components in isolation.

### Service Tests

Verify the business logic of services:

#### NotificationService

```dart
test('should generate unique IDs for different medications', () {
  final id1 = _generateNotificationId('med1', 0);
  final id2 = _generateNotificationId('med2', 0);

  expect(id1, isNot(equals(id2)));
});

test('should handle all notification operations in test mode', () async {
  service.enableTestMode();

  final medication = MedicationBuilder()
      .withId('test-med')
      .withSingleDose('08:00', 1.0)
      .build();

  await service.scheduleMedicationNotifications(
    medication,
    personId: 'test-person-id'
  );

  // Should not throw exceptions
});
```

#### DoseActionService

```dart
test('should register dose and update stock', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await service.registerDose(medication, '08:00');

  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Model Tests

Verify data serialization and deserialization:

```dart
group('Medication Model - Fasting Configuration', () {
  test('should serialize fasting configuration to JSON', () {
    final medication = MedicationBuilder()
        .withId('test_6')
        .withMultipleDoses(['08:00', '16:00'], 1.0)
        .withFasting(type: 'before', duration: 60)
        .build();

    final json = medication.toJson();

    expect(json['requiresFasting'], 1);
    expect(json['fastingType'], 'before');
    expect(json['fastingDurationMinutes'], 60);
    expect(json['notifyFasting'], 1);
  });

  test('should deserialize fasting from JSON', () {
    final json = {
      'id': 'test_8',
      'name': 'Test Medication',
      'requiresFasting': 1,
      'fastingType': 'before',
      'fastingDurationMinutes': 60,
      // ... other fields
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Utility Tests

Verify helper functions and calculations:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 doses/day
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 units / 2 per day = 10 days
});
```

---

## Widget Tests

Widget tests verify the user interface and user interaction.

### Screen Tests

Verify that screens render correctly and respond to interactions:

```dart
testWidgets('Should add medication with default type', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Paracetamol');
  await waitForDatabase(tester);

  expect(find.text('Paracetamol'), findsOneWidget);
  expect(find.text('Pastilla'), findsAtLeastNWidgets(1));
});
```

### Component Tests

Verify individual UI components:

```dart
testWidgets('Should display fasting countdown', (tester) async {
  final medication = MedicationBuilder()
      .withFasting(type: 'after', duration: 120)
      .build();

  await tester.pumpWidget(
    MaterialApp(
      home: FastingCountdown(medication: medication),
    ),
  );

  expect(find.textContaining('2:00'), findsOneWidget);
});
```

### Dependency Mocking

For widget tests, we use mocks to isolate components:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // In-memory database
  DatabaseHelper.setInMemoryDatabase(true);

  // Test mode for notifications
  NotificationService.instance.enableTestMode();

  // Ensure default person
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Complete Example: Edit Test

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Add medication
  await addMedicationWithDuration(tester, 'Ibuprofeno');
  await waitForDatabase(tester);

  // Open edit menu
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofeno',
    'Horarios y Cantidades',
  );

  // Modify schedules
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Save
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Verify change
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Integration Tests

Integration tests verify complete end-to-end user flows.

### End-to-End Tests

Simulate real user behavior:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Start app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Add medication
  await addMedicationWithDuration(
    tester,
    'Paracetamol',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Verify it appears in list
  expect(find.text('Paracetamol'), findsOneWidget);

  // 4. Open details modal
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  // 5. Register dose
  await tester.tap(find.text('Tomar dosis'));
  await waitForComplexAsyncOperation(tester);

  // 6. Verify updated stock
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Complete Flows

Integration tests cover important flows:

1. **Add medication**: `add_medication_test.dart`
   - Complete wizard navigation
   - Configuration of all parameters
   - Verification in main list

2. **Edit medication**: `edit_medication_test.dart`
   - Modification of each section
   - Preservation of unmodified data
   - Correct update in list

3. **Delete medication**: `delete_medication_test.dart`
   - Deletion confirmation
   - Notification cleanup
   - Associated history deletion

4. **Register dose**: `dose_registration_test.dart`
   - Manual registration from modal
   - Stock update
   - History entry creation

5. **Stock management**: `stock_management_test.dart`
   - Low stock alerts
   - Stock refill
   - Duration calculation

### Database Interaction

Integration tests interact with a real in-memory database:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // First app instance
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simulate close and reopen
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medication should still be present
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Testing Helpers

Helpers simplify test writing and reduce duplicated code.

### MedicationBuilder

The **builder pattern** allows creating test medications in a readable way:

```dart
/// Basic example
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// With fasting
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// With multiple doses
final medication = MedicationBuilder()
    .withName('Antibiótico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// As "as needed" medication
final medication = MedicationBuilder()
    .withName('Analgésico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### MedicationBuilder Benefits

1. **Readability**: Code is self-documented and easy to understand
2. **Maintainability**: Changes to the model only require updating the builder
3. **Code reduction**: Avoids repeating default values in each test
4. **Flexibility**: Allows configuring only what is necessary for each test

#### Factory Methods

The builder includes factory methods for common cases:

```dart
// Low stock (5 units)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// No stock
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Multiple doses per day (automatic)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Fasting enabled with default values
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Allows creating a builder from an existing medication:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nombre Modificado')
    .build();
```

### DatabaseTestHelper

Simplifies database setup and cleanup:

```dart
class DatabaseTestHelper {
  /// Initial setup (once per file)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Cleanup after each test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Shortcut: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Ensures default person exists
  static Future<void> ensureDefaultPerson() async {
    final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefault) {
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);
    }
  }
}
```

**Usage in tests:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Complete setup

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // Your test here
  });
}
```

### WidgetTestHelpers

Helper functions for widget tests:

```dart
/// Get localizations
AppLocalizations getL10n(WidgetTester tester);

/// Wait for database operations
Future<void> waitForDatabase(WidgetTester tester);

/// Wait for a widget to appear
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Scroll to a widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Open edit menu
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Add complete medication
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Wait for complex async operations
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Other Helpers

- **PersonTestHelper**: Person management in tests
- **NotificationTestHelper**: Helpers for notifications
- **TestConstants**: Shared constants (doses, stocks, times)

---

## Test Coverage

The test suite covers the most critical areas of the application.

### Coverage by Category

| Category | Tests | Description |
|-----------|-------|-------------|
| **Services** | ~94 tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Core Functionality** | ~79 tests | Dose management, stock, fasting, export/import |
| **Fasting** | ~61 tests | Fasting logic, notifications, countdown, prioritization |
| **Screens** | ~93 tests | Widget and navigation tests for all screens |
| **Integration** | ~52 tests | Complete end-to-end flows |

**Total: 369+ tests**

### Well-Covered Areas

#### Notifications (95% coverage)
- Scheduling and canceling notifications
- Unique IDs for different notification types
- Notifications for weekly patterns and specific dates
- Fasting notifications
- Quick actions from notifications
- Platform limits (500 notifications)
- Midnight edge cases

#### Fasting (90% coverage)
- Calculation of fasting periods (before/after)
- Duration validations
- Start and end notifications
- Visual countdown
- Prioritization with multiple active periods
- Early doses with fasting
- Configuration preservation

#### Dose Management (88% coverage)
- Dose registration (manual and from notification)
- Dose omission
- Extra doses
- Stock update
- Dose history
- Daily consumption calculation

#### Database (85% coverage)
- Medication CRUD
- Person CRUD
- Schema migration
- Export/import
- Referential integrity
- Cascade cleanup

### Areas with Less Coverage

Some areas have lower but non-critical coverage:

- **Advanced UI/UX** (60%): Animations, transitions
- **Settings** (65%): User preferences
- **Localization** (70%): Translations and languages
- **Permissions** (55%): System permission requests

These areas have lower coverage because:
1. They are difficult to test automatically
2. They require manual interaction
3. They depend on the operating system
4. They do not affect critical business logic

---

## Covered Edge Cases

Tests include special cases that could cause errors:

### 1. Midnight Notifications

**File**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dose scheduled yesterday at 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Registered today at 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Should count as previous day's dose
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dose at 22:00 with "after" fasting of 3 hours
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Fasting ends at 01:00 the next day
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Covered cases:**
- Late doses registered after midnight
- Fasting periods crossing midnight
- Doses scheduled exactly at 00:00
- Daily counter resets
- Postponed notifications crossing midnight

### 2. Deletion and Cleanup

**File**: `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Delete
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // Should have no scheduled notifications
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Delete person
  await db.deletePerson(person.id);

  // Should have no medications or history
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Covered cases:**
- Notification cancellation when deleting medication
- Cascade deletion of history
- Notification cleanup when deleting person
- Not affecting other medications/persons
- Referential integrity

### 3. Multiple Fasting Prioritization

**File**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Medication 1: "after" fasting of 120 minutes
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Medication 2: "after" fasting of 60 minutes
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Register both doses
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Should only show the most restrictive fasting (med-1 until 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Covered cases:**
- Multiple active fastings for one person
- Selection of the most restrictive period
- Ordering by end time
- Automatic filtering of finished periods
- Independence between different persons

### 4. Notification Actions

**File**: `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Simulate "register_dose" action from notification
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Verify effects
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));

  final history = await db.getDoseHistory(medication.id);
  expect(history.last.status, 'taken');
});

test('snooze_dose action should postpone notification by 10 minutes',
    () async {
  final notification = await scheduleNotification(
    medicationId: 'med-1',
    time: TimeOfDay(hour: 8, minute: 0),
  );

  // Snooze
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Verify new schedule
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Covered cases:**
- Registration from notification
- Omission from notification
- Snooze for 10 minutes
- Correct stock and history update
- Original notification cancellation

### 5. Notification Limits

**File**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Create 100 medications with 4 doses each
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Schedule notifications (potentially >500)
  await notificationService.scheduleAll();

  // Should not crash
  // Should prioritize near notifications
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Covered cases:**
- Handling more than 500 notifications
- Prioritizing near notifications
- Warning logging
- Not crashing the app
- Automatic rescheduling

---

## Running Tests

### Basic Commands

```bash
# Run all tests
flutter test

# Specific test
flutter test test/services/notification_service_test.dart

# Tests in a directory
flutter test test/integration/

# Tests with specific name
flutter test --name "fasting"

# Tests in verbose mode
flutter test --verbose

# Tests with time report
flutter test --reporter expanded
```

### Tests with Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Running Specific Tests

```bash
# Only service tests
flutter test test/*_service_test.dart

# Only integration tests
flutter test test/integration/

# Only fasting tests
flutter test test/fasting*.dart

# Exclude slow tests
flutter test --exclude-tags=slow
```

### Tests in CI/CD

```bash
# CI mode (no color, suitable format for logs)
flutter test --machine --coverage

# With timeout for slow tests
flutter test --timeout=30s

# Fast fail (stop at first error)
flutter test --fail-fast
```

### Test Debugging

```bash
# Run a single test in debug mode
flutter test --plain-name "specific test name"

# With breakpoints (VS Code/Android Studio)
# Use "Debug Test" from the IDE

# With visible prints
flutter test --verbose

# Save output to file
flutter test > test_output.txt 2>&1
```

---

## Guide to Writing Tests

### AAA Structure (Arrange-Act-Assert)

Organize each test into three clear sections:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Prepare the environment
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Execute the action to test
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Verify the result
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Naming Conventions

Use descriptive names that explain the scenario:

```dart
// ✅ GOOD: Describes the complete scenario
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ BAD: Vague or technical names
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Recommended format:**
- `should [expected action] when [condition]`
- `[action] [expected result] [optional context]`

### Setup and Teardown

Configure and clean the environment consistently:

```dart
void main() {
  // Initial setup once
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Before each test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // After each test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Your tests here
  test('...', () async {
    // Isolated test with clean environment
  });
}
```

### Mocking DatabaseHelper

For pure unit tests, mock the database:

```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late DoseActionService service;

  setUp(() {
    mockDb = MockDatabaseHelper();
    service = DoseActionService(database: mockDb);
  });

  test('should call database method with correct parameters', () async {
    final medication = MedicationBuilder().build();

    // Configure mock
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Execute action
    await service.registerDose(medication.id, '08:00');

    // Verify call
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Using MedicationBuilder

Take advantage of the builder to create readable tests:

```dart
test('should calculate correct stock duration', () {
  // Create medication with builder
  final medication = MedicationBuilder()
      .withName('Paracetamol')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 doses per day
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 days
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory method for low stock
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Best Practices

1. **Independent tests**: Each test should be able to run alone
   ```dart
   // ✅ GOOD: Self-contained test
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... rest of test
   });

   // ❌ BAD: Depends on execution order
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Depends on previous test
   });
   ```

2. **Fast tests**: Use in-memory database, avoid unnecessary delays
   ```dart
   // ✅ GOOD
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ BAD
   await Future.delayed(Duration(seconds: 2)); // Arbitrary delay
   ```

3. **Specific assertions**: Verify exactly what matters
   ```dart
   // ✅ GOOD
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ BAD
   expect(medication, isNotNull); // Too vague
   ```

4. **Logical groups**: Organize related tests
   ```dart
   group('Dose Registration', () {
     test('should register dose successfully', () {});
     test('should update stock when registering', () {});
     test('should create history entry', () {});
   });

   group('Dose Validation', () {
     test('should reject invalid time format', () {});
     test('should reject negative quantity', () {});
   });
   ```

5. **Test edge cases**: Not just the happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Useful comments**: Explain the "why", not the "what"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Doses registered after midnight but within
     // 2 hours of scheduling count for the previous day
     // This prevents late doses from duplicating daily count

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Database Testing

### Using sqflite_common_ffi

Tests use `sqflite_common_ffi` for in-memory database:

```dart
void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();

    // Use FFI factory
    databaseFactory = databaseFactoryFfi;

    // Enable in-memory mode
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Database is automatically created in memory
    final db = DatabaseHelper.instance;

    // Normal operations
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### In-Memory Database

Advantages of using in-memory database:

1. **Speed**: 10-100x faster than disk
2. **Isolation**: Each test starts with clean DB
3. **No side effects**: Does not modify real data
4. **Parallelization**: Tests can run in parallel

```dart
setUp(() async {
  // Reset for clean DB
  await DatabaseHelper.resetDatabase();

  // In-memory mode
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migrations in Tests

Tests verify that migrations work correctly:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Create DB in version 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (without persons table)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // Open in version 19 (trigger migration)
  final migratedDb = await DatabaseHelper.instance.database;

  // Verify persons exists
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Verify default person
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Cleanup Between Tests

It is crucial to clean the DB between tests to avoid contamination:

```dart
tearDown(() async {
  // Method 1: Delete all data
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Method 2: Reset completely
  await DatabaseHelper.resetDatabase();

  // Method 3: Use helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Referential Integrity Tests

Verify that DB relationships work correctly:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Delete person
  await db.deletePerson(person.id);

  // Medications should have been deleted
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Try to insert history for non-existent medication
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Should fail due to foreign key constraint
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD and Automated Testing

### Continuous Integration

Typical configuration for GitHub Actions:

```yaml
name: Tests

on:
  push:
    branches: [ main, development ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage --machine

    - name: Check coverage
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 70" | bc -l) )); then
          echo "Coverage $COVERAGE% is below 70%"
          exit 1
        fi

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v2
      with:
        file: ./coverage/lcov.info
```

### Pre-commit Hooks

Use `husky` or Git hook scripts to run tests before commit:

```bash
# .git/hooks/pre-commit
#!/bin/sh

echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed!"
```

### Minimum Coverage Threshold

Configure minimum threshold to avoid regressions:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Check minimum coverage
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Coverage Reports

Generate visual reports automatically:

```bash
# Generate report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Coverage badge
./scripts/generate_coverage_badge.sh

# Publish report
# (use GitHub Pages, Codecov, Coveralls, etc.)
```

---

## Next Steps

### Areas to Improve

1. **UI/UX Tests (60% → 80%)**
   - More animation tests
   - Gesture and swipe tests
   - Accessibility tests

2. **Permission Tests (55% → 75%)**
   - System permission mocking
   - Permission request flows
   - Handling denied permissions

3. **Localization Tests (70% → 90%)**
   - Tests for each language
   - Complete translation verification
   - Date/number formatting tests

4. **Performance Tests**
   - Critical operation benchmarks
   - Load tests (many medications)
   - Memory leak detection

### Pending Tests

#### High Priority

- [ ] Complete backup/restore tests
- [ ] Background notification tests
- [ ] Home screen widget tests
- [ ] Deep link tests
- [ ] Data sharing tests

#### Medium Priority

- [ ] All language tests
- [ ] Theme tests (light/dark)
- [ ] Onboarding tests
- [ ] Migrations between all versions
- [ ] CSV/PDF export tests

#### Low Priority

- [ ] Complex animation tests
- [ ] Advanced gesture tests
- [ ] Exhaustive accessibility tests
- [ ] Performance tests on slow devices

### Testing Roadmap

#### Q1 2025
- Reach 80% overall coverage
- Complete permission tests
- Add basic performance tests

#### Q2 2025
- All language tests
- Backup/restore tests
- Updated testing documentation

#### Q3 2025
- Complete accessibility tests
- Load and stress tests
- Full CI/CD automation

#### Q4 2025
- 85%+ overall coverage
- Performance test suite
- Visual regression tests

---

## Additional Resources

### Documentation

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Tools

- **flutter_test**: Flutter testing framework
- **mockito**: Dependency mocking
- **sqflite_common_ffi**: In-memory DB for tests
- **test_coverage**: Coverage analysis
- **lcov**: HTML report generation

### Related Files

- `/test/helpers/` - All testing helpers
- `/test/integration/` - Integration tests
- `/.github/workflows/test.yml` - CI/CD configuration
- `/scripts/run_tests.sh` - Testing scripts

---

**Last updated**: November 2025
**MedicApp version**: V19+
**Total tests**: 369+
**Average coverage**: 75-80%
