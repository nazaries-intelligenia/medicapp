# Database MedicApp - SQLite V19

## Panoramica

MedicApp utilizza SQLite V19 come sistema di gestione di database locale. L'architettura è progettata per supportare più persone (utenti) che possono condividere farmaci mantenendo configurazioni e pautas individuali.

### Caratteristiche Principali

- **Versione Attuale**: V19 (ultima versione stabile)
- **Motore**: SQLite con `sqflite` (Flutter)
- **Architettura**: Multi-persona con dati condivisi e configurazioni individuali
- **Ubicazione**: `medications.db` nella directory del database dell'applicazione
- **Migrazioni**: Sistema automatico di migrazioni progressive (V1 → V19)
- **Integrità**: Chiavi esterne esplicitamente abilitate in `onOpen` con eliminazione a cascata
- **Indici**: Ottimizzati per query frequenti

### Filosofia di Design

Il database V19 implementa una **separazione netta tra dati condivisi e dati individuali**:

- **Dati Condivisi** (tabella `medications`): Stock di farmaci che può essere utilizzato da qualsiasi persona
- **Dati Individuali** (tabella `person_medications`): Pautas, orari e configurazioni specifiche di ogni persona
- **Relazione N:N**: Una persona può avere più farmaci, e un farmaco può essere assegnato a più persone

---

## Schema delle Tabelle

### Tabella: `persons`

Memorizza le persone che utilizzano l'applicazione (utenti, familiari, pazienti).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Campi

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificatore unico della persona (UUID in formato stringa) |
| `name` | TEXT NOT NULL | Nome della persona |
| `isDefault` | INTEGER NOT NULL | 1 se è la persona predefinita (utente principale), 0 in caso contrario |

#### Regole

