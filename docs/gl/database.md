# Base de Datos MedicApp - SQLite V19

## Visión Xeral

MedicApp utiliza SQLite V19 como sistema de xestión de base de datos local. A arquitectura está deseñada para soportar múltiples persoas (usuarios) que poden compartir medicamentos pero manter configuracións e pautas individuais.

### Características Principais

- **Versión Actual**: V19 (última versión estable)
- **Motor**: SQLite con `sqflite` (Flutter)
- **Arquitectura**: Multi-persoa con datos compartidos e configuracións individuais
- **Localización**: `medications.db` no directorio de base de datos da aplicación
- **Migracións**: Sistema automático de migracións progresivas (V1 → V19)
- **Integridade**: Claves foráneas habilitadas con cascadas de eliminación
- **Índices**: Optimizados para consultas frecuentes

### Filosofía de Deseño

A base de datos V19 implementa unha **separación clara entre datos compartidos e datos individuais**:

- **Datos Compartidos** (táboa `medications`): Stock de medicamentos que pode ser utilizado por calquera persoa
- **Datos Individuais** (táboa `person_medications`): Pautas, horarios e configuracións específicas de cada persoa
- **Relación N:N**: Unha persoa pode ter múltiples medicamentos, e un medicamento pode ser asignado a múltiples persoas

---

## Esquema de Táboas

### Táboa: `persons`

Almacena as persoas que utilizan a aplicación (usuarios, familiares, pacientes).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Campos

| Campo | Tipo | Descrición |
|-------|------|------------|
| `id` | TEXT PRIMARY KEY | Identificador único da persoa (UUID en formato string) |
| `name` | TEXT NOT NULL | Nome da persoa |
| `isDefault` | INTEGER NOT NULL | 1 se é a persoa por defecto (usuario principal), 0 en caso contrario |

#### Regras

- Debe existir polo menos unha persoa con `isDefault = 1`
- Os IDs xéranse como timestamps en milisegundos
- O nome non pode estar baleiro

---

### Táboa: `medications`

Almacena os **datos compartidos** dos medicamentos (nome, tipo, stock).

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

#### Campos

| Campo | Tipo | Descrición |
|-------|------|------------|
| `id` | TEXT PRIMARY KEY | Identificador único do medicamento (UUID en formato string) |
| `name` | TEXT NOT NULL | Nome do medicamento (ex: "Ibuprofeno 600mg") |
| `type` | TEXT NOT NULL | Tipo de medicamento: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Cantidade actual en stock (compartida entre todas as persoas) |
| `lastRefillAmount` | REAL | Última cantidade engadida ao stock (suxestión para futuros reabastecementos) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Días de limiar para mostrar alerta de stock baixo (default: 3) |
| `lastDailyConsumption` | REAL | Última cantidade consumida nun día (para medicamentos "segundo necesidade") |

#### Notas

- **Stock Compartido**: O `stockQuantity` é único e compártese entre todas as persoas que usan o medicamento
- **Deduplicación**: Se dúas persoas engaden o mesmo medicamento (nome coincidente, case-insensitive), reutilízase o rexistro existente
- **Tipos**: O campo `type` determina a unidade de medida (píldoras, ml, gotas, etc.)

---

### Táboa: `person_medications`

Táboa de relación N:N que almacena a **pauta individual** de cada persoa para un medicamento específico.

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

#### Campos

