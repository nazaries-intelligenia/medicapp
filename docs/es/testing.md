# Guía de Testing - MedicApp

## Tabla de Contenidos

1. [Visión General del Testing](#visión-general-del-testing)
2. [Estructura de Tests](#estructura-de-tests)
3. [Tests Unitarios](#tests-unitarios)
4. [Tests de Widgets](#tests-de-widgets)
5. [Tests de Integración](#tests-de-integración)
6. [Helpers de Testing](#helpers-de-testing)
7. [Cobertura de Tests](#cobertura-de-tests)
8. [Casos Edge Cubiertos](#casos-edge-cubiertos)
9. [Ejecutar Tests](#ejecutar-tests)
10. [Guía para Escribir Tests](#guía-para-escribir-tests)
11. [Testing de Base de Datos](#testing-de-base-de-datos)
12. [CI/CD y Testing Automatizado](#cicd-y-testing-automatizado)
13. [Próximos Pasos](#próximos-pasos)

---

## Visión General del Testing

MedicApp cuenta con una suite de tests robusta y bien estructurada que garantiza la calidad y estabilidad del código:

- **601+ tests automatizados** distribuidos en 57 archivos
- **75-80% de cobertura de código** en áreas críticas
- **Múltiples tipos de tests**: unitarios, widgets e integración
- **Test-Driven Development (TDD)** para nuevas funcionalidades
- **Cobertura medible**: Soporte integrado para `flutter test --coverage`

### Filosofía de Testing

Nuestra estrategia de testing se basa en:

1. **Tests como documentación**: Los tests documentan el comportamiento esperado del sistema
2. **Cobertura inteligente**: Enfoque en áreas críticas (notificaciones, ayuno, gestión de dosis)
3. **Fast feedback**: Tests rápidos que se ejecutan en memoria
4. **Isolation**: Cada test es independiente y no afecta a otros
5. **Realismo**: Tests de integración que simulan flujos reales de usuario

### Tipos de Tests

```
test/
├── unitarios/          # Tests de servicios, modelos y lógica de negocio
├── widgets/            # Tests de componentes y pantallas individuales
└── integration/        # Tests end-to-end de flujos completos
```

---

## Estructura de Tests

El directorio de tests está organizado de forma clara y lógica:

```
test/
├── helpers/                              # Utilidades compartidas entre tests
│   ├── medication_builder.dart           # Builder pattern para crear medicamentos
│   ├── database_test_helper.dart         # Setup y cleanup de base de datos
│   ├── widget_test_helpers.dart          # Helpers para tests de widgets
│   ├── person_test_helper.dart           # Helpers para gestión de personas
│   ├── notification_test_helper.dart     # Helpers para tests de notificaciones
│   ├── test_constants.dart               # Constantes compartidas
│   └── test_helpers.dart                 # Helpers generales
│
├── integration/                          # Tests de integración (9 archivos)
│   ├── add_medication_test.dart          # Flujo completo de añadir medicamento
│   ├── edit_medication_test.dart         # Flujo de edición
│   ├── delete_medication_test.dart       # Flujo de eliminación
│   ├── dose_registration_test.dart       # Registro de dosis
│   ├── stock_management_test.dart        # Gestión de stock
│   ├── medication_modal_test.dart        # Modal de detalles
│   ├── navigation_test.dart              # Navegación entre pantallas
│   ├── app_startup_test.dart             # Inicio de aplicación
│   └── debug_menu_test.dart              # Menú de depuración
│
└── [41 archivos de tests unitarios/widgets]
```

### Archivos de Tests por Categoría

#### Tests de Servicios (13 archivos)
- `notification_service_test.dart` - Servicio de notificaciones
- `dose_action_service_test.dart` - Acciones sobre dosis
- `dose_history_service_test.dart` - Historial de dosis
- `preferences_service_test.dart` - Preferencias de usuario
- Y más...

#### Tests de Funcionalidad Core (18 archivos)
- `medication_model_test.dart` - Modelo de medicamento
- `dose_management_test.dart` - Gestión de dosis
- `extra_dose_test.dart` - Dosis extra
- `database_refill_test.dart` - Recargas de stock
- `database_export_import_test.dart` - Exportación/importación
- Y más...

#### Tests de Ayuno (6 archivos)
- `fasting_test.dart` - Lógica de ayuno
- `fasting_notification_test.dart` - Notificaciones de ayuno
- `fasting_countdown_test.dart` - Cuenta atrás de ayuno
- `fasting_field_preservation_test.dart` - Preservación de campos
- `early_dose_with_fasting_test.dart` - Dosis anticipada con ayuno
- `multiple_fasting_prioritization_test.dart` - Priorización múltiple

#### Tests de Pantallas (14 archivos)
- `edit_schedule_screen_test.dart` - Pantalla de edición de horarios
- `edit_duration_screen_test.dart` - Pantalla de edición de duración
- `edit_fasting_screen_test.dart` - Pantalla de edición de ayuno
- `edit_screens_validation_test.dart` - Validaciones
- `settings_screen_test.dart` - Pantalla de configuración
- `day_navigation_ui_test.dart` - Navegación por días
- Y más...

---

## Tests Unitarios

Los tests unitarios verifican el comportamiento de componentes individuales de forma aislada.

### Tests de Servicios

Verifican la lógica de negocio de los servicios:

#### NotificationService

```dart
test('should generate unique IDs for different medications', () {
  final id1 = _generateNotificationId('med1', 0);
  final id2 = _generateNotificationId('med2', 0);

  expect(id1, isNot(equals(id2)));
});

test('should handle all notification operations in test mode', () async {
  service.enableTestMode();

  final medication = MedicationBuilder()
      .withId('test-med')
      .withSingleDose('08:00', 1.0)
      .build();

  await service.scheduleMedicationNotifications(
    medication,
    personId: 'test-person-id'
  );

  // No debe lanzar excepciones
});
```

#### DoseActionService

```dart
test('should register dose and update stock', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await service.registerDose(medication, '08:00');

  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Tests de Modelos

Verifican la serialización y deserialización de datos:

```dart
group('Medication Model - Fasting Configuration', () {
  test('should serialize fasting configuration to JSON', () {
    final medication = MedicationBuilder()
        .withId('test_6')
        .withMultipleDoses(['08:00', '16:00'], 1.0)
        .withFasting(type: 'before', duration: 60)
        .build();

    final json = medication.toJson();

    expect(json['requiresFasting'], 1);
    expect(json['fastingType'], 'before');
    expect(json['fastingDurationMinutes'], 60);
    expect(json['notifyFasting'], 1);
  });

  test('should deserialize fasting from JSON', () {
    final json = {
      'id': 'test_8',
      'name': 'Test Medication',
      'requiresFasting': 1,
      'fastingType': 'before',
      'fastingDurationMinutes': 60,
      // ... otros campos
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Tests de Utilidades

Verifican funciones auxiliares y cálculos:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 dosis/día
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unidades / 2 por día = 10 días
});
```

---

## Tests de Widgets

Los tests de widgets verifican la interfaz de usuario y la interacción del usuario.

### Tests de Pantallas

Verifican que las pantallas se renderizan correctamente y responden a las interacciones:

```dart
testWidgets('Should add medication with default type', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Paracetamol');
  await waitForDatabase(tester);

  expect(find.text('Paracetamol'), findsOneWidget);
  expect(find.text('Pastilla'), findsAtLeastNWidgets(1));
});
```

### Tests de Componentes

Verifican componentes individuales de la UI:

```dart
testWidgets('Should display fasting countdown', (tester) async {
  final medication = MedicationBuilder()
      .withFasting(type: 'after', duration: 120)
      .build();

  await tester.pumpWidget(
    MaterialApp(
      home: FastingCountdown(medication: medication),
    ),
  );

  expect(find.textContaining('2:00'), findsOneWidget);
});
```

### Mocking de Dependencias

Para tests de widgets, usamos mocks para aislar componentes:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Base de datos en memoria
  DatabaseHelper.setInMemoryDatabase(true);

  // Modo de prueba para notificaciones
  NotificationService.instance.enableTestMode();

  // Asegurar persona por defecto
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Ejemplo Completo: Test de Edición

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Añadir medicamento
  await addMedicationWithDuration(tester, 'Ibuprofeno');
  await waitForDatabase(tester);

  // Abrir menú de edición
  await openEditMenuAndSelectSection(
    tester,
    'Ibuprofeno',
    'Horarios y Cantidades',
  );

  // Modificar horarios
  final timeField = find.byType(TextFormField).first;
  await tester.enterText(timeField, '10:00');

  // Guardar
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Verificar cambio
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Tests de Integración

Los tests de integración verifican flujos completos de usuario end-to-end.

### Tests End-to-End

Simulan el comportamiento real del usuario:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Iniciar app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Añadir medicamento
  await addMedicationWithDuration(
    tester,
    'Paracetamol',
    stockQuantity: '20',
  );
  await waitForDatabase(tester);

  // 3. Verificar que aparece en lista
  expect(find.text('Paracetamol'), findsOneWidget);

  // 4. Abrir modal de detalles
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  // 5. Registrar dosis
  await tester.tap(find.text('Tomar dosis'));
  await waitForComplexAsyncOperation(tester);

  // 6. Verificar stock actualizado
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Flujos Completos

Los tests de integración cubren flujos importantes:

1. **Agregar medicamento**: `add_medication_test.dart`
   - Navegación completa del wizard
   - Configuración de todos los parámetros
   - Verificación en lista principal

2. **Editar medicamento**: `edit_medication_test.dart`
   - Modificación de cada sección
   - Preservación de datos no modificados
   - Actualización correcta en lista

3. **Eliminar medicamento**: `delete_medication_test.dart`
   - Confirmación de eliminación
   - Limpieza de notificaciones
   - Eliminación de historial asociado

4. **Registrar dosis**: `dose_registration_test.dart`
   - Registro manual desde modal
   - Actualización de stock
   - Creación de entrada en historial

5. **Gestión de stock**: `stock_management_test.dart`
   - Alertas de stock bajo
   - Recarga de stock
   - Cálculo de duración

### Interacción con Base de Datos

Los tests de integración interactúan con una base de datos real en memoria:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Primera instancia de la app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simular cierre y reapertura
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medicamento debe seguir presente
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Helpers de Testing

Los helpers simplifican la escritura de tests y reducen código duplicado.

### MedicationBuilder

El **patrón builder** permite crear medicamentos de prueba de forma legible:

```dart
/// Ejemplo básico
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Con ayuno
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Con múltiples dosis
final medication = MedicationBuilder()
    .withName('Antibiótico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Como medicamento "a demanda"
final medication = MedicationBuilder()
    .withName('Analgésico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Beneficios de MedicationBuilder

1. **Legibilidad**: El código es autodocumentado y fácil de entender
2. **Mantenibilidad**: Cambios en el modelo solo requieren actualizar el builder
3. **Reducción de código**: Evita repetir valores por defecto en cada test
4. **Flexibilidad**: Permite configurar solo lo necesario para cada test

#### Factory Methods

El builder incluye métodos de fábrica para casos comunes:

```dart
// Stock bajo (5 unidades)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Sin stock
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Múltiples dosis al día (automático)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Ayuno habilitado con valores por defecto
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Permite crear un builder a partir de un medicamento existente:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nombre Modificado')
    .build();
```

### DatabaseTestHelper

Simplifica la configuración y limpieza de la base de datos:

```dart
class DatabaseTestHelper {
  /// Configuración inicial (una vez por archivo)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Limpieza después de cada test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Atazo: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Asegura que existe persona por defecto
  static Future<void> ensureDefaultPerson() async {
    final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();

    if (!hasDefault) {
      final person = Person(
        id: const Uuid().v4(),
        name: 'Test User',
        isDefault: true,
      );
      await DatabaseHelper.instance.insertPerson(person);
    }
  }
}
```

**Uso en tests:**

```dart
void main() {
  DatabaseTestHelper.setup(); // Configuración completa

  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  test('my test', () async {
    // Tu test aquí
  });
}
```

### WidgetTestHelpers

Funciones auxiliares para tests de widgets:

```dart
/// Obtener localizaciones
AppLocalizations getL10n(WidgetTester tester);

/// Esperar operaciones de base de datos
Future<void> waitForDatabase(WidgetTester tester);

/// Esperar a que aparezca un widget
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Hacer scroll a un widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Abrir menú de edición
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Añadir medicamento completo
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Esperar operaciones asíncronas complejas
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Otros Helpers

- **PersonTestHelper**: Gestión de personas en tests
- **NotificationTestHelper**: Helpers para notificaciones
- **TestConstants**: Constantes compartidas (dosis, stocks, tiempos)

---

## Cobertura de Tests

La suite de tests cubre las áreas más críticas de la aplicación.

### Cobertura por Categoría

| Categoría | Tests | Descripción |
|-----------|-------|-------------|
| **Servicios** | ~94 tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Funcionalidad Core** | ~79 tests | Gestión de dosis, stock, ayuno, exportación/importación |
| **Ayuno** | ~61 tests | Lógica de ayuno, notificaciones, cuenta atrás, priorización |
| **Pantallas** | ~93 tests | Tests de widgets y navegación de todas las pantallas |
| **Integración** | ~52 tests | Flujos completos end-to-end |

**Total: 601+ tests**

### Áreas Bien Cubiertas

#### Notificaciones (95% cobertura)
- Programación y cancelación de notificaciones
- IDs únicos para diferentes tipos de notificaciones
- Notificaciones para patrones semanales y fechas específicas
- Notificaciones de ayuno
- Acciones rápidas desde notificaciones
- Límites de plataforma (500 notificaciones)
- Casos edge de medianoche

#### Ayuno (90% cobertura)
- Cálculo de períodos de ayuno (before/after)
- Validaciones de duración
- Notificaciones de inicio y fin
- Cuenta atrás visual
- Priorización con múltiples períodos activos
- Dosis anticipadas con ayuno
- Preservación de configuración

#### Gestión de Dosis (88% cobertura)
- Registro de dosis (manual y desde notificación)
- Omisión de dosis
- Dosis extra
- Actualización de stock
- Historial de dosis
- Cálculo de consumo diario

#### Base de Datos (85% cobertura)
- CRUD de medicamentos
- CRUD de personas
- Migración de esquema
- Exportación/importación
- Integridad referencial
- Limpieza en cascada

### Áreas con Menos Cobertura

Algunas áreas tienen cobertura menor pero no crítica:

- **UI/UX avanzada** (60%): Animaciones, transiciones
- **Configuración** (65%): Preferencias de usuario
- **Localización** (70%): Traducciones e idiomas
- **Permisos** (55%): Solicitud de permisos de sistema

Estas áreas tienen menor cobertura porque:
1. Son difíciles de testear automáticamente
2. Requieren interacción manual
3. Dependen del sistema operativo
4. No afectan la lógica de negocio crítica

---

## Casos Edge Cubiertos

Los tests incluyen casos especiales que podrían causar errores:

### 1. Notificaciones a Medianoche

**Archivo**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dosis programada ayer a las 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Registrada hoy a las 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Debe contar como dosis del día anterior
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dosis a las 22:00 con ayuno "after" de 3 horas
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Ayuno termina a las 01:00 del día siguiente
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Casos cubiertos:**
- Dosis tardías registradas después de medianoche
- Períodos de ayuno que cruzan medianoche
- Dosis programadas exactamente a las 00:00
- Reseteo de contadores diarios
- Notificaciones pospuestas que cruzan medianoche

### 2. Eliminación y Limpieza

**Archivo**: `deletion_cleanup_test.dart`

```dart
test('deleting a medication cancels all its notifications', () async {
  final medication = MedicationBuilder()
      .withId('med-to-delete')
      .withSingleDose('08:00', 1.0)
      .build();

  await db.insertMedication(medication);
  await notificationService.schedule(medication);

  // Eliminar
  await db.deleteMedication(medication.id);
  await notificationService.cancelAll(medication.id);

  // No debe haber notificaciones programadas
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Eliminar persona
  await db.deletePerson(person.id);

  // No debe haber medicamentos ni historial
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Casos cubiertos:**
- Cancelación de notificaciones al eliminar medicamento
- Eliminación en cascada de historial
- Limpieza de notificaciones al eliminar persona
- No afectar otros medicamentos/personas
- Integridad referencial

### 3. Priorización de Múltiples Ayunos

**Archivo**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Medicamento 1: ayuno "after" de 120 minutos
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Medicamento 2: ayuno "after" de 60 minutos
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Registrar ambas dosis
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Solo debe mostrar el ayuno más restrictivo (med-1 hasta 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Casos cubiertos:**
- Múltiples ayunos activos para una persona
- Selección del período más restrictivo
- Ordenación por tiempo de finalización
- Filtrado automático de períodos terminados
- Independencia entre personas diferentes

### 4. Acciones de Notificación

**Archivo**: `notification_actions_test.dart`

```dart
test('register_dose action should reduce stock and create history', () async {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();

  await insertMedication(medication);

  // Simular acción "register_dose" desde notificación
  await handleNotificationAction(
    action: 'register_dose',
    medicationId: medication.id,
    doseTime: '08:00',
  );

  // Verificar efectos
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0); // 20 - 2
  expect(updated.takenDosesToday, contains('08:00'));

  final history = await db.getDoseHistory(medication.id);
  expect(history.last.status, 'taken');
});

test('snooze_dose action should postpone notification by 10 minutes',
    () async {
  final notification = await scheduleNotification(
    medicationId: 'med-1',
    time: TimeOfDay(hour: 8, minute: 0),
  );

  // Posponer
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Verificar nueva programación
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Casos cubiertos:**
- Registro desde notificación
- Omisión desde notificación
- Posponer 10 minutos
- Actualización correcta de stock e historial
- Cancelación de notificación original

### 5. Límites de Notificaciones

**Archivo**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Crear 100 medicamentos con 4 dosis cada uno
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Programar notificaciones (potencialmente >500)
  await notificationService.scheduleAll();

  // No debe crashear
  // Debe priorizar notificaciones cercanas
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Casos cubiertos:**
- Manejar más de 500 notificaciones
- Priorizar notificaciones cercanas
- Logging de advertencias
- No crashear la app
- Reprogramación automática

---

## Ejecutar Tests

### Comandos Básicos

```bash
# Ejecutar todos los tests
flutter test

# Test específico
flutter test test/services/notification_service_test.dart

# Tests en un directorio
flutter test test/integration/

# Tests con nombre específico
flutter test --name "fasting"

# Tests en modo verbose
flutter test --verbose

# Tests con reporte de tiempo
flutter test --reporter expanded
```

### Tests con Cobertura

```bash
# Ejecutar tests con cobertura
flutter test --coverage

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir reporte en navegador
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Ejecutar Tests Específicos

```bash
# Solo tests de servicios
flutter test test/*_service_test.dart

# Solo tests de integración
flutter test test/integration/

# Solo tests de ayuno
flutter test test/fasting*.dart

# Excluir tests lentos
flutter test --exclude-tags=slow
```

### Tests en CI/CD

```bash
# Modo CI (sin color, formato adecuado para logs)
flutter test --machine --coverage

# Con timeout para tests lentos
flutter test --timeout=30s

# Fallo rápido (detener en primer error)
flutter test --fail-fast
```

### Depuración de Tests

```bash
# Ejecutar un solo test en modo debug
flutter test --plain-name "specific test name"

# Con breakpoints (VS Code/Android Studio)
# Usar "Debug Test" desde el IDE

# Con prints visibles
flutter test --verbose

# Guardar output a archivo
flutter test > test_output.txt 2>&1
```

---

## Guía para Escribir Tests

### Estructura AAA (Arrange-Act-Assert)

Organiza cada test en tres secciones claras:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Preparar el entorno
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Ejecutar la acción a testear
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Verificar el resultado
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Naming Conventions

Usa nombres descriptivos que expliquen el escenario:

```dart
// ✅ BIEN: Describe el escenario completo
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ MAL: Nombres vagos o técnicos
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Formato recomendado:**
- `should [acción esperada] when [condición]`
- `[acción] [resultado esperado] [contexto opcional]`

### Setup y Teardown

Configura y limpia el entorno de forma consistente:

```dart
void main() {
  // Configuración inicial una sola vez
  DatabaseTestHelper.setupAll();

  late NotificationService service;
  late DatabaseHelper db;

  // Antes de cada test
  setUp(() async {
    service = NotificationService.instance;
    service.enableTestMode();
    db = DatabaseHelper.instance;
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  // Después de cada test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Tus tests aquí
  test('...', () async {
    // Test aislado con ambiente limpio
  });
}
```

### Mocking de DatabaseHelper

Para tests unitarios puros, mockea la base de datos:

```dart
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late DoseActionService service;

  setUp(() {
    mockDb = MockDatabaseHelper();
    service = DoseActionService(database: mockDb);
  });

  test('should call database method with correct parameters', () async {
    final medication = MedicationBuilder().build();

    // Configurar mock
    when(mockDb.updateMedication(any))
        .thenAnswer((_) async => 1);

    // Ejecutar acción
    await service.registerDose(medication.id, '08:00');

    // Verificar llamada
    verify(mockDb.updateMedication(argThat(
      predicate<Medication>((m) =>
        m.id == medication.id &&
        m.takenDosesToday.contains('08:00')
      )
    ))).called(1);
  });
}
```

### Uso de MedicationBuilder

Aprovecha el builder para crear tests legibles:

```dart
test('should calculate correct stock duration', () {
  // Crear medicamento con builder
  final medication = MedicationBuilder()
      .withName('Paracetamol')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 dosis al día
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 días
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory method para stock bajo
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Mejores Prácticas

1. **Tests independientes**: Cada test debe poder ejecutarse solo
   ```dart
   // ✅ BIEN: Test autocontenido
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... rest of test
   });

   // ❌ MAL: Depende de orden de ejecución
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Depende del test anterior
   });
   ```

2. **Tests rápidos**: Usa base de datos en memoria, evita delays innecesarios
   ```dart
   // ✅ BIEN
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ MAL
   await Future.delayed(Duration(seconds: 2)); // Delay arbitrario
   ```

3. **Assertions específicas**: Verifica exactamente lo que importa
   ```dart
   // ✅ BIEN
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ MAL
   expect(medication, isNotNull); // Demasiado vago
   ```

4. **Grupos lógicos**: Organiza tests relacionados
   ```dart
   group('Dose Registration', () {
     test('should register dose successfully', () {});
     test('should update stock when registering', () {});
     test('should create history entry', () {});
   });

   group('Dose Validation', () {
     test('should reject invalid time format', () {});
     test('should reject negative quantity', () {});
   });
   ```

5. **Test edge cases**: No solo el happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Comentarios útiles**: Explica el "por qué", no el "qué"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Dosis registradas después de medianoche pero dentro
     // de 2 horas de la programación cuentan para el día anterior
     // Esto previene que dosis tardías dupliquen el conteo diario

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Testing de Base de Datos

### Uso de sqflite_common_ffi

Los tests usan `sqflite_common_ffi` para base de datos en memoria:

```dart
void main() {
  setUpAll(() {
    // Inicializar FFI
    sqfliteFfiInit();

    // Usar factory FFI
    databaseFactory = databaseFactoryFfi;

    // Habilitar modo en memoria
    DatabaseHelper.setInMemoryDatabase(true);
  });

  test('database operations', () async {
    // Base de datos se crea automáticamente en memoria
    final db = DatabaseHelper.instance;

    // Operaciones normales
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Base de Datos en Memoria

Ventajas de usar base de datos en memoria:

1. **Velocidad**: 10-100x más rápido que disco
2. **Aislamiento**: Cada test comienza con BD limpia
3. **Sin efectos secundarios**: No modifica datos reales
4. **Paralelización**: Tests pueden correr en paralelo

```dart
setUp(() async {
  // Resetear para BD limpia
  await DatabaseHelper.resetDatabase();

  // Modo en memoria
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migraciones en Tests

Los tests verifican que las migraciones funcionan correctamente:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Crear BD en versión 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (sin tabla persons)
      await db.execute('''
        CREATE TABLE medications (...)
      ''');
    },
  );

  await db.close();

  // Abrir en versión 19 (trigger migración)
  final migratedDb = await DatabaseHelper.instance.database;

  // Verificar que persons existe
  final tables = await migratedDb.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='persons'"
  );

  expect(tables, isNotEmpty);

  // Verificar persona por defecto
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Limpieza entre Tests

Es crucial limpiar la BD entre tests para evitar contaminación:

```dart
tearDown(() async {
  // Método 1: Borrar todos los datos
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Método 2: Resetear completamente
  await DatabaseHelper.resetDatabase();

  // Método 3: Usar helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Tests de Integridad Referencial

Verificar que las relaciones de BD funcionan correctamente:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Eliminar persona
  await db.deletePerson(person.id);

  // Medicamentos deben haberse eliminado
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Intentar insertar historial para medicamento inexistente
  final entry = DoseHistoryEntry(
    id: 'h1',
    medicationId: 'non-existent',
    personId: 'p1',
    scheduledTime: '08:00',
    status: 'taken',
  );

  // Debe fallar por foreign key constraint
  expect(
    () => db.insertDoseHistory(entry),
    throwsA(isA<DatabaseException>()),
  );
});
```

---

## CI/CD y Testing Automatizado

### Integración Continua

Configuración típica para GitHub Actions:

```yaml
name: Tests

on:
  push:
    branches: [ main, development ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage --machine

    - name: Check coverage
      run: |
        COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 70" | bc -l) )); then
          echo "Coverage $COVERAGE% is below 70%"
          exit 1
        fi

    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v2
      with:
        file: ./coverage/lcov.info
```

### Pre-commit Hooks

Usar `husky` o scripts Git hooks para ejecutar tests antes de commit:

```bash
# .git/hooks/pre-commit
#!/bin/sh

echo "Running tests..."
flutter test

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed!"
```

### Umbral Mínimo de Cobertura

Configurar umbral mínimo para evitar regressions:

```bash
# scripts/check_coverage.sh
#!/bin/bash

flutter test --coverage

# Verificar cobertura mínima
MIN_COVERAGE=70
ACTUAL_COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | awk '{print $2}' | sed 's/%//')

if (( $(echo "$ACTUAL_COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "❌ Coverage $ACTUAL_COVERAGE% is below minimum $MIN_COVERAGE%"
  exit 1
else
  echo "✅ Coverage $ACTUAL_COVERAGE% meets minimum $MIN_COVERAGE%"
fi
```

### Reportes de Cobertura

Generar reportes visuales automáticamente:

```bash
# Generar reporte
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Badge de cobertura
./scripts/generate_coverage_badge.sh

# Publicar reporte
# (usar GitHub Pages, Codecov, Coveralls, etc.)
```

---

## Próximos Pasos

### Áreas a Mejorar

1. **Tests de UI/UX (60% → 80%)**
   - Más tests de animaciones
   - Tests de gestos y swipes
   - Tests de accesibilidad

2. **Tests de Permisos (55% → 75%)**
   - Mock de permisos del sistema
   - Flujos de solicitud de permisos
   - Manejo de permisos denegados

3. **Tests de Localización (70% → 90%)**
   - Tests para cada idioma
   - Verificación de traducciones completas
   - Tests de formateo de fechas/números

4. **Tests de Performance**
   - Benchmarks de operaciones críticas
   - Tests de carga (muchos medicamentos)
   - Memory leak detection

### Tests Pendientes

#### Alta Prioridad

- [ ] Tests de backup/restore completo
- [ ] Tests de notificaciones en background
- [x] Tests de widget de home screen (widget_service_test.dart)
- [ ] Tests de deep links
- [ ] Tests de compartir datos

#### Media Prioridad

- [ ] Tests de todos los idiomas
- [ ] Tests de temas (claro/oscuro)
- [ ] Tests de onboarding
- [ ] Tests de migraciones entre todas las versiones
- [ ] Tests de exportación a CSV/PDF

#### Baja Prioridad

- [ ] Tests de animaciones complejas
- [ ] Tests de gestos avanzados
- [ ] Tests de accesibilidad exhaustivos
- [ ] Tests de rendimiento en dispositivos lentos

### Roadmap de Testing

#### Q1 2025
- Alcanzar 80% de cobertura general
- Completar tests de permisos
- Añadir tests de performance básicos

#### Q2 2025
- Tests de todos los idiomas
- Tests de backup/restore
- Documentación de testing actualizada

#### Q3 2025
- Tests de accesibilidad completos
- Tests de carga y estrés
- Automatización completa en CI/CD

#### Q4 2025
- 85%+ cobertura general
- Suite de tests de performance
- Tests de regresión visual

---

## Recursos Adicionales

### Documentación

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Herramientas

- **flutter_test**: Framework de testing de Flutter
- **mockito**: Mocking de dependencias
- **sqflite_common_ffi**: BD en memoria para tests
- **test_coverage**: Análisis de cobertura
- **lcov**: Generación de reportes HTML

### Archivos Relacionados

- `/test/helpers/` - Todos los helpers de testing
- `/test/integration/` - Tests de integración
- `/.github/workflows/test.yml` - Configuración CI/CD
- `/scripts/run_tests.sh` - Scripts de testing

---

**Última actualización**: Noviembre 2025
**Versión de MedicApp**: V19+
**Tests totales**: 601+
**Cobertura promedio**: 75-80%
**Archivo de cobertura**: `coverage/lcov.info`
