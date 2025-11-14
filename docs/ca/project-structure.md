# Estructura del Projecte MedicApp

Aquest document descriu l'organització de carpetes i arxius del projecte MedicApp, una aplicació Flutter per a gestió de medicaments i recordatoris.

## Arbre de Directoris

### Estructura de `lib/`

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
    ├── app_localizations.dart (generat)
    └── app_localizations_*.dart (generats)
```

### Estructura de `test/`

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

### Arxius Arrel Importants

```
medicapp/
├── pubspec.yaml              # Dependències i configuració del projecte
├── l10n.yaml                 # Configuració de localització
├── analysis_options.yaml     # Regles de linting
├── android/
│   └── app/
│       └── build.gradle      # Configuració d'Android
└── ios/
    └── Runner/
        └── Info.plist        # Configuració d'iOS
```

## Directori `lib/`

### `lib/main.dart`

Punt d'entrada de l'aplicació. Responsabilitats:

- Inicialitzar el servei de notificacions
- Sol·licitar permisos de notificacions
- Crear la persona per defecte ("Jo") si no existeix
- Configurar MaterialApp amb:
  - Temes clar i fosc accessibles (fonts més grans)
  - Suport de localització (8 idiomes)
  - GlobalKey per a navegació des de notificacions
  - Rutes de navegació
- Re-programar notificacions en background en iniciar

### `lib/database/`

#### `database_helper.dart`

Singleton que gestiona tota la persistència de dades amb SQLite. Responsabilitats:

- Crear i actualitzar l'esquema de base de dades
- CRUD per a persones (Person)
- CRUD per a medicaments (Medication)
- CRUD per a assignacions persona-medicament (PersonMedication)
- CRUD per a historial de dosis (DoseHistoryEntry)
- Consultes complexes per obtenir medicaments actius per persona
- Exportar i importar base de dades (backup/restore)
- Suport per a base de dades en memòria (testing)

### `lib/models/`

Models de dades que representen les entitats del domini:

#### `person.dart`

Representa una persona que pren medicaments:

- `id`: UUID únic
- `name`: Nom de la persona
- `isDefault`: Indica si és la persona per defecte ("Jo")
- Conversió JSON i Map per a SQLite

#### `medication.dart`

Representa un medicament a l'armari:

- Informació bàsica: nom, tipus, notes
- Quantitat i estoc
- Freqüència: diària, setmanal, interval personalitzat, dates específiques, segons necessitat
- Horaris de presa
- Durada del tractament: continu, data fi, nombre de dosis
- Configuració de dejuni (opcional)
- Mètodes per calcular properes dosis
- Validacions de completitud

#### `person_medication.dart`

Relaciona medicaments amb persones:

- `personId`: Referència a Person
- `medicationId`: Referència a Medication
- `isActive`: Si està actiu per a la persona
- Usat per assignar medicaments de l'armari a persones específiques

#### `dose_history_entry.dart`

Registre d'una dosi presa, omesa o posposada:

- `medicationId`: Medicament associat
- `personId`: Persona que va prendre/ometre la dosi
- `scheduledTime`: Hora programada originalment
- `actualTime`: Hora real de registre
- `status`: taken, skipped, postponed
- `wasEarly`: Si es va prendre abans de temps
- `isExtraDose`: Si és dosi extra no programada
- `notes`: Notes opcionals

#### `medication_type.dart`

Enumeració de tipus de medicament:

- Tauleta, Càpsula, Xarop, Injecció
- Inhalador, Crema, Pegat
- Apòsit, Gota, Altre

#### `treatment_duration_type.dart`

Enumeració de tipus de durada de tractament:

- `continuous`: Sense data de fi
- `untilDate`: Fins a una data específica
- `numberOfDoses`: Nombre limitat de dosis

### `lib/screens/`

Pantalles de l'aplicació organitzades per funcionalitat.

#### Pantalles Principals

- **`main_screen.dart`**: Navegació principal amb BottomNavigationBar
- **`medication_list_screen.dart`**: Llista de medicaments actius de la persona, dosis d'avui
- **`medicine_cabinet_screen.dart`**: Armari compartit amb tots els medicaments
- **`dose_history_screen.dart`**: Historial de dosis amb filtres i estadístiques
- **`settings_screen.dart`**: Configuració, exportar/importar BD, gestió de persones

#### Flux d'Afegir Medicament (Wizard)

Navegació seqüencial per crear un medicament:

1. **`medication_info_screen.dart`**: Nom, tipus, notes
2. **`medication_frequency_screen.dart`**: Freqüència (diària, setmanal, interval, dates)
3. **`medication_dosage_screen.dart`**: Dosi per presa o interval entre dosis
4. **`medication_times_screen.dart`**: Horaris de presa
5. **`medication_dates_screen.dart`**: Data d'inici (i fi opcional)
6. **`medication_duration_screen.dart`**: Tipus de durada del tractament
7. **`medication_fasting_screen.dart`**: Configuració de dejuni (opcional)
8. **`medication_quantity_screen.dart`**: Quantitat per presa
9. **`medication_inventory_screen.dart`**: Estoc inicial i llindar d'alerta

#### Pantalles d'Edició

Ubicades a `edit_sections/`:

- **`edit_basic_info_screen.dart`**: Editar nom, tipus, notes
- **`edit_frequency_screen.dart`**: Modificar freqüència
- **`edit_schedule_screen.dart`**: Canviar horaris
- **`edit_duration_screen.dart`**: Ajustar durada del tractament
- **`edit_fasting_screen.dart`**: Configurar dejuni
- **`edit_quantity_screen.dart`**: Modificar quantitat

Cada secció té la seva pròpia carpeta amb widgets específics.

#### Pantalles de Suport

- **`weekly_days_selector_screen.dart`**: Selector de dies de la setmana
- **`specific_dates_selector_screen.dart`**: Selector de dates específiques
- **`dose_action_screen.dart`**: Registrar dosi (prendre, ometre, posposar)
- **`edit_medication_menu_screen.dart`**: Menú per editar medicament
- **`medication_stock_screen.dart`**: Gestió d'estoc de medicaments
- **`debug_notifications_screen.dart`**: Pantalla de debug per a notificacions (desenvolupament)

#### Pantalles de Persones

Ubicades a `persons/`:

- **`persons_management_screen.dart`**: Llista i gestió de persones
- **`add_edit_person_screen.dart`**: Crear o editar persona

#### Pantalles de l'Armari

Ubicades a `medicine_cabinet/`:

- **`medication_person_assignment_screen.dart`**: Assignar medicament a persones

#### Organització per Mòduls

Cada pantalla complexa té la seva pròpia carpeta amb:

- **`dialogs/`**: Diàlegs específics de la pantalla
- **`widgets/`**: Widgets reutilitzables dins de la pantalla
- **`services/`**: Lògica de negoci específica (ex: dose_calculation_service)

### `lib/services/`

Serveis que encapsulen lògica de negoci i operacions complexes.

#### `notification_service.dart`

Servei principal de notificacions. Responsabilitats:

- Inicialitzar flutter_local_notifications
- Sol·licitar permisos de notificacions
- Programar/cancel·lar notificacions de medicaments
- Gestionar notificacions de dejuni (ongoing)
- Gestionar notificacions per persona
- Respondre a accions de notificació (prendre, ometre)
- Limitar notificacions a 500 (màxim d'Android)

#### `dose_action_service.dart`

Gestiona les accions sobre dosis:

- Registrar dosi presa
- Ometre dosi
- Posposar dosi
- Registrar dosi extra
- Actualitzar estoc automàticament
- Re-programar notificacions després d'acció

#### `dose_history_service.dart`

Operacions sobre l'historial de dosis:

- Obtenir historial filtrat per data, medicament, persona
- Calcular estadístiques (adherència, dosis preses/omeses)
- Editar entrades d'historial
- Eliminar entrades

#### `preferences_service.dart`

Gestiona preferències d'usuari amb SharedPreferences:

- ID de persona activa
- Configuració de notificacions
- Preferències de UI
- Última data d'ús

#### `notification_id_generator.dart`

Genera IDs únics per a notificacions basats en:

- ID de medicament
- Timestamp de la dosi
- Evita col·lisions entre medicaments

#### `services/notifications/`

Subcarpeta amb mòduls específics de notificacions:

- **`notification_config.dart`**: Configuració de canals i sons
- **`notification_cancellation_manager.dart`**: Cancel·lació intel·ligent de notificacions
- **`daily_notification_scheduler.dart`**: Programar notificacions diàries
- **`weekly_notification_scheduler.dart`**: Programar notificacions setmanals
- **`fasting_notification_scheduler.dart`**: Programar notificacions de dejuni

### `lib/widgets/`

Widgets reutilitzables en tota l'aplicació:

#### `action_buttons.dart`

Botons comuns d'acció (prendre, ometre, posposar dosi).

#### `medication_header_card.dart`

Targeta de capçalera amb informació del medicament.

#### `widgets/forms/`

Formularis reutilitzables:

- **`medication_info_form.dart`**: Formulari d'informació bàsica
- **`frequency_option_card.dart`**: Targeta d'opció de freqüència
- **`fasting_configuration_form.dart`**: Formulari de configuració de dejuni

### `lib/utils/`

Utilitats i extensions:

#### `datetime_extensions.dart`

Extensions per a DateTime:

- Comparar dates ignorant hora
- Formatar dates
- Calcular dies entre dates
- Operacions d'inici/fi de dia

#### `medication_sorter.dart`

Algorismes d'ordenament de medicaments:

- Per propera dosi
- Per nom
- Per tipus
- Per urgència d'estoc

#### `number_utils.dart`

Utilitats per a nombres:

- Formatar quantitats
- Validar rangs
- Conversions

#### `platform_helper.dart`

Helpers específics de plataforma:

- Detectar Android/iOS
- Obrir configuració del sistema
- Sol·licitar permisos específics de plataforma

### `lib/l10n/`

Sistema de localització (i18n) de l'aplicació.

#### Arxius ARB (Application Resource Bundle)

Arxius de traducció en format JSON:

- **`app_es.arb`**: Espanyol (plantilla base)
- **`app_en.arb`**: Anglès
- **`app_ca.arb`**: Català
- **`app_eu.arb`**: Basc
- **`app_gl.arb`**: Gallec
- **`app_fr.arb`**: Francès
- **`app_de.arb`**: Alemany
- **`app_it.arb`**: Italià

Cada arxiu conté:

- Claus de traducció
- Valors traduïts
- Metadata de placeholders
- Descripcions per a traductors

#### Arxius Generats

Generats automàticament per `flutter gen-l10n`:

- **`app_localizations.dart`**: Classe base de localització
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etc.: Implementacions per idioma

Ús a l'app:

```dart
AppLocalizations.of(context).medicationName
```

## Directori `test/`

Tests unitaris i integració per garantir qualitat del codi.

### `test/helpers/`

Utilitats compartides per a testing:

#### `test_helpers.dart`

Helpers generals per a tests:

- Setup de base de dades de prova
- Mocks de serveis
- Funcions d'inicialització

#### `database_test_helper.dart`

Helpers específics per a tests de base de dades:

- Crear base de dades en memòria
- Poblar amb dades de prova
- Netejar estat entre tests

#### `medication_builder.dart`

Patró Builder per crear medicaments de prova:

```dart
final medication = MedicationBuilder()
  .withName('Aspirina')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Simplifica la creació de medicaments amb diferents configuracions.