| Campo | Tipo | Descrición |
|-------|------|------------|
| `id` | TEXT PRIMARY KEY | Identificador único da relación persoa-medicamento |
| `personId` | TEXT NOT NULL | FK a `persons.id` |
| `medicationId` | TEXT NOT NULL | FK a `medications.id` |
| `assignedDate` | TEXT NOT NULL | Data ISO8601 cando se asignou o medicamento á persoa |
| `durationType` | TEXT NOT NULL | Tipo de duración: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Intervalo de horas entre doses (0 se non aplica) |
| `doseSchedule` | TEXT NOT NULL | JSON con mapa de hora → cantidade (ex: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Lista CSV de horas tomadas hoxe (ex: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Lista CSV de horas omitidas hoxe (ex: `"14:00"`) |
| `takenDosesDate` | TEXT | Data ISO8601 das doses tomadas/omitidas (ex: `"2025-11-14"`) |
| `selectedDates` | TEXT | Lista CSV de datas específicas para `durationType = specificDates` |
| `weeklyDays` | TEXT | Lista CSV de días da semana (1=Luns, 7=Domingo) para `weeklyPattern` |
| `dayInterval` | INTEGER | Intervalo de días para `durationType = intervalDays` (ex: 2 = cada 2 días) |
| `startDate` | TEXT | Data ISO8601 de inicio do tratamento |
| `endDate` | TEXT | Data ISO8601 de fin do tratamento |
| `requiresFasting` | INTEGER NOT NULL | 1 se require xaxún, 0 en caso contrario |
| `fastingType` | TEXT | Tipo de xaxún: `before` ou `after` |
| `fastingDurationMinutes` | INTEGER | Duración do xaxún en minutos (ex: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 se debe notificar períodos de xaxún, 0 en caso contrario |
| `isSuspended` | INTEGER NOT NULL | 1 se o medicamento está suspendido (sen notificacións), 0 en caso contrario |

#### Notas

- **Relación Única**: Unha persoa non pode ter o mesmo medicamento asignado dúas veces (`UNIQUE(personId, medicationId)`)
- **Cascadas**: Se se elimina unha persoa ou medicamento, elimínanse automaticamente as relacións
- **doseSchedule**: Almacenado como JSON para flexibilidade (ex: diferentes cantidades en diferentes horas)
- **Tipos de Duración**:
  - `everyday`: Todos os días
  - `untilFinished`: Ata acabar o stock
  - `specificDates`: Só en datas específicas (almacenadas en `selectedDates`)
  - `weeklyPattern`: Días específicos da semana (almacenados en `weeklyDays`)
  - `intervalDays`: Cada N días (especificado en `dayInterval`)
  - `asNeeded`: Segundo necesidade (sen horario fixo)

---

### Táboa: `dose_history`

Rexistro histórico de todas as doses tomadas ou omitidas.

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

#### Campos

| Campo | Tipo | Descrición |
|-------|------|------------|
| `id` | TEXT PRIMARY KEY | Identificador único da entrada de historial |
| `medicationId` | TEXT NOT NULL | ID do medicamento (desnormalizado para rendemento) |
| `medicationName` | TEXT NOT NULL | Nome do medicamento (desnormalizado) |
| `medicationType` | TEXT NOT NULL | Tipo do medicamento (desnormalizado) |
| `personId` | TEXT NOT NULL | FK a `persons.id` - persoa que tomou/omitiu a dose |
| `scheduledDateTime` | TEXT NOT NULL | Data e hora ISO8601 programada para a dose |
| `registeredDateTime` | TEXT NOT NULL | Data e hora ISO8601 real cando se rexistrou a toma/omisión |
| `status` | TEXT NOT NULL | Estado da dose: `taken` ou `skipped` |
| `quantity` | REAL NOT NULL | Cantidade tomada (en unidades do tipo de medicamento) |
| `isExtraDose` | INTEGER NOT NULL | 1 se é unha dose extra (fóra do horario), 0 se é programada |
| `notes` | TEXT | Notas opcionais sobre a dose |

#### Notas

- **Desnormalización**: `medicationName` e `medicationType` almacénanse aquí para evitar JOINs en consultas de historial
- **Cascada**: Se se elimina unha persoa, elimínanse os seus rexistros de historial
- **Non hai FK a medications**: O historial mantense incluso se se elimina o medicamento
- **Atraso**: A diferenza entre `scheduledDateTime` e `registeredDateTime` indica se a dose foi puntual

---

## Relacións entre Táboas

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
         │ medicationId     │ (non FK, desnormalizado)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Claves Foráneas

| Táboa | Columna | Referencia | On Delete |
|-------|---------|------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Índices

Os seguintes índices están creados para optimizar consultas frecuentes:

```sql
-- Índice para buscar doses por medicamento
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Índice para buscar doses por data programada
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Índice para buscar medicamentos dunha persoa
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Índice para buscar persoas asignadas a un medicamento
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Propósito de Cada Índice

- **`idx_dose_history_medication`**: Acelera consultas de historial filtradas por medicamento (ex: ver todas as tomas de Ibuprofeno)
- **`idx_dose_history_date`**: Optimiza consultas por rango de datas (ex: historial dos últimos 7 días)
- **`idx_person_medications_person`**: Mellora a carga de medicamentos dunha persoa específica (consulta máis frecuente)
- **`idx_person_medications_medication`**: Facilita atopar que persoas están usando un medicamento

---

## Triggers

Actualmente non hai triggers implementados na base de datos. A lóxica de negocio manéxase na capa de aplicación (Dart).

**Posibles Triggers Futuros:**

```sql
-- Exemplo: Actualizar automaticamente stock ao rexistrar unha dose tomada
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Nota**: Este trigger non está implementado porque o control de stock manéxase explícitamente no código da aplicación para maior flexibilidade.

---

## Migracións

### Historial de Versións (V1 → V19)

| Versión | Cambios Principais |
|---------|---------------------|
| **V1** | Esquema inicial: táboa `medications` básica |
| **V2** | Engadido `doseTimes` (horarios de doses) |
| **V3** | Engadido `stockQuantity` (xestión de inventario) |
| **V4** | Engadidos `takenDosesToday`, `takenDosesDate` (tracking de tomas diarias) |
| **V5** | Engadido `doseSchedule` (cantidades variables por horario) |
| **V6** | Engadido `skippedDosesToday` (tracking de doses omitidas) |
| **V7** | Engadido `lastRefillAmount` (suxestións de reabastecemento) |
| **V8** | Engadido `lowStockThresholdDays` (limiar configurable) |
| **V9** | Engadidos `selectedDates`, `weeklyDays` (patróns de tratamento) |
| **V10** | Engadidos `startDate`, `endDate` (rango de tratamento) |
| **V11** | Creada táboa `dose_history` (historial completo de doses) |
| **V12** | Engadido `dayInterval` (tratamentos cada N días) |
| **V13** | Engadidos campos de xaxún: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Engadido `isSuspended` (suspensión temporal de medicamentos) |
| **V15** | Engadido `lastDailyConsumption` (tracking para medicamentos "segundo necesidade") |
| **V16** | Engadidos `extraDosesToday` e `isExtraDose` (doses fóra de horario) |
| **V17** | Creada táboa `persons` (soporte multi-persoa) |
| **V18** | Creada táboa `person_medications` (relación N:N), engadido `personId` a `dose_history` |
| **V19** | **Reestruturación maior**: Separación de datos compartidos (medications) e pautas individuais (person_medications) |

### Migración V18 → V19 (Reestruturación Maior)

A migración V19 é a máis complexa e importante. Separa os datos de medicamentos en dúas táboas:

#### Proceso de Migración

1. **Backup**: Renómanse as táboas existentes a `_old`
2. **Novas Táboas**: Créanse `medications` e `person_medications` co novo esquema
3. **Migración de Datos Compartidos**: Cópianse `id`, `name`, `type`, `stockQuantity`, etc. a `medications`
4. **Migración de Pautas Individuais**: Cópianse horarios, duración, xaxún, etc. a `person_medications`
5. **Recreación de Índices**: Créanse os índices optimizados
6. **Limpeza**: Elimínanse as táboas `_old`

```sql
-- Paso 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Paso 2: Crear nova táboa medications (só datos compartidos)
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);

-- Paso 3: Copiar datos compartidos
INSERT INTO medications (id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption)
SELECT id, name, type, stockQuantity, lastRefillAmount, lowStockThresholdDays, lastDailyConsumption
FROM medications_old;

-- Paso 4: Crear nova táboa person_medications (pautas individuais)
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

-- Paso 5: Migrar pautas individuais
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

-- Paso 6: Recrear índices
CREATE INDEX idx_person_medications_person ON person_medications(personId);
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);

-- Paso 7: Limpeza
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Sistema de Migración Automática

O sistema detecta automaticamente a versión actual da base de datos e aplica migracións progresivas:

```dart
// En database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Versión obxectivo
    onCreate: _createDB,  // Para bases de datos novas
    onUpgrade: _upgradeDB,  // Para migrar desde versións anteriores
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Aplica migracións progresivas desde oldVersion ata newVersion
  if (oldVersion < 2) { /* Migración V1→V2 */ }
  if (oldVersion < 3) { /* Migración V2→V3 */ }
  // ... ata V19
}
```

**Ventaxes**:
- **Progresivo**: Un usuario con V1 actualízase automaticamente ata V19
- **Sen perda de datos**: Cada migración preserva os datos existentes
- **Tolerante a erros**: Se falla unha migración, a base de datos permanece no estado anterior

---

## Regras de Negocio

### 1. Stock Compartido entre Persoas

- O `stockQuantity` na táboa `medications` é **único e compartido**
- Cando calquera persoa rexistra unha dose tomada, o stock decrémentase para todos
- **Exemplo**: Se hai 20 píldoras de Ibuprofeno e Ana toma 1, quedan 19 para todos (incluíndo Carlos)

### 2. Configuracións Individuais por Persoa

- Cada persoa pode ter **horarios diferentes** para o mesmo medicamento
- **Exemplo**:
  - Ana toma Ibuprofeno ás 08:00 e 20:00
  - Carlos toma o mesmo Ibuprofeno só ás 14:00

### 3. Validacións de Integridade

```sql
-- Unha persoa non pode ter o mesmo medicamento dúas veces
UNIQUE(personId, medicationId) en person_medications

-- Debe existir polo menos unha persoa por defecto
-- (Validado na capa de aplicación)
```

### 4. Cascadas de Eliminación

- **Eliminar persoa** → Elimínanse todas as súas relacións en `person_medications` e o seu historial en `dose_history`
- **Eliminar medicamento** → Elimínanse todas as relacións en `person_medications`, pero **NON** o historial (para auditoría)

### 5. Deduplicación de Medicamentos

Cando se crea un medicamento, o sistema verifica se xa existe un co mesmo nome (case-insensitive):

```dart
// Pseudocódigo
if (exists medication with same name) {
  reutilizar medicamento existente
  crear só nova entrada en person_medications
} else {
  crear novo medicamento
  crear entrada en person_medications
}
```

---

## Consultas SQL Comúns

### 1. Obter Medicamentos dunha Persoa

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

### 2. Rexistrar unha Toma de Medicamento

```sql
-- Paso 1: Inserir en historial
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Paso 2: Actualizar stock (só se é dose programada, non extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Paso 3: Actualizar takenDosesToday en person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Engadir hora tomada
  takenDosesDate = ?     -- Actualizar data
WHERE personId = ? AND medicationId = ?;
```

### 3. Calcular Stock Dispoñible e Alertas

```sql
-- Obter medicamentos con stock baixo para unha persoa
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
    -- Calcular stock mínimo baseado en dose diaria
    -- (Esta lóxica faise na aplicación porque doseSchedule é JSON)
  );
```

### 4. Obter Historial de Doses (Últimos 30 Días)

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

### 5. Calcular Adherencia (% de Doses Tomadas)

```sql
-- Total de doses programadas
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Doses tomadas
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Adherencia = (taken / total) * 100
```

### 6. Obter Persoas Asignadas a un Medicamento

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Verificar se un Medicamento Xa Existe (por nome)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimizacións

### 1. Transaccións Batch

Para operacións que modifican múltiples táboas, utilízanse transaccións:

```dart
await db.transaction((txn) async {
  // Múltiples operacións atómicas
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Ventaxes**:
- Atomicidade: Todo se garda ou nada se garda
- Consistencia: Non hai estados intermedios
- Rendemento: Unha soa escritura en disco

### 2. Prepared Statements

Todas as consultas utilizan prepared statements con placeholders (`?`) para previr SQL injection e mellorar rendemento:

```dart
// ✅ Correcto (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Incorrecto (vulnerable a SQL injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Índices Selectivos

Os índices están deseñados para as consultas máis frecuentes:
- `idx_person_medications_person`: Para a pantalla principal (mostrar medicamentos do usuario)
- `idx_dose_history_medication`: Para o historial dun medicamento específico
- `idx_dose_history_date`: Para consultas por rango de datas

### 4. Desnormalización Estratéxica

En `dose_history` almacénanse `medicationName` e `medicationType` (desnormalizados) para evitar JOINs custosos en consultas de historial. Isto sacrifica un pouco de espazo por moito rendemento.

### 5. Caché en Memoria

A aplicación utiliza caché para a persoa por defecto:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Consultar base de datos só se non está en caché
}
```

### 6. ANALYZE e VACUUM

**ANALYZE**: Actualiza estatísticas da base de datos para optimizar o query planner.

```sql
ANALYZE;
```

**VACUUM**: Reconstrúe a base de datos para liberar espazo e optimizar.

```sql
VACUUM;
```

**Recomendación**: Executar `ANALYZE` despois de cambios masivos de datos, e `VACUUM` periodicamente (ex: cada 3 meses).

---

## Backup e Restauración

### Localización do Arquivo de Base de Datos

A base de datos almacénase en:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Para obter a ruta real:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Estratexias de Backup

#### 1. Backup Manual (Exportación de Arquivo)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

A aplicación copia o arquivo `.db` a unha localización temporal. O usuario pode logo compartir este arquivo (Google Drive, correo, etc.).

#### 2. Importación de Backup

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Notas**:
- Créase un backup automático do arquivo actual antes de importar (`.backup`)
- Se a importación falla, restáurase automaticamente o backup

#### 3. Backup Automático (Recomendado para Produción)

Implementar un sistema de backup automático á nube:

```dart
// Pseudocódigo
void scheduleAutomaticBackup() {
  Timer.periodic(Duration(days: 7), (timer) async {
    final backupPath = await DatabaseHelper.instance.exportDatabase();
    await uploadToCloud(backupPath); // Google Drive, Dropbox, etc.
  });
}
```

### Exportación de Datos (JSON)

Para máxima portabilidade, pódese exportar a base de datos completa a JSON:

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

**Ventaxes**:
- Formato lexible por humanos
- Fácil de inspeccionar e depurar
- Independente de SQLite

**Desvantaxes**:
- Arquivo máis grande que `.db`
- Require parseo ao importar

---

## Exemplo de Uso Completo

### Escenario: Ana e Carlos comparten Ibuprofeno

```sql
-- 1. Crear persoas
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Crear medicamento compartido (Ibuprofeno)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofeno 600mg', 'pill', 40.0, 3);

-- 3. Asignar a Ana coa súa pauta (08:00 e 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Asignar a Carlos coa súa pauta (14:00 soamente)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana toma unha dose ás 08:05
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose
) VALUES (
  'dose_1', 'med_1', 'Ibuprofeno 600mg', 'pill', 'person_1',
  '2025-11-14T08:00:00', '2025-11-14T08:05:00', 'taken', 1.0, 0
);

-- 6. Actualizar stock (queda 39.0)
UPDATE medications SET stockQuantity = 39.0 WHERE id = 'med_1';

-- 7. Actualizar takenDosesToday de Ana
UPDATE person_medications
SET takenDosesToday = '08:00', takenDosesDate = '2025-11-14'
WHERE id = 'pm_1';

-- 8. Consultar stock restante (visible para ambos)
SELECT stockQuantity FROM medications WHERE id = 'med_1';
-- Resultado: 39.0

-- 9. Consultar adherencia de Ana
SELECT
  COUNT(*) FILTER (WHERE status = 'taken') as taken,
  COUNT(*) as total
FROM dose_history
WHERE personId = 'person_1' AND medicationId = 'med_1';
```

---

## Resumo

- **Versión**: V19 (SQLite)
- **Táboas Principais**: `persons`, `medications`, `person_medications`, `dose_history`
- **Arquitectura**: Multi-persoa con datos compartidos (stock) e configuracións individuais (pautas)
- **Migracións**: Sistema automático progresivo V1→V19
- **Integridade**: Claves foráneas con cascadas, índices optimizados
- **Optimizacións**: Transaccións batch, prepared statements, caché en memoria, desnormalización estratéxica
- **Backup**: Exportación de arquivo `.db` e JSON, importación con rollback automático

Esta base de datos está deseñada para soportar aplicacións de xestión de medicamentos multi-usuario con alto rendemento e garantías de integridade de datos.
