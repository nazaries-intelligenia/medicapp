# Estrutura do Proxecto MedicApp

Este documento describe a organización de cartafoles e arquivos do proxecto MedicApp, unha aplicación Flutter para xestión de medicamentos e recordatorios.

## Árbore de Directorios

### Estrutura de `lib/`

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
    ├── app_localizations.dart (xerado)
    └── app_localizations_*.dart (xerados)
```

### Estrutura de `test/`

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

### Arquivos Raíz Importantes

```
medicapp/
├── pubspec.yaml              # Dependencias e configuración do proxecto
├── l10n.yaml                 # Configuración de localización
├── analysis_options.yaml     # Regras de linting
├── android/
│   └── app/
│       └── build.gradle      # Configuración de Android
└── ios/
    └── Runner/
        └── Info.plist        # Configuración de iOS
```

## Directorio `lib/`

### `lib/main.dart`

Punto de entrada da aplicación. Responsabilidades:

- Inicializar o servizo de notificacións
- Solicitar permisos de notificacións
- Crear a persoa por defecto ("Eu") se non existe
- Configurar MaterialApp con:
  - Temas claro e escuro accesibles (fontes máis grandes)
  - Soporte de localización (8 idiomas)
  - GlobalKey para navegación desde notificacións
  - Rutas de navegación
- Re-programar notificacións en background ao iniciar

### `lib/database/`

#### `database_helper.dart`

Singleton que xestiona toda a persistencia de datos con SQLite. Responsabilidades:

- Crear e actualizar o esquema de base de datos
- CRUD para persoas (Person)
- CRUD para medicamentos (Medication)
- CRUD para asignacións persoa-medicamento (PersonMedication)
- CRUD para historial de doses (DoseHistoryEntry)
- Consultas complexas para obter medicamentos activos por persoa
- Exportar e importar base de datos (backup/restore)
- Soporte para base de datos en memoria (testing)

### `lib/models/`

Modelos de datos que representan as entidades do dominio:

#### `person.dart`

Representa unha persoa que toma medicamentos:

- `id`: UUID único
- `name`: Nome da persoa
- `isDefault`: Indica se é a persoa por defecto ("Eu")
- Conversión JSON e Map para SQLite

#### `medication.dart`

Representa un medicamento no botiquín:

- Información básica: nome, tipo, notas
- Cantidade e stock
- Frecuencia: diaria, semanal, intervalo personalizado, datas específicas, segundo necesidade
- Horarios de toma
- Duración do tratamento: continuo, data fin, número de doses
- Configuración de xaxún (opcional)
- Métodos para calcular próximas doses
- Validacións de completitude

#### `person_medication.dart`

Relaciona medicamentos con persoas:

- `personId`: Referencia a Person
- `medicationId`: Referencia a Medication
- `isActive`: Se está activo para a persoa
- Usado para asignar medicamentos do botiquín a persoas específicas

#### `dose_history_entry.dart`

Rexistro dunha dose tomada, omitida ou posposta:

- `medicationId`: Medicamento asociado
- `personId`: Persoa que tomou/omitiu a dose
- `scheduledTime`: Hora programada orixinalmente
- `actualTime`: Hora real de rexistro
- `status`: taken, skipped, postponed
- `wasEarly`: Se se tomou antes de tempo
- `isExtraDose`: Se é dose extra non programada
- `notes`: Notas opcionais

#### `medication_type.dart`

Enumeración de tipos de medicamento:

- Tableta, Cápsula, Xarope, Inxección
- Inhalador, Crema, Parche
- Apósito, Gota, Outro

#### `treatment_duration_type.dart`

Enumeración de tipos de duración de tratamento:

- `continuous`: Sen data de fin
- `untilDate`: Ata unha data específica
- `numberOfDoses`: Número limitado de doses

### `lib/screens/`

Pantallas da aplicación organizadas por funcionalidade.

#### Pantallas Principais

- **`main_screen.dart`**: Navegación principal con BottomNavigationBar
- **`medication_list_screen.dart`**: Lista de medicamentos activos da persoa, doses de hoxe
- **`medicine_cabinet_screen.dart`**: Botiquín compartido con todos os medicamentos
- **`dose_history_screen.dart`**: Historial de doses con filtros e estatísticas
- **`settings_screen.dart`**: Configuración, exportar/importar BD, xestión de persoas

#### Fluxo de Engadir Medicamento (Wizard)

Navegación secuencial para crear un medicamento:

1. **`medication_info_screen.dart`**: Nome, tipo, notas
2. **`medication_frequency_screen.dart`**: Frecuencia (diaria, semanal, intervalo, datas)
3. **`medication_dosage_screen.dart`**: Dose por toma ou intervalo entre doses
4. **`medication_times_screen.dart`**: Horarios de toma
5. **`medication_dates_screen.dart`**: Data de inicio (e fin opcional)
6. **`medication_duration_screen.dart`**: Tipo de duración do tratamento
7. **`medication_fasting_screen.dart`**: Configuración de xaxún (opcional)
8. **`medication_quantity_screen.dart`**: Cantidade por toma
9. **`medication_inventory_screen.dart`**: Stock inicial e limiar de alerta

#### Pantallas de Edición

Ubicadas en `edit_sections/`:

- **`edit_basic_info_screen.dart`**: Editar nome, tipo, notas
- **`edit_frequency_screen.dart`**: Modificar frecuencia
- **`edit_schedule_screen.dart`**: Cambiar horarios
- **`edit_duration_screen.dart`**: Axustar duración do tratamento
- **`edit_fasting_screen.dart`**: Configurar xaxún
- **`edit_quantity_screen.dart`**: Modificar cantidade

Cada sección ten o seu propio cartafol con widgets específicos.

#### Pantallas de Soporte

- **`weekly_days_selector_screen.dart`**: Selector de días da semana
- **`specific_dates_selector_screen.dart`**: Selector de datas específicas
- **`dose_action_screen.dart`**: Rexistrar dose (tomar, omitir, pospor)
- **`edit_medication_menu_screen.dart`**: Menú para editar medicamento
- **`medication_stock_screen.dart`**: Xestión de stock de medicamentos
- **`debug_notifications_screen.dart`**: Pantalla de debug para notificacións (desenvolvemento)

#### Pantallas de Persoas

Ubicadas en `persons/`:

- **`persons_management_screen.dart`**: Lista e xestión de persoas
- **`add_edit_person_screen.dart`**: Crear ou editar persoa

#### Pantallas do Botiquín

Ubicadas en `medicine_cabinet/`:

- **`medication_person_assignment_screen.dart`**: Asignar medicamento a persoas

#### Organización por Módulos

Cada pantalla complexa ten o seu propio cartafol con:

- **`dialogs/`**: Diálogos específicos da pantalla
- **`widgets/`**: Widgets reutilizables dentro da pantalla
- **`services/`**: Lóxica de negocio específica (ex: dose_calculation_service)

### `lib/services/`

Servizos que encapsulan lóxica de negocio e operacións complexas.

#### `notification_service.dart`

Servizo principal de notificacións. Responsabilidades:

- Inicializar flutter_local_notifications
- Solicitar permisos de notificacións
- Programar/cancelar notificacións de medicamentos
- Manexar notificacións de xaxún (ongoing)
- Xestionar notificacións por persoa
- Responder a accións de notificación (tomar, omitir)
- Limitar notificacións a 500 (máximo de Android)

#### `dose_action_service.dart`

Xestiona as accións sobre doses:

- Rexistrar dose tomada
- Omitir dose
- Pospor dose
- Rexistrar dose extra
- Actualizar stock automaticamente
- Re-programar notificacións tras acción

#### `dose_history_service.dart`

Operacións sobre o historial de doses:

- Obter historial filtrado por data, medicamento, persoa
- Calcular estatísticas (adherencia, doses tomadas/omitidas)
- Editar entradas de historial
- Eliminar entradas

#### `preferences_service.dart`

Xestiona preferencias de usuario con SharedPreferences:

- ID de persoa activa
- Configuración de notificacións
- Preferencias de UI
- Última data de uso

#### `notification_id_generator.dart`

Xera IDs únicos para notificacións baseados en:

- ID de medicamento
- Timestamp da dose
- Evita colisións entre medicamentos

#### `services/notifications/`

Subcartafol con módulos específicos de notificacións:

- **`notification_config.dart`**: Configuración de canles e sons
- **`notification_cancellation_manager.dart`**: Cancelación intelixente de notificacións
- **`daily_notification_scheduler.dart`**: Programar notificacións diarias
- **`weekly_notification_scheduler.dart`**: Programar notificacións semanais
- **`fasting_notification_scheduler.dart`**: Programar notificacións de xaxún

### `lib/widgets/`

Widgets reutilizables en toda a aplicación:

#### `action_buttons.dart`

Botóns comúns de acción (tomar, omitir, pospor dose).

#### `medication_header_card.dart`

Tarxeta de cabeceira con información do medicamento.

#### `widgets/forms/`

Formularios reutilizables:

- **`medication_info_form.dart`**: Formulario de información básica
- **`frequency_option_card.dart`**: Tarxeta de opción de frecuencia
- **`fasting_configuration_form.dart`**: Formulario de configuración de xaxún

### `lib/utils/`

Utilidades e extensións:

#### `datetime_extensions.dart`

Extensións para DateTime:

- Comparar datas ignorando hora
- Formatear datas
- Calcular días entre datas
- Operacións de inicio/fin de día

#### `medication_sorter.dart`

Algoritmos de ordenamento de medicamentos:

- Por próxima dose
- Por nome
- Por tipo
- Por urxencia de stock

#### `number_utils.dart`

Utilidades para números:

- Formatear cantidades
- Validar rangos
- Conversións

#### `platform_helper.dart`

Helpers específicos de plataforma:

- Detectar Android/iOS
- Abrir configuración do sistema
- Solicitar permisos específicos de plataforma

### `lib/l10n/`

Sistema de localización (i18n) da aplicación.

#### Arquivos ARB (Application Resource Bundle)

Arquivos de tradución en formato JSON:

- **`app_es.arb`**: Español (plantilla base)
- **`app_en.arb`**: Inglés
- **`app_ca.arb`**: Catalán
- **`app_eu.arb`**: Éuscaro
- **`app_gl.arb`**: Galego
- **`app_fr.arb`**: Francés
- **`app_de.arb`**: Alemán
- **`app_it.arb`**: Italiano

Cada arquivo contén:

- Claves de tradución
- Valores traducidos
- Metadata de placeholders
- Descricións para tradutores

#### Arquivos Xerados

Xerados automaticamente por `flutter gen-l10n`:

- **`app_localizations.dart`**: Clase base de localización
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etc.: Implementacións por idioma

Uso na app:

```dart
AppLocalizations.of(context).medicationName
```

## Directorio `test/`

Tests unitarios e integración para garantir calidade do código.

### `test/helpers/`

Utilidades compartidas para testing:

#### `test_helpers.dart`

Helpers xerais para tests:

- Setup de base de datos de proba
- Mocks de servizos
- Funcións de inicialización

#### `database_test_helper.dart`

Helpers específicos para tests de base de datos:

- Crear base de datos en memoria
- Poblar con datos de proba
- Limpar estado entre tests

#### `medication_builder.dart`

Patrón Builder para crear medicamentos de proba:

```dart
final medication = MedicationBuilder()
  .withName('Aspirina')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Simplifica a creación de medicamentos con diferentes configuracións.

