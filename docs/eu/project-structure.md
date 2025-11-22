# MedicApp Proiektuaren Egitura

Dokumentu honek MedicApp proiektuaren karpeten eta fitxategien antolamendua deskribatzen du, sendagaien eta oroigarrien kudeaketarako Flutter aplikazio bat.

## Direktorio Zuhaitza

### `lib/` Egitura

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
│   ├── smart_cache_service.dart
│   ├── medication_cache_service.dart
│   ├── intelligent_reminders_service.dart
│   ├── theme_service.dart
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
    ├── app_localizations.dart (sortua)
    └── app_localizations_*.dart (sortuak)
```

### `test/` Egitura

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

### Erroko Fitxategi Garrantzitsuak

```
medicapp/
├── pubspec.yaml              # Proiektuaren mendekotasunak eta konfigurazioa
├── l10n.yaml                 # Lokalizazio konfigurazioa
├── analysis_options.yaml     # Linting arauak
├── android/
│   └── app/
│       └── build.gradle      # Android konfigurazioa
└── ios/
    └── Runner/
        └── Info.plist        # iOS konfigurazioa
```

## `lib/` Direktorioa

### `lib/main.dart`

Aplikazioaren sarrera puntua. Erantzukizunak:

- Jakinarazpen zerbitzua hasieratu
- Jakinarazpen baimenak eskatu
- Pertsona lehenetsia ("Ni") sortu ez badago
- MaterialApp konfiguratu:
  - Gai argia eta iluna irisgarriak (letra-tamaina handiagoak)
  - Lokalizazio onarpena (8 hizkuntza)
  - GlobalKey jakinarazpenetatik nabigatzeko
  - Nabigazio bide ak
- Jakinarazpenak abiaraztean bigarren planoan berprogramatu

### `lib/database/`

#### `database_helper.dart`

Datuen iraunkortasun guztia SQLite-rekin kudeatzen duen Singleton-a. Erantzukizunak:

- Datu-basearen eskema sortu eta eguneratu
- Pertsonentzako CRUD (Person)
- Sendagaientzako CRUD (Medication)
- Pertsona-sendagai esleipenentzako CRUD (PersonMedication)
- Dosien historialerako CRUD (DoseHistoryEntry)
- Pertsonaren araberako sendagai aktiboak lortzeko kontsulta konplexuak
- Datu-basea esportatu eta inportatu (backup/restore)
- Memoria datu-basea probetarako

### `lib/models/`

Domeinuaren entitateak ordezkatzen dituzten datu modeloak:

#### `person.dart`

Sendagaiak hartzen dituen pertsona bat adierazten du:

- `id`: UUID bakarra
- `name`: Pertsonaren izena
- `isDefault`: Pertsona lehenetsia den ("Ni") adierazten du
- JSON eta Map bihurketak SQLite-rako

#### `medication.dart`

Botikingo sendagai bat adierazten du:

- Oinarrizko informazioa: izena, mota, oharrak
- Kantitatea eta stocka
- Maiztasuna: egunekoa, astekoa, tarte pertsonalizatua, data espezifikoak, behar den arabera
- Hartzeko orduak
- Tratamenduaren iraupena: jarraituaen, amaiera data, dosi kopurua
- Baraualdi konfigurazioa (aukerakoa)
- Hurrengo dosiak kalkulatzeko metodoak
- Osotasun baliosapenak

#### `person_medication.dart`

Sendagaiak pertsonarekin erlazionatzen ditu:

- `personId`: Person erreferentzia
- `medicationId`: Medication erreferentzia
- `isActive`: Pertsonarentzat aktiboa den
- Botikingo sendagaiak pertsona espezifikoei esleitzeko erabiltzen da

#### `dose_history_entry.dart`

Hartutako, omititutako edo atzeratutako dosiaren erregistroa:

- `medicationId`: Erlazionatutako sendagaia
- `personId`: Dosia hartu/omititu zuen pertsona
- `scheduledTime`: Jatorriz programatutako ordua
- `actualTime`: Erregistroaren benetako ordua
- `status`: taken, skipped, postponed
- `wasEarly`: Aurretik hartu zen
- `isExtraDose`: Programatu gabeko dosi extra bada
- `notes`: Ohar aukerakoitzak

#### `medication_type.dart`

Sendagai motaren enumerazioa:

- Tableta, Kapsula, Xarope, Injekzioa
- Inhaladorea, Krema, Apositu
- Apositua, Tanta, Bestea

#### `treatment_duration_type.dart`

Tratamenduaren iraupena motaren enumerazioa:

- `continuous`: Amaiera datarik gabe
- `untilDate`: Data espezifiko bat arte
- `numberOfDoses`: Dosi kopuru mugatua

### `lib/screens/`

Pantailak funtzionaltasunaren arabera antolatuak.

#### Pantaila Nagusiak

- **`main_screen.dart`**: Nabigazio nagusia BottomNavigationBar-rekin
- **`medication_list_screen.dart`**: Pertsonaren sendagai aktiboen zerrenda, gaurko dosiak
- **`medicine_cabinet_screen.dart`**: Sendagai guztiak dituen botikina partekatua
- **`dose_history_screen.dart`**: Dosien historiala iragazkiak eta estatistikak
- **`settings_screen.dart`**: Konfigurazioa, BD esportatu/inportatu, pertsonen kudeaketa

#### Sendagaia Gehitzeko Fluxua (Wizard)

Sendagai bat sortzeko sekuentziazko nabigazioa:

1. **`medication_info_screen.dart`**: Izena, mota, oharrak
2. **`medication_frequency_screen.dart`**: Maiztasuna (egunekoa, astekoa, tartea, datak)
3. **`medication_dosage_screen.dart`**: Hartze bakoitzeko dosia edo dosien arteko tartea
4. **`medication_times_screen.dart`**: Hartzeko orduak
5. **`medication_dates_screen.dart`**: Hasiera data (eta aukerazko amaiera data)
6. **`medication_duration_screen.dart`**: Tratamenduaren iraupena mota
7. **`medication_fasting_screen.dart`**: Baraualdi konfigurazioa (aukerakoa)
8. **`medication_quantity_screen.dart`**: Hartze bakoitzeko kantitatea
9. **`medication_inventory_screen.dart`**: Hasierako stocka eta alerta atalasea

#### Edizio Pantailak

`edit_sections/`-en kokatuta:

- **`edit_basic_info_screen.dart`**: Izena, mota, oharrak editatu
- **`edit_frequency_screen.dart`**: Maiztasuna aldatu
- **`edit_schedule_screen.dart`**: Orduak aldatu
- **`edit_duration_screen.dart`**: Tratamenduaren iraupena doitu
- **`edit_fasting_screen.dart`**: Baraualdia konfiguratu
- **`edit_quantity_screen.dart`**: Kantitatea aldatu

Sekzio bakoitzak bere karpeta propioa du widget espezifikoekin.

#### Laguntza Pantailak

- **`weekly_days_selector_screen.dart`**: Asteko egunen hautatzailea
- **`specific_dates_selector_screen.dart`**: Data espezifikoen hautatzailea
- **`dose_action_screen.dart`**: Dosia erregistratu (hartu, omititu, atzeratu)
- **`edit_medication_menu_screen.dart`**: Sendagaia editatzeko menua
- **`medication_stock_screen.dart`**: Sendagaien stock kudeaketa
- **`debug_notifications_screen.dart`**: Jakinarazpenetarako debug pantaila (garapena)

#### Pertsonen Pantailak

`persons/`-en kokatuta:

- **`persons_management_screen.dart`**: Pertsonen zerrenda eta kudeaketa
- **`add_edit_person_screen.dart`**: Pertsona sortu edo editatu

#### Botikina Pantailak

`medicine_cabinet/`-en kokatuta:

- **`medication_person_assignment_screen.dart`**: Sendagaia pertsonei esleitu

#### Moduluaren Araberako Antolamendua

Pantaila konplexu bakoitzak bere karpeta propioa dauka:

- **`dialogs/`**: Pantaila espezifikoko elkarrizketak
- **`widgets/`**: Pantailan berrerabilgarriak diren widgetak
- **`services/`**: Negozio logika espezifikoa (adib: dose_calculation_service)

### `lib/services/`

Negozio logika eta eragiketa konplexuak kapsulatzenduten zerbitzuak.

#### `notification_service.dart`

Jakinarazpen zerbitzu nagusia. Erantzukizunak:

- flutter_local_notifications hasieratu
- Jakinarazpen baimenak eskatu
- Sendagaien jakinarazpenak programatu/ezeztatu
- Baraualdi jakinarazpenak kudeatu (ongoing)
- Pertsonaren araberako jakinarazpenak kudeatu
- Jakinarazpen ekintzei erantzun (hartu, omititu)
- Jakinarazpenak 500-ra mugatu (Android maximoa)

#### `dose_action_service.dart`

Dosien gain eko ekintzak kudeatzen ditu:

- Hartutako dosia erregistratu
- Dosia omititu
- Dosia atzeratu
- Dosi extra erregistratu
- Stocka automatikoki eguneratu
- Ekintza ondoren jakinarazpenak berprogramatu

#### `dose_history_service.dart`

Dosien historialaren gain eko eragiketak:

- Historiala lortu dataren, sendagaiaren, pertsonaren araberako iragazkiekin
- Estatistikak kalkulatu (atxikipena, hartutako/omititutako dosiak)
- Historial sarrerak editatu
- Sarrerak ezabatu

#### `preferences_service.dart`

Erabiltzailearen lehentasunak SharedPreferences-ekin kudeatzen ditu:

- Pertsona aktiboaren ID-a
- Jakinarazpen konfigurazioa
- UI lehentasunak
- Azken erabilera data

#### `notification_id_generator.dart`

Honetan oinarritutako jakinarazpenetarako ID bakarrak sortzen ditu:

- Sendagaiaren ID-a
- Dosiaren timestamp-a
- Sendagaien arteko talken saihestea

#### `smart_cache_service.dart`

Cache generikoa TTL (Time-To-Live) eta LRU algoritmo batekin:

- Iraungi automatikoa minuturo
- Sarrera bakarra `getOrCompute()` metodoaren bidez
- Estatistikak (hits, misses, hit rate)
- Memoria kudeaketa dinamikoa

#### `medication_cache_service.dart`

Sendagaien datuentzat cache espezializatuak:

- Cache sendagai indibidualentzat (10min TTL)
- Cache sendagai zerrendatentzat (5min TTL)
- Cache dosi historialentzat (3min TTL)
- Cache estatistiketarako (30min TTL)

#### `intelligent_reminders_service.dart`

Atxikipen analisia eta aurreikuspena:

- Dosi historialan oinarritutako atxikipen analisia
- Ahaztura probabilitatearen aurreikuspena
- Orduteegi optimoaren iradokizunak
- Asteko eguna eta orduaren araberako metrikak

#### `theme_service.dart`

Gai ilun natibo kudeaketa:

- Gai modua (system/light/dark)
- Lehentasunen iraunkortasuna
- UI aldaketa berehalakoa
- Material Design 3 onarpena

#### `services/notifications/`

Jakinarazpen modulu espezifikoak dituen azpikarpeta:

- **`notification_config.dart`**: Kanaletaren eta soinuen konfigurazioa
- **`notification_cancellation_manager.dart`**: Jakinarazpenen ezeztapen adimenduna
- **`daily_notification_scheduler.dart`**: Eguneko jakinarazpenak programatu
- **`weekly_notification_scheduler.dart`**: Asteko jakinarazpenak programatu
- **`fasting_notification_scheduler.dart`**: Baraualdi jakinarazpenak programatu

### `lib/widgets/`

Aplikazio osoan berrerabilgarriak diren widgetak:

#### `action_buttons.dart`

Ekintza botoi arruntak (hartu, omititu, atzeratu dosia).

#### `medication_header_card.dart`

Sendagaiaren informazioa duen goiburuko txartela.

#### `widgets/forms/`

Berrerabilgarriak diren formularuak:

- **`medication_info_form.dart`**: Oinarrizko informazioaren formularioa
- **`frequency_option_card.dart`**: Maiztasun aukeraren txartela
- **`fasting_configuration_form.dart`**: Baraualdi konfigurazio formularioa

### `lib/utils/`

Erabilgarritasunak eta hedapenak:

#### `datetime_extensions.dart`

DateTime hedapenak:

- Datak ordurik kontuan hartu gabe konparatu
- Datak formateatu
- Datak arteko egunak kalkulatu
- Egunaren hasiera/amaiera eragiketak

#### `medication_sorter.dart`

Sendagaien ordenatze algoritmoak:

- Hurrengo dosiaren arabera
- Izenaren arabera
- Motaren arabera
- Stock urgentziaren arabera

#### `number_utils.dart`

Zenbakientzako erabilgarritasunak:

- Kantitateak formateatu
- Tarteak balioztatu
- Bihurketak

#### `platform_helper.dart`

Plataforma espezifikoko helper-ak:

- Android/iOS detektatu
- Sistemaren konfigurazioa ireki
- Plataforma espezifikoen baimenak eskatu

### `lib/l10n/`

Aplikazioaren lokalizazio sistema (i18n).

#### ARB Fitxategiak (Application Resource Bundle)

JSON formatuko itzulpen fitxategiak:

- **`app_es.arb`**: Gaztelania (oinarrizko txantiloia)
- **`app_en.arb`**: Ingelesa
- **`app_ca.arb`**: Katalana
- **`app_eu.arb`**: Euskara
- **`app_gl.arb`**: Galiziera
- **`app_fr.arb`**: Frantsesa
- **`app_de.arb`**: Alemana
- **`app_it.arb`**: Italiera

Fitxategi bakoitzak honako hau dauka:

- Itzulpen gakoak
- Itzulitako balioak
- Placeholder-en metadata
- Itzultzaileentzako deskribapenak

#### Sortutako Fitxategiak

`flutter gen-l10n`-ek automatikoki sortzen ditu:

- **`app_localizations.dart`**: Lokalizazio oinarrizko klasea
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etab.: Hizkuntza bakoitzeko inplementazioak

App-ean erabilera:

```dart
AppLocalizations.of(context).medicationName
```

## `test/` Direktorioa

Kode kalitatea bermatzeko proba unitarioak eta integraziokoak.

### `test/helpers/`

Probetarako partekatutako erabilgarritasunak:

#### `test_helpers.dart`

Probetarako helper orokorrak:

- Proba datu-basearen setup-a
- Zerbitzuen mock-ak
- Hasieratzeko funtzioak

#### `database_test_helper.dart`

Datu-base probetarako helper espezifikoak:

- Memorian datu-basea sortu
- Proba datuekin bete
- Proben artean egoera garbitu

#### `medication_builder.dart`

Proba sendagaiak sortzeko Builder eredua:

```dart
final medication = MedicationBuilder()
  .withName('Aspirina')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Konfigurazio desberdinetako sendagaiak sortzea errazten du.

