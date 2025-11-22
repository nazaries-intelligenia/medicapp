import 'dart:async';
import 'package:flutter/foundation.dart';
import '../logger_service.dart';
import 'cache_entry.dart';

/// Servicio de caché inteligente con TTL, LRU y gestión automática de memoria
class SmartCacheService<K, V> {
  final Duration defaultTTL;
  final int maxSize;
  final Map<K, CacheEntry<V>> _cache = {};
  Timer? _cleanupTimer;

  /// Estadísticas del caché
  int _hits = 0;
  int _misses = 0;
  int _evictions = 0;

  SmartCacheService({
    this.defaultTTL = const Duration(minutes: 5),
    this.maxSize = 100,
    bool enableAutoCleanup = true,
  }) {
    if (enableAutoCleanup) {
      _startAutoCleanup();
    }
  }

  /// Obtiene un valor del caché
  V? get(K key) {
    final entry = _cache[key];

    if (entry == null) {
      _misses++;
      LoggerService.debug('Cache miss for key: $key');
      return null;
    }

    if (entry.isExpired) {
      _cache.remove(key);
      _misses++;
      LoggerService.debug('Cache expired for key: $key');
      return null;
    }

    entry.markAsAccessed();
    _hits++;
    LoggerService.debug('Cache hit for key: $key');
    return entry.data;
  }

  /// Almacena un valor en el caché
  void put(K key, V value, {Duration? ttl}) {
    // Si el caché está lleno, eliminar la entrada con menor prioridad (LRU)
    if (_cache.length >= maxSize) {
      _evictLeastRecentlyUsed();
    }

    _cache[key] = CacheEntry(
      data: value,
      ttl: ttl ?? defaultTTL,
    );

    LoggerService.debug('Cached value for key: $key');
  }

  /// Obtiene un valor o lo calcula si no existe (cache-aside pattern)
  Future<V> getOrCompute(
    K key,
    Future<V> Function() compute, {
    Duration? ttl,
  }) async {
    final cached = get(key);
    if (cached != null) {
      return cached;
    }

    final value = await compute();
    put(key, value, ttl: ttl);
    return value;
  }

  /// Invalida una entrada específica
  void invalidate(K key) {
    _cache.remove(key);
    LoggerService.debug('Invalidated cache for key: $key');
  }

  /// Invalida múltiples entradas que coincidan con un predicado
  void invalidateWhere(bool Function(K key) predicate) {
    final keysToRemove = _cache.keys.where(predicate).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
    LoggerService.debug('Invalidated ${keysToRemove.length} cache entries');
  }

  /// Limpia todo el caché
  void clear() {
    final size = _cache.length;
    _cache.clear();
    LoggerService.info('Cache cleared: $size entries removed');
  }

  /// Elimina entradas expiradas
  void cleanup() {
    final before = _cache.length;
    _cache.removeWhere((key, entry) => entry.isExpired);
    final removed = before - _cache.length;

    if (removed > 0) {
      LoggerService.debug('Cleanup removed $removed expired entries');
    }
  }

  /// Elimina la entrada con menor prioridad (LRU)
  void _evictLeastRecentlyUsed() {
    if (_cache.isEmpty) return;

    K? keyToEvict;
    double lowestPriority = double.infinity;

    for (final entry in _cache.entries) {
      final priority = entry.value.priority;
      if (priority < lowestPriority) {
        lowestPriority = priority;
        keyToEvict = entry.key;
      }
    }

    if (keyToEvict != null) {
      _cache.remove(keyToEvict);
      _evictions++;
      LoggerService.debug('Evicted LRU entry: $keyToEvict');
    }
  }

  /// Inicia la limpieza automática periódica
  void _startAutoCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      cleanup();
    });
  }

  /// Detiene la limpieza automática
  void stopAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Obtiene estadísticas del caché
  CacheStats get stats => CacheStats(
        size: _cache.length,
        maxSize: maxSize,
        hits: _hits,
        misses: _misses,
        evictions: _evictions,
        hitRate: _hits + _misses > 0 ? _hits / (_hits + _misses) : 0.0,
      );

  /// Resetea las estadísticas
  void resetStats() {
    _hits = 0;
    _misses = 0;
    _evictions = 0;
  }

  /// Libera recursos
  void dispose() {
    stopAutoCleanup();
    clear();
  }
}

/// Estadísticas del caché
@immutable
class CacheStats {
  final int size;
  final int maxSize;
  final int hits;
  final int misses;
  final int evictions;
  final double hitRate;

  const CacheStats({
    required this.size,
    required this.maxSize,
    required this.hits,
    required this.misses,
    required this.evictions,
    required this.hitRate,
  });

  double get utilizationPercentage => (size / maxSize) * 100;

  @override
  String toString() {
    return 'CacheStats(size: $size/$maxSize, hits: $hits, misses: $misses, '
        'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, evictions: $evictions)';
  }
}
