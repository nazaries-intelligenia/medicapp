# Guía de Testing - MedicApp

## Táboa de Contidos

1. [Visión Xeral do Testing](#visión-xeral-do-testing)
2. [Estrutura de Tests](#estrutura-de-tests)
3. [Tests Unitarios](#tests-unitarios)
4. [Tests de Widgets](#tests-de-widgets)
5. [Tests de Integración](#tests-de-integración)
6. [Helpers de Testing](#helpers-de-testing)
7. [Cobertura de Tests](#cobertura-de-tests)
8. [Casos Edge Cubertos](#casos-edge-cubertos)
9. [Executar Tests](#executar-tests)
10. [Guía para Escribir Tests](#guía-para-escribir-tests)
11. [Testing de Base de Datos](#testing-de-base-de-datos)
12. [CI/CD e Testing Automatizado](#cicd-e-testing-automatizado)
13. [Próximos Pasos](#próximos-pasos)

---

## Visión Xeral do Testing

MedicApp conta cunha suite de tests robusta e ben estruturada que garante a calidade e estabilidade do código:

- **601+ tests automatizados** distribuídos en 57 arquivos
- **75-80% de cobertura de código** en áreas críticas
- **Múltiples tipos de tests**: unitarios, widgets e integración
- **Test-Driven Development (TDD)** para novas funcionalidades
- **Cobertura medible**: Soporte integrado para `flutter test --coverage`

### Filosofía de Testing

A nosa estratexia de testing baséase en:

1. **Tests como documentación**: Os tests documentan o comportamento esperado do sistema
2. **Cobertura intelixente**: Enfoque en áreas críticas (notificacións, xaxún, xestión de doses)
3. **Fast feedback**: Tests rápidos que se executan en memoria
4. **Isolation**: Cada test é independente e non afecta a outros
5. **Realismo**: Tests de integración que simulan fluxos reais de usuario

### Tipos de Tests

```
test/
├── unitarios/          # Tests de servizos, modelos e lóxica de negocio
├── widgets/            # Tests de compoñentes e pantallas individuais
└── integration/        # Tests end-to-end de fluxos completos
```

---

## Estrutura de Tests

O directorio de tests está organizado de forma clara e lóxica:

```
test/
├── helpers/                              # Utilidades compartidas entre tests
│   ├── medication_builder.dart           # Builder pattern para crear medicamentos
│   ├── database_test_helper.dart         # Setup e cleanup de base de datos
│   ├── widget_test_helpers.dart          # Helpers para tests de widgets
│   ├── person_test_helper.dart           # Helpers para xestión de persoas
│   ├── notification_test_helper.dart     # Helpers para tests de notificacións
│   ├── test_constants.dart               # Constantes compartidas
│   └── test_helpers.dart                 # Helpers xerais
│
├── integration/                          # Tests de integración (9 arquivos)
│   ├── add_medication_test.dart          # Fluxo completo de engadir medicamento
│   ├── edit_medication_test.dart         # Fluxo de edición
│   ├── delete_medication_test.dart       # Fluxo de eliminación
│   ├── dose_registration_test.dart       # Rexistro de doses
│   ├── stock_management_test.dart        # Xestión de stock
│   ├── medication_modal_test.dart        # Modal de detalles
│   ├── navigation_test.dart              # Navegación entre pantallas
│   ├── app_startup_test.dart             # Inicio de aplicación
│   └── debug_menu_test.dart              # Menú de depuración
│
└── [41 arquivos de tests unitarios/widgets]
```

### Arquivos de Tests por Categoría

#### Tests de Servizos (13 arquivos)
- `notification_service_test.dart` - Servizo de notificacións
- `dose_action_service_test.dart` - Accións sobre doses
- `dose_history_service_test.dart` - Historial de doses
- `preferences_service_test.dart` - Preferencias de usuario
- E máis...

#### Tests de Funcionalidade Core (18 arquivos)
- `medication_model_test.dart` - Modelo de medicamento
- `dose_management_test.dart` - Xestión de doses
- `extra_dose_test.dart` - Doses extra
- `database_refill_test.dart` - Recargas de stock
- `database_export_import_test.dart` - Exportación/importación
- E máis...

#### Tests de Xaxún (6 arquivos)
- `fasting_test.dart` - Lóxica de xaxún
- `fasting_notification_test.dart` - Notificacións de xaxún
- `fasting_countdown_test.dart` - Conta atrás de xaxún
- `fasting_field_preservation_test.dart` - Preservación de campos
- `early_dose_with_fasting_test.dart` - Dose anticipada con xaxún
- `multiple_fasting_prioritization_test.dart` - Priorización múltiple

#### Tests de Pantallas (14 arquivos)
- `edit_schedule_screen_test.dart` - Pantalla de edición de horarios
- `edit_duration_screen_test.dart` - Pantalla de edición de duración
- `edit_fasting_screen_test.dart` - Pantalla de edición de xaxún
- `edit_screens_validation_test.dart` - Validacións
- `settings_screen_test.dart` - Pantalla de configuración
- `day_navigation_ui_test.dart` - Navegación por días
- E máis...

---

## Tests Unitarios

Os tests unitarios verifican o comportamento de compoñentes individuais de forma illada.

### Tests de Servizos

Verifican a lóxica de negocio dos servizos:

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

  // Non debe lanzar excepcións
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

Verifican a serialización e deserialización de datos:

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
      // ... outros campos
    };

    final medication = Medication.fromJson(json);

    expect(medication.requiresFasting, true);
    expect(medication.fastingType, 'before');
    expect(medication.fastingDurationMinutes, 60);
  });
});
```

### Tests de Utilidades

Verifican funcións auxiliares e cálculos:

```dart
test('should calculate days until stock runs out', () {
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withMultipleDoses(['08:00', '16:00'], 1.0) // 2 doses/día
      .build();

  final days = calculateStockDuration(medication);

  expect(days, 10); // 20 unidades / 2 por día = 10 días
});
```

---

## Tests de Widgets

Os tests de widgets verifican a interface de usuario e a interacción do usuario.

### Tests de Pantallas

Verifican que as pantallas se renderizen correctamente e respondan ás interaccións:

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

### Tests de Compoñentes

Verifican compoñentes individuais da UI:

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

Para tests de widgets, usamos mocks para illar compoñentes:

```dart
setUp(() async {
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Base de datos en memoria
  DatabaseHelper.setInMemoryDatabase(true);

  // Modo de proba para notificacións
  NotificationService.instance.enableTestMode();

  // Asegurar persoa por defecto
  await DatabaseTestHelper.ensureDefaultPerson();
});
```

### Exemplo Completo: Test de Edición

```dart
testWidgets('Should edit medication schedule', (tester) async {
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Engadir medicamento
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

  // Gardar
  await scrollToWidget(tester, find.text('Guardar'));
  await tester.tap(find.text('Guardar'));
  await waitForDatabase(tester);

  // Verificar cambio
  expect(find.text('10:00'), findsOneWidget);
});
```

---

## Tests de Integración

Os tests de integración verifican fluxos completos de usuario end-to-end.

### Tests End-to-End

Simulan o comportamento real do usuario:

```dart
testWidgets('Complete flow: Add medication and register dose',
    (tester) async {
  // 1. Iniciar app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // 2. Engadir medicamento
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

  // 5. Rexistrar dose
  await tester.tap(find.text('Tomar dosis'));
  await waitForComplexAsyncOperation(tester);

  // 6. Verificar stock actualizado
  await tester.tap(find.text('Paracetamol'));
  await tester.pumpAndSettle();

  expect(find.textContaining('19'), findsOneWidget); // Stock - 1
});
```

### Fluxos Completos

Os tests de integración cobren fluxos importantes:

1. **Agregar medicamento**: `add_medication_test.dart`
   - Navegación completa do wizard
   - Configuración de todos os parámetros
   - Verificación en lista principal

2. **Editar medicamento**: `edit_medication_test.dart`
   - Modificación de cada sección
   - Preservación de datos non modificados
   - Actualización correcta en lista

3. **Eliminar medicamento**: `delete_medication_test.dart`
   - Confirmación de eliminación
   - Limpeza de notificacións
   - Eliminación de historial asociado

4. **Rexistrar dose**: `dose_registration_test.dart`
   - Rexistro manual desde modal
   - Actualización de stock
   - Creación de entrada en historial

5. **Xestión de stock**: `stock_management_test.dart`
   - Alertas de stock baixo
   - Recarga de stock
   - Cálculo de duración

### Interacción con Base de Datos

Os tests de integración interactúan cunha base de datos real en memoria:

```dart
testWidgets('Should persist medication after app restart',
    (tester) async {
  // Primeira instancia da app
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  await addMedicationWithDuration(tester, 'Aspirina');
  await waitForDatabase(tester);

  // Simular peche e reapertura
  await DatabaseHelper.instance.close();
  await tester.pumpWidget(const MedicApp());
  await waitForDatabase(tester);

  // Medicamento debe seguir presente
  expect(find.text('Aspirina'), findsOneWidget);
});
```

---

## Helpers de Testing

Os helpers simplifican a escritura de tests e reducen código duplicado.

### MedicationBuilder

O **patrón builder** permite crear medicamentos de proba de forma lexible:

```dart
/// Exemplo básico
final medication = MedicationBuilder()
    .withId('test_1')
    .withName('Aspirina')
    .withStock(20.0)
    .build();

/// Con xaxún
final medication = MedicationBuilder()
    .withName('Ibuprofeno')
    .withFasting(type: 'after', duration: 120)
    .withSingleDose('08:00', 1.0)
    .build();

/// Con múltiples doses
final medication = MedicationBuilder()
    .withName('Antibiótico')
    .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
    .withStock(30.0)
    .build();

/// Como medicamento "a demanda"
final medication = MedicationBuilder()
    .withName('Analxésico')
    .withAsNeeded()
    .withStock(10.0)
    .build();
```

#### Beneficios de MedicationBuilder

1. **Lexibilidade**: O código é autodocumentado e fácil de entender
2. **Mantenibilidade**: Cambios no modelo só requiren actualizar o builder
3. **Redución de código**: Evita repetir valores por defecto en cada test
4. **Flexibilidade**: Permite configurar só o necesario para cada test

#### Factory Methods

O builder inclúe métodos de fábrica para casos comúns:

```dart
// Stock baixo (5 unidades)
final medication = MedicationBuilder()
    .withName('Med')
    .withLowStock()
    .build();

// Sen stock
final medication = MedicationBuilder()
    .withName('Med')
    .withNoStock()
    .build();

// Múltiples doses ao día (automático)
final medication = MedicationBuilder()
    .withName('Med')
    .withMultipleDosesPerDay(3) // 08:00, 12:00, 16:00
    .build();

// Xaxún habilitado con valores por defecto
final medication = MedicationBuilder()
    .withName('Med')
    .withFastingEnabled() // before, 60 min
    .build();
```

#### Constructor from Medication

Permite crear un builder a partir dun medicamento existente:

```dart
final original = await db.getMedication('med-id');

final modified = MedicationBuilder.from(original)
    .withStock(50.0)
    .withName('Nome Modificado')
    .build();
```

### DatabaseTestHelper

Simplifica a configuración e limpeza da base de datos:

```dart
class DatabaseTestHelper {
  /// Configuración inicial (unha vez por arquivo)
  static void setupAll() {
    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      DatabaseHelper.setInMemoryDatabase(true);
    });
  }

  /// Limpeza despois de cada test
  static void setupEach() {
    tearDown(() async {
      await cleanDatabase();
    });
  }

  /// Atalho: setupAll + setupEach
  static void setup() {
    setupAll();
    setupEach();
  }

  /// Asegura que existe persoa por defecto
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
    // O teu test aquí
  });
}
```

### WidgetTestHelpers

Funcións auxiliares para tests de widgets:

```dart
/// Obter localizacións
AppLocalizations getL10n(WidgetTester tester);

/// Esperar operacións de base de datos
Future<void> waitForDatabase(WidgetTester tester);

/// Esperar a que apareza un widget
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
});

/// Facer scroll a un widget
Future<void> scrollToWidget(WidgetTester tester, Finder finder);

/// Abrir menú de edición
Future<void> openEditMenuAndSelectSection(
  WidgetTester tester,
  String medicationName,
  String sectionTitle,
);

/// Engadir medicamento completo
Future<void> addMedicationWithDuration(
  WidgetTester tester,
  String name, {
  String? type,
  String? durationType,
  int dosageIntervalHours = 8,
  String stockQuantity = '0',
});

/// Esperar operacións asíncronas complexas
Future<void> waitForComplexAsyncOperation(
  WidgetTester tester, {
  Duration asyncDelay = const Duration(milliseconds: 1000),
  int pumpCount = 20,
});
```

### Outros Helpers

- **PersonTestHelper**: Xestión de persoas en tests
- **NotificationTestHelper**: Helpers para notificacións
- **TestConstants**: Constantes compartidas (doses, stocks, tempos)

---

## Cobertura de Tests

A suite de tests cobre as áreas máis críticas da aplicación.

### Cobertura por Categoría

| Categoría | Tests | Descrición |
|-----------|-------|------------|
| **Servizos** | ~94 tests | NotificationService, DoseActionService, DoseHistoryService, PreferencesService |
| **Funcionalidade Core** | ~79 tests | Xestión de doses, stock, xaxún, exportación/importación |
| **Xaxún** | ~61 tests | Lóxica de xaxún, notificacións, conta atrás, priorización |
| **Pantallas** | ~93 tests | Tests de widgets e navegación de todas as pantallas |
| **Integración** | ~52 tests | Fluxos completos end-to-end |

**Total: 369+ tests**

### Áreas Ben Cubertas

#### Notificacións (95% cobertura)
- Programación e cancelación de notificacións
- IDs únicos para diferentes tipos de notificacións
- Notificacións para patróns semanais e datas específicas
- Notificacións de xaxún
- Accións rápidas desde notificacións
- Límites de plataforma (500 notificacións)
- Casos edge de medianoite

#### Xaxún (90% cobertura)
- Cálculo de períodos de xaxún (before/after)
- Validacións de duración
- Notificacións de inicio e fin
- Conta atrás visual
- Priorización con múltiples períodos activos
- Doses anticipadas con xaxún
- Preservación de configuración

#### Xestión de Doses (88% cobertura)
- Rexistro de doses (manual e desde notificación)
- Omisión de doses
- Doses extra
- Actualización de stock
- Historial de doses
- Cálculo de consumo diario

#### Base de Datos (85% cobertura)
- CRUD de medicamentos
- CRUD de persoas
- Migración de esquema
- Exportación/importación
- Integridade referencial
- Limpeza en cascada

### Áreas con Menos Cobertura

Algunhas áreas teñen cobertura menor pero non crítica:

- **UI/UX avanzada** (60%): Animacións, transicións
- **Configuración** (65%): Preferencias de usuario
- **Localización** (70%): Traducións e idiomas
- **Permisos** (55%): Solicitude de permisos de sistema

Estas áreas teñen menor cobertura porque:
1. Son difíciles de testear automaticamente
2. Requiren interacción manual
3. Dependen do sistema operativo
4. Non afectan a lóxica de negocio crítica

---

## Casos Edge Cubertos

Os tests inclúen casos especiais que poderían causar erros:

### 1. Notificacións a Medianoite

**Arquivo**: `notification_midnight_edge_cases_test.dart`

```dart
test('dose scheduled at 23:55 but registered at 00:05 counts for previous day',
    () async {
  // Dose programada onte ás 23:55
  final scheduledTime = DateTime(2024, 1, 15, 23, 55);

  // Rexistrada hoxe ás 00:05
  final registeredTime = DateTime(2024, 1, 16, 0, 5);

  // Debe contar como dose do día anterior
  expect(getDoseDate(scheduledTime), '2024-01-15');
});

test('fasting period crossing midnight is handled correctly', () async {
  // Dose ás 22:00 con xaxún "after" de 3 horas
  final medication = MedicationBuilder()
      .withSingleDose('22:00', 1.0)
      .withFasting(type: 'after', duration: 180)
      .build();

  // Xaxún termina á 01:00 do día seguinte
  final endTime = calculateFastingEnd(medication, '22:00');
  expect(endTime.hour, 1);
  expect(endTime.day, DateTime.now().add(Duration(days: 1)).day);
});
```

**Casos cubertos:**
- Doses tardías rexistradas despois de medianoite
- Períodos de xaxún que cruzan medianoite
- Doses programadas exactamente ás 00:00
- Reseteo de contadores diarios
- Notificacións pospostas que cruzan medianoite

### 2. Eliminación e Limpeza

**Arquivo**: `deletion_cleanup_test.dart`

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

  // Non debe haber notificacións programadas
  final pending = await notificationService.getPending();
  expect(pending.where((n) => n.id.contains('med-to-delete')), isEmpty);
});

test('deleting a person deletes all their medications and history', () async {
  final person = await createTestPerson('John');
  final med = await addMedicationForPerson(person.id, 'Aspirin');

  await registerDose(med.id, '08:00');

  // Eliminar persoa
  await db.deletePerson(person.id);

  // Non debe haber medicamentos nin historial
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);

  final history = await db.getDoseHistory(person.id);
  expect(history, isEmpty);
});
```

**Casos cubertos:**
- Cancelación de notificacións ao eliminar medicamento
- Eliminación en cascada de historial
- Limpeza de notificacións ao eliminar persoa
- Non afectar outros medicamentos/persoas
- Integridade referencial

### 3. Priorización de Múltiples Xaxúns

**Arquivo**: `multiple_fasting_prioritization_test.dart`

```dart
test('should keep most restrictive fasting when 2 active for same person',
    () async {
  // Medicamento 1: xaxún "after" de 120 minutos
  final med1 = MedicationBuilder()
      .withId('med-1')
      .withSingleDose('08:00', 1.0)
      .withFasting(type: 'after', duration: 120)
      .build();

  // Medicamento 2: xaxún "after" de 60 minutos
  final med2 = MedicationBuilder()
      .withId('med-2')
      .withSingleDose('08:30', 1.0)
      .withFasting(type: 'after', duration: 60)
      .build();

  // Rexistrar ambas doses
  await registerDose(med1.id, '08:00');
  await registerDose(med2.id, '08:30');

  // Só debe mostrar o xaxún máis restrictivo (med-1 ata 10:00)
  final activeFasting = await fastingManager.getActiveFasting();
  expect(activeFasting.length, 1);
  expect(activeFasting.first.medicationId, 'med-1');
});
```

**Casos cubertos:**
- Múltiples xaxúns activos para unha persoa
- Selección do período máis restrictivo
- Ordenación por tempo de finalización
- Filtrado automático de períodos terminados
- Independencia entre persoas diferentes

### 4. Accións de Notificación

**Arquivo**: `notification_actions_test.dart`

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

  // Pospor
  await handleNotificationAction(
    action: 'snooze_dose',
    medicationId: 'med-1',
    notificationId: notification.id,
  );

  // Verificar nova programación
  final rescheduled = await getNextNotification('med-1');
  expect(rescheduled.time.hour, 8);
  expect(rescheduled.time.minute, 10);
});
```

**Casos cubertos:**
- Rexistro desde notificación
- Omisión desde notificación
- Pospor 10 minutos
- Actualización correcta de stock e historial
- Cancelación de notificación orixinal

### 5. Límites de Notificacións

**Arquivo**: `notification_limits_test.dart`

```dart
test('should handle approaching platform limit (>400 notifications)',
    () async {
  // Crear 100 medicamentos con 4 doses cada un
  for (int i = 0; i < 100; i++) {
    final med = MedicationBuilder()
        .withId('med-$i')
        .withMultipleDoses(['08:00', '12:00', '16:00', '20:00'], 1.0)
        .withWeeklyPattern([1, 2, 3, 4, 5, 6, 7])
        .build();

    await insertMedication(med);
  }

  // Programar notificacións (potencialmente >500)
  await notificationService.scheduleAll();

  // Non debe crashear
  // Debe priorizar notificacións cercanas
  final pending = await notificationService.getPending();
  expect(pending.length, lessThanOrEqualTo(500));
});
```

**Casos cubertos:**
- Manexar máis de 500 notificacións
- Priorizar notificacións cercanas
- Logging de advertencias
- Non crashear a app
- Reprogramación automática

---

## Executar Tests

### Comandos Básicos

```bash
# Executar todos os tests
flutter test