- Deve esistere almeno una persona con `isDefault = 1`
- Gli ID si generano come timestamp (formato: millisecondi dall'epoch)
- Il nome non può essere vuoto

---

### Tabella: `medications`

Memorizza i **dati condivisi** dei farmaci (nome, tipo, stock).

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

#### Campi

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificatore unico del farmaco (UUID in formato stringa) |
| `name` | TEXT NOT NULL | Nome del farmaco (es: "Ibuprofene 600mg") |
| `type` | TEXT NOT NULL | Tipo di farmaco: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Quantità attuale in stock (condivisa tra tutte le persone) |
| `lastRefillAmount` | REAL | Ultima quantità aggiunta allo stock (suggerimento per futuri rifornimenti) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Giorni di soglia per mostrare avviso di stock basso (predefinito: 3) |
| `lastDailyConsumption` | REAL | Ultima quantità consumata in un giorno (per farmaci "al bisogno") |

#### Note

- **Stock Condiviso**: Lo `stockQuantity` è unico e condiviso tra tutte le persone che usano il farmaco
- **Deduplicazione**: Se due persone aggiungono lo stesso farmaco (nome coincidente, case-insensitive), viene riutilizzato il record esistente
- **Tipi**: Il campo `type` determina l'unità di misura (pillole, ml, gocce, ecc.)

---

### Tabella: `person_medications`

Tabella di relazione N:N che memorizza la **pauta individuale** di ogni persona per un farmaco specifico.

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

#### Campi

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificatore univoco per la relazione persona-farmaco (UUID v4) |
| `personId` | TEXT NOT NULL | FK a `persons.id` |
| `medicationId` | TEXT NOT NULL | FK a `medications.id` |
| `assignedDate` | TEXT NOT NULL | Data ISO8601 quando è stato assegnato il farmaco alla persona |
| `durationType` | TEXT NOT NULL | Tipo di durata: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Intervallo di ore tra dosi (0 se non applicabile) |
| `doseSchedule` | TEXT NOT NULL | JSON con mappa di ora → quantità (es: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Lista CSV di ore prese oggi (es: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Lista CSV di ore saltate oggi (es: `"14:00"`) |
| `takenDosesDate` | TEXT | Data ISO8601 delle dosi prese/saltate (es: `"2025-11-14"`) |
| `selectedDates` | TEXT | Lista CSV di date specifiche per `durationType = specificDates` |
| `weeklyDays` | TEXT | Lista CSV di giorni della settimana (1=Lunedì, 7=Domenica) per `weeklyPattern` |
| `dayInterval` | INTEGER | Intervallo di giorni per `durationType = intervalDays` (es: 2 = ogni 2 giorni) |
| `startDate` | TEXT | Data ISO8601 di inizio del trattamento |
| `endDate` | TEXT | Data ISO8601 di fine del trattamento |
| `requiresFasting` | INTEGER NOT NULL | 1 se richiede digiuno, 0 in caso contrario |
| `fastingType` | TEXT | Tipo di digiuno: `before` o `after` |
| `fastingDurationMinutes` | INTEGER | Durata del digiuno in minuti (es: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 se deve notificare periodi di digiuno, 0 in caso contrario |
| `isSuspended` | INTEGER NOT NULL | 1 se il farmaco è sospeso (senza notifiche), 0 in caso contrario |

#### Note

- **Relazione Unica**: Una persona non può avere lo stesso farmaco assegnato due volte (`UNIQUE(personId, medicationId)`)
- **Cascate**: Se si elimina una persona o un farmaco, vengono eliminate automaticamente le relazioni
- **doseSchedule**: Memorizzato come JSON per flessibilità (es: quantità diverse in orari diversi)
- **Tipi di Durata**:
  - `everyday`: Tutti i giorni
  - `untilFinished`: Fino a finire lo stock
  - `specificDates`: Solo in date specifiche (memorizzate in `selectedDates`)
  - `weeklyPattern`: Giorni specifici della settimana (memorizzati in `weeklyDays`)
  - `intervalDays`: Ogni N giorni (specificato in `dayInterval`)
  - `asNeeded`: Al bisogno (senza orario fisso)

---

### Tabella: `dose_history`

Registro storico di tutte le dosi prese o saltate.

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

#### Campi

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificatore unico della voce di storico |
| `medicationId` | TEXT NOT NULL | ID del farmaco (denormalizzato per prestazioni) |
| `medicationName` | TEXT NOT NULL | Nome del farmaco (denormalizzato) |
| `medicationType` | TEXT NOT NULL | Tipo del farmaco (denormalizzato) |
| `personId` | TEXT NOT NULL | FK a `persons.id` - persona che ha preso/saltato la dose |
| `scheduledDateTime` | TEXT NOT NULL | Data e ora ISO8601 programmata per la dose |
| `registeredDateTime` | TEXT NOT NULL | Data e ora ISO8601 reale quando è stata registrata l'assunzione/omissione |
| `status` | TEXT NOT NULL | Stato della dose: `taken` o `skipped` |
| `quantity` | REAL NOT NULL | Quantità presa (in unità del tipo di farmaco) |
| `isExtraDose` | INTEGER NOT NULL | 1 se è una dose extra (fuori orario), 0 se è programmata |
| `notes` | TEXT | Note opzionali sulla dose |

#### Note

- **Denormalizzazione**: `medicationName` e `medicationType` vengono memorizzati qui per evitare JOIN nelle query dello storico
- **Cascata**: Se si elimina una persona, vengono eliminati i suoi record di storico
- **No FK a medications**: Lo storico viene mantenuto anche se si elimina il farmaco
- **Ritardo**: La differenza tra `scheduledDateTime` e `registeredDateTime` indica se la dose è stata puntuale

---

## Relazioni tra Tabelle

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
         │ [pauta individuale]  │
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
         │ [dati stock]     │
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
         │ medicationId     │ (no FK, denormalizzato)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Chiavi Esterne

| Tabella | Colonna | Riferimento | On Delete |
|---------|---------|-------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Indici

I seguenti indici sono creati per ottimizzare query frequenti:

```sql
-- Indice per cercare dosi per farmaco
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Indice per cercare dosi per data programmata
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Indice per cercare farmaci di una persona
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Indice per cercare persone assegnate a un farmaco
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Scopo di Ogni Indice

- **`idx_dose_history_medication`**: Accelera query di storico filtrate per farmaco (es: vedere tutte le assunzioni di Ibuprofene)
- **`idx_dose_history_date`**: Ottimizza query per intervallo di date (es: storico degli ultimi 7 giorni)
- **`idx_person_medications_person`**: Migliora il caricamento dei farmaci di una persona specifica (query più frequente)
- **`idx_person_medications_medication`**: Facilita trovare quali persone stanno usando un farmaco

---

## Trigger

Attualmente non ci sono trigger implementati nel database. La logica di business viene gestita nel livello applicazione (Dart).

**Possibili Trigger Futuri:**

```sql
-- Esempio: Aggiornare automaticamente lo stock quando viene registrata una dose presa
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Nota**: Questo trigger non è implementato perché il controllo dello stock viene gestito esplicitamente nel codice dell'applicazione per maggiore flessibilità.

---

## Migrazioni

### Storico delle Versioni (V1 → V19)

| Versione | Modifiche Principali |
|----------|----------------------|
| **V1** | Schema iniziale: tabella `medications` di base |
| **V2** | Aggiunto `doseTimes` (orari di dose) |
| **V3** | Aggiunto `stockQuantity` (gestione inventario) |
| **V4** | Aggiunti `takenDosesToday`, `takenDosesDate` (tracking assunzioni giornaliere) |
| **V5** | Aggiunto `doseSchedule` (quantità variabili per orario) |
| **V6** | Aggiunto `skippedDosesToday` (tracking dosi saltate) |
| **V7** | Aggiunto `lastRefillAmount` (suggerimenti rifornimento) |
| **V8** | Aggiunto `lowStockThresholdDays` (soglia configurabile) |
| **V9** | Aggiunti `selectedDates`, `weeklyDays` (pattern di trattamento) |
| **V10** | Aggiunti `startDate`, `endDate` (intervallo di trattamento) |
| **V11** | Creata tabella `dose_history` (storico completo delle dosi) |
| **V12** | Aggiunto `dayInterval` (trattamenti ogni N giorni) |
| **V13** | Aggiunti campi digiuno: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Aggiunto `isSuspended` (sospensione temporanea dei farmaci) |
| **V15** | Aggiunto `lastDailyConsumption` (tracking per farmaci "al bisogno") |
| **V16** | Aggiunti `extraDosesToday` e `isExtraDose` (dosi fuori orario) |
| **V17** | Creata tabella `persons` (supporto multi-persona) |
| **V18** | Creata tabella `person_medications` (relazione N:N), aggiunto `personId` a `dose_history` |
| **V19** | **Ristrutturazione maggiore**: Separazione di dati condivisi (medications) e pautas individuali (person_medications) |

### Migrazione V18 → V19 (Ristrutturazione Maggiore)

La migrazione V19 è la più complessa e importante. Separa i dati dei farmaci in due tabelle:

#### Processo di Migrazione

1. **Backup**: Si rinominano le tabelle esistenti a `_old`
2. **Nuove Tabelle**: Si creano `medications` e `person_medications` con il nuovo schema
3. **Migrazione Dati Condivisi**: Si copiano `id`, `name`, `type`, `stockQuantity`, ecc. a `medications`
4. **Migrazione Pautas Individuali**: Si copiano orari, durata, digiuno, ecc. a `person_medications`
5. **Ricreazione Indici**: Si creano gli indici ottimizzati
6. **Pulizia**: Si eliminano le tabelle `_old`

```sql
-- Passo 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Passo 2: Creare nuova tabella medications (solo dati condivisi)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Passo 3: Copiare dati condivisi
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Passo 4: Creare nuova tabella person_medications (pautas individuali)
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

-- Passo 5: Migrare pautas individuali
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

-- Passo 6: Ricreare indici
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Passo 7: Pulizia
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Sistema di Migrazione Automatica

Il sistema rileva automaticamente la versione attuale del database e applica migrazioni progressive:

```dart
// In database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Versione obiettivo
    onCreate: _createDB,  // Per database nuovi
    onUpgrade: _upgradeDB,  // Per migrare da versioni precedenti
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Applica migrazioni progressive da oldVersion fino a newVersion
  if (oldVersion < 2) { /* Migrazione V1→V2 */ }
  if (oldVersion < 3) { /* Migrazione V2→V3 */ }
  // ... fino a V19
}
```

**Vantaggi**:
- **Progressivo**: Un utente con V1 si aggiorna automaticamente fino a V19
- **Senza perdita di dati**: Ogni migrazione preserva i dati esistenti
- **Tollerante agli errori**: Se una migrazione fallisce, il database rimane nello stato precedente

---

## Regole di Business

### 1. Stock Condiviso tra Persone

- Lo `stockQuantity` nella tabella `medications` è **unico e condiviso**
- Quando qualsiasi persona registra una dose presa, lo stock si decrementa per tutti
- **Esempio**: Se ci sono 20 pillole di Ibuprofene e Ana ne prende 1, rimangono 19 per tutti (incluso Carlos)

### 2. Configurazioni Individuali per Persona

- Ogni persona può avere **orari diversi** per lo stesso farmaco
- **Esempio**:
  - Ana prende Ibuprofene alle 08:00 e 20:00
  - Carlos prende lo stesso Ibuprofene solo alle 14:00

### 3. Validazioni di Integrità

```sql
-- Una persona non può avere lo stesso farmaco due volte
UNIQUE(personId, medicationId) in person_medications

-- Deve esistere almeno una persona predefinita
-- (Validato nel livello applicazione)
```

### 4. Cascate di Eliminazione

- **Eliminare persona** → Si eliminano tutte le sue relazioni in `person_medications` e il suo storico in `dose_history`
- **Eliminare farmaco** → Si eliminano tutte le relazioni in `person_medications`, ma **NON** lo storico (per audit)

### 5. Deduplicazione dei Farmaci

Quando si crea un farmaco, il sistema verifica se esiste già uno con lo stesso nome (case-insensitive):

```dart
// Pseudocodice
if (exists medication with same name) {
  riutilizzare farmaco esistente
  creare solo nuova voce in person_medications
} else {
  creare nuovo farmaco
  creare voce in person_medications
}
```

---

## Query SQL Comuni

### 1. Ottenere Farmaci di una Persona

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

### 2. Registrare un'Assunzione di Farmaco

```sql
-- Passo 1: Inserire nello storico
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Passo 2: Aggiornare stock (solo se è dose programmata, non extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Passo 3: Aggiornare takenDosesToday in person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Aggiungere ora presa
  takenDosesDate = ?     -- Aggiornare data
WHERE personId = ? AND medicationId = ?;
```

### 3. Calcolare Stock Disponibile e Avvisi

```sql
-- Ottenere farmaci con stock basso per una persona
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
    -- Calcolare stock minimo basato su dose giornaliera
    -- (Questa logica viene fatta nell'applicazione perché doseSchedule è JSON)
  );
```

### 4. Ottenere Storico Dosi (Ultimi 30 Giorni)

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

### 5. Calcolare Aderenza (% Dosi Prese)

```sql
-- Totale dosi programmate
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Dosi prese
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Aderenza = (taken / total) * 100
```

### 6. Ottenere Persone Assegnate a un Farmaco

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Verificare se un Farmaco Esiste Già (per nome)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Ottimizzazioni

### 1. Transazioni Batch

Per operazioni che modificano più tabelle, vengono utilizzate transazioni:

```dart
await db.transaction((txn) async {
  // Operazioni atomiche multiple
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Vantaggi**:
- Atomicità: Tutto viene salvato o niente viene salvato
- Consistenza: Non ci sono stati intermedi
- Prestazioni: Una sola scrittura su disco

### 2. Prepared Statements

Tutte le query utilizzano prepared statements con placeholder (`?`) per prevenire SQL injection e migliorare le prestazioni:

```dart
// ✅ Corretto (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Errato (vulnerabile a SQL injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Indici Selettivi

Gli indici sono progettati per le query più frequenti:
- `idx_person_medications_person`: Per la schermata principale (mostrare farmaci dell'utente)
- `idx_dose_history_medication`: Per lo storico di un farmaco specifico
- `idx_dose_history_date`: Per query per intervallo di date

### 4. Denormalizzazione Strategica

In `dose_history` vengono memorizzati `medicationName` e `medicationType` (denormalizzati) per evitare JOIN costosi nelle query dello storico. Questo sacrifica un po' di spazio per molto rendimento.

### 5. Cache in Memoria

L'applicazione utilizza cache per la persona predefinita:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Interrogare database solo se non è in cache
}
```

### 6. ANALYZE e VACUUM

**ANALYZE**: Aggiorna le statistiche del database per ottimizzare il query planner.

```sql
ANALYZE;
```

**VACUUM**: Ricostruisce il database per liberare spazio e ottimizzare.

```sql
VACUUM;
```

**Raccomandazione**: Eseguire `ANALYZE` dopo modifiche massive di dati, e `VACUUM` periodicamente (es: ogni 3 mesi).

---

## Backup e Ripristino

### Ubicazione del File Database

Il database viene memorizzato in:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Per ottenere il percorso reale:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Strategie di Backup

#### 1. Backup Manuale (Esportazione File)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

L'applicazione copia il file `.db` in una posizione temporanea. L'utente può poi condividere questo file (Google Drive, email, ecc.).

**Miglioramenti di sicurezza:**
- Verifica che il file del database esista prima dell'esportazione
- Genera eccezione se si tenta di esportare un database in memoria
- Valida il percorso di destinazione

#### 2. Importazione di Backup

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Note**:
- Viene creato un backup automatico del file attuale prima di importare (`.backup`)
- Se l'importazione fallisce, viene ripristinato automaticamente il backup
- Elimina i file WAL (Write-Ahead Logging) e SHM (Shared Memory) prima dell'importazione
- Include un ritardo di 100ms dopo la chiusura del database per garantire il rilascio dei file
- Verifica l'integrità del database importato mediante query di test

#### 3. Backup Automatico (Raccomandato per Produzione)

Implementare un sistema di backup automatico al cloud:

```dart
// Pseudocodice
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, ecc.
  });
}
```

### Esportazione Dati (JSON)

Per massima portabilità, si può esportare il database completo in JSON:

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

**Vantaggi**:
- Formato leggibile dall'uomo
- Facile da ispezionare e debuggare
- Indipendente da SQLite

**Svantaggi**:
- File più grande di `.db`
- Richiede parsing all'importazione

---

## Esempio d'Uso Completo

### Scenario: Ana e Carlos condividono Ibuprofene

```sql
-- 1. Creare persone
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Creare farmaco condiviso (Ibuprofene)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofene 600mg', 'pill', 40.0, 3);

-- 3. Assegnare ad Ana con la sua pauta (08:00 e 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Assegnare a Carlos con la sua pauta (14:00 solamente)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana prende una dose alle 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofene 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Aggiornare stock (rimangono 39.0)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Aggiornare takenDosesToday di Ana
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Interrogare stock rimanente (visibile per entrambi)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Risultato: 39.0

-- 9. Interrogare aderenza di Ana
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Riepilogo

- **Versione**: V19 (SQLite)
- **Tabelle Principali**: `persons`, `medications`, `person_medications`, `dose_history`
- **Architettura**: Multi-persona con dati condivisi (stock) e configurazioni individuali (pautas)
- **Migrazioni**: Sistema automatico progressivo V1→V19
- **Integrità**: Chiavi esterne con cascate, indici ottimizzati
- **Ottimizzazioni**: Transazioni batch, prepared statements, cache in memoria, denormalizzazione strategica
- **Backup**: Esportazione file `.db` e JSON, importazione con rollback automatico

Questo database è progettato per supportare applicazioni di gestione farmaci multi-utente con elevate prestazioni e garanzie di integrità dei dati.
