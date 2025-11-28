// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/medication_type.dart';
import 'package:medicapp/models/person.dart';
import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'helpers/medication_builder.dart';
import 'helpers/database_test_helper.dart';

/// Mock of PathProviderPlatform for tests
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    // Use system temporary directory
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    // Create a temporary directory for documents
    final tempDir = Directory.systemTemp.createTempSync('medicapp_test_docs_');
    return tempDir.path;
  }
}

void main() {
  DatabaseTestHelper.setupAll();

  setUpAll(() {
    // Configure path provider mock
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  group('Database Export/Import - In-Memory Restrictions', () {
    setUp(() async {
      // Use in-memory database for these tests
      DatabaseHelper.setInMemoryDatabase(true);
      await DatabaseHelper.resetDatabase();
    });

    tearDown(() async {
      await DatabaseHelper.resetDatabase();
    });

    test('should throw exception when trying to export in-memory database', () async {
      expect(
        () => DatabaseHelper.instance.exportDatabase(),
        throwsException,
      );
    });

    test('should throw exception when trying to import to in-memory database', () async {
      expect(
        () => DatabaseHelper.instance.importDatabase('/fake/path.db'),
        throwsException,
      );
    });
  });

  group('Database Export', () {
    late Directory testDbDir;

    setUp(() async {
      // Create temporary directory for test database
      testDbDir = await Directory.systemTemp.createTemp('medicapp_test_db_');

      // Disable in-memory mode
      DatabaseHelper.setInMemoryDatabase(false);
      await DatabaseHelper.resetDatabase();

      // Clean all medications before each test
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();

      // Configure database path for tests
      databaseFactory = databaseFactoryFfi;
    });

    tearDown(() async {
      // Clean data before resetting
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();
      await DatabaseHelper.resetDatabase();

      // Clean temporary directory
      if (await testDbDir.exists()) {
        await testDbDir.delete(recursive: true);
      }
    });

    test('should export database to a file', () async {
      // Insert some test data
      final medication = MedicationBuilder()
          .withId('export_test_1')
          .withName('Test Medicine')
          .withType(MedicationType.pill)
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .build();

      await DatabaseHelper.instance.insertMedication(medication);

      // Export the database
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      // Verify that the file was created
      final exportFile = File(exportPath);
      expect(await exportFile.exists(), isTrue);
      expect(await exportFile.length(), greaterThan(0));

      // Clean exported file
      if (await exportFile.exists()) {
        await exportFile.delete();
      }
    });

    test('should throw exception when database file does not exist', () async {
      // Reset the database without creating the file
      await DatabaseHelper.resetDatabase();

      // Delete the database file if it exists
      final dbPath = await DatabaseHelper.instance.getDatabasePath();
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }

      // Attempting to export should fail
      expect(
        () => DatabaseHelper.instance.exportDatabase(),
        throwsException,
      );
    });

    test('should create export file with timestamp in name', () async {
      // Insert test data
      final medication = MedicationBuilder()
          .withId('export_test_2')
          .withName('Test Medicine 2')
          .build();

      await DatabaseHelper.instance.insertMedication(medication);

      // Export
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      // Verify that the name contains the expected pattern
      expect(exportPath, contains('medicapp_backup_'));
      expect(exportPath, endsWith('.db'));

      // Clean up
      final exportFile = File(exportPath);
      if (await exportFile.exists()) {
        await exportFile.delete();
      }
    });
  });

  group('Database Import', () {
    late Directory testDbDir;
    const testPersonId = 'test-person-export-import';
    Person? testPerson;

    setUp(() async {
      // Create temporary directory for test database
      testDbDir = await Directory.systemTemp.createTemp('medicapp_test_db_');

      // Disable in-memory mode
      DatabaseHelper.setInMemoryDatabase(false);
      await DatabaseHelper.resetDatabase();

      // Clean all medications before each test
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();

      // Create test person
      testPerson = Person(
        id: testPersonId,
        name: 'Test Person Export/Import',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(testPerson!);

      databaseFactory = databaseFactoryFfi;
    });

    tearDown(() async {
      // Clean up persona de prueba
      if (testPerson != null) {
        await DatabaseHelper.instance.deletePerson(testPersonId);
      }

      // Clean data before resetting
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();
      await DatabaseHelper.resetDatabase();

      // Clean temporary directory
      if (await testDbDir.exists()) {
        await testDbDir.delete(recursive: true);
      }
    });

    test('should import database and preserve all data', () async {
      // Create test medications
      final med1 = MedicationBuilder()
          .withId('import_test_1')
          .withName('Medicine 1')
          .withType(MedicationType.pill)
          .withSingleDose('08:00', 1.0)
          .withStock(30.0)
          .withLastRefill(50.0)
          .build();

      final med2 = MedicationBuilder()
          .withId('import_test_2')
          .withName('Medicine 2')
          .withType(MedicationType.syrup)
          .withSingleDose('20:00', 5.0)
          .withStock(100.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      // Insert medications and assign to person (v19+)
      await DatabaseHelper.instance.insertMedication(med1);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPersonId,
        medicationId: med1.id,
        scheduleData: med1,
      );

      await DatabaseHelper.instance.insertMedication(med2);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPersonId,
        medicationId: med2.id,
        scheduleData: med2,
      );

      // Export database
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      // Clean current database
      await DatabaseHelper.instance.deleteAllMedications();
      final medsBeforeImport = await DatabaseHelper.instance.getAllMedications();
      expect(medsBeforeImport.length, 0);

      // Import database
      await DatabaseHelper.instance.importDatabase(exportPath);

      // Verify that all data was imported
      final medsAfterImport = await DatabaseHelper.instance.getAllMedications();
      expect(medsAfterImport.length, 2);

      // Verify basic data (available in medications table)
      final imported1Basic = medsAfterImport.firstWhere((m) => m.id == 'import_test_1');
      expect(imported1Basic.name, 'Medicine 1');
      expect(imported1Basic.type, MedicationType.pill);
      expect(imported1Basic.stockQuantity, 30.0);
      expect(imported1Basic.lastRefillAmount, 50.0);

      // Verify person data (including fasting fields)
      final medsForPerson = await DatabaseHelper.instance.getMedicationsForPerson(testPersonId);
      expect(medsForPerson.length, 2);

      final imported2 = medsForPerson.firstWhere((m) => m.id == 'import_test_2');
      expect(imported2.name, 'Medicine 2');
      expect(imported2.type, MedicationType.syrup);
      expect(imported2.stockQuantity, 100.0);
      expect(imported2.requiresFasting, isTrue);
      expect(imported2.fastingType, 'after');
      expect(imported2.fastingDurationMinutes, 120);

      // Clean exported file
      final exportFile = File(exportPath);
      if (await exportFile.exists()) {
        await exportFile.delete();
      }
    });

    test('should throw exception when import file does not exist', () async {
      expect(
        () => DatabaseHelper.instance.importDatabase('/fake/nonexistent/path.db'),
        throwsException,
      );
    });

    test('should create backup before importing', () async {
      // Create initial medication
      final originalMed = MedicationBuilder()
          .withId('backup_test_1')
          .withName('Original Medicine')
          .build();

      await DatabaseHelper.instance.insertMedication(originalMed);

      // Create database to import
      final med2 = MedicationBuilder()
          .withId('backup_test_2')
          .withName('New Medicine')
          .build();

      // Export (this will create a temporary file)
      await DatabaseHelper.instance.insertMedication(med2);
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      // The import should create a backup
      await DatabaseHelper.instance.importDatabase(exportPath);

      // Verify that the backup was created
      final dbPath = await DatabaseHelper.instance.getDatabasePath();
      final backupPath = '$dbPath.backup';
      final backupFile = File(backupPath);

      // The backup should exist
      expect(await backupFile.exists(), isTrue);

      // Clean up
      final exportFile = File(exportPath);
      if (await exportFile.exists()) {
        await exportFile.delete();
      }
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    });

    test('should restore from backup if import fails', () async {
      // Create initial medication
      final originalMed = MedicationBuilder()
          .withId('restore_test_1')
          .withName('Original Medicine')
          .build();

      await DatabaseHelper.instance.insertMedication(originalMed);

      // Create corrupt file to import
      final corruptFile = File(join(testDbDir.path, 'corrupt.db'));
      await corruptFile.writeAsString('This is not a valid database file');

      // Attempting to import should fail
      try {
        await DatabaseHelper.instance.importDatabase(corruptFile.path);
        fail('Should have thrown an exception');
      } catch (e) {
        // We expect it to fail
        expect(e, isException);
      }

      // The original database should be intact
      final meds = await DatabaseHelper.instance.getAllMedications();
      expect(meds.length, 1);
      expect(meds[0].id, 'restore_test_1');
      expect(meds[0].name, 'Original Medicine');

      // Clean up
      if (await corruptFile.exists()) {
        await corruptFile.delete();
      }
    });

    test('should replace current database with imported one', () async {
      // Create original medications
      final originalMed1 = MedicationBuilder()
          .withId('replace_test_1')
          .withName('Original 1')
          .build();

      final originalMed2 = MedicationBuilder()
          .withId('replace_test_2')
          .withName('Original 2')
          .build();

      await DatabaseHelper.instance.insertMedication(originalMed1);
      await DatabaseHelper.instance.insertMedication(originalMed2);

      // Export
      final exportPath = await DatabaseHelper.instance.exportDatabase();

      // Change current database
      await DatabaseHelper.instance.deleteAllMedications();
      final newMed = MedicationBuilder()
          .withId('replace_test_3')
          .withName('New Medicine')
          .build();
      await DatabaseHelper.instance.insertMedication(newMed);

      // Verify state before importing
      final medsBeforeImport = await DatabaseHelper.instance.getAllMedications();
      expect(medsBeforeImport.length, 1);
      expect(medsBeforeImport[0].id, 'replace_test_3');

      // Import previous database
      await DatabaseHelper.instance.importDatabase(exportPath);

      // Verify that the database was replaced
      final medsAfterImport = await DatabaseHelper.instance.getAllMedications();
      expect(medsAfterImport.length, 2);
      expect(medsAfterImport.any((m) => m.id == 'replace_test_1'), isTrue);
      expect(medsAfterImport.any((m) => m.id == 'replace_test_2'), isTrue);
      expect(medsAfterImport.any((m) => m.id == 'replace_test_3'), isFalse);

      // Clean up
      final exportFile = File(exportPath);
      if (await exportFile.exists()) {
        await exportFile.delete();
      }
    });
  });

  group('Database Export/Import - Integration', () {
    late Directory testDbDir;
    const testPersonId = 'test-person-integration';
    Person? testPerson;

    setUp(() async {
      testDbDir = await Directory.systemTemp.createTemp('medicapp_test_db_');
      DatabaseHelper.setInMemoryDatabase(false);
      await DatabaseHelper.resetDatabase();

      // Clean all medications before each test
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();

      // Create test person
      testPerson = Person(
        id: testPersonId,
        name: 'Test Person Integration',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(testPerson!);

      databaseFactory = databaseFactoryFfi;
    });

    tearDown(() async {
      // Clean up persona de prueba
      if (testPerson != null) {
        await DatabaseHelper.instance.deletePerson(testPersonId);
      }

      // Clean data before resetting
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.deleteAllDoseHistory();
      await DatabaseHelper.resetDatabase();
      if (await testDbDir.exists()) {
        await testDbDir.delete(recursive: true);
      }
    });

    test('should handle multiple export/import cycles', () async {
      // Cycle 1: Create and export
      final med1 = MedicationBuilder()
          .withId('cycle_test_1')
          .withName('Cycle Medicine 1')
          .build();
      await DatabaseHelper.instance.insertMedication(med1);
      final export1 = await DatabaseHelper.instance.exportDatabase();

      // Cycle 2: Add more data and export
      final med2 = MedicationBuilder()
          .withId('cycle_test_2')
          .withName('Cycle Medicine 2')
          .build();
      await DatabaseHelper.instance.insertMedication(med2);
      final export2 = await DatabaseHelper.instance.exportDatabase();

      // Import first export
      await DatabaseHelper.instance.importDatabase(export1);
      var meds = await DatabaseHelper.instance.getAllMedications();
      expect(meds.length, 1);
      expect(meds[0].id, 'cycle_test_1');

      // Import second export
      await DatabaseHelper.instance.importDatabase(export2);
      meds = await DatabaseHelper.instance.getAllMedications();
      expect(meds.length, 2);

      // Clean up
      await File(export1).delete();
      await File(export2).delete();
    });

    test('should preserve complex medication data through export/import', () async {
      final complexMed = MedicationBuilder()
          .withId('complex_test_1')
          .withName('Complex Medicine')
          .withType(MedicationType.injection)
          .withMultipleDoses(['08:00', '14:00', '20:00'], 2.5)
          .withStock(45.5)
          .withLastRefill(75.25)
          .withFasting(type: 'before', duration: 30)
          .withLowStockThreshold(7)
          .build();

      await DatabaseHelper.instance.insertMedication(complexMed);
      await DatabaseHelper.instance.assignMedicationToPerson(
        personId: testPersonId,
        medicationId: complexMed.id,
        scheduleData: complexMed,
      );

      // Export and import
      final exportPath = await DatabaseHelper.instance.exportDatabase();
      await DatabaseHelper.instance.deleteAllMedications();
      await DatabaseHelper.instance.importDatabase(exportPath);

      // Verify basic data (available in medications table)
      final imported = await DatabaseHelper.instance.getMedication('complex_test_1');
      expect(imported, isNotNull);
      expect(imported!.name, 'Complex Medicine');
      expect(imported.type, MedicationType.injection);
      expect(imported.stockQuantity, 45.5);
      expect(imported.lastRefillAmount, 75.25);
      expect(imported.lowStockThresholdDays, 7);

      // Verify person data (including schedule and fasting fields)
      final medsForPerson = await DatabaseHelper.instance.getMedicationsForPerson(testPersonId);
      expect(medsForPerson.length, 1);
      final importedWithSchedule = medsForPerson.first;
      expect(importedWithSchedule.doseSchedule.length, 3);
      expect(importedWithSchedule.doseSchedule['08:00'], 2.5);
      expect(importedWithSchedule.doseSchedule['14:00'], 2.5);
      expect(importedWithSchedule.doseSchedule['20:00'], 2.5);
      expect(importedWithSchedule.requiresFasting, isTrue);
      expect(importedWithSchedule.fastingType, 'before');
      expect(importedWithSchedule.fastingDurationMinutes, 30);

      // Clean up
      await File(exportPath).delete();
    });
  });
}
