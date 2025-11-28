/// Represents a cache entry with expiration metadata
class CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final Duration ttl;
  int accessCount;
  DateTime lastAccessedAt;

  CacheEntry({
    required this.data,
    required this.ttl,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    this.accessCount = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastAccessedAt = lastAccessedAt ?? DateTime.now();

  /// Checks if the entry has expired
  bool get isExpired {
    final now = DateTime.now();
    return now.difference(createdAt) > ttl;
  }

  /// Updates the last access timestamp
  void markAsAccessed() {
    lastAccessedAt = DateTime.now();
    accessCount++;
  }

  /// Calculates the priority for the LRU algorithm
  /// Higher priority = more likely to remain in cache
  double get priority {
    final timeSinceLastAccess = DateTime.now().difference(lastAccessedAt).inSeconds;
    final accessFrequency = accessCount.toDouble();

    // Formula: more recent accesses = higher priority
    return accessFrequency / (timeSinceLastAccess + 1);
  }
}
