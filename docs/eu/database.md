# MedicApp Datu-basea - SQLite V19

## Ikuspegi Orokorra

MedicApp-ek SQLite V19 erabiltzen du datu-base lokala kudeaketa sistema gisa. Arkitektura pertsona anitzen (erabiltzaileak) onarpena ahalbidetzeko diseinatuta dago, sendagaiak partekatu dezaketenak baina konfigurazioak eta pauta indibidualak mantentzea.

### Funtzionalitate Nagusiak

- **Uneko Bertsioa**: V19 (azken bertsio egonkorra)
- **Motorea**: SQLite `sqflite`-rekin (Flutter)
- **Arkitektura**: Pertsona anitzeko partekatutako datuak eta konfigurazio indibidualak
- **Kokapena**: `medications.db` aplikazioaren datu-base direktorioan
- **Migrazioak**: Migrazio progresiboen sistema automatikoa (V1 → V19)
- **Osotasuna**: Ezabaketa kaskadak gaituta dauden atzerriko gakoak
- **Indizeak**: Kontsulta ohikoak optimizatzeko

### Diseinu Filosofia

V19 datu-baseak **partekatutako datuen eta datu indibidualenen arteko banaketa argia** inplementatzen du:

- **Partekatutako Datuak** (`medications` taula): Edonork erabil dezakeen sendagaien stocka
- **Datu Indibidualak** (`person_medications` taula): Pertsona bakoitzaren pautak, ordutegia eta konfigurazioak espezifikoak
- **N:N Erlazioa**: Pertsona batek sendagai anitz izan ditzake, eta sendagai bat pertsona anitzei esleitu ahal zaio

---

## Taulen Eskema

### Taula: `persons`

Aplikazioa erabiltzen duten pertsonak gordetzen ditu (erabiltzaileak, familiarrak, pazienteak).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Eremuak

| Eremua | Mota | Deskribapena |
|--------|------|--------------|
| `id` | TEXT PRIMARY KEY | Pertsonaren identifikatzaile bakarra (UUID string formatuan) |
| `name` | TEXT NOT NULL | Pertsonaren izena |
| `isDefault` | INTEGER NOT NULL | 1 pertsona lehenetsia bada (erabiltzaile nagusia), 0 bestela |

#### Arauak

- Gutxienez pertsona bat egon behar da `isDefault = 1`-rekin
- ID-ak milisegundoko timestamp gisa sortzen dira
- Izena ezin da hutsik egon

---

### Taula: `medications`

Sendagaien **partekatutako datuak** gordetzen ditu (izena, mota, stocka).

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

#### Eremuak

| Eremua | Mota | Deskribapena |
|--------|------|--------------|
| `id` | TEXT PRIMARY KEY | Sendagaiaren identifikatzaile bakarra (UUID string formatuan) |
| `name` | TEXT NOT NULL | Sendagaiaren izena (adib: "Ibuprofeno 600mg") |
| `type` | TEXT NOT NULL | Sendagai mota: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Stockeko uneko kantitatea (pertsona guztien artean partekatua) |
| `lastRefillAmount` | REAL | Stockari gehitutako azken kantitatea (etorkizuneko hornitu ketetarako iradokizuna) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Stock baxuko alerta erakusteko eguneko atalasea (lehenetsia: 3) |
| `lastDailyConsumption` | REAL | Egun batean kontsumitutako azken kantitatea ("behar den arabera" sendagaientzat) |

#### Oharrak

- **Stock Partekatua**: `stockQuantity` bakarra da eta sendagaia erabiltzen duten pertsona guztien artean partekatzen da
- **Bikoizketa Kentzea**: Bi pertsonek sendagai bera gehitzen badute (izen bat datozenak, maiuskulak/minuskulak kontuan hartu gabe), existitzen den erregistroa berrerabiltzen da
- **Motak**: `type` eremuak neurri unitatea zehazten du (pilulak, ml, tantak, etab.)

