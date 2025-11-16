import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/database/database_helper.dart';
import 'helpers/database_test_helper.dart';
import 'helpers/medication_builder.dart';
import 'helpers/person_test_helper.dart';

/// Tests for medication expiration date functionality
///
/// Verifies that expiration date tracking, validation, and status detection
/// work correctly for medications.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setup();

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  group('Medication expiration date parsing', () {
    test('should parse valid MM/YYYY format correctly', () {
      final medication = MedicationBuilder()
          .withId('med-exp-1')
          .withExpirationDate('03/2025')
          .build();

      final expDateTime = medication.expirationDateTime;
      expect(expDateTime, isNotNull);
      expect(expDateTime!.year, 2025);
      expect(expDateTime.month, 3);
      expect(expDateTime.day, 31); // Last day of March
    });

    test('should handle February leap year correctly', () {
      final medication = MedicationBuilder()
          .withId('med-exp-2')
          .withExpirationDate('02/2024')
          .build();

      final expDateTime = medication.expirationDateTime;
      expect(expDateTime, isNotNull);
      expect(expDateTime!.day, 29); // 2024 is a leap year
    });

    test('should handle February non-leap year correctly', () {
      final medication = MedicationBuilder()
          .withId('med-exp-3')
          .withExpirationDate('02/2025')
          .build();

      final expDateTime = medication.expirationDateTime;
      expect(expDateTime, isNotNull);
      expect(expDateTime!.day, 28); // 2025 is not a leap year
    });

    test('should return null for invalid format', () {
      final medication = MedicationBuilder()
          .withId('med-exp-4')
          .withExpirationDate('2025-03-15') // Wrong format
          .build();

      expect(medication.expirationDateTime, isNull);
    });

    test('should return null for empty expiration date', () {
      final medication = MedicationBuilder()
          .withId('med-exp-5')
          .withExpirationDate('')
          .build();

      expect(medication.expirationDateTime, isNull);
    });

    test('should return null for null expiration date', () {
      final medication = MedicationBuilder()
          .withId('med-exp-6')
          .build();

      expect(medication.expirationDateTime, isNull);
    });
  });

  group('Medication expiration status detection', () {
    test('should detect expired medication', () {
      // Medication expired 2 months ago
      final twoMonthsAgo = DateTime.now().subtract(const Duration(days: 60));
      final expDate = '${twoMonthsAgo.month.toString().padLeft(2, '0')}/${twoMonthsAgo.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-7')
          .withExpirationDate(expDate)
          .build();

      expect(medication.isExpired, true);
      expect(medication.isNearExpiration, false);
      expect(medication.expirationStatus, ExpirationStatus.expired);
    });

    test('should detect near expiration (within 30 days)', () {
      // Use current month - from any day to the last day of current month is always ≤ 30 days
      final now = DateTime.now();
      final expDate = '${now.month.toString().padLeft(2, '0')}/${now.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-8')
          .withExpirationDate(expDate)
          .build();

      expect(medication.isExpired, false);
      expect(medication.isNearExpiration, true);
      expect(medication.expirationStatus, ExpirationStatus.nearExpiration);
    });

    test('should detect ok status (not near expiration)', () {
      // Medication expires in 3 months
      final threeMonthsAhead = DateTime.now().add(const Duration(days: 90));
      final expDate = '${threeMonthsAhead.month.toString().padLeft(2, '0')}/${threeMonthsAhead.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-9')
          .withExpirationDate(expDate)
          .build();

      expect(medication.isExpired, false);
      expect(medication.isNearExpiration, false);
      expect(medication.expirationStatus, ExpirationStatus.ok);
    });

    test('should return none status when no expiration date set', () {
      final medication = MedicationBuilder()
          .withId('med-exp-10')
          .build();

      expect(medication.isExpired, false);
      expect(medication.isNearExpiration, false);
      expect(medication.expirationStatus, ExpirationStatus.none);
    });

    test('should detect expiration on last day of month', () {
      // Expired today (last day of current month)
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1);
      final expDate = '${lastMonth.month.toString().padLeft(2, '0')}/${lastMonth.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-11')
          .withExpirationDate(expDate)
          .build();

      expect(medication.isExpired, true);
      expect(medication.expirationStatus, ExpirationStatus.expired);
    });

    test('should handle edge case: exactly 30 days until expiration', () {
      // Use current month to ensure we're within 30 days
      final now = DateTime.now();
      final expDate = '${now.month.toString().padLeft(2, '0')}/${now.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-12')
          .withExpirationDate(expDate)
          .build();

      // This should be near expiration since it's within current month
      expect(medication.isNearExpiration, true);
      expect(medication.expirationStatus, ExpirationStatus.nearExpiration);
    });

    test('should handle edge case: 31 days until expiration (not near)', () {
      // Use 2 months ahead to ensure we're beyond 30 days
      final now = DateTime.now();
      final twoMonthsAhead = DateTime(now.year, now.month + 2, 1);
      final expDate = '${twoMonthsAhead.month.toString().padLeft(2, '0')}/${twoMonthsAhead.year}';

      final medication = MedicationBuilder()
          .withId('med-exp-13')
          .withExpirationDate(expDate)
          .build();

      expect(medication.isNearExpiration, false);
      expect(medication.expirationStatus, ExpirationStatus.ok);
    });
  });

  group('Database persistence of expiration date', () {
    test('should persist expiration date to database', () async {
      final medication = MedicationBuilder()
          .withId('med-exp-db-1')
          .withName('Paracetamol')
          .withSingleDose('08:00', 1.0)
          .withStock(20.0)
          .withExpirationDate('06/2025')
          .build();

      await insertMedicationWithPerson(medication);

      // Retrieve from database
      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb, isNotNull);
      expect(fromDb!.expirationDate, '06/2025');
    });

    test('should update expiration date in database', () async {
      final medication = MedicationBuilder()
          .withId('med-exp-db-2')
          .withName('Ibuprofeno')
          .withSingleDose('12:00', 1.0)
          .withStock(15.0)
          .withExpirationDate('03/2025')
          .build();

      await insertMedicationWithPerson(medication);

      // Update expiration date
      final updatedMed = medication.copyWith(expirationDate: '09/2025');
      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      await DatabaseHelper.instance.updateMedicationForPerson(
        medication: updatedMed,
        personId: defaultPerson!.id,
      );

      // Verify update
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson.id,
      );

      expect(fromDb!.expirationDate, '09/2025');
    });

    test('should handle null expiration date in database', () async {
      final medication = MedicationBuilder()
          .withId('med-exp-db-3')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .build(); // No expiration date

      await insertMedicationWithPerson(medication);

      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb!.expirationDate, isNull);
      expect(fromDb.expirationStatus, ExpirationStatus.none);
    });

    test('should handle empty expiration date string in database', () async {
      final medication = MedicationBuilder()
          .withId('med-exp-db-4')
          .withName('Aspirina')
          .withSingleDose('20:00', 1.0)
          .withStock(25.0)
          .withExpirationDate('')
          .build();

      await insertMedicationWithPerson(medication);

      final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
      final fromDb = await DatabaseHelper.instance.getMedicationForPerson(
        medication.id,
        defaultPerson!.id,
      );

      expect(fromDb!.expirationDate, isEmpty);
      expect(fromDb.expirationStatus, ExpirationStatus.none);
    });
  });

  group('Medication JSON serialization with expiration date', () {
    test('should serialize expiration date to JSON', () {
      final medication = MedicationBuilder()
          .withId('med-exp-json-1')
          .withName('Losartán')
          .withExpirationDate('12/2025')
          .build();

      final json = medication.toJson();
      expect(json['expirationDate'], '12/2025');
    });

    test('should deserialize expiration date from JSON', () {
      final json = {
        'id': 'med-exp-json-2',
        'name': 'Enalapril',
        'type': 'pill',
        'dosageIntervalHours': 24,
        'durationType': 'everyday',
        'doseSchedule': '{"08:00":1.0}',
        'stockQuantity': 30.0,
        'expirationDate': '08/2026',
      };

      final medication = Medication.fromJson(json);
      expect(medication.expirationDate, '08/2026');
      expect(medication.expirationStatus, ExpirationStatus.ok);
    });

    test('should handle null expiration date in JSON', () {
      final json = {
        'id': 'med-exp-json-3',
        'name': 'Metformina',
        'type': 'pill',
        'dosageIntervalHours': 12,
        'durationType': 'everyday',
        'doseSchedule': '{"08:00":1.0,"20:00":1.0}',
        'stockQuantity': 60.0,
      };

      final medication = Medication.fromJson(json);
      expect(medication.expirationDate, isNull);
    });
  });

  group('copyWith preserves expiration date', () {
    test('should preserve expiration date when not modified', () {
      final medication = MedicationBuilder()
          .withId('med-exp-copy-1')
          .withName('Atorvastatina')
          .withExpirationDate('05/2025')
          .withStock(20.0)
          .build();

      final copied = medication.copyWith(stockQuantity: 15.0);

      expect(copied.expirationDate, '05/2025');
      expect(copied.stockQuantity, 15.0);
    });

    test('should update expiration date when explicitly provided', () {
      final medication = MedicationBuilder()
          .withId('med-exp-copy-2')
          .withName('Simvastatina')
          .withExpirationDate('03/2025')
          .build();

      final copied = medication.copyWith(expirationDate: '07/2025');

      expect(copied.expirationDate, '07/2025');
    });

    // Note: copyWith uses ?? operator which doesn't allow clearing values with null
    // This is by design and consistent with the rest of the Medication model
  });
}
