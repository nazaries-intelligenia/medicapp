import 'package:flutter/foundation.dart';

/// Adherence analysis for a medication
@immutable
class AdherenceAnalysis {
  final String medicationId;
  final String medicationName;

  // General metrics
  final int totalScheduledDoses;
  final int takenDoses;
  final int skippedDoses;
  final double adherenceRate;

  // Temporal analysis
  final Map<int, double> adherenceByDayOfWeek; // 1-7 (Mon-Sun)
  final Map<String, double> adherenceByTimeOfDay; // "08:00" -> 0.85

  // Identified patterns
  final List<String> bestTimes; // Times with better adherence
  final List<String> worstTimes; // Times with worse adherence
  final List<int> problematicDays; // Problematic days of the week

  // Recommendations
  final List<String> recommendations;

  // Trend
  final AdherenceTrend trend;

  const AdherenceAnalysis({
    required this.medicationId,
    required this.medicationName,
    required this.totalScheduledDoses,
    required this.takenDoses,
    required this.skippedDoses,
    required this.adherenceRate,
    required this.adherenceByDayOfWeek,
    required this.adherenceByTimeOfDay,
    required this.bestTimes,
    required this.worstTimes,
    required this.problematicDays,
    required this.recommendations,
    required this.trend,
  });

  /// Classifies adherence into categories
  AdherenceLevel get level {
    if (adherenceRate >= 0.90) return AdherenceLevel.excellent;
    if (adherenceRate >= 0.75) return AdherenceLevel.good;
    if (adherenceRate >= 0.50) return AdherenceLevel.fair;
    return AdherenceLevel.poor;
  }

  /// Checks if adherence is improving
  bool get isImproving => trend == AdherenceTrend.improving;

  /// Checks if urgent attention is required
  bool get needsAttention => adherenceRate < 0.50;
}

/// Adherence level
enum AdherenceLevel {
  excellent, // >= 90%
  good,      // >= 75%
  fair,      // >= 50%
  poor,      // < 50%
}

/// Adherence trend
enum AdherenceTrend {
  improving,   // Improving over time
  stable,      // Maintaining the level
  declining,   // Getting worse
  insufficient, // Not enough data
}

/// Optimal time slot suggestion
@immutable
class TimeSlotSuggestion {
  final String currentTime;
  final String suggestedTime;
  final double improvementPotential; // 0.0 - 1.0
  final String reason;

  const TimeSlotSuggestion({
    required this.currentTime,
    required this.suggestedTime,
    required this.improvementPotential,
    required this.reason,
  });
}

/// Dose skip prediction
@immutable
class SkipPrediction {
  final String medicationId;
  final String doseTime;
  final int dayOfWeek;
  final double skipProbability; // 0.0 - 1.0
  final List<String> riskFactors;

  const SkipPrediction({
    required this.medicationId,
    required this.doseTime,
    required this.dayOfWeek,
    required this.skipProbability,
    required this.riskFactors,
  });

  /// Risk level of skipping
  RiskLevel get riskLevel {
    if (skipProbability >= 0.70) return RiskLevel.high;
    if (skipProbability >= 0.40) return RiskLevel.medium;
    return RiskLevel.low;
  }
}

/// Risk level
enum RiskLevel {
  low,
  medium,
  high,
}
