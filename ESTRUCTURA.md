# Estructura del proyecto

```
lib/
├── database/
│   └── database_helper.dart            # Gestión de base de datos SQLite (singleton)
├── models/
│   ├── medication.dart                 # Modelo principal de medicamento
│   ├── medication_type.dart            # Enum de tipos de medicamento con unidades de stock
│   ├── treatment_duration_type.dart    # Enum de tipos de duración de tratamiento
│   └── dose_history_entry.dart         # Modelo para historial de dosis
├── screens/
│   ├── main_screen.dart                # Pantalla principal con NavigationRail
│   ├── medication_inventory_screen.dart# Vista unificada de inventario (tabs)
│   │
│   ├── # Pantallas principales modularizadas
│   ├── medication_list_screen.dart     # Pantalla principal con lista de medicamentos (1193 líneas)
│   │   └── medication_list/            # Módulos de medication_list
│   │       ├── widgets/                # Widgets reutilizables
│   │       │   ├── medication_card.dart
│   │       │   ├── battery_optimization_banner.dart
│   │       │   ├── empty_medications_view.dart
│   │       │   ├── today_doses_section.dart
│   │       │   └── debug_menu.dart
│   │       ├── dialogs/                # Diálogos modales
│   │       │   ├── medication_options_sheet.dart
│   │       │   ├── dose_selection_dialog.dart
│   │       │   ├── manual_dose_input_dialog.dart
│   │       │   ├── refill_input_dialog.dart
│   │       │   ├── edit_today_dose_dialog.dart
│   │       │   └── notification_permission_dialog.dart
│   │       └── services/               # Servicios específicos
│   │           └── dose_calculation_service.dart
│   │
│   ├── debug_notifications_screen.dart # Pantalla de depuración de notificaciones con tabs por persona
│   │
│   ├── medicine_cabinet_screen.dart    # Pantalla de Botiquín (151 líneas)
│   │   └── medicine_cabinet/           # Módulos de medicine_cabinet
│   │       └── widgets/
│   │           ├── medication_card.dart
│   │           ├── empty_cabinet_view.dart
│   │           ├── no_search_results_view.dart
│   │           └── medication_options_modal.dart
│   │
│   ├── medication_stock_screen.dart    # Pantalla de Pastillero
│   │
│   ├── dose_action_screen.dart         # Pantalla de acciones desde notificación (281 líneas)
│   │   └── dose_action/                # Módulos de dose_action
│   │       └── widgets/
│   │           ├── medication_header_card.dart
│   │           ├── take_dose_button.dart
│   │           ├── skip_dose_button.dart
│   │           └── postpone_buttons.dart
│   │
│   ├── dose_history_screen.dart        # Pantalla de historial de dosis (292 líneas)
│   │   └── dose_history/               # Módulos de dose_history
│   │       ├── widgets/
│   │       │   ├── stat_card.dart
│   │       │   ├── dose_history_card.dart
│   │       │   ├── filter_dialog.dart
│   │       │   ├── statistics_card.dart
│   │       │   ├── active_filters_chip.dart
│   │       │   └── empty_history_view.dart
│   │       └── dialogs/
│   │           ├── edit_entry_dialog.dart
│   │           └── delete_confirmation_dialog.dart
│   │
│   ├── # Flujo modular de añadir medicamento (7 pasos)
│   ├── medication_info_screen.dart     # Paso 1: Información básica (121 líneas)
│   ├── medication_duration_screen.dart # Paso 2: Tipo de duración del tratamiento
│   ├── medication_dates_screen.dart    # Paso 3: Fechas del tratamiento
│   ├── medication_frequency_screen.dart# Paso 4: Frecuencia de medicación
│   ├── medication_dosage_screen.dart   # Paso 5: Configuración de dosis
│   ├── medication_times_screen.dart    # Paso 6: Horario de tomas
│   ├── medication_quantity_screen.dart # Paso 7: Cantidad de medicamento
│   │
│   ├── # Flujo modular de edición
│   ├── edit_medication_menu_screen.dart# Menú de selección de sección a editar
│   └── edit_sections/                  # Pantallas de edición por sección
│       ├── edit_basic_info_screen.dart # Editar información básica
│       ├── edit_duration_screen.dart   # Editar duración del tratamiento
│       ├── edit_frequency_screen.dart  # Editar frecuencia
│       ├── edit_schedule_screen.dart   # Editar horarios y cantidades
│       └── edit_quantity_screen.dart   # Editar cantidad disponible
│   │
│   ├── # Selectores especializados
│   ├── specific_dates_selector_screen.dart # Selector de fechas específicas
│   └── weekly_days_selector_screen.dart    # Selector de días de la semana
├── services/
│   ├── notification_service.dart       # Servicio de notificaciones locales (singleton)
│   ├── dose_action_service.dart        # Servicio de registro de dosis (taken/skipped/manual/extra)
│   ├── dose_history_service.dart       # Servicio de gestión de historial
│   └── preferences_service.dart        # Servicio de preferencias de usuario
├── main.dart                            # Punto de entrada con inicialización de notificaciones
└── test/                                # Suite completa de tests (389 tests)
    ├── # Tests de modelos (2 tests)
    ├── medication_model_test.dart       # Modelo de medicamento, cálculo de stock
    │
    ├── # Tests de servicios críticos (94 tests)
    ├── notification_service_test.dart   # Notificaciones, permisos, postpone, ongoing (42 tests)
    ├── dose_action_service_test.dart    # Registro de dosis, validaciones (28 tests)
    ├── dose_history_service_test.dart   # Historial, eliminación, cambio estado (20 tests)
    ├── preferences_service_test.dart    # Preferencias de usuario (12 tests)
    │
    ├── # Tests de database y persistencia (18 tests)
    ├── database_refill_test.dart        # Persistencia de recargas (6 tests)
    ├── database_export_import_test.dart # Export/import con backup (12 tests)
    │
    ├── # Tests de funcionalidad principal (79 tests)
    ├── dose_management_test.dart        # Historial de dosis, eliminación (11 tests)
    ├── extra_dose_test.dart             # Tomas excepcionales (13 tests)
    ├── notification_cancellation_test.dart # Cancelación inteligente (11 tests)
    ├── early_dose_notification_test.dart # Reprogramación de dosis tempranas (5 tests)
    ├── early_dose_with_fasting_test.dart # Dosis tempranas con ayuno (8 tests)
    ├── medication_sorting_test.dart     # Ordenamiento por urgencia (6 tests)
    ├── as_needed_stock_test.dart        # Stock para ocasionales (15 tests)
    ├── as_needed_main_screen_display_test.dart # Display de ocasionales (10 tests)
    │
    ├── # Tests de funcionalidad de ayuno (61 tests)
    ├── fasting_test.dart                # Configuración de ayuno (13 tests)
    ├── fasting_countdown_test.dart      # Cuenta atrás visual (14 tests)
    ├── fasting_notification_test.dart   # Notificaciones y programación de ayuno (26 tests)
    ├── fasting_field_preservation_test.dart # Preservación de campos de ayuno (8 tests)
    │
    ├── # Tests de pantallas de edición (74 tests)
    ├── edit_screens_validation_test.dart # EditQuantityScreen (18 tests)
    ├── edit_schedule_screen_test.dart   # EditScheduleScreen (15 tests)
    ├── edit_fasting_screen_test.dart    # EditFastingScreen (18 tests)
    ├── edit_duration_screen_test.dart   # EditDurationScreen (23 tests)
    │
    ├── # Tests de widgets principales (19 tests)
    ├── settings_screen_test.dart        # Pantalla de configuración (19 tests)
    │
    ├── # Tests de integración (63 tests)
    ├── integration/                     # Suite modular de tests de integración
    │   ├── add_medication_test.dart
    │   ├── app_startup_test.dart
    │   ├── debug_menu_test.dart
    │   ├── delete_medication_test.dart
    │   ├── dose_registration_test.dart
    │   ├── edit_medication_test.dart
    │   ├── medication_modal_test.dart
    │   ├── navigation_test.dart
    │   └── stock_management_test.dart
    │
    └── helpers/                         # Test helpers
        └── medication_builder.dart      # Builder pattern para crear Medication en tests
                                         # Métodos: .withExtraDoses(), .withFastingEdgeCase()
```

