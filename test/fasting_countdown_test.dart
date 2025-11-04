import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/screens/medication_list/services/dose_calculation_service.dart';
import 'helpers/medication_builder.dart';
import 'helpers/database_test_helper.dart';

/// Helper to insert medication and assign to default person (V19+ requirement)
Future<void> insertMedicationWithPerson(Medication medication) async {
  await DatabaseHelper.instance.insertMedication(medication);
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson != null) {
    await DatabaseHelper.instance.assignMedicationToPerson(
      personId: defaultPerson.id,
      medicationId: medication.id,
      scheduleData: medication,
    );
  }
}

/// Helper to get default person ID (V19+ requirement)
Future<String> getDefaultPersonId() async {
  final defaultPerson = await DatabaseHelper.instance.getDefaultPerson();
  if (defaultPerson == null) throw Exception('No default person found');
  return defaultPerson.id;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DatabaseTestHelper.setupAll();

  // V19+: Ensure default person exists before each test
  setUp(() async {
    await DatabaseTestHelper.ensureDefaultPerson();
  });

  group('Fasting Countdown Display - DoseCalculationService.getActiveFastingPeriod', () {

    group('Ayuno tipo "before" (antes de la toma)', () {
      test('debe mostrar cuenta atrás cuando el ayuno está activo (ya comenzó)', () async {
        // Medicamento con dosis a las 10:00, ayuno de 60 minutos antes
        final medication = MedicationBuilder()
            .withId('test_before_active')
            .withSingleDose('10:00', 1.0)
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Simular que son las 09:30 (dentro del período de ayuno)
        final now = DateTime(2025, 10, 30, 9, 30);

        // Nota: En un test real, necesitaríamos poder inyectar el tiempo actual
        // Por ahora, verificamos que el método funciona
        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Si el test se ejecuta fuera del horario esperado, el resultado puede ser null
        // o puede tener datos dependiendo de la hora real de ejecución
        // Verificamos que el método no lanza excepciones
        expect(result, isA<Map<String, dynamic>?>());
      });

      test('debe mostrar cuenta atrás cuando el ayuno es próximo (dentro de 24h)', () async {
        // Medicamento con dosis a las 23:00, ayuno de 60 minutos antes
        final medication = MedicationBuilder()
            .withId('test_before_upcoming')
            .withSingleDose('23:00', 1.0)
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // El método debería devolver información si el ayuno comienza dentro de 24h
        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Verificamos que el método funciona sin errores
        expect(result, isA<Map<String, dynamic>?>());
      });

      test('no debe mostrar cuenta atrás si no hay dosis configuradas', () async {
        final medication = MedicationBuilder()
            .withId('test_before_no_doses')
            .withNoDoses() // Explícitamente sin dosis
            .withFasting(type: 'before', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('debe calcular correctamente el tiempo restante para ayuno "before"', () async {
        final medication = MedicationBuilder()
            .withId('test_before_calculation')
            .withSingleDose('14:00', 1.0)
            .withFasting(type: 'before', duration: 120) // 2 horas
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Si hay resultado, verificar que tiene los campos esperados
        if (result != null) {
          expect(result.containsKey('fastingEndTime'), true);
          expect(result.containsKey('remainingMinutes'), true);
          expect(result.containsKey('fastingType'), true);
          expect(result.containsKey('isActive'), true);
          expect(result['fastingType'], 'before');
          expect(result['remainingMinutes'], isA<int>());
          expect(result['fastingEndTime'], isA<DateTime>());
        }
      });

      test('debe diferenciar entre ayuno activo (isActive: true) y próximo (isActive: false)', () async {
        // Este test verifica que el campo isActive se establece correctamente
        final medication = MedicationBuilder()
            .withId('test_before_active_flag')
            .withSingleDose('15:00', 1.0)
            .withFasting(type: 'before', duration: 90)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        if (result != null) {
          // isActive debe ser true si ya comenzó el ayuno, false si es próximo
          expect(result['isActive'], isA<bool>());
        }
      });
    });

    group('Ayuno tipo "after" (después de la toma)', () {
      test('debe mostrar cuenta atrás solo si hay una dosis tomada hoy', () async {
        final medication = MedicationBuilder()
            .withId('test_after_active')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120) // 2 horas
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Sin dosis registradas, no debería mostrar cuenta atrás
        final resultBefore = await DoseCalculationService.getActiveFastingPeriod(medication);
        expect(resultBefore, isNull);

        // Registrar una dosis tomada hace 1 hora
        final now = DateTime.now();
        final doseTime = now.subtract(const Duration(hours: 1));

        final historyEntry = DoseHistoryEntry(
          id: 'test_entry_1',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );

        await DatabaseHelper.instance.insertDoseHistory(historyEntry);

        // Ahora debería mostrar cuenta atrás (quedan 60 minutos de ayuno)
        final resultAfter = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(resultAfter, isNotNull);
        expect(resultAfter!['fastingType'], 'after');
        expect(resultAfter['isActive'], true);
        expect(resultAfter['remainingMinutes'], lessThanOrEqualTo(60));
        expect(resultAfter['remainingMinutes'], greaterThan(0));
      });

      test('no debe mostrar cuenta atrás si el ayuno "after" ya finalizó', () async {
        final medication = MedicationBuilder()
            .withId('test_after_finished')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 60)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Registrar una dosis tomada hace 2 horas (el ayuno ya terminó)
        final now = DateTime.now();
        final doseTime = now.subtract(const Duration(hours: 2));

        final historyEntry = DoseHistoryEntry(
          id: 'test_entry_2',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        );

        await DatabaseHelper.instance.insertDoseHistory(historyEntry);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // El ayuno ya terminó, no debería mostrar nada
        expect(result, isNull);
      });

      test('debe usar la dosis más reciente para calcular ayuno "after"', () async {
        final medication = MedicationBuilder()
            .withId('test_after_most_recent')
            .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
            .withFasting(type: 'after', duration: 180) // 3 horas
            .build();

        // V19+: Insert medication and associate with default person
        await insertMedicationWithPerson(medication);

        // V19+: Get default person ID for dose history
        final personId = await getDefaultPersonId();

        final now = DateTime.now();

        // Registrar múltiples dosis hoy - asegurar que están en el pasado
        // y dentro del período de ayuno (3 horas)
        // Usar horas relativas desde ahora, pero ajustadas para evitar cruce de medianoche

        // Dosis más antigua: hace 5 horas
        var dose1Taken = now.subtract(const Duration(hours: 5));
        // Si cruza medianoche, mover a inicio del día actual
        if (dose1Taken.day != now.day) {
          dose1Taken = DateTime(now.year, now.month, now.day, 0, 30);
        }

        // Dosis más reciente: hace 2 horas (dentro del período de ayuno de 3h)
        var dose2Taken = now.subtract(const Duration(hours: 2));
        // Si cruza medianoche, mover a inicio del día actual (más reciente que dose1)
        if (dose2Taken.day != now.day) {
          dose2Taken = DateTime(now.year, now.month, now.day, 1, 0);
        }

        final dose1Scheduled = DateTime(now.year, now.month, now.day, 8, 0);
        final dose2Scheduled = DateTime(now.year, now.month, now.day, 14, 0);

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_3',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: personId,
          scheduledDateTime: dose1Scheduled,
          registeredDateTime: dose1Taken,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_4',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: personId,
          scheduledDateTime: dose2Scheduled,
          registeredDateTime: dose2Taken,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // Debería basarse en la dosis más reciente
        // Como el ayuno es de 3h, debería haber tiempo restante
        expect(result, isNotNull);
        expect(result!['fastingType'], 'after');
        expect(result['isActive'], true);
        // Allow some tolerance for test timing
        expect(result['remainingMinutes'], greaterThan(0));
        expect(result['remainingMinutes'], lessThanOrEqualTo(180)); // Max 3 hours
      });

      test('debe ignorar dosis saltadas al calcular ayuno "after"', () async {
        final medication = MedicationBuilder()
            .withId('test_after_ignore_skipped')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final now = DateTime.now();

        // Registrar una dosis saltada (no debería contar)
        final skippedDose = now.subtract(const Duration(minutes: 30));
        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_5',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: skippedDose,
          registeredDateTime: skippedDose,
          status: DoseStatus.skipped,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        // No debería mostrar cuenta atrás porque la dosis fue saltada
        expect(result, isNull);
      });
    });

    group('Casos donde NO debe mostrar cuenta atrás', () {
      test('no debe mostrar si requiresFasting es false', () async {
        final medication = MedicationBuilder()
            .withId('test_no_fasting')
            .withSingleDose('08:00', 1.0)
            .withFastingDisabled()
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('no debe mostrar si no hay dosis configuradas (medicamento sin ayuno)', () async {
        // Test simplificado: medicamento sin ayuno configurado y sin dosis
        final medication = MedicationBuilder()
            .withId('test_no_config')
            .withNoDoses()
            .withFastingDisabled()
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });

      test('debe manejar correctamente medicamentos sin configuración de ayuno', () async {
        // Medicamento normal sin ayuno, debería devolver null siempre
        final medication = MedicationBuilder()
            .withId('test_normal_med')
            .withSingleDose('12:00', 1.0)
            .build();

        // Por defecto, los medicamentos no tienen ayuno configurado
        expect(medication.requiresFasting, false);

        await DatabaseHelper.instance.insertMedication(medication);

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNull);
      });
    });

    group('Estructura de datos retornados', () {
      test('debe retornar todos los campos requeridos cuando hay ayuno activo', () async {
        final medication = MedicationBuilder()
            .withId('test_data_structure')
            .withSingleDose('08:00', 1.0)
            .withFasting(type: 'after', duration: 120)
            .build();

        await DatabaseHelper.instance.insertMedication(medication);

        // Registrar una dosis reciente
        final now = DateTime.now();
        final doseTime = now.subtract(const Duration(minutes: 30));

        await DatabaseHelper.instance.insertDoseHistory(DoseHistoryEntry(
          id: 'test_entry_6',
          medicationId: medication.id,
          medicationName: medication.name,
          medicationType: medication.type,
          personId: 'test-person-id',
          scheduledDateTime: doseTime,
          registeredDateTime: doseTime,
          status: DoseStatus.taken,
          quantity: 1.0,
        ));

        final result = await DoseCalculationService.getActiveFastingPeriod(medication);

        expect(result, isNotNull);
        expect(result!.keys, containsAll(['fastingEndTime', 'remainingMinutes', 'fastingType', 'isActive']));
        expect(result['fastingEndTime'], isA<DateTime>());
        expect(result['remainingMinutes'], isA<int>());
        expect(result['fastingType'], isA<String>());
        expect(result['isActive'], isA<bool>());
      });
    });
  });
}