#### `person_test_helper.dart`

Helpers per crear persones de prova:

- Crear persona per defecte
- Crear múltiples persones
- Gestionar relacions persona-medicament

#### `notification_test_helper.dart`

Mocks i helpers per a tests de notificacions:

- Mock de NotificationService
- Verificar notificacions programades
- Simular accions de notificació

#### `widget_test_helpers.dart`

Helpers per a widget tests:

- Crear widgets amb context complet
- Pump widgets amb localització
- Finders personalitzats

#### `test_constants.dart`

Constants compartides entre tests:

- IDs de prova
- Dates i hores fixes
- Valors predeterminats

### Tests Unitaris (arrel de `test/`)

34 arxius de tests unitaris organitzats per funcionalitat:

#### Tests de Base de Dades

- `database_export_import_test.dart`: Exportar/importar BD
- `database_refill_test.dart`: Recarregar estoc

#### Tests de Models

- `medication_model_test.dart`: Validació de model Medication

#### Tests de Serveis

- `notification_service_test.dart`: Servei de notificacions
- `dose_action_service_test.dart`: Accions de dosi
- `dose_history_service_test.dart`: Historial de dosis
- `preferences_service_test.dart`: Preferències d'usuari

#### Tests de Notificacions

- `notification_sync_test.dart`: Sincronització de notificacions
- `notification_cancellation_test.dart`: Cancel·lació de notificacions
- `notification_person_title_test.dart`: Títols amb nom de persona
- `notification_multi_person_test.dart`: Notificacions multi-persona
- `notification_actions_test.dart`: Accions des de notificacions
- `notification_limits_test.dart`: Límit de 500 notificacions
- `notification_midnight_edge_cases_test.dart`: Casos límit de mitjanit
- `early_dose_notification_test.dart`: Dosis primerenques
- `early_dose_with_fasting_test.dart`: Dosis primerenques amb dejuni

