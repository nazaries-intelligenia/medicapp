import 'package:flutter/material.dart';
import '../models/medication.dart';

/// Represents a fasting period in a day
class FastingPeriod {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Medication medication;
  final String doseTime; // The dose time that causes this fasting period

  FastingPeriod({
    required this.startTime,
    required this.endTime,
    required this.medication,
    required this.doseTime,
  });

  /// Check if a given time falls within this fasting period
  bool contains(TimeOfDay time) {
    final timeMinutes = time.hour * 60 + time.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    // Handle period that crosses midnight
    if (endMinutes < startMinutes) {
      return timeMinutes >= startMinutes || timeMinutes <= endMinutes;
    }

    return timeMinutes >= startMinutes && timeMinutes <= endMinutes;
  }

  @override
  String toString() {
    return 'FastingPeriod(${_formatTime(startTime)} - ${_formatTime(endTime)}, ${medication.name})';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Information about a fasting conflict
class FastingConflict {
  final TimeOfDay proposedTime;
  final FastingPeriod conflictingPeriod;
  final TimeOfDay? suggestedTime; // Alternative time that avoids the conflict

  FastingConflict({
    required this.proposedTime,
    required this.conflictingPeriod,
    this.suggestedTime,
  });
}

/// Service to detect and resolve conflicts between dose times and fasting periods
class FastingConflictService {
  /// Calculate all fasting periods for a medication for a typical day
  static List<FastingPeriod> calculateFastingPeriods(Medication medication) {
    if (!medication.requiresFasting ||
        medication.fastingDurationMinutes == null ||
        medication.fastingDurationMinutes! <= 0) {
      return [];
    }

    final periods = <FastingPeriod>[];
    final fastingMinutes = medication.fastingDurationMinutes!;

    for (final doseTimeStr in medication.doseTimes) {
      final parts = doseTimeStr.split(':');
      final doseTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );

      TimeOfDay startTime;
      TimeOfDay endTime;

      if (medication.fastingType == 'before') {
        // Fasting BEFORE taking the medication
        // Period: [doseTime - fastingDuration, doseTime]
        startTime = _subtractMinutes(doseTime, fastingMinutes);
        endTime = doseTime;
      } else {
        // Fasting AFTER taking the medication
        // Period: [doseTime, doseTime + fastingDuration]
        startTime = doseTime;
        endTime = _addMinutes(doseTime, fastingMinutes);
      }

      periods.add(
        FastingPeriod(
          startTime: startTime,
          endTime: endTime,
          medication: medication,
          doseTime: doseTimeStr,
        ),
      );
    }

    return periods;
  }

  /// Check if a proposed time conflicts with any fasting periods from other medications
  ///
  /// [proposedTime] - The time to check
  /// [allMedications] - All medications to check against
  /// [excludeMedicationId] - ID of medication to exclude (when editing existing medication)
  /// [personId] - Optional person ID to filter medications
  static FastingConflict? checkConflict({
    required TimeOfDay proposedTime,
    required List<Medication> allMedications,
    String? excludeMedicationId,
  }) {
    // Filter out the medication being edited (if any)
    final otherMedications = allMedications
        .where((m) => m.id != excludeMedicationId)
        .toList();

    // Get all fasting periods from other medications
    for (final medication in otherMedications) {
      final periods = calculateFastingPeriods(medication);

      for (final period in periods) {
        if (period.contains(proposedTime)) {
          // Found a conflict! Try to suggest an alternative time
          final suggestedTime = _findAlternativeTime(
            proposedTime,
            period,
            allMedications,
            excludeMedicationId,
          );

          return FastingConflict(
            proposedTime: proposedTime,
            conflictingPeriod: period,
            suggestedTime: suggestedTime,
          );
        }
      }
    }

    return null; // No conflict
  }

  /// Check multiple proposed times and return conflicts for any that have them
  static Map<String, FastingConflict> checkMultipleConflicts({
    required List<TimeOfDay> proposedTimes,
    required List<Medication> allMedications,
    String? excludeMedicationId,
  }) {
    final conflicts = <String, FastingConflict>{};

    for (final time in proposedTimes) {
      final conflict = checkConflict(
        proposedTime: time,
        allMedications: allMedications,
        excludeMedicationId: excludeMedicationId,
      );

      if (conflict != null) {
        final timeStr = _formatTimeOfDay(time);
        conflicts[timeStr] = conflict;
      }
    }

    return conflicts;
  }

  /// Suggest alternative dose times that avoid fasting conflicts
  ///
  /// [doseCount] - Number of doses per day
  /// [allMedications] - All medications to check against
  /// [excludeMedicationId] - ID of medication to exclude (when editing)
  static List<TimeOfDay> suggestConflictFreeTimes({
    required int doseCount,
    required List<Medication> allMedications,
    String? excludeMedicationId,
  }) {
    // Get all fasting periods from other medications
    final allPeriods = <FastingPeriod>[];
    for (final med in allMedications) {
      if (med.id != excludeMedicationId) {
        allPeriods.addAll(calculateFastingPeriods(med));
      }
    }

    // If no fasting periods, return default times
    if (allPeriods.isEmpty) {
      return _getDefaultTimes(doseCount);
    }

    final suggestedTimes = <TimeOfDay>[];

    // Try to find times that don't conflict
    // Start with standard distribution times and adjust as needed
    final defaultTimes = _getDefaultTimes(doseCount);

    for (final defaultTime in defaultTimes) {
      // Check if this time conflicts with any fasting period
      bool hasConflict = false;
      for (final period in allPeriods) {
        if (period.contains(defaultTime)) {
          hasConflict = true;
          break;
        }
      }

      if (!hasConflict) {
        // No conflict, use this time
        suggestedTimes.add(defaultTime);
      } else {
        // Find an alternative time near this default time
        final alternativeTime = _findNearestAvailableTime(
          defaultTime,
          allPeriods,
        );
        if (alternativeTime != null) {
          suggestedTimes.add(alternativeTime);
        } else {
          // Fallback: use the default time anyway
          // User will be warned about the conflict
          suggestedTimes.add(defaultTime);
        }
      }
    }

    return suggestedTimes;
  }

  // ========== PRIVATE HELPER METHODS ==========

  /// Get default dose times based on count (8AM, 2PM, 8PM pattern)
  static List<TimeOfDay> _getDefaultTimes(int doseCount) {
    if (doseCount == 1) {
      return [const TimeOfDay(hour: 8, minute: 0)];
    } else if (doseCount == 2) {
      return [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ];
    } else if (doseCount == 3) {
      return [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 14, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ];
    } else if (doseCount == 4) {
      return [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 12, minute: 0),
        const TimeOfDay(hour: 16, minute: 0),
        const TimeOfDay(hour: 20, minute: 0),
      ];
    } else {
      // Distribute evenly across waking hours (8 AM to 10 PM)
      const startHour = 8;
      const endHour = 22;
      const totalHours = endHour - startHour;

      final times = <TimeOfDay>[];
      final interval = totalHours / (doseCount - 1);

      for (int i = 0; i < doseCount; i++) {
        final hour = startHour + (interval * i);
        times.add(TimeOfDay(hour: hour.floor(), minute: 0));
      }

      return times;
    }
  }

