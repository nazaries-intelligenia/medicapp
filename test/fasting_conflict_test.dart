import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicapp/services/fasting_conflict_service.dart';
import 'helpers/medication_builder.dart';

void main() {
  group('FastingConflictService - Calculate Fasting Periods', () {
    test('should calculate "before" fasting periods correctly', () {
      // Medication with fasting BEFORE taking at 08:00
      // Fasting duration: 2 hours (120 minutes)
      // Expected period: 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 6, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 8, minute: 0));
      expect(periods[0].medication.name, 'Omeprazol');
    });

    test('should calculate "after" fasting periods correctly', () {
      // Medication with fasting AFTER taking at 14:00
      // Fasting duration: 3 hours (180 minutes)
      // Expected period: 14:00 - 17:00
      final medication = MedicationBuilder()
          .withId('med2')
          .withName('Levotiroxina')
          .withSingleDose('14:00', 1.0)
          .withFasting(type: 'after', duration: 180)
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 14, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 17, minute: 0));
    });

    test('should calculate multiple fasting periods for medication with multiple doses', () {
      // Medication with 3 doses and "before" fasting
      final medication = MedicationBuilder()
          .withId('med3')
          .withMultipleDoses(['08:00', '14:00', '20:00'], 1.0)
          .withFasting(type: 'before', duration: 60) // 1 hour
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 3);

      // First dose: 07:00 - 08:00
      expect(periods[0].startTime, const TimeOfDay(hour: 7, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 8, minute: 0));

      // Second dose: 13:00 - 14:00
      expect(periods[1].startTime, const TimeOfDay(hour: 13, minute: 0));
      expect(periods[1].endTime, const TimeOfDay(hour: 14, minute: 0));

      // Third dose: 19:00 - 20:00
      expect(periods[2].startTime, const TimeOfDay(hour: 19, minute: 0));
      expect(periods[2].endTime, const TimeOfDay(hour: 20, minute: 0));
    });

    test('should handle fasting period that crosses midnight (before)', () {
      // Medication taken at 01:00 with 3 hours "before" fasting
      // Expected period: 22:00 (previous day) - 01:00
      final medication = MedicationBuilder()
          .withId('med4')
          .withSingleDose('01:00', 1.0)
          .withFasting(type: 'before', duration: 180) // 3 hours
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 22, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 1, minute: 0));

      // Verify it correctly identifies times in the period
      expect(periods[0].contains(const TimeOfDay(hour: 23, minute: 30)), true);
      expect(periods[0].contains(const TimeOfDay(hour: 0, minute: 30)), true);
      expect(periods[0].contains(const TimeOfDay(hour: 2, minute: 0)), false);
    });

    test('should handle fasting period that crosses midnight (after)', () {
      // Medication taken at 23:00 with 3 hours "after" fasting
      // Expected period: 23:00 - 02:00 (next day)
      final medication = MedicationBuilder()
          .withId('med5')
          .withSingleDose('23:00', 1.0)
          .withFasting(type: 'after', duration: 180) // 3 hours
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 23, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 2, minute: 0));

      // Verify it correctly identifies times in the period
      expect(periods[0].contains(const TimeOfDay(hour: 23, minute: 30)), true);
      expect(periods[0].contains(const TimeOfDay(hour: 0, minute: 30)), true);
      expect(periods[0].contains(const TimeOfDay(hour: 1, minute: 30)), true);
      expect(periods[0].contains(const TimeOfDay(hour: 3, minute: 0)), false);
    });

    test('should return empty list when medication does not require fasting', () {
      final medication = MedicationBuilder()
          .withId('med6')
          .withSingleDose('08:00', 1.0)
          .withFastingDisabled()
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.isEmpty, true);
    });

    test('should return empty list when fasting duration is zero', () {
      final medication = MedicationBuilder()
          .withId('med7')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 0)
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.isEmpty, true);
    });
  });

  group('FastingConflictService - Check Conflicts', () {
    test('should detect conflict with "before" fasting period', () {
      // Medication with fasting 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120) // 2 hours
          .build();

      // Check if 07:00 conflicts (it should)
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 7, minute: 0),
        allMedications: [medication],
      );

      expect(conflict, isNotNull);
      expect(conflict!.conflictingPeriod.medication.name, 'Omeprazol');
      expect(conflict.proposedTime, const TimeOfDay(hour: 7, minute: 0));
    });

    test('should detect conflict with "after" fasting period', () {
      // Medication with fasting 14:00 - 17:00
      final medication = MedicationBuilder()
          .withId('med2')
          .withName('Levotiroxina')
          .withSingleDose('14:00', 1.0)
          .withFasting(type: 'after', duration: 180) // 3 hours
          .build();

      // Check if 15:30 conflicts (it should)
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 15, minute: 30),
        allMedications: [medication],
      );

      expect(conflict, isNotNull);
      expect(conflict!.conflictingPeriod.medication.name, 'Levotiroxina');
    });

    test('should NOT detect conflict when time is outside fasting period', () {
      // Medication with fasting 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      // Check if 10:00 conflicts (it should NOT)
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 10, minute: 0),
        allMedications: [medication],
      );

      expect(conflict, isNull);
    });

    test('should exclude specified medication from conflict check', () {
      // Medication with fasting 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      // Check conflict but exclude this medication
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 7, minute: 0),
        allMedications: [medication],
        excludeMedicationId: 'med1',
      );

      expect(conflict, isNull);
    });

    test('should detect conflict with midnight-crossing period', () {
      // Medication taken at 23:00 with 3 hours "after" fasting (23:00 - 02:00)
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('23:00', 1.0)
          .withFasting(type: 'after', duration: 180)
          .build();

      // Check times in the midnight-crossing period
      final conflict1 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 23, minute: 30),
        allMedications: [medication],
      );
      expect(conflict1, isNotNull);

      final conflict2 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 0, minute: 30),
        allMedications: [medication],
      );
      expect(conflict2, isNotNull);

      final conflict3 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 1, minute: 30),
        allMedications: [medication],
      );
      expect(conflict3, isNotNull);

      // Time outside period should not conflict
      final conflict4 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 3, minute: 0),
        allMedications: [medication],
      );
      expect(conflict4, isNull);
    });

    test('should detect conflicts with multiple medications', () {
      // Medication 1: fasting 06:00 - 08:00
      final med1 = MedicationBuilder()
          .withId('med1')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      // Medication 2: fasting 14:00 - 17:00
      final med2 = MedicationBuilder()
          .withId('med2')
          .withName('Levotiroxina')
          .withSingleDose('14:00', 1.0)
          .withFasting(type: 'after', duration: 180)
          .build();

      // Check 07:00 - should conflict with med1
      final conflict1 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 7, minute: 0),
        allMedications: [med1, med2],
      );
      expect(conflict1, isNotNull);
      expect(conflict1!.conflictingPeriod.medication.name, 'Omeprazol');

      // Check 15:00 - should conflict with med2
      final conflict2 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 15, minute: 0),
        allMedications: [med1, med2],
      );
      expect(conflict2, isNotNull);
      expect(conflict2!.conflictingPeriod.medication.name, 'Levotiroxina');

      // Check 10:00 - should not conflict
      final conflict3 = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 10, minute: 0),
        allMedications: [med1, med2],
      );
      expect(conflict3, isNull);
    });

    test('should provide suggested alternative time when conflict detected', () {
      // Medication with fasting 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      // Check if 07:00 conflicts and get suggestion
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 7, minute: 0),
        allMedications: [medication],
      );

      expect(conflict, isNotNull);
      expect(conflict!.suggestedTime, isNotNull);

      // Suggested time should be after the fasting period ends (after 08:00)
      final suggestedMinutes = conflict.suggestedTime!.hour * 60 +
                               conflict.suggestedTime!.minute;
      expect(suggestedMinutes, greaterThan(8 * 60)); // After 08:00
    });
  });

  group('FastingConflictService - Check Multiple Conflicts', () {
    test('should check multiple times and return conflicts map', () {
      // Medication with fasting 06:00 - 08:00
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      final conflicts = FastingConflictService.checkMultipleConflicts(
        proposedTimes: [
          const TimeOfDay(hour: 7, minute: 0),   // Should conflict
          const TimeOfDay(hour: 10, minute: 0),  // Should NOT conflict
          const TimeOfDay(hour: 6, minute: 30),  // Should conflict
        ],
        allMedications: [medication],
      );

      expect(conflicts.length, 2);
      expect(conflicts.containsKey('07:00'), true);
      expect(conflicts.containsKey('06:30'), true);
      expect(conflicts.containsKey('10:00'), false);
    });
  });

  group('FastingConflictService - Suggest Conflict-Free Times', () {
    test('should suggest default times when no medications have fasting', () {
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFastingDisabled()
          .build();

      final suggestedTimes = FastingConflictService.suggestConflictFreeTimes(
        doseCount: 3,
        allMedications: [medication],
      );

      expect(suggestedTimes.length, 3);
      // Default for 3 doses: 08:00, 14:00, 20:00
      expect(suggestedTimes[0], const TimeOfDay(hour: 8, minute: 0));
      expect(suggestedTimes[1], const TimeOfDay(hour: 14, minute: 0));
      expect(suggestedTimes[2], const TimeOfDay(hour: 20, minute: 0));
    });

    test('should adjust times to avoid fasting periods', () {
      // Medication with fasting 08:00 - 10:00 (after)
      final medication = MedicationBuilder()
          .withId('med1')
          .withName('Omeprazol')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      final suggestedTimes = FastingConflictService.suggestConflictFreeTimes(
        doseCount: 3,
        allMedications: [medication],
        excludeMedicationId: 'new_med',
      );

      expect(suggestedTimes.length, 3);

      // First dose should be adjusted to avoid 08:00-10:00 period
      // Should be either before 08:00 or after 10:00
      final firstDoseMinutes = suggestedTimes[0].hour * 60 + suggestedTimes[0].minute;
      const conflictStart = 8 * 60;
      const conflictEnd = 10 * 60;

      final isBeforeConflict = firstDoseMinutes < conflictStart;
      final isAfterConflict = firstDoseMinutes > conflictEnd;

      expect(isBeforeConflict || isAfterConflict, true,
        reason: 'First dose should avoid 08:00-10:00 period');
    });

    test('should handle multiple fasting periods', () {
      // Medication 1: fasting 06:00 - 08:00 (before)
      final med1 = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      // Medication 2: fasting 13:00 - 15:00 (after)
      final med2 = MedicationBuilder()
          .withId('med2')
          .withSingleDose('13:00', 1.0)
          .withFasting(type: 'after', duration: 120)
          .build();

      final suggestedTimes = FastingConflictService.suggestConflictFreeTimes(
        doseCount: 3,
        allMedications: [med1, med2],
      );

      expect(suggestedTimes.length, 3);

      // Verify all suggested times avoid both fasting periods
      for (final time in suggestedTimes) {
        final timeMinutes = time.hour * 60 + time.minute;

        // Should not be in 06:00 - 08:00
        final inPeriod1 = timeMinutes >= 6 * 60 && timeMinutes <= 8 * 60;

        // Should not be in 13:00 - 15:00
        final inPeriod2 = timeMinutes >= 13 * 60 && timeMinutes <= 15 * 60;

        expect(inPeriod1, false,
          reason: 'Time $time should avoid 06:00-08:00 period');
        expect(inPeriod2, false,
          reason: 'Time $time should avoid 13:00-15:00 period');
      }
    });

    test('should return appropriate times for different dose counts', () {
      // Test with 1, 2, 3, and 4 doses
      for (final doseCount in [1, 2, 3, 4]) {
        final suggestedTimes = FastingConflictService.suggestConflictFreeTimes(
          doseCount: doseCount,
          allMedications: [],
        );

        expect(suggestedTimes.length, doseCount,
          reason: 'Should return exactly $doseCount times');
      }
    });
  });

  group('FastingConflictService - Edge Cases', () {
    test('should handle medication with no dose times', () {
      final medication = MedicationBuilder()
          .withId('med1')
          .withDoseSchedule({}) // No doses
          .withFasting(type: 'before', duration: 120)
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);
      expect(periods.isEmpty, true);
    });

    test('should handle very short fasting duration (30 minutes)', () {
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 30)
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 7, minute: 30));
      expect(periods[0].endTime, const TimeOfDay(hour: 8, minute: 0));
    });

    test('should handle very long fasting duration (8 hours)', () {
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('12:00', 1.0)
          .withFasting(type: 'after', duration: 480) // 8 hours
          .build();

      final periods = FastingConflictService.calculateFastingPeriods(medication);

      expect(periods.length, 1);
      expect(periods[0].startTime, const TimeOfDay(hour: 12, minute: 0));
      expect(periods[0].endTime, const TimeOfDay(hour: 20, minute: 0));
    });

    test('should handle empty medications list', () {
      final conflict = FastingConflictService.checkConflict(
        proposedTime: const TimeOfDay(hour: 10, minute: 0),
        allMedications: [],
      );

      expect(conflict, isNull);
    });

    test('should handle suggesting times when all medication IDs should be excluded', () {
      final medication = MedicationBuilder()
          .withId('med1')
          .withSingleDose('08:00', 1.0)
          .withFasting(type: 'before', duration: 120)
          .build();

      final suggestedTimes = FastingConflictService.suggestConflictFreeTimes(
        doseCount: 3,
        allMedications: [medication],
        excludeMedicationId: 'med1', // Exclude the only medication
      );

      // Should return default times since all medications are excluded
      expect(suggestedTimes.length, 3);
      expect(suggestedTimes[0], const TimeOfDay(hour: 8, minute: 0));
    });
  });
}
