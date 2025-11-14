# Struttura del Progetto MedicApp

Questo documento descrive l'organizzazione delle cartelle e dei file del progetto MedicApp, un'applicazione Flutter per la gestione di farmaci e promemoria.

## Albero delle Directory

### Struttura di `lib/`

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
    ├── app_localizations.dart (generato)
    └── app_localizations_*.dart (generati)
```

### Struttura di `test/`

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

### File Radice Importanti

```
medicapp/
├── pubspec.yaml              # Dipendenze e configurazione del progetto
├── l10n.yaml                 # Configurazione localizzazione
├── analysis_options.yaml     # Regole di linting
├── android/
│   └── app/
│       └── build.gradle      # Configurazione Android
└── ios/
    └── Runner/
        └── Info.plist        # Configurazione iOS
```

## Directory `lib/`

### `lib/main.dart`

Punto di ingresso dell'applicazione. Responsabilità:

- Inizializzare il servizio notifiche
- Richiedere permessi notifiche
- Creare la persona predefinita ("Io") se non esiste
- Configurare MaterialApp con:
  - Temi chiaro e scuro accessibili (font più grandi)
  - Supporto localizzazione (8 lingue)
  - GlobalKey per navigazione dalle notifiche
  - Route di navigazione
- Riprogrammare notifiche in background all'avvio

### `lib/database/`

#### `database_helper.dart`

Singleton che gestisce tutta la persistenza dati con SQLite. Responsabilità:

- Creare e aggiornare lo schema del database
- CRUD per persone (Person)
- CRUD per farmaci (Medication)
- CRUD per assegnazioni persona-farmaco (PersonMedication)
- CRUD per storico dosi (DoseHistoryEntry)
- Query complesse per ottenere farmaci attivi per persona
- Esportare e importare database (backup/restore)
- Supporto per database in memoria (testing)

### `lib/models/`

Modelli di dati che rappresentano le entità del dominio:

#### `person.dart`

Rappresenta una persona che prende farmaci:

- `id`: UUID unico
- `name`: Nome della persona
- `isDefault`: Indica se è la persona predefinita ("Io")
- Conversione JSON e Map per SQLite

#### `medication.dart`

Rappresenta un farmaco nel kit:

- Informazioni di base: nome, tipo, note
- Quantità e stock
- Frequenza: giornaliera, settimanale, intervallo personalizzato, date specifiche, al bisogno
- Orari di assunzione
- Durata del trattamento: continuo, data fine, numero di dosi
- Configurazione digiuno (opzionale)
- Metodi per calcolare prossime dosi
- Validazioni di completezza

#### `person_medication.dart`

Mette in relazione farmaci con persone:

- `personId`: Riferimento a Person
- `medicationId`: Riferimento a Medication
- `isActive`: Se è attivo per la persona
- Usato per assegnare farmaci dal kit a persone specifiche

#### `dose_history_entry.dart`

Registro di una dose presa, saltata o posticipata:

- `medicationId`: Farmaco associato
- `personId`: Persona che ha preso/saltato la dose
- `scheduledTime`: Ora programmata originariamente
- `actualTime`: Ora reale di registrazione
- `status`: taken, skipped, postponed
- `wasEarly`: Se è stata presa in anticipo
- `isExtraDose`: Se è dose extra non programmata
- `notes`: Note opzionali

#### `medication_type.dart`

Enumerazione di tipi di farmaco:

- Compressa, Capsula, Sciroppo, Iniezione
- Inalatore, Crema, Cerotto
- Medicazione, Goccia, Altro

#### `treatment_duration_type.dart`

Enumerazione di tipi di durata trattamento:

- `continuous`: Senza data di fine
- `untilDate`: Fino a una data specifica
- `numberOfDoses`: Numero limitato di dosi

### `lib/screens/`

Schermate dell'applicazione organizzate per funzionalità.

#### Schermate Principali

- **`main_screen.dart`**: Navigazione principale con BottomNavigationBar
- **`medication_list_screen.dart`**: Elenco farmaci attivi della persona, dosi di oggi
- **`medicine_cabinet_screen.dart`**: Kit condiviso con tutti i farmaci
- **`dose_history_screen.dart`**: Storico dosi con filtri e statistiche
- **`settings_screen.dart`**: Configurazione, esporta/importa DB, gestione persone

#### Flusso Aggiungi Farmaco (Wizard)

Navigazione sequenziale per creare un farmaco:

1. **`medication_info_screen.dart`**: Nome, tipo, note
2. **`medication_frequency_screen.dart`**: Frequenza (giornaliera, settimanale, intervallo, date)
3. **`medication_dosage_screen.dart`**: Dose per assunzione o intervallo tra dosi
4. **`medication_times_screen.dart`**: Orari di assunzione
5. **`medication_dates_screen.dart`**: Data di inizio (e fine opzionale)
6. **`medication_duration_screen.dart`**: Tipo di durata del trattamento
7. **`medication_fasting_screen.dart`**: Configurazione digiuno (opzionale)
8. **`medication_quantity_screen.dart`**: Quantità per assunzione
9. **`medication_inventory_screen.dart`**: Stock iniziale e soglia avviso

#### Schermate di Modifica

Situate in `edit_sections/`:

- **`edit_basic_info_screen.dart`**: Modificare nome, tipo, note
- **`edit_frequency_screen.dart`**: Modificare frequenza
- **`edit_schedule_screen.dart`**: Cambiare orari
- **`edit_duration_screen.dart`**: Regolare durata del trattamento
- **`edit_fasting_screen.dart`**: Configurare digiuno
- **`edit_quantity_screen.dart`**: Modificare quantità

Ogni sezione ha la propria cartella con widget specifici.

#### Schermate di Supporto

- **`weekly_days_selector_screen.dart`**: Selettore giorni della settimana
- **`specific_dates_selector_screen.dart`**: Selettore date specifiche
- **`dose_action_screen.dart`**: Registrare dose (prendere, saltare, posticipare)
- **`edit_medication_menu_screen.dart`**: Menu per modificare farmaco
- **`medication_stock_screen.dart`**: Gestione stock farmaci
- **`debug_notifications_screen.dart`**: Schermata debug per notifiche (sviluppo)

#### Schermate Persone

Situate in `persons/`:

- **`persons_management_screen.dart`**: Elenco e gestione persone
- **`add_edit_person_screen.dart`**: Creare o modificare persona

#### Schermate Kit

Situate in `medicine_cabinet/`:

- **`medication_person_assignment_screen.dart`**: Assegnare farmaco a persone

#### Organizzazione per Moduli

Ogni schermata complessa ha la propria cartella con:

- **`dialogs/`**: Dialog specifici della schermata
- **`widgets/`**: Widget riutilizzabili all'interno della schermata
- **`services/`**: Logica di business specifica (es: dose_calculation_service)

### `lib/services/`

Servizi che incapsulano logica di business e operazioni complesse.

#### `notification_service.dart`

Servizio principale notifiche. Responsabilità:

- Inizializzare flutter_local_notifications
- Richiedere permessi notifiche
- Programmare/cancellare notifiche farmaci
- Gestire notifiche digiuno (ongoing)
- Gestire notifiche per persona
- Rispondere ad azioni notifica (prendere, saltare)
- Limitare notifiche a 500 (massimo Android)

#### `dose_action_service.dart`

Gestisce le azioni sulle dosi:

- Registrare dose presa
- Saltare dose
- Posticipare dose
- Registrare dose extra
- Aggiornare stock automaticamente
- Riprogrammare notifiche dopo azione

#### `dose_history_service.dart`

Operazioni sullo storico dosi:

- Ottenere storico filtrato per data, farmaco, persona
- Calcolare statistiche (aderenza, dosi prese/saltate)
- Modificare voci storico
- Eliminare voci

#### `preferences_service.dart`

Gestisce preferenze utente con SharedPreferences:

- ID persona attiva
- Configurazione notifiche
- Preferenze UI
- Ultima data di utilizzo

#### `notification_id_generator.dart`

Genera ID unici per notifiche basati su:

- ID farmaco
- Timestamp della dose
- Evita collisioni tra farmaci

#### `services/notifications/`

Sottocartella con moduli specifici notifiche:

- **`notification_config.dart`**: Configurazione canali e suoni
- **`notification_cancellation_manager.dart`**: Cancellazione intelligente notifiche
- **`daily_notification_scheduler.dart`**: Programmare notifiche giornaliere
- **`weekly_notification_scheduler.dart`**: Programmare notifiche settimanali
- **`fasting_notification_scheduler.dart`**: Programmare notifiche digiuno

### `lib/widgets/`

Widget riutilizzabili in tutta l'applicazione:

#### `action_buttons.dart`

Pulsanti comuni azione (prendere, saltare, posticipare dose).

#### `medication_header_card.dart`

Scheda intestazione con informazioni farmaco.

#### `widgets/forms/`

Moduli riutilizzabili:

- **`medication_info_form.dart`**: Modulo informazioni di base
- **`frequency_option_card.dart`**: Scheda opzione frequenza
- **`fasting_configuration_form.dart`**: Modulo configurazione digiuno

### `lib/utils/`

Utility ed estensioni:

#### `datetime_extensions.dart`

Estensioni per DateTime:

- Confrontare date ignorando ora
- Formattare date
- Calcolare giorni tra date
- Operazioni inizio/fine giorno

#### `medication_sorter.dart`

Algoritmi ordinamento farmaci:

- Per prossima dose
- Per nome
- Per tipo
- Per urgenza stock

#### `number_utils.dart`

Utility per numeri:

- Formattare quantità
- Validare intervalli
- Conversioni

#### `platform_helper.dart`

Helper specifici piattaforma:

- Rilevare Android/iOS
- Aprire configurazione sistema
- Richiedere permessi specifici piattaforma

### `lib/l10n/`

Sistema di localizzazione (i18n) dell'applicazione.

#### File ARB (Application Resource Bundle)

File traduzione in formato JSON:

- **`app_es.arb`**: Spagnolo (template base)
- **`app_en.arb`**: Inglese
- **`app_ca.arb`**: Catalano
- **`app_eu.arb`**: Basco
- **`app_gl.arb`**: Galiziano
- **`app_fr.arb`**: Francese
- **`app_de.arb`**: Tedesco
- **`app_it.arb`**: Italiano

Ogni file contiene:

- Chiavi di traduzione
- Valori tradotti
- Metadata placeholder
- Descrizioni per traduttori

#### File Generati

Generati automaticamente da `flutter gen-l10n`:

- **`app_localizations.dart`**: Classe base localizzazione
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, ecc.: Implementazioni per lingua

Uso nell'app:

```dart
AppLocalizations.of(context).medicationName
```

## Directory `test/`

Test unitari e integrazione per garantire qualità del codice.

### `test/helpers/`

Utility condivise per testing:

#### `test_helpers.dart`

Helper generali per test:

- Setup database di prova
- Mock servizi
- Funzioni inizializzazione

#### `database_test_helper.dart`

Helper specifici per test database:

- Creare database in memoria
- Popolare con dati di prova
- Pulire stato tra test

#### `medication_builder.dart`

Pattern Builder per creare farmaci di prova:

```dart
final medication = MedicationBuilder()
  .withName('Aspirina')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Semplifica la creazione di farmaci con diverse configurazioni.