---

### Taula: `person_medications`

N:N erlazio taula pertsona bakoitzaren sendagai espezifiko batentzako **pauta indibiduala** gordetzen duena.

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

#### Eremuak

| Eremua | Mota | Deskribapena |
|--------|------|--------------|
| `id` | TEXT PRIMARY KEY | Pertsona-sendagai erlazioaren identifikatzaile bakarra |
| `personId` | TEXT NOT NULL | `persons.id`-ra FK |
| `medicationId` | TEXT NOT NULL | `medications.id`-ra FK |
| `assignedDate` | TEXT NOT NULL | ISO8601 data sendagaia pertsonari esleitu zenean |
| `durationType` | TEXT NOT NULL | Iraupena mota: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Dosien arteko orduko tartea (0 aplikatzen ez bada) |
| `doseSchedule` | TEXT NOT NULL | Ordua → kantitatea mapa JSON batekin (adib: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Gaur hartutako orduen CSV zerrenda (adib: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Gaur omititutako orduen CSV zerrenda (adib: `"14:00"`) |
| `takenDosesDate` | TEXT | Hartutako/omititutako dosien ISO8601 data (adib: `"2025-11-14"`) |
| `selectedDates` | TEXT | Data espezifikoen CSV zerrenda `durationType = specificDates`-rako |
| `weeklyDays` | TEXT | Asteko egunen CSV zerrenda (1=Astelehena, 7=Igandea) `weeklyPattern`-erako |
| `dayInterval` | INTEGER | Egunen tartea `durationType = intervalDays`-rako (adib: 2 = 2 egunero) |
| `startDate` | TEXT | Tratamenduaren hasierako ISO8601 data |
| `endDate` | TEXT | Tratamenduaren amaierako ISO8601 data |
| `requiresFasting` | INTEGER NOT NULL | 1 baraualdia behar badu, 0 bestela |
| `fastingType` | TEXT | Baraualdi mota: `before` edo `after` |
| `fastingDurationMinutes` | INTEGER | Baraualdi iraupena minututan (adib: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 baraualdi aldiak jakinarazi behar baditu, 0 bestela |
| `isSuspended` | INTEGER NOT NULL | 1 sendagaia etenita badago (jakinarazpenik gabe), 0 bestela |

#### Oharrak

- **Erlazio Bakarra**: Pertsona batek ezin du sendagai bera bi aldiz esleituta izan (`UNIQUE(personId, medicationId)`)
- **Kaskadak**: Pertsona edo sendagai bat ezabatzen bada, erlazioak automatikoki ezabatzen dira
- **doseSchedule**: JSON gisa gordetzen da malgutasunerako (adib: kantitate desberdinak ordu desberdinetan)
- **Iraupena Motak**:
  - `everyday`: Egun guztietan
  - `untilFinished`: Stocka amaitu arte
  - `specificDates`: Data espezifikoetan soilik (`selectedDates`-en gordetzen dira)
  - `weeklyPattern`: Asteko egun espezifikoetan (`weeklyDays`-en gordetzen dira)
  - `intervalDays`: N egunero (`dayInterval`-en zehaztutakoa)
  - `asNeeded`: Behar den arabera (ordutegi finkorik gabe)

---

### Taula: `dose_history`

Hartutako edo omititutako dosi guztien erregistro historikoa.

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

#### Eremuak

| Eremua | Mota | Deskribapena |
|--------|------|--------------|
| `id` | TEXT PRIMARY KEY | Historial sarreraren identifikatzaile bakarra |
| `medicationId` | TEXT NOT NULL | Sendagaiaren ID (desnormalizatua errendimenduarentzat) |
| `medicationName` | TEXT NOT NULL | Sendagaiaren izena (desnormalizatua) |
| `medicationType` | TEXT NOT NULL | Sendagaiaren mota (desnormalizatua) |
| `personId` | TEXT NOT NULL | `persons.id`-ra FK - dosia hartu/omititu zuen pertsona |
| `scheduledDateTime` | TEXT NOT NULL | Dosiarentzat programatutako ISO8601 data eta ordua |
| `registeredDateTime` | TEXT NOT NULL | Hartzea/omisioa erregistratu zeneko benetako ISO8601 data eta ordua |
| `status` | TEXT NOT NULL | Dosiaren egoera: `taken` edo `skipped` |
| `quantity` | REAL NOT NULL | Hartutako kantitatea (sendagai motaren unitateetan) |
| `isExtraDose` | INTEGER NOT NULL | 1 dosi extra bat bada (ordutegi kanpokoa), 0 programatua bada |
| `notes` | TEXT | Dosiaren gaineko ohar aukerakoitzak |

#### Oharrak

- **Desnormalizazioa**: `medicationName` eta `medicationType` hemen gordetzen dira historial kontsultetan JOIN-ak saihesteko
- **Kaskada**: Pertsona bat ezabatzen bada, bere historial erregistroak ezabatzen dira
- **Ez dago medications-era FK**: Historiala mantentzen da sendagaia ezabatzen bada ere
- **Atzerapena**: `scheduledDateTime` eta `registeredDateTime` arteko diferentziak dosia puntuala izan zen adierazten du

---

## Taulen Arteko Erlazioak

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
         │ [pauta indibiduala]  │
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
         │ medicationId     │ (FK ez, desnormalizatua)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Atzerriko Gakoak

| Taula | Zutabea | Erreferentzia | On Delete |
|-------|---------|---------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Indizeak

Kontsulta ohikoak optimizatzeko honako indize hauek sortuta daude:

```sql
-- Sendagaiaren araberako dosiak bilatzeko indizea
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Programatutako dataren araberako dosiak bilatzeko indizea
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Pertsonaren sendagaiak bilatzeko indizea
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Sendagai bati esleitutako pertsonak bilatzeko indizea
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Indize Bakoitzaren Helburua

- **`idx_dose_history_medication`**: Sendagaiaren arabera iragazitako historial kontsultak azeleratzen ditu (adib: Ibuprofenoren hartze guztiak ikusi)
- **`idx_dose_history_date`**: Data-tarte araberako kontsultak optimizatzen ditu (adib: azken 7 egunetako historiala)
- **`idx_person_medications_person`**: Pertsona espezifiko baten sendagaien karga hobetzen du (kontsulta ohikoena)
- **`idx_person_medications_medication`**: Sendagai bat zein pertsonek erabiltzen duten aurkitzea errazten du

---

## Trigger-ak

Gaur egun ez dago trigger-ik inplementatuta datu-basean. Negozio logika aplikazioaren geruzoan (Dart) kudeatzen da.

**Etorkizuneko Trigger Posibleak:**

```sql
-- Adibidea: Automatikoki stocka eguneratu hartutako dosi bat erregistratzean
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Oharra**: Trigger hau ez dago inplementatuta stock kontrola malgutasun handiagorako aplikazioaren kodean esplizituki kudeatzen delako.

---

## Migrazioak

### Bertsioen Historiala (V1 → V19)

| Bertsioa | Aldaketa Nagusiak |
|---------|---------------------|
| **V1** | Hasierako eskema: `medications` taula oinarrizkoa |
| **V2** | Gehitua `doseTimes` (dosien orduak) |
| **V3** | Gehitua `stockQuantity` (inbentario kudeaketa) |
| **V4** | Gehituak `takenDosesToday`, `takenDosesDate` (eguneko hartzeen jarraipena) |
| **V5** | Gehitua `doseSchedule` (ordutegi arabera kantitate aldakorrak) |
| **V6** | Gehitua `skippedDosesToday` (omititutako dosien jarraipena) |
| **V7** | Gehitua `lastRefillAmount` (hornitzeko iradokizunak) |
| **V8** | Gehitua `lowStockThresholdDays` (atalase konfiguragarria) |
| **V9** | Gehituak `selectedDates`, `weeklyDays` (tratamendu patronak) |
| **V10** | Gehituak `startDate`, `endDate` (tratamendu tartea) |
| **V11** | Sortua `dose_history` taula (dosien historial osoa) |
| **V12** | Gehitua `dayInterval` (N egunero tratamenduak) |
| **V13** | Gehituak baraualdi eremuak: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Gehitua `isSuspended` (sendagaien aldi baterako etena) |
| **V15** | Gehitua `lastDailyConsumption` ("behar den arabera" sendagaientzako jarraipena) |
| **V16** | Gehituak `extraDosesToday` eta `isExtraDose` (ordutegi kanpoko dosiak) |
| **V17** | Sortua `persons` taula (pertsona anitzeko onarpena) |
| **V18** | Sortua `person_medications` taula (N:N erlazioa), gehitua `personId` `dose_history`-ra |
| **V19** | **Berregituraketa nagusia**: Partekatutako datuen (medications) eta pauta indibidualenen (person_medications) banaketa |

### V18 → V19 Migrazioa (Berregituraketa Nagusia)

V19 migrazioa konplexuena eta garrantzitsuena da. Sendagaien datuak bi taulatan banatzen ditu:

#### Migrazio Prozesua

1. **Backup**: Existitzen diren taulak `_old`-ra izendatzen dira
2. **Taula Berriak**: `medications` eta `person_medications` eskema berriarekin sortzen dira
3. **Partekatutako Datuen Migrazioa**: `id`, `name`, `type`, `stockQuantity`, etab. `medications`-era kopiatzen dira
4. **Pauta Indibidualenen Migrazioa**: Orduak, iraupena, baraualdia, etab. `person_medications`-era kopiatzen dira
5. **Indizeen Berrorrera**: Indize optimizatuak sortzen dira
6. **Garbiketa**: `_old` taulak ezabatzen dira

```sql
-- 1. Pausoa: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- 2. Pausoa: medications taula berria sortu (partekatutako datuak soilik)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- 3. Pausoa: Partekatutako datuak kopiatu
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- 4. Pausoa: person_medications taula berria sortu (pauta indibidualak)
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

-- 5. Pausoa: Pauta indibidualak migratu
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

-- 6. Pausoa: Indizeak berrortu
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- 7. Pausoa: Garbiketa
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Migrazio Sistema Automatikoa

Sistemak automatikoki datu-basearen uneko bertsioa detektatu eta migrazio progresiboak aplikatzen ditu:

```dart
// database_helper.dart-en
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Helburuko bertsioa
    onCreate: _createDB,  // Datu-base berrientzat
    onUpgrade: _upgradeDB,  // Aurreko bertsiotatik migratzeko
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // oldVersion-etik newVersion-era migrazio progresiboak aplikatu
  if (oldVersion < 2) { /* V1→V2 Migrazioa */ }
  if (oldVersion < 3) { /* V2→V3 Migrazioa */ }
  // ... V19-ra arte
}
```

**Abantailak**:
- **Progresiboa**: V1 duen erabiltzaile bat automatikoki V19-ra eguneratzen da
- **Datu galtzerik gabe**: Migrazio bakoitzak existitzen diren datuak mantentzen ditu
- **Errore tolerantea**: Migrazio batek huts egiten badu, datu-basea aurreko egoeran mantentzen da

---

## Negozio Arauak

### 1. Pertsonen Artean Stock Partekatua

- `medications` taulako `stockQuantity` **bakarra eta partekatua** da
- Edozein pertsonak hartutako dosi bat erregistratzen duenean, stocka guztiendako murrizten da
- **Adibidea**: 20 Ibuprofeno pilula badaude eta Anek 1 hartzen badu, 19 geratzen dira guztientzat (Carlos barne)

### 2. Pertsona Bakoitzeko Konfigurazio Indibidualak

- Pertsona bakoitzak sendagai berarentzat **ordutegi desberdinak** izan ditzake
- **Adibidea**:
  - Anek Ibuprofenoa 08:00 eta 20:00etan hartzen du
  - Carlosek Ibuprofeno bera 14:00etan soilik hartzen du

### 3. Osotasun Balidazioak

```sql
-- Pertsona batek ezin du sendagai bera bi aldiz izan
UNIQUE(personId, medicationId) person_medications-en

-- Gutxienez pertsona lehenetsiz bat egon behar da
-- (Aplikazioaren geruzean balidatua)
```

### 4. Ezabaketa Kaskadak

- **Pertsona ezabatu** → `person_medications`-eko bere erlazio guztiak eta `dose_history`-ko bere historiala ezabatzen dira
- **Sendagai ezabatu** → `person_medications`-eko erlazio guztiak ezabatzen dira, baina historiala **EZ** (auditatzeko)

### 5. Sendagaien Bikoizketa Kentzea

Sendagai bat sortzen denean, sistemak egiaztatu egiten du ea izen bereko bat (maiuskula/minuskulak kontuan hartu gabe) existitzen den:

```dart
// Pseudo-kodea
if (exists medication with same name) {
  existitzen den sendagaia berrerabili
  person_medications-en sarrera berria soilik sortu
} else {
  sendagai berria sortu
  person_medications-en sarrera sortu
}
```

---

## SQL Kontsulta Ohikoak

### 1. Pertsona Baten Sendagaiak Lortu

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

### 2. Sendagai Hartze Bat Erregistratu

```sql
-- 1. Pausoa: Historian sartu
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- 2. Pausoa: Stocka eguneratu (dosi programatua bada soilik, extra ez)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- 3. Pausoa: person_medications-en takenDosesToday eguneratu
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Hartutako ordua gehitu
  takenDosesDate = ?     -- Data eguneratu
WHERE personId = ? AND medicationId = ?;
```

### 3. Eskuragarri dagoen Stocka eta Alertak Kalkulatu

```sql
-- Pertsona batentzat stock baxuko sendagaiak lortu
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
    -- Egunkako disian oinarritutako stock minimoa kalkulatu
    -- (Logika hau aplikazioan egiten da doseSchedule JSON delako)
  );
```

### 4. Dosien Historiala Lortu (Azken 30 Egunak)

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

### 5. Atxikipena Kalkulatu (% Hartutako Dosiak)

```sql
-- Programatutako dosi guztiak
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Hartutako dosiak
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Atxikipena = (taken / total) * 100
```

### 6. Sendagai Bati Esleitutako Pertsonak Lortu

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Sendagai bat Existitzen den Egiaztatu (izenaren arabera)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimizazioak

### 1. Batch Transakzioak

Taula anitzak aldatzen dituzten eragiketetarako, transakzioak erabiltzen dira:

```dart
await db.transaction((txn) async {
  // Eragiketa atomiko anitz
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Abantailak**:
- Atomikotasuna: Guztia gordetzen da edo ezeri ez
- Koherentzia: Ez daude tarteko egoerak
- Errendimendua: Diskoan idazketa bakarra

### 2. Prepared Statements

Kontsulta guztiak placeholder-ak (`?`) dituzten prepared statements erabiltzen dituzte SQL injection saihesteko eta errendimendua hobetzeko:

```dart
// ✅ Zuzena (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Okerra (SQL injection-era zaurgarria)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Indize Selektiboak

Indizeak kontsulta ohikoenei diseinatuak daude:
- `idx_person_medications_person`: Pantaila nagusirako (erabiltzailearen sendagaiak erakutsi)
- `idx_dose_history_medication`: Sendagai espezifiko baten historialerako
- `idx_dose_history_date`: Data-tarte araberako kontsultarako

### 4. Desnormalizazio Estrategikoa

`dose_history`-n `medicationName` eta `medicationType` (desnormalizatuak) gordetzen dira historial kontsultetan JOIN kostuak saihesteko. Honek espazioa apurrt bat sakrifikatzen du errendimendu asko irabaziz.

### 5. Memorian Cachea

Aplikazioak pertsona lehenetsiaren cachea erabiltzen du:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Datu-basea kontsultatu cachean ez badago soilik
}
```

### 6. ANALYZE eta VACUUM

**ANALYZE**: Datu-basearen estatistikak eguneratzen ditu query planner-a optimizatzeko.

```sql
ANALYZE;
```

**VACUUM**: Datu-basea berreraikitzen du espazioa askatuz eta optimizatzeko.

```sql
VACUUM;
```

**Gomendagoa**: `ANALYZE` exekutatu datuen aldaketa masiboen ondoren, eta `VACUUM` periodikoki (adib: 3 hilabetero).

---

## Backup eta Berrezarketa

### Datu-base Fitxategiaren Kokapena

Datu-basea hemen gordetzen da:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Benetako bidea lortzeko:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Datu-basearen kokapena: $dbPath');
```

### Backup Estrategiak

#### 1. Backup Eskuzkoa (Fitxategi Esportazioa)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

Aplikazioak `.db` fitxategia kokapen aldi baterako batera kopiatzen du. Erabiltzaileak gero fitxategi hau partekatu dezake (Google Drive, posta, etab.).

#### 2. Backup Inportazioa

```dart
await DatabaseHelper.instance.importDatabase('/bidea/backup.db');
```

**Oharrak**:
- Inportatu aurretik uneko fitxategiaren backup automatikoa sortzen da (`.backup`)
- Inportazioak huts egiten badu, backupa automatikoki berreskuratzen da

#### 3. Backup Automatikoa (Gomendatua Produkziorako)

Cloud-era backup automatiko sistema bat inplementatu:

```dart
// Pseudo-kodea
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, etab.
  });
}
```

### Datuen Esportazioa (JSON)

Eramangarritasun maximorako, datu-base osoa JSON-era esportatu daiteke:

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

**Abantailak**:
- Gizakiek irakurtzeko modukoa
- Ikuskatu eta arazketa erraza
- SQLite-tik independentea

**Desabantailak**:
- Fitxategia `.db` baino handiagoa
- Inportatzean analizatzea behar du

---

## Erabilera Osoko Adibidea

### Eszenar ioa: Ana eta Carlosek Ibuprofenoa partekatzen dute

```sql
-- 1. Pertsonak sortu
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Sendagai partekatua sortu (Ibuprofenoa)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofeno 600mg', 'pill', 40.0, 3);

