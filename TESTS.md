# Tests

El proyecto incluye una suite completa de tests:

```bash
flutter test
```

### Suite de tests incluida:

- **test/as_needed_stock_test.dart** (15): Gestión de stock para ocasionales, cálculo basado en consumo real, serialización
- **test/as_needed_main_screen_display_test.dart** (10): Display de medicamentos ocasionales en pantalla principal, integración con historial de dosis
- **test/medication_model_test.dart** (2): Modelo de medicamento, cálculo de stock y dosis
- **test/preferences_service_test.dart** (12): Gestión de preferencias de usuario, independencia entre preferencias, valores por defecto, preferencia de notificación fija de ayuno
- **test/notification_service_test.dart** (37): Servicio de notificaciones, singleton, permisos, notificaciones pospuestas, notificación ongoing persistente con actualización automática (tests fusionados y optimizados)
- **test/notification_cancellation_test.dart** (7): Cancelación inteligente, múltiples dosis, casos edge (tests parametrizados)
- **test/early_dose_notification_test.dart** (5): Reprogramación de dosis tempranas, parámetro excludeToday, fix de duplicados
- **test/database_refill_test.dart** (6): Persistencia de recargas en SQLite
- **test/integration/** (45): Suite modular de widgets e integración con helpers i18n compartidos
- **test/dose_management_test.dart** (11): Historial de dosis, eliminación, cambio de estado, recálculo de estadísticas
- **test/fasting_test.dart** (10): Configuración de ayuno, serialización JSON, compatibilidad legacy
- **test/fasting_countdown_test.dart** (14): Cuenta atrás visual de ayuno, cálculo de períodos activos/próximos, diferenciación before/after, validación de estructura de datos
- **test/fasting_notification_test.dart** (22): Tests consolidados de notificaciones de ayuno, lógica de programación (before/after), casos edge, notificaciones dinámicas basadas en hora real
- **test/fasting_field_preservation_test.dart** (8): Preservación de campos de ayuno en edición, validación de estado
- **test/early_dose_with_fasting_test.dart** (8): Toma temprana con ayuno, cancelación correcta, uso de hora real
- **test/medication_sorting_test.dart** (6): Ordenamiento por urgencia, retraso y proximidad
- **test/edit_screens_validation_test.dart** (18): Validación EditQuantityScreen, cobertura 92.6%
- **test/edit_schedule_screen_test.dart** (15): EditScheduleScreen, gestión dinámica de dosis, cobertura 50.7%
- **test/edit_fasting_screen_test.dart** (18): EditFastingScreen, state management, cobertura 84.6%
- **test/edit_duration_screen_test.dart** (23): EditDurationScreen, validación de fechas, cobertura 82.7%
- **test/database_export_import_test.dart** (12): Export/import con validación, backup automático, restauración
- **test/extra_dose_test.dart** (5): Tomas extra/excepcionales, reducción de stock, historial con isExtraDose, ayuno "after" dinámico
- **test/dose_history_service_test.dart** (18): Servicio de historial, eliminación de entradas, restauración de stock, cambio de estado, cambio de hora de registro, validación de fechas, excepciones
- **test/dose_action_service_test.dart** (28): Registro de dosis tomadas/omitidas/manuales, validación de stock, persistencia, reset diario, cantidades fraccionarias, fasting notifications
- **test/settings_screen_test.dart** (19): Pantalla de configuración, preferencias de visualización (hora real, cuenta atrás de ayuno, notificación fija), export/import de base de datos, navegación, estado de UI
- **test/day_navigation_test.dart** (5): Navegación por días en ViewModel, carga de datos históricos, filtrado por persona, medicamentos programados y ocasionales
- **test/day_navigation_ui_test.dart** (22): Lógica de navegación por días, formato de fecha ("Hoy" vs fecha simple), cálculo de offsets entre días, conversión página ↔ fecha, validación de límites (años bisiestos, cambios de mes/año), casos edge

**Total**: ~465 tests cubriendo modelo, servicios (incluidos dose_history y dose_action), preferencias, persistencia, historial, funcionalidad de ayuno (incluida cuenta atrás visual y notificación ongoing), tomas extra, notificaciones, stock, navegación por días (UI y ViewModel), pantallas principales (settings_screen), pantallas de edición, backup/restore y widgets de integración

**Cobertura global**: ~75-80% estimada (suite optimizada)

**Nota sobre el Botiquín**: La funcionalidad del Botiquín (vista de inventario) está implementada y funcional, pero no tiene tests dedicados ya que utiliza los mismos componentes y datos que el resto de la aplicación (lectura de base de datos, UI de lista, búsqueda). La funcionalidad es verificada manualmente.

### Archivos de test actuales (35 archivos)

**Tests unitarios:**
- as_needed_main_screen_display_test.dart
- as_needed_stock_test.dart
- database_export_import_test.dart
- database_refill_test.dart
- day_navigation_test.dart
- day_navigation_ui_test.dart
- dose_action_service_test.dart
- dose_history_service_test.dart
- dose_management_test.dart
- early_dose_notification_test.dart
- early_dose_with_fasting_test.dart
- edit_duration_screen_test.dart
- edit_fasting_screen_test.dart
- edit_schedule_screen_test.dart
- edit_screens_validation_test.dart
- extra_dose_test.dart
- fasting_countdown_test.dart
- fasting_field_preservation_test.dart
- fasting_notification_test.dart
- fasting_test.dart
- medication_model_test.dart
- medication_sorting_test.dart
- notification_cancellation_test.dart
- notification_service_test.dart
- preferences_service_test.dart
- settings_screen_test.dart

**Tests de integración (9 archivos en test/integration/):**
- add_medication_test.dart
- app_startup_test.dart
- debug_menu_test.dart
- delete_medication_test.dart
- dose_registration_test.dart
- edit_medication_test.dart
- medication_modal_test.dart
- navigation_test.dart
- stock_management_test.dart

### Mejoras recientes

- **Tests de navegación por días** (noviembre 2025): 27 tests nuevos para funcionalidad de navegación temporal, day_navigation_test.dart (5 tests ViewModel: carga de datos históricos, filtrado por persona, medicamentos programados/ocasionales), day_navigation_ui_test.dart (22 tests UI: formato de fecha "Hoy" vs fecha simple, cálculo de offsets día ↔ página, validación de límites de fecha, años bisiestos, cambios de mes/año, casos edge), cobertura completa de lógica de calendario y selector de fechas, **Fix en ViewModel**: proteger syncNotificationsWithMedications con isTestMode para evitar inicialización de plugins nativos en tests, mock de SharedPreferences en tests
- **Optimización y corrección de suite de tests** (enero 2025):
  - **Corrección de tests de integración**: 4 tests con errores `database_closed` corregidos, añadidas esperas para operaciones asíncronas del ViewModel
  - **Optimización de tests redundantes**: 18 tests eliminados o fusionados, ~277 líneas removidas
  - **Tests fusionados**: NotificationService (6 tests → 2), NotificationCancellation (5 → 1), múltiples grupos de tests solapados
  - **Mejora de mantenibilidad**: Suite más rápida y enfocada, eliminados tests triviales sin valor
  - **Análisis de cobertura exhaustivo**: Identificadas 18 áreas críticas sin cobertura, estimados 103-150 tests nuevos necesarios
  - **Total optimización**: De ~450 a ~432 tests activos (-4%), -277 líneas, 100% tests pasando
  - **Próximas prioridades**: Tests para DatabaseHelper V19+ (multi-usuario), NotificationService navigation/sync, ViewModel cache
- **Refactorización masiva de suite de tests** (octubre 2025):
  - **Fase 1 - Migración MedicationBuilder**: 65+ instancias migradas, 100% de tests usan builder pattern
  - **Fase 2 - Eliminación de redundancia**: ~20 tests redundantes eliminados, ~480 líneas removidas, suite 35% más rápida
  - **Archivos eliminados**: dose_action_screen_test.dart (código muerto, sin pantalla asociada), dynamic_fasting_notification_test.dart, fasting_notification_scheduling_test.dart
  - **Archivo consolidado**: fasting_notification_test.dart (22 tests unificados)
  - **Optimización de tests**: extra_dose_test.dart (10→5), fasting_test.dart (14→10)
  - **Total reducción**: De 453 a 389 tests (-64 tests redundantes)
- **Tests de servicios críticos** (octubre 2025): 40 tests nuevos para dose_history_service (12) y dose_action_service (28), cobertura de servicios críticos aumentada significativamente, validación completa de lógica de negocio
- **Tomas extra/excepcionales** (octubre 2025): Registro de dosis fuera del horario programado, soporte de ayuno "after" dinámico, visualización con badge púrpura en historial y pantalla principal, campo `isExtraDose` en historial, actualización de 2 tests de integración
- **Notificación fija de cuenta atrás** (octubre 2025): Notificación ongoing persistente (Android), timer de actualización automática, 19 tests nuevos (PreferencesService + NotificationService), gestión del medicamento más urgente
- **Cuenta atrás visual de ayuno** (octubre 2025): Nueva preferencia configurable, visualización de tiempo restante en pantalla principal, 14 tests de cálculo y validación, fix de SharedPreferences en tests de integración
- **Refactorización con Helpers** (enero 2025): 3 nuevos módulos (medication_builder, database_test_helper, test_helpers), 13 archivos refactorizados, -751 líneas (-38%), mejoras en legibilidad
- **Tests de pantallas de edición** (74 tests): EditQuantity (18), EditSchedule (15), EditFasting (18), EditDuration (23), cobertura +1.9%
- **Internacionalización** (enero 2025): 43 tests migrados a i18n, ~140 cadenas reemplazadas, 24 nuevas claves ES/EN, 100% cobertura i18n
- **Navegación adaptativa** (enero 2025): Tests para NavigationBar/NavigationRail según tamaño y orientación, MaterialDesign guías
- **Fix notificaciones** (octubre 2025): Corrección de duplicados con dosis tempranas, parámetro excludeToday, 5 nuevos tests, mejoras en menú debug

### Uso de MedicationBuilder

Todos los tests de la suite utilizan el patrón Builder para crear instancias de `Medication`, lo que proporciona:

- **Legibilidad mejorada**: API fluida y expresiva
- **Valores por defecto sensatos**: Solo especificar lo necesario para cada test
- **Tipo safety**: Validación en tiempo de compilación
- **Mantenibilidad**: Cambios centralizados en el builder

**Ejemplo de uso:**

```dart
// Medicamento regular con horarios
final medication = MedicationBuilder()
  .withName('Paracetamol')
  .withType(MedicationType.pill)
  .withDoseTimes(['08:00', '14:00', '20:00'])
  .withStockQuantity(30.0)
  .build();

// Medicamento ocasional
final asNeeded = MedicationBuilder()
  .withName('Ibuprofeno')
  .withType(MedicationType.pill)
  .asNeeded()
  .build();

// Con ayuno configurado
final withFasting = MedicationBuilder()
  .withName('Omeprazol')
  .withFastingDuration(60)
  .withFastingType('before')
  .build();
```

### Análisis de Cobertura y Próximos Pasos

**Estado actual** (enero 2025):
- Tests activos: ~432
- Cobertura estimada: 75-80%
- Suite completamente funcional: ✅ 100% tests pasando

**Áreas críticas sin cobertura identificadas:**

1. **DatabaseHelper - Operaciones Multi-Usuario V19+** (🔴 Alta prioridad)
   - `createMedicationForPerson()`, `getMedicationForPerson()`, `updateMedicationForPerson()`
   - `assignMedicationToPerson()`, `getMedicationsForPerson()`
   - Migración de datos sin asignar
   - **Estimado**: 15-20 tests nuevos, 3-4 días

2. **NotificationService - Navegación y Taps** (🔴 Alta prioridad)
   - `_onNotificationTapped()`, `_navigateWithRetry()`, `processPendingNotification()`
   - Manejo de payloads multi-persona
   - **Estimado**: 8-10 tests nuevos, 2 días

3. **NotificationService - Sincronización** (🔴 Alta prioridad)
   - `syncNotificationsWithMedications()` - limpieza de notificaciones huérfanas
   - **Estimado**: 5-7 tests nuevos, 1 día

4. **MedicationListViewModel - Caché y Background** (🟠 Media-Alta prioridad)
   - `_loadCacheData()`, `_scheduleNotificationsInBackground()`
   - **Estimado**: 6-8 tests nuevos, 1-2 días

5. **FastingStateManager - Gestión Multi-Persona** (🟠 Media-Alta prioridad)
   - `loadFastingPeriods()`, `updateNotification()`
   - Gestión de períodos activos de todas las personas
   - **Estimado**: 8-10 tests nuevos, 1-2 días

**Total tests necesarios estimados**: 103-150 tests adicionales para cobertura completa

**Roadmap sugerido**:
- **Fase 1** (2 semanas): Cobertura crítica (DatabaseHelper V19+, NotificationService)
- **Fase 2** (1-2 semanas): Cobertura media-alta (ViewModel, FastingStateManager)
- **Fase 3** (2 semanas): Schedulers de notificaciones y casos edge
- **Fase 4** (1 semana): Refinamiento y cobertura completa
