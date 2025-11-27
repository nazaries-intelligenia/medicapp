import 'package:medicapp/database/database_helper.dart';
import 'package:medicapp/models/adherence_analysis.dart';
import 'package:medicapp/models/dose_history_entry.dart';
import 'package:medicapp/models/medication.dart';
import 'package:medicapp/services/logger_service.dart';

/// Servicio de análisis inteligente de adherencia a medicaciones
/// Analiza patrones históricos y genera recomendaciones personalizadas
class IntelligentRemindersService {
  static final IntelligentRemindersService instance = IntelligentRemindersService._();

  IntelligentRemindersService._();

  /// Analiza la adherencia de una medicación durante un período
  Future<AdherenceAnalysis> analyzeAdherence({
    required String medicationId,
    required String medicationName,
    DateTime? startDate,
    DateTime? endDate,
    int? daysPeriod,
  }) async {
    try {
      // Determinar el período de análisis
      final end = endDate ?? DateTime.now();
      final start = startDate ??
          end.subtract(Duration(days: daysPeriod ?? 30));

      LoggerService.debug(
        'Analyzing adherence for $medicationName from $start to $end',
      );

      // Obtener historial de dosis
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: start,
        endDate: end,
        medicationId: medicationId,
      );

      // Obtener información de la medicación
      final medication = await DatabaseHelper.instance.getMedication(medicationId);
      if (medication == null) {
        throw Exception('Medication not found: $medicationId');
      }

      // Calcular métricas generales
      final totalScheduled = _calculateTotalScheduledDoses(medication, start, end);
      final takenDoses = history.where((e) => e.status == DoseStatus.taken).length;
      final skippedDoses = history.where((e) => e.status == DoseStatus.skipped).length;
      final adherenceRate = totalScheduled > 0 ? takenDoses / totalScheduled : 0.0;

      // Análisis temporal
      final adherenceByDayOfWeek = _calculateAdherenceByDayOfWeek(history, medication);
      final adherenceByTimeOfDay = _calculateAdherenceByTimeOfDay(history);

      // Identificar patrones
      final bestTimes = _identifyBestTimes(adherenceByTimeOfDay, limit: 3);
      final worstTimes = _identifyWorstTimes(adherenceByTimeOfDay, limit: 3);
      final problematicDays = _identifyProblematicDays(adherenceByDayOfWeek);

      // Generar recomendaciones
      final recommendations = _generateRecommendations(
        adherenceRate: adherenceRate,
        bestTimes: bestTimes,
        worstTimes: worstTimes,
        problematicDays: problematicDays,
        medication: medication,
      );

      // Calcular tendencia
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

  /// Predice la probabilidad de omitir una dosis específica
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

      // Obtener historial relevante
      final history = await DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: start,
        endDate: end,
        medicationId: medicationId,
      );

