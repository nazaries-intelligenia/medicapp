# MedicApp Database - SQLite V19

## Overview

MedicApp uses SQLite V19 as its local database management system. The architecture is designed to support multiple persons (users) who can share medications but maintain individual configurations and schedules.

### Key Features

- **Current Version**: V19 (latest stable version)
- **Engine**: SQLite with `sqflite` (Flutter)
- **Architecture**: Multi-person with shared data and individual configurations
- **Location**: `medications.db` in the application's database directory
- **Migrations**: Automatic progressive migration system (V1 → V19)
- **Integrity**: Foreign keys explicitly enabled in `onOpen` with deletion cascades
- **Indexes**: Optimized for frequent queries

### Design Philosophy

The V19 database implements a **clear separation between shared data and individual data**:

- **Shared Data** (`medications` table): Medication stock that can be used by any person
- **Individual Data** (`person_medications` table): Schedules, routines and person-specific configurations
- **N:N Relationship**: A person can have multiple medications, and a medication can be assigned to multiple persons

---

## Table Schema

### Table: `persons`

Stores the persons who use the application (users, family members, patients).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Unique identifier for the person (UUID in string format) |
| `name` | TEXT NOT NULL | Name of the person |
| `isDefault` | INTEGER NOT NULL | 1 if it's the default person (main user), 0 otherwise |

#### Rules

- There must be at least one person with `isDefault = 1`
- IDs are generated as timestamps in milliseconds (format: milliseconds since epoch)
- Name cannot be empty

---

### Table: `medications`

Stores the **shared data** of medications (name, type, stock).

```sql
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
)
```

#### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Unique identifier for the medication (UUID in string format) |
| `name` | TEXT NOT NULL | Name of the medication (e.g., "Ibuprofen 600mg") |
| `type` | TEXT NOT NULL | Type of medication: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Current quantity in stock (shared among all persons) |
| `lastRefillAmount` | REAL | Last amount added to stock (suggestion for future refills) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Threshold days to show low stock alert (default: 3) |
| `lastDailyConsumption` | REAL | Last amount consumed in a day (for "as needed" medications) |

#### Notes

- **Shared Stock**: The `stockQuantity` is unique and shared among all persons using the medication
- **Deduplication**: If two persons add the same medication (name match, case-insensitive), the existing record is reused
- **Types**: The `type` field determines the unit of measurement (pills, ml, drops, etc.)

---

### Table: `person_medications`