#### `person_test_helper.dart`

Proba pertsonak sortzeko helper-ak:

- Pertsona lehenetsia sortu
- Pertsona anitz sortu
- Pertsona-sendagai erlazioak kudeatu

#### `notification_test_helper.dart`

Jakinarazpen probet arako mock-ak eta helper-ak:

- NotificationService mock-a
- Programatutako jakinarazpenak egiaztatu
- Jakinarazpen ekintzak simulatu

#### `widget_test_helpers.dart`

Widget probetarako helper-ak:

- Testuinguru osoarekin widgetak sortu
- Widgetak lokalizazioarekin pump egin
- Finder pertsonalizatuak

#### `test_constants.dart`

Proben artean partekatutako konstanteak:

- Proba ID-ak
- Data eta ordu finkatuak
- Balio lehenetsiak

### Proba Unitarioak (`test/`-en erro)

Funtzionaltasunaren araberako antolatutako 34 proba unitario fitxategi:

#### Datu-base Probak

- `database_export_import_test.dart`: BD esportatu/inportatu
- `database_refill_test.dart`: Stocka birkargatu

#### Modelo Probak

- `medication_model_test.dart`: Medication modeloaren balioztapena

#### Zerbitzu Probak

- `notification_service_test.dart`: Jakinarazpen zerbitzua
- `dose_action_service_test.dart`: Dosien ekintzak
- `dose_history_service_test.dart`: Dosien historiala
- `preferences_service_test.dart`: Erabiltzaile lehentasunak