#### Tests de Dejuni

- `fasting_test.dart`: Lògica de dejuni
- `fasting_notification_test.dart`: Notificacions de dejuni
- `fasting_countdown_test.dart`: Compte enrere de dejuni
- `fasting_field_preservation_test.dart`: Preservació de camps de dejuni

#### Tests de Dosi

- `dose_management_test.dart`: Gestió de dosis
- `extra_dose_test.dart`: Dosis extra
- `deletion_cleanup_test.dart`: Neteja en eliminar
- `multiple_fasting_prioritization_test.dart`: Priorització amb múltiples dejunis

#### Tests d'Estoc

- `as_needed_stock_test.dart`: Estoc per a medicaments segons necessitat

#### Tests de UI

- `day_navigation_test.dart`: Navegació entre dies
- `day_navigation_ui_test.dart`: UI de navegació de dies
- `medication_sorting_test.dart`: Ordenament de medicaments
- `as_needed_main_screen_display_test.dart`: Visualització segons necessitat

#### Tests de Pantalles

- `settings_screen_test.dart`: Pantalla de configuració
- `edit_duration_screen_test.dart`: Editar durada
- `edit_fasting_screen_test.dart`: Editar dejuni
- `edit_schedule_screen_test.dart`: Editar horaris
- `edit_screens_validation_test.dart`: Validacions d'edició