#### `person_test_helper.dart`

Helpers para crear persoas de proba:

- Crear persoa por defecto
- Crear múltiples persoas
- Xestionar relacións persoa-medicamento

#### `notification_test_helper.dart`

Mocks e helpers para tests de notificacións:

- Mock de NotificationService
- Verificar notificacións programadas
- Simular accións de notificación

#### `widget_test_helpers.dart`

Helpers para widget tests:

- Crear widgets con context completo
- Pump widgets con localización
- Finders personalizados

#### `test_constants.dart`

Constantes compartidas entre tests:

- IDs de proba
- Datas e horas fixas
- Valores predeterminados

### Tests Unitarios (raíz de `test/`)

34 arquivos de tests unitarios organizados por funcionalidade:

#### Tests de Base de Datos

- `database_export_import_test.dart`: Exportar/importar BD
- `database_refill_test.dart`: Recargar stock

#### Tests de Modelos

- `medication_model_test.dart`: Validación de modelo Medication

#### Tests de Servizos

- `notification_service_test.dart`: Servizo de notificacións
- `dose_action_service_test.dart`: Accións de doses
- `dose_history_service_test.dart`: Historial de doses
- `preferences_service_test.dart`: Preferencias de usuario

#### Tests de Notificacións

- `notification_sync_test.dart`: Sincronización de notificacións
- `notification_cancellation_test.dart`: Cancelación de notificacións
- `notification_person_title_test.dart`: Títulos con nome de persoa
- `notification_multi_person_test.dart`: Notificacións multi-persoa
- `notification_actions_test.dart`: Accións desde notificacións
- `notification_limits_test.dart`: Límite de 500 notificacións
- `notification_midnight_edge_cases_test.dart`: Casos límite de medianoite
- `early_dose_notification_test.dart`: Doses temperás
- `early_dose_with_fasting_test.dart`: Doses temperás con xaxún