#### `person_test_helper.dart`

Helper per creare persone di prova:

- Creare persona predefinita
- Creare multiple persone
- Gestire relazioni persona-farmaco

#### `notification_test_helper.dart`

Mock e helper per test notifiche:

- Mock NotificationService
- Verificare notifiche programmate
- Simulare azioni notifica

#### `widget_test_helpers.dart`

Helper per widget test:

- Creare widget con contesto completo
- Pump widget con localizzazione
- Finder personalizzati

#### `test_constants.dart`

Costanti condivise tra test:

- ID di prova
- Date e ore fisse
- Valori predefiniti

### Test Unitari (radice di `test/`)

34 file test unitari organizzati per funzionalità:

#### Test Database

- `database_export_import_test.dart`: Esporta/importa DB
- `database_refill_test.dart`: Ricaricare stock

#### Test Modelli

- `medication_model_test.dart`: Validazione modello Medication

#### Test Servizi

- `notification_service_test.dart`: Servizio notifiche
- `dose_action_service_test.dart`: Azioni dosi
- `dose_history_service_test.dart`: Storico dosi
- `preferences_service_test.dart`: Preferenze utente

#### Test Notifiche

- `notification_sync_test.dart`: Sincronizzazione notifiche
- `notification_cancellation_test.dart`: Cancellazione notifiche
- `notification_person_title_test.dart`: Titoli con nome persona
- `notification_multi_person_test.dart`: Notifiche multi-persona
- `notification_actions_test.dart`: Azioni da notifiche
- `notification_limits_test.dart`: Limite 500 notifiche
- `notification_midnight_edge_cases_test.dart`: Casi limite mezzanotte
- `early_dose_notification_test.dart`: Dosi anticipate
- `early_dose_with_fasting_test.dart`: Dosi anticipate con digiuno

