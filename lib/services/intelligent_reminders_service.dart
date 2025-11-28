import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/adherence_analysis.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/services/logger_service.dart';

/// Intelligent medication adherence analysis service
/// Analyzes historical patterns and generates personalized recommendations
class IntelligentRemindersService {
  static final IntelligentRemindersService instance = IntelligentRemindersService._();

  IntelligentRemindersService._();

  /// Analyzes medication adherence during a period
  Future<AdherenceAnalysis> analyzeAdherence({
    required String medicationId,
    required String medicationName,
    DateTime? startDate,
    DateTime? endDate,
    int? daysPeriod,
  }) async {
    try {
      // Determine the analysis period
      final end = endDate ?? DateTime.now();
      final start = startDate ??
          end.subtract(Duration(days: daysPeriod ?? 30));

      LoggerService.debug(
        'Analyzing adherence for $medicationName from $start to $end',
      );

      // Get dose history
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: start,
        endDate: end,
        medicationId: medicationId,
      );

      // Get medication information
      final medication = await DatabaseHelper.instance.getMedication(medicationId);
      if (medication == null) {
        throw Exception('Medication not found: $medicationId');
      }

      // Calculate general metrics
      final totalScheduled = _calculateTotalScheduledDoses(medication, start, end);
      final takenDoses = history.where((e) => e.status == DoseStatus.taken).length;
      final skippedDoses = history.where((e) => e.status == DoseStatus.skipped).length;
      final adherenceRate = totalScheduled > 0 ? takenDoses / totalScheduled : 0.0;

      // Temporal analysis
      final adherenceByDayOfWeek = _calculateAdherenceByDayOfWeek(history, medication);
      final adherenceByTimeOfDay = _calculateAdherenceByTimeOfDay(history);

      // Identify patterns
      final bestTimes = _identifyBestTimes(adherenceByTimeOfDay, limit: 3);
      final worstTimes = _identifyWorstTimes(adherenceByTimeOfDay, limit: 3);
      final problematicDays = _identifyProblematicDays(adherenceByDayOfWeek);

      // Generate recommendations
      final recommendations = _generateRecommendations(
        adherenceRate: adherenceRate,
        bestTimes: bestTimes,
        worstTimes: worstTimes,
        problematicDays: problematicDays,
        medication: medication,
      );

      // Calculate trend
      final trend = _calculateTrend(history, totalScheduled);

      return AdherenceAnalysis(
        medicationId: medicationId,
        medicationName: medicationName,
        totalScheduledDoses: totalScheduled,
        takenDoses: takenDoses,
        skippedDoses: skippedDoses,
        adherenceRate: adherenceRate,
        adherenceByDayOfWeek: adherenceByDayOfWeek,
        adherenceByTimeOfDay: adherenceByTimeOfDay,
        bestTimes: bestTimes,
        worstTimes: worstTimes,
        problematicDays: problematicDays,
        recommendations: recommendations,
        trend: trend,
      );
    } catch (e) {
      LoggerService.error('Error analyzing adherence: $e');
      rethrow;
    }
  }

  /// Predicts the probability of skipping a specific dose
  Future<SkipPrediction> predictSkipProbability({
    required String medicationId,
    required String doseTime,
    required int dayOfWeek,
    DateTime? analysisStartDate,
  }) async {
    try {
      final start = analysisStartDate ??
          DateTime.now().subtract(const Duration(days: 30));
      final end = DateTime.now();

      // Get relevant history
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: start,
        endDate: end,
        medicationId: medicationId,
      );

      // Filter by day of week and time
      final relevantHistory = history.where((entry) {
        final entryDayOfWeek = entry.scheduledDateTime.weekday;
        final entryTime = _formatTimeOfDay(entry.scheduledDateTime);
        return entryDayOfWeek == dayOfWeek && entryTime == doseTime;
      }).toList();

      if (relevantHistory.isEmpty) {
        return SkipPrediction(
          medicationId: medicationId,
          doseTime: doseTime,
          dayOfWeek: dayOfWeek,
          skipProbability: 0.0,
          riskFactors: const ['Insufficient data'],
        );
      }

      // Calculate skip probability
      final skipped = relevantHistory
          .where((e) => e.status == DoseStatus.skipped)
          .length;
      final skipProbability = skipped / relevantHistory.length;

      // Identify risk factors
      final riskFactors = _identifyRiskFactors(
        skipProbability: skipProbability,
        dayOfWeek: dayOfWeek,
        doseTime: doseTime,
        history: history,
      );

      LoggerService.debug(
        'Skip prediction for $doseTime on day $dayOfWeek: ${(skipProbability * 100).toStringAsFixed(1)}%',
      );

      return SkipPrediction(
        medicationId: medicationId,
        doseTime: doseTime,
        dayOfWeek: dayOfWeek,
        skipProbability: skipProbability,
        riskFactors: riskFactors,
      );
    } catch (e) {
      LoggerService.error('Error predicting skip probability: $e');
      rethrow;
    }
  }

  /// Suggests optimal times to improve adherence
  Future<List<TimeSlotSuggestion>> suggestOptimalTimes({
    required Medication medication,
    DateTime? analysisStartDate,
  }) async {
    try {
      final analysis = await analyzeAdherence(
        medicationId: medication.id,
        medicationName: medication.name,
        startDate: analysisStartDate,
      );

      final suggestions = <TimeSlotSuggestion>[];

      // For each problematic time, suggest alternative
      for (final worstTime in analysis.worstTimes) {
        final worstAdherence = analysis.adherenceByTimeOfDay[worstTime] ?? 0.0;

        // Search for the best alternative time
        String? bestAlternative;
        double bestAdherence = 0.0;

        for (final entry in analysis.adherenceByTimeOfDay.entries) {
          if (!medication.doseTimes.contains(entry.key) &&
              entry.value > bestAdherence) {
            bestAdherence = entry.value;
            bestAlternative = entry.key;
          }
        }

        if (bestAlternative != null && bestAdherence > worstAdherence) {
          final improvement = bestAdherence - worstAdherence;
          suggestions.add(TimeSlotSuggestion(
            currentTime: worstTime,
            suggestedTime: bestAlternative,
            improvementPotential: improvement,
            reason: _generateTimeSlotReason(
              currentTime: worstTime,
              currentAdherence: worstAdherence,
              suggestedTime: bestAlternative,
              suggestedAdherence: bestAdherence,
            ),
          ));
        }
      }

      LoggerService.info('Generated ${suggestions.length} time slot suggestions');
      return suggestions;
    } catch (e) {
      LoggerService.error('Error suggesting optimal times: $e');
      return [];
    }
  }

  // ============================================================================
  // HELPER METHODS - Metrics calculation
  // ============================================================================

  /// Calculates the total scheduled doses in a period
  int _calculateTotalScheduledDoses(
    Medication medication,
    DateTime start,
    DateTime end,
  ) {
    final days = end.difference(start).inDays + 1;
    final dosesPerDay = medication.doseTimes.length;
    return days * dosesPerDay;
  }

  /// Calculates adherence by day of week (1=Monday, 7=Sunday)
  Map<int, double> _calculateAdherenceByDayOfWeek(
    List<DoseHistoryEntry> history,
    Medication medication,
  ) {
    final adherenceByDay = <int, double>{};

    for (int day = 1; day <= 7; day++) {
      final dayHistory = history.where(
        (e) => e.scheduledDateTime.weekday == day,
      ).toList();

      if (dayHistory.isEmpty) {
        adherenceByDay[day] = 0.0;
        continue;
      }

      final taken = dayHistory.where((e) => e.status == DoseStatus.taken).length;
      adherenceByDay[day] = taken / dayHistory.length;
    }

    return adherenceByDay;
  }

  /// Calculates adherence by time of day
  Map<String, double> _calculateAdherenceByTimeOfDay(
    List<DoseHistoryEntry> history,
  ) {
    final adherenceByTime = <String, double>{};
    final groupedByTime = <String, List<DoseHistoryEntry>>{};

    // Group by hour
    for (final entry in history) {
      final time = _formatTimeOfDay(entry.scheduledDateTime);
      groupedByTime.putIfAbsent(time, () => []).add(entry);
    }

    // Calculate adherence by group
    for (final entry in groupedByTime.entries) {
      final taken = entry.value.where((e) => e.status == DoseStatus.taken).length;
      adherenceByTime[entry.key] = taken / entry.value.length;
    }

    return adherenceByTime;
  }

  /// Identifies the best times (highest adherence)
  List<String> _identifyBestTimes(
    Map<String, double> adherenceByTime,
    {int limit = 3}
  ) {
    final sorted = adherenceByTime.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(limit)
        .where((e) => e.value >= 0.75) // Only times with good adherence
        .map((e) => e.key)
        .toList();
  }

  /// Identifies the worst times (lowest adherence)
  List<String> _identifyWorstTimes(
    Map<String, double> adherenceByTime,
    {int limit = 3}
  ) {
    final sorted = adherenceByTime.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted
        .take(limit)
        .where((e) => e.value < 0.50) // Only problematic times
        .map((e) => e.key)
        .toList();
  }

  /// Identifies problematic days (adherence < 50%)
  List<int> _identifyProblematicDays(Map<int, double> adherenceByDay) {
    return adherenceByDay.entries
        .where((e) => e.value < 0.50)
        .map((e) => e.key)
        .toList();
  }

  /// Calculates adherence trend
  AdherenceTrend _calculateTrend(
    List<DoseHistoryEntry> history,
    int totalScheduled,
  ) {
    if (history.length < 10) {
      return AdherenceTrend.insufficient;
    }

    // Divide history into two halves
    final midpoint = history.length ~/ 2;
    final firstHalf = history.sublist(0, midpoint);
    final secondHalf = history.sublist(midpoint);

    final firstRate = _calculateAdherenceRate(firstHalf);
    final secondRate = _calculateAdherenceRate(secondHalf);

    final difference = secondRate - firstRate;

    if (difference > 0.10) return AdherenceTrend.improving;
    if (difference < -0.10) return AdherenceTrend.declining;
    return AdherenceTrend.stable;
  }

  /// Calculates adherence rate of a subset
  double _calculateAdherenceRate(List<DoseHistoryEntry> history) {
    if (history.isEmpty) return 0.0;
    final taken = history.where((e) => e.status == DoseStatus.taken).length;
    return taken / history.length;
  }

  // ============================================================================
  // HELPER METHODS - Recommendations generation
  // ============================================================================

  /// Generates personalized recommendations
  List<String> _generateRecommendations({
    required double adherenceRate,
    required List<String> bestTimes,
    required List<String> worstTimes,
    required List<int> problematicDays,
    required Medication medication,
  }) {
    final recommendations = <String>[];

    // Recommendation by adherence level
    if (adherenceRate < 0.50) {
      recommendations.add(
        'Your adherence is low (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Consider setting up more frequent reminders.',
      );
    } else if (adherenceRate < 0.75) {
      recommendations.add(
        'Your adherence is moderate (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Small adjustments can significantly improve it.',
      );
    } else if (adherenceRate >= 0.90) {
      recommendations.add(
        'Excellent adherence! (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Keep up these good habits.',
      );
    }

    // Recommendations for problematic times
    if (worstTimes.isNotEmpty) {
      recommendations.add(
        'The times ${worstTimes.join(", ")} are difficult for you. '
        'Consider adjusting these times or using additional alarms.',
      );
    }

    // Recommendations for problematic days
    if (problematicDays.isNotEmpty) {
      final dayNames = problematicDays.map(_getDayName).join(', ');
      recommendations.add(
        '$dayNames present more skips. '
        'Pay special attention on these days.',
      );
    }

    // Recommendation for successful times
    if (bestTimes.isNotEmpty && worstTimes.isNotEmpty) {
      recommendations.add(
        'You have better adherence at ${bestTimes.first}. '
        'You could move doses from difficult times to similar hours.',
      );
    }

    return recommendations;
  }

  /// Identifies risk factors for skipping
  List<String> _identifyRiskFactors({
    required double skipProbability,
    required int dayOfWeek,
    required String doseTime,
    required List<DoseHistoryEntry> history,
  }) {
    final riskFactors = <String>[];

    if (skipProbability > 0.50) {
      riskFactors.add('High historical probability of skipping');
    }

    // Analyze if it's weekend
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      final weekendSkips = history.where((e) =>
        (e.scheduledDateTime.weekday == 6 ||
         e.scheduledDateTime.weekday == 7) &&
        e.status == DoseStatus.skipped
      ).length;

      if (weekendSkips > 2) {
        riskFactors.add('Pattern of weekend skips');
      }
    }

    // Analyze early/late time
    final hour = int.parse(doseTime.split(':')[0]);
    if (hour < 7) {
      riskFactors.add('Very early morning time');
    } else if (hour >= 22) {
      riskFactors.add('Very late night time');
    }

    return riskFactors;
  }

  /// Generates reason for time slot suggestion
  String _generateTimeSlotReason({
    required String currentTime,
    required double currentAdherence,
    required String suggestedTime,
    required double suggestedAdherence,
  }) {
    final improvement = (suggestedAdherence - currentAdherence) * 100;
    return 'The time $suggestedTime has ${improvement.toStringAsFixed(0)}% '
        'more historical adherence than $currentTime';
  }

  // ============================================================================
  // HELPER METHODS - Utilities
  // ============================================================================

  /// Formats time of day as HH:mm
  String _formatTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Gets the name of the day of the week
  String _getDayName(int dayOfWeek) {
    const dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return dayNames[dayOfWeek - 1];
  }
}
