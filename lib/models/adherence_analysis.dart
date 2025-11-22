import 'package:flutter/foundation.dart';

/// Análisis de adherencia para una medicación
@immutable
class AdherenceAnalysis {
  final String medicationId;
  final String medicationName;

  // Métricas generales
  final int totalScheduledDoses;
  final int takenDoses;
  final int skippedDoses;
  final double adherenceRate;

  // Análisis temporal
  final Map<int, double> adherenceByDayOfWeek; // 1-7 (Lun-Dom)
  final Map<String, double> adherenceByTimeOfDay; // "08:00" -> 0.85

  // Patrones identificados
  final List<String> bestTimes; // Horarios con mejor adherencia
  final List<String> worstTimes; // Horarios con peor adherencia
  final List<int> problematicDays; // Días de la semana problemáticos

  // Recomendaciones
  final List<String> recommendations;

  // Tendencia
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

  /// Clasifica la adherencia en categorías
  AdherenceLevel get level {
    if (adherenceRate >= 0.90) return AdherenceLevel.excellent;
    if (adherenceRate >= 0.75) return AdherenceLevel.good;
    if (adherenceRate >= 0.50) return AdherenceLevel.fair;
    return AdherenceLevel.poor;
  }

  /// Verifica si la adherencia está mejorando
  bool get isImproving => trend == AdherenceTrend.improving;

  /// Verifica si requiere atención urgente
  bool get needsAttention => adherenceRate < 0.50;
}

/// Nivel de adherencia
enum AdherenceLevel {
  excellent, // >= 90%
  good,      // >= 75%
  fair,      // >= 50%
  poor,      // < 50%
}

/// Tendencia de adherencia
enum AdherenceTrend {
  improving,   // Mejorando con el tiempo
  stable,      // Manteniendo el nivel
  declining,   // Empeorando
  insufficient, // No hay suficientes datos
}

/// Sugerencia de horario óptimo
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

/// Predicción de omisión de dosis
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

  /// Nivel de riesgo de omisión
  RiskLevel get riskLevel {
    if (skipProbability >= 0.70) return RiskLevel.high;
    if (skipProbability >= 0.40) return RiskLevel.medium;
    return RiskLevel.low;
  }
}

/// Nivel de riesgo
enum RiskLevel {
  low,
  medium,
  high,
}