      // Filtrar por día de la semana y hora
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
          riskFactors: const ['Datos insuficientes'],
        );
      }

      // Calcular probabilidad de omisión
      final skipped = relevantHistory
          .where((e) => e.status == DoseStatus.skipped)
          .length;
      final skipProbability = skipped / relevantHistory.length;

      // Identificar factores de riesgo
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

  /// Sugiere horarios óptimos para mejorar adherencia
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

      // Para cada horario problemático, sugerir alternativa
      for (final worstTime in analysis.worstTimes) {
        final worstAdherence = analysis.adherenceByTimeOfDay[worstTime] ?? 0.0;

        // Buscar el mejor horario alternativo
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
  // HELPER METHODS - Cálculo de métricas
  // ============================================================================

  /// Calcula el total de dosis programadas en un período
  int _calculateTotalScheduledDoses(
    Medication medication,
    DateTime start,
    DateTime end,
  ) {
    final days = end.difference(start).inDays + 1;
    final dosesPerDay = medication.doseTimes.length;
    return days * dosesPerDay;
  }

  /// Calcula adherencia por día de la semana (1=Lunes, 7=Domingo)
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

  /// Calcula adherencia por hora del día
  Map<String, double> _calculateAdherenceByTimeOfDay(
    List<DoseHistoryEntry> history,
  ) {
    final adherenceByTime = <String, double>{};
    final groupedByTime = <String, List<DoseHistoryEntry>>{};

    // Agrupar por hora
    for (final entry in history) {
      final time = _formatTimeOfDay(entry.scheduledDateTime);
      groupedByTime.putIfAbsent(time, () => []).add(entry);
    }

    // Calcular adherencia por grupo
    for (final entry in groupedByTime.entries) {
      final taken = entry.value.where((e) => e.status == DoseStatus.taken).length;
      adherenceByTime[entry.key] = taken / entry.value.length;
    }

    return adherenceByTime;
  }

  /// Identifica los mejores horarios (mayor adherencia)
  List<String> _identifyBestTimes(
    Map<String, double> adherenceByTime,
    {int limit = 3}
  ) {
    final sorted = adherenceByTime.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(limit)
        .where((e) => e.value >= 0.75) // Solo horarios con buena adherencia
        .map((e) => e.key)
        .toList();
  }

  /// Identifica los peores horarios (menor adherencia)
  List<String> _identifyWorstTimes(
    Map<String, double> adherenceByTime,
    {int limit = 3}
  ) {
    final sorted = adherenceByTime.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return sorted
        .take(limit)
        .where((e) => e.value < 0.50) // Solo horarios problemáticos
        .map((e) => e.key)
        .toList();
  }

  /// Identifica días problemáticos (adherencia < 50%)
  List<int> _identifyProblematicDays(Map<int, double> adherenceByDay) {
    return adherenceByDay.entries
        .where((e) => e.value < 0.50)
        .map((e) => e.key)
        .toList();
  }

  /// Calcula la tendencia de adherencia
  AdherenceTrend _calculateTrend(
    List<DoseHistoryEntry> history,
    int totalScheduled,
  ) {
    if (history.length < 10) {
      return AdherenceTrend.insufficient;
    }

    // Dividir historial en dos mitades
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

  /// Calcula tasa de adherencia de un subconjunto
  double _calculateAdherenceRate(List<DoseHistoryEntry> history) {
    if (history.isEmpty) return 0.0;
    final taken = history.where((e) => e.status == DoseStatus.taken).length;
    return taken / history.length;
  }

  // ============================================================================
  // HELPER METHODS - Generación de recomendaciones
  // ============================================================================

  /// Genera recomendaciones personalizadas
  List<String> _generateRecommendations({
    required double adherenceRate,
    required List<String> bestTimes,
    required List<String> worstTimes,
    required List<int> problematicDays,
    required Medication medication,
  }) {
    final recommendations = <String>[];

    // Recomendación por nivel de adherencia
    if (adherenceRate < 0.50) {
      recommendations.add(
        'Tu adherencia es baja (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Considera configurar recordatorios más frecuentes.',
      );
    } else if (adherenceRate < 0.75) {
      recommendations.add(
        'Tu adherencia es moderada (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Pequeños ajustes pueden mejorarla significativamente.',
      );
    } else if (adherenceRate >= 0.90) {
      recommendations.add(
        '¡Excelente adherencia! (${(adherenceRate * 100).toStringAsFixed(0)}%). '
        'Mantén estos buenos hábitos.',
      );
    }

    // Recomendaciones por horarios problemáticos
    if (worstTimes.isNotEmpty) {
      recommendations.add(
        'Los horarios ${worstTimes.join(", ")} son difíciles para ti. '
        'Considera ajustar estos horarios o usar alarmas adicionales.',
      );
    }

    // Recomendaciones por días problemáticos
    if (problematicDays.isNotEmpty) {
      final dayNames = problematicDays.map(_getDayName).join(', ');
      recommendations.add(
        'Los días $dayNames presentan más omisiones. '
        'Presta especial atención estos días.',
      );
    }

    // Recomendación por horarios exitosos
    if (bestTimes.isNotEmpty && worstTimes.isNotEmpty) {
      recommendations.add(
        'Tienes mejor adherencia en ${bestTimes.first}. '
        'Podrías mover dosis de horarios difíciles a horas similares.',
      );
    }

    return recommendations;
  }

  /// Identifica factores de riesgo para omisión
  List<String> _identifyRiskFactors({
    required double skipProbability,
    required int dayOfWeek,
    required String doseTime,
    required List<DoseHistoryEntry> history,
  }) {
    final riskFactors = <String>[];

    if (skipProbability > 0.50) {
      riskFactors.add('Alta probabilidad histórica de omisión');
    }

    // Analizar si es fin de semana
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      final weekendSkips = history.where((e) =>
        (e.scheduledDateTime.weekday == 6 ||
         e.scheduledDateTime.weekday == 7) &&
        e.status == DoseStatus.skipped
      ).length;

      if (weekendSkips > 2) {
        riskFactors.add('Patrón de omisiones en fines de semana');
      }
    }

    // Analizar horario temprano/tardío
    final hour = int.parse(doseTime.split(':')[0]);
    if (hour < 7) {
      riskFactors.add('Horario muy temprano en la mañana');
    } else if (hour >= 22) {
      riskFactors.add('Horario muy tarde en la noche');
    }

    return riskFactors;
  }

  /// Genera razón para sugerencia de horario
  String _generateTimeSlotReason({
    required String currentTime,
    required double currentAdherence,
    required String suggestedTime,
    required double suggestedAdherence,
  }) {
    final improvement = (suggestedAdherence - currentAdherence) * 100;
    return 'El horario $suggestedTime tiene ${improvement.toStringAsFixed(0)}% '
        'más de adherencia histórica que $currentTime';
  }

  // ============================================================================
  // HELPER METHODS - Utilidades
  // ============================================================================

  /// Formatea hora del día como HH:mm
  String _formatTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Obtiene el nombre del día de la semana
  String _getDayName(int dayOfWeek) {
    const dayNames = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves',
      'Viernes', 'Sábado', 'Domingo'
    ];
    return dayNames[dayOfWeek - 1];
  }
}
