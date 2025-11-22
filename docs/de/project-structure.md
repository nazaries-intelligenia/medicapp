# Projektstruktur von MedicApp

Dieses Dokument beschreibt die Organisation von Ordnern und Dateien des MedicApp-Projekts, einer Flutter-Anwendung zur Medikamentenverwaltung und Erinnerungen.

## Verzeichnisbaum

### Struktur von `lib/`

```
lib/
├── main.dart
├── database/
│   └── database_helper.dart
├── models/
│   ├── person.dart
│   ├── medication.dart
│   ├── person_medication.dart
│   ├── dose_history_entry.dart
│   ├── medication_type.dart
│   └── treatment_duration_type.dart
├── providers/
│   └── theme_provider.dart
├── theme/
│   └── app_theme.dart
├── screens/
│   ├── main_screen.dart
│   ├── medication_list_screen.dart
│   ├── medicine_cabinet_screen.dart
│   ├── dose_history_screen.dart
│   ├── settings_screen.dart
│   ├── medication_info_screen.dart
│   ├── medication_frequency_screen.dart
│   ├── medication_dosage_screen.dart
│   ├── medication_times_screen.dart
│   ├── medication_dates_screen.dart
│   ├── medication_duration_screen.dart
│   ├── medication_fasting_screen.dart
│   ├── medication_quantity_screen.dart
│   ├── medication_inventory_screen.dart
│   ├── medication_stock_screen.dart
│   ├── weekly_days_selector_screen.dart
│   ├── specific_dates_selector_screen.dart
│   ├── dose_action_screen.dart
│   ├── edit_medication_menu_screen.dart
│   ├── debug_notifications_screen.dart
│   ├── medication_list/
│   │   ├── medication_cache_manager.dart
│   │   ├── dialogs/
│   │   │   ├── dose_selection_dialog.dart
│   │   │   ├── extra_dose_confirmation_dialog.dart
│   │   │   ├── medication_options_sheet.dart
│   │   │   ├── notification_permission_dialog.dart
│   │   │   ├── debug_info_dialog.dart
│   │   │   └── edit_today_dose_dialog.dart
│   │   ├── services/
│   │   │   └── dose_calculation_service.dart
│   │   └── widgets/
│   │       ├── battery_optimization_banner.dart
│   │       ├── empty_medications_view.dart
│   │       ├── today_doses_section.dart
│   │       └── debug_menu.dart
│   ├── medicine_cabinet/
│   │   ├── medication_person_assignment_screen.dart
│   │   ├── dialogs/
│   │   └── widgets/
│   │       ├── medication_card.dart
│   │       ├── medication_options_modal.dart
│   │       ├── empty_cabinet_view.dart
│   │       └── no_search_results_view.dart
│   ├── dose_history/
│   │   ├── dialogs/
│   │   │   ├── delete_confirmation_dialog.dart
│   │   │   └── edit_entry_dialog.dart
│   │   └── widgets/
│   │       ├── dose_history_card.dart
│   │       ├── active_filters_chip.dart
│   │       ├── empty_history_view.dart
│   │       ├── filter_dialog.dart
│   │       ├── stat_card.dart
│   │       └── statistics_card.dart
│   ├── dose_action/
│   │   └── widgets/
│   │       ├── postpone_buttons.dart
│   │       ├── skip_dose_button.dart
│   │       └── take_dose_button.dart
│   ├── edit_medication_menu/
│   │   └── widgets/
│   │       └── edit_menu_option.dart
│   ├── edit_sections/
│   │   ├── edit_basic_info_screen.dart
│   │   ├── edit_frequency_screen.dart
│   │   ├── edit_schedule_screen.dart
│   │   ├── edit_duration_screen.dart
│   │   ├── edit_fasting_screen.dart
│   │   ├── edit_quantity_screen.dart
│   │   ├── edit_frequency/
│   │   │   └── widgets/
│   │   │       ├── frequency_options_list.dart
│   │   │       ├── custom_interval_config_card.dart
│   │   │       ├── specific_dates_config_card.dart
│   │   │       └── weekly_pattern_config_card.dart
│   │   ├── edit_duration/
│   │   │   └── widgets/
│   │   │       ├── duration_type_info_card.dart
│   │   │       └── treatment_dates_card.dart
│   │   └── edit_quantity/
│   │       └── widgets/
│   ├── medication_dates/
│   │   └── widgets/
│   │       ├── clear_date_button.dart
│   │       ├── date_selector_card.dart
│   │       ├── dates_help_info.dart
│   │       └── duration_summary.dart
│   ├── medication_dosage/
│   │   └── widgets/
│   │       ├── custom_doses_input_card.dart
│   │       ├── dosage_mode_option_card.dart
│   │       ├── dose_summary_info.dart
│   │       └── interval_input_card.dart
│   ├── medication_duration/
│   │   └── widgets/
│   │       ├── duration_option_card.dart
│   │       └── specific_dates_selector_card.dart
│   ├── medication_frequency/
│   │   └── widgets/
│   │       └── weekly_days_selector_card.dart
│   ├── medication_quantity/
│   │   └── widgets/
│   │       └── medication_summary_card.dart
│   ├── medication_stock/
│   │   └── widgets/
│   │       ├── empty_stock_view.dart
│   │       ├── medication_stock_card.dart
│   │       └── stock_summary_card.dart
│   ├── persons/
│   │   ├── add_edit_person_screen.dart
│   │   └── persons_management_screen.dart
│   ├── settings/
│   │   └── widgets/
│   │       ├── info_card.dart
│   │       ├── setting_option_card.dart
│   │       └── setting_switch_card.dart
│   ├── specific_dates_selector/
│   │   └── widgets/
│   │       ├── date_list_tile.dart
│   │       ├── instructions_card.dart
│   │       └── selected_dates_list_card.dart
│   └── weekly_days_selector/
│       └── widgets/
│           ├── day_selection_tile.dart
│           └── selection_count_info.dart
├── services/
│   ├── notification_service.dart
│   ├── dose_action_service.dart
│   ├── dose_history_service.dart
│   ├── preferences_service.dart
│   ├── notification_id_generator.dart
│   ├── smart_cache_service.dart
│   ├── intelligent_reminders_service.dart
│   └── notifications/
│       ├── notification_config.dart
│       ├── notification_cancellation_manager.dart
│       ├── daily_notification_scheduler.dart
│       ├── weekly_notification_scheduler.dart
│       └── fasting_notification_scheduler.dart
├── widgets/
│   ├── action_buttons.dart
│   ├── medication_header_card.dart
│   └── forms/
│       ├── medication_info_form.dart
│       ├── frequency_option_card.dart
│       └── fasting_configuration_form.dart
├── utils/
│   ├── datetime_extensions.dart
│   ├── medication_sorter.dart
│   ├── number_utils.dart
│   └── platform_helper.dart
└── l10n/
    ├── app_es.arb
    ├── app_en.arb
    ├── app_ca.arb
    ├── app_eu.arb
    ├── app_gl.arb
    ├── app_fr.arb
    ├── app_de.arb
    ├── app_it.arb
    ├── app_localizations.dart (generiert)
    └── app_localizations_*.dart (generiert)
```

