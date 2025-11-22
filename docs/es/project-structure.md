# Estructura del Proyecto MedicApp

Este documento describe la organización de carpetas y archivos del proyecto MedicApp, una aplicación Flutter para gestión de medicamentos y recordatorios.

## Árbol de Directorios

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
│   ├── adherence_analysis.dart
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
│   ├── intelligent_reminders_service.dart
│   ├── cache/
│   │   ├── cache_entry.dart
│   │   ├── smart_cache_service.dart
│   │   └── medication_cache_service.dart
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
├── theme/
│   ├── app_theme.dart
│   └── theme_provider.dart
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
    ├── app_localizations.dart (generado)
    └── app_localizations_*.dart (generados)
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

### Archivos Raíz Importantes

```
medicapp/
├── pubspec.yaml              # Dependencias y configuración del proyecto
├── l10n.yaml                 # Configuración de localización
├── analysis_options.yaml     # Reglas de linting
├── android/
│   └── app/
│       └── build.gradle      # Configuración de Android
└── ios/
    └── Runner/
        └── Info.plist        # Configuración de iOS
```

## Directorio `lib/`

### `lib/main.dart`

Punto de entrada de la aplicación. Responsabilidades:

- Inicializar el servicio de notificaciones
- Solicitar permisos de notificaciones
- Crear la persona por defecto ("Yo") si no existe
- Configurar MaterialApp con:
  - Temas claro y oscuro accesibles (fuentes más grandes)
  - Soporte de localización (8 idiomas)
  - GlobalKey para navegación desde notificaciones
  - Rutas de navegación
- Re-programar notificaciones en background al iniciar

### `lib/database/`

#### `database_helper.dart`

Singleton que gestiona toda la persistencia de datos con SQLite. Responsabilidades:

- Crear y actualizar el esquema de base de datos
- CRUD para personas (Person)
- CRUD para medicamentos (Medication)
- CRUD para asignaciones persona-medicamento (PersonMedication)
- CRUD para historial de dosis (DoseHistoryEntry)
- Consultas complejas para obtener medicamentos activos por persona
- Exportar e importar base de datos (backup/restore)
- Soporte para base de datos en memoria (testing)

### `lib/models/`

Modelos de datos que representan las entidades del dominio:

#### `person.dart`

Representa una persona que toma medicamentos:

- `id`: UUID único
- `name`: Nombre de la persona
- `isDefault`: Indica si es la persona por defecto ("Yo")
- Conversión JSON y Map para SQLite

#### `medication.dart`

Representa un medicamento en el botiquín:

- Información básica: nombre, tipo, notas
- Cantidad y stock
- Frecuencia: diaria, semanal, intervalo personalizado, fechas específicas, según necesidad
- Horarios de toma
- Duración del tratamiento: continuo, fecha fin, número de dosis
- Configuración de ayuno (opcional)
- Métodos para calcular próximas dosis
- Validaciones de completitud

#### `person_medication.dart`

Relaciona medicamentos con personas:

- `personId`: Referencia a Person
- `medicationId`: Referencia a Medication
- `isActive`: Si está activo para la persona
- Usado para asignar medicamentos del botiquín a personas específicas

#### `adherence_analysis.dart`

Modelo para resultados de análisis de adherencia terapéutica:

- `overallAdherence`: Tasa global de adherencia (0.0-1.0)
- `adherenceByDayOfWeek`: Map con adherencia por día de la semana
- `adherenceByTimeOfDay`: Map con adherencia por hora del día
- `bestDay`: Día con mejor adherencia
- `worstDay`: Día con peor adherencia
- `bestTimeSlot`: Horario con mejor adherencia
- `worstTimeSlot`: Horario con peor adherencia
- `problematicDays`: Lista de días con adherencia <50%
- `recommendations`: Lista de sugerencias personalizadas
- `trend`: Tendencia de adherencia (improving/stable/declining)
- `totalDosesAnalyzed`: Total de dosis analizadas
- `dosesTaken`: Dosis tomadas
- `dosesMissed`: Dosis omitidas

Utilizado por `IntelligentRemindersService` para proporcionar insights detallados sobre patrones de medicación.

#### `dose_history_entry.dart`

Registro de una dosis tomada, omitida o pospuesta:

- `medicationId`: Medicamento asociado
- `personId`: Persona que tomó/omitió la dosis
- `scheduledTime`: Hora programada originalmente
- `actualTime`: Hora real de registro
- `status`: taken, skipped, postponed
- `wasEarly`: Si se tomó antes de tiempo
- `isExtraDose`: Si es dosis extra no programada
- `notes`: Notas opcionales

#### `medication_type.dart`

Enumeración de tipos de medicamento:

- Tableta, Cápsula, Jarabe, Inyección
- Inhalador, Crema, Parche
- Apósito, Gota, Otro

#### `treatment_duration_type.dart`

Enumeración de tipos de duración de tratamiento:

- `continuous`: Sin fecha de fin
- `untilDate`: Hasta una fecha específica
- `numberOfDoses`: Número limitado de dosis

### `lib/screens/`

Pantallas de la aplicación organizadas por funcionalidad.

#### Pantallas Principales

- **`main_screen.dart`**: Navegación principal con BottomNavigationBar
- **`medication_list_screen.dart`**: Lista de medicamentos activos de la persona, dosis de hoy
- **`medicine_cabinet_screen.dart`**: Botiquín compartido con todos los medicamentos
- **`dose_history_screen.dart`**: Historial de dosis con filtros y estadísticas
- **`settings_screen.dart`**: Configuración, exportar/importar BD, gestión de personas

#### Flujo de Agregar Medicamento (Wizard)

Navegación secuencial para crear un medicamento:

1. **`medication_info_screen.dart`**: Nombre, tipo, notas
2. **`medication_frequency_screen.dart`**: Frecuencia (diaria, semanal, intervalo, fechas)
3. **`medication_dosage_screen.dart`**: Dosis por toma o intervalo entre dosis
4. **`medication_times_screen.dart`**: Horarios de toma
5. **`medication_dates_screen.dart`**: Fecha de inicio (y fin opcional)
6. **`medication_duration_screen.dart`**: Tipo de duración del tratamiento
7. **`medication_fasting_screen.dart`**: Configuración de ayuno (opcional)
8. **`medication_quantity_screen.dart`**: Cantidad por toma
9. **`medication_inventory_screen.dart`**: Stock inicial y umbral de alerta

#### Pantallas de Edición

Ubicadas en `edit_sections/`:

- **`edit_basic_info_screen.dart`**: Editar nombre, tipo, notas
- **`edit_frequency_screen.dart`**: Modificar frecuencia
- **`edit_schedule_screen.dart`**: Cambiar horarios
- **`edit_duration_screen.dart`**: Ajustar duración del tratamiento
- **`edit_fasting_screen.dart`**: Configurar ayuno
- **`edit_quantity_screen.dart`**: Modificar cantidad

Cada sección tiene su propia carpeta con widgets específicos.

#### Pantallas de Soporte

- **`weekly_days_selector_screen.dart`**: Selector de días de la semana
- **`specific_dates_selector_screen.dart`**: Selector de fechas específicas
- **`dose_action_screen.dart`**: Registrar dosis (tomar, omitir, posponer)
- **`edit_medication_menu_screen.dart`**: Menú para editar medicamento
- **`medication_stock_screen.dart`**: Gestión de stock de medicamentos
- **`debug_notifications_screen.dart`**: Pantalla de debug para notificaciones (desarrollo)

#### Pantallas de Personas

Ubicadas en `persons/`:

- **`persons_management_screen.dart`**: Lista y gestión de personas
- **`add_edit_person_screen.dart`**: Crear o editar persona

#### Pantallas del Botiquín

Ubicadas en `medicine_cabinet/`:

- **`medication_person_assignment_screen.dart`**: Asignar medicamento a personas

#### Organización por Módulos

Cada pantalla compleja tiene su propia carpeta con:

- **`dialogs/`**: Diálogos específicos de la pantalla
- **`widgets/`**: Widgets reutilizables dentro de la pantalla
- **`services/`**: Lógica de negocio específica (ej: dose_calculation_service)

### `lib/services/`

Servicios que encapsulan lógica de negocio y operaciones complejas.

#### `notification_service.dart`

Servicio principal de notificaciones. Responsabilidades:

- Inicializar flutter_local_notifications
- Solicitar permisos de notificaciones
- Programar/cancelar notificaciones de medicamentos
- Manejar notificaciones de ayuno (ongoing)
- Gestionar notificaciones por persona
- Responder a acciones de notificación (tomar, omitir)
- Limitar notificaciones a 500 (máximo de Android)

#### `dose_action_service.dart`

Gestiona las acciones sobre dosis:

- Registrar dosis tomada
- Omitir dosis
- Posponer dosis
- Registrar dosis extra
- Actualizar stock automáticamente
- Re-programar notificaciones tras acción

#### `dose_history_service.dart`

Operaciones sobre el historial de dosis:

- Obtener historial filtrado por fecha, medicamento, persona
- Calcular estadísticas (adherencia, dosis tomadas/omitidas)
- Editar entradas de historial
- Eliminar entradas

#### `preferences_service.dart`

Gestiona preferencias de usuario con SharedPreferences:

- ID de persona activa
- Configuración de notificaciones
- Preferencias de UI
- Última fecha de uso
- **Modo de tema**: Guarda y recupera ThemeMode (system/light/dark)

Métodos relacionados con temas:
- `setThemeMode(ThemeMode mode)`: Persiste elección de tema
- `getThemeMode()`: Recupera tema guardado o retorna ThemeMode.system por defecto

#### `intelligent_reminders_service.dart`

Servicio de análisis de adherencia y predicción de patrones:

**Funcionalidades principales:**

1. **analyzeAdherence()**:
   - Analiza historial de dosis por persona y medicamento
   - Calcula métricas por día de la semana y hora del día
   - Identifica mejores/peores días y horarios
   - Genera recomendaciones personalizadas basadas en patrones
   - Calcula tendencia de adherencia (mejorando/estable/declinando)

2. **predictSkipProbability()**:
   - Predice probabilidad de omitir dosis en día/hora específicos
   - Clasifica riesgo como bajo (<30%), medio (30-60%), o alto (>60%)
   - Identifica factores de riesgo basados en historial
   - Útil para alertas proactivas

3. **suggestOptimalTimes()**:
   - Identifica horarios actuales con baja adherencia
   - Sugiere horarios alternativos con mejor historial
   - Calcula potencial de mejora para cada sugerencia
   - Proporciona razones basadas en datos

**Casos de uso:**
- Pantallas de estadísticas con análisis detallado
- Alertas proactivas para patrones problemáticos
- Asistente de optimización de horarios
- Reportes médicos con insights de cumplimiento

#### `notification_id_generator.dart`

Genera IDs únicos para notificaciones basados en:

- ID de medicamento
- Timestamp de la dosis
- Evita colisiones entre medicamentos

#### `services/cache/`

Subcarpeta con sistema de caché inteligente:

**`cache_entry.dart`**

Representa una entrada individual en el caché:

- `value`: Dato almacenado (genérico tipo T)
- `createdAt`: Timestamp de creación
- `lastAccessedAt`: Timestamp del último acceso (para LRU)
- `expiresAt`: Timestamp de expiración (basado en TTL)
- `isExpired`: Getter que verifica si la entrada ha caducado

**`smart_cache_service.dart`**

Servicio de caché genérico con algoritmo LRU y TTL automático:

- `maxSize`: Tamaño máximo de entradas en caché
- `ttl`: Time-To-Live para cada entrada
- Métodos principales:
  - `get(key)`: Obtiene valor si existe y no ha expirado
  - `put(key, value)`: Almacena valor con timestamp actual
  - `getOrCompute(key, computer)`: Patrón cache-aside
  - `invalidate(key)`: Elimina entrada específica
  - `clear()`: Limpia todo el caché
  - `statistics`: Getter con métricas (hits, misses, hit rate, evictions)
- Auto-limpieza cada minuto para eliminar entradas expiradas
- Algoritmo LRU evicta entradas menos usadas cuando se alcanza maxSize

**`medication_cache_service.dart`**

Gestiona cuatro cachés especializados para datos de medicamentos:

- `medicationsCache`: 10min TTL, 50 entradas - Medicamentos individuales
- `listsCache`: 5min TTL, 20 entradas - Listas de medicamentos
- `historyCache`: 3min TTL, 30 entradas - Consultas de historial
- `statisticsCache`: 30min TTL, 10 entradas - Cálculos estadísticos
- Métodos de invalidación selectiva por medicationId o personId

