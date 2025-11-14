# Funktionen von MedicApp

Diese Dokumentation beschreibt detailliert alle Funktionen von **MedicApp**, einer umfassenden Lösung für die Medikamentenverwaltung, entwickelt mit Flutter.

---

## Inhaltsverzeichnis

- [1. Multi-Personen-Verwaltung](#1-multi-personen-verwaltung)
- [2. Medikamententypen](#2-medikamententypen)
- [3. Intelligentes Benachrichtigungssystem](#3-intelligentes-benachrichtigungssystem)
- [4. Erweiterte Bestandskontrolle](#4-erweiterte-bestandskontrolle)
- [5. Verwaltung von Fastenzeiten](#5-verwaltung-von-fastenzeiten)
- [6. Vollständiger Einnahmeverlauf](#6-vollständiger-einnahmeverlauf)
- [7. Mehrsprachige Oberfläche](#7-mehrsprachige-oberfläche)
- [8. Material Design 3](#8-material-design-3)
- [9. Robuste Datenbank](#9-robuste-datenbank)
- [10. Umfassende Tests](#10-umfassende-tests)

---

## 1. Multi-Personen-Verwaltung

### Beschreibung
MedicApp ermöglicht die Verwaltung von Medikamenten für mehrere Personen aus einer einzigen Anwendung. Jede Person hat ihr eigenes Profil mit unabhängigen Medikamenten, Einnahmen und Statistiken.

### Hauptmerkmale
- **Unabhängige Profile**: Jede Person hat ihre eigenen Daten (Medikamente, Einnahmen, Zeitpläne)
- **Einfaches Wechseln**: Schneller Wechsel zwischen Personen über die Hauptoberfläche
- **Individuelle Statistiken**: Spezifische Therapietreue-Metriken für jede Person
- **Datenvalidierung**: Gewährleistung der referenziellen Integrität zwischen Personen und ihren Daten

### Technische Implementierung
```dart
// Modell: lib/models/person.dart
class Person {
  final int? id;
  final String name;
  final DateTime createdAt;

  Person({this.id, required this.name, required this.createdAt});
}

// Service: lib/services/person_service.dart
class PersonService {
  Future<List<Person>> getAllPersons();
  Future<Person> createPerson(String name);
  Future<void> deletePerson(int personId);
  // Löscht automatisch zugehörige Medikamente und Einnahmen
}
```

### Anwendungsfälle
1. **Familien**: Verwalten Sie die Medikation mehrerer Familienmitglieder
2. **Professionelle Pflegekräfte**: Verfolgen Sie die Behandlungen mehrerer Patienten
3. **Mehrere Behandlungen**: Organisieren Sie verschiedene Therapien für dieselbe Person

### Datenbank-Schema
```sql
CREATE TABLE persons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    created_at TEXT NOT NULL
);

-- Referenzielle Integrität
CREATE TABLE medications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    person_id INTEGER NOT NULL,
    -- ... weitere Felder
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
);
```

---

## 2. Medikamententypen

### Beschreibung
MedicApp unterstützt 14 verschiedene Medikamententypen, jeden mit seinem eigenen Icon und seiner eigenen Konfiguration.

### Unterstützte Typen

| Typ | Beschreibung | Standardeinheit | Icon |
|-----|-------------|-----------------|------|
| **Tablette** | Orale Tabletten | Tabletten | pill |
| **Kapsel** | Gelatinekapseln | Kapseln | capsule |
| **Sirup** | Flüssigkeiten zum Einnehmen | ml | liquid |
| **Injektion** | Injizierbare Medikamente | ml | syringe |
| **Inhalator** | Inhalierte Medikamente | Dosen | inhaler |
| **Creme** | Topische Cremes | g | cream |
| **Tropfen** | Augentropfen/Ohrentropfen | Tropfen | drop |
| **Pflaster** | Transdermale Pflaster | Pflaster | patch |
| **Zäpfchen** | Rektale/vaginale Zäpfchen | Zäpfchen | suppository |
| **Spray** | Nasenspray/Rachenspray | Dosen | spray |
| **Pulver** | Pulver zum Auflösen | g | powder |
| **Gel** | Topische Gele | g | gel |
| **Verband** | Wundverbände | Verbände | bandage |
| **Sonstige** | Andere Typen | Einheiten | other |

### Technische Implementierung
```dart
// Enum: lib/models/medication_type.dart
enum MedicationType {
  pill,      // Tablette
  capsule,   // Kapsel
  syrup,     // Sirup
  injection, // Injektion
  inhaler,   // Inhalator
  cream,     // Creme
  drops,     // Tropfen
  patch,     // Pflaster
  suppository, // Zäpfchen
  spray,     // Spray
  powder,    // Pulver
  gel,       // Gel
  bandage,   // Verband
  other      // Sonstige
}

// Erweiterung mit lokalisierten Namen und Einheiten
extension MedicationTypeExtension on MedicationType {
  String getLocalizedName(BuildContext context);
  String getDefaultUnit(BuildContext context);
  IconData getIcon();
}
```

### Anpassung
- **Flexible Einheiten**: Jedes Medikament kann eine benutzerdefinierte Einheit haben
- **Visuelle Identifizierung**: Spezifische Icons für jeden Typ
- **Lokalisierung**: Namen und Einheiten in 8 Sprachen übersetzt

---

## 3. Intelligentes Benachrichtigungssystem

### Beschreibung
Fortschrittliches Benachrichtigungssystem mit Schnellaktionen, automatischen Begrenzungen und speziellen Benachrichtigungen für Fastenzeiten.

### Hauptmerkmale

#### 3.1. Schnellaktionen
Drei Aktionen direkt von der Benachrichtigung aus verfügbar:
- **Einnehmen**: Registriert die Einnahme sofort
- **Verschieben**: Verschiebt um 15 Minuten (konfigurierbar)
- **Überspringen**: Markiert als übersprungen

```dart
// Implementierung: lib/services/notification_service.dart
class NotificationService {
  Future<void> showMedicationNotification(
    Medication medication,
    DateTime scheduledTime,
  ) async {
    // Aktionen konfigurieren
    final actions = [
      NotificationAction('take', 'Einnehmen'),
      NotificationAction('snooze', 'Verschieben'),
      NotificationAction('skip', 'Überspringen'),
    ];

    await _notifications.show(
      medication.id,
      medication.name,
      'Zeit zur Einnahme Ihrer Medikation',
      actions: actions,
    );
  }
}
```

#### 3.2. Begrenzung auf 5 Aktive Benachrichtigungen
- Automatische Priorisierung nach Zeitplan
- Zeigt maximal 5 gleichzeitige Benachrichtigungen an
- Ältere Benachrichtigungen werden automatisch entfernt

```dart
// Logik zur Begrenzung
Future<void> _limitActiveNotifications() async {
  final activeNotifications = await _getActiveNotifications();

  if (activeNotifications.length > 5) {
    // Nach Zeitplan sortieren (neueste zuerst)
    activeNotifications.sort((a, b) =>
      b.scheduledTime.compareTo(a.scheduledTime));

    // Ältere entfernen
    for (var i = 5; i < activeNotifications.length; i++) {
      await _notifications.cancel(activeNotifications[i].id);
    }
  }
}
```

#### 3.3. Fortlaufende Benachrichtigungen für Fastenzeiten
- Nicht entfernbare Benachrichtigung während des Fastens
- Timer mit verbleibender Zeit
- Automatische Aktualisierung alle Minute

```dart
// Fortlaufende Benachrichtigung
Future<void> showOngoingFastingNotification(
  Fasting fasting,
  Duration remaining,
) async {
  await _notifications.show(
    fasting.id,
    'Fastenzeit läuft',
    'Verbleibend: ${_formatDuration(remaining)}',
    ongoing: true,        // Nicht entfernbar
    autoCancel: false,    // Wird nicht automatisch entfernt
    showProgress: true,   // Zeigt Fortschrittsbalken
  );
}
```

### Arten von Benachrichtigungen
1. **Geplante Benachrichtigungen**: Für Einnahmezeitpläne
2. **Fortlaufende Benachrichtigungen**: Für laufende Fastenzeiten
3. **Erinnerungen**: Für niedrigen Bestand
4. **Warnungen**: Für Interaktionen oder Probleme

### Android-Kanäle
```dart
// Benachrichtigungskanäle
const channels = [
  AndroidNotificationChannel(
    'medication_reminders',
    'Medikamentenerinnerungen',
    importance: Importance.high,
  ),
  AndroidNotificationChannel(
    'fasting_alerts',
    'Fastenwarnungen',
    importance: Importance.max,
  ),
  AndroidNotificationChannel(
    'inventory_warnings',
    'Bestandswarnungen',
    importance: Importance.defaultImportance,
  ),
];
```

---

## 4. Erweiterte Bestandskontrolle

### Beschreibung
Automatisches Bestandsverwaltungssystem mit Warnungen, Benachrichtigungen und Nachfüllvorschlägen.

### Hauptmerkmale

#### 4.1. Automatische Bestandsverfolgung
```dart
// Modell: lib/models/medication.dart
class Medication {
  final double? currentStock;     // Aktueller Bestand
  final double? minStock;         // Minimaler Bestand für Warnungen
  final String unit;              // Einheit (Tabletten, ml, etc.)
  final bool trackInventory;      // Aktiviert/Deaktiviert Verfolgung
}

// Automatische Aktualisierung
Future<void> _updateStockOnIntake(Intake intake) async {
  if (medication.trackInventory) {
    final newStock = medication.currentStock - intake.dose;
    await _medicationService.updateStock(medication.id, newStock);

    // Niedriger Bestand prüfen
    if (newStock <= medication.minStock) {
      await _notificationService.showLowStockWarning(medication);
    }
  }
}
```

#### 4.2. Benachrichtigungen bei niedrigem Bestand
- **Warnung**: Wenn Bestand unter das Minimum fällt
- **Kritisch**: Wenn Bestand fast aufgebraucht ist
- **Aufgebraucht**: Wenn kein Bestand mehr vorhanden ist

```dart
// Bestandswarnungen
Future<void> checkInventoryStatus(Medication medication) async {
  if (!medication.trackInventory) return;

  final percentage = (medication.currentStock / medication.minStock) * 100;

  if (percentage <= 0) {
    await _showOutOfStockNotification(medication);
  } else if (percentage <= 25) {
    await _showCriticalStockNotification(medication);
  } else if (percentage <= 50) {
    await _showLowStockNotification(medication);
  }
}
```

#### 4.3. Nachfüllvorschläge
```dart
// Berechnung der Tage bis zum Aufbrauchen
int calculateDaysUntilEmpty(Medication medication) {
  if (!medication.trackInventory) return -1;

  final dailyConsumption = _calculateDailyConsumption(medication);
  if (dailyConsumption == 0) return -1;

  return (medication.currentStock / dailyConsumption).floor();
}

// Vorschlag zum Nachfüllen
String getRefillSuggestion(Medication medication) {
  final daysRemaining = calculateDaysUntilEmpty(medication);

  if (daysRemaining <= 7) {
    return 'Jetzt nachfüllen';
  } else if (daysRemaining <= 14) {
    return 'Bald nachfüllen';
  } else {
    return 'Bestand ausreichend';
  }
}
```

### Bestandsverlauf
- Registriert alle Bestandsänderungen
- Verfolgt Nachfüllungen und Verbrauch
- Zeigt Verbrauchsstatistiken an

---

## 5. Verwaltung von Fastenzeiten

### Beschreibung
System zur Verwaltung von Fastenzeiten vor und nach der Medikamenteneinnahme mit Validierung, Benachrichtigungen und intelligenten Warnungen.

### Hauptmerkmale

#### 5.1. Konfiguration von Fastenzeiten
```dart
// Modell: lib/models/fasting.dart
class Fasting {
  final int? id;
  final int medicationId;
  final int durationMinutes;        // Dauer in Minuten
  final FastingType type;           // BEFORE oder AFTER
  final DateTime? startTime;        // Start der Fastenzeit
  final DateTime? endTime;          // Ende der Fastenzeit

  Fasting({
    this.id,
    required this.medicationId,
    required this.durationMinutes,
    required this.type,
    this.startTime,
    this.endTime,
  });
}

enum FastingType {
  BEFORE,  // Vor der Einnahme
  AFTER    // Nach der Einnahme
}
```

#### 5.2. Validierung von Zeitplänen
```dart
// Prüft, ob ein Zeitplan von Fastenzeiten betroffen ist
Future<List<FastingConflict>> validateScheduleWithFasting(
  Medication medication,
  List<TimeOfDay> scheduleTimes,
) async {
  final conflicts = <FastingConflict>[];
  final fastings = await _fastingService.getFastings(medication.id);

  for (final time in scheduleTimes) {
    for (final fasting in fastings) {
      final conflict = _checkConflict(time, fasting, scheduleTimes);
      if (conflict != null) {
        conflicts.add(conflict);
      }
    }
  }

  return conflicts;
}
```

#### 5.3. Fortlaufende Benachrichtigungen
```dart
// Startet fortlaufende Benachrichtigung für Fastenzeit
Future<void> startFastingNotification(Fasting fasting) async {
  final endTime = fasting.endTime!;

  // Timer für periodische Aktualisierungen
  Timer.periodic(Duration(minutes: 1), (timer) async {
    final now = DateTime.now();
    final remaining = endTime.difference(now);

    if (remaining.isNegative) {
      timer.cancel();
      await _cancelFastingNotification(fasting.id);
      await _showFastingCompleteNotification(fasting);
    } else {
      await _updateFastingNotification(fasting, remaining);
    }
  });
}
```

#### 5.4. Intelligente Warnungen
- **Nur laufende oder zukünftige Fastenzeiten anzeigen**: Fastenzeiten, die bereits beendet sind, werden nicht angezeigt
- **Automatische Aktualisierung**: Entfernt beendete Fastenzeiten beim Öffnen der App
- **Benachrichtigung bei Abschluss**: Warnt, wenn die Fastenzeit endet

```dart
// Filtert nur laufende oder zukünftige Fastenzeiten
Future<List<Fasting>> getActiveFastings(int personId) async {
  final allFastings = await _fastingService.getAllFastings(personId);
  final now = DateTime.now();

  return allFastings.where((fasting) {
    if (fasting.endTime == null) return false;
    return fasting.endTime!.isAfter(now);
  }).toList();
}
```

### Anwendungsfälle
1. **Fasten vor der Medikation**: Medikamente, die auf nüchternen Magen eingenommen werden müssen
2. **Fasten nach der Medikation**: Medikamente, die ein Fasten nach der Einnahme erfordern
3. **Interaktionen mit Nahrungsmitteln**: Vermeidung von Nahrungsmitteln, die mit dem Medikament interagieren

---

## 6. Vollständiger Einnahmeverlauf

### Beschreibung
Detailliertes Aufzeichnungssystem aller Medikamenteneinnahmen mit Status, Zeitstempeln und Statistiken.

### Hauptmerkmale

#### 6.1. Einnahmestatus
```dart
// Modell: lib/models/intake.dart
class Intake {
  final int? id;
  final int medicationId;
  final DateTime scheduledTime;      // Geplante Zeit
  final DateTime? actualTime;        // Tatsächliche Zeit
  final IntakeStatus status;         // Status
  final double dose;                 // Eingenommene Dosis
  final String? notes;               // Optionale Notizen

  Intake({
    this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.actualTime,
    required this.status,
    required this.dose,
    this.notes,
  });
}

enum IntakeStatus {
  TAKEN,      // Eingenommen
  SKIPPED,    // Übersprungen
  SNOOZED     // Verschoben
}
```

#### 6.2. Einnahmestatistiken
```dart
// Berechnet Therapietreue-Metriken
class IntakeStatistics {
  final int totalScheduled;     // Insgesamt geplant
  final int taken;              // Eingenommen
  final int skipped;            // Übersprungen
  final int snoozed;            // Verschoben

  // Berechnungen
  double get adherenceRate => (taken / totalScheduled) * 100;
  double get skipRate => (skipped / totalScheduled) * 100;
  double get snoozeRate => (snoozed / totalScheduled) * 100;
}

// Statistiken pro Person
Future<IntakeStatistics> getStatistics(
  int personId,
  DateTimeRange dateRange,
) async {
  final intakes = await _getIntakesInRange(personId, dateRange);

  return IntakeStatistics(
    totalScheduled: intakes.length,
    taken: intakes.where((i) => i.status == IntakeStatus.TAKEN).length,
    skipped: intakes.where((i) => i.status == IntakeStatus.SKIPPED).length,
    snoozed: intakes.where((i) => i.status == IntakeStatus.SNOOZED).length,
  );
}
```

#### 6.3. Verlaufsansicht
```dart
// UI: lib/screens/history_screen.dart
class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          final intake = intakes[index];
          return IntakeCard(
            medication: intake.medication,
            scheduledTime: intake.scheduledTime,
            actualTime: intake.actualTime,
            status: intake.status,
            dose: intake.dose,
            notes: intake.notes,
          );
        },
      ),
    );
  }
}
```

### Erweiterte Funktionen
- **Filterung nach Status**: Nur eingenommen, übersprungen, etc. anzeigen
- **Filterung nach Datum**: Spezifischer Zeitraum
- **Filterung nach Person**: Statistiken pro Person
- **Filterung nach Medikament**: Verlauf eines spezifischen Medikaments
- **Export**: Export des Verlaufs zu CSV/PDF (zukünftige Funktion)

---

## 7. Mehrsprachige Oberfläche

### Beschreibung
Vollständige Unterstützung für 8 Sprachen mit dynamischem Wechsel und vollständiger Lokalisierung.

### Unterstützte Sprachen
1. **Spanisch (ES)** - Standardsprache
2. **Englisch (EN)**
3. **Französisch (FR)**
4. **Deutsch (DE)**
5. **Italienisch (IT)**
6. **Portugiesisch (PT)**
7. **Katalanisch (CA)**
8. **Baskisch (EU)**

### Technische Implementierung
```dart
// Konfiguration: lib/l10n/l10n.dart
class AppLocalizations {
  static const supportedLocales = [
    Locale('es'),  // Spanisch
    Locale('en'),  // Englisch
    Locale('fr'),  // Französisch
    Locale('de'),  // Deutsch
    Locale('it'),  // Italienisch
    Locale('pt'),  // Portugiesisch
    Locale('ca'),  // Katalanisch
    Locale('eu'),  // Baskisch
  ];

  // Delegierte für Lokalisierung
  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
```

### Lokalisierte Komponenten
```dart
// Verwendung in UI
Text(AppLocalizations.of(context)!.welcomeMessage);
Text(AppLocalizations.of(context)!.medicationReminder);
Text(AppLocalizations.of(context)!.lowStockWarning);

// Medikamententypen
medication.type.getLocalizedName(context);
medication.type.getDefaultUnit(context);

// Fehler und Warnungen
AppLocalizations.of(context)!.errorSavingMedication;
AppLocalizations.of(context)!.warningConflictingSchedule;
```

### Dynamischer Sprachwechsel
```dart
// Service: lib/services/settings_service.dart
class SettingsService {
  Future<void> changeLanguage(Locale newLocale) async {
    await _prefs.setString('language', newLocale.languageCode);

    // App aktualisieren ohne Neustart
    _localeNotifier.value = newLocale;
  }

  Locale getCurrentLocale() {
    final code = _prefs.getString('language') ?? 'es';
    return Locale(code);
  }
}
```

### Lokalisierte Dateien
```
lib/l10n/
├── app_es.arb    # Spanisch
├── app_en.arb    # Englisch
├── app_fr.arb    # Französisch
├── app_de.arb    # Deutsch
├── app_it.arb    # Italienisch
├── app_pt.arb    # Portugiesisch
├── app_ca.arb    # Katalanisch
└── app_eu.arb    # Baskisch
```

---

## 8. Material Design 3

### Beschreibung
Moderne Oberfläche mit Material Design 3, dynamischen Farben und adaptiven Komponenten.

### Hauptmerkmale

#### 8.1. Dynamisches Farbschema
```dart
// Theme: lib/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme(ColorScheme? dynamicColorScheme) {
    final colorScheme = dynamicColorScheme ?? ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // ... weitere Konfigurationen
    );
  }

  static ThemeData darkTheme(ColorScheme? dynamicColorScheme) {
    final colorScheme = dynamicColorScheme ?? ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // ... weitere Konfigurationen
    );
  }
}
```

#### 8.2. Material 3 Komponenten
- **Cards**: Mit erhöhtem/füllendem Stil
- **Buttons**: FAB, FilledButton, OutlinedButton, TextButton
- **Navigation**: NavigationBar, NavigationRail, NavigationDrawer
- **Dialoge**: AlertDialog, SimpleDialog, ShowModalBottomSheet
- **Inputs**: TextField mit Outlined-Stil, DropdownMenu
- **Chips**: FilterChip, ActionChip, InputChip

```dart
// Beispiel: Medikationskarte
Card(
  elevation: 0,
  color: Theme.of(context).colorScheme.surfaceVariant,
  child: ListTile(
    leading: Icon(medication.type.getIcon()),
    title: Text(medication.name),
    subtitle: Text(medication.description),
    trailing: IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () => _showOptions(medication),
    ),
  ),
)
```

#### 8.3. Adaptives Design
```dart
// Responsive Layout
class AdaptiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileLayout();
        } else if (constraints.maxWidth < 900) {
          return TabletLayout();
        } else {
          return DesktopLayout();
        }
      },
    );
  }
}
```

#### 8.4. Animationen und Übergänge
```dart
// Sanfte Übergänge
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
);

// Hero-Animationen
Hero(
  tag: 'medication-${medication.id}',
  child: MedicationCard(medication: medication),
);
```

### Themenkonfiguration
- **Helles Thema**: Helle Farben, hoher Kontrast
- **Dunkles Thema**: Dunkle Farben, reduzierte Augenbelastung
- **Dynamische Farben**: System-Farben (Android 12+)
- **Benutzerdefinierte Farben**: Konfigurierbare Farbpalette

---

## 9. Robuste Datenbank

### Beschreibung
SQLite-Datenbank V19 mit automatischen Migrationen, optimierten Indizes und Trigger-System.

### Hauptmerkmale

#### 9.1. Automatisches Migrationssystem
```dart
// Datenbank: lib/services/database_helper.dart
class DatabaseHelper {
  static const _databaseName = 'medicapp.db';
  static const _databaseVersion = 19;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    // ... weitere Tabellen
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Inkrementelle Migrationen
    if (oldVersion < 19) {
      await _migrateToV19(db);
    }
    // ... weitere Migrationen
  }
}
```

#### 9.2. Optimierte Indizes
```sql
-- Indizes für schnelle Abfragen
CREATE INDEX idx_medications_person ON medications(person_id);
CREATE INDEX idx_schedules_medication ON schedules(medication_id);
CREATE INDEX idx_intakes_medication ON intakes(medication_id);
CREATE INDEX idx_intakes_scheduled_time ON intakes(scheduled_time);
CREATE INDEX idx_fastings_medication ON fastings(medication_id);
```

#### 9.3. Trigger-System
```sql
-- Trigger: Löscht zugehörige Daten
CREATE TRIGGER delete_person_cascade
AFTER DELETE ON persons
BEGIN
  DELETE FROM medications WHERE person_id = OLD.id;
  DELETE FROM intakes WHERE medication_id IN (
    SELECT id FROM medications WHERE person_id = OLD.id
  );
END;

-- Trigger: Aktualisiert Bestand
CREATE TRIGGER update_stock_on_intake
AFTER INSERT ON intakes
WHEN NEW.status = 'TAKEN'
BEGIN
  UPDATE medications
  SET current_stock = current_stock - NEW.dose
  WHERE id = NEW.medication_id;
END;
```

#### 9.4. Referenzielle Integrität
```sql
-- Fremdschlüssel mit Kaskadierung
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  person_id INTEGER NOT NULL,
  -- ... weitere Felder
  FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
);

CREATE TABLE intakes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  medication_id INTEGER NOT NULL,
  -- ... weitere Felder
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE
);
```

### Erweiterte Funktionen
- **Transaktionen**: Gewährleistung der Datenintegrität
- **Backup**: Export/Import der Datenbank (zukünftige Funktion)
- **Verschlüsselung**: Schutz sensibler Daten (zukünftige Funktion)
- **Synchronisation**: Cloud-Sync (zukünftige Funktion)

---

## 10. Umfassende Tests

### Beschreibung
Umfassende Test-Suite mit über 432 automatisierten Tests und 75-80% Codeabdeckung.

### Testtypen

#### 10.1. Unit-Tests
```dart
// Test: test/models/medication_test.dart
void main() {
  group('Medication Model', () {
    test('should create medication with all fields', () {
      final medication = Medication(
        id: 1,
        personId: 1,
        name: 'Aspirin',
        type: MedicationType.pill,
        // ... weitere Felder
      );

      expect(medication.id, 1);
      expect(medication.name, 'Aspirin');
      expect(medication.type, MedicationType.pill);
    });

    test('should calculate days until empty correctly', () {
      final medication = Medication(
        currentStock: 30,
        // ... mit Zeitplan von 1 Tablette alle 8 Stunden
      );

      expect(medication.daysUntilEmpty, 10);
    });
  });
}
```

#### 10.2. Widget-Tests
```dart
// Test: test/widgets/medication_card_test.dart
void main() {
  testWidgets('MedicationCard displays information correctly', (tester) async {
    final medication = Medication(
      name: 'Aspirin',
      type: MedicationType.pill,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MedicationCard(medication: medication),
      ),
    );

    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.byIcon(Icons.medication), findsOneWidget);
  });
}
```

#### 10.3. Integrationstests
```dart
// Test: test/integration/medication_flow_test.dart
void main() {
  testWidgets('Complete medication flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigiert zur Hinzufügen-Bildschirm
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Füllt Formular aus
    await tester.enterText(find.byKey(Key('name_field')), 'Aspirin');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    // Verifiziert, dass Medikament hinzugefügt wurde
    expect(find.text('Aspirin'), findsOneWidget);
  });
}
```

#### 10.4. Spezifische Tests für Grenzfälle
```dart
// Test: test/notification_midnight_edge_cases_test.dart
void main() {
  group('Notification Midnight Edge Cases', () {
    test('handles notification scheduled at 23:59', () async {
      final scheduledTime = DateTime(2024, 1, 1, 23, 59);
      // ... Test-Logik
    });

    test('handles notification scheduled at 00:00', () async {
      final scheduledTime = DateTime(2024, 1, 1, 0, 0);
      // ... Test-Logik
    });
  });
}
```

### Abdeckung
```bash
# Abdeckungsbericht generieren
flutter test --coverage

# Aktuelle Abdeckung
Total: 432+ Tests
Abdeckung: 75-80%
- Models: ~90%
- Services: ~80%
- Widgets: ~70%
- Screens: ~60%
```

### Continuous Integration
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
```

---

## Zukünftige Funktionen

### In Planung
1. **Cloud-Synchronisation**: Backup und Synchronisation zwischen Geräten
2. **Export/Import**: Export von Daten zu CSV/PDF
3. **Medizinische Berichte**: Generierung von Berichten für Ärzte
4. **Interaktionen zwischen Medikamenten**: Warnungen bei Interaktionen
5. **Erinnerungen zum Nachfüllen**: Automatische Erinnerungen zum Nachfüllen
6. **Biometrische Authentifizierung**: Schutz sensibler Daten
7. **Widgets**: Home-Screen-Widgets für schnellen Zugriff
8. **Smartwatch-Integration**: Benachrichtigungen auf Wearables

---

## Zusätzliche Ressourcen

- **[Architekturdokumentation](architecture.md)**: Projektstruktur und Designmuster
- **[Datenbankdokumentation](database.md)**: Detailliertes Schema und Migrationen
- **[Testing-Leitfaden](testing.md)**: Wie man Tests schreibt und ausführt
- **[Beitragsleitfäden](contributing.md)**: Wie man zum Projekt beiträgt

---

**MedicApp - Umfassende Lösung für die Medikamentenverwaltung**
