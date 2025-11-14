# Base de Dades MedicApp - SQLite V19

## Visió General

MedicApp utilitza SQLite V19 com a sistema de gestió de base de dades local. L'arquitectura està dissenyada per suportar múltiples persones (usuaris) que poden compartir medicaments però mantenir configuracions i pautes individuals.

### Característiques Principals

- **Versió Actual**: V19 (última versió estable)
- **Motor**: SQLite amb `sqflite` (Flutter)
- **Arquitectura**: Multi-persona amb dades compartides i configuracions individuals
- **Ubicació**: `medications.db` al directori de base de dades de l'aplicació
- **Migracions**: Sistema automàtic de migracions progressives (V1 → V19)
- **Integritat**: Claus foranes habilitades amb cascades d'eliminació
- **Índexs**: Optimitzats per a consultes freqüents

### Filosofia de Disseny

La base de dades V19 implementa una **separació clara entre dades compartides i dades individuals**:

- **Dades Compartides** (taula `medications`): Estoc de medicaments que pot ser utilitzat per qualsevol persona
- **Dades Individuals** (taula `person_medications`): Pautes, horaris i configuracions específiques de cada persona
- **Relació N:N**: Una persona pot tenir múltiples medicaments, i un medicament pot ser assignat a múltiples persones

---

## Esquema de Taules

### Taula: `persons`

Emmagatzema les persones que utilitzen l'aplicació (usuaris, familiars, pacients).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Camps

| Camp | Tipus | Descripció |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador únic de la persona (UUID en format string) |
| `name` | TEXT NOT NULL | Nom de la persona |
| `isDefault` | INTEGER NOT NULL | 1 si és la persona per defecte (usuari principal), 0 en cas contrari |

#### Regles

- Ha d'existir almenys una persona amb `isDefault = 1`
- Els IDs es generen com timestamps en mil·lisegons
- El nom no pot estar buit

---

### Taula: `medications`

Emmagatzema les **dades compartides** dels medicaments (nom, tipus, estoc).

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

#### Camps

| Camp | Tipus | Descripció |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador únic del medicament (UUID en format string) |
| `name` | TEXT NOT NULL | Nom del medicament (ex: "Ibuprofèn 600mg") |
| `type` | TEXT NOT NULL | Tipus de medicament: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Quantitat actual en estoc (compartida entre totes les persones) |
| `lastRefillAmount` | REAL | Última quantitat afegida a l'estoc (suggeriment per a futurs reabastiments) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Dies de llindar per mostrar alerta d'estoc baix (per defecte: 3) |
| `lastDailyConsumption` | REAL | Última quantitat consumida en un dia (per a medicaments "segons necessitat") |

#### Notes

- **Estoc Compartit**: El `stockQuantity` és únic i es comparteix entre totes les persones que usen el medicament
- **Deduplicació**: Si dues persones afegeixen el mateix medicament (nom coincident, case-insensitive), es reutilitza el registre existent
- **Tipus**: El camp `type` determina la unitat de mesura (píndoles, ml, gotes, etc.)

---

### Taula: `person_medications`

Taula de relació N:N que emmagatzema la **pauta individual** de cada persona per a un medicament específic.

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

#### Camps