N:N relationship table that stores the **individual schedule** of each person for a specific medication.

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER NOT NULL DEFAULT 0,
  doseSchedule TEXT NOT NULL,
  takenDosesToday TEXT NOT NULL,
  skippedDosesToday TEXT NOT NULL,
  takenDosesDate TEXT,
  selectedDates TEXT,
  weeklyDays TEXT,
  dayInterval INTEGER,
  startDate TEXT,
  endDate TEXT,
  requiresFasting INTEGER NOT NULL DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER NOT NULL DEFAULT 0,
  isSuspended INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)
)
```

#### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Unique identifier for the person-medication relationship (UUID v4) |
| `personId` | TEXT NOT NULL | FK to `persons.id` |
| `medicationId` | TEXT NOT NULL | FK to `medications.id` |
| `assignedDate` | TEXT NOT NULL | ISO8601 date when the medication was assigned to the person |
| `durationType` | TEXT NOT NULL | Duration type: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Interval in hours between doses (0 if not applicable) |
| `doseSchedule` | TEXT NOT NULL | JSON with time → quantity map (e.g., `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | CSV list of times taken today (e.g., `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | CSV list of times skipped today (e.g., `"14:00"`) |
| `takenDosesDate` | TEXT | ISO8601 date of taken/skipped doses (e.g., `"2025-11-14"`) |
| `selectedDates` | TEXT | CSV list of specific dates for `durationType = specificDates` |
| `weeklyDays` | TEXT | CSV list of weekdays (1=Monday, 7=Sunday) for `weeklyPattern` |
| `dayInterval` | INTEGER | Day interval for `durationType = intervalDays` (e.g., 2 = every 2 days) |
| `startDate` | TEXT | ISO8601 start date of treatment |
| `endDate` | TEXT | ISO8601 end date of treatment |
| `requiresFasting` | INTEGER NOT NULL | 1 if fasting is required, 0 otherwise |
| `fastingType` | TEXT | Fasting type: `before` or `after` |
| `fastingDurationMinutes` | INTEGER | Fasting duration in minutes (e.g., 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 if fasting periods should be notified, 0 otherwise |
| `isSuspended` | INTEGER NOT NULL | 1 if the medication is suspended (no notifications), 0 otherwise |

#### Notes

- **Unique Relationship**: A person cannot have the same medication assigned twice (`UNIQUE(personId, medicationId)`)
- **Cascades**: If a person or medication is deleted, relationships are automatically deleted
- **doseSchedule**: Stored as JSON for flexibility (e.g., different quantities at different times)
- **Duration Types**:
  - `everyday`: Every day
  - `untilFinished`: Until stock is depleted
  - `specificDates`: Only on specific dates (stored in `selectedDates`)
  - `weeklyPattern`: Specific days of the week (stored in `weeklyDays`)
  - `intervalDays`: Every N days (specified in `dayInterval`)
  - `asNeeded`: As needed (no fixed schedule)

---

### Table: `dose_history`

Historical record of all doses taken or skipped.

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,
  registeredDateTime TEXT NOT NULL,
  status TEXT NOT NULL,
  quantity REAL NOT NULL,
  isExtraDose INTEGER NOT NULL DEFAULT 0,
  notes TEXT,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
)
```

#### Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Unique identifier for the history entry |
| `medicationId` | TEXT NOT NULL | Medication ID (denormalized for performance) |
| `medicationName` | TEXT NOT NULL | Medication name (denormalized) |
| `medicationType` | TEXT NOT NULL | Medication type (denormalized) |
| `personId` | TEXT NOT NULL | FK to `persons.id` - person who took/skipped the dose |
| `scheduledDateTime` | TEXT NOT NULL | ISO8601 scheduled date and time for the dose |
| `registeredDateTime` | TEXT NOT NULL | ISO8601 actual date and time when the dose was registered |
| `status` | TEXT NOT NULL | Dose status: `taken` or `skipped` |
| `quantity` | REAL NOT NULL | Amount taken (in medication type units) |
| `isExtraDose` | INTEGER NOT NULL | 1 if it's an extra dose (off schedule), 0 if scheduled |
| `notes` | TEXT | Optional notes about the dose |

#### Notes

- **Denormalization**: `medicationName` and `medicationType` are stored here to avoid JOINs in history queries
- **Cascade**: If a person is deleted, their history records are deleted
- **No FK to medications**: History is maintained even if the medication is deleted
- **Delay**: The difference between `scheduledDateTime` and `registeredDateTime` indicates if the dose was timely

---

## Table Relationships

```
┌──────────────┐
│   persons    │
│──────────────│
│ id (PK)      │───┐
│ name         │   │
│ isDefault    │   │
└──────────────┘   │
                   │
                   │ 1:N
                   │
                   ↓
         ┌──────────────────────┐
         │ person_medications   │
         │──────────────────────│
         │ id (PK)              │
         │ personId (FK)        │──→ persons.id
         │ medicationId (FK)    │──→ medications.id
         │ [individual schedule]│
         └──────────────────────┘
                   │
                   │ N:1
                   │
                   ↓
         ┌──────────────────┐
         │  medications     │
         │──────────────────│
         │ id (PK)          │
         │ name             │
         │ type             │
         │ stockQuantity    │
         │ [stock data]     │
         └──────────────────┘


┌──────────────┐
│   persons    │
│──────────────│
│ id (PK)      │───┐
└──────────────┘   │
                   │ 1:N
                   │
                   ↓
         ┌──────────────────┐
         │  dose_history    │
         │──────────────────│
         │ id (PK)          │
         │ personId (FK)    │──→ persons.id
         │ medicationId     │ (no FK, denormalized)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Foreign Keys

| Table | Column | Reference | On Delete |
|-------|---------|------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Indexes

The following indexes are created to optimize frequent queries:

```sql
-- Index for searching doses by medication
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Index for searching doses by scheduled date
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Index for searching medications of a person
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Index for searching persons assigned to a medication
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Purpose of Each Index

- **`idx_dose_history_medication`**: Speeds up history queries filtered by medication (e.g., see all Ibuprofen doses)
- **`idx_dose_history_date`**: Optimizes queries by date range (e.g., history of last 7 days)
- **`idx_person_medications_person`**: Improves loading of medications for a specific person (most frequent query)
- **`idx_person_medications_medication`**: Facilitates finding which persons are using a medication

---

## Triggers

There are currently no triggers implemented in the database. Business logic is handled in the application layer (Dart).

**Possible Future Triggers:**

```sql
-- Example: Automatically update stock when registering a taken dose
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Note**: This trigger is not implemented because stock control is explicitly managed in the application code for greater flexibility.

---

## Migrations

### Version History (V1 → V19)

| Version | Main Changes |
|---------|---------------------|
| **V1** | Initial schema: basic `medications` table |
| **V2** | Added `doseTimes` (dose schedules) |
| **V3** | Added `stockQuantity` (inventory management) |
| **V4** | Added `takenDosesToday`, `takenDosesDate` (daily dose tracking) |
| **V5** | Added `doseSchedule` (variable quantities per schedule) |
| **V6** | Added `skippedDosesToday` (skipped dose tracking) |
| **V7** | Added `lastRefillAmount` (refill suggestions) |
| **V8** | Added `lowStockThresholdDays` (configurable threshold) |
| **V9** | Added `selectedDates`, `weeklyDays` (treatment patterns) |
| **V10** | Added `startDate`, `endDate` (treatment range) |
| **V11** | Created `dose_history` table (complete dose history) |
| **V12** | Added `dayInterval` (treatments every N days) |
| **V13** | Added fasting fields: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Added `isSuspended` (temporary medication suspension) |
| **V15** | Added `lastDailyConsumption` (tracking for "as needed" medications) |
| **V16** | Added `extraDosesToday` and `isExtraDose` (off-schedule doses) |
| **V17** | Created `persons` table (multi-person support) |
| **V18** | Created `person_medications` table (N:N relationship), added `personId` to `dose_history` |
| **V19** | **Major restructuring**: Separation of shared data (medications) and individual schedules (person_medications) |

### Migration V18 → V19 (Major Restructuring)

The V19 migration is the most complex and important. It separates medication data into two tables:

#### Migration Process

1. **Backup**: Existing tables are renamed to `_old`
2. **New Tables**: `medications` and `person_medications` are created with the new schema
3. **Shared Data Migration**: `id`, `name`, `type`, `stockQuantity`, etc. are copied to `medications`
4. **Individual Schedule Migration**: Schedules, duration, fasting, etc. are copied to `person_medications`
5. **Index Recreation**: Optimized indexes are created
6. **Cleanup**: `_old` tables are deleted

```sql
-- Step 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Step 2: Create new medications table (shared data only)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Step 3: Copy shared data
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Step 4: Create new person_medications table (individual schedules)
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER NOT NULL DEFAULT 0,
  doseSchedule TEXT NOT NULL,
  takenDosesToday TEXT NOT NULL,
  skippedDosesToday TEXT NOT NULL,
  takenDosesDate TEXT,
  selectedDates TEXT,
  weeklyDays TEXT,
  dayInterval INTEGER,
  startDate TEXT,
  endDate TEXT,
  requiresFasting INTEGER NOT NULL DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER NOT NULL DEFAULT 0,
  isSuspended INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)
);

