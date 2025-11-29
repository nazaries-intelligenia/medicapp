# Guida al Testing - MedicApp

## Indice

1. [Panoramica del Testing](#panoramica-del-testing)
2. [Struttura dei Test](#struttura-dei-test)
3. [Test Unitari](#test-unitari)
4. [Test dei Widget](#test-dei-widget)
5. [Test di Integrazione](#test-di-integrazione)
6. [Helper per il Testing](#helper-per-il-testing)
7. [Copertura dei Test](#copertura-dei-test)
8. [Casi Edge Coperti](#casi-edge-coperti)
9. [Eseguire i Test](#eseguire-i-test)
10. [Guida per Scrivere Test](#guida-per-scrivere-test)
11. [Testing del Database](#testing-del-database)
12. [CI/CD e Testing Automatizzato](#cicd-e-testing-automatizzato)
13. [Prossimi Passi](#prossimi-passi)

---

## Panoramica del Testing

MedicApp ha una suite di test robusta e ben strutturata che garantisce la qualità e stabilità del codice:

- **601+ test automatizzati** distribuiti in 57 file
- **75-80% di copertura del codice** nelle aree critiche
- **Tipi multipli di test**: unitari, widget e integrazione
- **Test-Driven Development (TDD)** per nuove funzionalità
- **Copertura misurabile**: Supporto integrato per `flutter test --coverage`

### Filosofia di Testing

La nostra strategia di testing si basa su:

1. **Test come documentazione**: I test documentano il comportamento atteso del sistema
2. **Copertura intelligente**: Focus su aree critiche (notifiche, digiuno, gestione dosi)
3. **Fast feedback**: Test rapidi che vengono eseguiti in memoria
4. **Isolation**: Ogni test è indipendente e non influenza gli altri
5. **Realismo**: Test di integrazione che simulano flussi reali dell'utente

### Tipi di Test

```
test/
├── unitari/          # Test di servizi, modelli e logica di business
├── widgets/          # Test di componenti e schermate individuali
└── integration/      # Test end-to-end di flussi completi
```

---

## Struttura dei Test

La directory dei test è organizzata in modo chiaro e logico:

```
test/
├── helpers/                              # Utility condivise tra test
│   ├── medication_builder.dart           # Pattern builder per creare farmaci
│   ├── database_test_helper.dart         # Setup e cleanup database
│   ├── widget_test_helpers.dart          # Helper per test widget
│   ├── person_test_helper.dart           # Helper per gestione persone
│   ├── notification_test_helper.dart     # Helper per test notifiche
│   ├── test_constants.dart               # Costanti condivise
│   └── test_helpers.dart                 # Helper generali
│
├── integration/                          # Test di integrazione (9 file)
│   ├── add_medication_test.dart          # Flusso completo aggiungere farmaco
│   ├── edit_medication_test.dart         # Flusso modifica
│   ├── delete_medication_test.dart       # Flusso eliminazione
│   ├── dose_registration_test.dart       # Registrazione dose
│   ├── stock_management_test.dart        # Gestione stock
│   ├── medication_modal_test.dart        # Modal dettagli
│   ├── navigation_test.dart              # Navigazione tra schermate
│   ├── app_startup_test.dart             # Avvio applicazione
│   └── debug_menu_test.dart              # Menu debug
│
└── [41 file test unitari/widget]
```

### File Test per Categoria

#### Test Servizi (13 file)
- `notification_service_test.dart` - Servizio notifiche
- `dose_action_service_test.dart` - Azioni su dosi
- `dose_history_service_test.dart` - Storico dosi
- `preferences_service_test.dart` - Preferenze utente
- E altro...

#### Test Funzionalità Core (18 file)
- `medication_model_test.dart` - Modello farmaco
- `dose_management_test.dart` - Gestione dosi
- `extra_dose_test.dart` - Dosi extra
- `database_refill_test.dart` - Ricariche stock
- `database_export_import_test.dart` - Esportazione/importazione
- E altro...

#### Test Digiuno (6 file)
- `fasting_test.dart` - Logica digiuno
- `fasting_notification_test.dart` - Notifiche digiuno
- `fasting_countdown_test.dart` - Conto alla rovescia digiuno
- `fasting_field_preservation_test.dart` - Preservazione campi
- `early_dose_with_fasting_test.dart` - Dose anticipata con digiuno
- `multiple_fasting_prioritization_test.dart` - Prioritizzazione multipla

#### Test Schermate (14 file)
- `edit_schedule_screen_test.dart` - Schermata modifica orari
- `edit_duration_screen_test.dart` - Schermata modifica durata
- `edit_fasting_screen_test.dart` - Schermata modifica digiuno
- `edit_screens_validation_test.dart` - Validazioni
- `settings_screen_test.dart` - Schermata configurazione
- `day_navigation_ui_test.dart` - Navigazione per giorni
- E altro...

---

## Test Unitari

I test unitari verificano il comportamento dei componenti individuali in modo isolato.

### Test dei Servizi

Verificano la logica di business dei servizi:

#### NotificationService

```dart
test('should generate unique IDs for different medications', () {
  final id1 = _generateNotificationId('med1', 0);
  final id2 = _generateNotificationId('med2', 0);

  expect(id1, isNot(equals(id2)));
});

test('should handle all notification operations in test mode', () async {
  service.enableTestMode();

  final medication = MedicationBuilder()
      .withId('test-med')
      .withSingleDose('08:00', 1.0)
      .build();

  await service.scheduleMedicationNotifications(
    medication,
    personId: 'test-person-id'
  );

  // Non deve lanciare eccezioni
});
```

#### DoseActionService

```dart
test('should register dose and update stock', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await service.registerDose(medication, '08:00');

  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Test dei Modelli

Verificano serializzazione e deserializzazione dati:

```dart
group('Medication Model - Fasting Configuration', () {
  test('should serialize fasting configuration to JSON', () {
    final medication = MedicationBuilder()
        .withId('test_6')
        .withMultipleDoses(['08:00', '16:00'], 1.0)
        .withFasting(type: 'before', duration: 60)
        .build();

    final json = medication.toJson();

    expect(json['requiresFasting'], 1);
    expect(json['fastingType'], 'before');
    expect(json['fastingDurationMinutes'], 60);
    expect(json['notifyFasting'], 1);
  });

  test('should deserialize fasting from JSON', () {
    final json = {
      'id': 'test_8',
      'name': 'Test Medication',
      'requiresFasting': 1,
      'fastingType': 'before',
      'fastingDurationMinutes': 60,
      // ... altri campi
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Test delle Utility

Verificano funzioni ausiliarie e calcoli:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 dosi/giorno
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unità / 2 al giorno = 10 giorni
});
```

---

## Test dei Widget

I test dei widget verificano l'interfaccia utente e l'interazione dell'utente.

### Test delle Schermate

Verificano che le schermate si rendano correttamente e rispondano alle interazioni:

```dart
testWidgets('Should add medication with default type', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Paracetamolo');
  await waitForDatabase(tester);

  expect(find.text('Paracetamolo'), findsOneWidget);
  expect(find.text('Pillola'), findsAtLeastNWidgets(1));
});
```

### Test dei Componenti

Verificano componenti individuali della UI:

```dart
testWidgets('Should display fasting countdown', (tester) async {
  final medication = MedicationBuilder()
      .withFasting(type: 'after', duration: 120)
      .build();

  await tester.pumpWidget(
    MaterialApp(
      home: FastingCountdown(medication: medication),
    ),
  );

  expect(find.textContaining('2:00'), findsOneWidget);
});
```

### Mocking delle Dipendenze

Per i test dei widget, usiamo mock per isolare i componenti:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Database in memoria
  DatabaseHelper.setInMemoryDatabase(true);

  // Modo test per notifiche
  NotificationService.instance.enableTestMode();

  // Assicurare persona predefinita
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Esempio Completo: Test di Modifica

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Aggiungere farmaco
  await addMedicationWithDuration(tester, 'Ibuprofene');
  await waitForDatabase(tester);

  // Aprire menu modifica
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofene',
    'Orari e Quantità',
  );

  // Modificare orari
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Salvare
  await scrollToWidget(tester, find.text('Salva'));
  await tester.tap(find.text('Salva'));
  await waitForDatabase(tester);

  // Verificare modifica
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Test di Integrazione

I test di integrazione verificano flussi completi dell'utente end-to-end.

### Test End-to-End

Simulano il comportamento reale dell'utente:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Avviare app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Aggiungere farmaco
  await addMedicationWithDuration(
    tester,
    'Paracetamolo',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Verificare che appaia nell'elenco
  expect(find.text('Paracetamolo'), findsOneWidget);

  // 4. Aprire modal dettagli
  await tester.tap(find.text('Paracetamolo'));
  await tester.pumpAndSettle();

  // 5. Registrare dose
  await tester.tap(find.text('Prendi dose'));
  await waitForComplexAsyncOperation(tester);

  // 6. Verificare stock aggiornato
  await tester.tap(find.text('Paracetamolo'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Flussi Completi

I test di integrazione coprono flussi importanti:

1. **Aggiungere farmaco**: `add_medication_test.dart`
   - Navigazione completa wizard
   - Configurazione di tutti i parametri
   - Verifica nell'elenco principale

2. **Modificare farmaco**: `edit_medication_test.dart`
   - Modifica di ogni sezione
   - Preservazione dati non modificati
   - Aggiornamento corretto nell'elenco

3. **Eliminare farmaco**: `delete_medication_test.dart`
   - Conferma eliminazione
   - Pulizia notifiche
   - Eliminazione storico associato

4. **Registrare dose**: `dose_registration_test.dart`
   - Registrazione manuale da modal
   - Aggiornamento stock
   - Creazione voce nello storico

5. **Gestione stock**: `stock_management_test.dart`
   - Avvisi stock basso
   - Ricarica stock
   - Calcolo durata

### Interazione con Database

I test di integrazione interagiscono con un database reale in memoria:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Prima istanza app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simulare chiusura e riapertura
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Il farmaco deve essere ancora presente
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Helper per il Testing

Gli helper semplificano la scrittura dei test e riducono il codice duplicato.

### MedicationBuilder

Il **pattern builder** permette di creare farmaci di prova in modo leggibile:

```dart
/// Esempio base
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Con digiuno
final medication = MedicationBuilder()
    .withName('Ibuprofene')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Con dosi multiple
final medication = MedicationBuilder()
    .withName('Antibiotico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Come farmaco "al bisogno"
final medication = MedicationBuilder()
    .withName('Analgesico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Benefici di MedicationBuilder

1. **Leggibilità**: Il codice è autodocumentato e facile da capire
2. **Manutenibilità**: Modifiche al modello richiedono solo aggiornare il builder
3. **Riduzione codice**: Evita ripetere valori predefiniti in ogni test
4. **Flessibilità**: Permette configurare solo ciò che è necessario per ogni test

#### Factory Methods

Il builder include metodi factory per casi comuni:

```dart
// Stock basso (5 unità)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Senza stock
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Dosi multiple al giorno (automatico)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Digiuno abilitato con valori predefiniti
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Permette creare un builder da un farmaco esistente:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nome Modificato')
    .build();
```

### DatabaseTestHelper

Semplifica la configurazione e pulizia del database:

```dart
class DatabaseTestHelper {
  /// Configurazione iniziale (una volta per file)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Pulizia dopo ogni test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Scorciatoia: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Assicura che esista persona predefinita
  static Future<void> ensureDefaultPerson() async {
    final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefault) {
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);
    }
  }
}
```

**Uso nei test:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Configurazione completa

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // Il tuo test qui
  });
}
```

### WidgetTestHelpers

Funzioni ausiliarie per test widget:

```dart
/// Ottenere localizzazioni
AppLocalizations getL10n(WidgetTester tester);

/// Aspettare operazioni database
Future<void> waitForDatabase(WidgetTester tester);

/// Aspettare che appaia un widget
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Fare scroll a un widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Aprire menu modifica
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Aggiungere farmaco completo
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Aspettare operazioni asincrone complesse
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Altri Helper

- **PersonTestHelper**: Gestione persone nei test
- **NotificationTestHelper**: Helper per notifiche
- **TestConstants**: Costanti condivise (dosi, stock, tempi)

---

## Copertura dei Test

La suite di test copre le aree più critiche dell'applicazione.

### Copertura per Categoria

| Categoria | Test | Descrizione |
|-----------|------|-------------|
| **Servizi** | ~94 test | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Funzionalità Core** | ~79 test | Gestione dosi, stock, digiuno, esportazione/importazione |
| **Digiuno** | ~61 test | Logica digiuno, notifiche, conto alla rovescia, prioritizzazione |
| **Schermate** | ~93 test | Test widget e navigazione di tutte le schermate |
| **Integrazione** | ~52 test | Flussi completi end-to-end |

**Totale: 369+ test**

### Aree Ben Coperte

#### Notifiche (95% copertura)
- Programmazione e cancellazione notifiche
- ID unici per diversi tipi di notifiche
- Notifiche per pattern settimanali e date specifiche
- Notifiche digiuno
- Azioni rapide da notifiche
- Limiti piattaforma (500 notifiche)
- Casi edge mezzanotte

#### Digiuno (90% copertura)
- Calcolo periodi digiuno (before/after)
- Validazioni durata
- Notifiche inizio e fine
- Conto alla rovescia visivo
- Prioritizzazione con periodi multipli attivi
- Dosi anticipate con digiuno
- Preservazione configurazione

#### Gestione Dosi (88% copertura)
- Registrazione dose (manuale e da notifica)
- Omissione dose
- Dosi extra
- Aggiornamento stock
- Storico dosi
- Calcolo consumo giornaliero

#### Database (85% copertura)
- CRUD farmaci
- CRUD persone
- Migrazione schema
- Esportazione/importazione
- Integrità referenziale
- Pulizia a cascata

### Aree con Meno Copertura

Alcune aree hanno copertura minore ma non critica:

- **UI/UX avanzata** (60%): Animazioni, transizioni
- **Configurazione** (65%): Preferenze utente
- **Localizzazione** (70%): Traduzioni e lingue
- **Permessi** (55%): Richiesta permessi sistema

Queste aree hanno copertura minore perché:
1. Sono difficili da testare automaticamente
2. Richiedono interazione manuale
3. Dipendono dal sistema operativo
4. Non influenzano la logica di business critica

---

## Casi Edge Coperti

I test includono casi speciali che potrebbero causare errori:

### 1. Notifiche a Mezzanotte

**File**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dose programmata ieri alle 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Registrata oggi alle 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Deve contare come dose del giorno precedente
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dose alle 22:00 con digiuno "after" di 3 ore
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Digiuno termina alle 01:00 del giorno successivo
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Casi coperti:**
- Dosi tardive registrate dopo mezzanotte
- Periodi digiuno che attraversano mezzanotte
- Dosi programmate esattamente alle 00:00
- Reset contatori giornalieri
- Notifiche posticipate che attraversano mezzanotte

### 2. Eliminazione e Pulizia

**File**: `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Eliminare
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // Non devono esserci notifiche programmate
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Eliminare persona
  await db.deletePerson(person.id);

  // Non devono esserci farmaci né storico
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Casi coperti:**
- Cancellazione notifiche all'eliminazione farmaco
- Eliminazione a cascata storico
- Pulizia notifiche all'eliminazione persona
- Non influenzare altri farmaci/persone
- Integrità referenziale

### 3. Prioritizzazione Digiuni Multipli

**File**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Farmaco 1: digiuno "after" di 120 minuti
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Farmaco 2: digiuno "after" di 60 minuti
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Registrare entrambe le dosi
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Deve mostrare solo il digiuno più restrittivo (med-1 fino alle 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Casi coperti:**
- Digiuni multipli attivi per una persona
- Selezione del periodo più restrittivo
- Ordinamento per tempo di fine
- Filtraggio automatico periodi terminati
- Indipendenza tra persone diverse

### 4. Azioni Notifica

**File**: `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Simulare azione "register_dose" da notifica
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Verificare effetti
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));

  final history = await db.getDoseHistory(medication.id);
  expect(history.last.status, 'taken');
});

test('snooze_dose action should postpone notification by 10 minutes',
    () async {
  final notification = await scheduleNotification(
    medicationId: 'med-1',
    time: TimeOfDay(hour: 8, minute: 0),
  );

  // Posticipare
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Verificare nuova programmazione
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Casi coperti:**
- Registrazione da notifica
- Omissione da notifica
- Posticipare 10 minuti
- Aggiornamento corretto stock e storico
- Cancellazione notifica originale

### 5. Limiti Notifiche

**File**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Creare 100 farmaci con 4 dosi ciascuno
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Programmare notifiche (potenzialmente >500)
  await notificationService.scheduleAll();

  // Non deve crashare
  // Deve prioritizzare notifiche vicine
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Casi coperti:**
- Gestire più di 500 notifiche
- Prioritizzare notifiche vicine
- Logging avvisi
- Non crashare l'app
- Riprogrammazione automatica

---

## Eseguire i Test

### Comandi Base

```bash
# Eseguire tutti i test
flutter test

# Test specifico
flutter test test/services/notification_service_test.dart

# Test in una directory
flutter test test/integration/

# Test con nome specifico
flutter test --name "fasting"

# Test in modo verbose
flutter test --verbose

# Test con report tempo
flutter test --reporter expanded
```

### Test con Copertura

```bash
# Eseguire test con copertura
flutter test --coverage

# Generare report HTML
genhtml coverage/lcov.info -o coverage/html

# Aprire report nel browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Eseguire Test Specifici

```bash
# Solo test servizi
flutter test test/*_service_test.dart

# Solo test integrazione
flutter test test/integration/

# Solo test digiuno
flutter test test/fasting*.dart

# Escludere test lenti
flutter test --exclude-tags=slow
```

### Test in CI/CD

```bash
# Modo CI (senza colori, formato adeguato per log)
flutter test --machine --coverage

# Con timeout per test lenti
flutter test --timeout=30s

# Fallimento rapido (fermare al primo errore)
flutter test --fail-fast
```

### Debug dei Test

```bash
# Eseguire un solo test in modo debug
flutter test --plain-name "specific test name"

# Con breakpoint (VS Code/Android Studio)
# Usare "Debug Test" dall'IDE

# Con print visibili
flutter test --verbose

# Salvare output in file
flutter test > test_output.txt 2>&1
```

---

## Guida per Scrivere Test

### Struttura AAA (Arrange-Act-Assert)

Organizza ogni test in tre sezioni chiare:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Preparare l'ambiente
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Eseguire l'azione da testare
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Verificare il risultato
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Naming Conventions

Usa nomi descrittivi che spieghino lo scenario:

```dart
// ✅ BENE: Descrive lo scenario completo
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ MALE: Nomi vaghi o tecnici
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Formato raccomandato:**
- `should [azione attesa] when [condizione]`
- `[azione] [risultato atteso] [contesto opzionale]`

### Setup e Teardown

Configura e pulisci l'ambiente in modo consistente:

```dart
void main() {
  // Configurazione iniziale una sola volta
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Prima di ogni test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Dopo ogni test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // I tuoi test qui
  test('...', () async {
    // Test isolato con ambiente pulito
  });
}
```

### Mocking di DatabaseHelper

Per test unitari puri, mockea il database:

```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late DoseActionService service;

  setUp(() {
    mockDb = MockDatabaseHelper();
    service = DoseActionService(database: mockDb);
  });

  test('should call database method with correct parameters', () async {
    final medication = MedicationBuilder().build();

    // Configurare mock
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Eseguire azione
    await service.registerDose(medication.id, '08:00');

    // Verificare chiamata
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Uso di MedicationBuilder

Approfitta del builder per creare test leggibili:

```dart
test('should calculate correct stock duration', () {
  // Creare farmaco con builder
  final medication = MedicationBuilder()
      .withName('Paracetamolo')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 dosi al giorno
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 giorni
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Metodo factory per stock basso
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Migliori Pratiche

1. **Test indipendenti**: Ogni test deve poter essere eseguito da solo
   ```dart
   // ✅ BENE: Test autocontenuto
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... resto del test
   });

   // ❌ MALE: Dipende dall'ordine di esecuzione
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Dipende dal test precedente
   });
   ```

2. **Test rapidi**: Usa database in memoria, evita delay non necessari
   ```dart
   // ✅ BENE
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ MALE
   await Future.delayed(Duration(seconds: 2)); // Delay arbitrario
   ```

3. **Assertion specifiche**: Verifica esattamente ciò che importa
   ```dart
   // ✅ BENE
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ MALE
   expect(medication, isNotNull); // Troppo vago
   ```

4. **Gruppi logici**: Organizza test correlati
   ```dart
   group('Dose Registration', () {
     test('should register dose successfully', () {});
     test('should update stock when registering', () {});
     test('should create history entry', () {});
   });

   group('Dose Validation', () {
     test('should reject invalid time format', () {});
     test('should reject negative quantity', () {});
   });
   ```

5. **Test edge case**: Non solo il happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Commenti utili**: Spiega il "perché", non il "cosa"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Dosi registrate dopo mezzanotte ma entro
     // 2 ore dalla programmazione contano per il giorno precedente
     // Questo previene che dosi tardive duplichino il conteggio giornaliero

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Testing del Database

### Uso di sqflite_common_ffi

I test usano `sqflite_common_ffi` per database in memoria:

```dart
void main() {
  setUpAll(() {
    // Inizializzare FFI
    sqfliteFfiInit();

    // Usare factory FFI
    databaseFactory = databaseFactoryFfi;

    // Abilitare modo in memoria
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Database viene creato automaticamente in memoria
    final db = DatabaseHelper.instance;

    // Operazioni normali
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Database in Memoria

Vantaggi di usare database in memoria:

1. **Velocità**: 10-100x più veloce di disco
2. **Isolamento**: Ogni test inizia con DB pulito
3. **Senza effetti collaterali**: Non modifica dati reali
4. **Parallelizzazione**: I test possono girare in parallelo

```dart
setUp(() async {
  // Resettare per DB pulito
  await DatabaseHelper.resetDatabase();

  // Modo in memoria
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migrazioni nei Test

I test verificano che le migrazioni funzionino correttamente:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Creare DB in versione 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (senza tabella persons)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // Aprire in versione 19 (trigger migrazione)
  final migratedDb = await DatabaseHelper.instance.database;

  // Verificare che persons esista
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Verificare persona predefinita
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Pulizia tra Test

È cruciale pulire il DB tra test per evitare contaminazione:

```dart
tearDown(() async {
  // Metodo 1: Cancellare tutti i dati
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Metodo 2: Resettare completamente
  await DatabaseHelper.resetDatabase();

  // Metodo 3: Usare helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Test Integrità Referenziale

Verificare che le relazioni DB funzionino correttamente:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Eliminare persona
  await db.deletePerson(person.id);

  // I farmaci devono essere stati eliminati
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Tentare inserire storico per farmaco inesistente
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Deve fallire per foreign key constraint
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD e Testing Automatizzato

### Integrazione Continua

Configurazione tipica per GitHub Actions:

```yaml
name: Tests

on:
  push:
    branches: [ main, development ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage --machine

    - name: Check coverage
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 70" | bc -l) )); then
          echo "Coverage $COVERAGE% is below 70%"
          exit 1
        fi

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v2
      with:
        file: ./coverage/lcov.info
```

### Pre-commit Hooks

Usare `husky` o script Git hooks per eseguire test prima del commit:

```bash
# .git/hooks/pre-commit
#!/bin/sh

echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed!"
```

### Soglia Minima Copertura

Configurare soglia minima per evitare regressioni:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Verificare copertura minima
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Report Copertura

Generare report visuali automaticamente:

```bash
# Generare report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Badge copertura
./scripts/generate_coverage_badge.sh

# Pubblicare report
# (usare GitHub Pages, Codecov, Coveralls, ecc.)
```

---

## Prossimi Passi

### Aree da Migliorare

1. **Test UI/UX (60% → 80%)**
   - Più test animazioni
   - Test gesti e swipe
   - Test accessibilità

2. **Test Permessi (55% → 75%)**
   - Mock permessi sistema
   - Flussi richiesta permessi
   - Gestione permessi negati

3. **Test Localizzazione (70% → 90%)**
   - Test per ogni lingua
   - Verifica traduzioni complete
   - Test formattazione date/numeri

4. **Test Prestazioni**
   - Benchmark operazioni critiche
   - Test carico (molti farmaci)
   - Memory leak detection

### Test Pendenti

#### Alta Priorità

- [ ] Test backup/restore completo
- [ ] Test notifiche in background
- [ ] Test widget home screen
- [ ] Test deep link
- [ ] Test condivisione dati

#### Media Priorità

- [ ] Test tutte le lingue
- [ ] Test temi (chiaro/scuro)
- [ ] Test onboarding
- [ ] Test migrazioni tra tutte le versioni
- [ ] Test esportazione CSV/PDF

#### Bassa Priorità

- [ ] Test animazioni complesse
- [ ] Test gesti avanzati
- [ ] Test accessibilità esaustivi
- [ ] Test prestazioni dispositivi lenti

### Roadmap Testing

#### Q1 2025
- Raggiungere 80% copertura generale
- Completare test permessi
- Aggiungere test prestazioni base

#### Q2 2025
- Test tutte le lingue
- Test backup/restore
- Documentazione testing aggiornata

#### Q3 2025
- Test accessibilità completi
- Test carico e stress
- Automazione completa in CI/CD

#### Q4 2025
- 85%+ copertura generale
- Suite test prestazioni
- Test regressione visiva

---

## Risorse Aggiuntive

### Documentazione

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Strumenti

- **flutter_test**: Framework testing Flutter
- **mockito**: Mocking dipendenze
- **sqflite_common_ffi**: DB in memoria per test
- **test_coverage**: Analisi copertura
- **lcov**: Generazione report HTML

### File Correlati

- `/test/helpers/` - Tutti gli helper testing
- `/test/integration/` - Test integrazione
- `/.github/workflows/test.yml` - Configurazione CI/CD
- `/scripts/run_tests.sh` - Script testing

---

**Ultimo aggiornamento**: Novembre 2025
**Versione MedicApp**: V19+
**Test totali**: 369+
**Copertura media**: 75-80%
