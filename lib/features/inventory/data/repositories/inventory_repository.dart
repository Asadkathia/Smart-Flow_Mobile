import 'dart:io';
import 'dart:convert';
import '../models/inventory_item_model.dart';
import '../datasources/inventory_mock_data.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/shared/data/services/media_upload_service.dart';
import 'package:smartflowpro/shared/data/services/inventory_upload_service.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/config/app_config.dart';
import 'package:smartflowpro/core/config/supabase_config.dart';
import 'package:smartflowpro/core/errors/error_handler.dart';
import 'package:smartflowpro/core/services/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inventory Repository
///
/// Handles all inventory-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class InventoryRepository extends BaseRepository {
  final InventoryUploadService? _inventoryUploadService;

  InventoryRepository(
    super.apiClient,
    super.cache,
    super.offlineQueue, {
    super.useMockData,
    MediaUploadService? mediaUploadService,
    InventoryUploadService? inventoryUploadService,
  }) : _inventoryUploadService = inventoryUploadService;

  /// Get all inventory items - unified pattern
  Future<List<InventoryItemModel>> getInventoryItems({
    String? category,
    bool? isActive,
    int? page,
    int? pageSize,
  }) async {
    final cacheKey =
        '${StorageKeys.inventoryListCache}_${category ?? 'all'}_${isActive ?? 'all'}';

    return await fetchList<InventoryItemModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Use REST API directly for better performance (RLS handles security)
        final url = '${ApiEndpoints.restApiBaseFull}/inventory_items';

        final queryParams = <String, dynamic>{
          'select': '*',
          'active': 'eq.true',
          'order': 'name.asc',
        };

        if (category != null) queryParams['category'] = 'eq.$category';
        if (isActive != null) queryParams['active'] = 'eq.$isActive';
        if (page != null && pageSize != null) {
          final offset = (page - 1) * pageSize;
          queryParams['limit'] = pageSize;
          queryParams['offset'] = offset;
        }

        final response = await apiClient.get(url, queryParameters: queryParams);

        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => InventoryItemModel.fromJson(json)).toList();
        }

        return [];
      },
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              // Get orgId from action data or use default
              var items = InventoryMockData.getInventoryItems(orgId: 'org-1');
              if (category != null) {
                items = items
                    .where((item) => item.category == category)
                    .toList();
              }
              if (isActive != null) {
                items = items
                    .where((item) => item.isActive == isActive)
                    .toList();
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
        // Use REST API for single item (no single-item Edge Function)
        final url =
            '${ApiEndpoints.restApiBaseFull}/inventory_items?id=eq.$id&select=*';
        final response = await apiClient.get(url);

        if (response.data is List && (response.data as List).isNotEmpty) {
          return InventoryItemModel.fromJson(
            response.data[0] as Map<String, dynamic>,
          );
        }
        throw Exception('Inventory item not found');
      },
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
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
    String? createdBy,
  }) async {
    // Upload image first if provided
    String? imageUrl;
    String? tempItemId;

    if (image != null && _inventoryUploadService != null) {
      try {
        // Generate temp ID for storage path
        tempItemId = generateId();

        // Upload image to Supabase Storage
        imageUrl = await _inventoryUploadService.uploadInventoryImage(
          orgId: orgId,
          itemId: tempItemId,
          file: image,
        );
      } catch (e) {
        // If upload fails, continue without image
        // The offline queue will handle retry when online
        imageUrl = null;
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
        // Use REST API directly for better performance (RLS handles security)
        final url = '${ApiEndpoints.restApiBaseFull}/inventory_items';

        Logger.debug(
          'Creating inventory item with org_id: $orgId, created_by: $createdBy',
        );

        final response = await apiClient.post(
          url,
          data: {
            'org_id': orgId, // Required for RLS policy validation
            if (createdBy != null) 'created_by': createdBy,
            'name': name,
            'unit': unit,
            'sale_price': price,
            'taxable_default': true,
            'active': true,
            if (sku != null) 'sku': sku,
            if (category != null) 'category': category,
            if (description != null) 'description': description,
            if (imageUrl != null && imageUrl != 'pending_upload')
              'image_path': imageUrl,
          },
        );

        // REST API returns the created item directly (array with single item)
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InventoryItemModel.fromJson(
            response.data[0] as Map<String, dynamic>,
          );
        }
        return InventoryItemModel.fromJson(
          response.data as Map<String, dynamic>,
        );
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
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
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

    if (_inventoryUploadService != null) {
      try {
        // Generate temp ID for storage path
        tempItemId = generateId();

        // Upload image to Supabase Storage
        imageUrl = await _inventoryUploadService.uploadInventoryImage(
          orgId: orgId,
          itemId: tempItemId,
          file: image,
        );
      } catch (e) {
        // If upload fails, continue without image
        // The offline queue will handle retry when online
        imageUrl = null;
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
        // Use mock data if configured, otherwise call real API
        if (AppConfig.useMockData && !SupabaseConfig.isValid) {
          await Future.delayed(const Duration(seconds: 1));
          return newItem;
        }

        // Call actual Edge Function: tech-inventory-ai-detect
        final endpoint =
            '${ApiEndpoints.baseUrl}/${ApiEndpoints.inventoryAiDetectFunction}';

        // Convert image to base64 if we have a local file, or get public URL if uploaded
        String? imageBase64;
        String? publicImageUrl;

        if (imageUrl == null || imageUrl == 'pending_upload') {
          // Image not uploaded yet, send as base64
          try {
            final imageBytes = await image.readAsBytes();
            imageBase64 = base64Encode(imageBytes);
          } catch (e) {
            throw Exception('Failed to encode image: $e');
          }
        } else {
          // Image already uploaded to storage, get public URL
          if (_inventoryUploadService != null) {
            try {
              publicImageUrl = await _inventoryUploadService.getPublicUrl(
                storagePath: imageUrl,
              );
              Logger.info(
                'Generated public URL for AI detection: $publicImageUrl',
              );
            } catch (e) {
              Logger.error(
                'Failed to get public URL, falling back to base64: $e',
              );
              // Fallback: try to read the image as base64
              try {
                final imageBytes = await image.readAsBytes();
                imageBase64 = base64Encode(imageBytes);
              } catch (e2) {
                throw Exception('Failed to process image: $e2');
              }
            }
          } else {
            // No upload service available, try to read as base64
            try {
              final imageBytes = await image.readAsBytes();
              imageBase64 = base64Encode(imageBytes);
            } catch (e) {
              throw Exception('Failed to process image: $e');
            }
          }
        }

        final response = await apiClient.post(
          endpoint,
          data: {
            if (publicImageUrl != null) 'image_url': publicImageUrl,
            if (imageBase64 != null) 'image_base64': imageBase64,
            // hint_text is optional - can be used to provide context about the item
          },
        );

        // Parse Edge Function response format: { data: { name, category, unit, suggested_price, ... } }
        final responseData = response.data['data'] as Map<String, dynamic>?;
        if (responseData == null) {
          throw Exception('Invalid response format from AI detection');
        }

        // Create inventory item from AI detection result
        return InventoryItemModel(
          id: generateId(),
          orgId: orgId,
          name: responseData['name'] as String? ?? 'Unknown Item',
          unit: responseData['unit'] as String? ?? 'each',
          price: (responseData['suggested_price'] as num?)?.toDouble() ?? 0.0,
          sku: responseData['sku'] as String?,
          category: responseData['category'] as String?,
          description: responseData['notes'] as String?,
          imageUrl: imageUrl ?? 'pending_upload',
          isActive: true,
          isAiDetected: true,
          aiSuggestedPrice: (responseData['suggested_price'] as num?)
              ?.toDouble(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      },
      actionType: PendingActionType.addInventory,
      actionData: {
        'org_id': orgId,
        'ai_detection': true,
        'image_path': image.path,
      },
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => newItem,
    );
  }

  /// Get AI price suggestion for an item
  Future<AiPriceSuggestion> getAiPriceSuggestion({
    required File image,
    String? itemName,
    String? itemId,
  }) async {
    try {
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData && !SupabaseConfig.isValid) {
        await Future.delayed(const Duration(seconds: 1));
        return InventoryMockData.getMockPriceSuggestion();
      }

      // Call actual Edge Function: tech-inventory-ai-price
      final endpoint =
          '${ApiEndpoints.baseUrl}/${ApiEndpoints.inventoryAiPriceFunction}';

      // Convert image to base64
      String? imageBase64;
      try {
        final imageBytes = await image.readAsBytes();
        imageBase64 = base64Encode(imageBytes);
      } catch (e) {
        throw Exception('Failed to encode image: $e');
      }

      final response = await apiClient.post(
        endpoint,
        data: {
          'image_base64': imageBase64,
          if (itemId != null) 'item_id': itemId,
          if (itemName != null)
            'item_name':
                itemName, // Edge Function expects 'item_name', not 'hint_text'
        },
      );

      // Parse Edge Function response format: { data: { suggested_price, confidence, reasoning, ... } }
      final responseData = response.data['data'] as Map<String, dynamic>?;
      if (responseData == null) {
        throw Exception('Invalid response format from AI price suggestion');
      }

      // Map Edge Function response to AiPriceSuggestion model
      final priceRange = responseData['price_range'] as Map<String, dynamic>?;
      final confidenceValue =
          (responseData['confidence'] as num?)?.toDouble() ?? 0.5;
      final confidenceLevel = confidenceValue > 0.7
          ? 'high'
          : confidenceValue > 0.4
          ? 'medium'
          : 'low';

      return AiPriceSuggestion(
        suggestedPrice:
            (responseData['suggested_price'] as num?)?.toDouble() ?? 0.0,
        currency: 'USD',
        confidence: confidenceLevel,
        reasoning: responseData['reasoning'] as String?,
        similarItems: priceRange != null
            ? [
                'Min: \$${priceRange['min']?.toStringAsFixed(2)}',
                'Max: \$${priceRange['max']?.toStringAsFixed(2)}',
              ]
            : null,
      );
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
        // Use REST API for update (no update Edge Function yet)
        final url = '${ApiEndpoints.restApiBaseFull}/inventory_items?id=eq.$id';
        final response = await apiClient.patch(
          url,
          data: {
            if (name != null) 'name': name,
            if (unit != null) 'unit': unit,
            if (price != null) 'sale_price': price,
            if (sku != null) 'sku': sku,
            if (category != null) 'category': category,
            if (description != null) 'description': description,
            if (isActive != null) 'active': isActive,
          },
        );

        // REST API returns array, get first item
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InventoryItemModel.fromJson(
            response.data[0] as Map<String, dynamic>,
          );
        }
        return InventoryItemModel.fromJson(
          response.data as Map<String, dynamic>,
        );
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
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
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
        await offlineQueue.addAction(
          PendingAction(
            id: generateId(),
            type: PendingActionType.deleteInventory,
            data: {'id': id},
            timestamp: DateTime.now(),
          ),
        );
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
        // Use Edge Function: tech-inventory-items with search
        final functionName = 'tech-inventory-items';
        final url = '${ApiEndpoints.baseUrl}/$functionName';

        final response = await apiClient.get(
          url,
          queryParameters: {'search': query},
        );

        // Handle Edge Function response format
        if (response.data is Map && response.data['data'] != null) {
          final List<dynamic> data = response.data['data'] as List;
          return data.map((json) => InventoryItemModel.fromJson(json)).toList();
        }

        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => InventoryItemModel.fromJson(json)).toList();
        }

        return [];
      },
      fromJson: (data) =>
          InventoryItemModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              final items = InventoryMockData.getInventoryItems(orgId: 'org-1');
              return items
                  .where(
                    (item) =>
                        item.name.toLowerCase().contains(query.toLowerCase()) ||
                        (item.sku?.toLowerCase().contains(
                              query.toLowerCase(),
                            ) ??
                            false) ||
                        (item.category?.toLowerCase().contains(
                              query.toLowerCase(),
                            ) ??
                            false),
                  )
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
  final inventoryUploadService = ref.watch(inventoryUploadServiceProvider);

  return InventoryRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
    mediaUploadService: mediaUploadService,
    inventoryUploadService: inventoryUploadService,
  );
});
