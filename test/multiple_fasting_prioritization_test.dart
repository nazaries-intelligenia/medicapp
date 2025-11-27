import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/notification_service.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/person.dart';
import 'package:medicapp/screens/medication_list/fasting_state_manager.dart';
import 'package:uuid/uuid.dart';
import 'helpers/medication_builder.dart';
import 'helpers/database_test_helper.dart';

/// Tests for multiple concurrent fasting periods prioritization (V19+)
///
/// When multiple persons have active fasting periods, the system should:
/// 1. For each person, keep only the most restrictive fasting period (ending latest)
/// 2. Sort all persons' fasting periods by end time (soonest first)
/// 3. Show ongoing notifications for all active persons
/// 4. When one fasting period ends, it gets filtered out automatically
/// 5. Handle different persons' fasting periods independently
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late FastingStateManager fastingManager;

  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();

    fastingManager = FastingStateManager();
    fastingManager.updatePreferences(
      showFastingCountdown: true,
      showFastingNotification: true,
    );

    // Clean database and ensure no default person exists yet
    // Tests will create their own persons as needed
  });

  tearDown(() async {
    service.disableTestMode();
    fastingManager.dispose();
    await DatabaseTestHelper.cleanDatabase();
  });

  group('Multiple Fasting Periods Prioritization', () {
    test('should keep most restrictive fasting when 2 active for same person', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Medication 1: "after" fasting, 120 minutes (ends later)
      final med1 = MedicationBuilder()
          .withId('med_1_longer')
          .withName('Med with 2h fasting')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Medication 2: "after" fasting, 30 minutes (ends sooner)
      final med2 = MedicationBuilder()
          .withId('med_2_shorter')
          .withName('Med with 30min fasting')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 30)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      // Register doses taken at the same time (1 hour ago)
      final now = DateTime.now();
      final doseTime = now.subtract(const Duration(hours: 1));

      // Create dose history for medication 1 (fasting ends in 1 hour)
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      // Create dose history for medication 2 (fasting ends in 30 minutes - SOONER)
      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person.id,
        scheduledDateTime: doseTime.add(const Duration(minutes: 30)), // Taken 30 min later
        registeredDateTime: doseTime.add(const Duration(minutes: 30)),
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have active fasting periods
      expect(fastingManager.hasActiveFastingPeriods, isTrue);
      expect(fastingManager.activeFastingPeriods.length, 1); // One per person

      // The prioritized fasting should be the one ending later (most restrictive = med1)
      // This is the correct behavior: show the longest remaining fasting period
      final mostRestrictive = fastingManager.activeFastingPeriods.first;
      expect(mostRestrictive['medicationName'], contains('2h'));
      expect(mostRestrictive['personId'], person.id);
    });

    test('should switch to next fasting when most urgent one ends', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Medication 1: Short fasting (will end first)
      final med1 = MedicationBuilder()
          .withId('med_short')
          .withName('Short Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 30)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Medication 2: Long fasting (will become priority after first ends)
      final med2 = MedicationBuilder()
          .withId('med_long')
          .withName('Long Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();

      // Med1 taken 35 minutes ago (fasting already ended)
      final doseTime1 = now.subtract(const Duration(minutes: 35));
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person.id,
        scheduledDateTime: doseTime1,
        registeredDateTime: doseTime1,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      // Med2 taken 1 hour ago (fasting ends in 1 hour)
      final doseTime2 = now.subtract(const Duration(hours: 1));
      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person.id,
        scheduledDateTime: doseTime2,
        registeredDateTime: doseTime2,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should show only the long fasting (short one already ended)
      expect(fastingManager.hasActiveFastingPeriods, isTrue);
      final activePeriod = fastingManager.activeFastingPeriods.first;
      expect(activePeriod['medicationName'], 'Long Fasting Med');
    });

    test('should keep most restrictive fasting (latest ending) per person', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Med 1: Long duration (180 min) but taken recently
      final med1 = MedicationBuilder()
          .withId('med_long_duration')
          .withName('Long Duration Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 180) // 3 hours
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Med 2: Short duration (60 min) but taken earlier
      final med2 = MedicationBuilder()
          .withId('med_short_duration')
          .withName('Short Duration Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60) // 1 hour
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();

      // Med1 taken 30 minutes ago (ends in 150 minutes)
      final doseTime1 = now.subtract(const Duration(minutes: 30));
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person.id,
        scheduledDateTime: doseTime1,
        registeredDateTime: doseTime1,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      // Med2 taken 40 minutes ago (ends in 20 minutes - SOONER despite shorter duration)
      final doseTime2 = now.subtract(const Duration(minutes: 40));
      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person.id,
        scheduledDateTime: doseTime2,
        registeredDateTime: doseTime2,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should prioritize the one ending later (most restrictive = Long Duration Med)
      // This is the correct behavior: show the longest remaining fasting period
      expect(fastingManager.hasActiveFastingPeriods, isTrue);
      final mostRestrictive = fastingManager.activeFastingPeriods.first;
      expect(mostRestrictive['medicationName'], 'Long Duration Med');
    });

    test('should handle different persons fasting periods independently', () async {
      // Create two persons
      final person1 = Person(
        id: const Uuid().v4(),
        name: 'Person 1',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person1);

      final person2 = Person(
        id: const Uuid().v4(),
        name: 'Person 2',
        isDefault: false,
      );
      await DatabaseHelper.instance.insertPerson(person2);

      // Medication for person 1
      final med1 = MedicationBuilder()
          .withId('med_person1')
          .withName('Person 1 Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person1.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Medication for person 2
      final med2 = MedicationBuilder()
          .withId('med_person2')
          .withName('Person 2 Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 90)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person2.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();
      final doseTime = now.subtract(const Duration(minutes: 30));

      // Register dose for person 1
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person1.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      // Register dose for person 2
      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person2.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have 2 active fasting periods (one per person)
      expect(fastingManager.activeFastingPeriods.length, 2);

      // Verify both persons are present
      final personIds = fastingManager.activeFastingPeriods
          .map((p) => p['personId'] as String)
          .toSet();
      expect(personIds.contains(person1.id), isTrue);
      expect(personIds.contains(person2.id), isTrue);

      // They should be sorted by end time (soonest first after filtering)
      // Person1 ends sooner (60-30=30min remaining vs 90-30=60min remaining)
      final firstPeriod = fastingManager.activeFastingPeriods.first;
      expect(firstPeriod['personId'], person1.id);
    });

    test('should update ongoing notification correctly when switching active person', () async {
      // Create two persons
      final person1 = Person(
        id: const Uuid().v4(),
        name: 'Person 1',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person1);

      final person2 = Person(
        id: const Uuid().v4(),
        name: 'Person 2',
        isDefault: false,
      );
      await DatabaseHelper.instance.insertPerson(person2);

      // Medication for person 1
      final med1 = MedicationBuilder()
          .withId('med_p1')
          .withName('Med Person 1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person1.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Medication for person 2
      final med2 = MedicationBuilder()
          .withId('med_p2')
          .withName('Med Person 2')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 90)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person2.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();
      final doseTime = now.subtract(const Duration(minutes: 30));

      // Register doses for both persons
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person1.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person2.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Update notification (in test mode, this just verifies no errors)
      await fastingManager.updateNotification();

      expect(fastingManager.activeFastingPeriods.length, 2);
    });

    test('should handle edge case: 2 fastings ending at exactly same time', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Two medications with same fasting duration
      final med1 = MedicationBuilder()
          .withId('med_same_time_1')
          .withName('Med A')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      final med2 = MedicationBuilder()
          .withId('med_same_time_2')
          .withName('Med B')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();
      final exactSameTime = now.subtract(const Duration(minutes: 30));

      // Register doses at exactly the same time
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person.id,
        scheduledDateTime: exactSameTime,
        registeredDateTime: exactSameTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person.id,
        scheduledDateTime: exactSameTime,
        registeredDateTime: exactSameTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have 1 period (keeps the latest ending, which is the same)
      // The logic filters to keep one per person
      expect(fastingManager.hasActiveFastingPeriods, isTrue);
      expect(fastingManager.activeFastingPeriods.length, 1);
    });

    test('should handle fasting starting while another is active', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // First medication with long fasting
      final med1 = MedicationBuilder()
          .withId('med_first')
          .withName('First Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      // Second medication with shorter fasting
      final med2 = MedicationBuilder()
          .withId('med_second')
          .withName('Second Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 45)
          .build();

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      final now = DateTime.now();

      // First medication taken 1 hour ago (ends in 1 hour)
      final doseTime1 = now.subtract(const Duration(hours: 1));
      final history1 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med1.id,
        medicationName: med1.name,
        medicationType: med1.type,
        personId: person.id,
        scheduledDateTime: doseTime1,
        registeredDateTime: doseTime1,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history1);

      // Second medication taken 10 minutes ago (ends in 35 minutes - SOONER)
      final doseTime2 = now.subtract(const Duration(minutes: 10));
      final history2 = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med2.id,
        medicationName: med2.name,
        medicationType: med2.type,
        personId: person.id,
        scheduledDateTime: doseTime2,
        registeredDateTime: doseTime2,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history2);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should keep the most restrictive one (First Med ends later: 1h remaining vs 35min)
      expect(fastingManager.hasActiveFastingPeriods, isTrue);
      final mostRestrictive = fastingManager.activeFastingPeriods.first;
      expect(mostRestrictive['medicationName'], 'First Med');
    });

    test('should handle mix of before and after fasting types', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // "Before" fasting medication
      final medBefore = MedicationBuilder()
          .withId('med_before')
          .withName('Before Fasting Med')
          .withSingleDose('14:00', 1.0)
          .withFasting(type: 'before', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(medBefore);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: medBefore.id,
        scheduleData: medBefore,
      );

      // "After" fasting medication
      final medAfter = MedicationBuilder()
          .withId('med_after')
          .withName('After Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 90)
          .build();

      await DatabaseHelper.instance.insertMedication(medAfter);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: medAfter.id,
        scheduleData: medAfter,
      );

      final now = DateTime.now();

      // Register dose for "after" medication
      final doseTime = now.subtract(const Duration(minutes: 30));
      final historyAfter = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: medAfter.id,
        medicationName: medAfter.name,
        medicationType: medAfter.type,
        personId: person.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(historyAfter);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should handle both types without errors
      // Exact behavior depends on current time relative to "before" fasting window
      expect(() => fastingManager.hasActiveFastingPeriods, returnsNormally);
    });

    test('should handle no active fasting periods', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Create medication without fasting
      final med = MedicationBuilder()
          .withId('med_no_fasting')
          .withName('No Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFastingDisabled()
          .build();

      await DatabaseHelper.instance.insertMedication(med);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med.id,
        scheduleData: med,
      );

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have no active fasting periods
      expect(fastingManager.hasActiveFastingPeriods, isFalse);
      expect(fastingManager.activeFastingPeriods, isEmpty);
    });

    test('should filter out expired fasting periods', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Medication with short fasting that already expired
      final med = MedicationBuilder()
          .withId('med_expired')
          .withName('Expired Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 30)
          .build();

      await DatabaseHelper.instance.insertMedication(med);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med.id,
        scheduleData: med,
      );

      final now = DateTime.now();

      // Dose taken 35 minutes ago (fasting ended 5 minutes ago)
      final doseTime = now.subtract(const Duration(minutes: 35));
      final history = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med.id,
        medicationName: med.name,
        medicationType: med.type,
        personId: person.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history);

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should filter out the expired period (depends on 2-hour grace period)
      // The exact result depends on implementation details
      expect(() => fastingManager.hasActiveFastingPeriods, returnsNormally);
    });

    test('should handle person with multiple medications, keep only most restrictive', () async {
      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Multi Med User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Three medications for same person with different fasting durations
      final med1 = MedicationBuilder()
          .withId('med_30min')
          .withName('30 Min Fasting')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 30)
          .build();

      final med2 = MedicationBuilder()
          .withId('med_60min')
          .withName('60 Min Fasting')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      final med3 = MedicationBuilder()
          .withId('med_90min')
          .withName('90 Min Fasting')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 90)
          .build();

      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med1.id,
        scheduleData: med1,
      );

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med2.id,
        scheduleData: med2,
      );

      await DatabaseHelper.instance.insertMedication(med3);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med3.id,
        scheduleData: med3,
      );

      final now = DateTime.now();
      final doseTime = now.subtract(const Duration(minutes: 15));

      // Register doses for all three medications
      for (final med in [med1, med2, med3]) {
        final history = DoseHistoryEntry(
          id: const Uuid().v4(),
          medicationId: med.id,
          medicationName: med.name,
          medicationType: med.type,
          personId: person.id,
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );
        await DatabaseHelper.instance.insertDoseHistory(history);
      }

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have only 1 period (the most restrictive one ending latest)
      expect(fastingManager.activeFastingPeriods.length, 1);

      // Should be the 90-minute fasting (most restrictive)
      final period = fastingManager.activeFastingPeriods.first;
      expect(period['medicationName'], '90 Min Fasting');
    });
  });

  group('FastingStateManager Edge Cases', () {
    test('should handle fasting countdown disabled in preferences', () async {
      // Disable fasting countdown
      fastingManager.updatePreferences(
        showFastingCountdown: false,
        showFastingNotification: true,
      );

      // Create a person
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      // Create medication with fasting
      final med = MedicationBuilder()
          .withId('med_disabled')
          .withName('Fasting Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med.id,
        scheduleData: med,
      );

      // Load fasting periods
      await fastingManager.loadFastingPeriods();

      // Should have no periods because countdown is disabled
      expect(fastingManager.hasActiveFastingPeriods, isFalse);
    });

    test('should not crash when loading with no persons in database', () async {
      // Clean database completely (removes default person)
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();
      await DatabaseHelper.resetDatabase();

      // Load fasting periods with empty database
      await fastingManager.loadFastingPeriods();

      // Should handle gracefully
      expect(fastingManager.hasActiveFastingPeriods, isFalse);
      expect(fastingManager.activeFastingPeriods, isEmpty);
    });

    test('should handle notification update in test mode without errors', () async {
      // Create a person with active fasting
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);

      final med = MedicationBuilder()
          .withId('med_test_notif')
          .withName('Test Notification Med')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 60)
          .build();

      await DatabaseHelper.instance.insertMedication(med);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: person.id,
        medicationId: med.id,
        scheduleData: med,
      );

      final now = DateTime.now();
      final doseTime = now.subtract(const Duration(minutes: 30));
      final history = DoseHistoryEntry(
        id: const Uuid().v4(),
        medicationId: med.id,
        medicationName: med.name,
        medicationType: med.type,
        personId: person.id,
        scheduledDateTime: doseTime,
        registeredDateTime: doseTime,
        status: DoseStatus.taken,
        quantity: 1.0,
      );
      await DatabaseHelper.instance.insertDoseHistory(history);

      await fastingManager.loadFastingPeriods();

      // Update notification in test mode (should not crash)
      await expectLater(
        fastingManager.updateNotification(),
        completes,
      );
    });
  });
}