#### Test Digiuno

- `fasting_test.dart`: Logica digiuno
- `fasting_notification_test.dart`: Notifiche digiuno
- `fasting_countdown_test.dart`: Conto alla rovescia digiuno
- `fasting_field_preservation_test.dart`: Preservazione campi digiuno

#### Test Dosi

- `dose_management_test.dart`: Gestione dosi
- `extra_dose_test.dart`: Dosi extra
- `deletion_cleanup_test.dart`: Pulizia all'eliminazione
- `multiple_fasting_prioritization_test.dart`: Prioritizzazione multipli digiuni

#### Test Stock

- `as_needed_stock_test.dart`: Stock per farmaci al bisogno

#### Test UI

- `day_navigation_test.dart`: Navigazione tra giorni
- `day_navigation_ui_test.dart`: UI navigazione giorni
- `medication_sorting_test.dart`: Ordinamento farmaci
- `as_needed_main_screen_display_test.dart`: Visualizzazione al bisogno

#### Test Schermate

- `settings_screen_test.dart`: Schermata configurazione
- `edit_duration_screen_test.dart`: Modificare durata
- `edit_fasting_screen_test.dart`: Modificare digiuno
- `edit_schedule_screen_test.dart`: Modificare orari
- `edit_screens_validation_test.dart`: Validazioni modifica