#### Jakinarazpen Probak

- `notification_sync_test.dart`: Jakinarazpenen sinkronizazioa
- `notification_cancellation_test.dart`: Jakinarazpenen ezeztapena
- `notification_person_title_test.dart`: Pertsonaren izenaren izenburuak
- `notification_multi_person_test.dart`: Pertsona anitzeko jakinarazpenak
- `notification_actions_test.dart`: Jakinarazpenetatik ekintzak
- `notification_limits_test.dart`: 500 jakinarazpen muga
- `notification_midnight_edge_cases_test.dart`: Gauerdi muturretako kasuak
- `early_dose_notification_test.dart`: Goizaldeko dosiak
- `early_dose_with_fasting_test.dart`: Baraualdidun goizaldeko dosiak

#### Baraualdi Probak

- `fasting_test.dart`: Baraualdi logika
- `fasting_notification_test.dart`: Baraualdi jakinarazpenak
- `fasting_countdown_test.dart`: Baraualdi kontu atzera
- `fasting_field_preservation_test.dart`: Baraualdi eremuen mantentzea

#### Dosi Probak

- `dose_management_test.dart`: Dosien kudeaketa
- `extra_dose_test.dart`: Dosi extra
- `deletion_cleanup_test.dart`: Ezabatzean garbiketa
- `multiple_fasting_prioritization_test.dart`: Baraualdi anitzeko lehenespena

