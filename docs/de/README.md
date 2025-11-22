# MedicApp

[![Tests](https://img.shields.io/badge/tests-570%2B-brightgreen)](../../test)
[![Abdeckung](https://img.shields.io/badge/abdeckung-%3E80%25-green)](../../test)
[![Flutter](https://img.shields.io/badge/Flutter-3.9.2%2B-02569B?logo=flutter)](https://flutter.dev)
[![Material Design](https://img.shields.io/badge/Material%20Design-3-757575?logo=material-design)](https://m3.material.io)
[![Dart](https://img.shields.io/badge/Dart-3.10.0-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3-003B57?logo=sqlite)](https://www.sqlite.org)

**MedicApp** ist eine umfassende mobile Anwendung zur Medikamentenverwaltung, entwickelt mit Flutter. Sie wurde entwickelt, um Benutzern und Pflegekräften zu helfen, die Medikamentenverwaltung für mehrere Personen effizient und sicher zu organisieren und zu kontrollieren.

---

## Inhaltsverzeichnis

- [Projektbeschreibung](#projektbeschreibung)
- [Hauptfunktionen](#hauptfunktionen)
- [Screenshots](#screenshots)
- [Schnellstart](#schnellstart)
- [Dokumentation](#dokumentation)
- [Projektstatus](#projektstatus)
- [Lizenz](#lizenz)

---

## Projektbeschreibung

MedicApp ist eine umfassende Lösung für die Medikamentenverwaltung, die es Benutzern ermöglicht, medizinische Behandlungen für mehrere Personen aus einer einzigen Anwendung zu verwalten. Mit Fokus auf Benutzerfreundlichkeit und Barrierefreiheit erleichtert MedicApp die Verfolgung von Einnahmezeiten, Bestandskontrolle, Verwaltung von Fastenzeiten und intelligente Benachrichtigungen.

Die Anwendung implementiert eine saubere Architektur mit Trennung der Verantwortlichkeiten, Zustandsverwaltung mit Provider und eine robuste SQLite-Datenbank, die Datenpersistenz und -synchronisation gewährleistet. Mit Unterstützung für 8 Sprachen und Material Design 3 bietet MedicApp ein modernes und zugängliches Erlebnis für Benutzer weltweit.

Ideal für Patienten mit komplexen Behandlungen, professionelle Pflegekräfte, Familien, die die Medikation mehrerer Mitglieder verwalten, und alle, die ein zuverlässiges System für Erinnerungen und Medikamentenverfolgung benötigen.

---

## Hauptfunktionen

### 1. **Multi-Personen-Verwaltung**
Verwalten Sie Medikamente für mehrere Personen aus einer einzigen Anwendung. Jede Person hat ihr eigenes Profil, Medikamente, erfasste Einnahmen und unabhängige Statistiken (Datenbank V19+).

### 2. **14 Medikamententypen**
Vollständige Unterstützung für verschiedene Medikamententypen: Tablette, Kapsel, Sirup, Injektion, Inhalator, Creme, Tropfen, Pflaster, Zäpfchen, Spray, Pulver, Gel, Verband und Sonstige.

### 3. **Intelligente Benachrichtigungen**
Fortschrittliches Benachrichtigungssystem mit Schnellaktionen (Einnehmen/Verschieben/Überspringen), automatische Begrenzung auf 5 aktive Benachrichtigungen und fortlaufende Benachrichtigungen für laufende Fastenzeiten.

### 4. **Erweiterte Bestandskontrolle**
Automatische Bestandsverfolgung mit konfigurierbaren Warnungen, Benachrichtigungen bei niedrigem Bestand und Erinnerungen zum Nachfüllen von Medikamenten, bevor sie aufgebraucht sind.

### 5. **Verwaltung von Fastenzeiten**
Konfigurieren Sie Fastenzeiten vor/nach der Medikamenteneinnahme mit fortlaufenden Benachrichtigungen, Zeitplanvalidierung und intelligenten Warnungen, die nur laufende oder zukünftige Fastenzeiten anzeigen.

### 6. **Vollständiger Einnahmeverlauf**
Detaillierte Aufzeichnung aller Einnahmen mit Status (Eingenommen, Übersprungen, Verschoben), präzisen Zeitstempeln, Bestandsintegration und Therapietreue-Statistiken pro Person.

### 7. **Mehrsprachige Oberfläche**
Vollständige Unterstützung für 8 Sprachen: Spanisch, Englisch, Französisch, Deutsch, Italienisch, Portugiesisch, Katalanisch und Baskisch, mit dynamischem Wechsel ohne Neustart der Anwendung.

### 8. **Material Design 3**
Moderne Oberfläche mit hellem/dunklem Thema, adaptiven Komponenten, flüssigen Animationen und responsivem Design, das sich an verschiedene Bildschirmgrößen anpasst.

### 9. **Robuste Datenbank**
SQLite V19 mit automatischen Migrationen, optimierten Indizes, Validierung der referenziellen Integrität und vollständigem Trigger-System zur Aufrechterhaltung der Datenkonsistenz.

### 10. **Umfassende Tests**
Über 570 automatisierte Tests (>80% Abdeckung) einschließlich Unit-Tests, Widget-Tests, Integrationstests und spezifische Tests für Grenzfälle wie Benachrichtigungen um Mitternacht.

### 11. **Anpassungssystem für das Erscheinungsbild**
Wählen Sie aus mehreren Farbpaletten nach Ihren Präferenzen:
- **Sea Green**: Natürliche grüne Töne inspiriert vom Wald (Standard)
- **Material 3**: Baseline-Lila-Palette von Material Design 3 (#6750A4)
- Intuitiver Selektor im Einstellungsbildschirm mit Vorschau
- Benutzerbezogene Präferenz-Persistenz
- Vollständige Unterstützung für helle und dunkle Themen in beiden Paletten

### 12. **Benachrichtigungskonfiguration (Android)**
Passen Sie Ton und Verhalten von Benachrichtigungen vollständig an:
- Direkter Zugang zu Systembenachrichtigungseinstellungen aus der App
- Konfigurieren Sie Klingelton, Vibration, Priorität und weitere erweiterte Optionen
- Verwaltung über Benachrichtigungskanäle (Android 8.0+)
- Option wird automatisch auf inkompatiblen Plattformen ausgeblendet (iOS)

---

## Screenshots

_Abschnitt reserviert für zukünftige Screenshots der Anwendung._

---

## Schnellstart

### Voraussetzungen
- Flutter 3.9.2 oder höher
- Dart 3.10.0 oder höher
- Android Studio / VS Code mit Flutter-Erweiterungen

### Installation

```bash
# Repository klonen
git clone <repository-url>
cd medicapp

# Abhängigkeiten installieren
flutter pub get

# Anwendung ausführen
flutter run

# Tests ausführen
flutter test

# Abdeckungsbericht erstellen
flutter test --coverage
```

---

## Dokumentation

Die vollständige Projektdokumentation ist im Verzeichnis `docs/de/` verfügbar:

- **[Installationsanleitung](installation.md)** - Anforderungen, Installation und Erstkonfiguration
- **[Funktionen](features.md)** - Detaillierte Dokumentation aller Funktionalitäten
- **[Architektur](architecture.md)** - Projektstruktur, Muster und Designentscheidungen
- **[Datenbank](database.md)** - Schema, Migrationen, Trigger und Optimierungen
- **[Projektstruktur](project-structure.md)** - Organisation von Dateien und Verzeichnissen
- **[Technologien](technologies.md)** - Technologie-Stack und verwendete Abhängigkeiten
- **[Testing](testing.md)** - Testing-Strategie, Testtypen und Beitragsleitfäden
- **[Beitrag](contributing.md)** - Leitfäden zur Projektbeitragung
- **[Fehlerbehebung](troubleshooting.md)** - Häufige Probleme und Lösungen

---

## Projektstatus

- **Datenbankversion**: V19 (mit Multi-Personen-Unterstützung)
- **Tests**: 570+ automatisierte Tests
- **Abdeckung**: >80%
- **Unterstützte Sprachen**: 8 (ES, EN, CA, DE, EU, FR, GL, IT)
- **Medikamententypen**: 14
- **Farbpaletten**: 2 (Sea Green, Material 3)
- **Flutter**: 3.9.2+
- **Dart**: 3.10.0
- **Material Design**: 3
- **Status**: In aktiver Entwicklung

---

## Lizenz

Dieses Projekt ist lizenziert unter der [GNU Affero General Public License v3.0 (AGPL-3.0)](../../LICENSE).

Die AGPL-3.0 ist eine Copyleft-Freie-Software-Lizenz, die erfordert, dass jede modifizierte Version der Software, die auf einem Netzwerkserver läuft, ebenfalls als Open Source verfügbar gemacht wird.

---

**Entwickelt mit Flutter und Material Design 3**