  /// Find an alternative time that doesn't conflict with a fasting period
  static TimeOfDay? _findAlternativeTime(
    TimeOfDay originalTime,
    FastingPeriod conflictingPeriod,
    List<Medication> allMedications,
    String? excludeMedicationId,
  ) {
    // Try times after the fasting period ends
    final afterFasting = _addMinutes(conflictingPeriod.endTime, 30);
    if (checkConflict(
          proposedTime: afterFasting,
          allMedications: allMedications,
          excludeMedicationId: excludeMedicationId,
        ) ==
        null) {
      return afterFasting;
    }

    // Try times before the fasting period starts
    final beforeFasting = _subtractMinutes(conflictingPeriod.startTime, 30);
    if (checkConflict(
          proposedTime: beforeFasting,
          allMedications: allMedications,
          excludeMedicationId: excludeMedicationId,
        ) ==
        null) {
      return beforeFasting;
    }

    return null; // Couldn't find a good alternative
  }

  /// Find the nearest available time that doesn't conflict with any fasting period
  static TimeOfDay? _findNearestAvailableTime(
    TimeOfDay targetTime,
    List<FastingPeriod> allPeriods,
  ) {
    // Try times in 30-minute increments before and after
    for (int offset = 30; offset <= 180; offset += 30) {
      // Try later
      final laterTime = _addMinutes(targetTime, offset);
      if (!_timeConflictsWithPeriods(laterTime, allPeriods)) {
        return laterTime;
      }

      // Try earlier
      final earlierTime = _subtractMinutes(targetTime, offset);
      if (!_timeConflictsWithPeriods(earlierTime, allPeriods)) {
        return earlierTime;
      }
    }

    return null;
  }

  /// Check if a time conflicts with any of the given periods
  static bool _timeConflictsWithPeriods(
    TimeOfDay time,
    List<FastingPeriod> periods,
  ) {
    for (final period in periods) {
      if (period.contains(time)) {
        return true;
      }
    }
    return false;
  }

  /// Add minutes to a TimeOfDay (handles wrap-around past midnight)
  static TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  /// Subtract minutes from a TimeOfDay (handles wrap-around before midnight)
  static TimeOfDay _subtractMinutes(TimeOfDay time, int minutes) {
    var totalMinutes = time.hour * 60 + time.minute - minutes;
    if (totalMinutes < 0) {
      totalMinutes += 24 * 60; // Add 24 hours worth of minutes
    }
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  /// Format TimeOfDay as "HH:mm" string
  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