### Test Integrazione (`test/integration/`)

9 file test integrazione che provano flussi completi:

- **`app_startup_test.dart`**: Avvio applicazione
- **`add_medication_test.dart`**: Flusso completo aggiungere farmaco
- **`edit_medication_test.dart`**: Flusso modifica farmaco
- **`delete_medication_test.dart`**: Eliminazione farmaco
- **`medication_modal_test.dart`**: Modal opzioni farmaco
- **`dose_registration_test.dart`**: Registrazione dose
- **`stock_management_test.dart`**: Gestione stock
- **`navigation_test.dart`**: Navigazione tra schermate
- **`debug_menu_test.dart`**: Menu debug

### Pattern Naming Test

- **`*_test.dart`**: Tutti i test terminano con `_test.dart`
- **`integration/*_test.dart`**: Test integrazione in sottocartella
- Nomi descrittivi della funzionalità provata
- Raggruppati per feature/modulo

## File di Configurazione

### `pubspec.yaml`

File principale configurazione Flutter. Contiene:

#### Dipendenze Principali

- **`sqflite`**: Database SQLite
- **`flutter_local_notifications`**: Notifiche locali
- **`timezone`**: Gestione fusi orari
- **`intl`**: Internazionalizzazione e formattazione date
- **`shared_preferences`**: Storage chiave-valore
- **`file_picker`**: Selezione file
- **`share_plus`**: Condividere file
- **`path_provider`**: Accesso directory sistema
- **`uuid`**: Generazione ID unici
- **`android_intent_plus`**: Intent Android

#### Assets

- Icone launcher (Android/iOS)
- Splash screen
- File localizzazione (automatici)

#### Configurazione

- SDK minimo: Dart ^3.9.2
- Versione: 1.0.0+1

### `l10n.yaml`

Configurazione sistema localizzazione:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: Directory file ARB
- **`template-arb-file`**: File template (spagnolo)
- **`output-localization-file`**: File generato
- **`untranslated-messages-file`**: Report traduzioni mancanti

### `analysis_options.yaml`

Regole linting e analisi statica:

- Set regole raccomandate Flutter
- Regole personalizzate aggiuntive
- Esclusioni per file generati
- Configurazione severità avvisi

### `android/app/build.gradle`

Configurazione compilazione Android:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Permessi notifiche
- Configurazione icone adattive

### `ios/Runner/Info.plist`

Configurazione iOS:

- Permessi notifiche
- Configurazione background modes
- App Transport Security
- Icone e splash screen

## Risultati Modularizzazione

