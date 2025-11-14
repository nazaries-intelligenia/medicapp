# Base de Datos MedicApp - SQLite V19

## Visión General

MedicApp utiliza SQLite V19 como sistema de gestión de base de datos local. La arquitectura está diseñada para soportar múltiples personas (usuarios) que pueden compartir medicamentos pero mantener configuraciones y pautas individuales.

### Características Principales

- **Versión Actual**: V19 (última versión estable)
- **Motor**: SQLite con `sqflite` (Flutter)
- **Arquitectura**: Multi-persona con datos compartidos y configuraciones individuales
- **Ubicación**: `medications.db` en el directorio de base de datos de la aplicación
- **Migraciones**: Sistema automático de migraciones progresivas (V1 → V19)
- **Integridad**: Claves foráneas habilitadas con cascadas de eliminación
- **Índices**: Optimizados para consultas frecuentes

### Filosofía de Diseño

La base de datos V19 implementa una **separación clara entre datos compartidos y datos individuales**:

- **Datos Compartidos** (tabla `medications`): Stock de medicamentos que puede ser utilizado por cualquier persona
- **Datos Individuales** (tabla `person_medications`): Pautas, horarios y configuraciones específicas de cada persona
- **Relación N:N**: Una persona puede tener múltiples medicamentos, y un medicamento puede ser asignado a múltiples personas

---

## Esquema de Tablas

### Tabla: `persons`

