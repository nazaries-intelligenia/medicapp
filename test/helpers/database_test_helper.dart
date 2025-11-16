import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/person.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

/// Helper para configurar y limpiar la base de datos en tests.
///
/// Ejemplo de uso:
/// ```dart
/// void main() {
///   DatabaseTestHelper.setupAll();
///   DatabaseTestHelper.setupEach();
///
///   test('mi test', () async {
///     // tu test aquí
///   });
/// }
/// ```
class DatabaseTestHelper {
  /// Configura la base de datos para todos los tests en un grupo.
  /// Debe llamarse con setUpAll() una sola vez por archivo de test.
  static void setupAll() {
    setUpAll(() {
      // Inicializar FFI para sqflite
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Usar base de datos en memoria para tests
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Limpia la base de datos después de cada test.
  /// Debe llamarse con tearDown() en cada grupo de tests.
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Limpia todos los datos de la base de datos.
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

  /// Configura completamente la base de datos (setUpAll + tearDown).
  /// Atazo para configurar todo con una sola llamada.
  static void setup() {
    setupAll();
    setupEach();
  }
}
