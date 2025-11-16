# MedicApp-Datenbank - SQLite V19

## Übersicht

MedicApp verwendet SQLite V19 als lokales Datenbankverwaltungssystem. Die Architektur ist so konzipiert, dass sie mehrere Personen (Benutzer) unterstützt, die Medikamente teilen können, aber individuelle Konfigurationen und Schemata beibehalten.

### Hauptmerkmale

- **Aktuelle Version**: V19 (neueste stabile Version)
- **Engine**: SQLite mit `sqflite` (Flutter)
- **Architektur**: Multi-Personen mit geteilten Daten und individuellen Konfigurationen
- **Speicherort**: `medications.db` im Datenbankverzeichnis der Anwendung
- **Migrationen**: Automatisches progressives Migrationssystem (V1 → V19)
- **Integrität**: Fremdschlüssel explizit in `onOpen` aktiviert mit Löschkaskaden
- **Indizes**: Optimiert für häufige Abfragen

### Design-Philosophie

Die V19-Datenbank implementiert eine **klare Trennung zwischen geteilten und individuellen Daten**:

- **Geteilte Daten** (Tabelle `medications`): Medikamentenbestand, der von jeder Person genutzt werden kann
- **Individuelle Daten** (Tabelle `person_medications`): Personenspezifische Schemata, Zeitpläne und Konfigurationen
- **N:N-Beziehung**: Eine Person kann mehrere Medikamente haben, und ein Medikament kann mehreren Personen zugewiesen werden

---

## Tabellenschema

### Tabelle: `persons`

Speichert die Personen, die die Anwendung nutzen (Benutzer, Familienmitglieder, Patienten).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Felder

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | TEXT PRIMARY KEY | Eindeutiger Personenbezeichner (UUID im String-Format) |
| `name` | TEXT NOT NULL | Name der Person |
| `isDefault` | INTEGER NOT NULL | 1 wenn Standardperson (Hauptbenutzer), sonst 0 |

#### Regeln

- Es muss mindestens eine Person mit `isDefault = 1` existieren
- IDs werden als Millisekunden-Zeitstempel generiert (Format: Millisekunden seit Epoch)
- Der Name darf nicht leer sein

---

### Tabelle: `medications`

Speichert die **geteilten Daten** der Medikamente (Name, Typ, Bestand).

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

#### Felder

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | TEXT PRIMARY KEY | Eindeutiger Medikamentenbezeichner (UUID im String-Format) |
| `name` | TEXT NOT NULL | Medikamentenname (z.B.: "Ibuprofen 600mg") |
| `type` | TEXT NOT NULL | Medikamententyp: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Aktueller Bestand (geteilt zwischen allen Personen) |
| `lastRefillAmount` | REAL | Zuletzt hinzugefügte Menge zum Bestand (Vorschlag für zukünftige Nachfüllungen) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Tage-Schwellenwert für Warnung bei niedrigem Bestand (Standard: 3) |
| `lastDailyConsumption` | REAL | Zuletzt verbrauchte Menge an einem Tag (für "nach Bedarf"-Medikamente) |

#### Hinweise

- **Geteilter Bestand**: Die `stockQuantity` ist einzigartig und wird zwischen allen Personen geteilt, die das Medikament verwenden
- **Deduplizierung**: Wenn zwei Personen dasselbe Medikament hinzufügen (übereinstimmender Name, Groß-/Kleinschreibung ignoriert), wird der vorhandene Datensatz wiederverwendet
- **Typen**: Das Feld `type` bestimmt die Maßeinheit (Tabletten, ml, Tropfen usw.)

---

### Tabelle: `person_medications`

N:N-Beziehungstabelle, die das **individuelle Schema** jeder Person für ein bestimmtes Medikament speichert.

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

