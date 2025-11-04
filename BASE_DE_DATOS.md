# Base de datos

La aplicación utiliza SQLite para almacenar localmente todos los medicamentos. Los datos persisten entre sesiones de la aplicación.

## Arquitectura Multi-Persona (V19+)

A partir de la versión 19, MedicApp implementa una **arquitectura muchos-a-muchos** para soporte multi-persona. Esto permite:
- Gestionar medicamentos para múltiples personas (familiares, pacientes, etc.)
- Reutilizar medicamentos compartidos entre personas (mismo medicamento, diferentes horarios/configuraciones)
- Cada persona puede tener su propia configuración de horarios y seguimiento para cada medicamento
- Historial de dosis por persona

### Características de la base de datos:

- **Patrón Singleton**: Una única instancia de `DatabaseHelper` gestiona todas las operaciones
- **CRUD completo**: Create, Read, Update, Delete
- **Arquitectura muchos-a-muchos**: Medicamentos compartibles entre múltiples personas

## Estructura de Tablas

### Tabla `persons` (desde versión 19):
Almacena información de las personas que usan la aplicación (usuario principal, familiares, etc.)

  - `id` (TEXT PRIMARY KEY) - UUID único de la persona
  - `name` (TEXT NOT NULL) - Nombre de la persona
  - `isDefault` (INTEGER NOT NULL DEFAULT 0) - Indica si es la persona por defecto (1=sí, 0=no)
  - `createdAt` (TEXT NOT NULL) - Fecha de creación en formato ISO 8601

**Reglas de negocio**:
- Siempre debe existir al menos una persona (creada automáticamente en primera ejecución)
- Solo puede haber una persona marcada como `isDefault`
- La persona por defecto no se puede eliminar
- Al eliminar una persona, se eliminan sus asignaciones en `person_medications`

### Tabla `person_medications` (desde versión 19):
Tabla de unión que implementa la relación muchos-a-muchos entre personas y medicamentos. Almacena la configuración específica de cada persona para cada medicamento.

  - `id` (TEXT PRIMARY KEY) - UUID único del assignment
  - `personId` (TEXT NOT NULL) - FK a `persons.id`
  - `medicationId` (TEXT NOT NULL) - FK a `medications.id`
  - `durationType` (TEXT NOT NULL) - Tipo de tratamiento (daily, specificDates, weeklyPattern, dayInterval, untilFinished, asNeeded)
  - `dosageIntervalHours` (INTEGER NOT NULL) - Intervalo entre dosis en horas
  - `doseSchedule` (TEXT NOT NULL) - Horarios y cantidades en formato JSON: {"HH:mm": cantidad, ...}
  - `selectedDates` (TEXT NULLABLE) - Fechas específicas para el tratamiento
  - `weeklyDays` (TEXT NULLABLE) - Días de la semana para tratamiento semanal
  - `dayInterval` (INTEGER NULLABLE) - Intervalo en días para tratamientos como "cada N días"
  - `takenDosesToday` (TEXT NOT NULL DEFAULT '') - Horarios de tomas tomadas hoy
  - `skippedDosesToday` (TEXT NOT NULL DEFAULT '') - Horarios de tomas no tomadas hoy
  - `extraDosesToday` (TEXT NOT NULL DEFAULT '') - Horarios de tomas extra registradas hoy
  - `takenDosesDate` (TEXT NULLABLE) - Fecha de las tomas registradas en formato "yyyy-MM-dd"
  - `startDate` (TEXT NULLABLE) - Fecha de inicio del tratamiento
  - `endDate` (TEXT NULLABLE) - Fecha de fin del tratamiento
  - `requiresFasting` (INTEGER NOT NULL DEFAULT 0) - Si el medicamento requiere ayuno (0=no, 1=sí)
  - `fastingType` (TEXT NULLABLE) - Tipo de ayuno: 'before' o 'after'
  - `fastingDurationMinutes` (INTEGER NULLABLE) - Duración del período de ayuno en minutos
  - `notifyFasting` (INTEGER NOT NULL DEFAULT 0) - Si se deben enviar notificaciones de ayuno
  - `isSuspended` (INTEGER NOT NULL DEFAULT 0) - Si el medicamento está suspendido para esta persona
  - `createdAt` (TEXT NOT NULL) - Fecha de creación en formato ISO 8601
  - UNIQUE(`personId`, `medicationId`) - Una persona no puede tener el mismo medicamento asignado múltiples veces

**Reglas de negocio**:
- Al eliminar un medicamento, se eliminan todas sus asignaciones
- Al eliminar una persona, se eliminan todas sus asignaciones
- Si un medicamento no tiene asignaciones, se puede eliminar de `medications`
- Las notificaciones se programan por persona (cada persona recibe sus propias notificaciones)

### Tabla `medications` (versión 19):
Almacena la información **compartida** de los medicamentos (nombre, tipo, stock). La configuración específica de horarios está en `person_medications`.

  - `id` (TEXT PRIMARY KEY) - UUID único del medicamento
  - `name` (TEXT NOT NULL) - Nombre del medicamento
  - `type` (TEXT NOT NULL) - Tipo: pill, capsule, syrup, drops, injection, cream
  - `stockQuantity` (REAL NOT NULL DEFAULT 0) - Cantidad de medicamento disponible (compartida entre todas las personas)
  - `lastRefillAmount` (REAL NULLABLE) - Última cantidad de recarga (sugerencia para futuras recargas)
  - `lowStockThresholdDays` (INTEGER NOT NULL DEFAULT 3) - Días de anticipación para aviso de stock bajo
  - `lastDailyConsumption` (REAL NULLABLE) - Consumo diario promedio para medicamentos "según necesidad"

