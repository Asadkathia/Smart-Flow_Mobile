import 'package:uuid/uuid.dart';
import '../../../core/config/app_config.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/errors/error_handler.dart';
import '../remote/api_client.dart';
import '../local/offline_queue_service.dart';
import '../local/hive_service.dart';
import '../models/conflict_model.dart' as conflict_model;

/// Base Repository Pattern
/// 
/// Provides unified data fetching strategy:
/// 1. Try API first (primary source of truth)
/// 2. Fall back to cache if offline
/// 3. Use mock data only in development mode (controlled by AppConfig)
/// 
/// All repositories should extend this class for consistent behavior.
abstract class BaseRepository {
  final ApiClient _apiClient;
  final CacheService _cache;
  final OfflineQueueService _offlineQueue;
  final bool _useMockData;
  final Uuid _uuid = const Uuid();

  BaseRepository(
    this._apiClient,
    this._cache,
    this._offlineQueue, {
    bool? useMockData,
  }) : _useMockData = useMockData ?? AppConfig.shouldUseMockData;

  // ============ Protected Getters ============
  
  /// Get API client (for subclasses)
  ApiClient get apiClient => _apiClient;
  
  /// Get cache service (for subclasses)
  CacheService get cache => _cache;
  
  /// Get offline queue (for subclasses)
  OfflineQueueService get offlineQueue => _offlineQueue;
  
  /// Check if mock data should be used
  bool get useMockData => _useMockData;
  
  /// Generate unique ID
  String generateId() => _uuid.v4();

  // ============ Fetch Methods ============

  /// Fetch data with unified strategy
  /// 
  /// Priority: API → Cache → Mock (dev only)
  /// 
  /// [cacheKey] - Unique key for caching this data
  /// [apiCall] - Function that makes the API call
  /// [fromJson] - Function to deserialize JSON to model
  /// [mockData] - Optional mock data function (only used in dev mode)
  /// [cacheResult] - Whether to cache successful API responses
  /// [ignoreCache] - Whether to skip cache and force API call
  Future<T> fetch<T>({
    required String cacheKey,
    required Future<T> Function() apiCall,
    required T Function(dynamic) fromJson,
    T? Function()? mockData,
    bool cacheResult = true,
    bool ignoreCache = false,
  }) async {
    // 0. If mock data is enabled, check cache first for optimistic updates
    // Then fall back to mock data if cache is empty
    if (_useMockData && mockData != null) {
      if (!ignoreCache) {
        final cached = await _getCachedData<T>(cacheKey, fromJson);
        if (cached != null) {
          return cached;
        }
      }
      return mockData()!;
    }
    
    // 1. Try API first (unless cache-only mode)
    if (!ignoreCache || AppConfig.enableCache) {
      try {
        final result = await apiCall();
        
        // If result is empty and mock data is available, use mock data instead
        if (_useMockData && mockData != null) {
          if (result is List && result.isEmpty) {
            return mockData()!;
          }
          // For non-list types, check if result is "empty" (null, empty string, etc.)
          if (result == null || (result is String && result.isEmpty)) {
            return mockData()!;
          }
        }
        
        // Cache successful API response
        if (cacheResult && AppConfig.enableCache) {
          await _cacheData(cacheKey, result);
        }
        
        return result;
      } catch (e) {
        // 2. If network error, try cache
        if (ErrorHandler.isNetworkError(e)) {
          final cached = await _getCachedData<T>(
            cacheKey,
            fromJson,
          );
          
          // If cached data is empty and mock data is available, use mock data instead
          if (cached != null) {
            if (cached is List && cached.isEmpty && _useMockData && mockData != null) {
              return mockData()!;
            }
            return cached;
          }
        }
        
        // 3. Use mock data if available (in development mode)
        // This allows mock data to work even if error isn't recognized as network error
        if (_useMockData && mockData != null) {
          return mockData()!;
        }
        
        // Re-throw error if no fallback available
        throw ErrorHandler.handle(e);
      }
    }
    
    // If cache-only mode, try cache first
    final cached = await _getCachedData<T>(cacheKey, fromJson);
    if (cached != null) {
      // If cached data is empty and mock data is available, use mock data instead
      if (cached is List && cached.isEmpty && _useMockData && mockData != null) {
        return mockData()!;
      }
      return cached;
    }
    
    // Fallback to mock if available
    if (_useMockData && mockData != null) {
      return mockData()!;
    }
    
    throw const NetworkException(message: 'No data available');
  }

