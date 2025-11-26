import '../../models/medication.dart';
import '../../models/dose_history_entry.dart';
import '../../database/database_helper.dart';
import '../logger_service.dart';
import 'smart_cache_service.dart';

/// Servicio de caché específico para medicaciones
/// Integra SmartCacheService con la lógica de negocio de medicaciones
class MedicationCacheService {
  static final MedicationCacheService instance = MedicationCacheService._();

  MedicationCacheService._();

  // Cachés separados para diferentes tipos de datos
  final SmartCacheService<String, Medication?> _medicationCache =
      SmartCacheService(
    defaultTTL: const Duration(minutes: 10),
    maxSize: 50,
  );

  final SmartCacheService<String, List<Medication>> _medicationListCache =
      SmartCacheService(
    defaultTTL: const Duration(minutes: 5),
    maxSize: 20,
  );

  final SmartCacheService<String, List<DoseHistoryEntry>> _historyCache =
      SmartCacheService(
    defaultTTL: const Duration(minutes: 3),
    maxSize: 30,
  );

  final SmartCacheService<String, Map<String, dynamic>> _statsCache =
      SmartCacheService(
    defaultTTL: const Duration(minutes: 15),
    maxSize: 10,
  );

  // ============================================================================
  // MEDICATION CACHE
  // ============================================================================

  /// Obtiene una medicación del caché o de la BD
  Future<Medication?> getMedication(String medicationId) async {
    return await _medicationCache.getOrCompute(
      medicationId,
      () => DatabaseHelper.instance.getMedication(medicationId),
    );
  }

  /// Obtiene una medicación para una persona del caché o de la BD
  Future<Medication?> getMedicationForPerson(
    String medicationId,
    String personId,
  ) async {
    final cacheKey = '${medicationId}_$personId';
    return await _medicationCache.getOrCompute(
      cacheKey,
      () => DatabaseHelper.instance.getMedicationForPerson(
        medicationId,
        personId,
      ),
    );
  }

  /// Obtiene todas las medicaciones de una persona
  Future<List<Medication>> getMedicationsForPerson(String personId) async {
    return await _medicationListCache.getOrCompute(
      'person_$personId',
      () => DatabaseHelper.instance.getMedicationsForPerson(personId),
    );
  }

  /// Invalida el caché de una medicación específica
  void invalidateMedication(String medicationId) {
    _medicationCache.invalidateWhere((key) => key.startsWith(medicationId));
    LoggerService.debug('Invalidated medication cache: $medicationId');
  }

  /// Invalida el caché de medicaciones de una persona
  void invalidatePersonMedications(String personId) {
    _medicationListCache.invalidate('person_$personId');
    _medicationCache.invalidateWhere((key) => key.endsWith('_$personId'));
    LoggerService.debug('Invalidated person medications cache: $personId');
  }

  /// Invalida todo el caché de medicaciones cuando hay cambios importantes
  void invalidateAllMedications() {
    _medicationCache.clear();
    _medicationListCache.clear();
    LoggerService.info('Cleared all medication caches');
  }

  // ============================================================================
  // HISTORY CACHE
  // ============================================================================

  /// Obtiene el historial de dosis de una medicación
  Future<List<DoseHistoryEntry>> getDoseHistoryForMedication(
    String medicationId,
  ) async {
    return await _historyCache.getOrCompute(
      'med_$medicationId',
      () => DatabaseHelper.instance.getDoseHistoryForMedication(medicationId),
    );
  }

  /// Obtiene el historial de dosis para un rango de fechas
  Future<List<DoseHistoryEntry>> getDoseHistoryForDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String? medicationId,
  }) async {
    final cacheKey = '${startDate.toIso8601String()}_${endDate.toIso8601String()}'
        '${medicationId != null ? "_$medicationId" : ""}';

    return await _historyCache.getOrCompute(
      cacheKey,
      () => DatabaseHelper.instance.getDoseHistoryForDateRange(
        startDate: startDate,
        endDate: endDate,
        medicationId: medicationId,
      ),
    );
  }

  /// Invalida el caché de historial cuando se registra/elimina una dosis
  void invalidateDoseHistory({String? medicationId}) {
    if (medicationId != null) {
      _historyCache.invalidateWhere((key) => key.contains(medicationId));
    } else {
      _historyCache.clear();
    }
    LoggerService.debug('Invalidated dose history cache');
  }

  // ============================================================================
  // STATISTICS CACHE
  // ============================================================================

  /// Obtiene estadísticas de dosis con caché
  Future<Map<String, dynamic>> getDoseStatistics({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
    String? personId,
  }) async {
    final cacheKey = 'stats_${medicationId ?? 'all'}'
        '_${startDate?.toIso8601String() ?? 'all'}'
        '_${endDate?.toIso8601String() ?? 'all'}'
        '_${personId ?? 'all'}';

    return await _statsCache.getOrCompute(
      cacheKey,
      () => DatabaseHelper.instance.getDoseStatistics(
        medicationId: medicationId,
        startDate: startDate,
        endDate: endDate,
        personId: personId,
      ),
      ttl: const Duration(minutes: 30), // Stats can be cached longer
    );
  }

  /// Invalida el caché de estadísticas
  void invalidateStatistics() {
    _statsCache.clear();
    LoggerService.debug('Invalidated statistics cache');
  }

  // ============================================================================
  // CACHE MANAGEMENT
  // ============================================================================

  /// Limpia todo el caché
  void clearAll() {
    _medicationCache.clear();
    _medicationListCache.clear();
    _historyCache.clear();
    _statsCache.clear();
    LoggerService.info('Cleared all caches');
  }

  /// Obtiene estadísticas combinadas de todos los cachés
  Map<String, CacheStats> getAllStats() {
    return {
      'medications': _medicationCache.stats,
      'medication_lists': _medicationListCache.stats,
      'history': _historyCache.stats,
      'statistics': _statsCache.stats,
    };
  }

  /// Libera recursos de todos los cachés
  void dispose() {
    _medicationCache.dispose();
    _medicationListCache.dispose();
    _historyCache.dispose();
    _statsCache.dispose();
  }

  /// Optimiza el caché eliminando entradas expiradas
  void optimize() {
    _medicationCache.cleanup();
    _medicationListCache.cleanup();
    _historyCache.cleanup();
    _statsCache.cleanup();
    LoggerService.debug('Cache optimization completed');
  }
}