La refactoring del codice ha portato a una riduzione significativa di righe di codice per file, migliorando la manutenibilità:

| Schermata/File | Righe Prima | Righe Dopo | Riduzione |
|----------------|-------------|------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (modulo) | 950 | 1450 | +52.6% (distribuito in 10 file) |
| `medicine_cabinet` (modulo) | 850 | 875 | +2.9% (distribuito in 5 file) |
| `dose_history` (modulo) | 780 | 920 | +17.9% (distribuito in 8 file) |
| **Totale** | **2580** | **1260** | **-39.3%** (file principali) |

### Benefici

- File più piccoli e focalizzati (< 400 righe)
- Responsabilità unica per file
- Widget riutilizzabili separati
- Facilità nel trovare e modificare codice
- Migliore organizzazione per feature
- Test più specifici e isolati

## Pattern di Organizzazione

### Separazione per Livelli (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI e presentazione               │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Logica di business               │
│  - Operazioni complesse             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistenza                      │
│  - Modelli dati                     │
└─────────────────────────────────────┘
```

### Convenzioni Nomi

#### File

- **Schermate**: `*_screen.dart` (es: `medication_list_screen.dart`)
- **Widget**: `*_widget.dart` o nome descrittivo (es: `medication_card.dart`)
- **Dialog**: `*_dialog.dart` (es: `dose_selection_dialog.dart`)
- **Servizi**: `*_service.dart` (es: `notification_service.dart`)
- **Modelli**: nome singolare (es: `person.dart`, `medication.dart`)
- **Helper**: `*_helper.dart` (es: `database_helper.dart`)
- **Test**: `*_test.dart` (es: `fasting_test.dart`)

#### Classi

- **Schermate**: `*Screen` (es: `MedicationListScreen`)
- **Widget**: nome descrittivo (es: `MedicationCard`, `DoseHistoryCard`)
- **Servizi**: `*Service` (es: `NotificationService`)
- **Modelli**: nome singolare in PascalCase (es: `Person`, `Medication`)

#### Variabili

- **camelCase** per variabili e metodi
- **UPPER_SNAKE_CASE** per costanti
- **Nomi descrittivi** che riflettono lo scopo

### Ubicazione Widget Riutilizzabili

#### Widget Globali (`lib/widgets/`)

Widget usati in più schermate:

- Componenti UI generici
- Moduli condivisi
- Pulsanti azione comuni

#### Widget Schermata (`lib/screens/*/widgets/`)

Widget specifici di una schermata:

- Componenti UI unici
- Widget che dipendono dal contesto della schermata
- Non vengono riutilizzati in altre schermate

#### Dialog (`lib/screens/*/dialogs/`)

Dialog specifici di una schermata:

- Modali conferma
- Fogli opzioni (bottom sheets)
- Dialog input dati

### Helper e Utility

#### `lib/utils/`

Funzioni pure ed estensioni:

- Senza stato
- Senza dipendenze esterne
- Riutilizzabili in tutta l'app

#### `test/helpers/`

Utility specifiche testing:

- Builder oggetti di prova
- Mock servizi
- Setup ambiente test

## Assets e Risorse

### Icone Launcher

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (risoluzioni multiple)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### File Configurazione Piattaforma

#### Android

- `android/app/src/main/AndroidManifest.xml`: Permessi e configurazione
- `android/app/build.gradle`: Compilazione e dipendenze
- `android/gradle.properties`: Properties Gradle
- `android/local.properties`: Percorsi locali (non versionato)

#### iOS

- `ios/Runner/Info.plist`: Configurazione app
- `ios/Podfile`: Dipendenze CocoaPods
- `ios/Runner.xcodeproj/`: Progetto Xcode

## Statistiche Progetto

- **Totale file Dart in `lib/`**: 131
- **Totale file test**: 43 (34 unitari + 9 integrazione)
- **Righe codice (approssimativo)**: ~15.000 righe
- **Copertura test**: Alta (servizi critici 100%)
- **Lingue supportate**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Modelli dati**: 6
- **Schermate principali**: 20+
- **Servizi**: 5 principali + 5 moduli notifiche
- **Widget riutilizzabili**: 50+

---

Questo documento fornisce una visione completa della struttura del progetto MedicApp, facilitando la navigazione e comprensione del codice per sviluppatori nuovi ed esistenti.