#### Stock Probak

- `as_needed_stock_test.dart`: Behar den araberako sendagaien stocka

#### UI Probak

- `day_navigation_test.dart`: Egunen arteko nabigazioa
- `day_navigation_ui_test.dart`: Egun nabigazioaren UI
- `medication_sorting_test.dart`: Sendagaien ordenatzea
- `as_needed_main_screen_display_test.dart`: Behar den arabera bistaratzea

#### Pantaila Probak

- `settings_screen_test.dart`: Konfigurazio pantaila
- `edit_duration_screen_test.dart`: Iraupena editatu
- `edit_fasting_screen_test.dart`: Baraualdia editatu
- `edit_schedule_screen_test.dart`: Orduak editatu
- `edit_screens_validation_test.dart`: Edizioko baliosapenak

### Integrazio Probak (`test/integration/`)

Fluxu osoak probatzen dituzten 9 integrazio proba fitxategi:

- **`app_startup_test.dart`**: Aplikazioa abiatzea
- **`add_medication_test.dart`**: Sendagai bat gehitzeko fluxu osoa
- **`edit_medication_test.dart`**: Sendagaia editatzeko fluxua
- **`delete_medication_test.dart`**: Sendagaia ezabatzea
- **`medication_modal_test.dart`**: Sendagai aukeren modala
- **`dose_registration_test.dart`**: Dosiaren erregistroa
- **`stock_management_test.dart`**: Stock kudeaketa
- **`navigation_test.dart`**: Pantailen arteko nabigazioa
- **`debug_menu_test.dart`**: Debug menua