#### Tests de Xaxún

- `fasting_test.dart`: Lóxica de xaxún
- `fasting_notification_test.dart`: Notificacións de xaxún
- `fasting_countdown_test.dart`: Conta regresiva de xaxún
- `fasting_field_preservation_test.dart`: Preservación de campos de xaxún

#### Tests de Doses

- `dose_management_test.dart`: Xestión de doses
- `extra_dose_test.dart`: Doses extra
- `deletion_cleanup_test.dart`: Limpeza ao eliminar
- `multiple_fasting_prioritization_test.dart`: Priorización con múltiples xaxúns

#### Tests de Stock

- `as_needed_stock_test.dart`: Stock para medicamentos segundo necesidade

#### Tests de UI

- `day_navigation_test.dart`: Navegación entre días
- `day_navigation_ui_test.dart`: UI de navegación de días
- `medication_sorting_test.dart`: Ordenamento de medicamentos
- `as_needed_main_screen_display_test.dart`: Visualización segundo necesidade

#### Tests de Pantallas

- `settings_screen_test.dart`: Pantalla de configuración
- `edit_duration_screen_test.dart`: Editar duración
- `edit_fasting_screen_test.dart`: Editar xaxún
- `edit_schedule_screen_test.dart`: Editar horarios
- `edit_screens_validation_test.dart`: Validacións de edición

