# Funktionen von MedicApp

Diese Dokumentation beschreibt detailliert alle Funktionen von **MedicApp**, einer umfassenden Lösung für die Medikamentenverwaltung, entwickelt mit Flutter.

---

## Inhaltsverzeichnis

- [1. Multi-Personen-Verwaltung](#1-multi-personen-verwaltung)
- [2. Medikamententypen](#2-medikamententypen)
- [3. Intelligentes Benachrichtigungssystem](#3-intelligentes-benachrichtigungssystem)
- [4. Erweiterte Bestandskontrolle](#4-erweiterte-bestandskontrolle)
- [5. Verwaltung von Verfallsdaten](#5-verwaltung-von-verfallsdaten)
- [6. Verwaltung von Fastenzeiten](#6-verwaltung-von-fastenzeiten)
- [7. Vollständiger Einnahmeverlauf](#7-vollständiger-einnahmeverlauf)
- [8. Mehrsprachige Oberfläche](#8-mehrsprachige-oberfläche)
- [9. Material Design 3](#9-material-design-3)
- [10. Benachrichtigungen bei niedrigem Bestand](#10-benachrichtigungen-bei-niedrigem-bestand)
- [11. Robuste Datenbank](#11-robuste-datenbank)
- [12. Umfassende Tests](#12-umfassende-tests)
- [13. Intelligentes Cache-System](#13-intelligentes-cache-system)
- [14. Intelligente Erinnerungen](#14-intelligente-erinnerungen)
- [15. Natives Dunkles Theme](#15-natives-dunkles-theme)

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

## 10. Benachrichtigungen bei niedrigem Bestand

### Reaktive Benachrichtigungen bei unzureichendem Bestand

MedicApp implementiert ein intelligentes Bestandswarnsystem, das den Benutzer davor schützt, in kritischen Momenten ohne Medikamente dazustehen. Wenn ein Benutzer versucht, eine Dosis zu registrieren (entweder über den Hauptbildschirm oder über Schnellaktionen in Benachrichtigungen), überprüft das System automatisch, ob ausreichend Bestand vorhanden ist, um die Einnahme abzuschließen.

Wenn der verfügbare Bestand geringer ist als die für die Dosis benötigte Menge, zeigt MedicApp sofort eine Warnung über unzureichenden Bestand an, die die Registrierung der Einnahme verhindert. Diese reaktive Benachrichtigung gibt klar den Namen des betroffenen Medikaments, die benötigte versus die verfügbare Menge an und schlägt vor, den Bestand aufzufüllen, bevor erneut versucht wird, die Dosis zu registrieren.

Dieser Schutzmechanismus verhindert fehlerhafte Einträge im Verlauf und garantiert die Integrität der Bestandskontrolle, indem verhindert wird, dass Bestand abgezogen wird, der physisch nicht vorhanden ist. Die Warnung ist klar, nicht aufdringlich und leitet den Benutzer direkt zur Korrekturmaßnahme (Bestand auffüllen).

### Proaktive Benachrichtigungen bei niedrigem Bestand

Zusätzlich zu den reaktiven Warnungen zum Zeitpunkt der Einnahme einer Dosis verfügt MedicApp über ein proaktives System zur täglichen Bestandsüberwachung, das Versorgungsengpässe antizipiert, bevor sie auftreten. Dieses System bewertet automatisch einmal täglich den Bestand aller Medikamente und berechnet die verbleibenden Versorgungstage basierend auf dem geplanten Verbrauch.

Die Berechnung berücksichtigt mehrere Faktoren, um genau abzuschätzen, wie lange der aktuelle Bestand ausreicht:

**Für geplante Medikamente** - Das System addiert die gesamte Tagesdosis aller zugewiesenen Personen, multipliziert mit den im Häufigkeitsmuster konfigurierten Tagen (zum Beispiel, wenn das Medikament nur montags, mittwochs und freitags eingenommen wird, passt es die Berechnung an) und dividiert den aktuellen Bestand durch diesen effektiven Tagesverbrauch.

**Für gelegentliche Medikamente ("nach Bedarf")** - Verwendet den Protokolleintrag des letzten Tages des tatsächlichen Verbrauchs als Prädiktor und bietet eine adaptive Schätzung, die sich mit der Nutzung verbessert.

Wenn der Bestand eines Medikaments den konfigurierten Schwellenwert erreicht (standardmäßig 3 Tage, aber pro Medikament zwischen 1-10 Tagen anpassbar), sendet MedicApp eine proaktive Warnbenachrichtigung. Diese Benachrichtigung zeigt:

- Name des Medikaments und Typ
- Ungefähr verbleibende Versorgungstage
- Betroffene Person(en)
- Aktueller Bestand in entsprechenden Einheiten
- Aufstellungsvorschlag

### Vermeidung von Benachrichtigungs-Spam

Um zu vermeiden, dass der Benutzer mit wiederholten Warnungen bombardiert wird, implementiert das proaktive Benachrichtigungssystem intelligente Häufigkeitslogik. Jede Art von Warnung bei niedrigem Bestand wird maximal einmal täglich pro Medikament gesendet. Das System registriert das letzte Datum, an dem jede Warnung gesendet wurde, und benachrichtigt nicht erneut, bis:

1. Mindestens 24 Stunden seit der letzten Warnung vergangen sind, ODER
2. Der Benutzer den Bestand aufgefüllt hat (wodurch der Zähler zurückgesetzt wird)

Diese Spam-Vermeidung stellt sicher, dass Benachrichtigungen nützlich und zeitgerecht sind, ohne zu einer Belästigung zu werden, die den Benutzer dazu bringt, sie zu ignorieren oder zu deaktivieren.

### Integration mit visueller Bestandskontrolle

Die Warnungen bei niedrigem Bestand funktionieren nicht isoliert, sondern sind tief in das visuelle Ampelsystem der Medikamentenbox integriert. Wenn ein Medikament einen niedrigen Bestand hat:

- Erscheint es in der Liste der Hausapotheke rot oder gelb markiert
- Zeigt ein Warnsymbol auf dem Hauptbildschirm an
- Die proaktive Benachrichtigung ergänzt diese visuellen Signale

Diese mehrschichtige Information (visuell + Benachrichtigungen) garantiert, dass der Benutzer sich des Bestandsstatus von mehreren Kontaktpunkten mit der Anwendung aus bewusst ist.

### Konfiguration und Personalisierung

Jedes Medikament kann einen personalisierten Warnschwellenwert haben, der bestimmt, wann der Bestand als "niedrig" betrachtet wird. Kritische Medikamente wie Insulin oder Antikoagulantien können mit Schwellenwerten von 7-10 Tagen konfiguriert werden, um ausreichend Zeit zum Auffüllen zu ermöglichen, während weniger dringende Nahrungsergänzungsmittel Schwellenwerte von 1-2 Tagen verwenden können.

Das System respektiert diese individuellen Konfigurationen und ermöglicht es jedem Medikament, seine eigene an Kritikalität und Verfügbarkeit in Apotheken angepasste Warnrichtlinie zu haben.

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

## 5. Verwaltung von Verfallsdaten

### Kontrolle des Medikamentenverfalls

MedicApp ermöglicht die Erfassung und Überwachung von Verfallsdaten von Medikamenten, um die Behandlungssicherheit zu gewährleisten. Diese Funktionalität ist besonders wichtig für Bedarfsmedikamente und suspendierte Medikamente, die über längere Zeiträume gelagert werden.

Das System verwendet ein vereinfachtes Format MM/JJJJ (Monat/Jahr), das dem Standardformat auf Medikamentenverpackungen entspricht. Dies erleichtert die Dateneingabe, ohne den genauen Verfallstag kennen zu müssen.

### Automatische Statuserkennung

MedicApp bewertet automatisch den Verfallsstatus jedes Medikaments:

- **Abgelaufen**: Das Medikament hat sein Verfallsdatum überschritten und wird mit einem roten Warnetikett mit Warnsymbol angezeigt.
- **Bald ablaufend**: 30 Tage oder weniger bis zum Ablauf, wird mit einem orangefarbenen Vorsichtsetikett mit Uhrsymbol angezeigt.
- **In gutem Zustand**: Mehr als 30 Tage bis zum Ablauf, keine besondere Warnung wird angezeigt.

Visuelle Warnungen erscheinen direkt auf der Medikamentenkarte im Medizinschrank, neben dem Aussetzungsstatus falls zutreffend, und ermöglichen die schnelle Identifizierung von Medikamenten, die Aufmerksamkeit erfordern.

### Eingabe des Verfallsdatums

Das System fordert das Verfallsdatum zu drei bestimmten Zeitpunkten an:

1. **Beim Erstellen von Bedarfsmedikamenten**: Als letzter Schritt des Erstellungsprozesses (Schritt 2/2) erscheint ein optionaler Dialog zur Eingabe des Verfallsdatums vor dem Speichern des Medikaments.

2. **Beim Aussetzen von Medikamenten**: Beim Aussetzen eines Medikaments für alle Benutzer, die es teilen, wird das Verfallsdatum angefordert. Dies ermöglicht die Erfassung des Datums der Verpackung, die gelagert bleibt.

3. **Beim Nachfüllen von Bedarfsmedikamenten**: Nach dem Hinzufügen von Bestand zu einem Bedarfsmedikament bietet das System an, das Verfallsdatum zu aktualisieren, um das Datum der neu erworbenen Verpackung widerzuspiegeln.

In allen Fällen ist das Feld optional und kann übersprungen werden. Der Benutzer kann den Vorgang abbrechen oder das Feld einfach leer lassen.

### Format und Validierungen

Der Eingabedialog für das Verfallsdatum bietet zwei separate Felder:
- Monatsfeld (MM): akzeptiert Werte von 01 bis 12
- Jahresfeld (JJJJ): akzeptiert Werte von 2000 bis 2100

Das System validiert automatisch, dass der Monat im korrekten Bereich liegt und das Jahr gültig ist. Nach Abschluss des Monats (2 Ziffern) wechselt der Fokus automatisch zum Jahresfeld, um die Dateneingabe zu beschleunigen.

Das Datum wird im Format "MM/JJJJ" gespeichert (Beispiel: "03/2025") und für Verfallsvergleiche als letzter Tag dieses Monats interpretiert. Dies bedeutet, dass ein Medikament mit Datum "03/2025" ab dem 1. April 2025 als abgelaufen gilt.

### Systemvorteile

Diese Funktionalität hilft:
- Die Verwendung abgelaufener Medikamente zu verhindern, die unwirksam oder gefährlich sein könnten
- Den Bestand effizient zu verwalten, indem Medikamente identifiziert werden, die bald ablaufen
- Die Verwendung von Medikamenten nach Verfallsdatum zu priorisieren
- Einen sicheren Medizinschrank mit visueller Statuskontrolle jedes Medikaments zu pflegen
- Verschwendung zu vermeiden, indem daran erinnert wird, Medikamente vor Ablauf zu überprüfen

Das System verhindert nicht die Dosisregistrierung mit abgelaufenen Medikamenten, bietet aber klare visuelle Warnungen, damit der Benutzer informierte Entscheidungen treffen kann.

---

## 6. Verwaltung von Fastenzeiten

### Beschreibung
System zur Verwaltung von Fastenzeiten vor und nach der Medikamenteneinnahme mit Validierung, Benachrichtigungen und intelligenten Warnungen.

### Hauptmerkmale

#### 6.1. Konfiguration von Fastenzeiten
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

#### 6.2. Validierung von Zeitplänen
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

#### 6.3. Fortlaufende Benachrichtigungen
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

#### 6.4. Intelligente Warnungen
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

## 7. Vollständiger Einnahmeverlauf

### Beschreibung
Detailliertes Aufzeichnungssystem aller Medikamenteneinnahmen mit Status, Zeitstempeln und Statistiken.

### Hauptmerkmale

#### 7.1. Einnahmestatus
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

#### 7.2. Einnahmestatistiken
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

#### 7.3. Verlaufsansicht
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

## 8. Mehrsprachige Oberfläche

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

## 9. Material Design 3

### Beschreibung
Moderne Oberfläche mit Material Design 3, dynamischen Farben und adaptiven Komponenten.

### Hauptmerkmale

#### 9.1. Dynamisches Farbschema
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

#### 9.2. Material 3 Komponenten
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

#### 9.3. Adaptives Design
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

#### 9.4. Animationen und Übergänge
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

## 11. Robuste Datenbank

### Beschreibung
SQLite-Datenbank V19 mit automatischen Migrationen, optimierten Indizes und Trigger-System.

### Hauptmerkmale

#### 11.1. Automatisches Migrationssystem
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

#### 11.2. Optimierte Indizes
```sql
-- Indizes für schnelle Abfragen
CREATE INDEX idx_medications_person ON medications(person_id);
CREATE INDEX idx_schedules_medication ON schedules(medication_id);
CREATE INDEX idx_intakes_medication ON intakes(medication_id);
CREATE INDEX idx_intakes_scheduled_time ON intakes(scheduled_time);
CREATE INDEX idx_fastings_medication ON fastings(medication_id);
```

#### 11.3. Trigger-System
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

#### 11.4. Referenzielle Integrität
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

## 12. Umfassende Tests

### Beschreibung
Umfassende Test-Suite mit über 432 automatisierten Tests und 75-80% Codeabdeckung.

### Testtypen

#### 12.1. Unit-Tests
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

#### 12.2. Widget-Tests
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

#### 12.3. Integrationstests
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

#### 12.4. Spezifische Tests für Grenzfälle
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

## 13. Intelligentes Cache-System

### Beschreibung
Fortschrittliches Cache-System, das die Anwendungsleistung durch temporäre Speicherung häufig abgerufener Daten optimiert.

### Hauptmerkmale

#### 13.1. Generisches Cache mit TTL
```dart
class SmartCacheService<T> {
  final int maxSize;
  final Duration ttl;

  // Cache-Operationen
  T? get(String key);
  void put(String key, T value);
  Future<T> getOrCompute(String key, Future<T> Function() computer);
  void invalidate(String key);
  void clear();

  // Statistiken
  CacheStatistics get statistics;
}
```

**Eigenschaften:**
- **TTL (Time-To-Live)**: Jeder Eintrag läuft automatisch nach einer konfigurierbaren Zeitspanne ab
- **LRU-Algorithmus**: Entfernt am wenigsten kürzlich verwendete Einträge bei Erreichen der maximalen Größe
- **Auto-Bereinigung**: Periodischer Timer, der abgelaufene Einträge alle 60 Sekunden entfernt
- **Typsicherheit**: Vollständig generisch mit vollständiger Dart-Typenunterstützung

#### 13.2. Cache-Aside-Muster
```dart
// Automatische Verwendung des Caches
final medications = await medicationsCache.getOrCompute(
  'person_$personId',
  () => DatabaseHelper.instance.getMedicationsForPerson(personId),
);

// Äquivalent zu:
// 1. Im Cache suchen
// 2. Falls nicht vorhanden, aus DB laden
// 3. Im Cache speichern für zukünftige Zugriffe
```

#### 13.3. Spezialisierte Caches
```dart
class MedicationCacheService {
  // Cache für einzelne Medikamente (10 Min)
  static final medicationsCache = SmartCacheService<List<Medication>>(
    maxSize: 50,
    ttl: Duration(minutes: 10),
  );

  // Cache für Listen (5 Min)
  static final listsCache = SmartCacheService<List<Medication>>(
    maxSize: 20,
    ttl: Duration(minutes: 5),
  );

  // Cache für Verlauf (3 Min)
  static final historyCache = SmartCacheService<List<DoseHistoryEntry>>(
    maxSize: 30,
    ttl: Duration(minutes: 3),
  );

  // Cache für Statistiken (30 Min)
  static final statisticsCache = SmartCacheService<Map<String, dynamic>>(
    maxSize: 10,
    ttl: Duration(minutes: 30),
  );
}
```

**Angepasste TTL nach Typ:**
- Medikamente: 10 Minuten (ändern sich mäßig)
- Listen: 5 Minuten (häufiger aktualisiert)
- Verlauf: 3 Minuten (häufige neue Einträge)
- Statistiken: 30 Minuten (aufwändige Berechnungen)

#### 13.4. Echtzeit-Statistiken
```dart
class CacheStatistics {
  final int hits;           // Erfolgreiche Treffer
  final int misses;         // Fehlschläge
  final int evictions;      // Entfernte Einträge
  final int currentSize;    // Aktuelle Größe

  double get hitRate => hits / (hits + misses);  // Trefferquote
}

// Verwendung
final stats = medicationsCache.statistics;
print('Hit Rate: ${(stats.hitRate * 100).toStringAsFixed(1)}%');
```

### Leistungsvorteile

**Messergebnisse:**
- Reduzierung von DB-Zugriffen: 60-80%
- Reaktionszeit für Listen: 500ms → 50ms (10x schneller)
- Reaktionszeit für Statistiken: 2000ms → 100ms (20x schneller)
- Kontrollierter Speicher: < 5MB für alle Caches

### Automatische Ungültigmachung
```dart
// Nach Änderung eines Medikaments
await DatabaseHelper.instance.updateMedication(medication);

// Cache ungültig machen
MedicationCacheService.invalidate('medication_${medication.id}');
MedicationCacheService.listsCache.invalidate('person_${personId}');
```

---

## 14. Intelligente Erinnerungen

### Beschreibung
System für Therapietreue-Analyse und personalisierte Empfehlungen basierend auf historischen Einnahmemustern.

### Hauptmerkmale

#### 14.1. Therapietreue-Analyse
```dart
class IntelligentRemindersService {
  static Future<AdherenceAnalysis> analyzeAdherence({
    required String personId,
    required String medicationId,
    int daysToAnalyze = 30,
  });
}

// Ergebnis
AdherenceAnalysis {
  overallAdherence: 0.85,        // 85% globale Therapietreue
  bestDay: 'Monday',              // Bester Tag
  worstDay: 'Saturday',           // Schlechtester Tag
  bestTimeSlot: '08:00',          // Beste Zeit
  worstTimeSlot: '22:00',         // Schlechteste Zeit
  trend: AdherenceTrend.improving,
  recommendations: [
    'Erwägen Sie, Dosis von 22:00 auf 20:00 zu verschieben',
    'An Wochenenden werden zusätzliche Erinnerungen benötigt'
  ]
}
```

**Analysierte Metriken:**
- **Nach Wochentag**: Therapietreue von Montag bis Sonntag
- **Nach Tageszeit**: Morgen, Mittag, Nachmittag, Abend, Nacht
- **Tendenz**: Verbessert sich, stabil, nimmt ab
- **Problemmuster**: Tage/Zeiten mit Therapietreue <50%

#### 14.2. Vorhersage von Auslassungen
```dart
static Future<SkipProbability> predictSkipProbability({
  required String personId,
  required String medicationId,
  required int dayOfWeek,
  required String timeOfDay,
});

// Ergebnis
SkipProbability {
  probability: 0.65,              // 65% Wahrscheinlichkeit
  riskLevel: RiskLevel.high,      // Hohes Risiko
  factors: [
    'Samstage haben 60% mehr Auslassungen',
    'Zeit 22:00 ist durchweg problematisch',
    'Aktuelle Tendenz ist abnehmend'
  ]
}
```

**Verwendete Faktoren:**
- Historisches Auslassungsmuster am gleichen Wochentag
- Leistung zur gleichen Tageszeit
- Aktuelle Therapietreue-Tendenz
- Vergleich mit anderen Medikamenten

#### 14.3. Optimierung von Zeitplänen
```dart
static Future<List<TimeOptimizationSuggestion>> suggestOptimalTimes({
  required String personId,
  required String medicationId,
});

// Vorschläge
[
  TimeOptimizationSuggestion {
    currentTime: '22:00',
    suggestedTime: '20:00',
    currentAdherence: 0.45,         // 45%
    expectedAdherence: 0.82,        // 82%
    improvementPotential: 0.37,     // +37%
    reason: 'Therapietreue um 20:00 ist durchweg hoch'
  }
]
```

**Optimierungslogik:**
1. Identifiziert Zeiten mit niedriger Therapietreue (<70%)
2. Sucht alternative Zeiten mit besserer Historie
3. Berechnet Verbesserungspotenzial
4. Priorisiert nach erwarteter Wirkung

### Anwendungsfälle

#### UI-Integration
```dart
// Statistikbildschirm
final analysis = await IntelligentRemindersService.analyzeAdherence(
  personId: currentPerson.id,
  medicationId: medication.id,
);

// Analyse anzeigen
AdherenceReportCard(analysis: analysis);
```

#### Proaktive Warnungen
```dart
// Hohes Risiko für Auslassung erkennen
final skipProb = await IntelligentRemindersService.predictSkipProbability(
  personId: currentPerson.id,
  medicationId: medication.id,
  dayOfWeek: DateTime.now().weekday,
  timeOfDay: nextDose.time,
);

if (skipProb.riskLevel == RiskLevel.high) {
  await NotificationService.instance.showHighPriorityReminder(
    medication,
    'Wir haben bemerkt, dass Sie an Samstagen Schwierigkeiten haben. Zusätzliche Erinnerung!',
  );
}
```

#### Assistent zur Zeitplanoptimierung
```dart
// Vorschläge anbieten
final suggestions = await IntelligentRemindersService.suggestOptimalTimes(
  personId: currentPerson.id,
  medicationId: medication.id,
);

if (suggestions.isNotEmpty) {
  showDialog(
    context: context,
    builder: (context) => OptimizationDialog(
      suggestions: suggestions,
      onAccept: (suggestion) {
        // Zeitplan aktualisieren
      },
    ),
  );
}
```

### Datenschutz
- Alle Analysen sind 100% lokal
- Keine Daten werden an externe Server gesendet
- Historischer Verlauf wird nur auf dem Gerät gespeichert

---

## 15. Natives Dunkles Theme

### Beschreibung
Vollständig natives dunkles Theme mit automatischer Erkennung der Systempräferenz und nahtlosem Übergang ohne App-Neustart.

### Hauptmerkmale

#### 15.1. Drei Betriebsmodi
```dart
enum ThemeMode {
  system,  // Folgt der Systemkonfiguration
  light,   // Erzwingt helles Theme
  dark     // Erzwingt dunkles Theme
}
```

**System-Modus:**
- Erkennt automatisch das Theme des Betriebssystems
- Ändert sich dynamisch, wenn der Benutzer das System-Theme ändert
- Kein manueller Eingriff erforderlich

#### 15.2. ThemeProvider
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await PreferencesService.setThemeMode(mode);
    notifyListeners();  // Aktualisiert die gesamte App sofort
  }
}
```

**Integration mit Preferences:**
```dart
// Speichern
await PreferencesService.setThemeMode(ThemeMode.dark);

// Laden beim Start
final savedMode = PreferencesService.getThemeMode();
themeProvider.setThemeMode(savedMode);
```

#### 15.3. AppTheme-Definition
```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(...),
    cardTheme: CardTheme(...),
    // Vollständige Anpassung
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(...),
    cardTheme: CardTheme(...),
    // Vollständige Anpassung
  );
}
```

**Angepasste Komponenten:**
- `AppBarTheme`: Kohärente Balkenfarben
- `CardTheme`: Angemessene Erhöhung und Ränder
- `FloatingActionButtonTheme`: Hervorgehobene Buttons
- `InputDecorationTheme`: Konsistente Felder
- `DialogTheme`: Abgerundete Dialoge
- `SnackBarTheme`: Gestaltete Benachrichtigungen
- `TextTheme`: Vollständige Hierarchie

#### 15.4. Verwendung in main.dart
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: MainScreen(),
          );
        },
      ),
    ),
  );
}
```

#### 15.5. Theme-Auswahl-UI
```dart
// In SettingsScreen
ListTile(
  leading: Icon(Icons.palette),
  title: Text('Theme'),
  subtitle: Text(_getThemeModeLabel(themeProvider.themeMode)),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => ThemeSelectionDialog(
        currentMode: themeProvider.themeMode,
        onChanged: (mode) {
          themeProvider.setThemeMode(mode);
        },
      ),
    );
  },
);
```

### Vorteile

**Benutzererfahrung:**
- Augen-komfortabel für nächtliche Nutzung
- Energieeinsparung auf OLED-Bildschirmen (bis zu 40%)
- Reduzierte Blaulichtbelastung
- Automatische Anpassung an das System

**Technisch:**
- Sanfter Übergang ohne App-Neustart
- Persistierte Präferenz zwischen Sitzungen
- 100% native Material 3 Komponenten
- Für beiden Modi optimierte Farben
- Hoher Kontrast für Zugänglichkeit

**Wartbarkeit:**
- Zentralisierte Theme-Definition
- Einfach zu erweiternde benutzerdefinierte Farben
- Konsistenz in der gesamten Anwendung

### Design-Überlegungen

**Helles Theme:**
- Sauberer weißer Hintergrund
- Gedämpfte Schatten
- Lebendige Hervorhebungsfarben
- Optimaler Kontrast für Tageslicht

**Dunkles Theme:**
- Tiefschwarzer Hintergrund (#000000) für Energieeinsparung
- Subtile Schattierungen für Tiefe
- Gedämpfte Farben zur Vermeidung von Blendung
- Erhaltung der Lesbarkeit

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