### Tests d'Integració (`test/integration/`)

9 arxius de tests d'integració que proven fluxos complets:

- **`app_startup_test.dart`**: Inici d'aplicació
- **`add_medication_test.dart`**: Flux complet d'afegir medicament
- **`edit_medication_test.dart`**: Flux d'edició de medicament
- **`delete_medication_test.dart`**: Eliminació de medicament
- **`medication_modal_test.dart`**: Modal d'opcions de medicament
- **`dose_registration_test.dart`**: Registre de dosi
- **`stock_management_test.dart`**: Gestió d'estoc
- **`navigation_test.dart`**: Navegació entre pantalles
- **`debug_menu_test.dart`**: Menú de debug

### Patró de Naming de Tests

- **`*_test.dart`**: Tots els tests acaben amb `_test.dart`
- **`integration/*_test.dart`**: Tests d'integració en subcarpeta
- Noms descriptius de la funcionalitat provada
- Agrupats per feature/mòdul

## Arxius de Configuració

### `pubspec.yaml`

Arxiu principal de configuració de Flutter. Conté:

#### Dependències Principals

- **`sqflite`**: Base de dades SQLite
- **`flutter_local_notifications`**: Notificacions locals
- **`timezone`**: Gestió de zones horàries
- **`intl`**: Internacionalització i format de dates
- **`shared_preferences`**: Emmagatzematge clau-valor
- **`file_picker`**: Selecció d'arxius
- **`share_plus`**: Compartir arxius
- **`path_provider`**: Accés a directoris del sistema
- **`uuid`**: Generació d'IDs únics
- **`android_intent_plus`**: Intents d'Android

#### Assets

- Icones de launcher (Android/iOS)
- Splash screen
- Arxius de localització (automàtics)

#### Configuració

- SDK mínim: Dart ^3.9.2
- Versió: 1.0.0+1

### `l10n.yaml`

Configuració del sistema de localització:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: Directori d'arxius ARB
- **`template-arb-file`**: Arxiu plantilla (espanyol)
- **`output-localization-file`**: Arxiu generat
- **`untranslated-messages-file`**: Informe de traduccions mancants

### `analysis_options.yaml`

Regles de linting i anàlisi estàtic:

- Conjunt de regles recomanades de Flutter
- Regles personalitzades addicionals
- Exclusions per a arxius generats
- Configuració de severitat d'advertències

### `android/app/build.gradle`

Configuració de compilació Android:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Permisos de notificacions
- Configuració d'icones adaptatives

### `ios/Runner/Info.plist`

Configuració d'iOS:

- Permisos de notificacions
- Configuració de background modes
- App Transport Security
- Icones i splash screen

## Resultats de Modularització

La refactorització del codi ha resultat en una reducció significativa de línies de codi per arxiu, millorant la mantenibilitat:

| Pantalla/Arxiu | Línies Abans | Línies Després | Reducció |
|------------------|--------------|----------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (mòdul) | 950 | 1450 | +52.6% (distribuït en 10 arxius) |
| `medicine_cabinet` (mòdul) | 850 | 875 | +2.9% (distribuït en 5 arxius) |
| `dose_history` (mòdul) | 780 | 920 | +17.9% (distribuït en 8 arxius) |
| **Total** | **2580** | **1260** | **-39.3%** (arxius principals) |

### Beneficis

- Arxius més petits i enfocats (< 400 línies)
- Responsabilitat única per arxiu
- Widgets reutilitzables separats
- Facilitat per trobar i modificar codi
- Millor organització per feature
- Tests més específics i aïllats

## Patrons d'Organització

### Separació per Capes (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI i presentació                 │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Lògica de negoci                 │
│  - Operacions complexes             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistència                     │
│  - Models de dades                  │
└─────────────────────────────────────┘
```

### Convencions de Noms

#### Arxius

- **Pantalles**: `*_screen.dart` (ex: `medication_list_screen.dart`)
- **Widgets**: `*_widget.dart` o nom descriptiu (ex: `medication_card.dart`)
- **Diàlegs**: `*_dialog.dart` (ex: `dose_selection_dialog.dart`)
- **Serveis**: `*_service.dart` (ex: `notification_service.dart`)
- **Models**: nom singular (ex: `person.dart`, `medication.dart`)
- **Helpers**: `*_helper.dart` (ex: `database_helper.dart`)
- **Tests**: `*_test.dart` (ex: `fasting_test.dart`)

#### Classes

- **Pantalles**: `*Screen` (ex: `MedicationListScreen`)
- **Widgets**: nom descriptiu (ex: `MedicationCard`, `DoseHistoryCard`)
- **Serveis**: `*Service` (ex: `NotificationService`)
- **Models**: nom singular en PascalCase (ex: `Person`, `Medication`)

#### Variables

- **camelCase** per a variables i mètodes
- **UPPER_SNAKE_CASE** per a constants
- **Noms descriptius** que reflecteixin el propòsit

### Ubicació de Widgets Reutilitzables

#### Widgets Globals (`lib/widgets/`)

Widgets usats en múltiples pantalles:

- Components de UI genèrics
- Formularis compartits
- Botons d'acció comuns

#### Widgets de Pantalla (`lib/screens/*/widgets/`)

Widgets específics d'una pantalla:

- Components de UI únics
- Widgets que depenen del context de la pantalla
- No es reutilitzen en altres pantalles

#### Diàlegs (`lib/screens/*/dialogs/`)

Diàlegs específics d'una pantalla:

- Modals de confirmació
- Fulls d'opcions (bottom sheets)
- Diàlegs d'entrada de dades

### Helpers i Utilitats

#### `lib/utils/`

Funcions pures i extensions:

- Sense estat
- Sense dependències externes
- Reutilitzables en tota l'app

#### `test/helpers/`

Utilitats específiques de testing:

- Builders d'objectes de prova
- Mocks de serveis
- Setup d'entorn de test

## Assets i Recursos

### Icones de Launcher

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (múltiples resolucions)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Arxius de Configuració de Plataforma

#### Android

- `android/app/src/main/AndroidManifest.xml`: Permisos i configuració
- `android/app/build.gradle`: Compilació i dependències
- `android/gradle.properties`: Properties de Gradle
- `android/local.properties`: Rutes locals (no versionat)

#### iOS

- `ios/Runner/Info.plist`: Configuració de l'app
- `ios/Podfile`: Dependències CocoaPods
- `ios/Runner.xcodeproj/`: Projecte Xcode

## Estadístiques del Projecte

- **Total d'arxius Dart a `lib/`**: 131
- **Total d'arxius de test**: 43 (34 unitaris + 9 integració)
- **Línies de codi (aproximat)**: ~15,000 línies
- **Cobertura de tests**: Alta (serveis crítics 100%)
- **Idiomes suportats**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Models de dades**: 6
- **Pantalles principals**: 20+
- **Serveis**: 5 principals + 5 mòduls de notificacions
- **Widgets reutilitzables**: 50+

---

Aquest document proporciona una visió completa de l'estructura del projecte MedicApp, facilitant la navegació i comprensió del codi per a desenvolupadors nous i existents.