# Test específico
flutter test test/services/notification_service_test.dart

# Tests nun directorio
flutter test test/integration/

# Tests con nome específico
flutter test --name "fasting"

# Tests en modo verbose
flutter test --verbose

# Tests con reporte de tempo
flutter test --reporter expanded
```

### Tests con Cobertura

```bash
# Executar tests con cobertura
flutter test --coverage

# Xerar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir reporte en navegador
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Executar Tests Específicos

```bash
# Só tests de servizos
flutter test test/*_service_test.dart

# Só tests de integración
flutter test test/integration/

# Só tests de xaxún
flutter test test/fasting*.dart

# Excluír tests lentos
flutter test --exclude-tags=slow
```

### Tests en CI/CD

```bash
# Modo CI (sen cor, formato adecuado para logs)
flutter test --machine --coverage

# Con timeout para tests lentos
flutter test --timeout=30s

# Fallo rápido (deter en primeiro erro)
flutter test --fail-fast
```

### Depuración de Tests

```bash
# Executar un só test en modo debug
flutter test --plain-name "specific test name"

# Con breakpoints (VS Code/Android Studio)
# Usar "Debug Test" desde o IDE

# Con prints visibles
flutter test --verbose

# Gardar output a arquivo
flutter test > test_output.txt 2>&1
```