-- 3. Anari esleitu bere pautarekin (08:00 eta 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Carlosi esleitu bere pautarekin (14:00 soilik)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Anek 08:05-ean dosi bat hartzen du
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofeno 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Stocka eguneratu (39,0 geratzen da)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Anaren takenDosesToday eguneratu
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Geratzen den stocka kontsultatu (bientzat ikusgai)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Emaitza: 39.0

-- 9. Anaren atxikipena kontsultatu
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Laburpena

- **Bertsioa**: V19 (SQLite)
- **Taula Nagusiak**: `persons`, `medications`, `person_medications`, `dose_history`
- **Arkitektura**: Pertsona anitzeko partekatutako datuekin (stocka) eta konfigurazio indibidualak (pautak)
- **Migrazioak**: Sistema automatiko progresiboa V1→V19
- **Osotasuna**: Kaskadak dituzten atzerriko gakoak, indize optimizatuak
- **Optimizazioak**: Batch transakzioak, prepared statements, memoria cachea, desnormalizazio estrategikoa
- **Backup**: `.db` fitxategiaren eta JSON esportazioa, rollback automatikoa duen inportazioa

Datu-base hau pertsona anitzeko aplikazioen kudeaketarako diseinatuta dago errendimendu altua eta datuen osotasunaren bermeekin.