#### Felder

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | TEXT PRIMARY KEY | Eindeutiger Bezeichner der Person-Medikament-Beziehung (UUID v4) |
| `personId` | TEXT NOT NULL | Fremdschlüssel zu `persons.id` |
| `medicationId` | TEXT NOT NULL | Fremdschlüssel zu `medications.id` |
| `assignedDate` | TEXT NOT NULL | ISO8601-Datum, wann das Medikament der Person zugewiesen wurde |
| `durationType` | TEXT NOT NULL | Dauertyp: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Stundenintervall zwischen Dosen (0 wenn nicht zutreffend) |
| `doseSchedule` | TEXT NOT NULL | JSON mit Uhrzeit → Menge Map (z.B.: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | CSV-Liste der heute eingenommenen Uhrzeiten (z.B.: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | CSV-Liste der heute ausgelassenen Uhrzeiten (z.B.: `"14:00"`) |
| `takenDosesDate` | TEXT | ISO8601-Datum der eingenommenen/ausgelassenen Dosen (z.B.: `"2025-11-14"`) |
| `selectedDates` | TEXT | CSV-Liste bestimmter Daten für `durationType = specificDates` |
| `weeklyDays` | TEXT | CSV-Liste der Wochentage (1=Montag, 7=Sonntag) für `weeklyPattern` |
| `dayInterval` | INTEGER | Tagesintervall für `durationType = intervalDays` (z.B.: 2 = alle 2 Tage) |
| `startDate` | TEXT | ISO8601-Startdatum der Behandlung |
| `endDate` | TEXT | ISO8601-Enddatum der Behandlung |
| `requiresFasting` | INTEGER NOT NULL | 1 wenn Fasten erforderlich, sonst 0 |
| `fastingType` | TEXT | Fastentyp: `before` oder `after` |
| `fastingDurationMinutes` | INTEGER | Fastendauer in Minuten (z.B.: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 wenn über Fastenphasen benachrichtigt werden soll, sonst 0 |
| `isSuspended` | INTEGER NOT NULL | 1 wenn Medikament ausgesetzt (keine Benachrichtigungen), sonst 0 |

#### Hinweise

- **Eindeutige Beziehung**: Eine Person kann dasselbe Medikament nicht zweimal zugewiesen haben (`UNIQUE(personId, medicationId)`)
- **Kaskaden**: Wenn eine Person oder ein Medikament gelöscht wird, werden die Beziehungen automatisch gelöscht
- **doseSchedule**: Als JSON gespeichert für Flexibilität (z.B.: unterschiedliche Mengen zu verschiedenen Zeiten)
- **Dauertypen**:
  - `everyday`: Jeden Tag
  - `untilFinished`: Bis Bestand aufgebraucht
  - `specificDates`: Nur an bestimmten Daten (gespeichert in `selectedDates`)
  - `weeklyPattern`: Bestimmte Wochentage (gespeichert in `weeklyDays`)
  - `intervalDays`: Alle N Tage (angegeben in `dayInterval`)
  - `asNeeded`: Nach Bedarf (kein fester Zeitplan)

---

### Tabelle: `dose_history`

Historischer Eintrag aller eingenommenen oder ausgelassenen Dosen.

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

#### Felder

| Feld | Typ | Beschreibung |
|------|-----|--------------|
| `id` | TEXT PRIMARY KEY | Eindeutiger Bezeichner des Historieneintrags |
| `medicationId` | TEXT NOT NULL | Medikamenten-ID (denormalisiert für Leistung) |
| `medicationName` | TEXT NOT NULL | Medikamentenname (denormalisiert) |
| `medicationType` | TEXT NOT NULL | Medikamententyp (denormalisiert) |
| `personId` | TEXT NOT NULL | Fremdschlüssel zu `persons.id` - Person, die Dosis eingenommen/ausgelassen hat |
| `scheduledDateTime` | TEXT NOT NULL | ISO8601-Datum und -Uhrzeit der geplanten Dosis |
| `registeredDateTime` | TEXT NOT NULL | ISO8601-Datum und -Uhrzeit der tatsächlichen Registrierung der Einnahme/Auslassung |
| `status` | TEXT NOT NULL | Dosisstatus: `taken` oder `skipped` |
| `quantity` | REAL NOT NULL | Eingenommene Menge (in Einheiten des Medikamententyps) |
| `isExtraDose` | INTEGER NOT NULL | 1 wenn Extra-Dosis (außerhalb des Zeitplans), 0 wenn geplant |
| `notes` | TEXT | Optionale Notizen zur Dosis |

#### Hinweise

- **Denormalisierung**: `medicationName` und `medicationType` werden hier gespeichert, um JOINs in Historienabfragen zu vermeiden
- **Kaskade**: Wenn eine Person gelöscht wird, werden ihre Historieneinträge gelöscht
- **Kein Fremdschlüssel zu medications**: Die Historie bleibt erhalten, auch wenn das Medikament gelöscht wird
- **Verzögerung**: Die Differenz zwischen `scheduledDateTime` und `registeredDateTime` zeigt an, ob die Dosis pünktlich war

---

## Beziehungen zwischen Tabellen

```
┌──────────────┐
│   persons    │
│──────────────│
│ id (PK)      │───┐
│ name         │   │
│ isDefault    │   │
└──────────────┘   │
                   │ 1:N
                   │
                   ↓
         ┌──────────────────────┐
         │ person_medications   │
         │──────────────────────│
         │ id (PK)              │
         │ personId (FK)        │──→ persons.id
         │ medicationId (FK)    │──→ medications.id
         │ [individuelles       │
         │  Schema]             │
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
         │ [Bestandsdaten]  │
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
         │ medicationId     │ (kein Fremdschlüssel, denormalisiert)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Fremdschlüssel

| Tabelle | Spalte | Referenz | Bei Löschung |
|---------|--------|----------|--------------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Indizes

Die folgenden Indizes sind erstellt, um häufige Abfragen zu optimieren:

```sql
-- Index zum Suchen von Dosen nach Medikament
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Index zum Suchen von Dosen nach geplantem Datum
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Index zum Suchen von Medikamenten einer Person
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Index zum Suchen von Personen, die einem Medikament zugewiesen sind
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Zweck jedes Index

- **`idx_dose_history_medication`**: Beschleunigt Historienabfragen gefiltert nach Medikament (z.B.: alle Einnahmen von Ibuprofen sehen)
- **`idx_dose_history_date`**: Optimiert Abfragen nach Datumsbereich (z.B.: Historie der letzten 7 Tage)
- **`idx_person_medications_person`**: Verbessert das Laden von Medikamenten einer bestimmten Person (häufigste Abfrage)
- **`idx_person_medications_medication`**: Erleichtert das Finden welche Personen ein Medikament verwenden

---

## Trigger

Aktuell sind keine Trigger in der Datenbank implementiert. Die Geschäftslogik wird in der Anwendungsschicht (Dart) verwaltet.

**Mögliche zukünftige Trigger:**

```sql
-- Beispiel: Bestand automatisch beim Registrieren einer eingenommenen Dosis aktualisieren
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Hinweis**: Dieser Trigger ist nicht implementiert, da die Bestandskontrolle im Anwendungscode für größere Flexibilität explizit verwaltet wird.

---

## Migrationen

### Versionsverlauf (V1 → V19)

| Version | Hauptänderungen |
|---------|-----------------|
| **V1** | Anfangsschema: Basis-Tabelle `medications` |
| **V2** | `doseTimes` hinzugefügt (Dosiszeiten) |
| **V3** | `stockQuantity` hinzugefügt (Bestandsverwaltung) |
| **V4** | `takenDosesToday`, `takenDosesDate` hinzugefügt (tägliche Einnahme-Verfolgung) |
| **V5** | `doseSchedule` hinzugefügt (variable Mengen nach Uhrzeit) |
| **V6** | `skippedDosesToday` hinzugefügt (Verfolgung ausgelassener Dosen) |
| **V7** | `lastRefillAmount` hinzugefügt (Nachfüllvorschläge) |
| **V8** | `lowStockThresholdDays` hinzugefügt (konfigurierbarer Schwellenwert) |
| **V9** | `selectedDates`, `weeklyDays` hinzugefügt (Behandlungsmuster) |
| **V10** | `startDate`, `endDate` hinzugefügt (Behandlungsbereich) |
| **V11** | Tabelle `dose_history` erstellt (vollständige Dosishistorie) |
| **V12** | `dayInterval` hinzugefügt (Behandlungen alle N Tage) |
| **V13** | Fastenfelder hinzugefügt: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | `isSuspended` hinzugefügt (temporäre Aussetzung von Medikamenten) |
| **V15** | `lastDailyConsumption` hinzugefügt (Verfolgung für "nach Bedarf"-Medikamente) |
| **V16** | `extraDosesToday` und `isExtraDose` hinzugefügt (Dosen außerhalb des Zeitplans) |
| **V17** | Tabelle `persons` erstellt (Multi-Personen-Unterstützung) |
| **V18** | Tabelle `person_medications` erstellt (N:N-Beziehung), `personId` zu `dose_history` hinzugefügt |
| **V19** | **Große Umstrukturierung**: Trennung geteilter Daten (medications) und individueller Schemata (person_medications) |

### Migration V18 → V19 (Große Umstrukturierung)

Die V19-Migration ist die komplexeste und wichtigste. Sie trennt die Medikamentendaten in zwei Tabellen:

#### Migrationsprozess

1. **Backup**: Vorhandene Tabellen werden in `_old` umbenannt
2. **Neue Tabellen**: `medications` und `person_medications` mit neuem Schema werden erstellt
3. **Migration geteilter Daten**: `id`, `name`, `type`, `stockQuantity` usw. werden nach `medications` kopiert
4. **Migration individueller Schemata**: Zeitpläne, Dauer, Fasten usw. werden nach `person_medications` kopiert
5. **Index-Neuerstellung**: Optimierte Indizes werden erstellt
6. **Bereinigung**: `_old`-Tabellen werden gelöscht

```sql
-- Schritt 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Schritt 2: Neue medications-Tabelle erstellen (nur geteilte Daten)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Schritt 3: Geteilte Daten kopieren
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Schritt 4: Neue person_medications-Tabelle erstellen (individuelle Schemata)
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

-- Schritt 5: Individuelle Schemata migrieren
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

-- Schritt 6: Indizes neu erstellen
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Schritt 7: Bereinigung
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Automatisches Migrationssystem

Das System erkennt automatisch die aktuelle Datenbankversion und wendet progressive Migrationen an:

```dart
// In database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Zielversion
    onCreate: _createDB,  // Für neue Datenbanken
    onUpgrade: _upgradeDB,  // Zum Migrieren von früheren Versionen
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Wendet progressive Migrationen von oldVersion bis newVersion an
  if (oldVersion < 2) { /* Migration V1→V2 */ }
  if (oldVersion < 3) { /* Migration V2→V3 */ }
  // ... bis V19
}
```

**Vorteile**:
- **Progressiv**: Ein Benutzer mit V1 wird automatisch bis V19 aktualisiert
- **Ohne Datenverlust**: Jede Migration bewahrt vorhandene Daten
- **Fehlertolerant**: Wenn eine Migration fehlschlägt, bleibt die Datenbank im vorherigen Zustand

---

## Geschäftsregeln

### 1. Geteilter Bestand zwischen Personen

- Die `stockQuantity` in der Tabelle `medications` ist **einzigartig und geteilt**
- Wenn eine Person eine eingenommene Dosis registriert, wird der Bestand für alle verringert
- **Beispiel**: Wenn es 20 Ibuprofen-Tabletten gibt und Ana 1 nimmt, bleiben 19 für alle (einschließlich Carlos)

### 2. Individuelle Konfigurationen pro Person

- Jede Person kann **unterschiedliche Zeitpläne** für dasselbe Medikament haben
- **Beispiel**:
  - Ana nimmt Ibuprofen um 08:00 und 20:00
  - Carlos nimmt dasselbe Ibuprofen nur um 14:00

### 3. Integritätsvalidierungen

```sql
-- Eine Person kann dasselbe Medikament nicht zweimal haben
UNIQUE(personId, medicationId) in person_medications

-- Es muss mindestens eine Standardperson existieren
-- (Validiert in der Anwendungsschicht)
```

### 4. Löschkaskaden

- **Person löschen** → Alle ihre Beziehungen in `person_medications` und ihre Historie in `dose_history` werden gelöscht
- **Medikament löschen** → Alle Beziehungen in `person_medications` werden gelöscht, aber **NICHT** die Historie (für Audit)

### 5. Medikamenten-Deduplizierung

Beim Erstellen eines Medikaments prüft das System, ob bereits eines mit demselben Namen existiert (Groß-/Kleinschreibung ignoriert):

```dart
// Pseudocode
if (exists medication with same name) {
  vorhandenes Medikament wiederverwenden
  nur neuen Eintrag in person_medications erstellen
} else {
  neues Medikament erstellen
  Eintrag in person_medications erstellen
}
```

---

## Häufige SQL-Abfragen

### 1. Medikamente einer Person abrufen

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

### 2. Medikamenteneinnahme registrieren

```sql
-- Schritt 1: In Historie einfügen
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Schritt 2: Bestand aktualisieren (nur wenn geplante Dosis, nicht extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Schritt 3: takenDosesToday in person_medications aktualisieren
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Eingenommene Uhrzeit hinzufügen
  takenDosesDate = ?     -- Datum aktualisieren
WHERE personId = ? AND medicationId = ?;
```

### 3. Verfügbaren Bestand und Warnungen berechnen

```sql
-- Medikamente mit niedrigem Bestand für eine Person abrufen
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
    -- Mindestbestand basierend auf Tagesdosis berechnen
    -- (Diese Logik wird in der Anwendung durchgeführt, da doseSchedule JSON ist)
  );
```

### 4. Dosishistorie abrufen (Letzte 30 Tage)

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

### 5. Therapietreue berechnen (% eingenommener Dosen)

```sql
-- Gesamtzahl geplanter Dosen
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Eingenommene Dosen
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Therapietreue = (taken / total) * 100
```

### 6. Einem Medikament zugewiesene Personen abrufen

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Prüfen ob Medikament bereits existiert (nach Name)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimierungen

### 1. Batch-Transaktionen

Für Operationen, die mehrere Tabellen ändern, werden Transaktionen verwendet:

```dart
await db.transaction((txn) async {
  // Mehrere atomare Operationen
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Vorteile**:
- Atomarität: Alles wird gespeichert oder nichts wird gespeichert
- Konsistenz: Keine Zwischenzustände
- Leistung: Ein einziger Schreibvorgang auf Festplatte

### 2. Prepared Statements

Alle Abfragen verwenden Prepared Statements mit Platzhaltern (`?`) zur Vermeidung von SQL-Injection und zur Leistungsverbesserung:

```dart
// ✅ Korrekt (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Falsch (anfällig für SQL-Injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Selektive Indizes

Die Indizes sind für die häufigsten Abfragen konzipiert:
- `idx_person_medications_person`: Für Hauptbildschirm (Benutzermedikamente anzeigen)
- `idx_dose_history_medication`: Für Historie eines bestimmten Medikaments
- `idx_dose_history_date`: Für Abfragen nach Datumsbereich

### 4. Strategische Denormalisierung

In `dose_history` werden `medicationName` und `medicationType` (denormalisiert) gespeichert, um kostspielige JOINs in Historienabfragen zu vermeiden. Dies opfert etwas Speicherplatz für viel Leistung.

### 5. Arbeitsspeicher-Cache

Die Anwendung verwendet Cache für die Standardperson:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Datenbank nur abfragen wenn nicht im Cache
}
```

### 6. ANALYZE und VACUUM

**ANALYZE**: Aktualisiert Datenbankstatistiken zur Optimierung des Query-Planers.

```sql
ANALYZE;
```

**VACUUM**: Baut die Datenbank neu auf, um Speicherplatz freizugeben und zu optimieren.

```sql
VACUUM;
```

**Empfehlung**: `ANALYZE` nach massiven Datenänderungen ausführen, und `VACUUM` regelmäßig (z.B.: alle 3 Monate).

---

## Backup und Wiederherstellung

### Speicherort der Datenbankdatei

Die Datenbank wird gespeichert in:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Um den tatsächlichen Pfad zu erhalten:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Backup-Strategien

#### 1. Manuelles Backup (Datei-Export)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

Die Anwendung kopiert die `.db`-Datei an einen temporären Ort. Der Benutzer kann diese Datei dann teilen (Google Drive, E-Mail usw.).

**Sicherheitsverbesserungen**:
- Überprüft, ob die Datenbankdatei existiert **bevor** auf die Datenbank zugegriffen wird (verhindert automatische Erstellung)
- Wirft Ausnahme, wenn die Datenbank in-memory ist (kann nicht exportiert werden)

#### 2. Backup-Import

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Hinweise**:
- Es wird automatisch ein Backup der aktuellen Datei vor dem Import erstellt (`.backup`)
- Bei Fehlschlagen des Imports wird automatisch das Backup wiederhergestellt
- **Vollständige Bereinigung**: Löscht WAL (Write-Ahead Log) und SHM (Shared Memory) Dateien vor dem Import, um Konflikte zu vermeiden
- Enthält eine 100ms Verzögerung nach dem Import, um sicherzustellen, dass Dateisystemoperationen abgeschlossen sind
- Überprüft die Integrität der importierten Datenbank vor der Bestätigung

#### 3. Automatisches Backup (Empfohlen für Produktion)

Ein automatisches Cloud-Backup-System implementieren:

```dart
// Pseudocode
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox usw.
  });
}
```

### Datenexport (JSON)

Für maximale Portabilität kann die gesamte Datenbank nach JSON exportiert werden:

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

**Vorteile**:
- Von Menschen lesbares Format
- Einfach zu inspizieren und zu debuggen
- Unabhängig von SQLite

**Nachteile**:
- Größere Datei als `.db`
- Erfordert Parsing beim Import

---

## Vollständiges Verwendungsbeispiel

### Szenario: Ana und Carlos teilen sich Ibuprofen

```sql
-- 1. Personen erstellen
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Geteiltes Medikament erstellen (Ibuprofen)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofen 600mg', 'pill', 40.0, 3);

-- 3. Ana mit ihrem Schema zuweisen (08:00 und 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Carlos mit seinem Schema zuweisen (nur 14:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana nimmt eine Dosis um 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofen 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Bestand aktualisieren (bleibt 39.0)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. takenDosesToday von Ana aktualisieren
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Verbleibenden Bestand abfragen (für beide sichtbar)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Ergebnis: 39.0

-- 9. Therapietreue von Ana abfragen
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Zusammenfassung

- **Version**: V19 (SQLite)
- **Haupttabellen**: `persons`, `medications`, `person_medications`, `dose_history`
- **Architektur**: Multi-Personen mit geteilten Daten (Bestand) und individuellen Konfigurationen (Schemata)
- **Migrationen**: Automatisches progressives System V1→V19
- **Integrität**: Fremdschlüssel mit Kaskaden, optimierte Indizes
- **Optimierungen**: Batch-Transaktionen, Prepared Statements, Arbeitsspeicher-Cache, strategische Denormalisierung
- **Backup**: Export von `.db`-Datei und JSON, Import mit automatischem Rollback

Diese Datenbank ist konzipiert für Multi-Benutzer-Medikamentenverwaltungsanwendungen mit hoher Leistung und Datenintegritätsgarantien.