### Struktur von `test/`

```
test/
├── helpers/
│   ├── test_helpers.dart
│   ├── database_test_helper.dart
│   ├── medication_builder.dart
│   ├── person_test_helper.dart
│   ├── notification_test_helper.dart
│   ├── widget_test_helpers.dart
│   └── test_constants.dart
├── integration/
│   ├── add_medication_test.dart
│   ├── app_startup_test.dart
│   ├── debug_menu_test.dart
│   ├── delete_medication_test.dart
│   ├── dose_registration_test.dart
│   ├── edit_medication_test.dart
│   ├── medication_modal_test.dart
│   ├── navigation_test.dart
│   └── stock_management_test.dart
├── as_needed_main_screen_display_test.dart
├── as_needed_stock_test.dart
├── database_export_import_test.dart
├── database_refill_test.dart
├── day_navigation_test.dart
├── day_navigation_ui_test.dart
├── deletion_cleanup_test.dart
├── dose_action_service_test.dart
├── dose_history_service_test.dart
├── dose_management_test.dart
├── early_dose_notification_test.dart
├── early_dose_with_fasting_test.dart
├── edit_duration_screen_test.dart
├── edit_fasting_screen_test.dart
├── edit_schedule_screen_test.dart
├── edit_screens_validation_test.dart
├── extra_dose_test.dart
├── fasting_countdown_test.dart
├── fasting_field_preservation_test.dart
├── fasting_notification_test.dart
├── fasting_test.dart
├── medication_model_test.dart
├── medication_sorting_test.dart
├── multiple_fasting_prioritization_test.dart
├── notification_actions_test.dart
├── notification_cancellation_test.dart
├── notification_limits_test.dart
├── notification_midnight_edge_cases_test.dart
├── notification_multi_person_test.dart
├── notification_person_title_test.dart
├── notification_service_test.dart
├── notification_sync_test.dart
├── preferences_service_test.dart
└── settings_screen_test.dart
```

