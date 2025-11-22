# Architettura di MedicApp

## Sommario

1. [Visione Generale dell'Architettura](#visione-generale-dellarchitettura)
2. [Architettura Multi-Persona V19+](#architettura-multi-persona-v19)
3. [Livello dei Modelli (Models)](#livello-dei-modelli-models)
4. [Livello dei Servizi (Services)](#livello-dei-servizi-services)
5. [Livello delle Viste (Screens/Widgets)](#livello-delle-viste-screenswidgets)
6. [Flusso di Dati](#flusso-di-dati)
7. [Gestione delle Notifiche](#gestione-delle-notifiche)
8. [Database SQLite V19](#database-sqlite-v19)
9. [Ottimizzazioni delle Prestazioni](#ottimizzazioni-delle-prestazioni)
10. [Modularizzazione del Codice](#modularizzazione-del-codice)
11. [Localizzazione (l10n)](#localizzazione-l10n)
12. [Decisioni di Design](#decisioni-di-design)

---

## Visione Generale dell'Architettura

MedicApp utilizza un **pattern Model-View-Service (MVS)** semplificato, senza dipendenze da framework complessi di state management come BLoC, Riverpod o Redux.

### Giustificazione

La decisione di non usare state management complesso si basa su:

1. **Semplicità**: L'applicazione gestisce lo stato principalmente a livello di schermata/widget
2. **Prestazioni**: Meno livelli di astrazione = risposte più rapide
3. **Manutenibilità**: Codice più diretto e facile da comprendere
4. **Dimensione**: Meno dipendenze = APK più leggero

### Diagramma dei Livelli

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

## Architettura Multi-Persona V19+

A partire dalla versione 19, MedicApp implementa un **modello di dati N:N (molti-a-molti)** che permette a più persone di condividere lo stesso farmaco mantenendo configurazioni individuali.

### Modello di Dati N:N

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│   persons   │         │person_medications│         │ medications │
├─────────────┤         ├──────────────────┤         ├─────────────┤
│ id          │◄────────│ personId         │         │ id          │
│ name        │         │ medicationId     │────────►│ name        │
│ isDefault   │         │ assignedDate     │         │ type        │
└─────────────┘         │                  │         │ stockQuantity│
                        │ PAUTA INDIVIDUALE│         │ lastRefill  │
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

### Separazione delle Responsabilità

| Tabella | Responsabilità | Esempi |
|-------|----------------|----------|
| **medications** | Dati CONDIVISI tra persone | nome, tipo, scorta fisica |
| **person_medications** | Configurazione INDIVIDUALE di ogni persona | orari, durata, stato di sospensione |
| **dose_history** | Cronologia delle assunzioni per persona | registro con personId |

### Esempi di Casi d'Uso

#### Esempio 1: Paracetamolo Condiviso

```
Farmaco: Paracetamolo 500mg
├─ Scorta condivisa: 50 pillole
├─ Persona: Juan (utente predefinito)
│  └─ Pauta: 08:00, 16:00, 00:00 (3 volte al giorno)
└─ Persona: Maria (familiare)
   └─ Pauta: 12:00 (1 volta al giorno, solo secondo necessità)
```

Nel database:
- **1 voce** in `medications` (scorta condivisa)
- **2 voci** in `person_medications` (paute diverse)

#### Esempio 2: Farmaci Diversi

```
Juan:
├─ Omeprazolo 20mg → 08:00
└─ Atorvastatina 40mg → 22:00

Maria:
└─ Levotiroxina 100mcg → 07:00
```

Nel database:
- **3 voci** in `medications`
- **3 voci** in `person_medications` (una per farmaco-persona)

### Migrazione Automatica V16→V19

Il database migra automaticamente da architetture vecchie:

```dart
// V18: medications conteneva TUTTO (scorta + pauta)
medications (id, name, type, stock, doseSchedule, durationType, ...)

// V19: SEPARAZIONE
medications (id, name, type, stock)  // SOLO dati condivisi
person_medications (personId, medicationId, doseSchedule, durationType, ...)
```

**Processo di migrazione:**
1. Backup di tabelle vecchie (`medications_old`, `person_medications_old`)
2. Creazione di nuove strutture
3. Copia di dati condivisi a `medications`
4. Copia di paute individuali a `person_medications`
5. Ricreazione di indici
6. Eliminazione di backup

---

## Livello dei Modelli (Models)

### Person

Rappresenta una persona (utente o familiare).

```dart
class Person {
  final String id;
  final String name;
  final bool isDefault;  // Utente principale
}
```

**Responsabilità:**
- Identificazione unica
- Nome da mostrare nell'UI
- Indicatore di persona predefinita (riceve notifiche senza prefisso del nome)

### Medication

Rappresenta il **farmaco fisico** con la sua scorta condivisa.

```dart
class Medication {
  // DATI CONDIVISI (nella tabella medications)
  final String id;
  final String name;
  final MedicationType type;
  final double stockQuantity;
  final double? lastRefillAmount;
  final int lowStockThresholdDays;
  final double? lastDailyConsumption;

  // DATI INDIVIDUALI (da person_medications, si fondono nella consultazione)
  final TreatmentDurationType durationType;
  final Map<String, double> doseSchedule;
  final List<String> takenDosesToday;
  final List<String> skippedDosesToday;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool requiresFasting;
  final bool isSuspended;
  // ... più campi di configurazione individuale
}
```

**Metodi importanti:**
- `shouldTakeToday()`: Logica di frequenza (giornaliera, settimanale, intervallo, date specifiche)
- `isActive`: Verifica se il trattamento è in periodo attivo
- `isStockLow`: Calcola se la scorta è bassa secondo consumo giornaliero
- `getAvailableDosesToday()`: Filtra dosi non assunte/omesse

### PersonMedication

Tabella intermedia N:N con la **pauta individuale** di ogni persona.

```dart
class PersonMedication {
  final String id;
  final String personId;
  final String medicationId;
  final String assignedDate;

  // PAUTA INDIVIDUALE
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

Registro storico di ogni assunzione/omissione.

```dart
class DoseHistoryEntry {
  final String id;
  final String medicationId;
  final String personId;  // V19+: Tracciamento per persona
  final DateTime scheduledDateTime;  // Ora programmata
  final DateTime registeredDateTime; // Ora reale di registrazione
  final DoseStatus status;  // taken | skipped
  final double quantity;
  final bool isExtraDose;  // Dose fuori orario
  final String? notes;
}
```

**Funzionalità:**
- Audit di aderenza
- Calcolo di statistiche
- Permette modifica del tempo di registrazione
- Distingue tra dosi programmate ed extra

### Relazioni Tra Modelli

```
Person (1) ──── (N) PersonMedication (N) ──── (1) Medication
   │                      │                         │
   │                      │                         │
   │                      ▼                         │
   └──────────────► DoseHistoryEntry ◄─────────────┘
```

---

## Livello dei Servizi (Services)

### DatabaseHelper (Singleton)

Gestisce TUTTE le operazioni di SQLite.

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // CRUD Medications (solo dati condivisi)
  Future<int> insertMedication(Medication medication);
  Future<Medication?> getMedication(String id);
  Future<List<Medication>> getAllMedications();
  Future<int> updateMedication(Medication medication);

  // V19+: CRUD con persone
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

**Caratteristiche chiave:**
- Singleton per evitare connessioni multiple
- Migrazioni automatiche fino alla V19
- Cache di persona predefinita per ottimizzare query
- Metodi di esportazione/importazione del database

### NotificationService (Singleton)

Gestisce TUTTE le notifiche del sistema.

```dart
class NotificationService {
  static final NotificationService instance = NotificationService._init();

  // Inizializzazione
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> canScheduleExactAlarms();

  // Programmazione V19+ (richiede personId)
  Future<void> scheduleMedicationNotifications(
    Medication medication,
    {required String personId, bool excludeToday = false}
  );

  // Cancellazione intelligente
  Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication});
  Future<void> cancelTodaysDoseNotification({
    required Medication medication,
    required String doseTime,
    required String personId,
  });

  // Posticipare dose
  Future<void> schedulePostponedDoseNotification({
    required Medication medication,
    required String originalDoseTime,
    required TimeOfDay newTime,
    required String personId,
  });

  // Digiuno
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

  // Riprogrammazione massiva
  Future<void> rescheduleAllMedicationNotifications();

  // Debug
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
```

**Delegazione specializzata:**
- `DailyNotificationScheduler`: Notifiche giornaliere ricorrenti
- `WeeklyNotificationScheduler`: Pattern settimanali
- `FastingNotificationScheduler`: Gestione di periodi di digiuno
- `NotificationCancellationManager`: Cancellazione intelligente

**Limite di notifiche:**
L'app mantiene un massimo di **5 notifiche attive** nel sistema per evitare saturazione.

### DoseHistoryService

Centralizza operazioni sulla cronologia.

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

**Vantaggi:**
- Evita duplicazione di logica tra schermate
- Gestisce automaticamente l'aggiornamento di `Medication` se la voce è di oggi
- Ripristina la scorta se si elimina un'assunzione

### DoseActionService

Centralizza la logica di registrazione dosi per evitare duplicazione di codice tra componenti UI.

```dart
class DoseActionService {
  // Registrazione dosi programmate
  static Future<Medication> registerTakenDose({
    required Medication medication,
    required String doseTime,
  });

  static Future<Medication> registerSkippedDose({
    required Medication medication,
    required String doseTime,
  });

  // Registrazione dosi manuali
  static Future<Medication> registerManualDose({
    required Medication medication,
    required double quantity,
    double? lastDailyConsumption,
  });

  static Future<Medication> registerExtraDose({
    required Medication medication,
    required double quantity,
  });

  // Calcolo consumo giornaliero
  static Future<double> calculateDailyConsumption({
    required String medicationId,
    DateTime? date,
  });
}
```

**Responsabilità:**
- Validare scorta sufficiente prima di registrare dosi
- Aggiornare stato di dosi assunte/omesse per giorno
- Scontare automaticamente scorta
- Creare voci nella cronologia di dosi
- Gestire notifiche correlate (cancellare, riprogrammare, digiuno)
- Calcolare consumo giornaliero totale per farmaci "secondo necessità"

**Metodo `calculateDailyConsumption`:**
Aggiunto per centralizzare il calcolo del consumo giornaliero, particolarmente utile per farmaci "secondo necessità". Somma tutte le dosi assunte in un giorno specifico, escludendo dosi omesse. Questo valore viene utilizzato per aggiornare `lastDailyConsumption` e predire i giorni di scorta rimanenti.

**Eccezioni:**
- `InsufficientStockException`: Si lancia quando non c'è scorta sufficiente per completare una dose

### DoseCalculationService

Logica di business per calcolare prossime dosi.

```dart
class DoseCalculationService {
  static NextDoseInfo? getNextDoseInfo(Medication medication);
  static String formatNextDose(NextDoseInfo info, BuildContext context);
}
```

**Responsabilità:**
- Rileva prossima dose secondo frequenza
- Formatta messaggi localizzati ("Oggi alle 18:00", "Domani alle 08:00")
- Rispetta date di inizio/fine trattamento

### MedicationUpdateService

Centralizza operazioni comuni di aggiornamento farmaci per evitare duplicazione di codice e assicurare comportamento consistente.

```dart
class MedicationUpdateService {
  // Ricarica scorta
  static Future<Medication> refillMedication({
    required Medication medication,
    required double refillAmount,
  });

  // Gestione stato suspended
  static Future<Medication> resumeMedication({
    required Medication medication,
  });

  static Future<Medication> suspendMedication({
    required Medication medication,
  });
}
```

**Responsabilità:**
- **refillMedication**: Aggiorna scorta e salva `lastRefillAmount` per riferimento futuro
- **resumeMedication**: Attiva farmaco sospeso e riprogramma notifiche per tutte le persone assegnate
- **suspendMedication**: Disattiva farmaco e cancella tutte le notifiche programmate

**Vantaggi della centralizzazione:**
- Elimina creazione manuale ripetitiva di oggetti `Medication` con `copyWith`
- Gestisce correttamente la tabella `person_medications` (V19+) dove risiede `isSuspended`
- Coordina automaticamente notifiche al cambiare stato
- Riduce codice nei componenti UI da 493 a 419 linee (es: `MedicationCard`)

**Nota architettonica V19+:**
I metodi `resumeMedication` e `suspendMedication` aggiornano la tabella `person_medications` per ogni persona assegnata, poiché `isSuspended` è un campo specifico della relazione persona-farmaco, non del farmaco condiviso.

### FastingConflictService

Rileva conflitti tra orari di farmaci e periodi di digiuno.

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

**Responsabilità:**
- Verifica se un orario proposto coincide con un periodo di digiuno di un altro farmaco
- Calcola periodi di digiuno attivi (prima/dopo l'assunzione di farmaci)
- Suggerisce orari alternativi che evitino conflitti
- Supporta digiuno "before" (prima di assumere) e "after" (dopo aver assunto)

**Casi d'uso:**
- All'aggiungere un nuovo orario di dose in `DoseScheduleEditor`
- Al creare o modificare un farmaco in `EditScheduleScreen`
- Previene conflitti che potrebbero compromettere l'efficacia del trattamento
- Attivato in V19+ dopo la refactorizzazione di `EditScheduleScreen` per ricevere `allMedications` e `personId` come parametri

### SmartCacheService (Singleton)

Sistema di cache intelligente che ottimizza le prestazioni dell'applicazione mediante archiviazione temporanea di dati frequentemente acceduti.

```dart
class SmartCacheService<T> {
  final int maxSize;
  final Duration ttl;

  // Operazioni principali
  T? get(String key);
  void put(String key, T value);
  Future<T> getOrCompute(String key, Future<T> Function() computer);
  void invalidate(String key);
  void clear();

  // Statistiche
  CacheStatistics get statistics;
}
```

**Caratteristiche:**
- **TTL (Time-To-Live) automatico**: Ogni voce scade dopo un periodo configurabile
- **Algoritmo LRU**: Evizione di voci meno recentemente usate quando si raggiunge il limite
- **Pattern cache-aside**: Metodo `getOrCompute()` che verifica prima la cache, poi calcola se necessario
- **Auto-pulizia**: Timer periodico che elimina voci scadute ogni minuto
- **Statistiche in tempo reale**: Tracking di hits, misses, evictions e hit rate

#### MedicationCacheService

Gestisce quattro cache specializzate per diversi tipi di dati di farmaci:

```dart
class MedicationCacheService {
  // Cache specializzate
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

**Configurazioni per tipo:**
- **Farmaci**: 10 minuti TTL, 50 voci massimo - Per farmaci individuali
- **Liste**: 5 minuti TTL, 20 voci - Per liste di farmaci per persona/filtro
- **Cronologia**: 3 minuti TTL, 30 voci - Per query di cronologia delle dosi
- **Statistiche**: 30 minuti TTL, 10 voci - Per calcoli statistici pesanti

**Vantaggi:**
- Riduce accessi al database del 60-80% per dati frequentemente consultati
- Migliora tempi di risposta di query complesse (statistiche, cronologia)
- Invalidazione selettiva quando si modificano dati
- Memoria controllata con limiti configurabili

### IntelligentRemindersService

Servizio di analisi dell'aderenza e previsione di pattern di medicazione.

```dart
class IntelligentRemindersService {
  // Analisi dell'aderenza
  static Future<AdherenceAnalysis> analyzeAdherence({
    required String personId,
    required String medicationId,
    int daysToAnalyze = 30,
  });

  // Previsione di omissioni
  static Future<SkipProbability> predictSkipProbability({
    required String personId,
    required String medicationId,
    required int dayOfWeek,
    required String timeOfDay,
  });

  // Suggerimenti di orari ottimali
  static Future<List<TimeOptimizationSuggestion>> suggestOptimalTimes({
    required String personId,
    required String medicationId,
  });
}
```

**Funzionalità analyzeAdherence():**

Realizza un'analisi completa dell'aderenza terapeutica basata sulla cronologia delle dosi:

- **Metriche per giorno della settimana**: Calcola tassi di aderenza per ogni giorno (Lun-Dom)
- **Metriche per ora del giorno**: Identifica in quali orari c'è migliore conformità
- **Migliori/peggiori giorni e orari**: Rileva pattern di successo e problemi
- **Giorni problematici**: Elenca giorni con aderenza <50%
- **Raccomandazioni personalizzate**: Genera suggerimenti basati su pattern rilevati
- **Tendenza**: Calcola se l'aderenza sta migliorando, è stabile o in declino

Esempio di analisi:
```dart
AdherenceAnalysis {
  overallAdherence: 0.85,  // 85% di aderenza globale
  bestDay: 'Monday',        // Miglior giorno: lunedì
  worstDay: 'Saturday',     // Peggior giorno: sabato
  bestTimeSlot: '08:00',    // Miglior orario: 8:00
  worstTimeSlot: '22:00',   // Peggior orario: 22:00
  trend: AdherenceTrend.improving,  // Migliorando nel tempo
  recommendations: [
    'Considera di spostare la dose dalle 22:00 alle 20:00 (migliore aderenza)',
    'I fine settimana necessitano promemoria aggiuntivi'
  ]
}
```

**Funzionalità predictSkipProbability():**

Predice la probabilità che una dose venga omessa basandosi su pattern storici:

- **Input**: Persona, farmaco, giorno della settimana specifico, ora specifica
- **Analisi**: Esamina cronologia di omissioni in condizioni simili
- **Output**: Probabilità (0.0-1.0) e classificazione di rischio (basso/medio/alto)
- **Fattori considerati**: Giorno della settimana, ora del giorno, tendenza recente

Esempio di previsione:
```dart
SkipProbability {
  probability: 0.65,         // 65% probabilità di omissione
  riskLevel: RiskLevel.high, // Rischio alto
  factors: [
    'I sabati hanno 60% più omissioni',
    'Orario 22:00 è costantemente problematico'
  ]
}
```

**Funzionalità suggestOptimalTimes():**

Suggerisce cambi di orario per migliorare l'aderenza:

- Identifica orari attuali con bassa aderenza (<70%)
- Cerca orari alternativi con migliore cronologia di conformità
- Calcola il potenziale di miglioramento per ogni suggerimento
- Prioritizza suggerimenti per impatto atteso

Esempio di suggerimenti:
```dart
[
  TimeOptimizationSuggestion {
    currentTime: '22:00',
    suggestedTime: '20:00',
    currentAdherence: 0.45,      // 45% aderenza attuale
    expectedAdherence: 0.82,     // 82% attesa nel nuovo orario
    improvementPotential: 0.37,  // +37% miglioramento potenziale
    reason: 'L\'aderenza alle 20:00 è costantemente alta'
  }
]
```

**Casi d'uso:**
- Schermate di statistiche con analisi dettagliata dell'aderenza
- Allerte proattive quando si rilevano pattern di omissione
- Assistente di ottimizzazione di orari
- Report medici con insights di conformità

### Sistema di Notifiche per Scorte Basse

MedicApp implementa un sistema duale di avvisi di scorta che combina notifiche reattive (nel momento critico) e proattive (anticipatorie).

#### Notifiche Reattive (Immediate Stock Check)

Il sistema verifica automaticamente lo stock disponibile ogni volta che un utente tenta di registrare una dose, sia da:
- La schermata principale quando si marca una dose come "assunta"
- Le azioni rapide di notifica (pulsante "Assumere")
- La registrazione manuale di dosi occasionali

**Implementazione in NotificationService:**

```dart
Future<void> showLowStockNotification({
  required Medication medication,
  required String personName,
  bool isInsufficientForDose = false,
  int? daysRemaining,
}) async
```

**Flusso reattivo:**
1. L'utente tenta di registrare una dose
2. Il sistema verifica: `medication.stockQuantity < doseQuantity`
3. Se è insufficiente:
   - Mostra notifica immediata con priorità alta
   - NON permette la registrazione della dose
   - Indica la quantità necessaria vs disponibile
   - Guida l'utente a rifornire lo stock

**Intervallo di ID notifiche:** 7.000.000 - 7.999.999 (generati da `NotificationIdGenerator.generateLowStockId()`)

#### Notifiche Proattive (Daily Stock Monitoring)

Il sistema può eseguire controlli proattivi giornalieri che anticipano problemi di esaurimento scorte prima che si verifichino.

**Metodo principale:**

```dart
Future<void> checkLowStockForAllMedications() async
```

**Flusso proattivo:**
1. Si esegue massimo una volta al giorno (utilizza SharedPreferences per il tracking)
2. Itera su tutte le persone registrate
3. Per ogni farmaco attivo:
   - Calcola la dose giornaliera totale considerando:
     - Tutte le persone assegnate al farmaco
     - Frequenza del trattamento (giornaliero, settimanale, intervallo)
     - Orari configurati per persona
   - Divide lo stock attuale per la dose giornaliera
   - Ottiene i giorni di scorta rimanenti
4. Se `medication.isStockLow` (utilizza la soglia configurabile per farmaco):
   - Emette notifica proattiva
   - Include i giorni approssimativi rimanenti
   - Non blocca alcuna azione

**Prevenzione dello spam:**
- Registra l'ultima data di controllo in `SharedPreferences`
- Si esegue solo se `lastCheck != today`
- Ogni farmaco notifica solo una volta al giorno
- Si resetta quando si ricarica lo stock

**Integrazione con Medication.isStockLow:**
Il calcolo dello stock basso utilizza la proprietà esistente del modello:
```dart
bool get isStockLow {
  if (stockQuantity <= 0) return true;
  final dailyDose = doseSchedule.values.fold(0.0, (sum, dose) => sum + dose);
  if (dailyDose <= 0) return false;
  final daysRemaining = stockQuantity / dailyDose;
  return daysRemaining <= lowStockThresholdDays;
}
```

#### Configurazione dei Canali di Notifica

Le notifiche di stock utilizzano un canale dedicato:

```dart
// In NotificationConfig.getStockAlertAndroidDetails()
AndroidNotificationDetails(
  'stock_alerts',
  'Avvisi di Scorta Bassa',
  channelDescription: 'Notifiche quando lo stock di farmaci è basso',
  importance: Importance.high,
  priority: Priority.high,
  autoCancel: true,
)
```

**Caratteristiche:**
- Canale separato dai promemoria di dose
- Priorità alta (non massima, per non essere invasivo)
- Auto-cancellazione al tocco
- Senza azioni integrate (solo informative)

#### Quando Usare Ogni Tipo

| Tipo | Momento | Scopo | Bloccante |
|------|---------|-------|-----------|
| **Reattivo** | Quando si tenta di registrare una dose | Prevenire la registrazione con stock insufficiente | ✅ Sì |
| **Proattivo** | Controllo giornaliero (opzionale) | Anticipare la necessità di rifornimento | ❌ No |

**Vantaggio del design duale:**
- Protezione assoluta nel momento critico (reattivo)
- Pianificazione anticipata per evitare di raggiungere il momento critico (proattivo)
- Il sistema proattivo è opt-in (deve essere chiamato esplicitamente dalla logica dell'app)

---

## Livello delle Viste (Screens/Widgets)

### Struttura delle Schermate Principali

```
MedicationListScreen (schermata principale)
├─ MedicationCard (widget riutilizzabile)
│  ├─ TodayDosesSection
│  └─ FastingCountdownRow
├─ MedicationOptionsSheet (modale di opzioni)
└─ TodayDosesSection (dosi del giorno)

MedicationInfoScreen (creare/modificare farmaco)
├─ MedicationInfoForm
├─ MedicationDosageScreen
├─ MedicationTimesScreen
├─ MedicationDurationScreen
├─ MedicationDatesScreen
└─ EditFastingScreen

DoseActionScreen (registrare/omettere dose)
├─ TakeDoseButton
├─ SkipDoseButton
└─ PostponeButtons

DoseHistoryScreen (cronologia)
├─ FilterDialog
├─ StatisticsCard
└─ DeleteConfirmationDialog

SettingsScreen
├─ PersonsManagementScreen
└─ LanguageSelectionScreen
```

### Widget Riutilizzabili

**MedicationCard:**
- Mostra informazioni riassunte del farmaco
- Prossima dose
- Stato della scorta
- Dosi di oggi (assunte/omesse)
- Contatore di digiuno attivo (se applicabile)
- Persone assegnate (in modalità senza schede)

**TodayDosesSection:**
- Lista orizzontale di dosi del giorno
- Indicatore visuale: ✓ (assunta), ✗ (omessa), vuoto (pendente)
- Mostra ora reale di registrazione (se la configurazione è attivata)
- Tocco per modificare/eliminare

**FastingCountdownRow:**
- Contatore in tempo reale del digiuno rimanente
- Cambia a verde e suona al completamento
- Pulsante di dismiss per nasconderlo

### Navigazione

MedicApp usa **Navigator 1.0** standard di Flutter:

```dart
// Push basico
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Push con risultato
final result = await Navigator.push<Medication>(
  context,
  MaterialPageRoute(builder: (context) => MedicationInfoScreen()),
);
```

**Vantaggi di non usare Navigator 2.0:**
- Semplicità
- Stack esplicito facile da ragionare
- Minore curva di apprendimento

### Gestione dello Stato a Livello di Widget

**ViewModel Pattern (senza framework):**

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
    // Logica di business
    // Aggiorna database
    await loadMedications();  // Aggiorna UI
  }
}
```

**Nella schermata:**

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

**Vantaggi:**
- Non richiede pacchetti esterni (BLoC, Riverpod, Redux)
- Codice chiaro e diretto
- Prestazioni eccellenti (meno livelli di astrazione)
- Facile da testare: si istanzia solo il ViewModel

---

## Flusso di Dati

### Da UI a Database (Registrare Dose)

```
Utente tocca "Assumere" nella notifica
    │
    ▼
NotificationService._handleNotificationAction()
    │
    ├─ Valida scorta disponibile
    ├─ Aggiorna Medication (riduce scorta, aggiunge a takenDosesToday)
    │  └─ DatabaseHelper.updateMedicationForPerson()
    │
    ├─ Crea DoseHistoryEntry
    │  └─ DatabaseHelper.insertDoseHistory()
    │
    ├─ Cancella notifica
    │  └─ NotificationService.cancelTodaysDoseNotification()
    │
    └─ Se ha digiuno "dopo", programma notifica dinamica
       └─ NotificationService.scheduleDynamicFastingNotification()
```

### Da Servizi a Notifiche (Creare Farmaco)

```
Utente completa form di farmaco nuovo
    │
    ▼
MedicationListViewModel.createMedication()
    │
    ├─ DatabaseHelper.createMedicationForPerson()
    │  ├─ Cerca se esiste già farmaco con quel nome
    │  ├─ Se esiste: riutilizza (scorta condivisa)
    │  └─ Se no: crea voce in medications
    │
    └─ NotificationService.scheduleMedicationNotifications(
         medication,
         personId: personId
       )
       │
       ├─ Cancella notifiche vecchie (se esistevano)
       │
       ├─ Secondo durationType:
       │  ├─ everyday/untilFinished → DailyNotificationScheduler
       │  ├─ weeklyPattern → WeeklyNotificationScheduler
       │  └─ specificDates → DailyNotificationScheduler (date specifiche)
       │
       └─ Se requiresFasting && notifyFasting:
          └─ FastingNotificationScheduler.scheduleFastingNotifications()
```

### Aggiornamento di UI (Tempo Reale)

```
DatabaseHelper aggiorna dati
    │
    ▼
ViewModel.loadMedications()  // Ricarica dal DB
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

**Ottimizzazione UI-first:**
Molte operazioni aggiornano l'UI prima e poi il database in background:

```dart
// PRIMA (bloccante)
await database.update(...);
setState(() {});  // Utente aspetta

// ORA (ottimista)
setState(() {});  // UI istantanea
database.update(...);  // Background
```

Risultato: **15-30x più veloce** in operazioni comuni.

---

## Gestione delle Notifiche

### Sistema di ID Unici

Ogni notifica ha un ID unico calcolato secondo il suo tipo:

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

**Generazione di ID per notifica giornaliera:**
```dart
static int _generateDailyId(String medicationId, int doseIndex, String personId) {
  final medicationHash = medicationId.hashCode.abs();
  final personHash = personId.hashCode.abs();
  return ((medicationHash % 10000) * 1000 + (personHash % 10) * 100 + doseIndex);
}
```

**Vantaggi:**
- Evita collisioni tra tipi di notifica
- Permette cancellare selettivamente
- Debug più facile (l'ID indica il tipo per il suo intervallo)
- Supporto multi-persona (include hash del personId)

### Cancellazione Intelligente

Invece di cancellare ciecamente fino a 1000 ID, l'app calcola esattamente cosa cancellare:

```dart
Future<void> cancelMedicationNotifications(String medicationId, {Medication? medication}) async {
  if (medication == null) {
    // Cancellazione bruta (compatibilità)
    _cancelBruteForce(medicationId);
    return;
  }

  // Cancellazione intelligente
  final doseCount = medication.doseTimes.length;

  // Per ogni persona assegnata a questo farmaco
  final persons = await DatabaseHelper.instance.getPersonsForMedication(medicationId);

  for (final person in persons) {
    // Cancella notifiche giornaliere
    for (int i = 0; i < doseCount; i++) {
      final notificationId = NotificationIdGenerator.generate(
        type: NotificationIdType.daily,
        medicationId: medicationId,
        personId: person.id,
        doseIndex: i,
      );
      await _notificationsPlugin.cancel(notificationId);
    }

    // Cancella digiuno se applicabile
    if (medication.requiresFasting) {
      _cancelFastingNotifications(medication, person.id);
    }
  }
}
```

**Risultato:**
- Solo cancella le notifiche che realmente esistono
- Molto più veloce che iterare 1000 ID
- Evita effetti collaterali in altre notifiche

### Azioni Dirette (Android)

Le notifiche includono pulsanti di azione rapida:

```dart
final androidDetails = AndroidNotificationDetails(
  'medication_reminders',
  'Promemoria di Farmaci',
  actions: [
    AndroidNotificationAction('register_dose', 'Assumere'),
    AndroidNotificationAction('skip_dose', 'Omettere'),
    AndroidNotificationAction('snooze_dose', 'Posticipare 10min'),
  ],
);
```

**Flusso di azione:**
```
Utente tocca pulsante "Assumere"
    │
    ▼
NotificationService._onNotificationTapped()
    │ (rileva actionId = 'register_dose')
    ▼
_handleNotificationAction()
    │
    ├─ Carica farmaco dal DB
    ├─ Valida scorta
    ├─ Aggiorna Medication
    ├─ Crea DoseHistoryEntry
    ├─ Cancella notifica
    └─ Programma digiuno se applicabile
```

### Limite di 5 Notifiche Attive

Android/iOS hanno limiti di notifiche visibili. MedicApp programma intelligentemente:

**Strategia:**
- Solo programma notifiche per **oggi + 1 giorno** (domani)
- All'aprire l'app o cambiare giorno, riprogramma automaticamente
- Prioritizza le notifiche più vicine

```dart
Future<void> rescheduleAllMedicationNotifications() async {
  await cancelAllNotifications();

  final allPersons = await DatabaseHelper.instance.getAllPersons();

  for (final person in allPersons) {
    final medications = await DatabaseHelper.instance.getMedicationsForPerson(person.id);

    for (final medication in medications) {
      if (medication.isActive && !medication.isSuspended) {
        // Solo programma prossime 48h
        await scheduleMedicationNotifications(
          medication,
          personId: person.id,
          skipCancellation: true,  // Già cancellato tutto sopra
        );
      }
    }
  }
}
```

**Trigger di riprogrammazione:**
- All'avviare l'app
- Al riprendere dal background (AppLifecycleState.resumed)
- Dopo creare/modificare/eliminare farmaco
- Al cambiare giorno (mezzanotte)

---

## Database SQLite V19

### Schema delle Tabelle

#### medications (dati condivisi)

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

#### persons (utenti e familiari)

```sql
CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  isDefault INTEGER DEFAULT 0  -- Booleano: 1=predefinito, 0=no
);
```

#### person_medications (pauta individuale N:N)

```sql
CREATE TABLE person_medications (
  id TEXT PRIMARY KEY,
  personId TEXT NOT NULL,
  medicationId TEXT NOT NULL,
  assignedDate TEXT NOT NULL,

  -- CONFIGURAZIONE INDIVIDUALE
  durationType TEXT NOT NULL,
  dosageIntervalHours INTEGER DEFAULT 0,
  doseSchedule TEXT NOT NULL,  -- JSON: {"08:00": 1.0, "20:00": 1.5}
  takenDosesToday TEXT,        -- CSV: "08:00,20:00"
  skippedDosesToday TEXT,
  takenDosesDate TEXT,
  selectedDates TEXT,          -- CSV: "2025-01-15,2025-01-20"
  weeklyDays TEXT,             -- CSV: "1,3,5" (Lun, Mer, Ven)
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
  UNIQUE(personId, medicationId)  -- Una pauta per persona-farmaco
);
```

#### dose_history (cronologia delle assunzioni)

```sql
CREATE TABLE dose_history (
  id TEXT PRIMARY KEY,
  medicationId TEXT NOT NULL,
  medicationName TEXT NOT NULL,
  medicationType TEXT NOT NULL,
  personId TEXT NOT NULL,
  scheduledDateTime TEXT NOT NULL,   -- Quando doveva essere assunta
  registeredDateTime TEXT NOT NULL,  -- Quando è stata registrata
  status TEXT NOT NULL,              -- 'taken' | 'skipped'
  quantity REAL NOT NULL,
  isExtraDose INTEGER DEFAULT 0,
  notes TEXT,

  FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
);
```

### Indici e Ottimizzazioni

```sql
-- Ricerche rapide per farmaco
CREATE INDEX idx_dose_history_medication ON dose_history(medicationId);

-- Ricerche rapide per data
CREATE INDEX idx_dose_history_date ON dose_history(scheduledDateTime);

-- Ricerche rapide di paute per persona
CREATE INDEX idx_person_medications_person ON person_medications(personId);

-- Ricerche rapide di persone per farmaco
CREATE INDEX idx_person_medications_medication ON person_medications(medicationId);
```

**Impatto:**
- Query di cronologia: 10-100x più veloci
- Caricamento di farmaci per persona: O(log n) invece di O(n)
- Statistiche di aderenza: calcolo istantaneo

### Trigger per Integrità

Sebbene SQLite non abbia trigger espliciti in questo codice, le **foreign keys con CASCADE** garantiscono:

```sql
FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE
```

**Comportamento:**
- Se si elimina una persona → si eliminano automaticamente i suoi `person_medications` e `dose_history`
- Se si elimina un farmaco → si eliminano automaticamente i suoi `person_medications`

### Sistema di Migrazioni

Il database si auto-aggiorna da qualsiasi versione precedente:

```dart
await openDatabase(
  path,
  version: 19,  // Versione attuale
  onCreate: _createDB,     // Se è installazione nuova
  onUpgrade: _upgradeDB,   // Se esiste DB con versione < 19
);
```

**Esempio di migrazione (V18 → V19):**

```dart
if (oldVersion < 19) {
  // 1. Backup
  await db.execute('ALTER TABLE person_medications RENAME TO person_medications_old');
  await db.execute('ALTER TABLE medications RENAME TO medications_old');

  // 2. Creare nuove strutture
  await db.execute('''CREATE TABLE medications (...)''');
  await db.execute('''CREATE TABLE person_medications (...)''');

  // 3. Migrare dati
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

  // 4. Pulizia
  await db.execute('DROP TABLE person_medications_old');
  await db.execute('DROP TABLE medications_old');
}
```

**Vantaggi:**
- L'utente non perde dati nell'aggiornare
- Migrazione trasparente e automatica
- Rollback manuale possibile (si salvano backup temporanei)

---

## Ottimizzazioni delle Prestazioni

### Operazioni UI-First

**Problema originale:**
```dart
// Utente registra dose → UI congelata ~500ms
await database.update(medication);
setState(() {});  // UI aggiornata DOPO
```

**Soluzione ottimista:**
```dart
// UI aggiornata IMMEDIATAMENTE (~15ms)
setState(() {
  // Aggiornare stato locale
});
// Database si aggiorna in background
unawaited(database.update(medication));
```

**Risultati misurati:**
- Registrazione di dose: 500ms → **30ms** (16.6x più veloce)
- Aggiornamento di scorta: 400ms → **15ms** (26.6x più veloce)
- Navigazione tra schermate: 300ms → **20ms** (15x più veloce)

### Riduzione di Frame Saltati

**Prima (con state management complesso):**
```
Frame budget: 16ms (60 FPS)
Tempo reale: 45ms → 30 frame saltati al secondo
```

**Dopo (ViewModel semplice):**
```
Frame budget: 16ms (60 FPS)
Tempo reale: 12ms → 0 frame saltati
```

**Tecnica applicata:**
- Evitare rebuild in cascata
- `notifyListeners()` solo quando cambiano dati rilevanti
- Widget `const` dove possibile

### Tempo di Avvio < 100ms

```
1. main() eseguito                     → 0ms
2. DatabaseHelper inizializzato        → 10ms
3. NotificationService inizializzato   → 30ms
4. Prima schermata renderizzata        → 80ms
5. Dati caricati in background         → 200ms (async)
```

L'utente vede l'UI in **80ms**, i dati appaiono poco dopo.

**Tecnica:**
```dart
@override
void initState() {
  super.initState();
  _viewModel = MedicationListViewModel();

  // Inizializzare DOPO il primo frame
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _initializeViewModel();
  });
}
```

### Registrazione di Dose < 200ms

```
Tocco su "Assumere dose"
    ↓
15ms: setState aggiorna UI locale
    ↓
50ms: database.update() in background
    ↓
100ms: database.insert(history) in background
    ↓
150ms: NotificationService.cancel() in background
    ↓
Totale percepito dall'utente: 15ms (UI immediata)
Totale reale: 150ms (ma non blocca)
```

### Sistema di Cache Intelligente

MedicApp implementa un sistema di cache multi-livello che riduce significativamente gli accessi al database:

**SmartCacheService con algoritmo LRU:**
```dart
// Operazione senza cache
final medications = await DatabaseHelper.instance.getMedicationsForPerson(personId);
// Tempo: ~50-100ms per query

// Con cache intelligente
final medications = await MedicationCacheService.listsCache.getOrCompute(
  'medications_$personId',
  () => DatabaseHelper.instance.getMedicationsForPerson(personId),
);
// Primo accesso: ~50-100ms
// Accessi successivi (entro TTL): ~0.5-2ms
```

**Impatto misurato:**
- **Riduzione di query al DB**: 60-80% meno accessi per dati frequenti
- **Miglioramento in tempo di caricamento**: Lista farmaci 50-200ms → 2-5ms (cache hit)
- **Cronologia delle dosi**: Query complesse 300-500ms → 5-10ms (cache hit)
- **Statistiche**: Calcoli pesanti 800-1200ms → 10-15ms (cache hit)

**Auto-gestione della memoria:**
- Limiti di dimensione per cache prevengono uso eccessivo di RAM
- Algoritmo LRU evicta automaticamente dati meno usati
- TTL assicura che i dati non diventino obsoleti
- Auto-pulizia elimina voci scadute ogni minuto

**Invalidazione intelligente:**
```dart
// Al creare/aggiornare farmaco
await DatabaseHelper.instance.updateMedicationForPerson(medication, personId);
MedicationCacheService.invalidateMedicationCaches(medication.id);
// Invalida solo cache interessate, non tutto il sistema
```

**Statistiche in tempo reale:**
```dart
final stats = MedicationCacheService.medicationsCache.statistics;
print('Hit rate: ${stats.hitRate * 100}%');  // Es: 75% di request da cache
print('Total hits: ${stats.hits}');          // Request soddisfatte senza DB
print('Total misses: ${stats.misses}');      // Request che hanno richiesto DB
print('Evictions: ${stats.evictions}');      // Voci rimosse da LRU
```

### Cache di Persona Predefinita

```dart
class DatabaseHelper {
  Person? _cachedDefaultPerson;

  Future<Person?> getDefaultPerson() async {
    if (_cachedDefaultPerson != null) {
      return _cachedDefaultPerson;  // ¡Istantaneo!
    }

    // Solo consulta DB se non è in cache
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

**Impatto:**
- Ogni chiamata susseguente: 0.01ms (1000x più veloce)
- Si invalida solo quando si modifica qualche persona

---

## Modularizzazione del Codice

### Prima: File Monolitici

```
lib/
└── screens/
    └── medication_list_screen.dart  (3500 righe)
        ├── UI
        ├── Logica di business
        ├── Dialoghi
        └── Widget ausiliari (tutto mescolato)
```

### Dopo: Struttura Modulare

```
lib/
└── screens/
    └── medication_list/
        ├── medication_list_screen.dart        (400 righe - solo UI)
        ├── medication_list_viewmodel.dart     (300 righe - logica)
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

**Riduzione del 39.3%:**
- **Prima:** 3500 righe in 1 file
- **Dopo:** 2124 righe in 14 file (~150 righe/file in media)

### Vantaggi della Modularizzazione

1. **Manutenibilità:**
   - Modifica in un dialogo → modifichi solo quel file
   - Git diff più chiari (meno conflitti)

2. **Riutilizzabilità:**
   - `MedicationCard` usato nella lista E nella ricerca
   - `DoseSelectionDialog` riutilizzato in 3 schermate

3. **Testabilità:**
   - ViewModel si testa senza UI
   - Widget si testano con `testWidgets` in modo isolato

4. **Collaborazione:**
   - Persona A lavora sui dialoghi
   - Persona B lavora sul ViewModel
   - Senza conflitti di merge

### Esempio: Dialogo Riutilizzabile

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

// Uso in QUALSIASI schermata
final refillAmount = await RefillInputDialog.show(context, medication: med);
if (refillAmount != null) {
  // Logica di ricarica
}
```

**Riutilizzato in:**
- `MedicationListScreen`
- `MedicationStockScreen`
- `MedicineSearchScreen`

---

## Localizzazione (l10n)

MedicApp supporta **8 lingue** con il sistema ufficiale di Flutter.

### Sistema Flutter Intl

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true  # Auto-genera codice

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### File ARB (Application Resource Bundle)

```
lib/l10n/
├── app_en.arb  (template base - inglese)
├── app_es.arb  (spagnolo)
├── app_ca.arb  (catalano)
├── app_eu.arb  (basco)
├── app_gl.arb  (galiziano)
├── app_fr.arb  (francese)
├── app_it.arb  (italiano)
└── app_de.arb  (tedesco)
```

**Esempio di file ARB:**

```json
{
  "@@locale": "it",

  "mainScreenTitle": "I Miei Farmaci",
  "@mainScreenTitle": {
    "description": "Titolo della schermata principale"
  },

  "doseRegisteredAtTime": "Dose di {medication} registrata alle {time}. Scorta rimanente: {stock}",
  "@doseRegisteredAtTime": {
    "description": "Conferma di dose registrata",
    "placeholders": {
      "medication": {"type": "String"},
      "time": {"type": "String"},
      "stock": {"type": "String"}
    }
  },

  "remainingDosesToday": "{count, plural, =1{Rimane 1 dose oggi} other{Rimangono {count} dosi oggi}}",
  "@remainingDosesToday": {
    "description": "Dosi rimanenti",
    "placeholders": {
      "count": {"type": "int"}
    }
  }
}
```

### Generazione Automatica di Codice

Eseguendo `flutter gen-l10n`, si generano:

```dart
// lib/l10n/app_localizations.dart (astratta)
abstract class AppLocalizations {
  String get mainScreenTitle;
  String doseRegisteredAtTime(String medication, String time, String stock);
  String remainingDosesToday(int count);
}

// lib/l10n/app_localizations_it.dart (implementazione)
class AppLocalizationsIt extends AppLocalizations {
  @override
  String get mainScreenTitle => 'I Miei Farmaci';

  @override
  String doseRegisteredAtTime(String medication, String time, String stock) {
    return 'Dose di $medication registrata alle $time. Scorta rimanente: $stock';
  }

  @override
  String remainingDosesToday(int count) {
    return Intl.plural(
      count,
      one: 'Rimane 1 dose oggi',
      other: 'Rimangono $count dosi oggi',
    );
  }
}
```

### Uso nell'App

```dart
// In main.dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: MedicationListScreen(),
);

// In qualsiasi widget
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.mainScreenTitle),
    ),
    body: Text(l10n.remainingDosesToday(3)),  // "Rimangono 3 dosi oggi"
  );
}
```

### Pluralizzazione Automatica

```dart
// Italiano
remainingDosesToday(1) → "Rimane 1 dose oggi"
remainingDosesToday(3) → "Rimangono 3 dosi oggi"

// Inglese (generato da app_en.arb)
remainingDosesToday(1) → "1 dose remaining today"
remainingDosesToday(3) → "3 doses remaining today"
```

### Selezione Automatica di Lingua

L'app rileva la lingua del sistema:

```dart
// main.dart
MaterialApp(
  locale: const Locale('it', ''),  // Forzare italiano (opzionale)
  localeResolutionCallback: (locale, supportedLocales) {
    // Se la lingua del dispositivo è supportata, usarla
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode) {
        return supportedLocale;
      }
    }
    // Fallback a inglese
    return const Locale('en', '');
  },
);
```

---

## Decisioni di Design

### Perché NO BLoC/Riverpod/Redux

**Considerazioni:**

1. **Complessità non necessaria:**
   - MedicApp non ha stato globale complesso
   - La maggior parte dello stato è locale alle schermate
   - Non ci sono molteplici fonti di verità in competizione

2. **Curva di apprendimento:**
   - BLoC richiede comprendere Streams, Sinks, eventi
   - Riverpod ha concetti avanzati (providers, family, autoDispose)
   - Redux richiede azioni, reducer, middleware

3. **Prestazioni:**
   - ViewModel semplice: 12ms/frame
   - BLoC (misurato): 28ms/frame → **2.3x più lento**
   - Più livelli = più overhead

4. **Dimensione dell'APK:**
   - flutter_bloc: +2.5 MB
   - riverpod: +1.8 MB
   - Senza state management: 0 MB aggiuntivi

**Decisione:**
- `ChangeNotifier` + ViewModel è sufficiente
- Codice più semplice e diretto
- Prestazioni superiori

**Eccezione dove SÌ useremmo BLoC:**
- Se ci fosse sincronizzazione con backend in tempo reale
- Se più schermate dovessero reagire allo stesso stato
- Se ci fosse logica complessa con molteplici effetti collaterali

### Perché SQLite Invece di Hive/Isar

**Confronto:**

| Caratteristica | SQLite | Hive | Isar |
|----------------|--------|------|------|
| Query complesse | ✅ SQL completo | ❌ Solo key-value | ⚠️ Limitato |
| Relazioni N:N | ✅ Foreign keys | ❌ Manuale | ⚠️ Links manuali |
| Migrazioni | ✅ onUpgrade | ❌ Manuale | ⚠️ Parziale |
| Indici | ✅ CREATE INDEX | ❌ No | ✅ Sì |
| Transazioni | ✅ ACID | ⚠️ Limitate | ✅ Sì |
| Maturità | ✅ 20+ anni | ⚠️ Giovane | ⚠️ Molto giovane |
| Dimensione | ~1.5 MB | ~200 KB | ~1.2 MB |

**Decisione:**
- SQLite vince per:
  - **Query complesse** (JOIN, GROUP BY, statistiche)
  - **Migrazioni automatiche** (critico per aggiornamenti)
  - **Relazioni esplicite** (person_medications N:N)
  - **Maturità e stabilità**

**Caso dove useremmo Hive:**
- App molto semplice (solo lista di TODO senza relazioni)
- Non si necessitano ricerche complesse
- Priorità massima sulla dimensione dell'APK

### Perché Flutter Local Notifications

**Alternative considerate:**

1. **awesome_notifications:**
   - ✅ Più feature (notifiche ricche, immagini)
   - ❌ Più pesante (+3 MB)
   - ❌ API più complessa
   - ❌ Meno adottato (comunità più piccola)

2. **firebase_messaging:**
   - ✅ Push notifications remote
   - ❌ Richiede backend (non necessario per promemoria locali)
   - ❌ Dipendenza da Firebase (vendor lock-in)
   - ❌ Privacy (dati escono dal dispositivo)

3. **flutter_local_notifications:**
   - ✅ Leggero (~800 KB)
   - ✅ Maturo e stabile
   - ✅ Grande comunità (migliaia di stelle)
   - ✅ API semplice e diretta
   - ✅ 100% locale (privacy totale)
   - ✅ Supporta azioni dirette in Android

**Decisione:**
- `flutter_local_notifications` è sufficiente
- Non necessitiamo push remoto
- Privacy: tutto rimane sul dispositivo

### Trade-off Considerati

#### 1. ViewModel vs BLoC

**Trade-off:**
- ❌ Perde: Separazione stretta di logica
- ✅ Guadagna: Semplicità, prestazioni, dimensione

**Mitigazione:**
- ViewModel isola sufficiente logica per testing
- I Servizi gestiscono operazioni complesse

#### 2. SQLite vs NoSQL

**Trade-off:**
- ❌ Perde: Velocità in operazioni molto semplici
- ✅ Guadagna: Query complesse, relazioni, migrazioni

**Mitigazione:**
- Gli indici ottimizzano query lente
- La cache riduce accessi al DB

#### 3. Navigator 1.0 vs 2.0

**Trade-off:**
- ❌ Perde: Deep linking avanzato
- ✅ Guadagna: Semplicità, stack esplicito

**Mitigazione:**
- MedicApp non necessita deep linking complesso
- L'app è principalmente CRUD locale

#### 4. Aggiornamenti UI-First

**Trade-off:**
- ❌ Perde: Garanzia di consistenza immediata
- ✅ Guadagna: UX istantanea (15-30x più veloce)

**Mitigazione:**
- Le operazioni sono semplici (bassa probabilità di fallimento)
- Se fallisce l'operazione async, si ripristina l'UI con messaggio

---

## Riferimenti Incrociati

- **Guida di Sviluppo:** Per iniziare a contribuire → [CONTRIBUTING.md](../CONTRIBUTING.md)
- **Documentazione di API:** Riferimento di classi → [api_reference.md](api_reference.md)
- **Cronologia dei Cambiamenti:** Migrazioni di DB → [CHANGELOG.md](../../CHANGELOG.md)
- **Testing:** Strategie di prove → [testing.md](testing.md)

---

## Conclusione

L'architettura di MedicApp prioritizza:

1. **Semplicità** sulla complessità non necessaria
2. **Prestazioni** misurabili e ottimizzate
3. **Manutenibilità** attraverso modularizzazione
4. **Privacy** con elaborazione 100% locale
5. **Scalabilità** mediante design N:N multi-persona

Questa architettura permette:
- Tempo di risposta UI < 30ms
- Supporto multi-persona con paute indipendenti
- Aggiungere nuove feature senza refactoring di strutture core
- Testing isolato di componenti
- Migrazione di database senza perdita di dati

Per contribuire al progetto mantenendo questa architettura, consulta [CONTRIBUTING.md](../CONTRIBUTING.md).