-- Step 5: Migrate individual schedules
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
INNER JOIN medications_old m ON pm.medicationId = m.id;

-- Step 6: Recreate indexes
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Step 7: Cleanup
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Automatic Migration System

The system automatically detects the current database version and applies progressive migrations:

```dart
// In database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Target version
    onCreate: _createDB,  // For new databases
    onUpgrade: _upgradeDB,  // To migrate from previous versions
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Applies progressive migrations from oldVersion to newVersion
  if (oldVersion < 2) { /* Migration V1→V2 */ }
  if (oldVersion < 3) { /* Migration V2→V3 */ }
  // ... up to V19
}
```

**Advantages**:
- **Progressive**: A user with V1 automatically updates to V19
- **No data loss**: Each migration preserves existing data
- **Error tolerant**: If a migration fails, the database remains in the previous state

---

## Business Rules

### 1. Stock Shared Among Persons

- The `stockQuantity` in the `medications` table is **unique and shared**
- When any person registers a taken dose, the stock decrements for everyone
- **Example**: If there are 20 Ibuprofen pills and Ana takes 1, there are 19 left for everyone (including Carlos)

### 2. Individual Configurations per Person

- Each person can have **different schedules** for the same medication
- **Example**:
  - Ana takes Ibuprofen at 08:00 and 20:00
  - Carlos takes the same Ibuprofen only at 14:00