---

## Guía para Escribir Tests

### Estrutura AAA (Arrange-Act-Assert)

Organiza cada test en tres seccións claras:

```dart
test('should register dose and update stock', () async {
  // ARRANGE: Preparar o contorno
  final medication = MedicationBuilder()
      .withStock(20.0)
      .withSingleDose('08:00', 2.0)
      .build();
  await db.insertMedication(medication);

  // ACT: Executar a acción a testear
  await doseService.registerDose(medication.id, '08:00');

  // ASSERT: Verificar o resultado
  final updated = await db.getMedication(medication.id);
  expect(updated.stockQuantity, 18.0);
  expect(updated.takenDosesToday, contains('08:00'));
});
```

### Naming Conventions

Usa nomes descritivos que expliquen o escenario:

```dart
// ✅ BEN: Describe o escenario completo
test('should cancel notifications when medication is deleted', () {});
test('should show error when stock is insufficient', () {});
test('dose registered after midnight counts for previous day', () {});

// ❌ MAL: Nomes vagos ou técnicos
test('test1', () {});
test('notification test', () {});
test('deletion', () {});
```

**Formato recomendado:**
- `should [acción esperada] when [condición]`
- `[acción] [resultado esperado] [contexto opcional]`

### Setup e Teardown

Configura e limpa o contorno de forma consistente:

```dart
void main() {
  // Configuración inicial unha soa vez
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

  // Despois de cada test
  tearDown(() async {
    service.disableTestMode();
    await DatabaseTestHelper.cleanDatabase();
  });

  // Os teus tests aquí
  test('...', () async {
    // Test illado con ambiente limpo
  });
}
```

### Mocking de DatabaseHelper

Para tests unitarios puros, mockea a base de datos:

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

    // Executar acción
    await service.registerDose(medication.id, '08:00');

    // Verificar chamada
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

Aproveita o builder para crear tests lexibles:

```dart
test('should calculate correct stock duration', () {
  // Crear medicamento con builder
  final medication = MedicationBuilder()
      .withName('Paracetamol')
      .withStock(30.0)
      .withMultipleDosesPerDay(3) // 3 doses ao día
      .build();

  final duration = calculateStockDays(medication);

  expect(duration, 10); // 30 / 3 = 10 días
});

test('should alert when stock is low', () {
  final medication = MedicationBuilder()
      .withLowStock() // Factory method para stock baixo
      .withLowStockThreshold(3)
      .build();

  expect(isStockLow(medication), true);
});
```

### Mellores Prácticas

1. **Tests independentes**: Cada test debe poder executarse só
   ```dart
   // ✅ BEN: Test autocontido
   test('...', () async {
     final medication = createTestMedication();
     await db.insert(medication);
     // ... resto do test
   });

   // ❌ MAL: Depende de orde de execución
   late Medication sharedMedication;
   test('create medication', () {
     sharedMedication = createTestMedication();
   });
   test('use medication', () {
     expect(sharedMedication, isNotNull); // Depende do test anterior
   });
   ```