#### `services/notifications/`

Subcarpeta con módulos específicos de notificaciones:

- **`notification_config.dart`**: Configuración de canales y sonidos
- **`notification_cancellation_manager.dart`**: Cancelación inteligente de notificaciones
- **`daily_notification_scheduler.dart`**: Programar notificaciones diarias
- **`weekly_notification_scheduler.dart`**: Programar notificaciones semanales
- **`fasting_notification_scheduler.dart`**: Programar notificaciones de ayuno

### `lib/widgets/`

Widgets reutilizables en toda la aplicación:

#### `action_buttons.dart`

Botones comunes de acción (tomar, omitir, posponer dosis).

#### `medication_header_card.dart`

Tarjeta de cabecera con información del medicamento.

#### `widgets/forms/`

Formularios reutilizables:

- **`medication_info_form.dart`**: Formulario de información básica
- **`frequency_option_card.dart`**: Tarjeta de opción de frecuencia
- **`fasting_configuration_form.dart`**: Formulario de configuración de ayuno

### `lib/utils/`

Utilidades y extensiones:

#### `datetime_extensions.dart`

Extensiones para DateTime:

- Comparar fechas ignorando hora
- Formatear fechas
- Calcular días entre fechas
- Operaciones de inicio/fin de día

#### `medication_sorter.dart`

Algoritmos de ordenamiento de medicamentos:

- Por próxima dosis
- Por nombre
- Por tipo
- Por urgencia de stock

#### `number_utils.dart`

Utilidades para números:

- Formatear cantidades
- Validar rangos
- Conversiones

#### `platform_helper.dart`

Helpers específicos de plataforma:

- Detectar Android/iOS
- Abrir configuración del sistema
- Solicitar permisos específicos de plataforma

### `lib/theme/`

Sistema de temas con soporte para modo claro y oscuro.

#### `app_theme.dart`

Define los temas visuales de la aplicación:

**Temas completos:**
- `lightTheme`: Tema claro con Material Design 3
- `darkTheme`: Tema oscuro con Material Design 3

**Esquemas de color:**
- Colores primarios, secundarios y terciarios
- Superficies y fondos apropiados
- Contraste optimizado para accesibilidad

**Componentes personalizados:**
- `AppBarTheme`: Barras de aplicación cohesivas
- `CardTheme`: Tarjetas con elevación y bordes
- `FloatingActionButtonTheme`: Botones de acción destacados
- `InputDecorationTheme`: Campos de texto consistentes
- `DialogTheme`: Diálogos con esquinas redondeadas
- `SnackBarTheme`: Notificaciones temporales estilizadas
- `TextTheme`: Jerarquía tipográfica completa
- `IconTheme`: Iconos con colores apropiados

**Ventajas:**
- Transición suave entre temas
- Colores optimizados para legibilidad
- Soporte Material Design 3 completo
- Consistencia visual en toda la app

#### `theme_provider.dart`

Proveedor de estado para gestión de temas:

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  Future<void> setThemeMode(ThemeMode mode);
  ThemeMode get themeMode;
}
```

**Responsabilidades:**
- Mantener estado actual del tema (system/light/dark)
- Notificar cambios a widgets suscritos
- Persistir elección mediante PreferencesService
- Cargar tema guardado al iniciar

**Integración con app:**
- Usado con ChangeNotifierProvider en main.dart
- MaterialApp escucha cambios y actualiza UI automáticamente
- Transiciones sin necesidad de reiniciar app

### `lib/l10n/`

Sistema de localización (i18n) de la aplicación.

#### Archivos ARB (Application Resource Bundle)

Archivos de traducción en formato JSON:

- **`app_es.arb`**: Español (plantilla base)
- **`app_en.arb`**: Inglés
- **`app_ca.arb`**: Catalán
- **`app_eu.arb`**: Euskera
- **`app_gl.arb`**: Gallego
- **`app_fr.arb`**: Francés
- **`app_de.arb`**: Alemán
- **`app_it.arb`**: Italiano

Cada archivo contiene:

- Claves de traducción
- Valores traducidos
- Metadata de placeholders
- Descripciones para traductores

#### Archivos Generados

Generados automáticamente por `flutter gen-l10n`:

- **`app_localizations.dart`**: Clase base de localización
- **`app_localizations_es.dart`**, **`app_localizations_en.dart`**, etc.: Implementaciones por idioma

Uso en la app:

```dart
AppLocalizations.of(context).medicationName
```

## Directorio `test/`

Tests unitarios e integración para garantizar calidad del código.

### `test/helpers/`

Utilidades compartidas para testing:

#### `test_helpers.dart`

Helpers generales para tests:

- Setup de base de datos de prueba
- Mocks de servicios
- Funciones de inicialización

#### `database_test_helper.dart`

Helpers específicos para tests de base de datos:

- Crear base de datos en memoria
- Poblar con datos de prueba
- Limpiar estado entre tests

#### `medication_builder.dart`

Patrón Builder para crear medicamentos de prueba:

```dart
final medication = MedicationBuilder()
  .withName('Aspirina')
  .withDailyFrequency()
  .withTimes(['08:00', '20:00'])
  .build();
