import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/constants/app_constants.dart';

/// Hive Service for SmartFlowPro
/// 
/// Manages local data caching using Hive.
/// Provides methods for storing and retrieving cached data.
class HiveService {
  /// Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters here when models are created
    // Example: Hive.registerAdapter(VisitModelAdapter());
  }

  /// Open a box for a specific data type
  Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return Hive.openBox<T>(name);
  }

  /// Open a lazy box (loads data on demand)
  Future<LazyBox<T>> openLazyBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.lazyBox<T>(name);
    }
    return Hive.openLazyBox<T>(name);
  }

  /// Close a specific box
  Future<void> closeBox(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box(name).close();
    }
  }

  /// Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  /// Delete a box
  Future<void> deleteBox(String name) async {
    await Hive.deleteBoxFromDisk(name);
  }

  /// Clear all Hive data
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await initialize();
  }
}

/// Cache Entry with expiry
class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;
  final Duration expiry;

  CacheEntry({
    required this.data,
    required this.cachedAt,
    this.expiry = AppConstants.cacheExpiry,
  });

  /// Check if cache has expired
  bool get isExpired => DateTime.now().difference(cachedAt) > expiry;

  /// Check if cache is still valid
  bool get isValid => !isExpired;

  /// Convert to JSON for storage
  Map<String, dynamic> toJson(dynamic Function(T) dataToJson) => {
    'data': dataToJson(data),
    'cachedAt': cachedAt.toIso8601String(),
    'expirySeconds': expiry.inSeconds,
  };

  /// Create from JSON
  factory CacheEntry.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataFromJson,
  ) {
    return CacheEntry(
      data: dataFromJson(json['data']),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      expiry: Duration(seconds: json['expirySeconds'] as int),
    );
  }
}

/// Generic Cache Service
class CacheService<T> {
  final String boxName;
  Box<Map>? _box;

  CacheService(this.boxName);

  /// Initialize the cache box
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<Map>(boxName);
  }

  /// Ensure box is initialized
  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await initialize();
    }
  }

  /// Cache data with a key
  Future<void> cache(
    String key,
    T data,
    dynamic Function(T) toJson, {
    Duration? expiry,
  }) async {
    await _ensureInitialized();
    
    final entry = CacheEntry(
      data: data,
      cachedAt: DateTime.now(),
      expiry: expiry ?? AppConstants.cacheExpiry,
    );
    
    await _box?.put(key, entry.toJson(toJson));
  }

  /// Get cached data
  Future<T?> get(
    String key,
    T Function(dynamic) fromJson, {
    bool ignoreExpiry = false,
  }) async {
    await _ensureInitialized();
    
    final json = _box?.get(key);
    if (json == null) return null;
    
    try {
      final entry = CacheEntry<T>.fromJson(
        Map<String, dynamic>.from(json),
        fromJson,
      );
      
      if (!ignoreExpiry && entry.isExpired) {
        await remove(key);
        return null;
      }
      
      return entry.data;
    } catch (e) {
      // Invalid cache data
      await remove(key);
      return null;
    }
  }

  /// Check if cache exists and is valid
  Future<bool> has(String key) async {
    await _ensureInitialized();
    
    final json = _box?.get(key);
    if (json == null) return false;
    
    try {
      final cachedAt = DateTime.parse(json['cachedAt'] as String);
      final expirySeconds = json['expirySeconds'] as int;
      final expiry = Duration(seconds: expirySeconds);
      
      return DateTime.now().difference(cachedAt) <= expiry;
    } catch (e) {
      return false;
    }
  }

  /// Remove cached data
  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _box?.delete(key);
  }

  /// Clear all cached data
  Future<void> clear() async {
    await _ensureInitialized();
    await _box?.clear();
  }

  /// Close the cache box
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}

/// Hive Service Provider
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Visits Cache Provider
final visitsCacheProvider = Provider<CacheService>((ref) {
  final cache = CacheService(StorageKeys.visitsBox);
  ref.onDispose(() => cache.close());
  return cache;
});

/// Quotes Cache Provider
final quotesCacheProvider = Provider<CacheService>((ref) {
  final cache = CacheService(StorageKeys.quotesBox);
  ref.onDispose(() => cache.close());
  return cache;
});

/// Inventory Cache Provider
final inventoryCacheProvider = Provider<CacheService>((ref) {
  final cache = CacheService(StorageKeys.inventoryBox);
  ref.onDispose(() => cache.close());
  return cache;
});

/// Invoices Cache Provider
final invoicesCacheProvider = Provider<CacheService>((ref) {
  final cache = CacheService(StorageKeys.invoicesBox);
  ref.onDispose(() => cache.close());
  return cache;
});

/// Chat Cache Provider
final chatCacheProvider = Provider<CacheService>((ref) {
  final cache = CacheService(StorageKeys.chatBox);
  ref.onDispose(() => cache.close());
  return cache;
});