Almacena las personas que utilizan la aplicación (usuarios, familiares, pacientes).

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER NOT NULL DEFAULT 0
)
```

#### Campos

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador único de la persona (UUID en formato string) |
| `name` | TEXT NOT NULL | Nombre de la persona |
| `isDefault` | INTEGER NOT NULL | 1 si es la persona por defecto (usuario principal), 0 en caso contrario |

#### Reglas

- Debe existir al menos una persona con `isDefault = 1`
- Los IDs se generan como timestamps en milisegundos
- El nombre no puede estar vacío

---

### Tabla: `medications`

Almacena los **datos compartidos** de los medicamentos (nombre, tipo, stock).

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

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador único del medicamento (UUID en formato string) |
| `name` | TEXT NOT NULL | Nombre del medicamento (ej: "Ibuprofeno 600mg") |
| `type` | TEXT NOT NULL | Tipo de medicamento: `pill`, `syrup`, `drops`, `injection`, `capsule`, `tablet`, `cream`, `patch`, `inhaler`, `other` |
| `stockQuantity` | REAL NOT NULL | Cantidad actual en stock (compartida entre todas las personas) |
| `lastRefillAmount` | REAL | Última cantidad añadida al stock (sugerencia para futuros reabastecimientos) |
| `lowStockThresholdDays` | INTEGER NOT NULL | Días de umbral para mostrar alerta de stock bajo (default: 3) |
| `lastDailyConsumption` | REAL | Última cantidad consumida en un día (para medicamentos "según necesidad") |

#### Notas

- **Stock Compartido**: El `stockQuantity` es único y se comparte entre todas las personas que usan el medicamento
- **Deduplicación**: Si dos personas agregan el mismo medicamento (nombre coincidente, case-insensitive), se reutiliza el registro existente
- **Tipos**: El campo `type` determina la unidad de medida (píldoras, ml, gotas, etc.)

---

### Tabla: `person_medications`

Tabla de relación N:N que almacena la **pauta individual** de cada persona para un medicamento específico.

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

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador único de la relación persona-medicamento |
| `personId` | TEXT NOT NULL | FK a `persons.id` |
| `medicationId` | TEXT NOT NULL | FK a `medications.id` |
| `assignedDate` | TEXT NOT NULL | Fecha ISO8601 cuando se asignó el medicamento a la persona |
| `durationType` | TEXT NOT NULL | Tipo de duración: `everyday`, `untilFinished`, `specificDates`, `weeklyPattern`, `intervalDays`, `asNeeded` |
| `dosageIntervalHours` | INTEGER NOT NULL | Intervalo de horas entre dosis (0 si no aplica) |
| `doseSchedule` | TEXT NOT NULL | JSON con mapa de hora → cantidad (ej: `{"08:00": 1.0, "20:00": 0.5}`) |
| `takenDosesToday` | TEXT NOT NULL | Lista CSV de horas tomadas hoy (ej: `"08:00,20:00"`) |
| `skippedDosesToday` | TEXT NOT NULL | Lista CSV de horas omitidas hoy (ej: `"14:00"`) |
| `takenDosesDate` | TEXT | Fecha ISO8601 de las dosis tomadas/omitidas (ej: `"2025-11-14"`) |
| `selectedDates` | TEXT | Lista CSV de fechas específicas para `durationType = specificDates` |
| `weeklyDays` | TEXT | Lista CSV de días de la semana (1=Lunes, 7=Domingo) para `weeklyPattern` |
| `dayInterval` | INTEGER | Intervalo de días para `durationType = intervalDays` (ej: 2 = cada 2 días) |
| `startDate` | TEXT | Fecha ISO8601 de inicio del tratamiento |
| `endDate` | TEXT | Fecha ISO8601 de fin del tratamiento |
| `requiresFasting` | INTEGER NOT NULL | 1 si requiere ayuno, 0 en caso contrario |
| `fastingType` | TEXT | Tipo de ayuno: `before` o `after` |
| `fastingDurationMinutes` | INTEGER | Duración del ayuno en minutos (ej: 30, 60, 120) |
| `notifyFasting` | INTEGER NOT NULL | 1 si debe notificar períodos de ayuno, 0 en caso contrario |
| `isSuspended` | INTEGER NOT NULL | 1 si el medicamento está suspendido (sin notificaciones), 0 en caso contrario |

#### Notas

- **Relación Única**: Un persona no puede tener el mismo medicamento asignado dos veces (`UNIQUE(personId, medicationId)`)
- **Cascadas**: Si se elimina una persona o medicamento, se eliminan automáticamente las relaciones
- **doseSchedule**: Almacenado como JSON para flexibilidad (ej: diferentes cantidades en diferentes horas)
- **Tipos de Duración**:
  - `everyday`: Todos los días
  - `untilFinished`: Hasta acabar el stock
  - `specificDates`: Solo en fechas específicas (almacenadas en `selectedDates`)
  - `weeklyPattern`: Días específicos de la semana (almacenados en `weeklyDays`)
  - `intervalDays`: Cada N días (especificado en `dayInterval`)
  - `asNeeded`: Según necesidad (sin horario fijo)

---

### Tabla: `dose_history`

Registro histórico de todas las dosis tomadas u omitidas.

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

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `id` | TEXT PRIMARY KEY | Identificador único de la entrada de historial |
| `medicationId` | TEXT NOT NULL | ID del medicamento (desnormalizado para rendimiento) |
| `medicationName` | TEXT NOT NULL | Nombre del medicamento (desnormalizado) |
| `medicationType` | TEXT NOT NULL | Tipo del medicamento (desnormalizado) |
| `personId` | TEXT NOT NULL | FK a `persons.id` - persona que tomó/omitió la dosis |
| `scheduledDateTime` | TEXT NOT NULL | Fecha y hora ISO8601 programada para la dosis |
| `registeredDateTime` | TEXT NOT NULL | Fecha y hora ISO8601 real cuando se registró la toma/omisión |
| `status` | TEXT NOT NULL | Estado de la dosis: `taken` o `skipped` |
| `quantity` | REAL NOT NULL | Cantidad tomada (en unidades del tipo de medicamento) |
| `isExtraDose` | INTEGER NOT NULL | 1 si es una dosis extra (fuera del horario), 0 si es programada |
| `notes` | TEXT | Notas opcionales sobre la dosis |

#### Notas

- **Desnormalización**: `medicationName` y `medicationType` se almacenan aquí para evitar JOINs en consultas de historial
- **Cascada**: Si se elimina una persona, se eliminan sus registros de historial
- **No hay FK a medications**: El historial se mantiene incluso si se elimina el medicamento
- **Retraso**: La diferencia entre `scheduledDateTime` y `registeredDateTime` indica si la dosis fue puntual

---

## Relaciones entre Tablas

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
         │ medicationId     │ (no FK, desnormalizado)
         │ scheduledDateTime│
         │ registeredDateTime│
         │ status           │
         └──────────────────┘
```