### 3. Integrity Validations

```sql
-- A person cannot have the same medication twice
UNIQUE(personId, medicationId) in person_medications

-- There must be at least one default person
-- (Validated in the application layer)
```

### 4. Deletion Cascades

- **Delete person** → All their relationships in `person_medications` and their history in `dose_history` are deleted
- **Delete medication** → All relationships in `person_medications` are deleted, but **NOT** the history (for auditing)

### 5. Medication Deduplication

When creating a medication, the system verifies if one with the same name already exists (case-insensitive):

```dart
// Pseudocode
if (exists medication with same name) {
  reuse existing medication
  create only new entry in person_medications
} else {
  create new medication
  create entry in person_medications
}
```

---

## Common SQL Queries

### 1. Get Medications for a Person

```sql
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
```

### 2. Register a Medication Dose Taken

```sql
-- Step 1: Insert into history
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Step 2: Update stock (only if scheduled dose, not extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Step 3: Update takenDosesToday in person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Add taken time
  takenDosesDate = ?     -- Update date
WHERE personId = ? AND medicationId = ?;
```

### 3. Calculate Available Stock and Alerts

```sql
-- Get medications with low stock for a person
SELECT
  m.id,
  m.name,
  m.stockQuantity,
  m.lowStockThresholdDays,
  pm.doseSchedule
FROM medications m
INNER JOIN person_medications pm ON m.id = pm.medicationId
WHERE pm.personId = ?
  AND m.stockQuantity > 0
  AND m.stockQuantity < (
    -- Calculate minimum stock based on daily dose
    -- (This logic is done in the application because doseSchedule is JSON)
  );
```

### 4. Get Dose History (Last 30 Days)

```sql
SELECT
  id,
  medicationId,
  medicationName,
  medicationType,
  personId,
  scheduledDateTime,
  registeredDateTime,
  status,
  quantity,
  isExtraDose,
  notes
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= date('now', '-30 days')
ORDER BY scheduledDateTime DESC;
```

### 5. Calculate Adherence (% of Doses Taken)

```sql
-- Total scheduled doses
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Taken doses
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Adherence = (taken / total) * 100
```

### 6. Get Persons Assigned to a Medication

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Check if a Medication Already Exists (by name)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimizations

### 1. Batch Transactions

For operations that modify multiple tables, transactions are used:

```dart
await db.transaction((txn) async {
  // Multiple atomic operations
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Advantages**:
- Atomicity: Everything is saved or nothing is saved
- Consistency: No intermediate states
- Performance: Single disk write

### 2. Prepared Statements

All queries use prepared statements with placeholders (`?`) to prevent SQL injection and improve performance:

```dart
// ✅ Correct (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Incorrect (vulnerable to SQL injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Selective Indexes

Indexes are designed for the most frequent queries:
- `idx_person_medications_person`: For the main screen (show user's medications)
- `idx_dose_history_medication`: For history of a specific medication
- `idx_dose_history_date`: For date range queries

### 4. Strategic Denormalization

In `dose_history`, `medicationName` and `medicationType` are stored (denormalized) to avoid costly JOINs in history queries. This sacrifices a bit of space for much better performance.

### 5. In-Memory Cache

The application uses cache for the default person:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Query database only if not in cache
}
```

### 6. ANALYZE and VACUUM

**ANALYZE**: Updates database statistics to optimize the query planner.

```sql
ANALYZE;
```

**VACUUM**: Rebuilds the database to free up space and optimize.

```sql
VACUUM;
```

**Recommendation**: Run `ANALYZE` after massive data changes, and `VACUUM` periodically (e.g., every 3 months).

---

## Backup and Restoration

### Database File Location

The database is stored at:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

To get the actual path:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Backup Strategies

#### 1. Manual Backup (File Export)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

The application copies the `.db` file to a temporary location. The user can then share this file (Google Drive, email, etc.).

**Security improvements**:
- Verifies that the database file exists **before** accessing the database (prevents automatic creation)
- Throws exception if the database is in-memory (cannot be exported)

#### 2. Backup Import

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Notes**:
- An automatic backup of the current file is created before importing (`.backup`)
- If import fails, the backup is automatically restored
- **Complete cleanup**: Deletes WAL (Write-Ahead Log) and SHM (Shared Memory) files before importing to avoid conflicts
- Includes a 100ms delay after import to ensure file system operations complete
- Verifies the integrity of the imported database before confirming

#### 3. Automatic Backup (Recommended for Production)

Implement an automatic cloud backup system:

```dart
// Pseudocode
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, etc.
  });
}
```

### Data Export (JSON)

For maximum portability, the entire database can be exported to JSON:

```dart
Future<Map<String, dynamic>> exportToJson() async {
  final db = await DatabaseHelper.instance.database;

  return {
    'version': 19,
    'exportDate': DateTime.now().toIso8601String(),
    'persons': await db.query('persons'),
    'medications': await db.query('medications'),
    'person_medications': await db.query('person_medications'),
    'dose_history': await db.query('dose_history'),
  };
}
```

**Advantages**:
- Human-readable format
- Easy to inspect and debug
- SQLite-independent

**Disadvantages**:
- Larger file than `.db`
- Requires parsing when importing

---

## Complete Usage Example

### Scenario: Ana and Carlos share Ibuprofen

```sql
-- 1. Create persons
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Create shared medication (Ibuprofen)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofeno 600mg', 'pill', 40.0, 3);

-- 3. Assign to Ana with her schedule (08:00 and 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Assign to Carlos with his schedule (14:00 only)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana takes a dose at 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofeno 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Update stock (39.0 remaining)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Update Ana's takenDosesToday
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Query remaining stock (visible to both)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Result: 39.0

-- 9. Query Ana's adherence
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Summary

- **Version**: V19 (SQLite)
- **Main Tables**: `persons`, `medications`, `person_medications`, `dose_history`
- **Architecture**: Multi-person with shared data (stock) and individual configurations (schedules)
- **Migrations**: Automatic progressive system V1→V19
- **Integrity**: Foreign keys with cascades, optimized indexes
- **Optimizations**: Batch transactions, prepared statements, in-memory cache, strategic denormalization
- **Backup**: `.db` file and JSON export, import with automatic rollback

This database is designed to support multi-user medication management applications with high performance and data integrity guarantees.