```

Simplifica la creación de medicamentos con diferentes configuraciones.

#### `person_test_helper.dart`

Helpers para crear personas de prueba:

- Crear persona por defecto
- Crear múltiples personas
- Gestionar relaciones persona-medicamento

#### `notification_test_helper.dart`

Mocks y helpers para tests de notificaciones:

- Mock de NotificationService
- Verificar notificaciones programadas
- Simular acciones de notificación

#### `widget_test_helpers.dart`

Helpers para widget tests:

- Crear widgets con context completo
- Pump widgets con localización
- Finders personalizados

#### `test_constants.dart`

Constantes compartidas entre tests:

- IDs de prueba
- Fechas y horas fijas
- Valores predeterminados

### Tests Unitarios (raíz de `test/`)

34 archivos de tests unitarios organizados por funcionalidad:

#### Tests de Base de Datos

- `database_export_import_test.dart`: Exportar/importar BD
- `database_refill_test.dart`: Recargar stock

#### Tests de Modelos

- `medication_model_test.dart`: Validación de modelo Medication

#### Tests de Servicios

- `notification_service_test.dart`: Servicio de notificaciones
- `dose_action_service_test.dart`: Acciones de dosis
- `dose_history_service_test.dart`: Historial de dosis
- `preferences_service_test.dart`: Preferencias de usuario

#### Tests de Notificaciones

- `notification_sync_test.dart`: Sincronización de notificaciones
- `notification_cancellation_test.dart`: Cancelación de notificaciones
- `notification_person_title_test.dart`: Títulos con nombre de persona
- `notification_multi_person_test.dart`: Notificaciones multi-persona
- `notification_actions_test.dart`: Acciones desde notificaciones
- `notification_limits_test.dart`: Límite de 500 notificaciones
- `notification_midnight_edge_cases_test.dart`: Casos límite de medianoche
- `early_dose_notification_test.dart`: Dosis tempranas
- `early_dose_with_fasting_test.dart`: Dosis tempranas con ayuno

#### Tests de Ayuno

- `fasting_test.dart`: Lógica de ayuno
- `fasting_notification_test.dart`: Notificaciones de ayuno
- `fasting_countdown_test.dart`: Cuenta regresiva de ayuno
- `fasting_field_preservation_test.dart`: Preservación de campos de ayuno

#### Tests de Dosis

- `dose_management_test.dart`: Gestión de dosis
- `extra_dose_test.dart`: Dosis extra
- `deletion_cleanup_test.dart`: Limpieza al eliminar
- `multiple_fasting_prioritization_test.dart`: Priorización con múltiples ayunos

#### Tests de Stock

- `as_needed_stock_test.dart`: Stock para medicamentos según necesidad

#### Tests de UI

- `day_navigation_test.dart`: Navegación entre días
- `day_navigation_ui_test.dart`: UI de navegación de días
- `medication_sorting_test.dart`: Ordenamiento de medicamentos
- `as_needed_main_screen_display_test.dart`: Visualización según necesidad

#### Tests de Pantallas

- `settings_screen_test.dart`: Pantalla de configuración
- `edit_duration_screen_test.dart`: Editar duración
- `edit_fasting_screen_test.dart`: Editar ayuno
- `edit_schedule_screen_test.dart`: Editar horarios
- `edit_screens_validation_test.dart`: Validaciones de edición

### Tests de Integración (`test/integration/`)

9 archivos de tests de integración que prueban flujos completos:

- **`app_startup_test.dart`**: Inicio de aplicación
- **`add_medication_test.dart`**: Flujo completo de agregar medicamento
- **`edit_medication_test.dart`**: Flujo de edición de medicamento
- **`delete_medication_test.dart`**: Eliminación de medicamento
- **`medication_modal_test.dart`**: Modal de opciones de medicamento
- **`dose_registration_test.dart`**: Registro de dosis
- **`stock_management_test.dart`**: Gestión de stock
- **`navigation_test.dart`**: Navegación entre pantallas
- **`debug_menu_test.dart`**: Menú de debug

### Patrón de Naming de Tests

- **`*_test.dart`**: Todos los tests terminan con `_test.dart`
- **`integration/*_test.dart`**: Tests de integración en subcarpeta
- Nombres descriptivos de la funcionalidad probada
- Agrupados por feature/módulo

## Archivos de Configuración

### `pubspec.yaml`

Archivo principal de configuración de Flutter. Contiene:

#### Dependencias Principales

- **`sqflite`**: Base de datos SQLite
- **`flutter_local_notifications`**: Notificaciones locales
- **`timezone`**: Manejo de zonas horarias
- **`intl`**: Internacionalización y formateo de fechas
- **`shared_preferences`**: Almacenamiento clave-valor
- **`file_picker`**: Selección de archivos
- **`share_plus`**: Compartir archivos
- **`path_provider`**: Acceso a directorios del sistema
- **`uuid`**: Generación de IDs únicos
- **`android_intent_plus`**: Intents de Android

#### Assets

- Iconos de launcher (Android/iOS)
- Splash screen
- Archivos de localización (automáticos)

#### Configuración

- SDK mínimo: Dart ^3.9.2
- Versión: 1.0.0+1

### `l10n.yaml`

Configuración del sistema de localización:

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
untranslated-messages-file: untranslated_messages.json
```

- **`arb-dir`**: Directorio de archivos ARB
- **`template-arb-file`**: Archivo plantilla (español)
- **`output-localization-file`**: Archivo generado
- **`untranslated-messages-file`**: Reporte de traducciones faltantes

### `analysis_options.yaml`

Reglas de linting y análisis estático:

- Conjunto de reglas recomendadas de Flutter
- Reglas personalizadas adicionales
- Exclusiones para archivos generados
- Configuración de severidad de advertencias

### `android/app/build.gradle`

Configuración de compilación Android:

- `minSdkVersion`: 21 (Android 5.0)
- `targetSdkVersion`: 34 (Android 14)
- Permisos de notificaciones
- Configuración de iconos adaptativos

### `ios/Runner/Info.plist`

Configuración de iOS:

- Permisos de notificaciones
- Configuración de background modes
- App Transport Security
- Iconos y splash screen

## Resultados de Modularización

La refactorización del código ha resultado en una reducción significativa de líneas de código por archivo, mejorando la mantenibilidad:

| Pantalla/Archivo | Líneas Antes | Líneas Después | Reducción |
|------------------|--------------|----------------|-----------|
| `medication_list_screen.dart` | 950 | 680 | -28.4% |
| `medicine_cabinet_screen.dart` | 850 | 212 | -75.1% |
| `dose_history_screen.dart` | 780 | 368 | -52.8% |
| `medication_list` (módulo) | 950 | 1450 | +52.6% (distribuido en 10 archivos) |
| `medicine_cabinet` (módulo) | 850 | 875 | +2.9% (distribuido en 5 archivos) |
| `dose_history` (módulo) | 780 | 920 | +17.9% (distribuido en 8 archivos) |
| **Total** | **2580** | **1260** | **-39.3%** (archivos principales) |

### Beneficios

- Archivos más pequeños y enfocados (< 400 líneas)
- Responsabilidad única por archivo
- Widgets reutilizables separados
- Facilidad para encontrar y modificar código
- Mejor organización por feature
- Tests más específicos y aislados

## Patrones de Organización

### Separación por Capas (Model-View-Service)

```
┌─────────────────────────────────────┐
│         Screens (View)              │
│  - UI y presentación                │
│  - StatefulWidget/StatelessWidget   │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│        Services (Business)          │
│  - Lógica de negocio                │
│  - Operaciones complejas            │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│      Database & Models (Data)       │
│  - Persistencia                     │
│  - Modelos de datos                 │
└─────────────────────────────────────┘
```

### Convenciones de Nombres

#### Archivos

- **Pantallas**: `*_screen.dart` (ej: `medication_list_screen.dart`)
- **Widgets**: `*_widget.dart` o nombre descriptivo (ej: `medication_card.dart`)
- **Diálogos**: `*_dialog.dart` (ej: `dose_selection_dialog.dart`)
- **Servicios**: `*_service.dart` (ej: `notification_service.dart`)
- **Modelos**: nombre singular (ej: `person.dart`, `medication.dart`)
- **Helpers**: `*_helper.dart` (ej: `database_helper.dart`)
- **Tests**: `*_test.dart` (ej: `fasting_test.dart`)

#### Clases

- **Pantallas**: `*Screen` (ej: `MedicationListScreen`)
- **Widgets**: nombre descriptivo (ej: `MedicationCard`, `DoseHistoryCard`)
- **Servicios**: `*Service` (ej: `NotificationService`)
- **Modelos**: nombre singular en PascalCase (ej: `Person`, `Medication`)

#### Variables

- **camelCase** para variables y métodos
- **UPPER_SNAKE_CASE** para constantes
- **Nombres descriptivos** que reflejan el propósito

### Ubicación de Widgets Reutilizables

#### Widgets Globales (`lib/widgets/`)

Widgets usados en múltiples pantallas:

- Componentes de UI genéricos
- Formularios compartidos
- Botones de acción comunes

#### Widgets de Pantalla (`lib/screens/*/widgets/`)

Widgets específicos de una pantalla:

- Componentes de UI únicos
- Widgets que dependen del contexto de la pantalla
- No se reutilizan en otras pantallas

#### Diálogos (`lib/screens/*/dialogs/`)

Diálogos específicos de una pantalla:

- Modales de confirmación
- Hojas de opciones (bottom sheets)
- Diálogos de entrada de datos

### Helpers y Utilidades

#### `lib/utils/`

Funciones puras y extensiones:

- Sin estado
- Sin dependencias externas
- Reutilizables en toda la app

#### `test/helpers/`

Utilidades específicas de testing:

- Builders de objetos de prueba
- Mocks de servicios
- Setup de entorno de test

## Assets y Recursos

### Iconos de Launcher

```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
└── mipmap-xxxhdpi/ic_launcher.png

ios/Runner/Assets.xcassets/AppIcon.appiconset/
└── Icon-*.png (múltiples resoluciones)
```

### Splash Screen

```
android/app/src/main/res/drawable/
└── launch_background.xml

ios/Runner/Assets.xcassets/LaunchImage.imageset/
└── LaunchImage*.png
```

### Archivos de Configuración de Plataforma

#### Android

- `android/app/src/main/AndroidManifest.xml`: Permisos y configuración
- `android/app/build.gradle`: Compilación y dependencias
- `android/gradle.properties`: Properties de Gradle
- `android/local.properties`: Rutas locales (no versionado)

#### iOS

- `ios/Runner/Info.plist`: Configuración de la app
- `ios/Podfile`: Dependencias CocoaPods
- `ios/Runner.xcodeproj/`: Proyecto Xcode

## Estadísticas del Proyecto

- **Total de archivos Dart en `lib/`**: 131
- **Total de archivos de test**: 43 (34 unitarios + 9 integración)
- **Líneas de código (aproximado)**: ~15,000 líneas
- **Cobertura de tests**: Alta (servicios críticos 100%)
- **Idiomas soportados**: 8 (ES, EN, CA, EU, GL, FR, DE, IT)
- **Modelos de datos**: 6
- **Pantallas principales**: 20+
- **Servicios**: 5 principales + 5 módulos de notificaciones
- **Widgets reutilizables**: 50+

---

Este documento proporciona una visión completa de la estructura del proyecto MedicApp, facilitando la navegación y comprensión del código para desarrolladores nuevos y existentes.
