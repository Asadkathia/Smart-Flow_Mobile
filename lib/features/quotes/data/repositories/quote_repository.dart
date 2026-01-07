import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/quote_model.dart';
import '../models/line_item_model.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/local/offline_queue_service.dart';
import '../../../../shared/data/local/hive_service.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/validation/validation_rules.dart';
import '../../../../core/validation/quote_validator.dart';

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
        final queryParams = <String, dynamic>{};
        if (visitId != null) queryParams['visit_id'] = visitId;
        if (status != null) queryParams['status'] = status.name;
        if (page != null) queryParams['page'] = page;
        if (pageSize != null) queryParams['page_size'] = pageSize;
        
        final response = await apiClient.get(
          '/v1/tech/quotes',
          queryParameters: queryParams.isEmpty ? null : queryParams,
        );
        
        // Handle paginated response if page/pageSize provided
        if (page != null || pageSize != null) {
          // Backend should return paginated response
          // For now, handle both formats
          if (response.data is Map && response.data['data'] != null) {
            final List<dynamic> data = response.data['data'] as List;
            return data.map((json) => QuoteModel.fromJson(json)).toList();
          }
        }
        
        final List<dynamic> data = response.data as List;
        return data.map((json) => QuoteModel.fromJson(json)).toList();
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
        final response = await apiClient.get('/v1/tech/quotes/$id');
        return QuoteModel.fromJson(response.data);
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
        final response = await apiClient.post(
          '/v1/tech/quotes',
          data: quote.toJson(),
        );
        return QuoteModel.fromJson(response.data);
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
        final response = await apiClient.patch(
          '/v1/tech/quotes/${quote.id}',
          data: quote.toJson(),
        );
        return QuoteModel.fromJson(response.data);
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
    
    return await mutate<QuoteModel>(
      cacheKey: 'quote_$id',
      apiCall: () async {
        final response = await apiClient.post('/v1/tech/quotes/$id/finalize');
        return QuoteModel.fromJson(response.data);
      },
      actionType: PendingActionType.updateQuote,
      actionData: {'quote_id': id, 'action': 'finalize'},
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: QuoteStatus.finalized,
        lockedAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
          type: PendingActionType.updateQuote, // TODO: Add deleteQuote action type
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

