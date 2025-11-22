import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'package:medicapp/models/person.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/screens/medication_list/medication_list_viewmodel.dart';
import 'package:medicapp/screens/medication_list/services/dose_calculation_service.dart';
import 'package:medicapp/utils/datetime_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'helpers/test_helpers.dart';
import 'helpers/database_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupTestDatabase();

  // Mock SharedPreferences for all tests
  SharedPreferences.setMockInitialValues({});

  // Helper function to get the default person (created by ensureDefaultPerson)
  Future<Person> getDefaultPerson() async {
    final person = await DatabaseHelper.instance.getDefaultPerson();
    if (person == null) {
      throw Exception('No default person found');
    }
    return person;
  }

  // Helper function to create test person
  Future<Person> createTestPerson({
    required String name,
    required bool isDefault,
  }) async {
    final person = Person(
      id: const Uuid().v4(),
      name: name,
      isDefault: isDefault,
    );
    await DatabaseHelper.instance.insertPerson(person);
    return person;
  }

  group('MedicationListViewModel - Helper Methods', () {
    late MedicationListViewModel viewModel;
    late Person testPerson;

    setUp(() async {
      await DatabaseTestHelper.cleanDatabase();
      await DatabaseTestHelper.ensureDefaultPerson();
      viewModel = MedicationListViewModel();
      testPerson = await getDefaultPerson();
    });

    tearDown(() async {
      viewModel.dispose();
      await DatabaseTestHelper.cleanDatabase();
    });

    group('_getFreshMedication', () {
      test('returns medication when it exists', () async {
        // Arrange
        final medication = createTestMedication(
          name: 'Aspirin',
          type: MedicationType.pill,
        );
        await DatabaseHelper.instance.insertMedication(medication);
        await DatabaseHelper.instance.assignMedicationToPerson(
          personId: testPerson.id,
          medicationId: medication.id,
          scheduleData: medication,
        );

        // Initialize viewModel with person context
        await viewModel.initialize(isTestMode: true);

        // Act
        final result = await viewModel.getFreshMedication(medication.id);

        // Assert
        expect(result, isNotNull);
        expect(result?.id, equals(medication.id));
        expect(result?.name, equals('Aspirin'));
      });

      test('returns null when medication does not exist', () async {
        // Arrange
        await viewModel.initialize(isTestMode: true);

        // Act
        final result = await viewModel.getFreshMedication('non-existent-id');

        // Assert
        expect(result, isNull);
      });
    });

    group('_getPersonId', () {
      test('returns correct person ID when person is selected', () async {
        // Arrange
        await viewModel.initialize(isTestMode: true);

        // Act
        final personId = await viewModel.getPersonId();

        // Assert
        expect(personId, isNotEmpty);
        expect(personId, equals(testPerson.id));
      });

      test('returns default person ID when no person is selected', () async {
        // Arrange
        final anotherPerson = await createTestPerson(
          name: 'Another User',
          isDefault: false,
        );
        await viewModel.initialize(isTestMode: true);

        // Act
        final personId = await viewModel.getPersonId();

        // Assert
        expect(personId, equals(testPerson.id)); // Should be default person
      });
    });
  });

  group('MedicationListViewModel - Dose Registration', () {
    late MedicationListViewModel viewModel;
    late Person testPerson;
    late Medication medication;

    setUp(() async {
      await DatabaseTestHelper.cleanDatabase();
      await DatabaseTestHelper.ensureDefaultPerson();
      viewModel = MedicationListViewModel();
      testPerson = await getDefaultPerson();

      medication = createTestMedication(
        name: 'Test Med',
        type: MedicationType.pill,
        doseSchedule: {'08:00': 1.0, '20:00': 1.0},
        stockQuantity: 50.0,
      );

      await DatabaseHelper.instance.insertMedication(medication);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPerson.id,
        medicationId: medication.id,
        scheduleData: medication,
      );

      await viewModel.initialize(isTestMode: true);
    });

    tearDown(() async {
      viewModel.dispose();
      await DatabaseTestHelper.cleanDatabase();
    });

    test('registerDose successfully registers a dose', () async {
      // Act
      final result = await viewModel.registerDose(
        medication: medication,
        doseTime: '08:00',
      );

      // Assert
      expect(result, isNotEmpty);
      expect(result, contains('remaining|1|')); // 1 remaining dose

      // Verify medication was updated
      final updatedMed = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        testPerson.id,
      );
      expect(updatedMed?.takenDosesToday, contains('08:00'));
      expect(updatedMed?.stockQuantity, equals(49.0)); // 50 - 1
    });

    test('registerDose throws InsufficientStockException when stock is low', () async {
      // Arrange - Create medication with insufficient stock
      final lowStockMed = createTestMedication(
        name: 'Low Stock Med',
        type: MedicationType.pill,
        doseSchedule: {'08:00': 5.0},
        stockQuantity: 2.0, // Less than dose quantity
      );

      await DatabaseHelper.instance.insertMedication(lowStockMed);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPerson.id,
        medicationId: lowStockMed.id,
        scheduleData: lowStockMed,
      );

      // Act & Assert
      expect(
        () => viewModel.registerDose(
          medication: lowStockMed,
          doseTime: '08:00',
        ),
        throwsA(isA<InsufficientStockException>()),
      );
    });

    test('registerDose updates takenDosesDate correctly', () async {
      // Act
      await viewModel.registerDose(
        medication: medication,
        doseTime: '08:00',
      );

      // Assert
      final updatedMed = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        testPerson.id,
      );
      expect(updatedMed?.takenDosesDate, equals(DateTime.now().toDateString()));
    });

    test('registerDose creates correct history entry', () async {
      // Act
      await viewModel.registerDose(
        medication: medication,
        doseTime: '08:00',
      );

      // Assert
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication(
        medication.id,
      );
      expect(history, hasLength(1));
      expect(history.first.medicationId, equals(medication.id));
      expect(history.first.status.name, equals('taken'));
      expect(history.first.quantity, equals(1.0));
    });
  });

  group('MedicationListViewModel - Extra Dose Registration', () {
    late MedicationListViewModel viewModel;
    late Person testPerson;
    late Medication medication;

    setUp(() async {
      await DatabaseTestHelper.cleanDatabase();
      await DatabaseTestHelper.ensureDefaultPerson();
      viewModel = MedicationListViewModel();
      testPerson = await getDefaultPerson();

      medication = createTestMedication(
        name: 'Test Med',
        type: MedicationType.pill,
        doseSchedule: {'08:00': 2.0},
        stockQuantity: 50.0,
      );

      await DatabaseHelper.instance.insertMedication(medication);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPerson.id,
        medicationId: medication.id,
        scheduleData: medication,
      );

      await viewModel.initialize(isTestMode: true);
    });

    tearDown(() async {
      viewModel.dispose();
      await DatabaseTestHelper.cleanDatabase();
    });

    test('registerExtraDose successfully registers extra dose', () async {
      // Act
      final result = await viewModel.registerExtraDose(
        medication: medication,
      );

      // Assert
      expect(result, isNotEmpty);
      expect(result, contains('|')); // Contains pipe-separated data

      // Verify stock was reduced
      final updatedMed = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        testPerson.id,
      );
      expect(updatedMed?.stockQuantity, equals(48.0)); // 50 - 2
    });

    test('registerExtraDose creates history entry with isExtraDose flag', () async {
      // Act
      await viewModel.registerExtraDose(medication: medication);

      // Assert
      final history = await DatabaseHelper.instance.getDoseHistoryForMedication(
        medication.id,
      );
      expect(history, hasLength(1));
      expect(history.first.isExtraDose, isTrue);
    });
  });

  group('MedicationListViewModel - Initialization', () {
    late MedicationListViewModel viewModel;

    setUp(() async {
      await DatabaseTestHelper.cleanDatabase();
      await DatabaseTestHelper.ensureDefaultPerson();
      viewModel = MedicationListViewModel();
    });

    tearDown(() async {
      viewModel.dispose();
      await DatabaseTestHelper.cleanDatabase();
    });

    test('initialize loads persons correctly', () async {
      // Arrange
      // Default person already exists from setUp
      await createTestPerson(name: 'Person 2', isDefault: false);

      // Act
      await viewModel.initialize(isTestMode: true);

      // Assert
      expect(viewModel.persons, hasLength(2));
      expect(viewModel.selectedPerson, isNotNull);
      expect(viewModel.selectedPerson?.isDefault, isTrue);
    });

    test('initialize sets isLoading correctly', () async {
      // Arrange
      // Default person already exists from setUp
      expect(viewModel.isLoading, isTrue); // Initially true

      // Act
      await viewModel.initialize(isTestMode: true);

      // Assert
      expect(viewModel.isLoading, isFalse);
    });
  });

  group('MedicationListViewModel - Person Selection', () {
    late MedicationListViewModel viewModel;
    late Person person1;
    late Person person2;

    setUp(() async {
      await DatabaseTestHelper.cleanDatabase();
      await DatabaseTestHelper.ensureDefaultPerson();
      viewModel = MedicationListViewModel();
      person1 = await getDefaultPerson();
      person2 = await createTestPerson(name: 'Person 2', isDefault: false);
      await viewModel.initialize(isTestMode: true);
    });

    tearDown(() async {
      viewModel.dispose();
      await DatabaseTestHelper.cleanDatabase();
    });

    test('selectPerson changes selected person', () async {
      // Assert initial state
      expect(viewModel.selectedPerson?.id, equals(person1.id));

      // Act
      await viewModel.selectPerson(person2);

      // Assert
      expect(viewModel.selectedPerson?.id, equals(person2.id));
    });

    test('selectPerson does not change if same person selected', () async {
      // Arrange
      final initialPerson = viewModel.selectedPerson;

      // Act
      await viewModel.selectPerson(person1);

      // Assert
      expect(viewModel.selectedPerson, equals(initialPerson));
    });
  });
}