| Camp | Tipus | Descripció |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador únic de la relació persona-medicament |
| `personId` | TEXT NOT NULL | FK a `persons.id` |
| `medicationId` | TEXT NOT NULL | FK a `medications.id` |
| `assignedDate` | TEXT NOT NULL | Data ISO8601 quan es va assignar el medicament a la persona |
| `durationType` | TEXT NOT NULL | Tipus de durada: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Interval d'hores entre dosis (0 si no aplica) |
| `doseSchedule` | TEXT NOT NULL | JSON amb mapa d'hora → quantitat (ex: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Llista CSV d'hores preses avui (ex: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Llista CSV d'hores omeses avui (ex: `"14:00"`) |
| `takenDosesDate` | TEXT | Data ISO8601 de les dosis preses/omeses (ex: `"2025-11-14"`) |
| `selectedDates` | TEXT | Llista CSV de dates específiques per a `durationType = specificDates` |
| `weeklyDays` | TEXT | Llista CSV de dies de la setmana (1=Dilluns, 7=Diumenge) per a `weeklyPattern` |
| `dayInterval` | INTEGER | Interval de dies per a `durationType = intervalDays` (ex: 2 = cada 2 dies) |
| `startDate` | TEXT | Data ISO8601 d'inici del tractament |
| `endDate` | TEXT | Data ISO8601 de fi del tractament |
| `requiresFasting` | INTEGER NOT NULL | 1 si requereix dejuni, 0 en cas contrari |
| `fastingType` | TEXT | Tipus de dejuni: `before` o `after` |
| `fastingDurationMinutes` | INTEGER | Durada del dejuni en minuts (ex: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 si ha de notificar períodes de dejuni, 0 en cas contrari |
| `isSuspended` | INTEGER NOT NULL | 1 si el medicament està suspès (sense notificacions), 0 en cas contrari |

#### Notes

- **Relació Única**: Una persona no pot tenir el mateix medicament assignat dues vegades (`UNIQUE(personId, medicationId)`)
- **Cascades**: Si s'elimina una persona o medicament, s'eliminen automàticament les relacions
- **doseSchedule**: Emmagatzemat com a JSON per a flexibilitat (ex: diferents quantitats en diferents hores)
- **Tipus de Durada**:
  - `everyday`: Tots els dies
  - `untilFinished`: Fins acabar l'estoc
  - `specificDates`: Només en dates específiques (emmagatzemades a `selectedDates`)
  - `weeklyPattern`: Dies específics de la setmana (emmagatzemats a `weeklyDays`)
  - `intervalDays`: Cada N dies (especificat a `dayInterval`)
  - `asNeeded`: Segons necessitat (sense horari fix)

---

### Taula: `dose_history`

Registre històric de totes les dosis preses o omeses.

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

#### Camps

| Camp | Tipus | Descripció |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador únic de l'entrada d'historial |
| `medicationId` | TEXT NOT NULL | ID del medicament (desnormalitzat per a rendiment) |
| `medicationName` | TEXT NOT NULL | Nom del medicament (desnormalitzat) |
| `medicationType` | TEXT NOT NULL | Tipus del medicament (desnormalitzat) |
| `personId` | TEXT NOT NULL | FK a `persons.id` - persona que va prendre/ometre la dosi |
| `scheduledDateTime` | TEXT NOT NULL | Data i hora ISO8601 programada per a la dosi |
| `registeredDateTime` | TEXT NOT NULL | Data i hora ISO8601 real quan es va registrar la presa/omissió |
| `status` | TEXT NOT NULL | Estat de la dosi: `taken` o `skipped` |
| `quantity` | REAL NOT NULL | Quantitat presa (en unitats del tipus de medicament) |
| `isExtraDose` | INTEGER NOT NULL | 1 si és una dosi extra (fora de l'horari), 0 si és programada |
| `notes` | TEXT | Notes opcionals sobre la dosi |

#### Notes

- **Desnormalització**: `medicationName` i `medicationType` s'emmagatzemen aquí per evitar JOINs en consultes d'historial
- **Cascada**: Si s'elimina una persona, s'eliminen els seus registres d'historial
- **No hi ha FK a medications**: L'historial es manté fins i tot si s'elimina el medicament
- **Retard**: La diferència entre `scheduledDateTime` i `registeredDateTime` indica si la dosi va ser puntual

---

## Relacions entre Taules

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
         │ [pauta individual]   │
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
         │ medicationId     │ (no FK, desnormalitzat)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Claus Foranes

| Taula | Columna | Referència | On Delete |
|-------|---------|------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Índexs

Els següents índexs estan creats per optimitzar consultes freqüents:

```sql
-- Índex per buscar dosis per medicament
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Índex per buscar dosis per data programada
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Índex per buscar medicaments d'una persona
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Índex per buscar persones assignades a un medicament
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Propòsit de Cada Índex

- **`idx_dose_history_medication`**: Accelera consultes d'historial filtrades per medicament (ex: veure totes les preses d'Ibuprofèn)
- **`idx_dose_history_date`**: Optimitza consultes per rang de dates (ex: historial dels últims 7 dies)
- **`idx_person_medications_person`**: Millora la càrrega de medicaments d'una persona específica (consulta més freqüent)
- **`idx_person_medications_medication`**: Facilita trobar quines persones estan usant un medicament

---

## Triggers

Actualment no hi ha triggers implementats a la base de dades. La lògica de negoci es gestiona a la capa d'aplicació (Dart).

**Possibles Triggers Futurs:**

```sql
-- Exemple: Actualitzar automàticament estoc en registrar una dosi presa
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Nota**: Aquest trigger no està implementat perquè el control d'estoc es gestiona explícitament al codi de l'aplicació per a major flexibilitat.

---

## Migracions

### Historial de Versions (V1 → V19)

| Versió | Canvis Principals |
|---------|---------------------|
| **V1** | Esquema inicial: taula `medications` bàsica |
| **V2** | Afegit `doseTimes` (horaris de dosis) |
| **V3** | Afegit `stockQuantity` (gestió d'inventari) |
| **V4** | Afegits `takenDosesToday`, `takenDosesDate` (tracking de preses diàries) |
| **V5** | Afegit `doseSchedule` (quantitats variables per horari) |
| **V6** | Afegit `skippedDosesToday` (tracking de dosis omeses) |
| **V7** | Afegit `lastRefillAmount` (suggeriments de reabastiment) |
| **V8** | Afegit `lowStockThresholdDays` (llindar configurable) |
| **V9** | Afegits `selectedDates`, `weeklyDays` (patrons de tractament) |
| **V10** | Afegits `startDate`, `endDate` (rang de tractament) |
| **V11** | Creada taula `dose_history` (historial complet de dosis) |
| **V12** | Afegit `dayInterval` (tractaments cada N dies) |
| **V13** | Afegits camps de dejuni: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Afegit `isSuspended` (suspensió temporal de medicaments) |
| **V15** | Afegit `lastDailyConsumption` (tracking per a medicaments "segons necessitat") |
| **V16** | Afegits `extraDosesToday` i `isExtraDose` (dosis fora d'horari) |
| **V17** | Creada taula `persons` (suport multi-persona) |
| **V18** | Creada taula `person_medications` (relació N:N), afegit `personId` a `dose_history` |
| **V19** | **Reestructuració major**: Separació de dades compartides (medications) i pautes individuals (person_medications) |

### Migració V18 → V19 (Reestructuració Major)

La migració V19 és la més complexa i important. Separa les dades de medicaments en dues taules:

#### Procés de Migració

1. **Backup**: Es renombren les taules existents a `_old`
2. **Noves Taules**: Es creen `medications` i `person_medications` amb el nou esquema
3. **Migració de Dades Compartides**: Es copien `id`, `name`, `type`, `stockQuantity`, etc. a `medications`
4. **Migració de Pautes Individuals**: Es copien horaris, durada, dejuni, etc. a `person_medications`
5. **Recreació d'Índexs**: Es creen els índexs optimitzats
6. **Neteja**: S'eliminen les taules `_old`

```sql
-- Pas 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Pas 2: Crear nova taula medications (només dades compartides)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Pas 3: Copiar dades compartides
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Pas 4: Crear nova taula person_medications (pautes individuals)
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

-- Pas 5: Migrar pautes individuals
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

-- Pas 6: Recrear índexs
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Pas 7: Neteja
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Sistema de Migració Automàtica

El sistema detecta automàticament la versió actual de la base de dades i aplica migracions progressives:

```dart
// A database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Versió objectiu
    onCreate: _createDB,  // Per a bases de dades noves
    onUpgrade: _upgradeDB,  // Per migrar des de versions anteriors
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Aplica migracions progressives des de oldVersion fins newVersion
  if (oldVersion < 2) { /* Migració V1→V2 */ }
  if (oldVersion < 3) { /* Migració V2→V3 */ }
  // ... fins V19
}
```

**Avantatges**:
- **Progressiu**: Un usuari amb V1 s'actualitza automàticament fins V19
- **Sense pèrdua de dades**: Cada migració preserva les dades existents
- **Tolerant a errors**: Si falla una migració, la base de dades roman en l'estat anterior

---

## Regles de Negoci

### 1. Estoc Compartit entre Persones

- El `stockQuantity` a la taula `medications` és **únic i compartit**
- Quan qualsevol persona registra una dosi presa, l'estoc es decrementa per a tots
- **Exemple**: Si hi ha 20 píndoles d'Ibuprofèn i Anna en pren 1, en queden 19 per a tots (incloent Carles)

### 2. Configuracions Individuals per Persona

- Cada persona pot tenir **horaris diferents** per al mateix medicament
- **Exemple**:
  - Anna pren Ibuprofèn a les 08:00 i 20:00
  - Carles pren el mateix Ibuprofèn només a les 14:00

### 3. Validacions d'Integritat

```sql
-- Una persona no pot tenir el mateix medicament dues vegades
UNIQUE(personId, medicationId) a person_medications

-- Ha d'existir almenys una persona per defecte
-- (Validat a la capa d'aplicació)
```

### 4. Cascades d'Eliminació

- **Eliminar persona** → S'eliminen totes les seves relacions a `person_medications` i el seu historial a `dose_history`
- **Eliminar medicament** → S'eliminen totes les relacions a `person_medications`, però **NO** l'historial (per a auditoria)

### 5. Deduplicació de Medicaments

Quan es crea un medicament, el sistema verifica si ja n'existeix un amb el mateix nom (case-insensitive):

```dart
// Pseudocodi
if (exists medication with same name) {
  reutilitzar medicament existent
  crear només nova entrada a person_medications
} else {
  crear nou medicament
  crear entrada a person_medications
}
```

---

## Consultes SQL Comunes

### 1. Obtenir Medicaments d'una Persona

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

### 2. Registrar una Presa de Medicament

```sql
-- Pas 1: Inserir a historial
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Pas 2: Actualitzar estoc (només si és dosi programada, no extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Pas 3: Actualitzar takenDosesToday a person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Afegir hora presa
  takenDosesDate = ?     -- Actualitzar data
WHERE personId = ? AND medicationId = ?;
```

### 3. Calcular Estoc Disponible i Alertes

```sql
-- Obtenir medicaments amb estoc baix per a una persona
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
    -- Calcular estoc mínim basat en dosi diària
    -- (Aquesta lògica es fa a l'aplicació perquè doseSchedule és JSON)
  );
```

### 4. Obtenir Historial de Dosis (Últims 30 Dies)

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

### 5. Calcular Adherència (% de Dosis Preses)

```sql
-- Total de dosis programades
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Dosis preses
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Adherència = (taken / total) * 100
```

### 6. Obtenir Persones Assignades a un Medicament

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Verificar si un Medicament Ja Existeix (per nom)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimitzacions

### 1. Transaccions Batch

Per a operacions que modifiquen múltiples taules, s'utilitzen transaccions:

```dart
await db.transaction((txn) async {
  // Múltiples operacions atòmiques
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Avantatges**:
- Atomicitat: Tot es guarda o res es guarda
- Consistència: No hi ha estats intermedis
- Rendiment: Una sola escriptura al disc

### 2. Prepared Statements

Totes les consultes utilitzen prepared statements amb placeholders (`?`) per prevenir SQL injection i millorar rendiment:

```dart
// ✅ Correcte (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Incorrecte (vulnerable a SQL injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Índexs Selectius

Els índexs estan dissenyats per a les consultes més freqüents:
- `idx_person_medications_person`: Per a la pantalla principal (mostrar medicaments de l'usuari)
- `idx_dose_history_medication`: Per a l'historial d'un medicament específic
- `idx_dose_history_date`: Per a consultes per rang de dates

### 4. Desnormalització Estratègica

A `dose_history` s'emmagatzemen `medicationName` i `medicationType` (desnormalitzats) per evitar JOINs costosos en consultes d'historial. Això sacrifica una mica d'espai per molt rendiment.

### 5. Caché en Memòria

L'aplicació utilitza caché per a la persona per defecte:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Consultar base de dades només si no està a caché
}
```

### 6. ANALYZE i VACUUM

**ANALYZE**: Actualitza estadístiques de la base de dades per optimitzar el query planner.

```sql
ANALYZE;
```

**VACUUM**: Reconstrueix la base de dades per alliberar espai i optimitzar.

```sql
VACUUM;
```

**Recomanació**: Executar `ANALYZE` després de canvis massius de dades, i `VACUUM` periòdicament (ex: cada 3 mesos).

---

## Backup i Restauració

### Ubicació de l'Arxiu de Base de Dades

La base de dades s'emmagatzema a:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Per obtenir la ruta real:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Estratègies de Backup

#### 1. Backup Manual (Exportació d'Arxiu)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

L'aplicació copia l'arxiu `.db` a una ubicació temporal. L'usuari pot després compartir aquest arxiu (Google Drive, correu, etc.).

#### 2. Importació de Backup

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Notes**:
- Es crea un backup automàtic de l'arxiu actual abans d'importar (`.backup`)
- Si la importació falla, es restaura automàticament el backup

#### 3. Backup Automàtic (Recomanat per a Producció)

Implementar un sistema de backup automàtic al núvol:

```dart
// Pseudocodi
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, etc.
  });
}
```

### Exportació de Dades (JSON)

Per a màxima portabilitat, es pot exportar la base de dades completa a JSON:

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

**Avantatges**:
- Format llegible per humans
- Fàcil d'inspeccionar i depurar
- Independent de SQLite

**Desavantatges**:
- Arxiu més gran que `.db`
- Requereix parseig en importar

---

## Exemple d'Ús Complet

### Escenari: Anna i Carles comparteixen Ibuprofèn

```sql
-- 1. Crear persones
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Anna', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carles', 0);

-- 2. Crear medicament compartit (Ibuprofèn)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofèn 600mg', 'pill', 40.0, 3);

-- 3. Assignar a Anna amb la seva pauta (08:00 i 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Assignar a Carles amb la seva pauta (14:00 solament)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Anna pren una dosi a les 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofèn 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Actualitzar estoc (queda 39.0)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Actualitzar takenDosesToday d'Anna
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Consultar estoc restant (visible per a tots dos)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Resultat: 39.0

-- 9. Consultar adherència d'Anna
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Resum

- **Versió**: V19 (SQLite)
- **Taules Principals**: `persons`, `medications`, `person_medications`, `dose_history`
- **Arquitectura**: Multi-persona amb dades compartides (estoc) i configuracions individuals (pautes)
- **Migracions**: Sistema automàtic progressiu V1→V19
- **Integritat**: Claus foranes amb cascades, índexs optimitzats
- **Optimitzacions**: Transaccions batch, prepared statements, caché en memòria, desnormalització estratègica
- **Backup**: Exportació d'arxiu `.db` i JSON, importació amb rollback automàtic

Aquesta base de dades està dissenyada per suportar aplicacions de gestió de medicaments multi-usuari amb alt rendiment i garanties d'integritat de dades.
