import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/treatment_duration_type.dart';
import 'package:medicapp/models/person.dart';
import 'package:medicapp/screens/medication_list/medication_list_viewmodel.dart';
import 'package:medicapp/utils/datetime_extensions.dart';
import 'helpers/medication_builder.dart';
import 'helpers/database_test_helper.dart';

void main() {
  late DatabaseHelper db;

  // Setup database for all tests
  DatabaseTestHelper.setupAll();

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.cleanDatabase();
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  group('Day Navigation - ViewModel', () {
    test('loadMedicationsForDate loads today correctly', () async {
      // Get default person
      final person = await db.getDefaultPerson();
      expect(person, isNotNull);

      // Create a ViewModel
      final viewModel = MedicationListViewModel();
      await viewModel.initialize(isTestMode: true);

      // Create a medication
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Test Med')
          .withMultipleDoses(['08:00', '20:00'], 1.0)
          .withStock(100)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      await db.createMedicationForPerson(
        medication: medication,
        personId: person!.id,
      );

      // Load medications for today
      final today = DateTime.now();
      await viewModel.loadMedicationsForDate(today);

      // Verify medications loaded
      expect(viewModel.medications.length, 1);
      expect(viewModel.medications.first.name, 'Test Med');

      viewModel.dispose();
    });

    test('loadMedicationsForDate loads historical data correctly', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayNormalized = DateTime(yesterday.year, yesterday.month, yesterday.day);

      // Get default person
      final person = await db.getDefaultPerson();
      expect(person, isNotNull);

      // Create a ViewModel
      final viewModel = MedicationListViewModel();
      await viewModel.initialize(isTestMode: true);

      // Create a medication
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Test Med')
          .withMultipleDoses(['08:00', '20:00'], 1.0)
          .withStock(100)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      await db.createMedicationForPerson(
        medication: medication,
        personId: person!.id,
      );

      // Create history entries for yesterday
      final entry1 = DoseHistoryEntry(
        id: 'entry1',
        medicationId: 'med1',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: person.id,
        scheduledDateTime: yesterdayNormalized.add(const Duration(hours: 8)),
        registeredDateTime: yesterdayNormalized.add(const Duration(hours: 8, minutes: 5)),
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      final entry2 = DoseHistoryEntry(
        id: 'entry2',
        medicationId: 'med1',
        medicationName: 'Test Med',
        medicationType: MedicationType.pill,
        personId: person.id,
        scheduledDateTime: yesterdayNormalized.add(const Duration(hours: 20)),
        registeredDateTime: yesterdayNormalized.add(const Duration(hours: 20, minutes: 5)),
        status: DoseStatus.skipped,
        quantity: 1.0,
      );

      await db.insertDoseHistory(entry1);
      await db.insertDoseHistory(entry2);

      // Load medications for yesterday
      await viewModel.loadMedicationsForDate(yesterday);

      // Verify medications loaded with historical data
      expect(viewModel.medications.length, 1);
      final loadedMed = viewModel.medications.first;
      expect(loadedMed.name, 'Test Med');
      expect(loadedMed.takenDosesToday.contains('08:00'), isTrue);
      expect(loadedMed.skippedDosesToday.contains('20:00'), isTrue);
      expect(loadedMed.takenDosesDate, yesterdayNormalized.toDateString());

      viewModel.dispose();
    });

    test('loadMedicationsForDate shows as-needed meds only if taken on that day', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayNormalized = DateTime(yesterday.year, yesterday.month, yesterday.day);

      // Get default person
      final person = await db.getDefaultPerson();
      expect(person, isNotNull);

      // Create a ViewModel
      final viewModel = MedicationListViewModel();
      await viewModel.initialize(isTestMode: true);

      // Create an as-needed medication
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('As Needed Med')
          .withAsNeeded()
          .withStock(100)
          .build();

      await db.createMedicationForPerson(
        medication: medication,
        personId: person!.id,
      );

      // Create history entry for yesterday
      final entry = DoseHistoryEntry(
        id: 'entry1',
        medicationId: 'med1',
        medicationName: 'As Needed Med',
        medicationType: MedicationType.pill,
        personId: person.id,
        scheduledDateTime: yesterdayNormalized.add(const Duration(hours: 10)),
        registeredDateTime: yesterdayNormalized.add(const Duration(hours: 10, minutes: 5)),
        status: DoseStatus.taken,
        quantity: 1.0,
      );

      await db.insertDoseHistory(entry);

      // Load medications for yesterday - should show the as-needed med
      await viewModel.loadMedicationsForDate(yesterday);
      expect(viewModel.medications.length, 1);
      expect(viewModel.medications.first.name, 'As Needed Med');

      // Load medications for today - should NOT show the as-needed med (not taken today)
      await viewModel.loadMedicationsForDate(DateTime.now());
      expect(viewModel.medications.where((m) => m.name == 'As Needed Med').length, 0);

      viewModel.dispose();
    });

    test('loadMedicationsForDate shows scheduled meds even without history', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      // Get default person
      final person = await db.getDefaultPerson();
      expect(person, isNotNull);

      // Create a ViewModel
      final viewModel = MedicationListViewModel();
      await viewModel.initialize(isTestMode: true);

      // Create a scheduled medication
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Scheduled Med')
          .withMultipleDoses(['08:00', '20:00'], 1.0)
          .withStock(100)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      await db.createMedicationForPerson(
        medication: medication,
        personId: person!.id,
      );

      // Load medications for yesterday - should show even without history
      await viewModel.loadMedicationsForDate(yesterday);
      expect(viewModel.medications.length, 1);
      expect(viewModel.medications.first.name, 'Scheduled Med');

      // Should have empty dose lists (no history for that day)
      expect(viewModel.medications.first.takenDosesToday.isEmpty, isTrue);
      expect(viewModel.medications.first.skippedDosesToday.isEmpty, isTrue);

      viewModel.dispose();
    });

    test('loadMedicationsForDate filters by person', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayNormalized = DateTime(yesterday.year, yesterday.month, yesterday.day);

      // Get default person
      final person1 = await db.getDefaultPerson();
      expect(person1, isNotNull);

      // Create another person
      final person2 = Person(
        id: 'person2',
        name: 'Person 2',
        isDefault: false,
      );
      await db.insertPerson(person2);

      // Create a ViewModel
      final viewModel = MedicationListViewModel();
      await viewModel.initialize(isTestMode: true);

      // Create medications for different persons
      final med1 = MedicationBuilder()
          .withId('med1')
          .withName('Med for Person 1')
          .withMultipleDoses(['08:00'], 1.0)
          .withStock(100)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      final med2 = MedicationBuilder()
          .withId('med2')
          .withName('Med for Person 2')
          .withMultipleDoses(['08:00'], 1.0)
          .withStock(100)
          .withDurationType(TreatmentDurationType.everyday)
          .build();

      await db.createMedicationForPerson(medication: med1, personId: person1!.id);
      await db.createMedicationForPerson(medication: med2, personId: person2.id);

      // Create history for both
      await db.insertDoseHistory(DoseHistoryEntry(
        id: 'entry1',
        medicationId: 'med1',
        medicationName: 'Med for Person 1',
        medicationType: MedicationType.pill,
        personId: person1.id,
        scheduledDateTime: yesterdayNormalized.add(const Duration(hours: 8)),
        registeredDateTime: yesterdayNormalized.add(const Duration(hours: 8)),
        status: DoseStatus.taken,
        quantity: 1.0,
      ));

      await db.insertDoseHistory(DoseHistoryEntry(
        id: 'entry2',
        medicationId: 'med2',
        medicationName: 'Med for Person 2',
        medicationType: MedicationType.pill,
        personId: person2.id,
        scheduledDateTime: yesterdayNormalized.add(const Duration(hours: 8)),
        registeredDateTime: yesterdayNormalized.add(const Duration(hours: 8)),
        status: DoseStatus.taken,
        quantity: 1.0,
      ));

      // Load for person 1 (default person selected during initialization)
      await viewModel.loadMedicationsForDate(yesterday);
      expect(viewModel.medications.length, 1);
      expect(viewModel.medications.first.name, 'Med for Person 1');

      viewModel.dispose();
    });
  });
}