### Wichtige Root-Dateien

```
medicapp/
├── pubspec.yaml              # Projektabhängigkeiten und -konfiguration
├── l10n.yaml                 # Lokalisierungskonfiguration
├── analysis_options.yaml     # Linting-Regeln
├── android/
│   └── app/
│       └── build.gradle      # Android-Konfiguration
└── ios/
    └── Runner/
        └── Info.plist        # iOS-Konfiguration
```

## Verzeichnis `lib/`

### `lib/main.dart`

Einstiegspunkt der Anwendung. Verantwortlichkeiten:

- Benachrichtigungsdienst initialisieren
- Benachrichtigungsberechtigungen anfordern
- Standardperson ("Ich") erstellen falls nicht vorhanden
- MaterialApp konfigurieren mit:
  - Zugänglichen hellen und dunklen Themen (größere Schriften)
  - Lokalisierungsunterstützung (8 Sprachen)
  - GlobalKey für Navigation von Benachrichtigungen
  - Navigationsrouten
- Benachrichtigungen im Hintergrund beim Start neu planen

### `lib/database/`

#### `database_helper.dart`

Singleton, der alle Datenpersistenz mit SQLite verwaltet. Verantwortlichkeiten:

- Datenbankschema erstellen und aktualisieren
- CRUD für Personen (Person)
- CRUD für Medikamente (Medication)
- CRUD für Person-Medikament-Zuweisungen (PersonMedication)
- CRUD für Dosishistorie (DoseHistoryEntry)
- Komplexe Abfragen zum Abrufen aktiver Medikamente nach Person
- Datenbank exportieren und importieren (Backup/Wiederherstellung)
- Unterstützung für In-Memory-Datenbank (Testing)

### `lib/models/`

Datenmodelle, die Domain-Entitäten repräsentieren:

#### `person.dart`

Repräsentiert eine Person, die Medikamente einnimmt:

- `id`: Eindeutige UUID
- `name`: Name der Person
- `isDefault`: Gibt an ob Standardperson ("Ich")
- JSON- und Map-Konvertierung für SQLite

#### `medication.dart`

Repräsentiert ein Medikament im Schrank:

- Basisinformationen: Name, Typ, Notizen
- Menge und Bestand
- Häufigkeit: täglich, wöchentlich, benutzerdefiniertes Intervall, bestimmte Daten, nach Bedarf
- Einnahmezeiten
- Behandlungsdauer: kontinuierlich, Enddatum, Dosisanzahl
- Fastenkonfiguration (optional)
- Methoden zur Berechnung nächster Dosen
- Vollständigkeitsvalidierungen

#### `person_medication.dart`

Verknüpft Medikamente mit Personen:

- `personId`: Referenz zu Person
- `medicationId`: Referenz zu Medication
- `isActive`: Ob für Person aktiv
- Verwendet zur Zuweisung von Schrankmedikamenten zu bestimmten Personen

#### `dose_history_entry.dart`

Aufzeichnung einer eingenommenen, ausgelassenen oder verschobenen Dosis:

- `medicationId`: Zugehöriges Medikament
- `personId`: Person, die Dosis eingenommen/ausgelassen hat
- `scheduledTime`: Ursprünglich geplante Zeit
- `actualTime`: Tatsächliche Registrierungszeit
- `status`: taken, skipped, postponed
- `wasEarly`: Ob vorzeitig eingenommen
- `isExtraDose`: Ob nicht geplante Extra-Dosis
- `notes`: Optionale Notizen

#### `medication_type.dart`

Aufzählung von Medikamententypen:

- Tablette, Kapsel, Sirup, Injektion
- Inhalator, Creme, Pflaster
- Verband, Tropfen, Andere

#### `treatment_duration_type.dart`

Aufzählung von Behandlungsdauertypen:

- `continuous`: Ohne Enddatum
- `untilDate`: Bis zu einem bestimmten Datum
- `numberOfDoses`: Begrenzte Anzahl von Dosen

### `lib/screens/`

Anwendungsbildschirme nach Funktionalität organisiert.

#### Hauptbildschirme

