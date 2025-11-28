import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/person.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

/// Helper to set up and clean up the database in tests.
///
/// Usage example:
/// ```dart
/// void main() {
///   DatabaseTestHelper.setupAll();
///   DatabaseTestHelper.setupEach();
///
///   test('my test', () async {
///     // your test here
///   });
/// }
/// ```
class DatabaseTestHelper {
  /// Configures the database for all tests in a group.
  /// Should be called with setUpAll() once per test file.
  static void setupAll() {
    setUpAll(() {
      // Initialize FFI for sqflite
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Use in-memory database for tests
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Cleans the database after each test.
  /// Should be called with tearDown() in each test group.
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Cleans all data from the database.
  static Future<void> cleanDatabase() async {
    // Delete all data in the correct order (respecting foreign keys)
    await DatabaseHelper.instance.deleteAllDoseHistory();
    // Note: Deleting persons will cascade delete person_medications due to FK constraints
    await DatabaseHelper.instance.deleteAllPersons();
    await DatabaseHelper.instance.deleteAllMedications();
    await DatabaseHelper.resetDatabase();
  }

  /// Ensures a default person exists in the database (required for v19+ tests).
  /// Call this after database reset to ensure tests can add medications.
  static Future<void> ensureDefaultPerson() async {
    final hasDefaultPerson = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefaultPerson) {
      final defaultPerson = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(defaultPerson);
    }
  }

  /// Fully configures the database (setUpAll + tearDown).
  /// Shortcut to set up everything with a single call.
  static void setup() {
    setupAll();
    setupEach();
  }
}