### Proben Izendatze Eredua

- **`*_test.dart`**: Proba guztiak `_test.dart`-ekin amaitzen dira
- **`integration/*_test.dart`**: Integrazio probak azpikarpetan
- Probatutako funtzionaltasunaren izen deskribatzaileak
- Feature/modulu arabera taldekatuak

## Konfigurazio Fitxategiak

### `pubspec.yaml`

Flutter-en konfigurazio fitxategi nagusia. Edukia:

#### Mendekotasun Nagusiak

- **`sqflite`**: SQLite datu-basea
- **`flutter_local_notifications`**: Jakinarazpen lokalak
- **`timezone`**: Ordu-zonen kudeaketa
- **`intl`**: Nazioartekotzea eta dataren formatua
- **`shared_preferences`**: Gako-balio biltegiratzea
- **`file_picker`**: Fitxategien hautatzailea
- **`share_plus`**: Fitxategiak partekatzea
- **`path_provider`**: Sistemaren direktorioak atzitzea
- **`uuid`**: ID bakarren sorrera
- **`android_intent_plus`**: Android intentak

#### Baliabideak

- Launcher ikonoak (Android/iOS)
- Splash screen
- Lokalizazio fitxategiak (automatikoak)

#### Konfigurazioa

- SDK minimoa: Dart ^3.9.2
- Bertsioa: 1.0.0+1

