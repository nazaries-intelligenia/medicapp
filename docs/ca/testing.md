# Guia de Testing - MedicApp

## Taula de Continguts

1. [Visió General del Testing](#visió-general-del-testing)
2. [Estructura de Tests](#estructura-de-tests)
3. [Tests Unitaris](#tests-unitaris)
4. [Tests de Widgets](#tests-de-widgets)
5. [Tests d'Integració](#tests-dintegració)
6. [Helpers de Testing](#helpers-de-testing)
7. [Cobertura de Tests](#cobertura-de-tests)
8. [Casos Edge Coberts](#casos-edge-coberts)
9. [Executar Tests](#executar-tests)
10. [Guia per Escriure Tests](#guia-per-escriure-tests)
11. [Testing de Base de Dades](#testing-de-base-de-dades)
12. [CI/CD i Testing Automatitzat](#cicd-i-testing-automatitzat)
13. [Propers Passos](#propers-passos)

---

## Visió General del Testing

MedicApp compta amb una suite de tests robusta i ben estructurada que garanteix la qualitat i estabilitat del codi:

- **369+ tests automatitzats** distribuïts en 50 arxius
- **75-80% de cobertura de codi** en àrees crítiques
- **Múltiples tipus de tests**: unitaris, widgets i integració
- **Test-Driven Development (TDD)** per a noves funcionalitats

### Filosofia de Testing

La nostra estratègia de testing es basa en:

1. **Tests com a documentació**: Els tests documenten el comportament esperat del sistema
2. **Cobertura intel·ligent**: Enfocament en àrees crítiques (notificacions, dejuni, gestió de dosis)
3. **Fast feedback**: Tests ràpids que s'executen en memòria
4. **Isolation**: Cada test és independent i no afecta a altres
5. **Realisme**: Tests d'integració que simulen fluxos reals d'usuari

### Tipus de Tests

```
test/
├── unitaris/          # Tests de serveis, models i lògica de negoci
├── widgets/            # Tests de components i pantalles individuals
└── integration/        # Tests end-to-end de fluxos complets
```

---

## Estructura de Tests

El directori de tests està organitzat de forma clara i lògica:

```
test/
├── helpers/                              # Utilitats compartides entre tests
│   ├── medication_builder.dart           # Builder pattern per crear medicaments
│   ├── database_test_helper.dart         # Setup i cleanup de base de dades
│   ├── widget_test_helpers.dart          # Helpers per a tests de widgets
│   ├── person_test_helper.dart           # Helpers per a gestió de persones
│   ├── notification_test_helper.dart     # Helpers per a tests de notificacions
│   ├── test_constants.dart               # Constants compartides
│   └── test_helpers.dart                 # Helpers generals
│
├── integration/                          # Tests d'integració (9 arxius)
│   ├── add_medication_test.dart          # Flux complet d'afegir medicament
│   ├── edit_medication_test.dart         # Flux d'edició
│   ├── delete_medication_test.dart       # Flux d'eliminació
│   ├── dose_registration_test.dart       # Registre de dosi
│   ├── stock_management_test.dart        # Gestió d'estoc
│   ├── medication_modal_test.dart        # Modal de detalls
│   ├── navigation_test.dart              # Navegació entre pantalles
│   ├── app_startup_test.dart             # Inici d'aplicació
│   └── debug_menu_test.dart              # Menú de depuració
│
└── [41 arxius de tests unitaris/widgets]
```

### Arxius de Tests per Categoria

#### Tests de Serveis (13 arxius)
- `notification_service_test.dart` - Servei de notificacions
- `dose_action_service_test.dart` - Accions sobre dosis
- `dose_history_service_test.dart` - Historial de dosis
- `preferences_service_test.dart` - Preferències d'usuari
- I més...

#### Tests de Funcionalitat Core (18 arxius)
- `medication_model_test.dart` - Model de medicament
- `dose_management_test.dart` - Gestió de dosis
- `extra_dose_test.dart` - Dosi extra
- `database_refill_test.dart` - Recàrregues d'estoc
- `database_export_import_test.dart` - Exportació/importació
- I més...

#### Tests de Dejuni (6 arxius)
- `fasting_test.dart` - Lògica de dejuni
- `fasting_notification_test.dart` - Notificacions de dejuni
- `fasting_countdown_test.dart` - Compte enrere de dejuni
- `fasting_field_preservation_test.dart` - Preservació de camps
- `early_dose_with_fasting_test.dart` - Dosi anticipada amb dejuni
- `multiple_fasting_prioritization_test.dart` - Priorització múltiple

#### Tests de Pantalles (14 arxius)
- `edit_schedule_screen_test.dart` - Pantalla d'edició d'horaris
- `edit_duration_screen_test.dart` - Pantalla d'edició de durada
- `edit_fasting_screen_test.dart` - Pantalla d'edició de dejuni
- `edit_screens_validation_test.dart` - Validacions
- `settings_screen_test.dart` - Pantalla de configuració
- `day_navigation_ui_test.dart` - Navegació per dies
- I més...

---

## Tests Unitaris

Els tests unitaris verifiquen el comportament de components individuals de forma aïllada.

### Tests de Serveis

Verifiquen la lògica de negoci dels serveis:

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

  // No ha de llançar excepcions
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

### Tests de Models

Verifiquen la serialització i deserialització de dades:

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
      // ... altres camps
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Tests d'Utilitats

Verifiquen funcions auxiliars i càlculs:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 dosis/dia
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unitats / 2 per dia = 10 dies
});
```

---

## Tests de Widgets

Els tests de widgets verifiquen la interfície d'usuari i la interacció de l'usuari.

### Tests de Pantalles

Verifiquen que les pantalles es renderitzen correctament i responen a les interaccions:

```dart
testWidgets('Should add medication with default type', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Paracetamol');
  await waitForDatabase(tester);

  expect(find.text('Paracetamol'), findsOneWidget);
  expect(find.text('Pastilla'), findsAtLeastNWidgets(1));
});
```

### Tests de Components

Verifiquen components individuals de la UI:

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

### Mocking de Dependències

Per a tests de widgets, usem mocks per aïllar components:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Base de dades en memòria
  DatabaseHelper.setInMemoryDatabase(true);

  // Mode de prova per a notificacions
  NotificationService.instance.enableTestMode();

  // Assegurar persona per defecte
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Exemple Complet: Test d'Edició

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Afegir medicament
  await addMedicationWithDuration(tester, 'Ibuprofèn');
  await waitForDatabase(tester);

  // Obrir menú d'edició
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofèn',
    'Horaris i Quantitats',
  );

  // Modificar horaris
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Guardar
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Verificar canvi
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Tests d'Integració

Els tests d'integració verifiquen fluxos complets d'usuari end-to-end.

### Tests End-to-End

Simulen el comportament real de l'usuari:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Iniciar app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Afegir medicament
  await addMedicationWithDuration(
    tester,
    'Paracetamol',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Verificar que apareix a llista
  expect(find.text('Paracetamol'), findsOneWidget);

  // 4. Obrir modal de detalls
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  // 5. Registrar dosi
  await tester.tap(find.text('Prendre dosi'));
  await waitForComplexAsyncOperation(tester);

  // 6. Verificar estoc actualitzat
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Fluxos Complets

Els tests d'integració cobreixen fluxos importants:

1. **Agregar medicament**: `add_medication_test.dart`
   - Navegació completa del wizard
   - Configuració de tots els paràmetres
   - Verificació a llista principal

2. **Editar medicament**: `edit_medication_test.dart`
   - Modificació de cada secció
   - Preservació de dades no modificades
   - Actualització correcta a llista

3. **Eliminar medicament**: `delete_medication_test.dart`
   - Confirmació d'eliminació
   - Neteja de notificacions
   - Eliminació d'historial associat

4. **Registrar dosi**: `dose_registration_test.dart`
   - Registre manual des de modal
   - Actualització d'estoc
   - Creació d'entrada a historial

5. **Gestió d'estoc**: `stock_management_test.dart`
   - Alertes d'estoc baix
   - Recàrrega d'estoc
   - Càlcul de durada

### Interacció amb Base de Dades

Els tests d'integració interactuen amb una base de dades real en memòria:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Primera instància de l'app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simular tancament i reapertura
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medicament ha de continuar present
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Helpers de Testing

Els helpers simplifiquen l'escriptura de tests i redueixen codi duplicat.

### MedicationBuilder

El **patró builder** permet crear medicaments de prova de forma llegible:

```dart
/// Exemple bàsic
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Amb dejuni
final medication = MedicationBuilder()
    .withName('Ibuprofèn')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Amb múltiples dosis
final medication = MedicationBuilder()
    .withName('Antibiòtic')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Com a medicament "a demanda"
final medication = MedicationBuilder()
    .withName('Analgèsic')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Beneficis de MedicationBuilder

1. **Llegibilitat**: El codi és autodocumentat i fàcil d'entendre
2. **Mantenibilitat**: Canvis al model només requereixen actualitzar el builder
3. **Reducció de codi**: Evita repetir valors per defecte a cada test
4. **Flexibilitat**: Permet configurar només el necessari per a cada test

#### Factory Methods

El builder inclou mètodes de fàbrica per a casos comuns:

```dart
// Estoc baix (5 unitats)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Sense estoc
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Múltiples dosis al dia (automàtic)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Dejuni habilitat amb valors per defecte
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Permet crear un builder a partir d'un medicament existent:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nom Modificat')
    .build();
```

### DatabaseTestHelper

Simplifica la configuració i neteja de la base de dades:

```dart
class DatabaseTestHelper {
  /// Configuració inicial (una vegada per arxiu)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Neteja després de cada test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Drecera: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Assegura que existeix persona per defecte
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

**Ús en tests:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Configuració completa

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // El teu test aquí
  });
}
```

### WidgetTestHelpers

Funcions auxiliars per a tests de widgets:

```dart
/// Obtenir localitzacions
AppLocalizations getL10n(WidgetTester tester);

/// Esperar operacions de base de dades
Future<void> waitForDatabase(WidgetTester tester);

/// Esperar a que aparegui un widget
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Fer scroll a un widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Obrir menú d'edició
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Afegir medicament complet
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Esperar operacions asíncrones complexes
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Altres Helpers

- **PersonTestHelper**: Gestió de persones en tests
- **NotificationTestHelper**: Helpers per a notificacions
- **TestConstants**: Constants compartides (dosis, stocks, temps)

---

## Cobertura de Tests

La suite de tests cobreix les àrees més crítiques de l'aplicació.

### Cobertura per Categoria

| Categoria | Tests | Descripció |
|-----------|-------|-------------|
| **Serveis** | ~94 tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Funcionalitat Core** | ~79 tests | Gestió de dosis, estoc, dejuni, exportació/importació |
| **Dejuni** | ~61 tests | Lògica de dejuni, notificacions, compte enrere, priorització |
| **Pantalles** | ~93 tests | Tests de widgets i navegació de totes les pantalles |
| **Integració** | ~52 tests | Fluxos complets end-to-end |

**Total: 369+ tests**

### Àrees Ben Cobertes

#### Notificacions (95% cobertura)
- Programació i cancel·lació de notificacions
- IDs únics per a diferents tipus de notificacions
- Notificacions per a patrons setmanals i dates específiques
- Notificacions de dejuni
- Accions ràpides des de notificacions
- Límits de plataforma (500 notificacions)
- Casos edge de mitjanit

#### Dejuni (90% cobertura)
- Càlcul de períodes de dejuni (before/after)
- Validacions de durada
- Notificacions d'inici i fi
- Compte enrere visual
- Priorització amb múltiples períodes actius
- Dosis anticipades amb dejuni
- Preservació de configuració

#### Gestió de Dosis (88% cobertura)
- Registre de dosi (manual i des de notificació)
- Omissió de dosi
- Dosi extra
- Actualització d'estoc
- Historial de dosis
- Càlcul de consum diari

#### Base de Dades (85% cobertura)
- CRUD de medicaments
- CRUD de persones
- Migració d'esquema
- Exportació/importació
- Integritat referencial
- Neteja en cascada

### Àrees amb Menys Cobertura

Algunes àrees tenen cobertura menor però no crítica:

- **UI/UX avançada** (60%): Animacions, transicions
- **Configuració** (65%): Preferències d'usuari
- **Localització** (70%): Traduccions i idiomes
- **Permisos** (55%): Sol·licitud de permisos de sistema

Aquestes àrees tenen menor cobertura perquè:
1. Són difícils de testejar automàticament
2. Requereixen interacció manual
3. Depenen del sistema operatiu
4. No afecten la lògica de negoci crítica

---

## Casos Edge Coberts

Els tests inclouen casos especials que podrien causar errors:

### 1. Notificacions a Mitjanit

**Arxiu**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dosi programada ahir a les 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Registrada avui a les 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Ha de comptar com a dosi del dia anterior
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dosi a les 22:00 amb dejuni "after" de 3 hores
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Dejuni acaba a la 01:00 del dia següent
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Casos coberts:**
- Dosis tardanes registrades després de mitjanit
- Períodes de dejuni que creuen mitjanit
- Dosis programades exactament a les 00:00
- Reset de comptadors diaris
- Notificacions posposades que creuen mitjanit

### 2. Eliminació i Neteja

**Arxiu**: `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Eliminar
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // No hi ha d'haver notificacions programades
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Eliminar persona
  await db.deletePerson(person.id);

  // No hi ha d'haver medicaments ni historial
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Casos coberts:**
- Cancel·lació de notificacions en eliminar medicament
- Eliminació en cascada d'historial
- Neteja de notificacions en eliminar persona
- No afectar altres medicaments/persones
- Integritat referencial

### 3. Priorització de Múltiples Dejunis

**Arxiu**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Medicament 1: dejuni "after" de 120 minuts
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Medicament 2: dejuni "after" de 60 minuts
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Registrar ambdues dosis
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Només ha de mostrar el dejuni més restrictiu (med-1 fins 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Casos coberts:**
- Múltiples dejunis actius per a una persona
- Selecció del període més restrictiu
- Ordenació per temps de finalització
- Filtrat automàtic de períodes acabats
- Independència entre persones diferents

### 4. Accions de Notificació

**Arxiu**: `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Simular acció "register_dose" des de notificació
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Verificar efectes
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

  // Posposar
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Verificar nova programació
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Casos coberts:**
- Registre des de notificació
- Omissió des de notificació
- Posposar 10 minuts
- Actualització correcta d'estoc i historial
- Cancel·lació de notificació original

### 5. Límits de Notificacions

**Arxiu**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Crear 100 medicaments amb 4 dosis cadascun
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Programar notificacions (potencialment >500)
  await notificationService.scheduleAll();

  // No ha de crashar
  // Ha de prioritzar notificacions properes
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Casos coberts:**
- Gestionar més de 500 notificacions
- Prioritzar notificacions properes
- Logging d'advertiments
- No crashar l'app
- Reprogramació automàtica

---

## Executar Tests

### Comandaments Bàsics

```bash
# Executar tots els tests
flutter test

# Test específic
flutter test test/services/notification_service_test.dart

# Tests en un directori
flutter test test/integration/

# Tests amb nom específic
flutter test --name "fasting"

# Tests en mode verbose
flutter test --verbose

# Tests amb informe de temps
flutter test --reporter expanded
```

### Tests amb Cobertura

```bash
# Executar tests amb cobertura
flutter test --coverage

# Generar informe HTML
genhtml coverage/lcov.info -o coverage/html

# Obrir informe en navegador
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Executar Tests Específics

```bash
# Només tests de serveis
flutter test test/*_service_test.dart

# Només tests d'integració
flutter test test/integration/

# Només tests de dejuni
flutter test test/fasting*.dart

# Excloure tests lents
flutter test --exclude-tags=slow
```

### Tests en CI/CD

```bash
# Mode CI (sense color, format adequat per a logs)
flutter test --machine --coverage

# Amb timeout per a tests lents
flutter test --timeout=30s

# Fall ràpid (aturar al primer error)
flutter test --fail-fast
```

### Depuració de Tests

```bash
# Executar un sol test en mode debug
flutter test --plain-name "specific test name"

# Amb breakpoints (VS Code/Android Studio)
# Usar "Debug Test" des de l'IDE

# Amb prints visibles
flutter test --verbose

# Guardar output a arxiu
flutter test > test_output.txt 2>&1
```

---

## Guia per Escriure Tests

### Estructura AAA (Arrange-Act-Assert)

Organitza cada test en tres seccions clares:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Preparar l'entorn
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Executar l'acció a testejar
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Verificar el resultat
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Naming Conventions

Usa noms descriptius que expliquin l'escenari:

```dart
// ✅ BÉ: Descriu l'escenari complet
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ MALAMENT: Noms vagues o tècnics
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Format recomanat:**
- `should [acció esperada] when [condició]`
- `[acció] [resultat esperat] [context opcional]`

### Setup i Teardown

Configura i neteja l'entorn de forma consistent:

```dart
void main() {
  // Configuració inicial una sola vegada
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Abans de cada test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Després de cada test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Els teus tests aquí
  test('...', () async {
    // Test aïllat amb ambient net
  });
}
```

### Mocking de DatabaseHelper

Per a tests unitaris purs, mockea la base de dades:

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

    // Configurar mock
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Executar acció
    await service.registerDose(medication.id, '08:00');

    // Verificar crida
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Ús de MedicationBuilder

Aprofita el builder per crear tests llegibles:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Crear medicament amb builder
final med = MedicationBuilder()
  .withName('Paracetamol')
  .withStock(30.0)
  .withMultipleDosesPerDay(3) // 3 dosis al dia
  .build();

final duration = calculateStockDays(medication);

expect(duration, 10); // 30 / 3 = 10 dies
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory method per a estoc baix
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Millors Pràctiques

1. **Tests independents**: Cada test ha de poder executar-se sol
   ```dart
   // ✅ BÉ: Test autocontingut
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... resta del test
   });

   // ❌ MALAMENT: Depèn d'ordre d'execució
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Depèn del test anterior
   });
   ```

2. **Tests ràpids**: Usa base de dades en memòria, evita delays innecessaris
   ```dart
   // ✅ BÉ
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ MALAMENT
   await Future.delayed(Duration(seconds: 2)); // Delay arbitrari
   ```

3. **Assertions específiques**: Verifica exactament el que importa
   ```dart
   // ✅ BÉ
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ MALAMENT
   expect(medication, isNotNull); // Massa vague
   ```

4. **Grups lògics**: Organitza tests relacionats
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

5. **Test edge cases**: No només el happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Comentaris útils**: Explica el "per què", no el "què"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Dosis registrades després de mitjanit però dins de
     // 2 hores de la programació compten per al dia anterior
     // Això prevé que dosis tardanes dupliquin el comptatge diari

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Testing de Base de Dades

### Ús de sqflite_common_ffi

Els tests usen `sqflite_common_ffi` per a base de dades en memòria:

```dart
void main() {
  setUpAll(() {
    // Inicialitzar FFI
    sqfliteFfiInit();

    // Usar factory FFI
    databaseFactory = databaseFactoryFfi;

    // Habilitar mode en memòria
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Base de dades es crea automàticament en memòria
    final db = DatabaseHelper.instance;

    // Operacions normals
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Base de Dades en Memòria

Avantatges d'usar base de dades en memòria:

1. **Velocitat**: 10-100x més ràpid que disc
2. **Aïllament**: Cada test comença amb BD neta
3. **Sense efectes secundaris**: No modifica dades reals
4. **Paral·lelització**: Tests poden córrer en paral·lel

```dart
setUp(() async {
  // Reset per a BD neta
  await DatabaseHelper.resetDatabase();

  // Mode en memòria
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migracions en Tests

Els tests verifiquen que les migracions funcionen correctament:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Crear BD en versió 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (sense taula persons)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // Obrir en versió 19 (trigger migració)
  final migratedDb = await DatabaseHelper.instance.database;

  // Verificar que persons existeix
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Verificar persona per defecte
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Neteja entre Tests

És crucial netejar la BD entre tests per evitar contaminació:

```dart
tearDown(() async {
  // Mètode 1: Esborrar totes les dades
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Mètode 2: Reset completament
  await DatabaseHelper.resetDatabase();

  // Mètode 3: Usar helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Tests d'Integritat Referencial

Verificar que les relacions de BD funcionen correctament:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Eliminar persona
  await db.deletePerson(person.id);

  // Medicaments s'han d'haver eliminat
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Intentar inserir historial per a medicament inexistent
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Ha de fallar per foreign key constraint
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD i Testing Automatitzat

### Integració Contínua

Configuració típica per a GitHub Actions:

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

Usar `husky` o scripts Git hooks per executar tests abans de commit:

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

### Llindar Mínim de Cobertura

Configurar llindar mínim per evitar regressions:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Verificar cobertura mínima
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Informes de Cobertura

Generar informes visuals automàticament:

```bash
# Generar informe
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Badge de cobertura
./scripts/generate_coverage_badge.sh

# Publicar informe
# (usar GitHub Pages, Codecov, Coveralls, etc.)
```

---

## Propers Passos

### Àrees a Millorar

1. **Tests de UI/UX (60% → 80%)**
   - Més tests d'animacions
   - Tests de gestos i swipes
   - Tests d'accessibilitat

2. **Tests de Permisos (55% → 75%)**
   - Mock de permisos del sistema
   - Fluxos de sol·licitud de permisos
   - Gestió de permisos denegats

3. **Tests de Localització (70% → 90%)**
   - Tests per a cada idioma
   - Verificació de traduccions completes
   - Tests de formatatge de dates/números

4. **Tests de Rendiment**
   - Benchmarks d'operacions crítiques
   - Tests de càrrega (molts medicaments)
   - Memory leak detection

### Tests Pendents

#### Alta Prioritat

- [ ] Tests de backup/restore complet
- [ ] Tests de notificacions en background
- [ ] Tests de widget de home screen
- [ ] Tests de deep links
- [ ] Tests de compartir dades

#### Mitjana Prioritat

- [ ] Tests de tots els idiomes
- [ ] Tests de temes (clar/fosc)
- [ ] Tests d'onboarding
- [ ] Tests de migracions entre totes les versions
- [ ] Tests d'exportació a CSV/PDF

#### Baixa Prioritat

- [ ] Tests d'animacions complexes
- [ ] Tests de gestos avançats
- [ ] Tests d'accessibilitat exhaustius
- [ ] Tests de rendiment en dispositius lents

### Roadmap de Testing

#### Q1 2025
- Assolir 80% de cobertura general
- Completar tests de permisos
- Afegir tests de rendiment bàsics

#### Q2 2025
- Tests de tots els idiomes
- Tests de backup/restore
- Documentació de testing actualitzada

#### Q3 2025
- Tests d'accessibilitat complets
- Tests de càrrega i estrès
- Automatització completa en CI/CD

#### Q4 2025
- 85%+ cobertura general
- Suite de tests de rendiment
- Tests de regressió visual

---

## Recursos Addicionals

### Documentació

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Eines

- **flutter_test**: Framework de testing de Flutter
- **mockito**: Mocking de dependències
- **sqflite_common_ffi**: BD en memòria per a tests
- **test_coverage**: Anàlisi de cobertura
- **lcov**: Generació d'informes HTML

### Arxius Relacionats

- `/test/helpers/` - Tots els helpers de testing
- `/test/integration/` - Tests d'integració
- `/.github/workflows/test.yml` - Configuració CI/CD
- `/scripts/run_tests.sh` - Scripts de testing

---

**Última actualització**: Novembre 2025
**Versió de MedicApp**: V19+
**Tests totals**: 369+
**Cobertura mitjana**: 75-80%