### Claves Foráneas

| Tabla | Columna | Referencia | On Delete |
|-------|---------|------------|-----------|
| `person_medications` | `personId` | `persons.id` | CASCADE |
| `person_medications` | `medicationId` | `medications.id` | CASCADE |
| `dose_history` | `personId` | `persons.id` | CASCADE |

---

## Índices

Los siguientes índices están creados para optimizar consultas frecuentes:

```sql
-- Índice para buscar dosis por medicamento
CREATE INDEX idx_dose_history_medication
ON dose_history(medicationId);

-- Índice para buscar dosis por fecha programada
CREATE INDEX idx_dose_history_date
ON dose_history(scheduledDateTime);

-- Índice para buscar medicamentos de una persona
CREATE INDEX idx_person_medications_person
ON person_medications(personId);

-- Índice para buscar personas asignadas a un medicamento
CREATE INDEX idx_person_medications_medication
ON person_medications(medicationId);
```

### Propósito de Cada Índice

- **`idx_dose_history_medication`**: Acelera consultas de historial filtradas por medicamento (ej: ver todas las tomas de Ibuprofeno)
- **`idx_dose_history_date`**: Optimiza consultas por rango de fechas (ej: historial de los últimos 7 días)
- **`idx_person_medications_person`**: Mejora la carga de medicamentos de una persona específica (consulta más frecuente)
- **`idx_person_medications_medication`**: Facilita encontrar qué personas están usando un medicamento

---

## Triggers

Actualmente no hay triggers implementados en la base de datos. La lógica de negocio se maneja en la capa de aplicación (Dart).

**Posibles Triggers Futuros:**

```sql
-- Ejemplo: Actualizar automáticamente stock al registrar una dosis tomada
CREATE TRIGGER update_stock_on_dose_taken
AFTER INSERT ON dose_history
WHEN NEW.status = 'taken' AND NEW.isExtraDose = 0
BEGIN
  UPDATE medications
  SET stockQuantity = stockQuantity - NEW.quantity
  WHERE id = NEW.medicationId;
END;
```

**Nota**: Este trigger no está implementado porque el control de stock se maneja explícitamente en el código de la aplicación para mayor flexibilidad.

---

## Migraciones

### Historial de Versiones (V1 → V19)

| Versión | Cambios Principales |
|---------|---------------------|
| **V1** | Esquema inicial: tabla `medications` básica |
| **V2** | Añadido `doseTimes` (horarios de dosis) |
| **V3** | Añadido `stockQuantity` (gestión de inventario) |
| **V4** | Añadidos `takenDosesToday`, `takenDosesDate` (tracking de tomas diarias) |
| **V5** | Añadido `doseSchedule` (cantidades variables por horario) |
| **V6** | Añadido `skippedDosesToday` (tracking de dosis omitidas) |
| **V7** | Añadido `lastRefillAmount` (sugerencias de reabastecimiento) |
| **V8** | Añadido `lowStockThresholdDays` (umbral configurable) |
| **V9** | Añadidos `selectedDates`, `weeklyDays` (patrones de tratamiento) |
| **V10** | Añadidos `startDate`, `endDate` (rango de tratamiento) |
| **V11** | Creada tabla `dose_history` (historial completo de dosis) |
| **V12** | Añadido `dayInterval` (tratamientos cada N días) |
| **V13** | Añadidos campos de ayuno: `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting` |
| **V14** | Añadido `isSuspended` (suspensión temporal de medicamentos) |
| **V15** | Añadido `lastDailyConsumption` (tracking para medicamentos "según necesidad") |
| **V16** | Añadidos `extraDosesToday` y `isExtraDose` (dosis fuera de horario) |
| **V17** | Creada tabla `persons` (soporte multi-persona) |
| **V18** | Creada tabla `person_medications` (relación N:N), añadido `personId` a `dose_history` |
| **V19** | **Reestructuración mayor**: Separación de datos compartidos (medications) y pautas individuales (person_medications) |

