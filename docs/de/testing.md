# Testing-Leitfaden - MedicApp

## Inhaltsverzeichnis

1. [Übersicht über das Testing](#übersicht-über-das-testing)
2. [Test-Struktur](#test-struktur)
3. [Unit-Tests](#unit-tests)
4. [Widget-Tests](#widget-tests)
5. [Integrationstests](#integrationstests)
6. [Testing-Helfer](#testing-helfer)
7. [Test-Abdeckung](#test-abdeckung)
8. [Abgedeckte Edge Cases](#abgedeckte-edge-cases)
9. [Tests ausführen](#tests-ausführen)
10. [Leitfaden zum Schreiben von Tests](#leitfaden-zum-schreiben-von-tests)
11. [Datenbank-Testing](#datenbank-testing)
12. [CI/CD und automatisiertes Testing](#cicd-und-automatisiertes-testing)
13. [Nächste Schritte](#nächste-schritte)

---

## Übersicht über das Testing

MedicApp verfügt über eine robuste und gut strukturierte Test-Suite, die Codequalität und -stabilität gewährleistet:

- **369+ automatisierte Tests** verteilt auf 50 Dateien
- **75-80% Code-Abdeckung** in kritischen Bereichen
- **Mehrere Testtypen**: Unit-, Widget- und Integrationstests
- **Test-Driven Development (TDD)** für neue Funktionen

### Testing-Philosophie

Unsere Testing-Strategie basiert auf:

1. **Tests als Dokumentation**: Tests dokumentieren das erwartete Systemverhalten
2. **Intelligente Abdeckung**: Fokus auf kritische Bereiche (Benachrichtigungen, Fasten, Dosisverwaltung)
3. **Schnelles Feedback**: Schnelle Tests, die im Speicher ausgeführt werden
4. **Isolation**: Jeder Test ist unabhängig und beeinflusst keine anderen
5. **Realismus**: Integrationstests, die echte Benutzerflows simulieren

### Testtypen

```
test/
├── unitarios/          # Tests für Services, Modelle und Geschäftslogik
├── widgets/            # Tests für einzelne Komponenten und Bildschirme
└── integration/        # End-to-End-Tests für vollständige Flows
```

---

## Test-Struktur

Das Test-Verzeichnis ist klar und logisch organisiert:

```
test/
├── helpers/                              # Gemeinsame Utilities zwischen Tests
│   ├── medication_builder.dart           # Builder-Pattern zum Erstellen von Medikamenten
│   ├── database_test_helper.dart         # Setup und Cleanup der Datenbank
│   ├── widget_test_helpers.dart          # Helfer für Widget-Tests
│   ├── person_test_helper.dart           # Helfer für Personenverwaltung
│   ├── notification_test_helper.dart     # Helfer für Benachrichtigungstests
│   ├── test_constants.dart               # Gemeinsame Konstanten
│   └── test_helpers.dart                 # Allgemeine Helfer
│
├── integration/                          # Integrationstests (9 Dateien)
│   ├── add_medication_test.dart          # Vollständiger Flow zum Hinzufügen von Medikamenten
│   ├── edit_medication_test.dart         # Bearbeitungsflow
│   ├── delete_medication_test.dart       # Löschflow
│   ├── dose_registration_test.dart       # Dosisregistrierung
│   ├── stock_management_test.dart        # Bestandsverwaltung
│   ├── medication_modal_test.dart        # Details-Modal
│   ├── navigation_test.dart              # Navigation zwischen Bildschirmen
│   ├── app_startup_test.dart             # Anwendungsstart
│   └── debug_menu_test.dart              # Debug-Menü
│
└── [41 Unit-/Widget-Testdateien]
```

### Testdateien nach Kategorie

#### Service-Tests (13 Dateien)
- `notification_service_test.dart` - Benachrichtigungsservice
- `dose_action_service_test.dart` - Aktionen für Dosen
- `dose_history_service_test.dart` - Dosisverlauf
- `preferences_service_test.dart` - Benutzereinstellungen
- Und mehr...

#### Core-Funktionalitätstests (18 Dateien)
- `medication_model_test.dart` - Medikamentenmodell
- `dose_management_test.dart` - Dosisverwaltung
- `extra_dose_test.dart` - Extradosen
- `database_refill_test.dart` - Bestandsaufstockungen
- `database_export_import_test.dart` - Export/Import
- Und mehr...

#### Fasten-Tests (6 Dateien)
- `fasting_test.dart` - Fastenlogik
- `fasting_notification_test.dart` - Fastenbenachrichtigungen
- `fasting_countdown_test.dart` - Fasten-Countdown
- `fasting_field_preservation_test.dart` - Felderhaltung
- `early_dose_with_fasting_test.dart` - Vorzeitige Dosis mit Fasten
- `multiple_fasting_prioritization_test.dart` - Mehrfach-Priorisierung

#### Bildschirm-Tests (14 Dateien)
- `edit_schedule_screen_test.dart` - Zeitplanbearbeitungsbildschirm
- `edit_duration_screen_test.dart` - Dauerbearbeitungsbildschirm
- `edit_fasting_screen_test.dart` - Fastenbearbeitungsbildschirm
- `edit_screens_validation_test.dart` - Validierungen
- `settings_screen_test.dart` - Einstellungsbildschirm
- `day_navigation_ui_test.dart` - Tagesnavigation
- Und mehr...

---

## Unit-Tests

Unit-Tests überprüfen das Verhalten einzelner Komponenten isoliert.

### Service-Tests

Überprüfen die Geschäftslogik der Services:

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

  // Sollte keine Exceptions werfen
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

### Modell-Tests

Überprüfen Serialisierung und Deserialisierung von Daten:

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
      // ... andere Felder
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Utility-Tests

Überprüfen Hilfsfunktionen und Berechnungen:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 Dosen/Tag
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 Einheiten / 2 pro Tag = 10 Tage
});
```

---

## Widget-Tests

Widget-Tests überprüfen die Benutzeroberfläche und Benutzerinteraktion.

### Bildschirm-Tests

Überprüfen, dass Bildschirme korrekt gerendert werden und auf Interaktionen reagieren:

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

### Komponenten-Tests

Überprüfen einzelne UI-Komponenten:

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

### Mocking von Abhängigkeiten

Für Widget-Tests verwenden wir Mocks, um Komponenten zu isolieren:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // In-Memory-Datenbank
  DatabaseHelper.setInMemoryDatabase(true);

  // Testmodus für Benachrichtigungen
  NotificationService.instance.enableTestMode();

  // Standardperson sicherstellen
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Vollständiges Beispiel: Bearbeitungstest

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medikament hinzufügen
  await addMedicationWithDuration(tester, 'Ibuprofeno');
  await waitForDatabase(tester);

  // Bearbeitungsmenü öffnen
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofeno',
    'Horarios y Cantidades',
  );

  // Zeitpläne ändern
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Speichern
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Änderung überprüfen
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Integrationstests

Integrationstests überprüfen vollständige End-to-End-Benutzerflows.

### End-to-End-Tests

Simulieren echtes Benutzerverhalten:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. App starten
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Medikament hinzufügen
  await addMedicationWithDuration(
    tester,
    'Paracetamol',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Überprüfen, dass es in der Liste erscheint
  expect(find.text('Paracetamol'), findsOneWidget);

  // 4. Details-Modal öffnen
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  // 5. Dosis registrieren
  await tester.tap(find.text('Tomar dosis'));
  await waitForComplexAsyncOperation(tester);

  // 6. Aktualisierten Bestand überprüfen
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Bestand - 1
});
```

### Vollständige Flows

Integrationstests decken wichtige Flows ab:

1. **Medikament hinzufügen**: `add_medication_test.dart`
   - Vollständige Wizard-Navigation
   - Konfiguration aller Parameter
   - Überprüfung in der Hauptliste

2. **Medikament bearbeiten**: `edit_medication_test.dart`
   - Änderung jeder Sektion
   - Erhalt nicht geänderter Daten
   - Korrekte Aktualisierung in der Liste

3. **Medikament löschen**: `delete_medication_test.dart`
   - Löschbestätigung
   - Bereinigung von Benachrichtigungen
   - Löschung zugehöriger Historie

4. **Dosis registrieren**: `dose_registration_test.dart`
   - Manuelle Registrierung vom Modal
   - Bestandsaktualisierung
   - Erstellung eines Historieneintrags

5. **Bestandsverwaltung**: `stock_management_test.dart`
   - Niedrige Bestandswarnungen
   - Bestandsaufstockung
   - Dauerberechnung

### Datenbankinteraktion

Integrationstests interagieren mit einer echten In-Memory-Datenbank:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Erste Instanz der App
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Schließen und erneutes Öffnen simulieren
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medikament sollte noch vorhanden sein
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Testing-Helfer

Helfer vereinfachen das Schreiben von Tests und reduzieren Codeduplikation.

### MedicationBuilder

Das **Builder-Pattern** ermöglicht es, Testmedikamente lesbar zu erstellen:

```dart
/// Einfaches Beispiel
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Mit Fasten
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Mit mehreren Dosen
final medication = MedicationBuilder()
    .withName('Antibiótico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Als "Bedarfsmedikament"
final medication = MedicationBuilder()
    .withName('Analgésico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Vorteile von MedicationBuilder

1. **Lesbarkeit**: Der Code ist selbstdokumentierend und leicht verständlich
2. **Wartbarkeit**: Änderungen am Modell erfordern nur Aktualisierung des Builders
3. **Codereduzierung**: Vermeidet Wiederholung von Standardwerten in jedem Test
4. **Flexibilität**: Ermöglicht Konfiguration nur des Notwendigen für jeden Test

#### Factory-Methoden

Der Builder enthält Factory-Methoden für häufige Fälle:

```dart
// Niedriger Bestand (5 Einheiten)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Kein Bestand
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Mehrere Dosen pro Tag (automatisch)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Fasten aktiviert mit Standardwerten
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Ermöglicht die Erstellung eines Builders aus einem bestehenden Medikament:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nombre Modificado')
    .build();
```

### DatabaseTestHelper

Vereinfacht Einrichtung und Bereinigung der Datenbank:

```dart
class DatabaseTestHelper {
  /// Initiale Einrichtung (einmal pro Datei)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Bereinigung nach jedem Test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Shortcut: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Stellt sicher, dass Standardperson existiert
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

**Verwendung in Tests:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Vollständige Konfiguration

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // Ihr Test hier
  });
}
```

### WidgetTestHelpers

Hilfsfunktionen für Widget-Tests:

```dart
/// Lokalisierungen abrufen
AppLocalizations getL10n(WidgetTester tester);

/// Auf Datenbankoperationen warten
Future<void> waitForDatabase(WidgetTester tester);

/// Warten, bis ein Widget erscheint
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Zu einem Widget scrollen
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Bearbeitungsmenü öffnen
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Vollständiges Medikament hinzufügen
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Auf komplexe asynchrone Operationen warten
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Andere Helfer

- **PersonTestHelper**: Personenverwaltung in Tests
- **NotificationTestHelper**: Helfer für Benachrichtigungen
- **TestConstants**: Gemeinsame Konstanten (Dosen, Bestände, Zeiten)

---

## Test-Abdeckung

Die Test-Suite deckt die kritischsten Bereiche der Anwendung ab.

### Abdeckung nach Kategorie

| Kategorie | Tests | Beschreibung |
|-----------|-------|-------------|
| **Services** | ~94 Tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Core-Funktionalität** | ~79 Tests | Dosisverwaltung, Bestand, Fasten, Export/Import |
| **Fasten** | ~61 Tests | Fastenlogik, Benachrichtigungen, Countdown, Priorisierung |
| **Bildschirme** | ~93 Tests | Widget- und Navigationstests aller Bildschirme |
| **Integration** | ~52 Tests | Vollständige End-to-End-Flows |

**Gesamt: 369+ Tests**

### Gut abgedeckte Bereiche

#### Benachrichtigungen (95% Abdeckung)
- Planung und Abbruch von Benachrichtigungen
- Eindeutige IDs für verschiedene Benachrichtigungstypen
- Benachrichtigungen für wöchentliche Muster und spezifische Daten
- Fastenbenachrichtigungen
- Schnellaktionen aus Benachrichtigungen
- Plattformlimits (500 Benachrichtigungen)
- Mitternachts-Edge Cases

#### Fasten (90% Abdeckung)
- Berechnung von Fastenperioden (before/after)
- Dauervalidierungen
- Benachrichtigungen für Start und Ende
- Visueller Countdown
- Priorisierung mit mehreren aktiven Perioden
- Vorzeitige Dosen mit Fasten
- Erhalt der Konfiguration

#### Dosisverwaltung (88% Abdeckung)
- Dosisregistrierung (manuell und von Benachrichtigung)
- Dosisauslassung
- Extradosen
- Bestandsaktualisierung
- Dosisverlauf
- Berechnung des täglichen Verbrauchs

#### Datenbank (85% Abdeckung)
- CRUD für Medikamente
- CRUD für Personen
- Schemamigrationen
- Export/Import
- Referenzielle Integrität
- Kaskadierende Bereinigung

### Bereiche mit geringerer Abdeckung

Einige Bereiche haben geringere, aber nicht kritische Abdeckung:

- **Erweiterte UI/UX** (60%): Animationen, Übergänge
- **Konfiguration** (65%): Benutzereinstellungen
- **Lokalisierung** (70%): Übersetzungen und Sprachen
- **Berechtigungen** (55%): Anforderung von Systemberechtigungen

Diese Bereiche haben geringere Abdeckung, weil:
1. Sie schwer automatisch zu testen sind
2. Sie manuelle Interaktion erfordern
3. Sie vom Betriebssystem abhängen
4. Sie keine kritische Geschäftslogik betreffen

---

## Abgedeckte Edge Cases

Tests beinhalten Sonderfälle, die Fehler verursachen könnten:

### 1. Benachrichtigungen um Mitternacht

**Datei**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Gestern um 23:55 geplante Dosis
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Heute um 00:05 registriert
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Sollte als Dosis des Vortags zählen
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dosis um 22:00 mit "after" Fasten von 3 Stunden
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Fasten endet um 01:00 am nächsten Tag
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Abgedeckte Fälle:**
- Verspätete Dosen, die nach Mitternacht registriert werden
- Fastenperioden, die Mitternacht überschreiten
- Genau um 00:00 geplante Dosen
- Zurücksetzen täglicher Zähler
- Verschobene Benachrichtigungen, die Mitternacht überschreiten

### 2. Löschung und Bereinigung

**Datei**: `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Löschen
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // Es sollten keine geplanten Benachrichtigungen vorhanden sein
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Person löschen
  await db.deletePerson(person.id);

  // Es sollten keine Medikamente oder Historie vorhanden sein
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Abgedeckte Fälle:**
- Abbruch von Benachrichtigungen beim Löschen des Medikaments
- Kaskadierende Löschung der Historie
- Bereinigung von Benachrichtigungen beim Löschen der Person
- Keine Auswirkung auf andere Medikamente/Personen
- Referenzielle Integrität

### 3. Priorisierung mehrerer Fastenperioden

**Datei**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Medikament 1: "after" Fasten von 120 Minuten
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Medikament 2: "after" Fasten von 60 Minuten
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Beide Dosen registrieren
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Nur das restriktivste Fasten sollte angezeigt werden (med-1 bis 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Abgedeckte Fälle:**
- Mehrere aktive Fastenperioden für eine Person
- Auswahl der restriktivsten Periode
- Sortierung nach Endzeit
- Automatische Filterung beendeter Perioden
- Unabhängigkeit zwischen verschiedenen Personen

### 4. Benachrichtigungsaktionen

**Datei**: `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Aktion "register_dose" von Benachrichtigung simulieren
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Auswirkungen überprüfen
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

  // Verschieben
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Neue Planung überprüfen
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Abgedeckte Fälle:**
- Registrierung von Benachrichtigung
- Auslassung von Benachrichtigung
- 10 Minuten verschieben
- Korrekte Aktualisierung von Bestand und Historie
- Abbruch der ursprünglichen Benachrichtigung

### 5. Benachrichtigungslimits

**Datei**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // 100 Medikamente mit jeweils 4 Dosen erstellen
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Benachrichtigungen planen (potenziell >500)
  await notificationService.scheduleAll();

  // Sollte nicht abstürzen
  // Sollte nahe Benachrichtigungen priorisieren
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Abgedeckte Fälle:**
- Umgang mit mehr als 500 Benachrichtigungen
- Priorisierung naher Benachrichtigungen
- Logging von Warnungen
- App stürzt nicht ab
- Automatische Neuplanung

---

## Tests ausführen

### Grundlegende Befehle

```bash
# Alle Tests ausführen
flutter test

# Spezifischer Test
flutter test test/services/notification_service_test.dart

# Tests in einem Verzeichnis
flutter test test/integration/

# Tests mit spezifischem Namen
flutter test --name "fasting"

# Tests im Verbose-Modus
flutter test --verbose

# Tests mit Zeitreport
flutter test --reporter expanded
```

### Tests mit Abdeckung

```bash
# Tests mit Abdeckung ausführen
flutter test --coverage

# HTML-Report generieren
genhtml coverage/lcov.info -o coverage/html

# Report im Browser öffnen
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Spezifische Tests ausführen

```bash
# Nur Service-Tests
flutter test test/*_service_test.dart

# Nur Integrationstests
flutter test test/integration/

# Nur Fasten-Tests
flutter test test/fasting*.dart

# Langsame Tests ausschließen
flutter test --exclude-tags=slow
```

### Tests in CI/CD

```bash
# CI-Modus (ohne Farbe, geeignetes Format für Logs)
flutter test --machine --coverage

# Mit Timeout für langsame Tests
flutter test --timeout=30s

# Schneller Abbruch (bei erstem Fehler stoppen)
flutter test --fail-fast
```

### Test-Debugging

```bash
# Einzelnen Test im Debug-Modus ausführen
flutter test --plain-name "specific test name"

# Mit Breakpoints (VS Code/Android Studio)
# "Debug Test" aus der IDE verwenden

# Mit sichtbaren Prints
flutter test --verbose

# Output in Datei speichern
flutter test > test_output.txt 2>&1
```

---

## Leitfaden zum Schreiben von Tests

### AAA-Struktur (Arrange-Act-Assert)

Organisieren Sie jeden Test in drei klare Abschnitte:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Umgebung vorbereiten
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Zu testende Aktion ausführen
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Ergebnis überprüfen
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Namenskonventionen

Verwenden Sie beschreibende Namen, die das Szenario erklären:

```dart
// ✅ GUT: Beschreibt das vollständige Szenario
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ SCHLECHT: Vage oder technische Namen
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Empfohlenes Format:**
- `should [erwartete Aktion] when [Bedingung]`
- `[Aktion] [erwartetes Ergebnis] [optionaler Kontext]`

### Setup und Teardown

Konfigurieren und bereinigen Sie die Umgebung konsistent:

```dart
void main() {
  // Einmalige initiale Konfiguration
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Vor jedem Test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Nach jedem Test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Ihre Tests hier
  test('...', () async {
    // Isolierter Test mit sauberer Umgebung
  });
}
```

### Mocking von DatabaseHelper

Für reine Unit-Tests mocken Sie die Datenbank:

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

    // Mock konfigurieren
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Aktion ausführen
    await service.registerDose(medication.id, '08:00');

    // Aufruf überprüfen
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Verwendung von MedicationBuilder

Nutzen Sie den Builder für lesbare Tests:

```dart
test('should calculate correct stock duration', () {
  // Medikament mit Builder erstellen
  final medication = MedicationBuilder()
      .withName('Paracetamol')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 Dosen pro Tag
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 Tage
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory-Methode für niedrigen Bestand
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Best Practices

1. **Unabhängige Tests**: Jeder Test sollte alleine ausführbar sein
   ```dart
   // ✅ GUT: Eigenständiger Test
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... Rest des Tests
   });

   // ❌ SCHLECHT: Hängt von Ausführungsreihenfolge ab
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Hängt vom vorherigen Test ab
   });
   ```

2. **Schnelle Tests**: Verwenden Sie In-Memory-Datenbank, vermeiden Sie unnötige Delays
   ```dart
   // ✅ GUT
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ SCHLECHT
   await Future.delayed(Duration(seconds: 2)); // Willkürliche Verzögerung
   ```

3. **Spezifische Assertions**: Überprüfen Sie genau das, was wichtig ist
   ```dart
   // ✅ GUT
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ SCHLECHT
   expect(medication, isNotNull); // Zu vage
   ```

4. **Logische Gruppen**: Organisieren Sie verwandte Tests
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

5. **Test Edge Cases**: Nicht nur den Happy Path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Nützliche Kommentare**: Erklären Sie das "Warum", nicht das "Was"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Nach Mitternacht registrierte Dosen, aber innerhalb
     // von 2 Stunden nach der Planung, zählen zum Vortag
     // Dies verhindert, dass verspätete Dosen die tägliche Zählung verdoppeln

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Datenbank-Testing

### Verwendung von sqflite_common_ffi

Tests verwenden `sqflite_common_ffi` für In-Memory-Datenbank:

```dart
void main() {
  setUpAll(() {
    // FFI initialisieren
    sqfliteFfiInit();

    // FFI-Factory verwenden
    databaseFactory = databaseFactoryFfi;

    // In-Memory-Modus aktivieren
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Datenbank wird automatisch im Speicher erstellt
    final db = DatabaseHelper.instance;

    // Normale Operationen
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### In-Memory-Datenbank

Vorteile der Verwendung einer In-Memory-Datenbank:

1. **Geschwindigkeit**: 10-100x schneller als Festplatte
2. **Isolation**: Jeder Test beginnt mit sauberer DB
3. **Keine Nebeneffekte**: Ändert keine echten Daten
4. **Parallelisierung**: Tests können parallel laufen

```dart
setUp(() async {
  // Zurücksetzen für saubere DB
  await DatabaseHelper.resetDatabase();

  // In-Memory-Modus
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migrationen in Tests

Tests überprüfen, dass Migrationen korrekt funktionieren:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // DB in Version 18 erstellen
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (ohne persons-Tabelle)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // In Version 19 öffnen (Migration auslösen)
  final migratedDb = await DatabaseHelper.instance.database;

  // Überprüfen, dass persons existiert
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Standardperson überprüfen
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Bereinigung zwischen Tests

Es ist entscheidend, die DB zwischen Tests zu bereinigen, um Kontamination zu vermeiden:

```dart
tearDown(() async {
  // Methode 1: Alle Daten löschen
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Methode 2: Vollständig zurücksetzen
  await DatabaseHelper.resetDatabase();

  // Methode 3: Helfer verwenden
  await DatabaseTestHelper.cleanDatabase();
});
```

### Tests zur referenziellen Integrität

Überprüfen Sie, dass DB-Beziehungen korrekt funktionieren:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Person löschen
  await db.deletePerson(person.id);

  // Medikamente sollten gelöscht worden sein
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Versuchen, Historie für nicht existierendes Medikament einzufügen
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Sollte aufgrund von Foreign Key Constraint fehlschlagen
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD und automatisiertes Testing

### Continuous Integration

Typische Konfiguration für GitHub Actions:

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

Verwenden Sie `husky` oder Git Hook-Skripte, um Tests vor dem Commit auszuführen:

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

### Minimale Abdeckungsschwelle

Konfigurieren Sie eine Mindestschwelle, um Regressionen zu vermeiden:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Mindestabdeckung überprüfen
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Abdeckungsberichte

Generieren Sie automatisch visuelle Berichte:

```bash
# Bericht generieren
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Abdeckungs-Badge
./scripts/generate_coverage_badge.sh

# Bericht veröffentlichen
# (GitHub Pages, Codecov, Coveralls usw. verwenden)
```

---

## Nächste Schritte

### Verbesserungsbereiche

1. **UI/UX-Tests (60% → 80%)**
   - Mehr Animationstests
   - Tests für Gesten und Swipes
   - Barrierefreiheitstests

2. **Berechtigungstests (55% → 75%)**
   - Mocking von Systemberechtigungen
   - Flows für Berechtigungsanfragen
   - Umgang mit abgelehnten Berechtigungen

3. **Lokalisierungstests (70% → 90%)**
   - Tests für jede Sprache
   - Überprüfung vollständiger Übersetzungen
   - Tests für Datums-/Zahlenformatierung

4. **Performance-Tests**
   - Benchmarks kritischer Operationen
   - Last-Tests (viele Medikamente)
   - Memory Leak Detection

### Ausstehende Tests

#### Hohe Priorität

- [ ] Tests für vollständiges Backup/Restore
- [ ] Tests für Hintergrundbenachrichtigungen
- [ ] Tests für Home-Screen-Widget
- [ ] Tests für Deep Links
- [ ] Tests für Datenfreigabe

#### Mittlere Priorität

- [ ] Tests für alle Sprachen
- [ ] Tests für Themes (hell/dunkel)
- [ ] Tests für Onboarding
- [ ] Tests für Migrationen zwischen allen Versionen
- [ ] Tests für Export nach CSV/PDF

#### Niedrige Priorität

- [ ] Tests für komplexe Animationen
- [ ] Tests für erweiterte Gesten
- [ ] Umfassende Barrierefreiheitstests
- [ ] Performance-Tests auf langsamen Geräten

### Testing-Roadmap

#### Q1 2025
- 80% Gesamtabdeckung erreichen
- Berechtigungstests vervollständigen
- Grundlegende Performance-Tests hinzufügen

#### Q2 2025
- Tests für alle Sprachen
- Backup/Restore-Tests
- Aktualisierte Testing-Dokumentation

#### Q3 2025
- Vollständige Barrierefreiheitstests
- Last- und Stresstests
- Vollständige Automatisierung in CI/CD

#### Q4 2025
- 85%+ Gesamtabdeckung
- Performance-Test-Suite
- Visuelle Regressionstests

---

## Zusätzliche Ressourcen

### Dokumentation

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Tools

- **flutter_test**: Flutter Testing Framework
- **mockito**: Mocking von Abhängigkeiten
- **sqflite_common_ffi**: In-Memory-DB für Tests
- **test_coverage**: Abdeckungsanalyse
- **lcov**: HTML-Report-Generierung

### Verwandte Dateien

- `/test/helpers/` - Alle Testing-Helfer
- `/test/integration/` - Integrationstests
- `/.github/workflows/test.yml` - CI/CD-Konfiguration
- `/scripts/run_tests.sh` - Testing-Skripte

---

**Letzte Aktualisierung**: November 2025
**MedicApp-Version**: V19+
**Gesamt-Tests**: 369+
**Durchschnittliche Abdeckung**: 75-80%