**Campos obsoletos** (mantenidos solo para retrocompatibilidad con versiones < 19):
  - `durationType`, `dosageIntervalHours`, `doseSchedule`, `takenDosesToday`, `skippedDosesToday`, `extraDosesToday`, `takenDosesDate`, `selectedDates`, `weeklyDays`, `dayInterval`, `startDate`, `endDate`, `requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting`, `isSuspended`
  - Estos campos ahora se almacenan en `person_medications` por persona

**Migración de datos**:
- Al actualizar a V19, los medicamentos existentes se migran automáticamente
- Se crea una persona por defecto ("Usuario") si no existe
- Los medicamentos legacy se asignan a la persona por defecto
- Los datos de configuración se copian a `person_medications`

### Tabla `dose_history` (desde versión 11):
Historial completo de todas las dosis registradas. Desde V19+ incluye referencia a la persona.

  - `id` (TEXT PRIMARY KEY) - UUID único de la entrada de historial
  - `medicationId` (TEXT NOT NULL) - FK a `medications.id`
  - `medicationName` (TEXT NOT NULL) - Nombre del medicamento (desnormalizado para consultas rápidas)
  - `medicationType` (TEXT NOT NULL) - Tipo del medicamento (desnormalizado para consultas rápidas)
  - `personId` (TEXT NOT NULL) - FK a `persons.id` (añadido en V19+)
  - `scheduledDateTime` (TEXT NOT NULL) - Hora programada de la toma en formato ISO 8601
  - `registeredDateTime` (TEXT NOT NULL) - Hora real de registro en formato ISO 8601
  - `status` (TEXT NOT NULL) - Estado: 'taken' o 'skipped'
  - `quantity` (REAL NOT NULL) - Cantidad tomada/omitida
  - `notes` (TEXT NULLABLE) - Notas opcionales
  - `isExtraDose` (INTEGER NOT NULL DEFAULT 0) - Indica si es una toma extra/excepcional (0=no, 1=sí)
  - Índices en `medicationId`, `personId` y `scheduledDateTime` para consultas rápidas

**Uso**:
- Permite tracking completo de adherencia al tratamiento por persona
- Las consultas pueden filtrar por medicamento, persona, rango de fechas, etc.
- Se usa para generar estadísticas y reportes

## Migraciones de Base de Datos

Sistema de versionado automático para actualizar el esquema sin perder datos:

### Historial de Versiones:
- **V1 → V2**: Campos de duración de tratamiento y horarios
- **V2 → V11**: Múltiples mejoras incluyendo sistema de historial de dosis
- **V11 → V12**: Campo `dayInterval` para tratamientos con intervalo de días
- **V12 → V13**: Campos de ayuno (`requiresFasting`, `fastingType`, `fastingDurationMinutes`, `notifyFasting`)
- **V13 → V14**: Campo `isSuspended` para suspensión de medicamentos
- **V14 → V15**: Campo `lastDailyConsumption` para medicamentos ocasionales
- **V15 → V16**: Campos `extraDosesToday` e `isExtraDose` para tomas excepcionales
- **V16 → V19**: **Arquitectura multi-persona (cambio mayor)**

### Migración V16 → V19 (Multi-Persona):

**Cambios estructurales**:
1. Creación de tabla `persons`
2. Creación de tabla `person_medications` (muchos-a-muchos)
3. Adición de campo `personId` en `dose_history`
4. Los campos de configuración en `medications` se mantienen por retrocompatibilidad

**Proceso de migración automática**:
1. Se crea la persona por defecto si no existe ("Usuario" con `isDefault=1`)
2. Se migran todos los medicamentos existentes:
   - Los datos de configuración (horarios, tipo de tratamiento, etc.) se copian a `person_medications`
   - Se crea una entrada en `person_medications` asociando cada medicamento con la persona por defecto
   - Los campos obsoletos en `medications` se mantienen pero ya no se usan
3. Se actualiza `dose_history`:
   - Se agrega el campo `personId` a todas las entradas existentes
   - Todas las entradas legacy se asocian a la persona por defecto
4. Las notificaciones se reprograman automáticamente para la persona por defecto

**Retrocompatibilidad**:
- Los métodos legacy de `DatabaseHelper` siguen funcionando
- `getMedications()` devuelve medicamentos de la persona por defecto
- `updateMedication()` actualiza solo campos compartidos (stock)
- `updateMedicationForPerson()` actualiza configuración específica por persona

## Diagrama de Relaciones

```
persons (1) ─────┐
                 │
                 │ (muchos-a-muchos)
                 │
                 └──> person_medications (N) ──> (1) medications
                              │
                              │ (historial)
                              │
                              └──> (N) dose_history
```

## Consultas Comunes

### Obtener medicamentos de una persona:
```sql
SELECT m.*, pm.*
FROM medications m
INNER JOIN person_medications pm ON m.id = pm.medicationId
WHERE pm.personId = ?
```

### Obtener historial de dosis de una persona:
```sql
SELECT *
FROM dose_history
WHERE personId = ?
  AND scheduledDateTime BETWEEN ? AND ?
ORDER BY scheduledDateTime DESC
```

### Verificar si un medicamento está asignado a una persona:
```sql
SELECT COUNT(*)
FROM person_medications
WHERE personId = ? AND medicationId = ?
```