### Migración V18 → V19 (Reestructuración Mayor)

La migración V19 es la más compleja e importante. Separa los datos de medicamentos en dos tablas:

#### Proceso de Migración

1. **Backup**: Se renombran las tablas existentes a `_old`
2. **Nuevas Tablas**: Se crean `medications` y `person_medications` con el nuevo esquema
3. **Migración de Datos Compartidos**: Se copian `id`, `name`, `type`, `stockQuantity`, etc. a `medications`
4. **Migración de Pautas Individuales**: Se copian horarios, duración, ayuno, etc. a `person_medications`
5. **Recreación de Índices**: Se crean los índices optimizados
6. **Limpieza**: Se eliminan las tablas `_old`

```sql
-- Paso 1: Backup
ALTER TABLE person_medications RENAME TO person_medications_old;
ALTER TABLE medications RENAME TO medications_old;

-- Paso 2: Crear nueva tabla medications (solo datos compartidos)
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

-- Paso 4: Crear nueva tabla person_medications (pautas individuales)
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

-- Paso 5: Migrar pautas individuales
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

-- Paso 7: Limpieza
DROP TABLE person_medications_old;
DROP TABLE medications_old;
```

### Sistema de Migración Automática

El sistema detecta automáticamente la versión actual de la base de datos y aplica migraciones progresivas:

```dart
// En database_helper.dart
Future<Database> _initDB(String filePath) async {
  return await openDatabase(
    path,
    version: 19,  // Versión objetivo
    onCreate: _createDB,  // Para bases de datos nuevas
    onUpgrade: _upgradeDB,  // Para migrar desde versiones anteriores
  );
}

Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // Aplica migraciones progresivas desde oldVersion hasta newVersion
  if (oldVersion < 2) { /* Migración V1→V2 */ }
  if (oldVersion < 3) { /* Migración V2→V3 */ }
  // ... hasta V19
}
```

**Ventajas**:
- **Progresivo**: Un usuario con V1 se actualiza automáticamente hasta V19
- **Sin pérdida de datos**: Cada migración preserva los datos existentes
- **Tolerante a errores**: Si falla una migración, la base de datos permanece en el estado anterior

---

## Reglas de Negocio

### 1. Stock Compartido entre Personas

- El `stockQuantity` en la tabla `medications` es **único y compartido**
- Cuando cualquier persona registra una dosis tomada, el stock se decrementa para todos
- **Ejemplo**: Si hay 20 píldoras de Ibuprofeno y Ana toma 1, quedan 19 para todos (incluyendo Carlos)

### 2. Configuraciones Individuales por Persona

- Cada persona puede tener **horarios diferentes** para el mismo medicamento
- **Ejemplo**:
  - Ana toma Ibuprofeno a las 08:00 y 20:00
  - Carlos toma el mismo Ibuprofeno solo a las 14:00

### 3. Validaciones de Integridad

```sql
-- Una persona no puede tener el mismo medicamento dos veces
UNIQUE(personId, medicationId) en person_medications

-- Debe existir al menos una persona por defecto
-- (Validado en la capa de aplicación)
```

### 4. Cascadas de Eliminación

- **Eliminar persona** → Se eliminan todas sus relaciones en `person_medications` y su historial en `dose_history`
- **Eliminar medicamento** → Se eliminan todas las relaciones en `person_medications`, pero **NO** el historial (para auditoría)

### 5. Deduplicación de Medicamentos

Cuando se crea un medicamento, el sistema verifica si ya existe uno con el mismo nombre (case-insensitive):

```dart
// Pseudocódigo
if (exists medication with same name) {
  reutilizar medicamento existente
  crear solo nueva entrada en person_medications
} else {
  crear nuevo medicamento
  crear entrada en person_medications
}
```

---