### `l10n.yaml`

Lokalizazio sistemaren konfigurazioa:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: ARB fitxategien direktorioa
- **`template-arb-file`**: Txantiloia fitxategia (gaztelania)
- **`output-localization-file`**: Sortutako fitxategia
- **`untranslated-messages-file`**: Itzulpen falta direnen txostena

### `analysis_options.yaml`

Linting eta analisi estatikoko arauak:

- Flutter-en arauko multzo gomendatua
- Arauko gehigarri pertsonalizatuak
- Sortutako fitxategientzako esklusioitzak
- Ohartaratzaien larritasun konfigurazioa

### `android/app/build.gradle`

Android konpilazio konfigurazioa:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Jakinarazpen baimenak
- Ikono moldagarrien konfigurazioa

### `ios/Runner/Info.plist`

iOS konfigurazioa:

- Jakinarazpen baimenak
- Background mode konfigurazioa
- App Transport Security
- Ikonoak eta splash screen

## Modularizazio Emaitzak

Kodearen berregituraketa fitxategi bakoitzeko lerro kopuruaren murrizketa nabarmen eragin du, mantengarra sugartasuna hobetuz:

| Pantaila/Fitxategia | Lerro Aurretik | Lerro Ondoren | Murrizketa |
|---------------------|---------------|---------------|------------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (modulua) | 950 | 1450 | +52.6% (10 fitxategietan banatuta) |
| `medicine_cabinet` (modulua) | 850 | 875 | +2.9% (5 fitxategietan banatuta) |
| `dose_history` (modulua) | 780 | 920 | +17.9% (8 fitxategietan banatuta) |
| **Guztira** | **2580** | **1260** | **-39.3%** (fitxategi nagusiak) |

### Onurak

- Fitxategi txikiagoak eta fokalizatuagoak (< 400 lerro)
- Fitxategi bakoitzeko erantzukizun bakarra
- Widget berrerabilgarriak bereizita
- Kodea aurkitu eta aldatzeko erraztasuna
- Feature araberako antolamen du hobea
- Proba espezifikoagoak eta isolatuagoak

## Antolamendu Ereduak

