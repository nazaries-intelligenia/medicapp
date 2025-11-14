# Beitragsleitfaden

Vielen Dank für Ihr Interesse daran, zu **MedicApp** beizutragen. Dieser Leitfaden wird Ihnen helfen, qualitativ hochwertige Beiträge zu leisten, die der gesamten Community zugute kommen.

---

## Inhaltsverzeichnis

- [Willkommen](#willkommen)
- [Wie man beiträgt](#wie-man-beiträgt)
- [Beitragsprozess](#beitragsprozess)
- [Code-Konventionen](#code-konventionen)
- [Commit-Konventionen](#commit-konventionen)
- [Pull Request Leitfaden](#pull-request-leitfaden)
- [Testing-Leitfaden](#testing-leitfaden)
- [Neue Funktionen hinzufügen](#neue-funktionen-hinzufügen)
- [Bugs melden](#bugs-melden)
- [Übersetzungen hinzufügen](#übersetzungen-hinzufügen)
- [Entwicklungsumgebung einrichten](#entwicklungsumgebung-einrichten)
- [Nützliche Ressourcen](#nützliche-ressourcen)
- [Häufig gestellte Fragen](#häufig-gestellte-fragen)
- [Kontakt und Community](#kontakt-und-community)

---

## Willkommen

Wir freuen uns, dass Sie zu MedicApp beitragen möchten. Dieses Projekt ist dank Menschen wie Ihnen möglich, die ihre Zeit und ihr Wissen einsetzen, um die Gesundheit und das Wohlbefinden von Nutzern weltweit zu verbessern.

### Arten willkommener Beiträge

Wir schätzen alle Arten von Beiträgen:

- **Code**: Neue Funktionen, Bugfixes, Performance-Verbesserungen
- **Dokumentation**: Verbesserungen an bestehender Dokumentation, neue Anleitungen, Tutorials
- **Übersetzungen**: Hinzufügen oder Verbessern von Übersetzungen in den 8 unterstützten Sprachen
- **Testing**: Tests hinzufügen, Abdeckung verbessern, Bugs melden
- **Design**: UI/UX-Verbesserungen, Icons, Assets
- **Ideen**: Verbesserungsvorschläge, Architekturdiskussionen
- **Review**: PRs anderer Beitragender reviewen

### Verhaltenskodex

Dieses Projekt folgt einem Verhaltenskodex des gegenseitigen Respekts:

- **Respektvoll sein**: Behandeln Sie alle mit Respekt und Rücksicht
- **Konstruktiv sein**: Kritik sollte konstruktiv und auf Verbesserung ausgerichtet sein
- **Inklusiv sein**: Fördern Sie eine einladende Umgebung für Menschen aller Hintergründe
- **Professionell sein**: Halten Sie Diskussionen auf das Projekt fokussiert
- **Kooperativ sein**: Arbeiten Sie im Team und teilen Sie Wissen

Jedes unangemessene Verhalten kann den Projekt-Maintainern gemeldet werden.

---

## Wie man beiträgt

### Bugs melden

Wenn Sie einen Bug finden, helfen Sie uns, ihn zu beheben, indem Sie diese Schritte befolgen:

1. **Zuerst suchen**: Überprüfen Sie die [bestehenden Issues](../../issues), um zu sehen, ob er bereits gemeldet wurde
2. **Ein Issue erstellen**: Wenn es ein neuer Bug ist, erstellen Sie ein detailliertes Issue (siehe Abschnitt [Bugs melden](#bugs-melden))
3. **Kontext bereitstellen**: Fügen Sie Schritte zur Reproduktion, erwartetes Verhalten, Screenshots, Logs hinzu
4. **Angemessen kennzeichnen**: Verwenden Sie das Label `bug` im Issue

### Verbesserungen vorschlagen

Haben Sie eine Idee zur Verbesserung von MedicApp?

1. **Überprüfen, ob es bereits existiert**: Suchen Sie in den Issues, ob es jemand bereits vorgeschlagen hat
2. **Ein "Feature Request" Issue erstellen**: Beschreiben Sie Ihren Vorschlag im Detail
3. **Das "Warum" erklären**: Begründen Sie, warum diese Verbesserung wertvoll ist
4. **Vor der Implementierung diskutieren**: Warten Sie auf Feedback der Maintainer, bevor Sie mit dem Codieren beginnen

### Code beitragen

Um Code beizutragen:

1. **Ein Issue finden**: Suchen Sie nach Issues mit den Labels `good first issue` oder `help wanted`
2. **Ihre Absicht kommentieren**: Geben Sie an, dass Sie an diesem Issue arbeiten werden, um Duplikate zu vermeiden
3. **Dem Prozess folgen**: Lesen Sie den Abschnitt [Beitragsprozess](#beitragsprozess)
4. **Einen PR erstellen**: Folgen Sie dem [Pull Request Leitfaden](#pull-request-leitfaden)

### Dokumentation verbessern

Dokumentation ist fundamental:

- **Fehler korrigieren**: Tippfehler, defekte Links, veraltete Informationen
- **Dokumentation erweitern**: Beispiele, Diagramme, klarere Erklärungen hinzufügen
- **Dokumentation übersetzen**: Helfen Sie, Docs in andere Sprachen zu übersetzen
- **Tutorials hinzufügen**: Erstellen Sie Schritt-für-Schritt-Anleitungen für häufige Anwendungsfälle

### In neue Sprachen übersetzen

MedicApp unterstützt derzeit 8 Sprachen. Um eine neue hinzuzufügen oder bestehende Übersetzungen zu verbessern, konsultieren Sie den Abschnitt [Übersetzungen hinzufügen](#übersetzungen-hinzufügen).

---

## Beitragsprozess

Befolgen Sie diese Schritte für einen erfolgreichen Beitrag:

### 1. Repository forken

Forken Sie das Repository in Ihr GitHub-Konto:

```bash
# Von GitHub aus, klicken Sie auf "Fork" in der oberen rechten Ecke
```

### 2. Ihren Fork klonen

Klonen Sie Ihren Fork lokal:

```bash
git clone https://github.com/IHR_BENUTZERNAME/medicapp.git
cd medicapp
```

### 3. Upstream-Repository konfigurieren

Fügen Sie das Original-Repository als "upstream" hinzu:

```bash
git remote add upstream https://github.com/ORIGINAL_REPO/medicapp.git
git fetch upstream
```

### 4. Einen Branch erstellen

Erstellen Sie einen beschreibenden Branch für Ihre Arbeit:

```bash
# Für neue Funktionen
git checkout -b feature/beschreibender-name

# Für Bugfixes
git checkout -b fix/bug-name

# Für Dokumentation
git checkout -b docs/änderungs-beschreibung

# Für Tests
git checkout -b test/test-beschreibung
```

**Branch-Namenskonventionen:**
- `feature/` - Neue Funktion
- `fix/` - Bugfix
- `docs/` - Dokumentationsänderungen
- `test/` - Tests hinzufügen oder verbessern
- `refactor/` - Refactoring ohne funktionale Änderungen
- `style/` - Format-/Stiländerungen
- `chore/` - Wartungsaufgaben

### 5. Änderungen vornehmen

Nehmen Sie Ihre Änderungen vor und befolgen Sie die [Code-Konventionen](#code-konventionen).

### 6. Tests schreiben

**Alle Codeänderungen müssen entsprechende Tests enthalten:**

```bash
# Tests während der Entwicklung ausführen
flutter test

# Spezifische Tests ausführen
flutter test test/pfad/zum/test.dart

# Abdeckung anzeigen
flutter test --coverage
```

Konsultieren Sie den Abschnitt [Testing-Leitfaden](#testing-leitfaden) für weitere Details.

### 7. Code formatieren

Stellen Sie sicher, dass Ihr Code korrekt formatiert ist:

```bash
# Gesamtes Projekt formatieren
dart format .

# Statische Analyse überprüfen
flutter analyze
```

### 8. Commits erstellen

Erstellen Sie Commits gemäß den [Commit-Konventionen](#commit-konventionen):

```bash
git add .
git commit -m "feat: Erinnerungsbenachrichtigung für Nachfüllung hinzufügen"
```

### 9. Branch aktuell halten

Synchronisieren Sie regelmäßig mit dem Upstream-Repository:

```bash
git fetch upstream
git rebase upstream/main
```

### 10. Änderungen pushen

Pushen Sie Ihre Änderungen zu Ihrem Fork:

```bash
git push origin ihr-branch-name
```

### 11. Pull Request erstellen

Erstellen Sie einen PR von GitHub aus gemäß dem [Pull Request Leitfaden](#pull-request-leitfaden).

---

## Code-Konventionen

Konsistenten Code zu pflegen ist fundamental für die Wartbarkeit des Projekts.

### Dart Style Guide

Wir folgen dem offiziellen [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

- **Klassennamen**: `PascalCase` (z.B. `MedicationService`)
- **Variablen-/Funktionsnamen**: `camelCase` (z.B. `getMedications`)
- **Konstantennamen**: `camelCase` (z.B. `maxNotifications`)
- **Dateinamen**: `snake_case` (z.B. `medication_service.dart`)
- **Ordnernamen**: `snake_case` (z.B. `notification_service`)

### Linting

Das Projekt verwendet `flutter_lints`, konfiguriert in `analysis_options.yaml`:

```bash
# Statische Analyse ausführen
flutter analyze

# Es sollte keine Fehler oder Warnungen geben
```

Alle PRs müssen die Analyse ohne Fehler oder Warnungen bestehen.

### Automatische Formatierung

Verwenden Sie `dart format` vor dem Commit:

```bash
# Allen Code formatieren
dart format .

# Spezifische Datei formatieren
dart format lib/services/medication_service.dart
```

**Editor-Konfiguration:**

- **VS Code**: "Format On Save" in den Einstellungen aktivieren
- **Android Studio**: Settings > Editor > Code Style > Dart > Set from: Dart Official

### Namenskonventionen

**Boolesche Variablen:**
```dart
// Gut
bool isActive = true;
bool hasNotifications = false;
bool requiresFasting = true;

// Schlecht
bool active = true;
bool notifications = false;
```

**Methoden, die Werte zurückgeben:**
```dart
// Gut
List<Medication> getMedications();
Future<bool> saveMedication(Medication med);
String calculateNextDose();

// Schlecht
List<Medication> medications();
Future<bool> medication(Medication med);
```

**Private Methoden:**
```dart
// Gut
void _updateDatabase() { }
String _formatDate(DateTime date) { }

// Schlecht
void updateDatabase() { }  // sollte privat sein
String formatDate(DateTime date) { }  // sollte privat sein
```

### Dateiorganisation

**Import-Reihenfolge:**
```dart
// 1. Dart-Imports:
import 'dart:async';
import 'dart:convert';

// 2. Package-Imports:
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// 3. Relative Projekt-Imports:
import '../models/medication.dart';
import '../services/database_service.dart';
```

**Reihenfolge der Mitglieder in Klassen:**
```dart
class Example {
  // 1. Statische Felder
  static const int maxValue = 100;

  // 2. Instanzfelder
  final String name;
  int count;

  // 3. Konstruktor
  Example(this.name, this.count);

  // 4. Öffentliche Methoden
  void publicMethod() { }

  // 5. Private Methoden
  void _privateMethod() { }
}
```

### Kommentare und Dokumentation

**Öffentliche APIs dokumentieren:**
```dart
/// Ruft alle Medikamente einer bestimmten Person ab.
///
/// Gibt eine Liste von [Medication] für die angegebene [personId] zurück.
/// Die Liste ist alphabetisch nach Namen sortiert.
///
/// Wirft [DatabaseException], wenn ein Datenbankfehler auftritt.
Future<List<Medication>> getMedicationsByPerson(String personId) async {
  // Implementierung...
}
```

**Inline-Kommentare bei Bedarf:**
```dart
// Verbleibende Tage basierend auf durchschnittlichem Verbrauch berechnen
final daysRemaining = stockQuantity / averageDailyConsumption;
```

**Offensichtliche Kommentare vermeiden:**
```dart
// Schlecht - unnötiger Kommentar
// Zähler um 1 erhöhen
count++;

// Gut - selbsterklärender Code
count++;
```

---

## Commit-Konventionen

Wir verwenden semantische Commits, um eine klare und lesbare Historie zu pflegen.

### Format

```
typ: kurze Beschreibung in Kleinbuchstaben

[optionaler Körper mit mehr Details]

[optionaler Footer mit Issue-Referenzen]
```

### Commit-Typen

| Typ | Beschreibung | Beispiel |
|------|-------------|---------|
| `feat` | Neue Funktion | `feat: Unterstützung für mehrere Personen hinzufügen` |
| `fix` | Bugfix | `fix: Bestandsberechnung in anderer Zeitzone korrigieren` |
| `docs` | Dokumentationsänderungen | `docs: Installationsanleitung aktualisieren` |
| `test` | Tests hinzufügen oder ändern | `test: Tests für Fasten um Mitternacht hinzufügen` |
| `refactor` | Refactoring ohne funktionale Änderungen | `refactor: Benachrichtigungslogik in Service extrahieren` |
| `style` | Formatänderungen | `style: Code gemäß dart format formatieren` |
| `chore` | Wartungsaufgaben | `chore: Abhängigkeiten aktualisieren` |
| `perf` | Performance-Verbesserungen | `perf: Datenbankabfragen optimieren` |

### Beispiele für gute Commits

```bash
# Neues Feature mit Beschreibung
git commit -m "feat: Fastenbenachrichtigungen mit anpassbarer Dauer hinzufügen"

# Fix mit Issue-Referenz
git commit -m "fix: Berechnung der nächsten Dosis korrigieren (#123)"

# Docs
git commit -m "docs: Beitragsabschnitt in README hinzufügen"

# Test
git commit -m "test: Integrationstests für mehrere Fastenperioden hinzufügen"

# Refactor mit Kontext
git commit -m "refactor: Medikamentenlogik in spezifische Klassen aufteilen

- MedicationValidator für Validierungen erstellen
- Bestandsberechnungen in MedicationStockCalculator extrahieren
- Code-Lesbarkeit verbessern"
```

### Zu vermeidende Commit-Beispiele

```bash
# Schlecht - zu vage
git commit -m "fix bug"
git commit -m "update"
git commit -m "changes"

# Schlecht - ohne Typ
git commit -m "neue Funktionalität hinzufügen"

# Schlecht - falscher Typ
git commit -m "docs: neuen Bildschirm hinzufügen"  # sollte 'feat' sein
```

### Zusätzliche Regeln

- **Erster Buchstabe klein**: "feat: hinzufügen..." nicht "feat: Hinzufügen..."
- **Kein Punkt am Ende**: "feat: Unterstützung hinzufügen" nicht "feat: Unterstützung hinzufügen."
- **Imperativmodus**: "hinzufügen" nicht "hinzugefügt" oder "hinzufügend"
- **Maximal 72 Zeichen**: Halten Sie die erste Zeile kurz
- **Optionaler Körper**: Verwenden Sie den Körper, um das "Warum" zu erklären, nicht das "Was"

---

## Pull Request Leitfaden

### Vor der PR-Erstellung

**Checkliste:**

- [ ] Ihr Code kompiliert ohne Fehler: `flutter run`
- [ ] Alle Tests bestehen: `flutter test`
- [ ] Der Code ist formatiert: `dart format .`
- [ ] Keine Analyse-Warnungen: `flutter analyze`
- [ ] Sie haben Tests für Ihre Änderung hinzugefügt
- [ ] Die Testabdeckung bleibt >= 75%
- [ ] Sie haben die Dokumentation bei Bedarf aktualisiert
- [ ] Die Commits folgen den Konventionen
- [ ] Ihr Branch ist mit `main` aktualisiert

### Pull Request erstellen

**Beschreibender Titel:**

```
feat: Unterstützung für anpassbare Fastenperioden hinzufügen
fix: Crash in Benachrichtigungen um Mitternacht beheben
docs: Architekturdokumentation verbessern
```

**Detaillierte Beschreibung:**

```markdown
## Beschreibung

Dieser PR fügt Unterstützung für anpassbare Fastenperioden hinzu, sodass Benutzer spezifische Dauern vor oder nach der Einnahme eines Medikaments konfigurieren können.

## Durchgeführte Änderungen

- Felder `fastingType` und `fastingDurationMinutes` zum Medication-Modell hinzufügen
- Validierungslogik für Fastenperioden implementieren
- UI zum Konfigurieren von Fasten im Medikamentenbearbeitungsbildschirm hinzufügen
- Ongoing-Benachrichtigungen für aktive Fastenperioden erstellen
- Umfassende Tests hinzufügen (15 neue Tests)

## Art der Änderung

- [x] Neue Funktion (Änderung, die Funktionalität hinzufügt, ohne bestehenden Code zu brechen)
- [ ] Bugfix (Änderung, die ein Issue behebt)
- [ ] Breaking Change (Fix oder Feature, das bestehende Funktionalität ändern würde)
- [ ] Diese Änderung erfordert Dokumentationsaktualisierung

## Screenshots

_Falls zutreffend, Screenshots von UI-Änderungen hinzufügen_

## Tests

- [x] Unit-Tests hinzugefügt
- [x] Integrationstests hinzugefügt
- [x] Alle bestehenden Tests bestehen
- [x] Abdeckung >= 75%

## Checkliste

- [x] Code folgt Projektkonventionen
- [x] Ich habe meinen eigenen Code überprüft
- [x] Ich habe komplexe Bereiche kommentiert
- [x] Ich habe die Dokumentation aktualisiert
- [x] Meine Änderungen erzeugen keine Warnungen
- [x] Ich habe Tests hinzugefügt, die meinen Fix/meine Funktion prüfen
- [x] Neue und bestehende Tests bestehen lokal

## Verwandte Issues

Closes #123
Verwandt mit #456
```

### Während des Reviews

**Auf Kommentare antworten:**
- Bedanken Sie sich für das Feedback
- Beantworten Sie Fragen klar
- Nehmen Sie angeforderte Änderungen zeitnah vor
- Markieren Sie Konversationen als gelöst nach Anwendung der Änderungen

**PR aktuell halten:**
```bash
# Wenn es Änderungen in main gibt, Branch aktualisieren
git fetch upstream
git rebase upstream/main
git push origin ihr-branch --force-with-lease
```

### Nach dem Merge

**Aufräumen:**
```bash
# Fork aktualisieren
git checkout main
git pull upstream main
git push origin main

# Lokalen Branch löschen
git branch -d ihr-branch

# Remote-Branch löschen (optional)
git push origin --delete ihr-branch
```

---

## Testing-Leitfaden

Testing ist **obligatorisch** für alle Code-Beiträge.

### Prinzipien

- **Alle PRs müssen Tests enthalten**: Ohne Ausnahme
- **Mindestabdeckung beibehalten**: >= 75%
- **Tests müssen unabhängig sein**: Jeder Test sollte alleine ausführbar sein
- **Tests müssen deterministisch sein**: Gleicher Input = gleicher Output immer
- **Tests müssen schnell sein**: < 1 Sekunde pro Unit-Test

### Testtypen

**Unit-Tests:**
```dart
// test/models/medication_test.dart
void main() {
  group('Medication', () {
    test('berechnet Bestandstage korrekt', () {
      final medication = MedicationBuilder()
        .withStock(30.0)
        .withSingleDose('08:00', 1.0)
        .build();

      expect(medication.calculateDaysRemaining(), equals(30));
    });
  });
}
```

**Widget-Tests:**
```dart
// test/screens/medication_list_screen_test.dart
void main() {
  testWidgets('zeigt Medikamentenliste korrekt an', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: MedicationListScreen()),
    );

    expect(find.text('Mis Medicamentos'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
```

**Integrationstests:**
```dart
// test/integration/medication_flow_test.dart
void main() {
  testWidgets('vollständiger Flow zum Hinzufügen von Medikament', (tester) async {
    // Setup
    await tester.pumpWidget(MyApp());

    // Medikament hinzufügen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Navigation und Speichern überprüfen
    expect(find.text('Nuevo Medicamento'), findsOneWidget);
  });
}
```

### MedicationBuilder verwenden

Um Testmedikamente zu erstellen, verwenden Sie den Helfer `MedicationBuilder`:

```dart
import 'package:medicapp/test/helpers/medication_builder.dart';

// Einfaches Medikament
final med = MedicationBuilder()
  .withName('Aspirina')
  .withStock(20.0)
  .build();

// Mit Fasten
final medWithFasting = MedicationBuilder()
  .withName('Ibuprofeno')
  .withFasting(type: 'before', duration: 60)
  .build();

// Mit mehreren Dosen
final medMultipleDoses = MedicationBuilder()
  .withName('Vitamina C')
  .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
  .build();

// Mit niedrigem Bestand
final medLowStock = MedicationBuilder()
  .withName('Paracetamol')
  .withLowStock()
  .build();
```

### Tests ausführen

```bash
# Alle Tests
flutter test

# Spezifischer Test
flutter test test/models/medication_test.dart

# Mit Abdeckung
flutter test --coverage

# Abdeckungsbericht anzeigen (erfordert genhtml)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Testabdeckung

**Ziel: >= 75% Abdeckung**

```bash
# Bericht generieren
flutter test --coverage

# Abdeckung pro Datei anzeigen
lcov --list coverage/lcov.info
```

**Kritische Bereiche, die Tests MÜSSEN haben:**
- Modelle und Geschäftslogik (95%+)
- Services und Utilities (90%+)
- Bildschirme und Haupt-Widgets (70%+)

**Bereiche, in denen die Abdeckung geringer sein kann:**
- Rein visuelle Widgets
- Initiale Konfiguration (main.dart)
- Automatisch generierte Dateien

---

## Neue Funktionen hinzufügen

### Bevor Sie beginnen

1. **Zuerst in einem Issue diskutieren**: Erstellen Sie ein Issue, das Ihren Vorschlag beschreibt
2. **Auf Feedback warten**: Die Maintainer werden reviewen und Feedback geben
3. **Genehmigung erhalten**: Warten Sie auf grünes Licht, bevor Sie Zeit in die Implementierung investieren

### Der Architektur folgen

MedicApp verwendet **MVS-Architektur (Model-View-Service)**:

```
lib/
├── models/           # Datenmodelle
├── screens/          # Views (UI)
├── services/         # Geschäftslogik
└── l10n/            # Übersetzungen
```

**Prinzipien:**
- **Models**: Nur Daten, keine Geschäftslogik
- **Services**: Alle Geschäftslogik und Datenzugriff
- **Screens**: Nur UI, minimale Logik

**Beispiel für neue Funktionalität:**

```dart
// 1. Modell hinzufügen (falls nötig)
// lib/models/reminder.dart
class Reminder {
  final String id;
  final String medicationId;
  final DateTime reminderTime;

  Reminder({required this.id, required this.medicationId, required this.reminderTime});
}

// 2. Service hinzufügen
// lib/services/reminder_service.dart
class ReminderService {
  Future<void> scheduleReminder(Reminder reminder) async {
    // Geschäftslogik
  }
}

// 3. Bildschirm/Widget hinzufügen
// lib/screens/reminder_screen.dart
class ReminderScreen extends StatelessWidget {
  // Nur UI, delegiert Logik an Service
}

// 4. Tests hinzufügen
// test/services/reminder_service_test.dart
void main() {
  group('ReminderService', () {
    test('schedule reminder erstellt Benachrichtigung', () async {
      // Test
    });
  });
}
```

### Dokumentation aktualisieren

Beim Hinzufügen neuer Funktionalität:

- [ ] `docs/es/features.md` aktualisieren
- [ ] Verwendungsbeispiele hinzufügen
- [ ] Diagramme bei Bedarf aktualisieren
- [ ] Dokumentationskommentare im Code hinzufügen

### Internationalisierung berücksichtigen

MedicApp unterstützt 8 Sprachen. **Alle neuen Funktionen müssen übersetzt werden:**

```dart
// Anstatt hardcodierten Text:
Text('New Medication')

// Übersetzungen verwenden:
Text(AppLocalizations.of(context)!.newMedication)
```

Fügen Sie die Schlüssel in allen `.arb`-Dateien hinzu:
- `lib/l10n/app_es.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_de.arb`
- `lib/l10n/app_fr.arb`
- `lib/l10n/app_it.arb`
- `lib/l10n/app_ca.arb`
- `lib/l10n/app_eu.arb`
- `lib/l10n/app_gl.arb`

### Umfassende Tests hinzufügen

Neue Funktionalität erfordert vollständige Tests:

- Unit-Tests für alle Logik
- Widget-Tests für UI
- Integrationstests für vollständige Flows
- Tests für Edge Cases und Fehler

---

## Bugs melden

### Erforderliche Informationen

Beim Melden eines Bugs, fügen Sie hinzu:

**1. Bug-Beschreibung:**
Klare und prägnante Beschreibung des Problems.

**2. Schritte zur Reproduktion:**
```
1. Zum Bildschirm 'Medicamentos' gehen
2. Auf 'Agregar medicamento' klicken
3. Fasten von 60 Minuten konfigurieren
4. Medikament speichern
5. Fehler in Konsole sehen
```

**3. Erwartetes Verhalten:**
"Das Medikament sollte mit der Fastenkonfiguration gespeichert werden."

**4. Tatsächliches Verhalten:**
"Ein Fehler 'Invalid fasting duration' wird angezeigt und das Medikament wird nicht gespeichert."

**5. Screenshots/Videos:**
Falls zutreffend, Screenshots oder Bildschirmaufnahme hinzufügen.

**6. Logs/Fehler:**
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Invalid fasting duration
#0      Medication.validate (package:medicapp/models/medication.dart:123)
```

**7. Umgebung:**
```
- Flutter-Version: 3.9.2
- Dart-Version: 3.0.0
- Gerät: Samsung Galaxy S21
- OS: Android 13
- MedicApp-Version: 1.0.0
```

**8. Zusätzlicher Kontext:**
Alle anderen relevanten Informationen über das Problem.

### Issue-Template

```markdown
## Bug-Beschreibung
[Klare und prägnante Beschreibung]

## Schritte zur Reproduktion
1.
2.
3.

## Erwartetes Verhalten
[Was sollte passieren]

## Tatsächliches Verhalten
[Was passiert tatsächlich]

## Screenshots
[Falls zutreffend]

## Logs/Fehler
```
[Logs hier einfügen]
```

## Umgebung
- Flutter-Version:
- Dart-Version:
- Gerät:
- OS und Version:
- MedicApp-Version:

## Zusätzlicher Kontext
[Zusätzliche Informationen]
```

---

## Übersetzungen hinzufügen

MedicApp unterstützt 8 Sprachen. Helfen Sie uns, hochwertige Übersetzungen zu pflegen.

### Dateistandorte

Übersetzungsdateien befinden sich in:

```
lib/l10n/
├── app_es.arb    # Spanisch (Basis)
├── app_en.arb    # Englisch
├── app_de.arb    # Deutsch
├── app_fr.arb    # Französisch
├── app_it.arb    # Italienisch
├── app_ca.arb    # Katalanisch
├── app_eu.arb    # Baskisch
└── app_gl.arb    # Galizisch
```

### Neue Sprache hinzufügen

**1. Vorlage kopieren:**
```bash
cp lib/l10n/app_es.arb lib/l10n/app_XX.arb
```

**2. Alle Schlüssel übersetzen:**
```json
{
  "appTitle": "MedicApp",
  "@appTitle": {
    "description": "Anwendungstitel"
  },
  "medications": "Medikamente",
  "@medications": {
    "description": "Titel des Medikamentenbildschirms"
  }
}
```

**3. `l10n.yaml` aktualisieren** (falls vorhanden):
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

**4. Sprache in `MaterialApp` registrieren:**
```dart
// lib/main.dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: [
    const Locale('es'),
    const Locale('en'),
    const Locale('de'),
    const Locale('fr'),
    const Locale('it'),
    const Locale('ca'),
    const Locale('eu'),
    const Locale('gl'),
    const Locale('XX'),  // Neue Sprache
  ],
  // ...
)
```

**5. Code-Generierung ausführen:**
```bash
flutter pub get
# Übersetzungen werden automatisch generiert
```

**6. In der App testen:**
```dart
// Sprache vorübergehend zum Testen ändern
Locale('XX')
```

### Bestehende Übersetzungen verbessern

**1. Datei identifizieren:**
Zum Beispiel, um Englisch zu verbessern: `lib/l10n/app_en.arb`

**2. Schlüssel finden:**
```json
{
  "lowStockWarning": "Low stock warning",
  "@lowStockWarning": {
    "description": "Warnung bei niedrigem Bestand"
  }
}
```

**3. Übersetzung verbessern:**
```json
{
  "lowStockWarning": "Running low on medication",
  "@lowStockWarning": {
    "description": "Warnung, wenn wenig Medikamentenbestand übrig ist"
  }
}
```

**4. PR erstellen** mit der Änderung.

### Übersetzungsrichtlinien

- **Konsistenz bewahren**: Verwenden Sie dieselben Begriffe in allen Übersetzungen
- **Angemessener Kontext**: Berücksichtigen Sie den medizinischen Kontext
- **Angemessene Länge**: Vermeiden Sie sehr lange Übersetzungen, die die UI brechen
- **Formalität**: Verwenden Sie einen professionellen, aber freundlichen Ton
- **In UI testen**: Überprüfen Sie, dass die Übersetzung auf dem Bildschirm gut aussieht

---

## Entwicklungsumgebung einrichten

### Anforderungen

- **Flutter SDK**: 3.9.2 oder höher
- **Dart SDK**: 3.0 oder höher
- **Editor**: VS Code oder Android Studio empfohlen
- **Git**: Für Versionskontrolle

### Flutter-Installation

**macOS/Linux:**
```bash
# Flutter herunterladen
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Installation überprüfen
flutter doctor
```

**Windows:**
1. Flutter SDK von [flutter.dev](https://flutter.dev) herunterladen
2. Nach `C:\src\flutter` extrahieren
3. `C:\src\flutter\bin` zum PATH hinzufügen
4. `flutter doctor` ausführen

### Editor-Konfiguration

**VS Code (Empfohlen):**

1. **Erweiterungen installieren:**
   - Flutter
   - Dart
   - Flutter Widget Snippets (optional)

2. **settings.json konfigurieren:**
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.rulers": [80]
  },
  "dart.lineLength": 80
}
```

3. **Nützliche Shortcuts:**
   - `Cmd/Ctrl + .` - Schnellaktionen
   - `Cmd/Ctrl + Shift + P` - Command Palette
   - `F5` - Debug
   - `Ctrl + F5` - Ohne Debug ausführen

**Android Studio:**

1. **Plugins installieren:**
   - Flutter-Plugin
   - Dart-Plugin

2. **Konfigurieren:**
   - Settings > Editor > Code Style > Dart
   - Set from: Dart Official
   - Line length: 80

### Linter-Konfiguration

Das Projekt verwendet `flutter_lints`. Es ist bereits in `analysis_options.yaml` konfiguriert.

```bash
# Analyse ausführen
flutter analyze

# Issues in Echtzeit im Editor sehen
# (automatisch in VS Code und Android Studio)
```

### Git-Konfiguration

```bash
# Identität konfigurieren
git config --global user.name "Ihr Name"
git config --global user.email "ihre@email.com"

# Standard-Editor konfigurieren
git config --global core.editor "code --wait"

# Nützliche Aliase konfigurieren
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
```

### Projekt ausführen

```bash
# Abhängigkeiten installieren
flutter pub get

# Im Emulator/Gerät ausführen
flutter run

# Im Debug-Modus ausführen
flutter run --debug

# Im Release-Modus ausführen
flutter run --release

# Hot reload (während Ausführung)
# 'r' im Terminal drücken

# Hot restart (während Ausführung)
# 'R' im Terminal drücken
```

### Häufige Probleme

**"Flutter SDK not found":**
```bash
# PATH überprüfen
echo $PATH  # macOS/Linux
echo %PATH%  # Windows

# Flutter zum PATH hinzufügen
export PATH="$PATH:/pfad/zu/flutter/bin"  # macOS/Linux
```

**"Android licenses not accepted":**
```bash
flutter doctor --android-licenses
```

**"CocoaPods not installed" (macOS):**
```bash
sudo gem install cocoapods
pod setup
```

---

## Nützliche Ressourcen

### Projektdokumentation

- [Installationsanleitung](installation.md)
- [Funktionen](features.md)
- [Architektur](architecture.md)
- [Datenbank](database.md)
- [Projektstruktur](project-structure.md)
- [Technologien](technologies.md)

### Externe Dokumentation

**Flutter:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

**Material Design 3:**
- [Material Design Guidelines](https://m3.material.io/)
- [Material Components](https://m3.material.io/components)
- [Material Theming](https://m3.material.io/foundations/customization)

**SQLite:**
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [sqflite Package](https://pub.dev/packages/sqflite)

**Testing:**
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Tools

- [Dart Pad](https://dartpad.dev/) - Online Dart Playground
- [FlutLab](https://flutlab.io/) - Online Flutter IDE
- [DartDoc](https://dart.dev/tools/dartdoc) - Dokumentationsgenerator
- [Flutter Inspector](https://docs.flutter.dev/development/tools/devtools/inspector) - Widget-Debugging

### Community

- [Flutter Discord](https://discord.gg/flutter)
- [r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)

---

## Häufig gestellte Fragen

### Wie fange ich an, beizutragen?

1. Lesen Sie diesen Leitfaden vollständig
2. Richten Sie Ihre Entwicklungsumgebung ein
3. Suchen Sie nach Issues mit dem Label `good first issue`
4. Kommentieren Sie im Issue, dass Sie daran arbeiten werden
5. Folgen Sie dem [Beitragsprozess](#beitragsprozess)

### Wo kann ich helfen?

Bereiche, in denen wir immer Hilfe benötigen:

- **Übersetzungen**: Übersetzungen verbessern oder hinzufügen
- **Dokumentation**: Docs erweitern oder verbessern
- **Tests**: Testabdeckung erhöhen
- **Bugs**: Gemeldete Issues lösen
- **UI/UX**: Interface und Benutzererfahrung verbessern

Suchen Sie nach Issues mit Labels:
- `good first issue` - Ideal zum Einstieg
- `help wanted` - Hier brauchen wir Hilfe
- `documentation` - Bezogen auf Dokumentation
- `translation` - Übersetzungen
- `bug` - Gemeldete Bugs

### Wie lange dauern Reviews?

- **Kleine PRs** (< 100 Zeilen): 1-2 Tage
- **Mittlere PRs** (100-500 Zeilen): 3-5 Tage
- **Große PRs** (> 500 Zeilen): 1-2 Wochen

**Tipps für schnellere Reviews:**
- Halten Sie PRs klein und fokussiert
- Schreiben Sie gute Beschreibungen
- Antworten Sie zeitnah auf Kommentare
- Fügen Sie vollständige Tests hinzu

### Was tue ich, wenn mein PR nicht akzeptiert wird?

Seien Sie nicht entmutigt. Es gibt mehrere Gründe:

1. **Nicht mit Projektvision abgestimmt**: Diskutieren Sie die Idee zuerst in einem Issue
2. **Benötigt Änderungen**: Wenden Sie das Feedback an und aktualisieren Sie den PR
3. **Technische Probleme**: Beheben Sie die erwähnten Issues
4. **Timing**: Es ist vielleicht nicht der richtige Zeitpunkt, aber es wird später überdacht

**Sie werden immer etwas Wertvolles aus dem Prozess lernen.**

### Kann ich an mehreren Issues gleichzeitig arbeiten?

Wir empfehlen, sich auf eines nach dem anderen zu konzentrieren:

- Schließen Sie ein Issue ab, bevor Sie ein anderes beginnen
- Vermeiden Sie, Issues für andere zu blockieren
- Wenn Sie pausieren müssen, kommentieren Sie im Issue

### Wie gehe ich mit Merge-Konflikten um?

```bash
# Branch mit main aktualisieren
git fetch upstream
git rebase upstream/main

# Wenn es Konflikte gibt, wird Git Sie informieren
# Lösen Sie Konflikte in Ihrem Editor
# Dann:
git add .
git rebase --continue

# Push (mit force, wenn Sie zuvor gepusht hatten)
git push origin ihr-branch --force-with-lease
```

### Muss ich ein CLA unterschreiben?

Derzeit erfordern wir **kein** CLA (Contributor License Agreement). Durch Ihren Beitrag stimmen Sie zu, dass Ihr Code unter AGPL-3.0 lizenziert wird.

### Kann ich anonym beitragen?

Ja, aber Sie benötigen ein GitHub-Konto. Sie können einen anonymen Benutzernamen verwenden, wenn Sie möchten.

---

## Kontakt und Community

### GitHub Issues

Die Hauptkommunikationsform erfolgt über [GitHub Issues](../../issues):

- **Bugs melden**: Erstellen Sie ein Issue mit Label `bug`
- **Verbesserungen vorschlagen**: Erstellen Sie ein Issue mit Label `enhancement`
- **Fragen stellen**: Erstellen Sie ein Issue mit Label `question`
- **Ideen diskutieren**: Erstellen Sie ein Issue mit Label `discussion`

### Discussions (falls zutreffend)

Wenn das Repository GitHub Discussions aktiviert hat:

- Allgemeine Fragen
- Ihre Projekte mit MedicApp zeigen
- Ideen teilen
- Anderen Benutzern helfen

### Antwortzeiten

- **Dringende Issues** (kritische Bugs): 24-48 Stunden
- **Normale Issues**: 3-7 Tage
- **PRs**: Je nach Größe (siehe FAQ)
- **Fragen**: 2-5 Tage

### Maintainer

Die Projekt-Maintainer werden Issues, PRs überprüfen und Fragen beantworten. Haben Sie Geduld, wir sind ein kleines Team, das in unserer Freizeit daran arbeitet.

---

## Danksagungen

Vielen Dank, dass Sie diesen Leitfaden gelesen haben und für Ihr Interesse daran, zu MedicApp beizutragen.

Jeder Beitrag, egal wie klein, macht einen Unterschied für die Benutzer, die auf diese Anwendung angewiesen sind, um ihre Gesundheit zu verwalten.

**Wir freuen uns auf Ihren Beitrag!**

---

**Lizenz:** Dieses Projekt steht unter [AGPL-3.0](../../LICENSE).

**Letzte Aktualisierung:** 2025-11-14