- **`main_screen.dart`**: Hauptnavigation mit BottomNavigationBar
- **`medication_list_screen.dart`**: Liste aktiver Medikamente der Person, heutige Dosen
- **`medicine_cabinet_screen.dart`**: Geteilter Schrank mit allen Medikamenten
- **`dose_history_screen.dart`**: Dosishistorie mit Filtern und Statistiken
- **`settings_screen.dart`**: Konfiguration, DB-Export/Import, Personenverwaltung

#### Medikament-Hinzufügen-Ablauf (Wizard)

Sequentielle Navigation zum Erstellen eines Medikaments:

1. **`medication_info_screen.dart`**: Name, Typ, Notizen
2. **`medication_frequency_screen.dart`**: Häufigkeit (täglich, wöchentlich, Intervall, Daten)
3. **`medication_dosage_screen.dart`**: Dosis pro Einnahme oder Intervall zwischen Dosen
4. **`medication_times_screen.dart`**: Einnahmezeiten
5. **`medication_dates_screen.dart`**: Startdatum (und optionales Enddatum)
6. **`medication_duration_screen.dart`**: Behandlungsdauertyp
7. **`medication_fasting_screen.dart`**: Fastenkonfiguration (optional)
8. **`medication_quantity_screen.dart`**: Menge pro Einnahme
9. **`medication_inventory_screen.dart`**: Anfangsbestand und Warnschwelle

#### Bearbeitungsbildschirme

In `edit_sections/` platziert:

- **`edit_basic_info_screen.dart`**: Name, Typ, Notizen bearbeiten
- **`edit_frequency_screen.dart`**: Häufigkeit ändern
- **`edit_schedule_screen.dart`**: Zeitpläne ändern
- **`edit_duration_screen.dart`**: Behandlungsdauer anpassen
- **`edit_fasting_screen.dart`**: Fasten konfigurieren
- **`edit_quantity_screen.dart`**: Menge ändern

Jeder Abschnitt hat seinen eigenen Ordner mit spezifischen Widgets.

#### Unterstützungsbildschirme

- **`weekly_days_selector_screen.dart`**: Wochentagsauswahl
- **`specific_dates_selector_screen.dart`**: Bestimmte Datumsauswahl
- **`dose_action_screen.dart`**: Dosis registrieren (einnehmen, auslassen, verschieben)
- **`edit_medication_menu_screen.dart`**: Menü zum Bearbeiten von Medikamenten
- **`medication_stock_screen.dart`**: Medikamentenbestandsverwaltung
- **`debug_notifications_screen.dart`**: Debug-Bildschirm für Benachrichtigungen (Entwicklung)

#### Personenbildschirme

In `persons/` platziert:

- **`persons_management_screen.dart`**: Personenliste und -verwaltung
- **`add_edit_person_screen.dart`**: Person erstellen oder bearbeiten

#### Schrankbildschirme

In `medicine_cabinet/` platziert:

- **`medication_person_assignment_screen.dart`**: Medikament Personen zuweisen

#### Organisation nach Modulen

Jeder komplexe Bildschirm hat seinen eigenen Ordner mit:

- **`dialogs/`**: Bildschirmspezifische Dialoge
- **`widgets/`**: Wiederverwendbare Widgets innerhalb des Bildschirms
- **`services/`**: Spezifische Geschäftslogik (z.B.: dose_calculation_service)

### `lib/services/`

Dienste, die Geschäftslogik und komplexe Operationen kapseln.

#### `notification_service.dart`

Hauptbenachrichtigungsdienst. Verantwortlichkeiten:

- flutter_local_notifications initialisieren
- Benachrichtigungsberechtigungen anfordern
- Medikamentenbenachrichtigungen planen/stornieren
- Fasten-Benachrichtigungen verwalten (ongoing)
- Benachrichtigungen nach Person verwalten
- Auf Benachrichtigungsaktionen reagieren (einnehmen, auslassen)
- Benachrichtigungen auf 500 begrenzen (Android-Maximum)

#### `dose_action_service.dart`

Verwaltet Aktionen auf Dosen:

- Eingenommene Dosis registrieren
- Dosis auslassen
- Dosis verschieben
- Extra-Dosis registrieren
- Bestand automatisch aktualisieren
- Benachrichtigungen nach Aktion neu planen

#### `dose_history_service.dart`

Operationen auf Dosishistorie:

- Historie gefiltert nach Datum, Medikament, Person abrufen
- Statistiken berechnen (Therapietreue, eingenommene/ausgelassene Dosen)
- Historieneinträge bearbeiten
- Einträge löschen

#### `preferences_service.dart`