### Geruzen Araberako Banaketa (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI eta aurkezpena                │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Negozio logika                   │
│  - Eragiketa konplexuak             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Iraunkortasuna                   │
│  - Datu modeloak                    │
└─────────────────────────────────────┘
```

### Izendatze Konbentzoak

#### Fitxategiak

- **Pantailak**: `*_screen.dart` (adib: `medication_list_screen.dart`)
- **Widgetak**: `*_widget.dart` edo izen deskribatzailea (adib: `medication_card.dart`)
- **Elkarrizketak**: `*_dialog.dart` (adib: `dose_selection_dialog.dart`)
- **Zerbitzuak**: `*_service.dart` (adib: `notification_service.dart`)
- **Modeloak**: izen singularra (adib: `person.dart`, `medication.dart`)
- **Helper-ak**: `*_helper.dart` (adib: `database_helper.dart`)
- **Probak**: `*_test.dart` (adib: `fasting_test.dart`)

#### Klaseak

- **Pantailak**: `*Screen` (adib: `MedicationListScreen`)
- **Widgetak**: izen deskribatzailea (adib: `MedicationCard`, `DoseHistoryCard`)
- **Zerbitzuak**: `*Service` (adib: `NotificationService`)
- **Modeloak**: izen singularra PascalCase-n (adib: `Person`, `Medication`)

#### Aldagaiak

- **camelCase** aldagaiak eta metodoentzat
- **UPPER_SNAKE_CASE** konstanteentzat
- **Izen deskribatzaileak** helburua islatzen dutenak

### Widget Berrerabilgarrien Kokapena

#### Widget Globalak (`lib/widgets/`)

Pantaila anitzetan erabiltzen diren widgetak:

- UI osagai generikoak
- Formulario partekatuak
- Ekintza botoi arruntak

#### Pantailako Widgetak (`lib/screens/*/widgets/`)

Pantaila espezifikoko widgetak:

- UI osagai bakarrak
- Pantaila testuinguruarekiko mendekoa duten widgetak
- Beste pantailetan ez dira berrerabiltzen

#### Elkarrizketak (`lib/screens/*/dialogs/`)

Pantaila espezifikoko elkarrizketak:

- Baieztatze modalak
- Aukeren orriak (bottom sheets)
- Datu sarrera elkarrizketak

### Helper-ak eta Erabilgarritasunak

#### `lib/utils/`

Funtzio puruak eta hedapenak:

- Egoera gabe
- Kanpoko mendekotasunik gabe
- App osoan berrerabilgarriak

#### `test/helpers/`

Probaketarako erabilgarritasun espezifikoak:

- Proba objektuen builder-ak
- Zerbitzu mock-ak
- Proba ingurunearen setup-a

## Baliabideak eta Baliabideak

### Launcher Ikonoak

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (bereizmen anitz)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Plataforma Konfigurazio Fitxategiak

#### Android

- `android/app/src/main/AndroidManifest.xml`: Baimenak eta konfigurazioa
- `android/app/build.gradle`: Konpilazioa eta mendekotasunak
- `android/gradle.properties`: Gradle properties
- `android/local.properties`: Bide lokalak (bertsioa tuta ez)

#### iOS

- `ios/Runner/Info.plist`: App konfigurazioa
- `ios/Podfile`: CocoaPods mendekotasunak
- `ios/Runner.xcodeproj/`: Xcode proiektua

## Proiektuaren Estatistikak

- **Dart fitxategi guztira `lib/`-en**: 131
- **Proba fitxategi guztira**: 43 (34 unitarioak + 9 integrazioa)
- **Kode lerroak (gutxi gorabehera)**: ~15,000 lerro
- **Proba estaldura**: Altua (zerbitzu kritikoak 100%)
- **Onartutako hizkuntzak**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Datu modeloak**: 6
- **Pantaila nagusiak**: 20+
- **Zerbitzuak**: 5 nagusi + 5 jakinarazpen moduluak
- **Widget berrerabilgarriak**: 50+

---

Dokumentu honek MedicApp proiektuaren egitura oso baten ikuspegia ematen du, garatzaile berri eta existenteen kodea nabigatzea eta ulertzea erraztuz.