## Consultas SQL Comunes

### 1. Obtener Medicamentos de una Persona

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

### 2. Registrar una Toma de Medicamento

```sql
-- Paso 1: Insertar en historial
INSERT INTO dose_history (
  id, medicationId, medicationName, medicationType, personId,
  scheduledDateTime, registeredDateTime, status, quantity, isExtraDose, notes
) VALUES (?, ?, ?, ?, ?, ?, ?, 'taken', ?, 0, ?);

-- Paso 2: Actualizar stock (solo si es dosis programada, no extra)
UPDATE medications
SET stockQuantity = stockQuantity - ?
WHERE id = ?;

-- Paso 3: Actualizar takenDosesToday en person_medications
UPDATE person_medications
SET
  takenDosesToday = ?,  -- Añadir hora tomada
  takenDosesDate = ?     -- Actualizar fecha
WHERE personId = ? AND medicationId = ?;
```

### 3. Calcular Stock Disponible y Alertas

```sql
-- Obtener medicamentos con stock bajo para una persona
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
    -- Calcular stock mínimo basado en dosis diaria
    -- (Esta lógica se hace en la aplicación porque doseSchedule es JSON)
  );
```

### 4. Obtener Historial de Dosis (Últimos 30 Días)

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

### 5. Calcular Adherencia (% de Dosis Tomadas)

```sql
-- Total de dosis programadas
SELECT COUNT(*) as total
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?;

-- Dosis tomadas
SELECT COUNT(*) as taken
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime >= ?
  AND scheduledDateTime <= ?
  AND status = 'taken';

-- Adherencia = (taken / total) * 100
```

### 6. Obtener Personas Asignadas a un Medicamento

```sql
SELECT p.id, p.name, p.isDefault
FROM persons p
INNER JOIN person_medications pm ON p.id = pm.personId
WHERE pm.medicationId = ?
ORDER BY p.name ASC;
```

### 7. Verificar si un Medicamento Ya Existe (por nombre)

```sql
SELECT id, name, type, stockQuantity
FROM medications
WHERE LOWER(name) = LOWER(?)
LIMIT 1;
```

---

## Optimizaciones

### 1. Transacciones Batch

Para operaciones que modifican múltiples tablas, se utilizan transacciones:

```dart
await db.transaction((txn) async {
  // Múltiples operaciones atómicas
  await txn.insert('dose_history', entry.toMap());
  await txn.update('medications', {'stockQuantity': newStock}, where: 'id = ?', whereArgs: [medicationId]);
  await txn.update('person_medications', {'takenDosesToday': taken}, where: 'personId = ? AND medicationId = ?', whereArgs: [personId, medicationId]);
});
```

**Ventajas**:
- Atomicidad: Todo se guarda o nada se guarda
- Consistencia: No hay estados intermedios
- Rendimiento: Una sola escritura en disco

### 2. Prepared Statements

Todas las consultas utilizan prepared statements con placeholders (`?`) para prevenir SQL injection y mejorar rendimiento:

```dart
// ✅ Correcto (prepared statement)
await db.query('medications', where: 'id = ?', whereArgs: [id]);

// ❌ Incorrecto (vulnerable a SQL injection)
await db.rawQuery("SELECT * FROM medications WHERE id = '$id'");
```

### 3. Índices Selectivos

Los índices están diseñados para las consultas más frecuentes:
- `idx_person_medications_person`: Para la pantalla principal (mostrar medicamentos del usuario)
- `idx_dose_history_medication`: Para el historial de un medicamento específico
- `idx_dose_history_date`: Para consultas por rango de fechas

### 4. Desnormalización Estratégica

En `dose_history` se almacenan `medicationName` y `medicationType` (desnormalizados) para evitar JOINs costosos en consultas de historial. Esto sacrifica un poco de espacio por mucho rendimiento.

### 5. Caché en Memoria

La aplicación utiliza caché para la persona por defecto:

```dart
Person? _cachedDefaultPerson;

Future<Person?> getDefaultPerson() async {
  if (_cachedDefaultPerson != null) return _cachedDefaultPerson;
  // Consultar base de datos solo si no está en caché
}
```

