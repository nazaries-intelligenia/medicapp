import '../../models/medication.dart';
import '../../models/dose_history_entry.dart';
import '../../database/database_helper.dart';
import '../logger_service.dart';
import 'smart_cache_service.dart';

/// Medication-specific cache service
/// Integrates SmartCacheService with medication business logic
class MedicationCacheService {
  static final MedicationCacheService instance = MedicationCacheService._();

  MedicationCacheService._();

  // Separate caches for different data types
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

  /// Gets a medication from cache or from the DB
  Future<Medication?> getMedication(String medicationId) async {
    return await _medicationCache.getOrCompute(
      medicationId,
      () => DatabaseHelper.instance.getMedication(medicationId),
    );
  }

  /// Gets a medication for a person from cache or from the DB
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

  /// Gets all medications for a person
  Future<List<Medication>> getMedicationsForPerson(String personId) async {
    return await _medicationListCache.getOrCompute(
      'person_$personId',
      () => DatabaseHelper.instance.getMedicationsForPerson(personId),
    );
  }

  /// Invalidates the cache for a specific medication
  void invalidateMedication(String medicationId) {
    _medicationCache.invalidateWhere((key) => key.startsWith(medicationId));
    LoggerService.debug('Invalidated medication cache: $medicationId');
  }

  /// Invalidates the medications cache for a person
  void invalidatePersonMedications(String personId) {
    _medicationListCache.invalidate('person_$personId');
    _medicationCache.invalidateWhere((key) => key.endsWith('_$personId'));
    LoggerService.debug('Invalidated person medications cache: $personId');
  }

  /// Invalidates all medication caches when there are important changes
  void invalidateAllMedications() {
    _medicationCache.clear();
    _medicationListCache.clear();
    LoggerService.info('Cleared all medication caches');
  }

  // ============================================================================
  // HISTORY CACHE
  // ============================================================================

  /// Gets the dose history for a medication
  Future<List<DoseHistoryEntry>> getDoseHistoryForMedication(
    String medicationId,
  ) async {
    return await _historyCache.getOrCompute(
      'med_$medicationId',
      () => DatabaseHelper.instance.getDoseHistoryForMedication(medicationId),
    );
  }

  /// Gets the dose history for a date range
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

  /// Invalidates the history cache when a dose is registered/deleted
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

  /// Gets dose statistics with caching
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

  /// Invalidates the statistics cache
  void invalidateStatistics() {
    _statsCache.clear();
    LoggerService.debug('Invalidated statistics cache');
  }

  // ============================================================================
  // CACHE MANAGEMENT
  // ============================================================================

  /// Clears all caches
  void clearAll() {
    _medicationCache.clear();
    _medicationListCache.clear();
    _historyCache.clear();
    _statsCache.clear();
    LoggerService.info('Cleared all caches');
  }

  /// Gets combined statistics from all caches
  Map<String, CacheStats> getAllStats() {
    return {
      'medications': _medicationCache.stats,
      'medication_lists': _medicationListCache.stats,
      'history': _historyCache.stats,
      'statistics': _statsCache.stats,
    };
  }

  /// Releases resources from all caches
  void dispose() {
    _medicationCache.dispose();
    _medicationListCache.dispose();
    _historyCache.dispose();
    _statsCache.dispose();
  }

  /// Optimizes the cache by removing expired entries
  void optimize() {
    _medicationCache.cleanup();
    _medicationListCache.cleanup();
    _historyCache.cleanup();
    _statsCache.cleanup();
    LoggerService.debug('Cache optimization completed');
  }
}