2. **Tests rápidos**: Usa base de datos en memoria, evita delays innecesarios
   ```dart
   // ✅ BEN
   DatabaseHelper.setInMemoryDatabase(true);

   // ❌ MAL
   await Future.delayed(Duration(seconds: 2)); // Delay arbitrario
   ```

3. **Assertions específicas**: Verifica exactamente o que importa
   ```dart
   // ✅ BEN
   expect(medication.stockQuantity, 18.0);
   expect(medication.takenDosesToday, contains('08:00'));

   // ❌ MAL
   expect(medication, isNotNull); // Demasiado vago
   ```

4. **Grupos lóxicos**: Organiza tests relacionados
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

5. **Test edge cases**: Non só o happy path
   ```dart
   group('Stock Management', () {
     test('should register dose with sufficient stock', () {});

     test('should register dose even with 0 stock', () {});

     test('should handle decimal quantities correctly', () {});

     test('should not go below 0 stock', () {});
   });
   ```

6. **Comentarios útiles**: Explica o "por que", non o "que"
   ```dart
   test('should count late dose for previous day', () async {
     // V19+: Doses rexistradas despois de medianoite pero dentro
     // de 2 horas da programación contan para o día anterior
     // Isto prevén que doses tardías dupliquen o conto diario

     final scheduledTime = DateTime(..., 23, 55);
     final registeredTime = DateTime(..., 0, 5);
     // ...
   });
   ```