  /// Fetch list data with unified strategy
  Future<List<T>> fetchList<T>({
    required String cacheKey,
    required Future<List<T>> Function() apiCall,
    required T Function(dynamic) fromJson,
    List<T> Function()? mockData,
    bool cacheResult = true,
    bool ignoreCache = false,
  }) async {
    return fetch<List<T>>(
      cacheKey: cacheKey,
      apiCall: apiCall,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => fromJson(item)).toList();
        }
        throw ApiException.badRequest('Expected list response');
      },
      mockData: mockData,
      cacheResult: cacheResult,
      ignoreCache: ignoreCache,
    );
  }

  // ============ Mutate Methods ============

  /// Mutate data with offline queue support and conflict detection
  /// 
  /// Handles mutations (create/update/delete) with automatic offline queuing
  /// and version-based conflict detection.
  /// 
  /// [cacheKey] - Cache key for the affected resource
  /// [apiCall] - Function that makes the API call
  /// [actionType] - Type of pending action for offline queue
  /// [actionData] - Data to store in offline queue
  /// [fromJson] - Function to deserialize JSON to model
  /// [optimisticUpdate] - Function to return optimistic update (for immediate UI feedback)
  /// [updateCache] - Whether to update cache after successful mutation
  /// [localEntity] - Optional local entity for conflict detection (must have version field)
  /// [entityType] - Entity type name for conflict info (e.g., 'visit', 'quote')
  /// [checkConflict] - Whether to check for conflicts (default: true for updates)
  Future<T> mutate<T>({
    required String cacheKey,
    required Future<T> Function() apiCall,
    required PendingActionType actionType,
    required Map<String, dynamic> actionData,
    required T Function(dynamic) fromJson,
    T? Function()? optimisticUpdate,
    bool updateCache = true,
    T? localEntity,
    String? entityType,
    bool checkConflict = true,
  }) async {
    // Check for conflicts before making API call (if local entity provided)
    if (checkConflict && localEntity != null) {
      final conflictInfo = await _checkConflict<T>(
        localEntity: localEntity,
        cacheKey: cacheKey,
        entityType: entityType ?? 'entity',
        fromJson: fromJson,
      );
      
      if (conflictInfo != null && conflictInfo.hasConflict) {
        // Throw conflict exception - will be handled by repository layer
        throw conflict_model.ConflictException(conflictInfo);
      }
    }

    try {
      final result = await apiCall();
      
      // Update cache with new data
      if (updateCache && AppConfig.enableCache) {
        await _cacheData(cacheKey, result);
      }
      
      return result;
    } catch (e) {
      // Re-throw conflict exceptions as-is
      if (e is conflict_model.ConflictException) {
        rethrow;
      }
      
      // Queue for offline sync if network error
      if (ErrorHandler.isNetworkError(e) && AppConfig.enableOfflineQueue) {
        await _offlineQueue.addAction(PendingAction(
          id: generateId(),
          type: actionType,
          data: actionData,
          timestamp: DateTime.now(),
        ));
        
        // Return optimistic update if available (only for network/offline errors)
        if (optimisticUpdate != null) {
          final optimistic = optimisticUpdate();
          if (optimistic != null) {
            // When using mock data, cache the optimistic update so it persists
            // This ensures UI updates are reflected when providers refresh
            if (_useMockData && updateCache && AppConfig.enableCache) {
              await _cacheData(cacheKey, optimistic);
            }
            return optimistic;
          }
        }
      }
      
      // Re-throw error if not handled by offline queue
      throw ErrorHandler.handle(e);
    }
  }

  /// Check for conflicts by comparing local and cached/server versions
  /// 
  /// Returns ConflictInfo if conflict detected, null otherwise.
  Future<conflict_model.ConflictInfo?> _checkConflict<T>({
    required T localEntity,
    required String cacheKey,
    required String entityType,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      // Extract version from local entity
      final localVersion = _extractVersion(localEntity);
      if (localVersion == null) {
        // No version field, skip conflict check
        return null;
      }

      // Extract entity ID
      final entityId = _extractId(localEntity);
      if (entityId == null) {
        return null;
      }

      // Get cached version (represents last known server state)
      final cached = await _getCachedData<T>(
        cacheKey,
        (data) {
          try {
            return fromJson(data);
          } catch (_) {
            return null as T?;
          }
        },
      );

      if (cached == null) {
        // No cached data, can't check conflict
        return null;
      }

      final cachedVersion = _extractVersion(cached);
      if (cachedVersion == null) {
        return null;
      }

      // Check if versions differ
      if (localVersion != cachedVersion) {
        // Conflict detected - get JSON representations
        final localJson = _toJsonMap(localEntity);
        final cachedJson = _toJsonMap(cached);

        return conflict_model.ConflictInfo(
          entityId: entityId,
          localVersion: localVersion,
          serverVersion: cachedVersion,
          localData: localJson,
          serverData: cachedJson,
          entityType: entityType,
          detectedAt: DateTime.now(),
        );
      }

      return null;
    } catch (e) {
      // Silently fail conflict check - don't block mutation
      return null;
    }
  }

  /// Extract version number from entity
  /// 
  /// Supports entities with a `version` field (int).
  int? _extractVersion<T>(T entity) {
    try {
      final dynamic obj = entity;
      if (obj == null) return null;
      
      // Try to access version field
      if (obj is Map) {
        return obj['version'] as int?;
      }
      
      // Try reflection-style access (for freezed models)
      try {
        final version = (obj as dynamic).version;
        if (version is int) {
          return version;
        }
      } catch (_) {
        // Ignore reflection errors
      }
      
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Extract ID from entity
  String? _extractId<T>(T entity) {
    try {
      final dynamic obj = entity;
      if (obj == null) return null;
      
      // Try to access id field
      if (obj is Map) {
        return obj['id'] as String?;
      }
      
      // Try reflection-style access
      try {
        final id = (obj as dynamic).id;
        if (id is String) {
          return id;
        }
      } catch (_) {
        // Ignore reflection errors
      }
      
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Convert entity to JSON map
  Map<String, dynamic> _toJsonMap<T>(T entity) {
    try {
      final dynamic obj = entity;
      if (obj == null) return {};
      
      if (obj is Map) {
        return Map<String, dynamic>.from(obj);
      }
      
      // Try toJson method
      try {
        final json = (obj as dynamic).toJson();
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
      } catch (_) {
        // Ignore toJson errors
      }
      
      return {};
    } catch (_) {
      return {};
    }
  }

  // ============ Cache Helpers ============

  /// Cache data
  Future<void> _cacheData<T>(String key, T data) async {
    try {
      if (data is List) {
        // Handle list of models
        final jsonList = data.map((item) {
          final dynamic itemObj = item;
          if (itemObj != null && itemObj is! Map) {
            try {
              return (itemObj as dynamic).toJson();
            } catch (_) {
              return item;
            }
          }
          return item;
        }).toList();
        await _cache.cache(key, jsonList, (d) => d as List);
      } else if (data is Map) {
        await _cache.cache(key, data, (d) => d as Map<String, dynamic>);
      } else {
        // Try to call toJson if available
        final dynamic dataObj = data;
        if (dataObj != null && dataObj is! Map) {
          try {
            // For models with toJson, serialize them
            final json = (dataObj as dynamic).toJson();
            await _cache.cache(key, json, (d) => d as Map<String, dynamic>);
          } catch (_) {
            // If toJson fails, try to cache as-is
            await _cache.cache(key, data, (d) => d as Map<String, dynamic>);
          }
        } else {
          await _cache.cache(key, data, (d) => d as Map<String, dynamic>);
        }
      }
    } catch (e) {
      // Silently fail cache operations
      // Log in debug mode if needed
    }
  }

  /// Get cached data
  Future<T?> _getCachedData<T>(
    String key,
    T? Function(dynamic) fromJson,
  ) async {
    try {
      final cached = await _cache.get(
        key,
        (data) => fromJson(data),
        ignoreExpiry: false,
      );
      return cached;
    } catch (e) {
      return null;
    }
  }

  /// Clear cached data
  Future<void> clearCache(String key) async {
    await _cache.remove(key);
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    await _cache.clear();
  }
}

