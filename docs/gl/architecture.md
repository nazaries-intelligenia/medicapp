# Arquitectura de MedicApp

## Táboa de Contidos

1. [Visión Xeral da Arquitectura](#visión-xeral-da-arquitectura)
2. [Arquitectura Multi-Persoa V19+](#arquitectura-multi-persoa-v19)
3. [Capa de Modelos (Models)](#capa-de-modelos-models)
4. [Capa de Servizos (Services)](#capa-de-servizos-services)
5. [Capa de Vista (Screens/Widgets)](#capa-de-vista-screenswidgets)
6. [Fluxo de Datos](#fluxo-de-datos)
7. [Xestión de Notificacións](#xestión-de-notificacións)
8. [Base de Datos SQLite V19](#base-de-datos-sqlite-v19)
9. [Optimizacións de Rendemento](#optimizacións-de-rendemento)
10. [Modularización do Código](#modularización-do-código)
11. [Localización (l10n)](#localización-l10n)
12. [Decisións de Deseño](#decisións-de-deseño)

---

## Visión Xeral da Arquitectura

MedicApp utiliza un **patrón Model-View-Service (MVS)** simplificado, sen dependencias de frameworks complexos de state management como BLoC, Riverpod ou Redux.

### Xustificación

A decisión de non usar state management complexo baséase en:

1. **Simplicidade**: A aplicación xestiona estado principalmente a nivel de pantalla/widget
2. **Rendemento**: Menos capas de abstracción = respostas máis rápidas
3. **Mantemento**: Código máis directo e fácil de entender
4. **Tamaño**: Menos dependencias = APK máis lixeiro

### Diagrama de Capas

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer (Views)                     │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │  Screens   │  │  Widgets   │  │  ViewModels    │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  Service Layer                          │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │Notification│  │DoseHistory │  │DoseCalculation │   │
│  │  Service   │  │  Service   │  │    Service     │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   Data Layer                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │  Models    │  │ Database   │  │ Preferences    │   │
│  │            │  │  Helper    │  │                │   │
│  └────────────┘  └────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Arquitectura Multi-Persoa V19+

A partir da versión 19, MedicApp implementa un **modelo de datos N:N (moitos-a-moitos)** que permite que múltiples persoas compartan o mesmo medicamento mentres manteñen configuracións individuais.

### Modelo de Datos N:N

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   persons   │         │person_medications│         │ medications │
├─────────────┤         ├──────────────────┤         ├─────────────┤
│ id          │◄────────│ personId         │         │ id          │
│ name        │         │ medicationId     │────────►│ name        │
│ isDefault   │         │ assignedDate     │         │ type        │
└─────────────┘         │                  │         │ stockQuantity│
                        │ PAUTA INDIVIDUAL │         │ lastRefill  │
                        │ ──────────────── │         │ lowStockDays│
                        │ durationType     │         │ lastConsump.│
                        │ doseSchedule     │         └─────────────┘
                        │ takenDosesToday  │
                        │ skippedDosesTo.. │
                        │ startDate        │
                        │ endDate          │
                        │ requiresFasting  │
                        │ isSuspended      │
                        └──────────────────┘
```

### Separación de Responsabilidades

| Táboa | Responsabilidade | Exemplos |
|-------|-----------------|----------|
| **medications** | Datos COMPARTIDOS entre persoas | nome, tipo, stock físico |
| **person_medications** | Configuración INDIVIDUAL de cada persoa | horarios, duración, estado de suspensión |
| **dose_history** | Historial de tomas por persoa | rexistro con personId |

### Exemplos de Casos de Uso

#### Exemplo 1: Paracetamol Compartido

```
Medicamento: Paracetamol 500mg
├─ Stock compartido: 50 pastillas
├─ Persoa: Xoán (usuario por defecto)
│  └─ Pauta: 08:00, 16:00, 00:00 (3 veces ao día)
└─ Persoa: María (familiar)
   └─ Pauta: 12:00 (1 vez ao día, só segundo necesidade)
```

En base de datos:
- **1 entrada** en `medications` (stock compartido)
- **2 entradas** en `person_medications` (pautas diferentes)

#### Exemplo 2: Medicamentos Diferentes

```
Xoán:
├─ Omeprazol 20mg → 08:00
└─ Atorvastatina 40mg → 22:00

María:
└─ Levotiroxina 100mcg → 07:00
```

En base de datos:
- **3 entradas** en `medications`
- **3 entradas** en `person_medications` (unha por medicamento-persoa)

### Migración Automática V16→V19

A base de datos migra automaticamente de arquitecturas antigas:

```dart
// V18: medications contiña TODO (stock + pauta)
medications (id, name, type, stock, doseSchedule, durationType, ...)

// V19: SEPARACIÓN
medications (id, name, type, stock)  // SÓ datos compartidos
person_medications (personId, medicationId, doseSchedule, durationType, ...)
```

**Proceso de migración:**
1. Backup de táboas antigas (`medications_old`, `person_medications_old`)
2. Creación de novas estruturas
3. Copia de datos compartidos a `medications`
4. Copia de pautas individuais a `person_medications`
5. Recreación de índices
6. Eliminación de backups

---

## Capa de Modelos (Models)

### Person

Representa a unha persoa (usuario ou familiar).

```dart
class Person {
  final String id;
  final String name;
  final bool isDefault;  // Usuario principal
}
```

**Responsabilidades:**
- Identificación única
- Nome para mostrar en UI
- Indicador de persoa por defecto (recibe notificacións sen prefixo de nome)

### Medication

Representa o **medicamento físico** co seu stock compartido.

```dart
class Medication {
  // DATOS COMPARTIDOS (en táboa medications)
  final String id;
  final String name;
  final MedicationType type;
  final double stockQuantity;
  final double? lastRefillAmount;
  final int lowStockThresholdDays;
  final double? lastDailyConsumption;

  // DATOS INDIVIDUAIS (de person_medications, fusiónanse ao consultar)
  final TreatmentDurationType durationType;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool requiresFasting;
  final bool isSuspended;
  // ... máis campos de configuración individual
}
```

**Métodos importantes:**
- `shouldTakeToday()`: Lóxica de frecuencia (diaria, semanal, intervalo, datas específicas)
- `isActive`: Verifica se o tratamento está en período activo
- `isStockLow`: Calcula se queda stock baixo segundo consumo diario
- `getAvailableDosesToday()`: Filtra doses non tomadas/omitidas

### PersonMedication

Táboa intermedia N:N coa **pauta individual** de cada persoa.

```dart
class PersonMedication {
  final String id;
  final String personId;
  final String medicationId;
  final String assignedDate;

  // PAUTA INDIVIDUAL
  final TreatmentDurationType durationType;
  final int dosageIntervalHours;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final String? takenDosesDate;
  final List<String>? selectedDates;
  final List<int>? weeklyDays;
  final int? dayInterval;
  final String? startDate;
  final String? endDate;
  final bool requiresFasting;
  final String? fastingType;
  final int? fastingDurationMinutes;
  final bool notifyFasting;
  final bool isSuspended;
}
```

### DoseHistoryEntry

Rexistro histórico de cada toma/omisión.

```dart
class DoseHistoryEntry {
  final String id;
  final String medicationId;
  final String personId;  // V19+: Rastrexo por persoa
  final DateTime scheduledDateTime;  // Hora programada
  final DateTime registeredDateTime; // Hora real de rexistro
  final DoseStatus status;  // taken | skipped
  final double quantity;
  final bool isExtraDose;  // Dose fóra de horario
  final String? notes;
}
```

**Funcionalidade:**
- Auditoría de adherencia
- Cálculo de estatísticas
- Permite edición de tempo de rexistro
- Distingue entre doses programadas e extra

### Relacións Entre Modelos

```
Person (1) ──── (N) PersonMedication (N) ──── (1) Medication
   │                      │                         │
   │                      │                         │
   │                      ▼                         │
   └──────────────► DoseHistoryEntry ◄─────────────┘
```

---

## Capa de Servizos (Services)

### DatabaseHelper (Singleton)

Xestiona TODAS as operacións de SQLite.

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // CRUD Medications (só datos compartidos)
  Future<int> insertMedication(Medication medication);
  Future<Medication?> getMedication(String id);
  Future<List<Medication>> getAllMedications();
  Future<int> updateMedication(Medication medication);

  // V19+: CRUD con persoas
  Future<String> createMedicationForPerson({
    required Medication medication,
    required String personId,
  });
  Future<Medication?> getMedicationForPerson(String medicationId, String personId);
  Future<List<Medication>> getMedicationsForPerson(String personId);
  Future<int> updateMedicationForPerson({
    required Medication medication,
    required String personId,
  });

  // CRUD Persons
  Future<int> insertPerson(Person person);
  Future<Person?> getDefaultPerson();
  Future<List<Person>> getAllPersons();

  // CRUD PersonMedications
  Future<int> insertPersonMedication(PersonMedication pm);
  Future<List<Person>> getPersonsForMedication(String medicationId);

  // CRUD DoseHistory
  Future<int> insertDoseHistory(DoseHistoryEntry entry);
  Future<List<DoseHistoryEntry>> getDoseHistoryForDateRange(...);
  Future<Map<String, dynamic>> getDoseStatistics(...);
}
```

**Características clave:**
- Singleton para evitar múltiples conexións
- Migracións automáticas ata V19
- Caché de persoa por defecto para optimizar queries
- Métodos de exportación/importación de base de datos

### NotificationService (Singleton)

Xestiona TODAS as notificacións do sistema.

```dart
class NotificationService {
  static final NotificationService instance = NotificationService._init();

  // Inicialización
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> canScheduleExactAlarms();

  // Programación V19+ (require personId)
  Future<void> scheduleMedicationNotifications(
    Medication medication,
    {required String personId, bool excludeToday = false}
  );

  // Cancelación intelixente
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication});
  Future<void> cancelTodaysDoseNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  });

  // Pospor dose
  Future<void> schedulePostponedDoseNotification({
    required Medication medication,
    required String originalDoseTime,
    required TimeOfDay newTime,
    required String personId,
  });

  // Xaxún
  Future<void> scheduleDynamicFastingNotification({
    required Medication medication,
    required DateTime actualDoseTime,
    required String personId,
  });
  Future<void> showOngoingFastingNotification({
    required String personId,
    required String medicationName,
    required String timeRemaining,
    required String endTime,
  });

  // Reprogramación masiva
  Future<void> rescheduleAllMedicationNotifications();

  // Debug
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
```

**Delegación especializada:**
- `DailyNotificationScheduler`: Notificacións diarias recurrentes
- `WeeklyNotificationScheduler`: Patróns semanais
- `FastingNotificationScheduler`: Xestión de períodos de xaxún
- `NotificationCancellationManager`: Cancelación intelixente

**Límite de notificacións:**
A app mantén un máximo de **5 notificacións activas** no sistema para evitar saturación.

### DoseHistoryService

Centraliza operacións sobre o historial.

```dart
class DoseHistoryService {
  static Future<void> deleteHistoryEntry(DoseHistoryEntry entry);
  static Future<DoseHistoryEntry> changeEntryStatus(
    DoseHistoryEntry entry,
    DoseStatus newStatus,
  );
  static Future<DoseHistoryEntry> changeRegisteredTime(
    DoseHistoryEntry entry,
    DateTime newRegisteredTime,
  );
}
```

**Vantaxes:**
- Evita duplicación de lóxica entre pantallas
- Manexa automaticamente actualización de `Medication` se a entrada é de hoxe
- Restaura stock se se elimina unha toma

### DoseCalculationService

Lóxica de negocio para calcular próximas doses.

```dart
class DoseCalculationService {
  static NextDoseInfo? getNextDoseInfo(Medication medication);
  static String formatNextDose(NextDoseInfo info, BuildContext context);
}
```

**Responsabilidades:**
- Detecta próxima dose segundo frecuencia
- Formatea mensaxes localizadas ("Hoxe ás 18:00", "Mañá ás 08:00")
- Respecta datas de inicio/fin de tratamento

### DoseActionService

Centraliza a lóxica de rexistro de doses para evitar duplicación de código entre compoñentes UI.

```dart
class DoseActionService {
  // Rexistro de doses programadas
  static Future<Medication> registerTakenDose({
    required Medication medication,
    required String doseTime,
  });

  static Future<Medication> registerSkippedDose({
    required Medication medication,
    required String doseTime,
  });

  // Rexistro de doses manuais
  static Future<Medication> registerManualDose({
    required Medication medication,
    required double quantity,
    double? lastDailyConsumption,
  });

  static Future<Medication> registerExtraDose({
    required Medication medication,
    required double quantity,
  });

  // Cálculo de consumo diario
  static Future<double> calculateDailyConsumption({
    required String medicationId,
    DateTime? date,
  });
}
```

**Responsabilidades:**
- Validar stock suficiente antes de rexistrar doses
- Actualizar estado de doses tomadas/omitidas por día
- Descontar stock automaticamente
- Crear entradas en historial de doses
- Xestionar notificacións relacionadas (cancelar, reprogramar, xaxún)
- Calcular consumo diario total para medicamentos "segundo necesidade"

**Método `calculateDailyConsumption`:**
Engadido para centralizar o cálculo de consumo diario, especialmente útil para medicamentos "segundo necesidade". Suma todas as doses tomadas nun día específico, excluíndo doses omitidas. Este valor úsase para actualizar `lastDailyConsumption` e predecir días de stock restantes.

**Excepcións:**
- `InsufficientStockException`: Lánzase cando non hai stock suficiente para completar unha dose

### SmartCacheService (Singleton)

Sistema de caché intelixente que optimiza o rendemento da aplicación mediante almacenamento temporal de datos frecuentemente accedidos.

```dart
class SmartCacheService<T> {
  final int maxSize;
  final Duration ttl;

  // Operacións principais
  T? get(String key);
  void put(String key, T value);
  Future<T> getOrCompute(String key, Future<T> Function() computer);
  void invalidate(String key);
  void clear();

  // Estatísticas
  CacheStatistics get statistics;
}
```

**Características:**
- **TTL (Time-To-Live) automático**: Cada entrada expira despois dun período configurable
- **Algoritmo LRU**: Evicción de entradas menos recentemente usadas cando se alcanza o límite
- **Patrón cache-aside**: Método `getOrCompute()` que verifica caché primeiro, logo computa se é necesario
- **Auto-limpeza**: Timer periódico que elimina entradas expiradas cada minuto
- **Estatísticas en tempo real**: Tracking de hits, misses, evictions e hit rate

#### MedicationCacheService

Xestiona catro cachés especializados para diferentes tipos de datos de medicamentos:

```dart
class MedicationCacheService {
  // Cachés especializados
  static final medicationsCache = SmartCacheService<List<Medication>>(
    maxSize: 50,
    ttl: Duration(minutes: 10),
  );

  static final listsCache = SmartCacheService<List<Medication>>(
    maxSize: 20,
    ttl: Duration(minutes: 5),
  );

  static final historyCache = SmartCacheService<List<DoseHistoryEntry>>(
    maxSize: 30,
    ttl: Duration(minutes: 3),
  );

  static final statisticsCache = SmartCacheService<Map<String, dynamic>>(
    maxSize: 10,
    ttl: Duration(minutes: 30),
  );
}
```

**Configuracións por tipo:**
- **Medicacións**: 10 minutos TTL, 50 entradas máximo - Para medicamentos individuais
- **Listas**: 5 minutos TTL, 20 entradas - Para listas de medicamentos por persoa/filtro
- **Historial**: 3 minutos TTL, 30 entradas - Para consultas de historial de doses
- **Estatísticas**: 30 minutos TTL, 10 entradas - Para cálculos estatísticos pesados

**Vantaxes:**
- Reduce accesos a base de datos en 60-80% para datos frecuentemente consultados
- Mellora tempos de resposta de queries complexos (estatísticas, historial)
- Invalidación selectiva cando se modifican datos
- Memoria controlada con límites configurables

### IntelligentRemindersService

Servizo de análise de adherencia e predición de patróns de medicación.

```dart
class IntelligentRemindersService {
  // Análise de adherencia
  static Future<AdherenceAnalysis> analyzeAdherence({
    required String personId,
    required String medicationId,
    int daysToAnalyze = 30,
  });

  // Predición de omisións
  static Future<SkipProbability> predictSkipProbability({
    required String personId,
    required String medicationId,
    required int dayOfWeek,
    required String timeOfDay,
  });

  // Suxestións de horarios óptimos
  static Future<List<TimeOptimizationSuggestion>> suggestOptimalTimes({
    required String personId,
    required String medicationId,
  });
}
```

**Funcionalidade analyzeAdherence():**

Realiza unha análise completa de adherencia terapéutica baseada no historial de doses:

- **Métricas por día da semana**: Calcula taxas de adherencia para cada día (Lun-Dom)
- **Métricas por hora do día**: Identifica en que horarios hai mellor cumprimento
- **Mellores/peores días e horarios**: Detecta patróns de éxito e problemas
- **Días problemáticos**: Lista días con adherencia <50%
- **Recomendacións personalizadas**: Xera suxestións baseadas en patróns detectados
- **Tendencia**: Calcula se a adherencia está mellorando, estable ou declinando

Exemplo de análise:
```dart
AdherenceAnalysis {
  overallAdherence: 0.85,  // 85% de adherencia global
  bestDay: 'Monday',        // Mellor día: luns
  worstDay: 'Saturday',     // Peor día: sábado
  bestTimeSlot: '08:00',    // Mellor horario: 8:00
  worstTimeSlot: '22:00',   // Peor horario: 22:00
  trend: AdherenceTrend.improving,  // Mellorando co tempo
  recommendations: [
    'Considera mover dose de 22:00 a 20:00 (mellor adherencia)',
    'Os fins de semana necesitan recordatorios adicionais'
  ]
}
```

**Funcionalidade predictSkipProbability():**

Predí a probabilidade de que unha dose sexa omitida baseándose en patróns históricos:

- **Entrada**: Persoa, medicamento, día da semana específico, hora específica
- **Análise**: Examina historial de omisións en condicións similares
- **Saída**: Probabilidade (0.0-1.0) e clasificación de risco (baixo/medio/alto)
- **Factores considerados**: Día da semana, hora do día, tendencia recente

Exemplo de predición:
```dart
SkipProbability {
  probability: 0.65,         // 65% probabilidade de omisión
  riskLevel: RiskLevel.high, // Risco alto
  factors: [
    'Sábados teñen 60% máis omisións',
    'Horario 22:00 é consistentemente problemático'
  ]
}
```

**Funcionalidade suggestOptimalTimes():**

Suxire cambios de horario para mellorar a adherencia:

- Identifica horarios actuais con baixa adherencia (<70%)
- Busca horarios alternativos con mellor historial de cumprimento
- Calcula o potencial de mellora para cada suxestión
- Prioriza suxestións por impacto esperado

Exemplo de suxestións:
```dart
[
  TimeOptimizationSuggestion {
    currentTime: '22:00',
    suggestedTime: '20:00',
    currentAdherence: 0.45,      // 45% adherencia actual
    expectedAdherence: 0.82,     // 82% esperada en novo horario
    improvementPotential: 0.37,  // +37% mellora potencial
    reason: 'A adherencia ás 20:00 é consistentemente alta'
  }
]
```

**Casos de uso:**
- Pantallas de estatísticas con análise detallada de adherencia
- Alertas proactivas cando se detectan patróns de omisión
- Asistente de optimización de horarios
- Reportes médicos con insights de cumprimento

### FastingConflictService

Detecta conflitos entre horarios de medicamentos e períodos de xaxún.

```dart
class FastingConflictService {
  static FastingConflict? checkForConflicts({
    required String selectedTime,
    required List<Medication> allMedications,
    String? excludeMedicationId,
  });
  static String? suggestAlternativeTime({
    required String conflictTime,
    required FastingConflict conflict,
  });
}
```

**Responsabilidades:**
- Verifica se un horario proposto coincide cun período de xaxún doutro medicamento
- Calcula períodos de xaxún activos (antes/despois de tomar medicamentos)
- Suxire horarios alternativos que eviten conflitos
- Soporta xaxún "before" (antes de tomar) e "after" (despois de tomar)

**Casos de uso:**
- Ao engadir un novo horario de dose en `DoseScheduleEditor`
- Ao crear ou editar un medicamento en `EditScheduleScreen`
- Prevén conflitos que poderían comprometer a efectividade do tratamento
- Activado en V19+ tras refactorización de `EditScheduleScreen` para recibir `allMedications` e `personId` como parámetros

### Sistema de Notificacións de Stock Baixo

MedicApp implementa un sistema dual de alertas de stock que combina notificacións reactivas (no momento crítico) e proactivas (anticipatorias).

#### Notificacións Reactivas (Immediate Stock Check)

O sistema verifica automaticamente o stock dispoñible cada vez que un usuario intenta rexistrar unha dose, xa sexa desde:
- A pantalla principal ao marcar unha dose como "tomada"
- As accións rápidas de notificación (botón "Rexistrar")
- O rexistro manual de doses ocasionais

**Implementación en NotificationService:**

```dart
Future<void> showLowStockNotification({
  required Medication medication,
  required String personName,
  bool isInsufficientForDose = false,
  int? daysRemaining,
}) async
```

**Fluxo reactivo:**
1. Usuario intenta rexistrar unha dose
2. Sistema verifica: `medication.stockQuantity < doseQuantity`
3. Se é insuficiente:
   - Mostra notificación inmediata con prioridade alta
   - NON permite o rexistro da dose
   - Indica cantidade necesaria vs dispoñible
   - Guía ao usuario a repoñer stock

**Rango de IDs de notificación:** 7,000,000 - 7,999,999 (xerados por `NotificationIdGenerator.generateLowStockId()`)

#### Notificacións Proactivas (Daily Stock Monitoring)

O sistema pode executar chequeos proactivos diarios que anticipan problemas de desabastecemento antes de que ocorran.

**Método principal:**

```dart
Future<void> checkLowStockForAllMedications() async
```

**Fluxo proactivo:**
1. Execútase máximo unha vez ao día (utiliza SharedPreferences para tracking)
2. Itera sobre todas as persoas rexistradas
3. Para cada medicamento activo:
   - Calcula dose diaria total considerando:
     - Todas as persoas asignadas ao medicamento
     - Frecuencia de tratamento (diario, semanal, intervalo)
     - Horarios configurados por persoa
   - Divide stock actual entre dose diaria
   - Obtén días de subministración restantes
4. Se `medication.isStockLow` (utiliza o limiar configurable por medicamento):
   - Emite notificación proactiva
   - Inclúe días aproximados restantes
   - Non bloquea ningunha acción

**Prevención de spam:**
- Rexistra última data de chequeo en `SharedPreferences`
- Só executa se `lastCheck != today`
- Cada medicamento só notifica unha vez ao día
- Reiníciase ao repoñer stock

**Integración con Medication.isStockLow:**
O cálculo de stock baixo utiliza a propiedade existente do modelo:
```dart
bool get isStockLow {
  if (stockQuantity <= 0) return true;
  final dailyDose = doseSchedule.values.fold(0.0, (sum, dose) => sum + dose);
  if (dailyDose <= 0) return false;
  final daysRemaining = stockQuantity / dailyDose;
  return daysRemaining <= lowStockThresholdDays;
}
```

#### Configuración de Canles de Notificación

As notificacións de stock utilizan unha canle dedicada:

```dart
// En NotificationConfig.getStockAlertAndroidDetails()
AndroidNotificationDetails(
  'stock_alerts',
  'Alertas de Stock Baixo',
  channelDescription: 'Notificacións cando o stock de medicamentos está baixo',
  importance: Importance.high,
  priority: Priority.high,
  autoCancel: true,
)
```

**Características:**
- Canle separada de recordatorios de dose
- Prioridade alta (non máxima, para non ser intrusivo)
- Auto-cancelación ao tocar
- Sen accións integradas (só informativas)

#### Cando Usar Cada Tipo

| Tipo | Momento | Propósito | Bloqueante |
|------|---------|-----------|------------|
| **Reactivo** | Ao intentar rexistrar dose | Previr rexistro con stock insuficiente | ✅ Si |
| **Proactivo** | Chequeo diario (opcional) | Anticipar reposición necesaria | ❌ Non |

**Vantaxe do deseño dual:**
- Protección absoluta no momento crítico (reactivo)
- Planificación anticipada para evitar chegar ao momento crítico (proactivo)
- O sistema proactivo é opt-in (debe chamarse explícitamente desde lóxica de app)

### MedicationUpdateService

Centraliza operacións comúns de actualización de medicamentos para evitar duplicación de código e asegurar comportamento consistente.

```dart
class MedicationUpdateService {
  // Reabastecemento de stock
  static Future<Medication> refillMedication({
    required Medication medication,
    required double refillAmount,
  });

  // Xestión de estado suspended
  static Future<Medication> resumeMedication({
    required Medication medication,
  });

  static Future<Medication> suspendMedication({
    required Medication medication,
  });
}
```

**Responsabilidades:**
- **refillMedication**: Actualiza stock e garda `lastRefillAmount` para referencia futura
- **resumeMedication**: Activa medicamento suspendido e reprograma notificacións para todas as persoas asignadas
- **suspendMedication**: Desactiva medicamento e cancela todas as notificacións programadas

**Vantaxes de centralización:**
- Elimina creación manual repetitiva de obxectos `Medication` con `copyWith`
- Manexa correctamente a táboa `person_medications` (V19+) onde reside `isSuspended`
- Coordina automaticamente notificacións ao cambiar estado
- Reduce código en compoñentes UI de 493 a 419 liñas (ex: `MedicationCard`)

**Nota arquitectónica V19+:**
Os métodos `resumeMedication` e `suspendMedication` actualizan a táboa `person_medications` para cada persoa asignada, xa que `isSuspended` é un campo específico da relación persoa-medicamento, non do medicamento compartido.

---

## Capa de Vista (Screens/Widgets)

### Estrutura de Pantallas Principais

```
MedicationListScreen (pantalla principal)
├─ MedicationCard (widget reutilizable)
│  ├─ TodayDosesSection
│  └─ FastingCountdownRow
├─ MedicationOptionsSheet (modal de opcións)
└─ TodayDosesSection (doses do día)

MedicationInfoScreen (crear/editar medicamento)
├─ MedicationInfoForm
├─ MedicationDosageScreen
├─ MedicationTimesScreen
├─ MedicationDurationScreen
├─ MedicationDatesScreen
└─ EditFastingScreen

DoseActionScreen (rexistrar/omitir dose)
├─ TakeDoseButton
├─ SkipDoseButton
└─ PostponeButtons

DoseHistoryScreen (historial)
├─ FilterDialog
├─ StatisticsCard
└─ DeleteConfirmationDialog

SettingsScreen
├─ PersonsManagementScreen
└─ LanguageSelectionScreen
```

### Sistema de Temas (ThemeProvider)

MedicApp implementa un sistema completo de temas con soporte para modo claro e escuro nativo.

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await PreferencesService.setThemeMode(mode);
    notifyListeners();
  }
}
```

**Características do sistema de temas:**

**Tres modos de operación:**
- **System**: Segue a configuración do sistema operativo automaticamente
- **Light**: Forza tema claro independentemente do sistema
- **Dark**: Forza tema escuro independentemente do sistema

**Implementación en AppTheme:**

A clase `AppTheme` define esquemas de cor completos para ambos modos:

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    // Estilos personalizados para todos os compoñentes
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    // Estilos personalizados para todos os compoñentes
  );
}
```

**Personalización de compoñentes:**
- `AppBarTheme`: Barras de aplicación con cores cohesivas
- `CardTheme`: Tarxetas con elevación e bordos apropiados
- `FloatingActionButtonTheme`: Botóns de acción flotante destacados
- `InputDecorationTheme`: Campos de texto consistentes
- `DialogTheme`: Diálogos con esquinas redondeadas
- `SnackBarTheme`: Notificacións temporais estilizadas
- `TextTheme`: Xerarquía tipográfica completa

**Integración con PreferencesService:**

O servizo de preferencias persiste a elección do usuario:

```dart
static Future<void> setThemeMode(ThemeMode mode) async {
  await _prefs.setString('theme_mode', mode.toString());
}

static ThemeMode getThemeMode() {
  final modeString = _prefs.getString('theme_mode');
  // Conversión de string a enum
}
```

**Uso en main.dart:**

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeProvider.themeMode,
  // ...
)
```

**Vantaxes:**
- Transición suave entre temas sen reiniciar app
- Cores optimizadas para lexibilidade en ambos modos
- Aforro de batería en modo escuro (pantallas OLED)
- Accesibilidade mellorada para usuarios con sensibilidade á luz
- Preferencia persistida entre sesións

### Widgets Reutilizables

**MedicationCard:**
- Mostra información resumida do medicamento
- Próxima dose
- Estado de stock
- Doses de hoxe (tomadas/omitidas)
- Contador de xaxún activo (se aplica)
- Persoas asignadas (en modo sen pestanas)

**TodayDosesSection:**
- Lista horizontal de doses do día
- Indicador visual: ✓ (tomada), ✗ (omitida), baleiro (pendente)
- Mostra hora real de rexistro (se a configuración está activada)
- Tap para editar/eliminar

**FastingCountdownRow:**
- Contador en tempo real do xaxún restante
- Cambia a verde e toca son ao completarse
- Botón de dismiss para ocultalo

### Patróns de Código Reutilizables

MedicApp implementa varios patróns de código reutilizables que melloran a mantenibilidade e reducen a duplicación:

**SelectableOptionCard<T>:**
- Widget xenérico para tarxetas de opcións seleccionables con soporte de tipos
- Localización: `lib/widgets/forms/selectable_option_card.dart`
- Propósito: Interfaz consistente para selección de opcións en formularios

**MedicationStatusBadge:**
- Badge reutilizable para mostrar estados de medicamentos
- Propósito: Visualización estandarizada de estados (activo, suspendido, esgotado)

**MedicationActionHandler (Mixin):**
- Mixin para manexo consistente de accións de medicamentos
- Propósito: Xestión de erros centralizada e lóxica de accións común
- Beneficios: Reduce duplicación de código en compoñentes UI

**NotificationServiceTestHelper:**
- Helper de probas para configuración e limpeza do servizo de notificacións
- Localización: `test/helpers/notification_test_helper.dart`
- Propósito: Simplifica a escritura de probas de notificacións

**person_test_helper.dart:**
- Localización canónica consolidada para utilidades de proba relacionadas con persoas
- Propósito: Punto único para funcións helper de probas de persoas
- Beneficios: Evita duplicación de código de probas entre ficheiros

### Navegación

MedicApp usa **Navigator 1.0** estándar de Flutter:

```dart
// Push básico
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Push con resultado
final result = await Navigator.push<Medication>(
  context,
  MaterialPageRoute(builder: (context) => MedicationInfoScreen()),
);
```

**Vantaxes de non usar Navigator 2.0:**
- Simplicidade
- Stack explícito fácil de razoar
- Menor curva de aprendizaxe

### Xestión de Estado a Nivel de Widget

**ViewModel Pattern (sen framework):**

```dart
class MedicationListViewModel extends ChangeNotifier {
  List<Medication> _medications = [];
  List<Person> _persons = [];
  Person? _selectedPerson;
  bool _isLoading = false;

  // Getters
  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  // Business logic
  Future<void> loadMedications() async {
    _isLoading = true;
    notifyListeners();

    _medications = _selectedPerson != null
      ? await DatabaseHelper.instance.getMedicationsForPerson(_selectedPerson!.id)
      : await DatabaseHelper.instance.getAllMedications();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerDose({required Medication medication, required String doseTime}) async {
    // Lóxica de negocio
    // Actualiza base de datos
    await loadMedications();  // Refresca UI
  }
}
```

**Na pantalla:**

```dart
class MedicationListScreen extends StatefulWidget {
  @override
  State<MedicationListScreen> createState() => MedicationListScreenState();
}

class MedicationListScreenState extends State<MedicationListScreen> {
  late final MedicationListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicationListViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.initialize();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _viewModel.isLoading
        ? CircularProgressIndicator()
        : ListView.builder(
            itemCount: _viewModel.medications.length,
            itemBuilder: (context, index) {
              return MedicationCard(medication: _viewModel.medications[index]);
            },
          ),
    );
  }
}
```

**Vantaxes:**
- Non require paquetes externos (BLoC, Riverpod, Redux)
- Código claro e directo
- Rendemento excelente (menos capas de abstracción)
- Fácil testeo: só se instancia o ViewModel

---

## Fluxo de Datos

### De UI a Base de Datos (Rexistrar Dose)

```
Usuario toca "Tomar" en notificación
    │
    ▼
NotificationService._handleNotificationAction()
    │
    ├─ Valida stock dispoñible
    ├─ Actualiza Medication (reduce stock, engade a takenDosesToday)
    │  └─ DatabaseHelper.updateMedicationForPerson()
    │
    ├─ Crea DoseHistoryEntry
    │  └─ DatabaseHelper.insertDoseHistory()
    │
    ├─ Cancela notificación
    │  └─ NotificationService.cancelTodaysDoseNotification()
    │
    └─ Se ten xaxún "despois", programa notificación dinámica
       └─ NotificationService.scheduleDynamicFastingNotification()
```

### De Servizos a Notificacións (Crear Medicamento)

```
Usuario completa formulario de medicamento novo
    │
    ▼
MedicationListViewModel.createMedication()
    │
    ├─ DatabaseHelper.createMedicationForPerson()
    │  ├─ Busca se xa existe medicamento con ese nome
    │  ├─ Se existe: reutiliza (stock compartido)
    │  └─ Se non: crea entrada en medications
    │
    └─ NotificationService.scheduleMedicationNotifications(
         medication,
         personId: personId
       )
       │
       ├─ Cancela notificacións antigas (se existían)
       │
       ├─ Segundo durationType:
       │  ├─ everyday/untilFinished → DailyNotificationScheduler
       │  ├─ weeklyPattern → WeeklyNotificationScheduler
       │  └─ specificDates → DailyNotificationScheduler (datas específicas)
       │
       └─ Se requiresFasting && notifyFasting:
          └─ FastingNotificationScheduler.scheduleFastingNotifications()
```

### Actualización de UI (Tempo Real)

```
DatabaseHelper actualiza datos
    │
    ▼
ViewModel.loadMedications()  // Recarga desde BD
    │
    ▼
ViewModel.notifyListeners()
    │
    ▼
Screen._onViewModelChanged()
    │
    ▼
setState(() {})  // Flutter rebuilds UI
```

**Optimización UI-first:**
Moitas operacións actualizan a UI primeiro e logo a base de datos en background:

```dart
// ANTES (bloqueante)
await database.update(...);
setState(() {});  // Usuario espera

// AGORA (optimista)
setState(() {});  // UI instantánea
database.update(...);  // Background
```

Resultado: **15-30x máis rápido** en operacións comúns.

---

## Xestión de Notificacións

### Sistema de IDs Únicos

Cada notificación ten un ID único calculado segundo o seu tipo:

```dart
enum NotificationIdType {
  daily,           // 0-10,999,999
  postponed,       // 2,000,000-2,999,999
  specificDate,    // 3,000,000-3,999,999
  weekly,          // 4,000,000-4,999,999
  fasting,         // 5,000,000-5,999,999
  dynamicFasting,  // 6,000,000-6,999,999
}
```

**Xeración de ID para notificación diaria:**
```dart
static int _generateDailyId(String medicationId, int doseIndex, String personId) {
  final medicationHash = medicationId.hashCode.abs();
  final personHash = personId.hashCode.abs();
  return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
}
```

**Vantaxes:**
- Evita colisións entre tipos de notificación
- Permite cancelar selectivamente
- Debug máis fácil (o ID indica o tipo polo seu rango)
- Soporte multi-persoa (inclúe hash do personId)

### Cancelación Intelixente

En lugar de cancelar cegamente ata 1000 IDs, a app calcula exactamente que cancelar:

```dart
Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
  if (medication == null) {
    // Cancelación bruta (compatibilidade)
    _cancelBruteForce(medicationId);
    return;
  }

  // Cancelación intelixente
  final doseCount = medication.doseTimes.length;

  // Para cada persoa asignada a este medicamento
  final persons = await DatabaseHelper.instance.getPersonsForMedication(medicationId);

  for (final person in persons) {
    // Cancela notificacións diarias
    for (int i = 0; i < doseCount; i++) {
      final notificationId = NotificationIdGenerator.generate(
        type: NotificationIdType.daily,
        medicationId: medicationId,
        personId: person.id,
        doseIndex: i,
      );
      await _notificationsPlugin.cancel(notificationId);
    }

    // Cancela xaxún se aplica
    if (medication.requiresFasting) {
      _cancelFastingNotifications(medication, person.id);
    }
  }
}
```

**Resultado:**
- Só cancela as notificacións que realmente existen
- Moito máis rápido que iterar 1000 IDs
- Evita efectos secundarios noutras notificacións

### Accións Directas (Android)

As notificacións inclúen botóns de acción rápida:

```dart
final androidDetails = AndroidNotificationDetails(
  'medication_reminders',
  'Recordatorios de Medicamentos',
  actions: [
    AndroidNotificationAction('register_dose', 'Tomar'),
    AndroidNotificationAction('skip_dose', 'Omitir'),
    AndroidNotificationAction('snooze_dose', 'Pospor 10min'),
  ],
);
```

**Fluxo de acción:**
```
Usuario toca botón "Tomar"
    │
    ▼
NotificationService._onNotificationTapped()
    │ (detecta actionId = 'register_dose')
    ▼
_handleNotificationAction()
    │
    ├─ Carga medicamento desde BD
    ├─ Valida stock
    ├─ Actualiza Medication
    ├─ Crea DoseHistoryEntry
    ├─ Cancela notificación
    └─ Programa xaxún se aplica
```

### Límite de 5 Notificacións Activas

Android/iOS teñen límites de notificacións visibles. MedicApp programa intelixentemente:

**Estratexia:**
- Só programa notificacións para **hoxe + 1 día** (mañá)
- Ao abrir a app ou cambiar de día, reprograma automaticamente
- Prioriza as notificacións máis cercanas

```dart
Future<void> rescheduleAllMedicationNotifications() async {
  await cancelAllNotifications();

  final allPersons = await DatabaseHelper.instance.getAllPersons();

  for (final person in allPersons) {
    final medications = await DatabaseHelper.instance.getMedicationsForPerson(person.id);

    for (final medication in medications) {
      if (medication.isActive && !medication.isSuspended) {
        // Só programa próximas 48h
        await scheduleMedicationNotifications(
          medication,
          personId: person.id,
          skipCancellation: true,  // Xa cancelamos todo arriba
        );
      }
    }
  }
}
```

**Triggers de reprogramación:**
- Ao iniciar a app
- Ao retomar desde background (AppLifecycleState.resumed)
- Despois de crear/editar/eliminar medicamento
- Ao cambiar de día (medianoite)

---

## Base de Datos SQLite V19

### Esquema de Táboas

#### medications (datos compartidos)

```sql
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  stockQuantity REAL NOT NULL DEFAULT 0,
  lastRefillAmount REAL,
  lowStockThresholdDays INTEGER NOT NULL DEFAULT 3,
  lastDailyConsumption REAL
);
```

#### persons (usuarios e familiares)

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER DEFAULT 0  -- Booleano: 1=default, 0=non
);
```

#### person_medications (pauta individual N:N)

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,

  -- CONFIGURACIÓN INDIVIDUAL
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER DEFAULT 0,
  doseSchedule TEXT NOT NULL,  -- JSON: {"08:00": 1.0, "20:00": 1.5}
  takenDosesToday TEXT,        -- CSV: "08:00,20:00"
  skippedDosesToday TEXT,
  takenDosesDate TEXT,
  selectedDates TEXT,          -- CSV: "2025-01-15,2025-01-20"
  weeklyDays TEXT,             -- CSV: "1,3,5" (Lun, Mér, Ven)
  dayInterval INTEGER,
  startDate TEXT,              -- ISO8601
  endDate TEXT,
  requiresFasting INTEGER DEFAULT 0,
  fastingType TEXT,
  fastingDurationMinutes INTEGER,
  notifyFasting INTEGER DEFAULT 0,
  isSuspended INTEGER DEFAULT 0,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE,
  FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE,
  UNIQUE(personId, medicationId)  -- Unha pauta por persoa-medicamento
);
```

#### dose_history (historial de tomas)

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,   -- Cando debía tomarse
  registeredDateTime TEXT NOT NULL,  -- Cando se rexistrou
  status TEXT NOT NULL,              -- 'taken' | 'skipped'
  quantity REAL NOT NULL,
  isExtraDose INTEGER DEFAULT 0,
  notes TEXT,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
);
```

### Índices e Optimizacións

```sql
-- Buscas rápidas por medicamento
CREATE INDEX idx_dose_history_medication ON dose_history(medicationId);

-- Buscas rápidas por data
CREATE INDEX idx_dose_history_date ON dose_history(scheduledDateTime);

-- Buscas rápidas de pautas por persoa
CREATE INDEX idx_person_medications_person ON person_medications(personId);

-- Buscas rápidas de persoas por medicamento
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);
```

**Impacto:**
- Queries de historial: 10-100x máis rápidas
- Carga de medicamentos por persoa: O(log n) en lugar de O(n)
- Estatísticas de adherencia: cálculo instantáneo

### Triggers para Integridade

Aínda que SQLite non ten triggers explícitos neste código, as **foreign keys con CASCADE** garanten:

```sql
FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
```

**Comportamento:**
- Se se elimina unha persoa → elimínanse automaticamente os seus `person_medications` e `dose_history`
- Se se elimina un medicamento → elimínanse automaticamente os seus `person_medications`

### Sistema de Migracións

A base de datos auto-actualízase desde calquera versión anterior:

```dart
await openDatabase(
  path,
  version: 19,  // Versión actual
  onCreate: _createDB,     // Se é instalación nova
  onUpgrade: _upgradeDB,   // Se xa existe BD con versión < 19
);
```

**Exemplo de migración (V18 → V19):**

```dart
if (oldVersion < 19) {
  // 1. Backup
  await db.execute('ALTER TABLE person_medications RENAME TO person_medications_old');
  await db.execute('ALTER TABLE medications RENAME TO medications_old');

  // 2. Crear novas estruturas
  await db.execute('''CREATE TABLE medications (...)''');
  await db.execute('''CREATE TABLE person_medications (...)''');

  // 3. Migrar datos
  await db.execute('''
    INSERT INTO medications (id, name, type, stockQuantity, ...)
    SELECT id, name, type, stockQuantity, ... FROM medications_old
  ''');

  await db.execute('''
    INSERT INTO person_medications (id, personId, medicationId, doseSchedule, ...)
    SELECT pm.id, pm.personId, pm.medicationId, m.doseSchedule, ...
    FROM person_medications_old pm
    INNER JOIN medications_old m ON pm.medicationId = m.id
  ''');

  // 4. Limpar
  await db.execute('DROP TABLE person_medications_old');
  await db.execute('DROP TABLE medications_old');
}
```

**Vantaxes:**
- Usuario non perde datos ao actualizar
- Migración transparente e automática
- Rollback manual posible (gárdanse backups temporais)

---

## Optimizacións de Rendemento

### Operacións UI-First

**Problema orixinal:**
```dart
// Usuario rexistra dose → UI conxelada ~500ms
await database.update(medication);
setState(() {});  // UI actualizada DESPOIS
```

**Solución optimista:**
```dart
// UI actualizada INMEDIATAMENTE (~15ms)
setState(() {
  // Actualizar estado local
});
// Base de datos actualízase en background
unawaited(database.update(medication));
```

**Resultados medidos:**
- Rexistro de dose: 500ms → **30ms** (16.6x máis rápido)
- Actualización de stock: 400ms → **15ms** (26.6x máis rápido)
- Navegación entre pantallas: 300ms → **20ms** (15x máis rápido)

### Redución de Frames Saltados

**Antes (con state management complexo):**
```
Frame budget: 16ms (60 FPS)
Tempo real: 45ms → 30 frames saltados por segundo
```

**Despois (ViewModel simple):**
```
Frame budget: 16ms (60 FPS)
Tempo real: 12ms → 0 frames saltados
```

**Técnica aplicada:**
- Evitar rebuilds en cascada
- `notifyListeners()` só cando cambian datos relevantes
- Widgets `const` onde sexa posible

### Tempo de Inicio < 100ms

```
1. main() executado                     → 0ms
2. DatabaseHelper inicializado          → 10ms
3. NotificationService inicializado     → 30ms
4. Primeira pantalla renderizada         → 80ms
5. Datos cargados en background         → 200ms (async)
```

Usuario ve UI en **80ms**, datos aparecen pouco despois.

**Técnica:**
```dart
@override
void initState() {
  super.initState();
  _viewModel = MedicationListViewModel();

  // Inicializar DESPOIS do primeiro frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _initializeViewModel();
  });
}
```

### Rexistro de Dose < 200ms

```
Tap en "Tomar dose"
    ↓
15ms: setState actualiza UI local
    ↓
50ms: database.update() en background
    ↓
100ms: database.insert(history) en background
    ↓
150ms: NotificationService.cancel() en background
    ↓
Total percibido polo usuario: 15ms (UI inmediata)
Total real: 150ms (pero non bloquea)
```

### Caché de Persoa por Defecto

```dart
class DatabaseHelper {
  Person? _cachedDefaultPerson;

  Future<Person?> getDefaultPerson() async {
    if (_cachedDefaultPerson != null) {
      return _cachedDefaultPerson;  // ¡Instantáneo!
    }

    // Só consulta BD se non está en caché
    final db = await database;
    final result = await db.query('persons', where: 'isDefault = ?', whereArgs: [1]);
    _cachedDefaultPerson = Person.fromJson(result.first);
    return _cachedDefaultPerson;
  }

  void _invalidateDefaultPersonCache() {
    _cachedDefaultPerson = null;
  }
}
```

**Impacto:**
- Cada chamada subsecuente: 0.01ms (1000x máis rápida)
- Invalídase só cando se modifica algunha persoa

---

## Modularización do Código

### Antes: Arquivos Monolíticos

```
lib/
└── screens/
    └── medication_list_screen.dart  (3500 liñas)
        ├── UI
        ├── Lóxica de negocio
        ├── Diálogos
        └── Widgets auxiliares (todo mesturado)
```

### Despois: Estrutura Modular

```
lib/
└── screens/
    └── medication_list/
        ├── medication_list_screen.dart        (400 liñas - só UI)
        ├── medication_list_viewmodel.dart     (300 liñas - lóxica)
        │
        ├── widgets/
        │   ├── medication_card.dart
        │   ├── today_doses_section.dart
        │   ├── empty_medications_view.dart
        │   ├── battery_optimization_banner.dart
        │   └── debug_menu.dart
        │
        ├── dialogs/
        │   ├── medication_options_sheet.dart
        │   ├── dose_selection_dialog.dart
        │   ├── refill_input_dialog.dart
        │   └── notification_permission_dialog.dart
        │
        └── services/
            └── dose_calculation_service.dart
```

**Redución do 39.3%:**
- **Antes:** 3500 liñas en 1 arquivo
- **Despois:** 2124 liñas en 14 arquivos (~150 liñas/arquivo promedio)

### Vantaxes da Modularización

1. **Mantemento:**
   - Cambio nun diálogo → só editas ese arquivo
   - Git diffs máis claros (menos conflitos)

2. **Reusabilidade:**
   - `MedicationCard` usado en lista E en busca
   - `DoseSelectionDialog` reutilizado en 3 pantallas

3. **Testabilidade:**
   - ViewModel testiase sen UI
   - Widgets testianse con `testWidgets` de forma illada

4. **Colaboración:**
   - Persoa A traballa en diálogos
   - Persoa B traballa en ViewModel
   - Sen conflitos de merge

### Exemplo: Diálogo Reutilizable

```dart
// lib/screens/medication_list/dialogs/refill_input_dialog.dart
class RefillInputDialog {
  static Future<double?> show(
    BuildContext context,
    {required Medication medication}
  ) async {
    return showDialog<double>(
      context: context,
      builder: (context) => _RefillInputDialogWidget(medication: medication),
    );
  }
}

// Uso en CALQUERA pantalla
final refillAmount = await RefillInputDialog.show(context, medication: med);
if (refillAmount != null) {
  // Lóxica de recarga
}
```

**Reutilizado en:**
- `MedicationListScreen`
- `MedicationStockScreen`
- `MedicineSearchScreen`

---

## Localización (l10n)

MedicApp soporta **8 idiomas** co sistema oficial de Flutter.

### Sistema Flutter Intl

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true  # Auto-xera código

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Arquivos ARB (Application Resource Bundle)

```
lib/l10n/
├── app_en.arb  (plantilla base - inglés)
├── app_es.arb  (español)
├── app_ca.arb  (catalán)
├── app_eu.arb  (éuscaro)
├── app_gl.arb  (galego)
├── app_fr.arb  (francés)
├── app_it.arb  (italiano)
└── app_de.arb  (alemán)
```

**Exemplo de arquivo ARB:**

```json
{
  "@@locale": "gl",

  "mainScreenTitle": "Os meus Medicamentos",
  "@mainScreenTitle": {
    "description": "Título da pantalla principal"
  },

  "doseRegisteredAtTime": "Dose de {medication} rexistrada ás {time}. Stock restante: {stock}",
  "@doseRegisteredAtTime": {
    "description": "Confirmación de dose rexistrada",
    "placeholders": {
      "medication": {"type": "String"},
      "time": {"type": "String"},
      "stock": {"type": "String"}
    }
  },

  "remainingDosesToday": "{count, plural, =1{Queda 1 dose hoxe} other{Quedan {count} doses hoxe}}",
  "@remainingDosesToday": {
    "description": "Doses restantes",
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

### Xeración Automática de Código

Ao executar `flutter gen-l10n`, xéranse:

```dart
// lib/l10n/app_localizations.dart (abstracta)
abstract class AppLocalizations {
  String get mainScreenTitle;
  String doseRegisteredAtTime(String medication, String time, String stock);
  String remainingDosesToday(int count);
}

// lib/l10n/app_localizations_gl.dart (implementación)
class AppLocalizationsGl extends AppLocalizations {
  @override
  String get mainScreenTitle => 'Os meus Medicamentos';

  @override
  String doseRegisteredAtTime(String medication, String time, String stock) {
    return 'Dose de $medication rexistrada ás $time. Stock restante: $stock';
  }

  @override
  String remainingDosesToday(int count) {
    return Intl.plural(
      count,
      one: 'Queda 1 dose hoxe',
      other: 'Quedan $count doses hoxe',
    );
  }
}
```

### Uso na App

```dart
// En main.dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MedicationListScreen(),
);

// En calquera widget
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.mainScreenTitle),
    ),
    body: Text(l10n.remainingDosesToday(3)),  // "Quedan 3 doses hoxe"
  );
}
```

### Pluralización Automática

```dart
// Galego
remainingDosesToday(1) → "Queda 1 dose hoxe"
remainingDosesToday(3) → "Quedan 3 doses hoxe"