### Tests de Integración (`test/integration/`)

9 arquivos de tests de integración que proban fluxos completos:

- **`app_startup_test.dart`**: Inicio de aplicación
- **`add_medication_test.dart`**: Fluxo completo de engadir medicamento
- **`edit_medication_test.dart`**: Fluxo de edición de medicamento
- **`delete_medication_test.dart`**: Eliminación de medicamento
- **`medication_modal_test.dart`**: Modal de opcións de medicamento
- **`dose_registration_test.dart`**: Rexistro de doses
- **`stock_management_test.dart`**: Xestión de stock
- **`navigation_test.dart`**: Navegación entre pantallas
- **`debug_menu_test.dart`**: Menú de debug

### Patrón de Naming de Tests

- **`*_test.dart`**: Todos os tests rematan con `_test.dart`
- **`integration/*_test.dart`**: Tests de integración en subcartafol
- Nomes descritivos da funcionalidade probada
- Agrupados por feature/módulo

## Arquivos de Configuración

### `pubspec.yaml`

Arquivo principal de configuración de Flutter. Contén:

#### Dependencias Principais

- **`sqflite`**: Base de datos SQLite
- **`flutter_local_notifications`**: Notificacións locais
- **`timezone`**: Manexo de zonas horarias
- **`intl`**: Internacionalización e formateo de datas
- **`shared_preferences`**: Almacenamento clave-valor
- **`file_picker`**: Selección de arquivos
- **`share_plus`**: Compartir arquivos
- **`path_provider`**: Acceso a directorios do sistema
- **`uuid`**: Xeración de IDs únicos
- **`android_intent_plus`**: Intents de Android

#### Assets

- Iconos de launcher (Android/iOS)
- Splash screen
- Arquivos de localización (automáticos)

#### Configuración

- SDK mínimo: Dart ^3.9.2
- Versión: 1.0.0+1

### `l10n.yaml`

Configuración do sistema de localización:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: Directorio de arquivos ARB
- **`template-arb-file`**: Arquivo plantilla (español)
- **`output-localization-file`**: Arquivo xerado
- **`untranslated-messages-file`**: Reporte de traducións faltantes

### `analysis_options.yaml`

Regras de linting e análise estático:

- Conxunto de regras recomendadas de Flutter
- Regras personalizadas adicionais
- Exclusións para arquivos xerados
- Configuración de severidade de advertencias

### `android/app/build.gradle`

Configuración de compilación Android:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Permisos de notificacións
- Configuración de iconos adaptativos

### `ios/Runner/Info.plist`

Configuración de iOS:

- Permisos de notificacións
- Configuración de background modes
- App Transport Security
- Iconos e splash screen

## Resultados de Modularización

A refactorización do código resultou nunha redución significativa de liñas de código por arquivo, mellorando a mantenibilidade:

| Pantalla/Arquivo | Liñas Antes | Liñas Despois | Redución |
|------------------|--------------|----------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (módulo) | 950 | 1450 | +52.6% (distribuído en 10 arquivos) |
| `medicine_cabinet` (módulo) | 850 | 875 | +2.9% (distribuído en 5 arquivos) |
| `dose_history` (módulo) | 780 | 920 | +17.9% (distribuído en 8 arquivos) |
| **Total** | **2580** | **1260** | **-39.3%** (arquivos principais) |

### Beneficios

- Arquivos máis pequenos e enfocados (< 400 liñas)
- Responsabilidade única por arquivo
- Widgets reutilizables separados
- Facilidade para atopar e modificar código
- Mellor organización por feature
- Tests máis específicos e illados

## Patróns de Organización

### Separación por Capas (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI e presentación                │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Lóxica de negocio                │
│  - Operacións complexas             │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistencia                     │
│  - Modelos de datos                 │
└─────────────────────────────────────┘
```

### Convencións de Nomes

#### Arquivos

- **Pantallas**: `*_screen.dart` (ex: `medication_list_screen.dart`)
- **Widgets**: `*_widget.dart` ou nome descritivo (ex: `medication_card.dart`)
- **Diálogos**: `*_dialog.dart` (ex: `dose_selection_dialog.dart`)
- **Servizos**: `*_service.dart` (ex: `notification_service.dart`)
- **Modelos**: nome singular (ex: `person.dart`, `medication.dart`)
- **Helpers**: `*_helper.dart` (ex: `database_helper.dart`)
- **Tests**: `*_test.dart` (ex: `fasting_test.dart`)

#### Clases

- **Pantallas**: `*Screen` (ex: `MedicationListScreen`)
- **Widgets**: nome descritivo (ex: `MedicationCard`, `DoseHistoryCard`)
- **Servizos**: `*Service` (ex: `NotificationService`)
- **Modelos**: nome singular en PascalCase (ex: `Person`, `Medication`)

#### Variables

- **camelCase** para variables e métodos
- **UPPER_SNAKE_CASE** para constantes
- **Nomes descritivos** que reflicten o propósito

### Ubicación de Widgets Reutilizables

#### Widgets Globais (`lib/widgets/`)

Widgets usados en múltiples pantallas:

- Compoñentes de UI xenéricos
- Formularios compartidos
- Botóns de acción comúns

#### Widgets de Pantalla (`lib/screens/*/widgets/`)

Widgets específicos dunha pantalla:

- Compoñentes de UI únicos
- Widgets que dependen do contexto da pantalla
- Non se reutilizan noutras pantallas

#### Diálogos (`lib/screens/*/dialogs/`)

Diálogos específicos dunha pantalla:

- Modais de confirmación
- Follas de opcións (bottom sheets)
- Diálogos de entrada de datos

### Helpers e Utilidades

#### `lib/utils/`

Funcións puras e extensións:

- Sen estado
- Sen dependencias externas
- Reutilizables en toda a app

#### `test/helpers/`

Utilidades específicas de testing:

- Builders de obxectos de proba
- Mocks de servizos
- Setup de ambiente de test

## Assets e Recursos

### Iconos de Launcher

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (múltiples resolucións)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Arquivos de Configuración de Plataforma

#### Android

- `android/app/src/main/AndroidManifest.xml`: Permisos e configuración
- `android/app/build.gradle`: Compilación e dependencias
- `android/gradle.properties`: Properties de Gradle
- `android/local.properties`: Rutas locais (non versionado)

#### iOS

- `ios/Runner/Info.plist`: Configuración da app
- `ios/Podfile`: Dependencias CocoaPods
- `ios/Runner.xcodeproj/`: Proxecto Xcode

## Estatísticas do Proxecto

- **Total de arquivos Dart en `lib/`**: 131
- **Total de arquivos de test**: 43 (34 unitarios + 9 integración)
- **Liñas de código (aproximado)**: ~15,000 liñas
- **Cobertura de tests**: Alta (servizos críticos 100%)
- **Idiomas soportados**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Modelos de datos**: 6
- **Pantallas principais**: 20+
- **Servizos**: 5 principais + 5 módulos de notificacións
- **Widgets reutilizables**: 50+

---

Este documento proporciona unha visión completa da estrutura do proxecto MedicApp, facilitando a navegación e comprensión do código para desenvolvedores novos e existentes.