Verwaltet Benutzereinstellungen mit SharedPreferences:

- ID der aktiven Person
- Benachrichtigungskonfiguration
- UI-Einstellungen
- Letztes Nutzungsdatum
- Theme-Modus (hell/dunkel/system)

#### `smart_cache_service.dart`

Intelligentes Cache-System für häufig abgerufene Daten:

- Generisches Cache mit TTL (Time-To-Live)
- LRU-Algorithmus (Least Recently Used)
- Automatische Ungültigmachung abgelaufener Einträge
- Echtzeit-Statistiken (Hits, Misses, Hit Rate)
- Spezialisierte Caches:
  - `medicationsCache`: Einzelne Medikamente (10 Min TTL)
  - `listsCache`: Medikamentenlisten (5 Min TTL)
  - `historyCache`: Dosisverlauf (3 Min TTL)
  - `statisticsCache`: Statistische Berechnungen (30 Min TTL)

#### `intelligent_reminders_service.dart`

Service für Therapietreue-Analyse und prädiktive Erinnerungen:

- Analyse der Therapietreue nach Wochentag und Tageszeit
- Vorhersage der Wahrscheinlichkeit, Dosen auszulassen
- Empfehlungen für optimale Zeitpläne
- Identifikation problematischer Muster
- Personalisierte Verbesserungsvorschläge

#### `notification_id_generator.dart`

Generiert eindeutige IDs für Benachrichtigungen basierend auf:

- Medikamenten-ID
- Dosis-Zeitstempel
- Vermeidet Kollisionen zwischen Medikamenten

#### `services/notifications/`

Unterordner mit spezifischen Benachrichtigungsmodulen:

- **`notification_config.dart`**: Kanal- und Soundkonfiguration
- **`notification_cancellation_manager.dart`**: Intelligente Benachrichtigungsstornierung
- **`daily_notification_scheduler.dart`**: Tägliche Benachrichtigungen planen
- **`weekly_notification_scheduler.dart`**: Wöchentliche Benachrichtigungen planen
- **`fasting_notification_scheduler.dart`**: Fasten-Benachrichtigungen planen

### `lib/providers/`

State-Management-Provider mit ChangeNotifier:

#### `theme_provider.dart`

Verwaltet den Theme-Modus der Anwendung:

- `ThemeMode` State (system/light/dark)
- Methode zum Ändern des Themes
- Persistierung der Einstellungen mit PreferencesService
- Benachrichtigung an Widgets bei Theme-Änderung

### `lib/theme/`

Definition der visuellen Themen:

#### `app_theme.dart`

Konfiguration der hellen und dunklen Themes:

- `lightTheme`: Helles Theme mit Material 3
- `darkTheme`: Dunkles Theme mit Material 3
- Vollständige Anpassung von Komponenten (AppBar, Cards, Buttons, etc.)
- Vollständige typografische Hierarchie
- Konsistentes Farbschema

### `lib/widgets/`

In der gesamten Anwendung wiederverwendbare Widgets:

#### `action_buttons.dart`

Häufige Aktionsbuttons (Dosis einnehmen, auslassen, verschieben).

#### `medication_header_card.dart`

Header-Karte mit Medikamenteninformationen.

#### `widgets/forms/`

Wiederverwendbare Formulare:

- **`medication_info_form.dart`**: Basisinformationsformular
- **`frequency_option_card.dart`**: Häufigkeitsoptionskarte
- **`fasting_configuration_form.dart`**: Fastenkonfigurationsformular

### `lib/utils/`

Hilfsprogramme und Erweiterungen:

#### `datetime_extensions.dart`

DateTime-Erweiterungen:

- Daten vergleichen ohne Uhrzeit
- Daten formatieren
- Tage zwischen Daten berechnen
- Operationen für Tagesbeginn/-ende

#### `medication_sorter.dart`

Medikamentensortieralgorithmen:

- Nach nächster Dosis
- Nach Name
- Nach Typ
- Nach Bestandsnotfall

#### `number_utils.dart`

Zahlen-Hilfsprogramme:

- Mengen formatieren
- Bereiche validieren
- Konvertierungen

#### `platform_helper.dart`

Plattformspezifische Helfer:

- Android/iOS erkennen
- Systemeinstellungen öffnen
- Plattformspezifische Berechtigungen anfordern

### `lib/l10n/`

Anwendungslokalisierungssystem (i18n).

#### ARB-Dateien (Application Resource Bundle)

Übersetzungsdateien im JSON-Format:

- **`app_es.arb`**: Spanisch (Basisvorlage)
- **`app_en.arb`**: Englisch
- **`app_ca.arb`**: Katalanisch
- **`app_eu.arb`**: Baskisch
- **`app_gl.arb`**: Galicisch
- **`app_fr.arb`**: Französisch
- **`app_de.arb`**: Deutsch
- **`app_it.arb`**: Italienisch

Jede Datei enthält:

- Übersetzungsschlüssel
- Übersetzte Werte
- Platzhalter-Metadaten
- Beschreibungen für Übersetzer

#### Generierte Dateien

Automatisch generiert durch `flutter gen-l10n`:

- **`app_localizations.dart`**: Basis-Lokalisierungsklasse
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, usw.: Sprachimplementierungen

Verwendung in der App:

```dart
AppLocalizations.of(context).medicationName
```

## Verzeichnis `test/`

Unit- und Integrationstests zur Codequalitätssicherung.

### `test/helpers/`

Geteilte Test-Hilfsprogramme:

#### `test_helpers.dart`

Allgemeine Test-Helfer:

- Testdatenbank-Setup
- Service-Mocks
- Initialisierungsfunktionen

#### `database_test_helper.dart`

Spezifische Datenbank-Test-Helfer:

- In-Memory-Datenbank erstellen
- Mit Testdaten füllen
- Zustand zwischen Tests bereinigen

#### `medication_builder.dart`

Builder-Muster zur Erstellung von Test-Medikamenten:

