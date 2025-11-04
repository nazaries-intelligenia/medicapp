import 'dart:convert';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/medication.dart';
import '../models/dose_history_entry.dart';
import '../models/person.dart';
import '../models/person_medication.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _useInMemory = false; // For testing

  DatabaseHelper._init();

  // Set to use in-memory database for testing
  static void setInMemoryDatabase(bool inMemory) {
    _useInMemory = inMemory;
    _database = null; // Reset database when switching modes
  }

  // Reset database instance (useful for testing)
  static Future<void> resetDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_useInMemory ? ':memory:' : 'medications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path;
    if (_useInMemory || filePath == ':memory:') {
      path = inMemoryDatabasePath;
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 19,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onOpen: (db) async {
        // Debug: Check database schema
        final result = await db.rawQuery('PRAGMA table_info(medications)');
        print('Database columns: ${result.map((e) => e['name']).toList()}');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const integerNullableType = 'INTEGER';
    const realType = 'REAL NOT NULL DEFAULT 0';

    // === NUEVA ARQUITECTURA (V19+) ===
    // medications: Solo datos COMPARTIDOS entre personas (stock)
    // person_medications: Pauta INDIVIDUAL de cada persona

    await db.execute('''
      CREATE TABLE medications (
        id $idType,
        name $textType,
        type $textType,
        stockQuantity $realType,
        lastRefillAmount REAL,
        lowStockThresholdDays $integerType DEFAULT 3,
        lastDailyConsumption REAL
      )
    ''');

    // Create dose_history table for tracking all doses
    await db.execute('''
      CREATE TABLE dose_history (
        id $idType,
        medicationId $textType,
        medicationName $textType,
        medicationType $textType,
        personId $textType,
        scheduledDateTime $textType,
        registeredDateTime $textType,
        status $textType,
        quantity REAL NOT NULL,
        isExtraDose $integerType DEFAULT 0,
        notes $textNullableType,
        FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
      )
    ''');

    // Create index for faster queries by medicationId and date
    await db.execute('''
      CREATE INDEX idx_dose_history_medication
      ON dose_history(medicationId)
    ''');

    await db.execute('''
      CREATE INDEX idx_dose_history_date
      ON dose_history(scheduledDateTime)
    ''');

    // Create persons table for multi-user support
    await db.execute('''
      CREATE TABLE persons (
        id $idType,
        name $textType,
        isDefault $integerType DEFAULT 0
      )
    ''');

    // Create person_medications table with INDIVIDUAL schedule data
    await db.execute('''
      CREATE TABLE person_medications (
        id $idType,
        personId $textType,
        medicationId $textType,
        assignedDate $textType,
        durationType $textType,
        dosageIntervalHours $integerType DEFAULT 0,
        doseSchedule $textType,
        takenDosesToday $textType,
        skippedDosesToday $textType,
        takenDosesDate $textNullableType,
        selectedDates $textNullableType,
        weeklyDays $textNullableType,
        dayInterval $integerNullableType,
        startDate $textNullableType,
        endDate $textNullableType,
        requiresFasting $integerType DEFAULT 0,
        fastingType $textNullableType,
        fastingDurationMinutes $integerNullableType,
        notifyFasting $integerType DEFAULT 0,
        isSuspended $integerType DEFAULT 0,
        FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
        FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
        UNIQUE(personId, medicationId)
      )
    ''');

    // Create index for faster queries
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_person_medications_person
      ON person_medications(personId)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_person_medications_medication
      ON person_medications(medicationId)
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add doseTimes column for version 2
      await db.execute('''
        ALTER TABLE medications ADD COLUMN doseTimes TEXT NOT NULL DEFAULT ''
      ''');
    }

    if (oldVersion < 3) {
      // Add stockQuantity column for version 3
      await db.execute('''
        ALTER TABLE medications ADD COLUMN stockQuantity REAL NOT NULL DEFAULT 0
      ''');
    }

    if (oldVersion < 4) {
      // Add takenDosesToday and takenDosesDate columns for version 4
      await db.execute('''
        ALTER TABLE medications ADD COLUMN takenDosesToday TEXT NOT NULL DEFAULT ''
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN takenDosesDate TEXT
      ''');
    }

    if (oldVersion < 5) {
      // Add doseSchedule column for version 5 (dose quantities per time)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN doseSchedule TEXT NOT NULL DEFAULT ''
      ''');
    }

    if (oldVersion < 6) {
      // Add skippedDosesToday column for version 6 (track skipped doses separately)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN skippedDosesToday TEXT NOT NULL DEFAULT ''
      ''');
    }

    if (oldVersion < 7) {
      // Add lastRefillAmount column for version 7 (store last refill amount for suggestions)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN lastRefillAmount REAL
      ''');
    }

    if (oldVersion < 8) {
      // Add lowStockThresholdDays column for version 8 (configurable low stock threshold)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN lowStockThresholdDays INTEGER NOT NULL DEFAULT 3
      ''');
    }

    if (oldVersion < 9) {
      // Add selectedDates and weeklyDays columns for version 9 (specific days and weekly patterns)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN selectedDates TEXT
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN weeklyDays TEXT
      ''');
    }

    if (oldVersion < 10) {
      // Add startDate and endDate columns for version 10 (Phase 2: treatment date range)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN startDate TEXT
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN endDate TEXT
      ''');
    }

    if (oldVersion < 11) {
      // Create dose_history table for version 11 (Phase 2: dose history tracking)
      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';
      const textNullableType = 'TEXT';

      await db.execute('''
        CREATE TABLE dose_history (
          id $idType,
          medicationId $textType,
          medicationName $textType,
          medicationType $textType,
          scheduledDateTime $textType,
          registeredDateTime $textType,
          status $textType,
          quantity REAL NOT NULL,
          notes $textNullableType
        )
      ''');

      // Create indexes
      await db.execute('''
        CREATE INDEX idx_dose_history_medication
        ON dose_history(medicationId)
      ''');

      await db.execute('''
        CREATE INDEX idx_dose_history_date
        ON dose_history(scheduledDateTime)
      ''');
    }

    if (oldVersion < 12) {
      // Add dayInterval column for version 12 (interval-based medication schedules)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN dayInterval INTEGER
      ''');
    }

    if (oldVersion < 13) {
      // Add fasting columns for version 13 (fasting period configuration)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN requiresFasting INTEGER NOT NULL DEFAULT 0
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN fastingType TEXT
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN fastingDurationMinutes INTEGER
      ''');
      await db.execute('''
        ALTER TABLE medications ADD COLUMN notifyFasting INTEGER NOT NULL DEFAULT 0
      ''');
    }

    if (oldVersion < 14) {
      // Add isSuspended column for version 14 (medication suspension)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN isSuspended INTEGER NOT NULL DEFAULT 0
      ''');
    }

    if (oldVersion < 15) {
      // Add lastDailyConsumption column for version 15 (track last day consumption for "as needed" medications)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN lastDailyConsumption REAL
      ''');
    }

    if (oldVersion < 16) {
      // Add extraDosesToday column for version 16 (track extra doses taken outside of schedule)
      await db.execute('''
        ALTER TABLE medications ADD COLUMN extraDosesToday TEXT NOT NULL DEFAULT ''
      ''');

      // Add isExtraDose column to dose_history for version 16
      await db.execute('''
        ALTER TABLE dose_history ADD COLUMN isExtraDose INTEGER NOT NULL DEFAULT 0
      ''');
    }

    if (oldVersion < 17) {
      // Create persons table for version 17 (multi-user support)
      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';
      const integerType = 'INTEGER NOT NULL';

      await db.execute('''
        CREATE TABLE persons (
          id $idType,
          name $textType,
          isDefault $integerType DEFAULT 0
        )
      ''');
    }

    if (oldVersion < 18) {
      // Version 18: Implement many-to-many relationship between persons and medications
      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';

      // Create person_medications table for many-to-many relationship
      await db.execute('''
        CREATE TABLE person_medications (
          id $idType,
          personId $textType,
          medicationId $textType,
          assignedDate $textType,
          FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
          FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
          UNIQUE(personId, medicationId)
        )
      ''');

      // Create indexes
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_person_medications_person
        ON person_medications(personId)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_person_medications_medication
        ON person_medications(medicationId)
      ''');

      // Add personId column to dose_history
      await db.execute('''
        ALTER TABLE dose_history ADD COLUMN personId TEXT
      ''');

      // Assign all existing dose history entries to default person
      final defaultPerson = await db.query(
        'persons',
        where: 'isDefault = ?',
        whereArgs: [1],
        limit: 1,
      );

      if (defaultPerson.isNotEmpty) {
        final defaultPersonId = defaultPerson.first['id'] as String;
        await db.execute('''
          UPDATE dose_history
          SET personId = ?
          WHERE personId IS NULL
        ''', [defaultPersonId]);
      }
    }

    if (oldVersion < 19) {
      // === VERSION 19: MAJOR RESTRUCTURE ===
      // Split medications table into:
      // - medications: shared data (stock)
      // - person_medications: individual schedule data per person

      print('=== Starting migration to v19 ===');

      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';
      const textNullableType = 'TEXT';
      const integerType = 'INTEGER NOT NULL';
      const integerNullableType = 'INTEGER';
      const realType = 'REAL NOT NULL DEFAULT 0';

      // Step 1: Backup old person_medications table
      await db.execute('ALTER TABLE person_medications RENAME TO person_medications_old');

      // Step 2: Backup old medications table
      await db.execute('ALTER TABLE medications RENAME TO medications_old');

      // Step 3: Create new medications table (only shared data)
      await db.execute('''
        CREATE TABLE medications (
          id $idType,
          name $textType,
          type $textType,
          stockQuantity $realType,
          lastRefillAmount REAL,
          lowStockThresholdDays $integerType DEFAULT 3,
          lastDailyConsumption REAL
        )
      ''');

      // Step 4: Copy shared data from medications_old to medications
      await db.execute('''
        INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
        SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
        FROM medications_old
      ''');

      // Step 5: Create new person_medications table with individual schedule data
      await db.execute('''
        CREATE TABLE person_medications (
          id $idType,
          personId $textType,
          medicationId $textType,
          assignedDate $textType,
          durationType $textType,
          dosageIntervalHours $integerType DEFAULT 0,
          doseSchedule $textType,
          takenDosesToday $textType,
          skippedDosesToday $textType,
          takenDosesDate $textNullableType,
          selectedDates $textNullableType,
          weeklyDays $textNullableType,
          dayInterval $integerNullableType,
          startDate $textNullableType,
          endDate $textNullableType,
          requiresFasting $integerType DEFAULT 0,
          fastingType $textNullableType,
          fastingDurationMinutes $integerNullableType,
          notifyFasting $integerType DEFAULT 0,
          isSuspended $integerType DEFAULT 0,
          FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
          FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
          UNIQUE(personId, medicationId)
        )
      ''');

      // Step 6: Migrate data from old person_medications to new one
      // For each relationship, copy schedule data from medications_old
      await db.execute('''
        INSERT INTO person_medications (
          id, personId, medicationId, assignedDate,
          durationType, dosageIntervalHours, doseSchedule,
          takenDosesToday, skippedDosesToday, takenDosesDate,
          selectedDates, weeklyDays, dayInterval,
          startDate, endDate,
          requiresFasting, fastingType, fastingDurationMinutes, notifyFasting,
          isSuspended
        )
        SELECT
          pm.id, pm.personId, pm.medicationId, pm.assignedDate,
          m.durationType, m.dosageIntervalHours, m.doseSchedule,
          m.takenDosesToday, m.skippedDosesToday, m.takenDosesDate,
          m.selectedDates, m.weeklyDays, m.dayInterval,
          m.startDate, m.endDate,
          m.requiresFasting, m.fastingType, m.fastingDurationMinutes, m.notifyFasting,
          m.isSuspended
        FROM person_medications_old pm
        INNER JOIN medications_old m ON pm.medicationId = m.id
      ''');

      // Step 7: Recreate indexes
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_person_medications_person
        ON person_medications(personId)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_person_medications_medication
        ON person_medications(medicationId)
      ''');

      // Step 8: Drop old tables
      await db.execute('DROP TABLE person_medications_old');
      await db.execute('DROP TABLE medications_old');

      print('=== Migration to v19 complete ===');
    }
  }

  // === NEW V19 METHODS ===

  /// Create a medication and assign it to a person with their individual schedule
  /// This is the main method to use when creating a new medication for a person
  Future<String> createMedicationForPerson({
    required Medication medication,
    required String personId,
  }) async {
    final db = await database;

    // Check if a medication with this name already exists
    final existingMed = await db.query(
      'medications',
      where: 'name = ? COLLATE NOCASE',
      whereArgs: [medication.name],
      limit: 1,
    );

    String medicationId;

    if (existingMed.isNotEmpty) {
      // Medication exists, reuse it (shared stock)
      medicationId = existingMed.first['id'] as String;
      print('Reusing existing medication: $medicationId (${medication.name})');
    } else {
      // Create new medication (shared data only)
      medicationId = medication.id;
      await db.insert(
        'medications',
        {
          'id': medication.id,
          'name': medication.name,
          'type': medication.type.name,
          'stockQuantity': medication.stockQuantity,
          'lastRefillAmount': medication.lastRefillAmount,
          'lowStockThresholdDays': medication.lowStockThresholdDays,
          'lastDailyConsumption': medication.lastDailyConsumption,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Created new medication: $medicationId (${medication.name})');
    }

    // Create person_medication relationship with individual schedule
    final personMedication = PersonMedication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personId: personId,
      medicationId: medicationId,
      assignedDate: DateTime.now().toIso8601String(),
      durationType: medication.durationType,
      dosageIntervalHours: medication.dosageIntervalHours,
      doseSchedule: medication.doseSchedule,
      takenDosesToday: medication.takenDosesToday,
      skippedDosesToday: medication.skippedDosesToday,
      takenDosesDate: medication.takenDosesDate,
      selectedDates: medication.selectedDates,
      weeklyDays: medication.weeklyDays,
      dayInterval: medication.dayInterval,
      startDate: medication.startDate?.toIso8601String(),
      endDate: medication.endDate?.toIso8601String(),
      requiresFasting: medication.requiresFasting,
      fastingType: medication.fastingType,
      fastingDurationMinutes: medication.fastingDurationMinutes,
      notifyFasting: medication.notifyFasting,
      isSuspended: medication.isSuspended,
    );

    await db.insert(
      'person_medications',
      personMedication.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('Assigned medication to person: $personId');
    return medicationId;
  }

  // Create - Insert a medication (LEGACY - for backward compatibility)
  // NOTE: In v19+, prefer using createMedicationForPerson
  Future<int> insertMedication(Medication medication) async {
    final db = await database;

    // In v19+, this only inserts shared data
    return await db.insert(
      'medications',
      {
        'id': medication.id,
        'name': medication.name,
        'type': medication.type.name,
        'stockQuantity': medication.stockQuantity,
        'lastRefillAmount': medication.lastRefillAmount,
        'lowStockThresholdDays': medication.lowStockThresholdDays,
        'lastDailyConsumption': medication.lastDailyConsumption,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read - Get all medications
  Future<List<Medication>> getAllMedications() async {
    final db = await database;
    final result = await db.query('medications');

    return result.map((json) => Medication.fromJson(json)).toList();
  }

  // Read - Get a single medication by ID
  Future<Medication?> getMedication(String id) async {
    final db = await database;
    final maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Medication.fromJson(maps.first);
    }
    return null;
  }

  /// Get a single medication for a specific person (includes doseSchedule from person_medications)
  Future<Medication?> getMedicationForPerson(String medicationId, String personId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        m.id,
        m.name,
        m.type,
        m.stockQuantity,
        m.lastRefillAmount,
        m.lowStockThresholdDays,
        m.lastDailyConsumption,
        pm.durationType,
        pm.dosageIntervalHours,
        pm.doseSchedule,
        pm.takenDosesToday,
        pm.skippedDosesToday,
        pm.takenDosesDate,
        pm.selectedDates,
        pm.weeklyDays,
        pm.dayInterval,
        pm.startDate,
        pm.endDate,
        pm.requiresFasting,
        pm.fastingType,
        pm.fastingDurationMinutes,
        pm.notifyFasting,
        pm.isSuspended
      FROM medications m
      INNER JOIN person_medications pm ON m.id = pm.medicationId
      WHERE m.id = ? AND pm.personId = ?
    ''', [medicationId, personId]);

    if (result.isNotEmpty) {
      return Medication.fromJson(result.first);
    }
    return null;
  }

  /// Update medication data for a specific person
  /// Updates both shared data (stock) and individual schedule
  Future<int> updateMedicationForPerson({
    required Medication medication,
    required String personId,
  }) async {
    final db = await database;

    // Update shared data (stock) in medications table
    await db.update(
      'medications',
      {
        'name': medication.name,
        'type': medication.type.name,
        'stockQuantity': medication.stockQuantity,
        'lastRefillAmount': medication.lastRefillAmount,
        'lowStockThresholdDays': medication.lowStockThresholdDays,
        'lastDailyConsumption': medication.lastDailyConsumption,
      },
      where: 'id = ?',
      whereArgs: [medication.id],
    );

    // Update individual schedule in person_medications table
    return await db.update(
      'person_medications',
      {
        'durationType': medication.durationType.name,
        'dosageIntervalHours': medication.dosageIntervalHours,
        'doseSchedule': jsonEncode(medication.doseSchedule),
        'takenDosesToday': medication.takenDosesToday.join(','),
        'skippedDosesToday': medication.skippedDosesToday.join(','),
        'takenDosesDate': medication.takenDosesDate,
        'selectedDates': medication.selectedDates?.join(','),
        'weeklyDays': medication.weeklyDays?.join(','),
        'dayInterval': medication.dayInterval,
        'startDate': medication.startDate?.toIso8601String(),
        'endDate': medication.endDate?.toIso8601String(),
        'requiresFasting': medication.requiresFasting ? 1 : 0,
        'fastingType': medication.fastingType,
        'fastingDurationMinutes': medication.fastingDurationMinutes,
        'notifyFasting': medication.notifyFasting ? 1 : 0,
        'isSuspended': medication.isSuspended ? 1 : 0,
      },
      where: 'medicationId = ? AND personId = ?',
      whereArgs: [medication.id, personId],
    );
  }

  // Update - Update a medication (LEGACY - for backward compatibility)
  // NOTE: In v19+, this only updates shared data (stock)
  Future<int> updateMedication(Medication medication) async {
    final db = await database;
    final result = await db.update(
      'medications',
      {
        'name': medication.name,
        'type': medication.type.name,
        'stockQuantity': medication.stockQuantity,
        'lastRefillAmount': medication.lastRefillAmount,
        'lowStockThresholdDays': medication.lowStockThresholdDays,
        'lastDailyConsumption': medication.lastDailyConsumption,
      },
      where: 'id = ?',
      whereArgs: [medication.id],
    );
    return result;
  }

  // Delete - Delete a medication
  Future<int> deleteMedication(String id) async {
    final db = await database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all medications (useful for testing)
  Future<int> deleteAllMedications() async {
    final db = await database;
    return await db.delete('medications');
  }

  // === DOSE HISTORY METHODS ===

  // Create - Insert a dose history entry
  Future<int> insertDoseHistory(DoseHistoryEntry entry) async {
    final db = await database;
    return await db.insert(
      'dose_history',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read - Get all dose history entries
  Future<List<DoseHistoryEntry>> getAllDoseHistory() async {
    final db = await database;
    final result = await db.query(
      'dose_history',
      orderBy: 'scheduledDateTime DESC', // Most recent first
    );

    return result.map((map) => DoseHistoryEntry.fromMap(map)).toList();
  }

  // Read - Get dose history for a specific medication
  Future<List<DoseHistoryEntry>> getDoseHistoryForMedication(String medicationId) async {
    final db = await database;
    final result = await db.query(
      'dose_history',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
      orderBy: 'scheduledDateTime DESC',
    );

    return result.map((map) => DoseHistoryEntry.fromMap(map)).toList();
  }

  // Read - Get dose history for a date range
  Future<List<DoseHistoryEntry>> getDoseHistoryForDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? medicationId,
  }) async {
    final db = await database;

    final startString = startDate.toIso8601String();
    final endString = endDate.toIso8601String();

    String where = 'scheduledDateTime >= ? AND scheduledDateTime <= ?';
    List<dynamic> whereArgs = [startString, endString];

    if (medicationId != null) {
      where += ' AND medicationId = ?';
      whereArgs.add(medicationId);
    }

    final result = await db.query(
      'dose_history',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'scheduledDateTime DESC',
    );

    return result.map((map) => DoseHistoryEntry.fromMap(map)).toList();
  }

  // Read - Get statistics for a medication
  Future<Map<String, dynamic>> getDoseStatistics({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
    String? personId,
  }) async {
    final db = await database;

    String where = '1 = 1'; // Always true
    List<dynamic> whereArgs = [];

    if (medicationId != null) {
      where += ' AND medicationId = ?';
      whereArgs.add(medicationId);
    }

    if (startDate != null) {
      where += ' AND scheduledDateTime >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      where += ' AND scheduledDateTime <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (personId != null) {
      where += ' AND personId = ?';
      whereArgs.add(personId);
    }

    // Get total count
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as total FROM dose_history WHERE $where',
      whereArgs,
    );
    final total = totalResult.first['total'] as int;

    // Get taken count
    final takenResult = await db.rawQuery(
      'SELECT COUNT(*) as taken FROM dose_history WHERE $where AND status = ?',
      [...whereArgs, 'taken'],
    );
    final taken = takenResult.first['taken'] as int;

    // Get skipped count
    final skippedResult = await db.rawQuery(
      'SELECT COUNT(*) as skipped FROM dose_history WHERE $where AND status = ?',
      [...whereArgs, 'skipped'],
    );
    final skipped = skippedResult.first['skipped'] as int;

    // Calculate adherence percentage
    final adherence = total > 0 ? (taken / total * 100).toDouble() : 0.0;

    return {
      'total': total,
      'taken': taken,
      'skipped': skipped,
      'adherence': adherence,
    };
  }

  // Delete - Delete a dose history entry
  Future<int> deleteDoseHistory(String id) async {
    final db = await database;
    return await db.delete(
      'dose_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete - Delete all dose history for a medication
  Future<int> deleteDoseHistoryForMedication(String medicationId) async {
    final db = await database;
    return await db.delete(
      'dose_history',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }

  // Read - Get medication IDs that have doses registered today
  /// Returns a Set of medication IDs that have at least one dose taken today
  /// based on the registeredDateTime (when the dose was actually taken)
  Future<Set<String>> getMedicationIdsWithDosesToday() async {
    final db = await database;

    // Get today's date range (from 00:00:00 to 23:59:59)
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final result = await db.query(
      'dose_history',
      columns: ['DISTINCT medicationId'],
      where: 'registeredDateTime >= ? AND registeredDateTime <= ? AND status = ?',
      whereArgs: [
        todayStart.toIso8601String(),
        todayEnd.toIso8601String(),
        'taken', // Only include taken doses, not skipped
      ],
    );

    return result.map((row) => row['medicationId'] as String).toSet();
  }

  // Delete all dose history (useful for testing)
  Future<int> deleteAllDoseHistory() async {
    final db = await database;
    return await db.delete('dose_history');
  }

  // === PERSON MANAGEMENT METHODS ===

  // Create - Insert a person
  Future<int> insertPerson(Person person) async {
    final db = await database;
    return await db.insert(
      'persons',
      person.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read - Get all persons
  Future<List<Person>> getAllPersons() async {
    final db = await database;
    final result = await db.query('persons', orderBy: 'name ASC');
    return result.map((json) => Person.fromJson(json)).toList();
  }

  // Read - Get a single person by ID
  Future<Person?> getPerson(String id) async {
    final db = await database;
    final maps = await db.query(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Person.fromJson(maps.first);
    }
    return null;
  }

  // Read - Get the default person
  Future<Person?> getDefaultPerson() async {
    final db = await database;
    final maps = await db.query(
      'persons',
      where: 'isDefault = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Person.fromJson(maps.first);
    }
    return null;
  }

  // Update - Update a person
  Future<int> updatePerson(Person person) async {
    final db = await database;
    return await db.update(
      'persons',
      person.toJson(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  // Delete - Delete a person
  Future<int> deletePerson(String id) async {
    final db = await database;
    return await db.delete(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all persons (useful for testing)
  Future<int> deleteAllPersons() async {
    final db = await database;
    return await db.delete('persons');
  }

  // Check if default person exists
  Future<bool> hasDefaultPerson() async {
    final defaultPerson = await getDefaultPerson();
    return defaultPerson != null;
  }

  // === PERSON-MEDICATION RELATIONSHIP METHODS ===

  // Create - Assign a medication to a person
  Future<int> insertPersonMedication(PersonMedication personMedication) async {
    final db = await database;
    return await db.insert(
      'person_medications',
      personMedication.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Helper - Assign medication to person with schedule data (V19+)
  Future<int> assignMedicationToPerson({
    required String personId,
    required String medicationId,
    required Medication scheduleData,
  }) async {
    final personMedication = PersonMedication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personId: personId,
      medicationId: medicationId,
      assignedDate: DateTime.now().toIso8601String(),
      durationType: scheduleData.durationType,
      dosageIntervalHours: scheduleData.dosageIntervalHours,
      doseSchedule: scheduleData.doseSchedule,
      takenDosesToday: scheduleData.takenDosesToday,
      skippedDosesToday: scheduleData.skippedDosesToday,
      takenDosesDate: scheduleData.takenDosesDate,
      selectedDates: scheduleData.selectedDates,
      weeklyDays: scheduleData.weeklyDays,
      dayInterval: scheduleData.dayInterval,
      startDate: scheduleData.startDate?.toIso8601String(),
      endDate: scheduleData.endDate?.toIso8601String(),
      requiresFasting: scheduleData.requiresFasting,
      fastingType: scheduleData.fastingType,
      fastingDurationMinutes: scheduleData.fastingDurationMinutes,
      notifyFasting: scheduleData.notifyFasting,
      isSuspended: scheduleData.isSuspended,
    );
    return await insertPersonMedication(personMedication);
  }

  // Delete - Unassign medication from person
  Future<int> unassignMedicationFromPerson({
    required String personId,
    required String medicationId,
  }) async {
    final db = await database;
    return await db.delete(
      'person_medications',
      where: 'personId = ? AND medicationId = ?',
      whereArgs: [personId, medicationId],
    );
  }

  // Read - Get all persons assigned to a medication
  Future<List<Person>> getPersonsForMedication(String medicationId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.* FROM persons p
      INNER JOIN person_medications pm ON p.id = pm.personId
      WHERE pm.medicationId = ?
      ORDER BY p.name ASC
    ''', [medicationId]);

    return result.map((json) => Person.fromJson(json)).toList();
  }

  // Read - Get all medications assigned to a person
  // Combines shared data from medications with individual schedule from person_medications
  Future<List<Medication>> getMedicationsForPerson(String personId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        m.id,
        m.name,
        m.type,
        m.stockQuantity,
        m.lastRefillAmount,
        m.lowStockThresholdDays,
        m.lastDailyConsumption,
        pm.durationType,
        pm.dosageIntervalHours,
        pm.doseSchedule,
        pm.takenDosesToday,
        pm.skippedDosesToday,
        pm.takenDosesDate,
        pm.selectedDates,
        pm.weeklyDays,
        pm.dayInterval,
        pm.startDate,
        pm.endDate,
        pm.requiresFasting,
        pm.fastingType,
        pm.fastingDurationMinutes,
        pm.notifyFasting,
        pm.isSuspended
      FROM medications m
      INNER JOIN person_medications pm ON m.id = pm.medicationId
      WHERE pm.personId = ?
    ''', [personId]);

    return result.map((json) => Medication.fromJson(json)).toList();
  }

  // Read - Check if a person is assigned to a medication
  Future<bool> isPersonAssignedToMedication({
    required String personId,
    required String medicationId,
  }) async {
    final db = await database;
    final result = await db.query(
      'person_medications',
      where: 'personId = ? AND medicationId = ?',
      whereArgs: [personId, medicationId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // Read - Get all person-medication relationships
  Future<List<PersonMedication>> getAllPersonMedications() async {
    final db = await database;
    final result = await db.query('person_medications');
    return result.map((json) => PersonMedication.fromJson(json)).toList();
  }

  // Delete - Delete a specific person-medication relationship by ID
  Future<int> deletePersonMedication(String id) async {
    final db = await database;
    return await db.delete(
      'person_medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Read - Get all medications that have no person assigned
  Future<List<Medication>> getMedicationsWithoutPersonAssignment() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT m.* FROM medications m
      WHERE NOT EXISTS (
        SELECT 1 FROM person_medications pm
        WHERE pm.medicationId = m.id
      )
    ''');
    return result.map((json) => Medication.fromJson(json)).toList();
  }

  // Helper - Migrate unassigned medications to default person (V19+)
  // Note: In v19+, this is handled automatically by the migration script
  // This method is kept for manual migration if needed
  Future<void> migrateUnassignedMedicationsToDefaultPerson() async {
    // Get default person
    final defaultPerson = await getDefaultPerson();
    if (defaultPerson == null) {
      print('No default person found, cannot migrate medications');
      return;
    }

    // Get all medications without person assignment
    final unassignedMedications = await getMedicationsWithoutPersonAssignment();
    print('Found ${unassignedMedications.length} medications without person assignment');

    // Assign each medication to the default person
    // In v19+, we need to create dummy schedule data since medications table doesn't have it
    for (final medication in unassignedMedications) {
      // Check if already assigned
      final isAssigned = await isPersonAssignedToMedication(
        personId: defaultPerson.id,
        medicationId: medication.id,
      );

      if (!isAssigned) {
        await assignMedicationToPerson(
          personId: defaultPerson.id,
          medicationId: medication.id,
          scheduleData: medication, // Use medication data as schedule
        );
        print('Assigned medication ${medication.name} to default person ${defaultPerson.name}');
      }
    }

    print('Migration complete: ${unassignedMedications.length} medications assigned to ${defaultPerson.name}');
  }

  // Delete - Delete all person-medication relationships (useful for testing)
  Future<int> deleteAllPersonMedications() async {
    final db = await database;
    return await db.delete('person_medications');
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Export the database to a file
  /// Returns the path to the exported file
  Future<String> exportDatabase() async {
    // Can't export in-memory database
    if (_useInMemory) {
      throw Exception('Cannot export in-memory database');
    }

    // Get the current database file path
    final dbPath = await getDatabasesPath();
    final currentDbPath = join(dbPath, 'medications.db');

    // Create a temporary directory for the export
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
    final exportFileName = 'medicapp_backup_$timestamp.db';
    final exportPath = join(tempDir.path, exportFileName);

    // Copy the database file
    final dbFile = File(currentDbPath);
    if (!await dbFile.exists()) {
      throw Exception('Database file not found');
    }

    await dbFile.copy(exportPath);
    print('Database exported to: $exportPath');

    return exportPath;
  }

  /// Import a database from a file
  /// This will replace the current database with the imported one
  Future<void> importDatabase(String importPath) async {
    // Can't import to in-memory database
    if (_useInMemory) {
      throw Exception('Cannot import to in-memory database');
    }

    final importFile = File(importPath);
    if (!await importFile.exists()) {
      throw Exception('Import file not found: $importPath');
    }

    // Close current database connection
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Get the target database path
    final dbPath = await getDatabasesPath();
    final targetDbPath = join(dbPath, 'medications.db');

    // Backup current database before importing (just in case)
    final currentDbFile = File(targetDbPath);
    if (await currentDbFile.exists()) {
      final backupPath = '$targetDbPath.backup';
      await currentDbFile.copy(backupPath);
      print('Current database backed up to: $backupPath');
    }

    // Copy the import file to the database location
    await importFile.copy(targetDbPath);
    print('Database imported from: $importPath');

    // Verify the imported database by opening it
    try {
      _database = await _initDB('medications.db');
      print('Database imported successfully and verified');
    } catch (e) {
      // If verification fails, restore from backup
      print('Import verification failed: $e');
      final backupPath = '$targetDbPath.backup';
      final backupFile = File(backupPath);
      if (await backupFile.exists()) {
        await backupFile.copy(targetDbPath);
        _database = await _initDB('medications.db');
        print('Restored database from backup');
      }
      throw Exception('Failed to import database: $e');
    }
  }

  /// Get the current database file path
  Future<String> getDatabasePath() async {
    if (_useInMemory) {
      return ':memory:';
    }
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'medications.db');
  }
}