### 6. ANALYZE y VACUUM

**ANALYZE**: Actualiza estadísticas de la base de datos para optimizar el query planner.

```sql
ANALYZE;
```

**VACUUM**: Reconstruye la base de datos para liberar espacio y optimizar.

```sql
VACUUM;
```

**Recomendación**: Ejecutar `ANALYZE` después de cambios masivos de datos, y `VACUUM` periódicamente (ej: cada 3 meses).

---

## Backup y Restauración

### Ubicación del Archivo de Base de Datos

La base de datos se almacena en:

```
Android: /data/data/com.example.medicapp/databases/medications.db
iOS: /Documents/databases/medications.db
```

Para obtener la ruta real:

```dart
final dbPath = await DatabaseHelper.instance.getDatabasePath();
print('Database location: $dbPath');
```

### Estrategias de Backup

#### 1. Backup Manual (Exportación de Archivo)

```dart
final backupPath = await DatabaseHelper.instance.exportDatabase();
// backupPath = /tmp/medicapp_backup_2025-11-14T10-30-00.db
```

La aplicación copia el archivo `.db` a una ubicación temporal. El usuario puede luego compartir este archivo (Google Drive, correo, etc.).

#### 2. Importación de Backup

```dart
await DatabaseHelper.instance.importDatabase('/path/to/backup.db');
```

**Notas**:
- Se crea un backup automático del archivo actual antes de importar (`.backup`)
- Si la importación falla, se restaura automáticamente el backup

#### 3. Backup Automático (Recomendado para Producción)

Implementar un sistema de backup automático a la nube:

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

Para máxima portabilidad, se puede exportar la base de datos completa a JSON:

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

**Ventajas**:
- Formato legible por humanos
- Fácil de inspeccionar y depurar
- Independiente de SQLite

**Desventajas**:
- Archivo más grande que `.db`
- Requiere parseo al importar

---

## Ejemplo de Uso Completo

### Escenario: Ana y Carlos comparten Ibuprofeno

```sql
-- 1. Crear personas
INSERT INTO persons (id, name, isDefault) VALUES ('person_1', 'Ana', 1);
INSERT INTO persons (id, name, isDefault) VALUES ('person_2', 'Carlos', 0);

-- 2. Crear medicamento compartido (Ibuprofeno)
INSERT INTO medications (id, name, type, stockQuantity, lowStockThresholdDays)
VALUES ('med_1', 'Ibuprofeno 600mg', 'pill', 40.0, 3);

-- 3. Asignar a Ana con su pauta (08:00 y 20:00)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_1', 'person_1', 'med_1', '2025-11-14T00:00:00', 'everyday', 12,
  '{"08:00": 1.0, "20:00": 1.0}', '', ''
);

-- 4. Asignar a Carlos con su pauta (14:00 solamente)
INSERT INTO person_medications (
  id, personId, medicationId, assignedDate, durationType, dosageIntervalHours,
  doseSchedule, takenDosesToday, skippedDosesToday
) VALUES (
  'pm_2', 'person_2', 'med_1', '2025-11-14T00:00:00', 'everyday', 0,
  '{"14:00": 1.0}', '', ''
);

-- 5. Ana toma una dosis a las 08:05
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

## Resumen

- **Versión**: V19 (SQLite)
- **Tablas Principales**: `persons`, `medications`, `person_medications`, `dose_history`
- **Arquitectura**: Multi-persona con datos compartidos (stock) y configuraciones individuales (pautas)
- **Migraciones**: Sistema automático progresivo V1→V19
- **Integridad**: Claves foráneas con cascadas, índices optimizados
- **Optimizaciones**: Transacciones batch, prepared statements, caché en memoria, desnormalización estratégica
- **Backup**: Exportación de archivo `.db` y JSON, importación con rollback automático

Esta base de datos está diseñada para soportar aplicaciones de gestión de medicamentos multi-usuario con alto rendimiento y garantías de integridad de datos.