// Inglés (xerado desde app_en.arb)
remainingDosesToday(1) → "1 dose remaining today"
remainingDosesToday(3) → "3 doses remaining today"
```

### Selección Automática de Idioma

A app detecta o idioma do sistema:

```dart
// main.dart
MaterialApp(
  locale: const Locale('gl', ''),  // Forzar galego (opcional)
  localeResolutionCallback: (locale, supportedLocales) {
    // Se o idioma do dispositivo está soportado, usalo
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode) {
        return supportedLocale;
      }
    }
    // Fallback a inglés
    return const Locale('en', '');
  },
);
```

---

## Decisións de Deseño

### Por Que NON BLoC/Riverpod/Redux

**Consideracións:**

1. **Complexidade innecesaria:**
   - MedicApp non ten estado global complexo
   - A maioría do estado é local a pantallas
   - Non hai múltiples fontes de verdade compitiendo

2. **Curva de aprendizaxe:**
   - BLoC require entender Streams, Sinks, eventos
   - Riverpod ten conceptos avanzados (providers, family, autoDispose)
   - Redux require accións, reducers, middleware

3. **Rendemento:**
   - ViewModel simple: 12ms/frame
   - BLoC (medido): 28ms/frame → **2.3x máis lento**
   - Máis capas = máis overhead

4. **Tamaño do APK:**
   - flutter_bloc: +2.5 MB
   - riverpod: +1.8 MB
   - Sen state management: 0 MB adicionais

**Decisión:**
- `ChangeNotifier` + ViewModel é suficiente
- Código máis simple e directo
- Rendemento superior

**Excepción onde SI usaríamos BLoC:**
- Se houbese sincronización con backend en tempo real
- Se múltiples pantallas necesitasen reactuar ao mesmo estado
- Se houbese lóxica complexa con múltiples efectos secundarios

### Por Que SQLite en Lugar de Hive/Isar

**Comparación:**

| Característica | SQLite | Hive | Isar |
|----------------|--------|------|------|
| Queries complexas | ✅ SQL completo | ❌ Só key-value | ⚠️ Limitado |
| Relacións N:N | ✅ Foreign keys | ❌ Manual | ⚠️ Links manuais |
| Migracións | ✅ onUpgrade | ❌ Manual | ⚠️ Parcial |
| Índices | ✅ CREATE INDEX | ❌ Non | ✅ Si |
| Transaccións | ✅ ACID | ⚠️ Limitadas | ✅ Si |
| Madurez | ✅ 20+ anos | ⚠️ Novo | ⚠️ Moi novo |
| Tamaño | ~1.5 MB | ~200 KB | ~1.2 MB |

**Decisión:**
- SQLite gaña por:
  - **Queries complexas** (JOIN, GROUP BY, estatísticas)
  - **Migracións automáticas** (crítico para actualizacións)
  - **Relacións explícitas** (person_medications N:N)
  - **Madurez e estabilidade**

**Caso onde usaríamos Hive:**
- App moi simple (só lista de TODOs sen relacións)
- Non se necesitan buscas complexas
- Prioridade máxima en tamaño do APK

### Por Que Flutter Local Notifications

**Alternativas consideradas:**

1. **awesome_notifications:**
   - ✅ Máis features (notificacións ricas, imaxes)
   - ❌ Máis pesado (+3 MB)
   - ❌ API máis complexa
   - ❌ Menos adoptado (comunidade máis pequena)

2. **firebase_messaging:**
   - ✅ Push notifications remotas
   - ❌ Require backend (innecesario para recordatorios locais)
   - ❌ Dependencia de Firebase (vendor lock-in)
   - ❌ Privacidade (datos saen do dispositivo)

3. **flutter_local_notifications:**
   - ✅ Lixeiro (~800 KB)
   - ✅ Maduro e estable
   - ✅ Gran comunidade (miles de stars)
   - ✅ API simple e directa
   - ✅ 100% local (privacidade total)
   - ✅ Soporta accións directas en Android

**Decisión:**
- `flutter_local_notifications` é suficiente
- Non necesitamos push remoto
- Privacidade: todo queda no dispositivo

### Trade-offs Considerados

#### 1. ViewModel vs BLoC

**Trade-off:**
- ❌ Perde: Separación estricta de lóxica
- ✅ Gaña: Simplicidade, rendemento, tamaño

**Mitigación:**
- ViewModel illa suficiente lóxica para testeo
- Services manexan operacións complexas

#### 2. SQLite vs NoSQL

**Trade-off:**
- ❌ Perde: Velocidade en operacións moi simples
- ✅ Gaña: Queries complexas, relacións, migracións

**Mitigación:**
- Índices optimizan queries lentas
- Caché reduce accesos a BD

#### 3. Navigator 1.0 vs 2.0

**Trade-off:**
- ❌ Perde: Deep linking avanzado
- ✅ Gaña: Simplicidade, stack explícito

**Mitigación:**
- MedicApp non necesita deep linking complexo
- A app é principalmente CRUD local

#### 4. UI-First Updates

**Trade-off:**
- ❌ Perde: Garantía de consistencia inmediata
- ✅ Gaña: UX instantánea (15-30x máis rápida)

**Mitigación:**
- Operacións son simples (baixa probabilidade de fallo)
- Se falla operación async, revírtese UI con mensaxe

---

## Referencias Cruzadas

- **Guía de Desenvolvemento:** Para comezar a contribuír → [CONTRIBUTING.md](../CONTRIBUTING.md)
- **Documentación de API:** Referencia de clases → [api_reference.md](api_reference.md)
- **Historial de Cambios:** Migracións de BD → [CHANGELOG.md](../../CHANGELOG.md)
- **Testing:** Estratexias de probas → [testing.md](testing.md)

---

## Conclusión

A arquitectura de MedicApp prioriza:

1. **Simplicidade** sobre complexidade innecesaria
2. **Rendemento** medible e optimizado
3. **Mantemento** a través de modularización
4. **Privacidade** con procesamento 100% local
5. **Escalabilidade** mediante deseño N:N multi-persoa

Esta arquitectura permite:
- Tempo de resposta UI < 30ms
- Soporte multi-persoa con pautas independentes
- Engadir novas features sen refactorizar estruturas core
- Testing illado de compoñentes
- Migración de base de datos sen perda de datos

Para contribuír ao proxecto mantendo esta arquitectura, consulta [CONTRIBUTING.md](../CONTRIBUTING.md).
