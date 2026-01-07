import 'dart:io';
import 'dart:convert';
import '../models/inventory_item_model.dart';
import '../datasources/inventory_mock_data.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/local/offline_queue_service.dart';
import '../../../../shared/data/local/hive_service.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../../../shared/data/services/media_upload_service.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inventory Repository
/// 
/// Handles all inventory-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class InventoryRepository extends BaseRepository {
  final MediaUploadService? _mediaUploadService;

  InventoryRepository(
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
    MediaUploadService? mediaUploadService,
  }) : _mediaUploadService = mediaUploadService,
       super(apiClient, cache, offlineQueue, useMockData: useMockData);

  /// Get all inventory items - unified pattern
  Future<List<InventoryItemModel>> getInventoryItems({
    String? category,
    bool? isActive,
    int? page,
    int? pageSize,
  }) async {
    final cacheKey = '${StorageKeys.inventoryListCache}_${category ?? 'all'}_${isActive ?? 'all'}';
    
    return await fetchList<InventoryItemModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await apiClient.get(
          '/v1/tech/inventory/items',
          queryParameters: {
            if (category != null) 'category': category,
            if (isActive != null) 'is_active': isActive,
            if (page != null) 'page': page,
            if (pageSize != null) 'page_size': pageSize,
          },
        );
        
        final List<dynamic> data = response.data as List;
        return data.map((json) => InventoryItemModel.fromJson(json)).toList();
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              // Get orgId from action data or use default
              var items = InventoryMockData.getInventoryItems(orgId: 'org-1');
              if (category != null) {
                items = items.where((item) => item.category == category).toList();
              }
              if (isActive != null) {
                items = items.where((item) => item.isActive == isActive).toList();
              }
              return items;
            }
          : null,
    );
  }

  /// Get single inventory item - unified pattern
  Future<InventoryItemModel> getInventoryItem(String id) async {
    return await fetch<InventoryItemModel>(
      cacheKey: 'inventory_item_$id',
      apiCall: () async {
        final response = await apiClient.get('/v1/tech/inventory/items/$id');
        return InventoryItemModel.fromJson(response.data);
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              final items = InventoryMockData.getInventoryItems(orgId: 'org-1');
              return items.firstWhere((item) => item.id == id);
            }
          : null,
    );
  }

  /// Create inventory item (manual entry) - with offline support
  Future<InventoryItemModel> createInventoryItem({
    required String orgId,
    required String name,
    required String unit,
    required double price,
    String? sku,
    String? category,
    String? description,
    File? image,
  }) async {
    // Upload image first if provided
    String? imageUrl;
    String? tempItemId;
    
    if (image != null && _mediaUploadService != null) {
      try {
        // Generate temporary ID for upload path
        tempItemId = generateId();
        imageUrl = await _mediaUploadService!.uploadImage(
          image,
          'inventory/$tempItemId',
          entityId: tempItemId,
          entityType: 'inventory',
        );
      } catch (e) {
        // If upload fails, set pending flag for offline retry
        imageUrl = 'pending_upload';
      }
    }

    final newItem = InventoryItemModel(
      id: tempItemId ?? generateId(),
      orgId: orgId,
      name: name,
      unit: unit,
      price: price,
      sku: sku,
      category: category,
      description: description,
      imageUrl: imageUrl,
      isActive: true,
      isAiDetected: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await mutate<InventoryItemModel>(
      cacheKey: StorageKeys.inventoryListCache,
      apiCall: () async {
        final response = await apiClient.post(
          '/v1/tech/inventory/items',
          data: newItem.toJson(),
        );
        return InventoryItemModel.fromJson(response.data);
      },
      actionType: PendingActionType.addInventory,
      actionData: {
        'org_id': orgId,
        'name': name,
        'unit': unit,
        'price': price,
        if (sku != null) 'sku': sku,
        if (category != null) 'category': category,
        if (description != null) 'description': description,
        if (image != null) 'image_path': image.path,
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => newItem,
    );
  }

  /// Create inventory item via AI auto-detection - with offline support
  Future<InventoryItemModel> createInventoryItemWithAI({
    required String orgId,
    required File image,
  }) async {
    // Upload image first if media service available
    String? imageUrl;
    String? tempItemId;
    
    if (_mediaUploadService != null) {
      try {
        tempItemId = generateId();
        imageUrl = await _mediaUploadService!.uploadImage(
          image,
          'inventory/$tempItemId',
          entityId: tempItemId,
          entityType: 'inventory',
        );
      } catch (e) {
        // If upload fails, set pending flag for offline retry
        imageUrl = 'pending_upload';
      }
    }

    final aiDetection = InventoryMockData.getMockItemDetection();
    
    final newItem = InventoryItemModel(
      id: tempItemId ?? generateId(),
      orgId: orgId,
      name: aiDetection.name,
      unit: aiDetection.unit,
      price: aiDetection.suggestedPrice,
      sku: aiDetection.sku,
      category: aiDetection.category,
      description: aiDetection.description,
      imageUrl: imageUrl ?? 'pending_upload',
      isActive: true,
      isAiDetected: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await mutate<InventoryItemModel>(
      cacheKey: StorageKeys.inventoryListCache,
      apiCall: () async {
        // TODO (Phase 2): Replace with actual API call when backend is ready
        // POST /v1/tech/inventory/items/ai-detect
        // The API should accept imageUrl or image file
        // final response = await apiClient.post('/v1/tech/inventory/items/ai-detect', data: {
        //   'image_url': imageUrl,
        //   'org_id': orgId,
        // });
        // return InventoryItemModel.fromJson(response.data);
        
        // Mock for now
        await Future.delayed(const Duration(seconds: 1));
        return newItem;
      },
      actionType: PendingActionType.addInventory,
      actionData: {
        'org_id': orgId,
        'ai_detection': true,
        'image_path': image.path,
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => newItem,
    );
  }

  /// Get AI price suggestion for an item
  Future<AiPriceSuggestion> getAiPriceSuggestion({
    required File image,
    String? itemName,
  }) async {
    try {
      // TODO (Phase 2): Replace with actual API call when backend is ready
      // POST /v1/tech/inventory/items/:id/ai-price
      // final response = await _apiClient.post('/v1/tech/inventory/items/:id/ai-price', data: formData);
      // return AiPriceSuggestion.fromJson(response.data);

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));
      return InventoryMockData.getMockPriceSuggestion();
    } catch (e) {
      throw Exception('Failed to get AI price suggestion: $e');
    }
  }

  /// Update inventory item - with offline support
  Future<InventoryItemModel> updateInventoryItem({
    required String id,
    required String orgId,
    String? name,
    String? unit,
    double? price,
    String? sku,
    String? category,
    String? description,
    bool? isActive,
  }) async {
    // Get current item for optimistic update
    final current = await getInventoryItem(id);

    return await mutate<InventoryItemModel>(
      cacheKey: 'inventory_item_$id',
      apiCall: () async {
        final response = await apiClient.patch(
          '/v1/tech/inventory/items/$id',
          data: {
            if (name != null) 'name': name,
            if (unit != null) 'unit': unit,
            if (price != null) 'price': price,
            if (sku != null) 'sku': sku,
            if (category != null) 'category': category,
            if (description != null) 'description': description,
            if (isActive != null) 'is_active': isActive,
          },
        );
        return InventoryItemModel.fromJson(response.data);
      },
      actionType: PendingActionType.updateInventory,
      actionData: {
        'id': id,
        'org_id': orgId,
        'name': name,
        'unit': unit,
        'price': price,
        'sku': sku,
        'category': category,
        'description': description,
        'is_active': isActive,
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        name: name ?? current.name,
        unit: unit ?? current.unit,
        price: price ?? current.price,
        sku: sku ?? current.sku,
        category: category ?? current.category,
        description: description ?? current.description,
        isActive: isActive ?? current.isActive,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'inventory_item',
      checkConflict: true,
    );
  }

  /// Delete inventory item - with offline support
  Future<void> deleteInventoryItem(String id) async {
    try {
      await apiClient.delete('/v1/tech/inventory/items/$id');
      // Clear cache
      await clearCache('inventory_item_$id');
      await clearCache(StorageKeys.inventoryListCache);
    } catch (e) {
      // Queue for offline sync if network error
      if (ErrorHandler.isNetworkError(e)) {
        await offlineQueue.addAction(PendingAction(
          id: generateId(),
          type: PendingActionType.deleteInventory,
          data: {'id': id},
          timestamp: DateTime.now(),
        ));
      }
      rethrow;
    }
  }

  /// Search inventory items - unified pattern
  Future<List<InventoryItemModel>> searchInventoryItems(String query) async {
    final cacheKey = '${StorageKeys.inventoryListCache}_search_$query';
    
    return await fetchList<InventoryItemModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await apiClient.get(
          '/v1/tech/inventory/items',
          queryParameters: {'search': query},
        );
        final List<dynamic> data = response.data as List;
        return data.map((json) => InventoryItemModel.fromJson(json)).toList();
      },
      fromJson: (data) => InventoryItemModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              final items = InventoryMockData.getInventoryItems(orgId: 'org-1');
              return items
                  .where((item) =>
                      item.name.toLowerCase().contains(query.toLowerCase()) ||
                      (item.sku?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                      (item.category?.toLowerCase().contains(query.toLowerCase()) ?? false))
                  .toList();
            }
          : null,
      cacheResult: false, // Don't cache search results
    );
  }
}

/// Inventory Repository Provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cache = ref.watch(inventoryCacheProvider);
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  final mediaUploadService = ref.watch(mediaUploadServiceProvider);
  
  return InventoryRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
    mediaUploadService: mediaUploadService,
  );
});

