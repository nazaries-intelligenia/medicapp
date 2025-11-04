/// Manages caching for medication-related data in the medication list screen.
///
/// This class handles:
/// - Daily dose information for "as needed" medications
/// - Actual dose times when doses were taken
/// - Cache invalidation and updates
class MedicationCacheManager {
  // Cache for "as needed" medication doses taken today
  // Key: medication ID, Value: map with dosesCount, totalQuantity, etc.
  final Map<String, Map<String, dynamic>> _asNeededDosesInfo = {};

  // Cache for actual dose times (scheduled time -> actual time)
  // Key: medication ID, Value: map of scheduled time -> actual DateTime
  final Map<String, Map<String, DateTime>> _actualDoseTimes = {};

  /// Get "as needed" doses info for a specific medication
  Map<String, dynamic>? getAsNeededDosesInfo(String medicationId) {
    return _asNeededDosesInfo[medicationId];
  }

  /// Set "as needed" doses info for a specific medication
  void setAsNeededDosesInfo(String medicationId, Map<String, dynamic> info) {
    _asNeededDosesInfo[medicationId] = info;
  }

  /// Get actual dose times for a specific medication
  Map<String, DateTime>? getActualDoseTimes(String medicationId) {
    return _actualDoseTimes[medicationId];
  }

  /// Set actual dose times for a specific medication
  void setActualDoseTimes(String medicationId, Map<String, DateTime> times) {
    _actualDoseTimes[medicationId] = times;
  }

  /// Check if cache contains "as needed" info for a medication
  bool hasAsNeededInfo(String medicationId) {
    return _asNeededDosesInfo.containsKey(medicationId);
  }

  /// Check if cache contains actual dose times for a medication
  bool hasActualDoseTimes(String medicationId) {
    return _actualDoseTimes.containsKey(medicationId);
  }

  /// Clear all "as needed" doses info
  void clearAsNeededDosesInfo() {
    _asNeededDosesInfo.clear();
  }

  /// Clear all actual dose times
  void clearActualDoseTimes() {
    _actualDoseTimes.clear();
  }

  /// Clear all caches
  void clearAll() {
    _asNeededDosesInfo.clear();
    _actualDoseTimes.clear();
  }

  /// Remove cache for a specific medication
  void removeForMedication(String medicationId) {
    _asNeededDosesInfo.remove(medicationId);
    _actualDoseTimes.remove(medicationId);
  }
}