---

## Testing de Base de Datos

### Uso de sqflite_common_ffi

Os tests usan `sqflite_common_ffi` para base de datos en memoria:

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
    // Base de datos créase automaticamente en memoria
    final db = DatabaseHelper.instance;

    // Operacións normais
    await db.insertMedication(medication);
    final result = await db.getMedication(medication.id);

    expect(result, isNotNull);
  });
}
```

### Base de Datos en Memoria

Vantaxes de usar base de datos en memoria:

1. **Velocidade**: 10-100x máis rápido que disco
2. **Illamento**: Cada test comeza con BD limpa
3. **Sen efectos secundarios**: Non modifica datos reais
4. **Paralelización**: Tests poden correr en paralelo

```dart
setUp(() async {
  // Resetear para BD limpa
  await DatabaseHelper.resetDatabase();

  // Modo en memoria
  DatabaseHelper.setInMemoryDatabase(true);
});
```

### Migracións en Tests

Os tests verifican que as migracións funcionen correctamente:

```dart
test('should migrate from v18 to v19 (persons table)', () async {
  // Crear BD en versión 18
  final db = await openDatabase(
    inMemoryDatabasePath,
    version: 18,
    onCreate: (db, version) async {
      // Schema v18 (sen táboa persons)
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

  // Verificar persoa por defecto
  final hasDefault = await DatabaseHelper.instance.hasDefaultPerson();
  expect(hasDefault, true);
});
```

### Limpeza entre Tests

É crucial limpar a BD entre tests para evitar contaminación:

```dart
tearDown(() async {
  // Método 1: Borrar todos os datos
  await DatabaseHelper.instance.deleteAllMedications();
  await DatabaseHelper.instance.deleteAllDoseHistory();
  await DatabaseHelper.instance.deleteAllPersons();

  // Método 2: Resetear completamente
  await DatabaseHelper.resetDatabase();

  // Método 3: Usar helper
  await DatabaseTestHelper.cleanDatabase();
});
```

### Tests de Integridade Referencial

Verificar que as relacións de BD funcionen correctamente:

```dart
test('deleting person should cascade delete medications', () async {
  final person = Person(id: 'p1', name: 'John');
  await db.insertPerson(person);

  final med = MedicationBuilder()
      .withId('m1')
      .build();
  await db.insertMedicationForPerson(med, person.id);

  // Eliminar persoa
  await db.deletePerson(person.id);

  // Medicamentos deben eliminarse
  final meds = await db.getMedicationsForPerson(person.id);
  expect(meds, isEmpty);
});

test('dose_history references valid medication', () async {
  // Intentar inserir historial para medicamento inexistente
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

## CI/CD e Testing Automatizado

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

Usar `husky` ou scripts Git hooks para executar tests antes de commit:

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

Xerar reportes visuais automaticamente:

```bash
# Xerar reporte
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Badge de cobertura
./scripts/generate_coverage_badge.sh

# Publicar reporte
# (usar GitHub Pages, Codecov, Coveralls, etc.)
```

---

## Próximos Pasos

### Áreas a Mellorar

1. **Tests de UI/UX (60% → 80%)**
   - Máis tests de animacións
   - Tests de xestos e swipes
   - Tests de accesibilidade

2. **Tests de Permisos (55% → 75%)**
   - Mock de permisos do sistema
   - Fluxos de solicitude de permisos
   - Manexo de permisos denegados

3. **Tests de Localización (70% → 90%)**
   - Tests para cada idioma
   - Verificación de traducións completas
   - Tests de formateo de datas/números

4. **Tests de Performance**
   - Benchmarks de operacións críticas
   - Tests de carga (moitos medicamentos)
   - Memory leak detection

### Tests Pendentes

#### Alta Prioridade

- [ ] Tests de backup/restore completo
- [ ] Tests de notificacións en background
- [ ] Tests de widget de home screen
- [ ] Tests de deep links
- [ ] Tests de compartir datos

#### Media Prioridade

- [ ] Tests de todos os idiomas
- [ ] Tests de temas (claro/escuro)
- [ ] Tests de onboarding
- [ ] Tests de migracións entre todas as versións
- [ ] Tests de exportación a CSV/PDF

#### Baixa Prioridade

- [ ] Tests de animacións complexas
- [ ] Tests de xestos avanzados
- [ ] Tests de accesibilidade exhaustivos
- [ ] Tests de rendemento en dispositivos lentos

### Roadmap de Testing

#### Q1 2025
- Alcanzar 80% de cobertura xeral
- Completar tests de permisos
- Engadir tests de performance básicos

#### Q2 2025
- Tests de todos os idiomas
- Tests de backup/restore
- Documentación de testing actualizada

#### Q3 2025
- Tests de accesibilidade completos
- Tests de carga e estrés
- Automatización completa en CI/CD

#### Q4 2025
- 85%+ cobertura xeral
- Suite de tests de performance
- Tests de regresión visual

---

## Recursos Adicionais

### Documentación

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Documentation](https://pub.dev/packages/mockito)

### Ferramentas

- **flutter_test**: Framework de testing de Flutter
- **mockito**: Mocking de dependencias
- **sqflite_common_ffi**: BD en memoria para tests
- **test_coverage**: Análise de cobertura
- **lcov**: Xeración de reportes HTML

### Arquivos Relacionados

- `/test/helpers/` - Todos os helpers de testing
- `/test/integration/` - Tests de integración
- `/.github/workflows/test.yml` - Configuración CI/CD
- `/scripts/run_tests.sh` - Scripts de testing

---

**Última actualización**: Novembro 2025
**Versión de MedicApp**: V19+
**Tests totais**: 369+
**Cobertura promedio**: 75-80%
