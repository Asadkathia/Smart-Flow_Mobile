import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/quote_model.dart';
import '../models/line_item_model.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/errors/error_handler.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import 'package:smartflowpro/core/validation/quote_validator.dart';

/// Quote Repository
/// 
/// Handles all quote-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class QuoteRepository extends BaseRepository {
  QuoteRepository(
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
  }) : super(apiClient, cache, offlineQueue, useMockData: useMockData);

  /// Get all quotes for a visit
  /// 
  /// Uses REST API directly to avoid ES256 JWT issues with Edge Functions.
  /// RLS policies will filter by technician's organization automatically.
  /// 
  /// [page] and [pageSize] are optional for backward compatibility.
  /// When provided, enables pagination support.
  Future<List<QuoteModel>> getQuotes({
    String? visitId,
    QuoteStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final cacheKey = 'quotes_${visitId ?? 'all'}_${status?.name ?? 'all'}';
    
    return await fetchList<QuoteModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Use REST API directly (works with ES256 JWT)
        String url = '${ApiEndpoints.restApiBaseFull}/quotes?select=*&order=created_at.desc';
        
        // Add filters
        if (visitId != null) {
          url += '&visit_id=eq.$visitId';
        }
        if (status != null) {
          url += '&status=eq.${status.name}';
        }
        
        // Add pagination
        if (page != null && pageSize != null) {
          final offset = (page - 1) * pageSize;
          url += '&limit=$pageSize&offset=$offset';
        }
        
        final response = await apiClient.get(url);
        
        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => QuoteModel.fromJson(json)).toList();
        }
        
        return [];
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      mockData: null, // TODO: Add mock data if needed
    );
  }

  /// Get single quote
  Future<QuoteModel> getQuote(String id) async {
    return await fetch<QuoteModel>(
      cacheKey: 'quote_$id',
      apiCall: () async {
        // Use REST API directly
        final url = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$id&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Quote not found');
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      mockData: null, // TODO: Add mock data if needed
    );
  }

  /// Create a new quote - with offline support
  Future<QuoteModel> createQuote(QuoteModel quote) async {
    return await mutate<QuoteModel>(
      cacheKey: 'quote_${quote.id}',
      apiCall: () async {
        // Use REST API to insert
        // Convert quote to JSON and map camelCase to snake_case for database
        final quoteJson = quote.toJson();
        final dbJson = <String, dynamic>{
          'id': quoteJson['id'],
          'org_id': quoteJson['org_id'],
          'visit_id': quoteJson['visit_id'],
          'quote_number': quoteJson['quote_number'],
          'status': quoteJson['status'],
          'taxable': quoteJson['taxable'],
          'subtotal': quoteJson['subtotal'],
          'discount_total': quoteJson['discount_total'],
          'tax_total': quoteJson['tax_total'],
          'grand_total': quoteJson['grand_total'],
          'locked_at': quoteJson['locked_at'],
          'locked_by': quoteJson['locked_by'],
          'version': quoteJson['version'],
          'created_at': quoteJson['created_at']?.toIso8601String(),
          'updated_at': quoteJson['updated_at']?.toIso8601String(),
        };
        
        // Note: line_items are stored in a separate table, not in quotes table
        // They should be inserted separately after quote creation
        
        final url = '${ApiEndpoints.restApiBaseFull}/quotes';
        
        final response = await apiClient.post(url, data: dbJson);
        
        // REST API returns array with single item on insert
        if (response.data is List && (response.data as List).isNotEmpty) {
          return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        return QuoteModel.fromJson(response.data as Map<String, dynamic>);
      },
      actionType: PendingActionType.createQuote,
      actionData: {
        'quote_id': quote.id,
        'visit_id': quote.visitId,
        'quote_number': quote.quoteNumber,
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => quote, // Return the quote as-is for immediate UI update
    );
  }

  /// Update a quote - with offline support
  Future<QuoteModel> updateQuote(QuoteModel quote) async {
    return await mutate<QuoteModel>(
      cacheKey: 'quote_${quote.id}',
      apiCall: () async {
        // Use REST API to update
        // Convert quote to JSON and map camelCase to snake_case for database
        final quoteJson = quote.toJson();
        final dbJson = <String, dynamic>{
          'org_id': quoteJson['org_id'],
          'visit_id': quoteJson['visit_id'],
          'quote_number': quoteJson['quote_number'],
          'status': quoteJson['status'],
          'taxable': quoteJson['taxable'],
          'subtotal': quoteJson['subtotal'],
          'discount_total': quoteJson['discount_total'],
          'tax_total': quoteJson['tax_total'],
          'grand_total': quoteJson['grand_total'],
          'locked_at': quoteJson['locked_at'],
          'locked_by': quoteJson['locked_by'],
          'version': quoteJson['version'],
          'updated_at': quoteJson['updated_at']?.toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.${quote.id}';
        
        final response = await apiClient.patch(url, data: dbJson);
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to update quote');
      },
      actionType: PendingActionType.updateQuote,
      actionData: {
        'quote_id': quote.id,
        'visit_id': quote.visitId,
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => quote,
      localEntity: quote,
      entityType: 'quote',
      checkConflict: true,
    );
  }

  /// Finalize a quote - with offline support
  Future<QuoteModel> finalizeQuote(String id) async {
    // Get current quote first for optimistic update
    final current = await getQuote(id);
    
    // Validate using QuoteValidator (PRD Section 18)
    QuoteValidator.validateCanFinalize(current);
    
    final now = DateTime.now();
    
    return await mutate<QuoteModel>(
      cacheKey: 'quote_$id',
      apiCall: () async {
        // Use REST API to update status to finalized
        final url = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$id';
        
        final response = await apiClient.patch(url, data: {
          'status': 'finalized',
          'locked_at': now.toIso8601String(),
        });
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to finalize quote');
      },
      actionType: PendingActionType.updateQuote,
      actionData: {'quote_id': id, 'action': 'finalize'},
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: QuoteStatus.finalized,
        lockedAt: now,
        updatedAt: now,
      ),
      localEntity: current,
      entityType: 'quote',
      checkConflict: true,
    );
  }

  /// Delete a quote - with offline support
  Future<void> deleteQuote(String id) async {
    try {
      await apiClient.delete('/v1/tech/quotes/$id');
      // Clear cache
      await clearCache('quote_$id');
    } catch (e) {
      // Queue for offline sync if network error
      if (ErrorHandler.isNetworkError(e)) {
        await offlineQueue.addAction(PendingAction(
          id: generateId(),
          type: PendingActionType.deleteQuote,
          data: {'quote_id': id, 'action': 'delete'},
          timestamp: DateTime.now(),
        ));
      }
      rethrow;
    }
  }
}

/// Quote Repository Provider
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cache = ref.watch(quotesCacheProvider);
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  
  return QuoteRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
  );
});