## Arquitectura Modular

### Principios aplicados
- **KISS (Keep It Simple)**: Cada componente tiene una única responsabilidad
- **DRY (Don't Repeat Yourself)**: Widgets reutilizables entre pantallas
- **Separación de responsabilidades**: Lógica de negocio separada de la presentación
- **Feature-based organization**: Módulos organizados por funcionalidad

### Resultados de la modularización
| Pantalla | Antes | Después | Reducción |
|----------|-------|---------|-----------|
| medication_list_screen.dart | 1,666 | 1,193 | -28.4% |
| medicine_cabinet_screen.dart | 606 | 151 | -75.1% |
| dose_history_screen.dart | 618 | 292 | -52.8% |
| medication_info_screen.dart | 135 | 121 | -10.4% |
| dose_action_screen.dart | 489 | 281 | -42.5% |
| **TOTAL** | **3,227** | **1,959** | **-39.3%** |

### Beneficios
✅ **Mantenibilidad**: Código más organizado y fácil de mantener
✅ **Reusabilidad**: Widgets compartidos entre múltiples pantallas
✅ **Testabilidad**: Componentes más pequeños y fáciles de probar
✅ **Escalabilidad**: Estructura preparada para crecimiento futuro
✅ **Legibilidad**: Archivos más cortos y enfocados

## Optimización de Rendimiento

### Patrón UI-First para Operaciones Asíncronas

La aplicación implementa un patrón de optimización donde **todas las operaciones que modifican datos actualizan la UI primero** y luego ejecutan tareas pesadas (como reprogramar notificaciones) en segundo plano de forma no bloqueante.

#### Patrón aplicado en MedicationListViewModel

```dart
// ✅ Patrón optimizado (UI instantánea)
async function operacionModificaDatos() {
  // 1. Modificar datos en base de datos
  await modificarDatos();

  // 2. Actualizar UI INMEDIATAMENTE (rápido: <200ms)
  await _fastingManager.loadFastingPeriods();
  await _reloadMedicationsOnly();  // Sin notificaciones

  // 3. Operaciones pesadas en background (no bloqueante)
  Future.microtask(() async {
    // Reprogramar notificaciones sin bloquear UI
    await NotificationService.instance.scheduleMedicationNotifications(...);
  });
}
```

#### Métodos optimizados

| Método | Función | Tiempo UI Antes | Tiempo UI Ahora |
|--------|---------|-----------------|-----------------|
| `registerDose()` | Registrar dosis programada | 2-3s | <200ms (15x) |
| `registerManualDose()` | Registrar dosis manual | 2-3s | <200ms (15x) |
| `deleteTodayDose()` | Eliminar dosis registrada | 2-3s | <200ms (15x) |
| `toggleTodayDoseStatus()` | Cambiar taken↔skipped | 2-3s | <200ms (15x) |
| `selectPerson()` | Cambiar pestaña persona | 1-2s | <200ms (10x) |
| `refillMedication()` | Rellenar stock | 1-2s | <200ms (10x) |
| `deleteMedication()` | Eliminar medicamento | 2-3s | <200ms (15x) |
| `loadMedications()` | Cargar lista completa | 1.5-3s | <300ms (10x) |

#### Método `_reloadMedicationsOnly()`

Método optimizado que recarga solo datos de UI sin operaciones costosas:

```dart
Future<void> _reloadMedicationsOnly() async {
  // ✅ Carga solo medicamentos y cache (rápido)
  // ❌ NO sincroniza notificaciones (lento)
  // ❌ NO reprograma notificaciones (lento)

  final medications = await DatabaseHelper.instance.getMedications(...);
  await _loadCacheData(medications);
  _medications.clear();
  _medications.addAll(medications);
  _safeNotify();  // Actualiza UI
}
```

### Optimización del Inicio de la App

**main.dart** inicia la app inmediatamente y reprograma notificaciones en background:

```dart
// ✅ App inicia instantáneamente
runApp(const MedicApp());

// Notificaciones en background (no bloquea inicio)
Future.microtask(() async {
  await NotificationService.instance.rescheduleAllMedicationNotifications();
});
```

### Resultados de Rendimiento

| Métrica | Antes | Ahora | Mejora |
|---------|-------|-------|--------|
| **Inicio de app** | 2-3s bloqueado | <100ms | 20-30x |
| **Frames saltados** | 106-204 por operación | ~0 | 100% eliminado |
| **Rate limiting** | Constante (warnings) | Eliminado | 100% |
| **Davey warnings** | 898-1324ms | <16ms | 98% reducción |
| **UI responsiva** | Requiere cambiar pestañas | Instantánea | ✅ |

### Principios de Optimización

1. **UI First**: Siempre actualizar UI primero (<200ms)
2. **Background Heavy Operations**: Notificaciones y operaciones costosas en `Future.microtask()`
3. **No Await on Non-Critical**: No esperar operaciones que no afectan la UI inmediata
4. **Reload Only What's Needed**: `_reloadMedicationsOnly()` vs `loadMedications()`
5. **Error Handling**: Operaciones background con `.catchError()` para no afectar UI
