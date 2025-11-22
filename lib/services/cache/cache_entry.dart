/// Representa una entrada en el caché con metadata de expiración
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

  /// Verifica si la entrada ha expirado
  bool get isExpired {
    final now = DateTime.now();
    return now.difference(createdAt) > ttl;
  }

  /// Actualiza el timestamp de último acceso
  void markAsAccessed() {
    lastAccessedAt = DateTime.now();
    accessCount++;
  }

  /// Calcula la prioridad para el algoritmo LRU
  /// Mayor prioridad = más probable que se mantenga en caché
  double get priority {
    final timeSinceLastAccess = DateTime.now().difference(lastAccessedAt).inSeconds;
    final accessFrequency = accessCount.toDouble();

    // Fórmula: más accesos recientes = mayor prioridad
    return accessFrequency / (timeSinceLastAccess + 1);
  }
}