```dart
final medication = MedicationBuilder()
  .withName('Aspirin')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Vereinfacht die Erstellung von Medikamenten mit verschiedenen Konfigurationen.

#### `person_test_helper.dart`

Helfer zur Erstellung von Test-Personen:

- Standardperson erstellen
- Mehrere Personen erstellen
- Person-Medikament-Beziehungen verwalten

#### `notification_test_helper.dart`

Mocks und Helfer für Benachrichtigungstests:

- NotificationService-Mock
- Geplante Benachrichtigungen überprüfen
- Benachrichtigungsaktionen simulieren

#### `widget_test_helpers.dart`

Helfer für Widget-Tests:

- Widgets mit vollständigem Kontext erstellen
- Widgets mit Lokalisierung pumpen
- Benutzerdefinierte Finder

#### `test_constants.dart`

Zwischen Tests geteilte Konstanten:

- Test-IDs
- Feste Daten und Uhrzeiten
- Standardwerte

### Unit-Tests (Root von `test/`)

34 Unit-Test-Dateien nach Funktionalität organisiert:

#### Datenbanktests

- `database_export_import_test.dart`: DB exportieren/importieren
- `database_refill_test.dart`: Bestand auffüllen

#### Modelltests

- `medication_model_test.dart`: Medication-Modell-Validierung

#### Servicetests

- `notification_service_test.dart`: Benachrichtigungsdienst
- `dose_action_service_test.dart`: Dosisaktionen
- `dose_history_service_test.dart`: Dosishistorie
- `preferences_service_test.dart`: Benutzereinstellungen

#### Benachrichtigungstests

- `notification_sync_test.dart`: Benachrichtigungssynchronisation
- `notification_cancellation_test.dart`: Benachrichtigungsstornierung
- `notification_person_title_test.dart`: Titel mit Personenname
- `notification_multi_person_test.dart`: Multi-Personen-Benachrichtigungen
- `notification_actions_test.dart`: Aktionen von Benachrichtigungen
- `notification_limits_test.dart`: Limit von 500 Benachrichtigungen
- `notification_midnight_edge_cases_test.dart`: Mitternachts-Grenzfälle
- `early_dose_notification_test.dart`: Vorzeitige Dosen
- `early_dose_with_fasting_test.dart`: Vorzeitige Dosen mit Fasten

#### Fastentests

- `fasting_test.dart`: Fastenlogik
- `fasting_notification_test.dart`: Fasten-Benachrichtigungen
- `fasting_countdown_test.dart`: Fasten-Countdown
- `fasting_field_preservation_test.dart`: Erhaltung von Fastenfeldern

#### Dosistests

- `dose_management_test.dart`: Dosisverwaltung
- `extra_dose_test.dart`: Extra-Dosen
- `deletion_cleanup_test.dart`: Bereinigung beim Löschen
- `multiple_fasting_prioritization_test.dart`: Priorisierung mit mehreren Fasten

#### Bestandstests

- `as_needed_stock_test.dart`: Bestand für Nach-Bedarf-Medikamente

#### UI-Tests

- `day_navigation_test.dart`: Navigation zwischen Tagen
- `day_navigation_ui_test.dart`: Tagesnavigations-UI
- `medication_sorting_test.dart`: Medikamentensortierung
- `as_needed_main_screen_display_test.dart`: Nach-Bedarf-Anzeige

#### Bildschirmtests

- `settings_screen_test.dart`: Einstellungsbildschirm
- `edit_duration_screen_test.dart`: Dauer bearbeiten
- `edit_fasting_screen_test.dart`: Fasten bearbeiten
- `edit_schedule_screen_test.dart`: Zeitpläne bearbeiten
- `edit_screens_validation_test.dart`: Bearbeitungsvalidierungen

### Integrationstests (`test/integration/`)

9 Integrationstestdateien, die vollständige Abläufe testen:

- **`app_startup_test.dart`**: Anwendungsstart
- **`add_medication_test.dart`**: Vollständiger Medikament-Hinzufügen-Ablauf
- **`edit_medication_test.dart`**: Medikament-Bearbeitungsablauf
- **`delete_medication_test.dart`**: Medikamentenlöschung
- **`medication_modal_test.dart`**: Medikamentenoptionen-Modal
- **`dose_registration_test.dart`**: Dosisregistrierung
- **`stock_management_test.dart`**: Bestandsverwaltung
- **`navigation_test.dart`**: Navigation zwischen Bildschirmen
- **`debug_menu_test.dart`**: Debug-Menü

### Test-Benennungsmuster

- **`*_test.dart`**: Alle Tests enden mit `_test.dart`
- **`integration/*_test.dart`**: Integrationstests in Unterordner
- Beschreibende Namen der getesteten Funktionalität
- Gruppiert nach Feature/Modul

## Konfigurationsdateien

### `pubspec.yaml`

Haupt-Flutter-Konfigurationsdatei. Enthält:

#### Hauptabhängigkeiten

- **`sqflite`**: SQLite-Datenbank
- **`flutter_local_notifications`**: Lokale Benachrichtigungen
- **`timezone`**: Zeitzonenverwaltung
- **`intl`**: Internationalisierung und Datumsformatierung
- **`shared_preferences`**: Schlüssel-Wert-Speicher
- **`file_picker`**: Dateiauswahl
- **`share_plus`**: Dateien teilen
- **`path_provider`**: Systemverzeichniszugriff
- **`uuid`**: Eindeutige ID-Generierung
- **`android_intent_plus`**: Android-Intents

#### Assets

- Launcher-Icons (Android/iOS)
- Splash-Screen
- Lokalisierungsdateien (automatisch)

#### Konfiguration

- Mindest-SDK: Dart ^3.9.2
- Version: 1.0.0+1

### `l10n.yaml`

Lokalisierungssystemkonfiguration:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: ARB-Dateiverzeichnis
- **`template-arb-file`**: Vorlagendatei (Spanisch)
- **`output-localization-file`**: Generierte Datei
- **`untranslated-messages-file`**: Bericht fehlender Übersetzungen

### `analysis_options.yaml`

Linting- und statische Analyseregeln:

- Empfohlene Flutter-Regeln
- Zusätzliche benutzerdefinierte Regeln
- Ausschlüsse für generierte Dateien
- Warnschweregraden-Konfiguration

### `android/app/build.gradle`

Android-Build-Konfiguration:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Benachrichtigungsberechtigungen
- Adaptive Icon-Konfiguration

### `ios/Runner/Info.plist`

iOS-Konfiguration:

- Benachrichtigungsberechtigungen
- Hintergrundmodus-Konfiguration
- App Transport Security
- Icons und Splash-Screen

## Modularisierungsergebnisse

Die Code-Refaktorisierung hat zu einer erheblichen Reduzierung der Zeilen pro Datei geführt, was die Wartbarkeit verbessert:

| Bildschirm/Datei | Zeilen Vorher | Zeilen Nachher | Reduzierung |
|------------------|---------------|----------------|-------------|
| `medication_list_screen.dart` | 950 | 680 | -28,4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75,1% |
| `dose_history_screen.dart` | 780 | 368 | -52,8% |
| `medication_list` (Modul) | 950 | 1450 | +52,6% (verteilt auf 10 Dateien) |
| `medicine_cabinet` (Modul) | 850 | 875 | +2,9% (verteilt auf 5 Dateien) |
| `dose_history` (Modul) | 780 | 920 | +17,9% (verteilt auf 8 Dateien) |
| **Gesamt** | **2580** | **1260** | **-39,3%** (Hauptdateien) |

### Vorteile

- Kleinere und fokussierte Dateien (< 400 Zeilen)
- Einzelne Verantwortung pro Datei
- Getrennte wiederverwendbare Widgets
- Leichteres Finden und Ändern von Code
- Bessere Feature-Organisation
- Spezifischere und isolierte Tests

## Organisationsmuster

### Schichttrennung (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI und Präsentation              │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Geschäftslogik                   │
│  - Komplexe Operationen             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistenz                       │
│  - Datenmodelle                     │
└─────────────────────────────────────┘
```

### Benennungskonventionen

#### Dateien

- **Bildschirme**: `*_screen.dart` (z.B.: `medication_list_screen.dart`)
- **Widgets**: `*_widget.dart` oder beschreibender Name (z.B.: `medication_card.dart`)
- **Dialoge**: `*_dialog.dart` (z.B.: `dose_selection_dialog.dart`)
- **Dienste**: `*_service.dart` (z.B.: `notification_service.dart`)
- **Modelle**: Singular (z.B.: `person.dart`, `medication.dart`)
- **Helfer**: `*_helper.dart` (z.B.: `database_helper.dart`)
- **Tests**: `*_test.dart` (z.B.: `fasting_test.dart`)

#### Klassen

- **Bildschirme**: `*Screen` (z.B.: `MedicationListScreen`)
- **Widgets**: Beschreibender Name (z.B.: `MedicationCard`, `DoseHistoryCard`)
- **Dienste**: `*Service` (z.B.: `NotificationService`)
- **Modelle**: Singular in PascalCase (z.B.: `Person`, `Medication`)

#### Variablen

- **camelCase** für Variablen und Methoden
- **UPPER_SNAKE_CASE** für Konstanten
- **Beschreibende Namen** die den Zweck widerspiegeln

### Speicherort wiederverwendbarer Widgets

#### Globale Widgets (`lib/widgets/`)

Widgets, die in mehreren Bildschirmen verwendet werden:

- Generische UI-Komponenten
- Geteilte Formulare
- Häufige Aktionsbuttons

#### Bildschirm-Widgets (`lib/screens/*/widgets/`)

Bildschirmspezifische Widgets:

- Einzigartige UI-Komponenten
- Widgets, die vom Bildschirmkontext abhängen
- Werden nicht in anderen Bildschirmen wiederverwendet

#### Dialoge (`lib/screens/*/dialogs/`)

Bildschirmspezifische Dialoge:

- Bestätigungsmodale
- Optionsblätter (Bottom Sheets)
- Dateneingabedialoge

### Helfer und Hilfsprogramme

#### `lib/utils/`

Reine Funktionen und Erweiterungen:

- Zustandslos
- Keine externen Abhängigkeiten
- In der gesamten App wiederverwendbar

#### `test/helpers/`

Testspezifische Hilfsprogramme:

- Test-Objekt-Builder
- Service-Mocks
- Testumgebungs-Setup

## Assets und Ressourcen

### Launcher-Icons

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (mehrere Auflösungen)
```

### Splash-Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Plattformkonfigurationsdateien

#### Android

- `android/app/src/main/AndroidManifest.xml`: Berechtigungen und Konfiguration
- `android/app/build.gradle`: Build und Abhängigkeiten
- `android/gradle.properties`: Gradle-Properties
- `android/local.properties`: Lokale Pfade (nicht versioniert)

#### iOS

- `ios/Runner/Info.plist`: App-Konfiguration
- `ios/Podfile`: CocoaPods-Abhängigkeiten
- `ios/Runner.xcodeproj/`: Xcode-Projekt

## Projektstatistiken

- **Dart-Dateien gesamt in `lib/`**: 131
- **Testdateien gesamt**: 43 (34 Unit + 9 Integration)
- **Codezeilen (ungefähr)**: ~15.000 Zeilen
- **Testabdeckung**: Hoch (kritische Dienste 100%)
- **Unterstützte Sprachen**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Datenmodelle**: 6
- **Hauptbildschirme**: 20+
- **Dienste**: 5 Haupt + 5 Benachrichtigungsmodule
- **Wiederverwendbare Widgets**: 50+

---

Dieses Dokument bietet einen vollständigen Überblick über die Struktur des MedicApp-Projekts und erleichtert die Navigation und das Verständnis des Codes für neue und bestehende Entwickler.
