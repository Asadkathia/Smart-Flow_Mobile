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

  /// Convert line items to JSON for API requests
  /// 
  /// Extracts common mapping logic to avoid duplication.
  List<Map<String, dynamic>> _lineItemsToJson(List<LineItemModel> lineItems, String quoteId, String orgId) {
    return lineItems.map((item) => <String, dynamic>{
      'id': item.id,
      'quote_id': quoteId,
      'org_id': orgId,
      'description': item.description,
      'qty': item.qty,
      'unit_price': item.unitPrice,
      'type': item.type.name,
      'unit': item.unit,
      'taxable': item.taxable,
      'reference_id': item.referenceId,
      'created_at': item.createdAt.toIso8601String(),
      'updated_at': item.updatedAt.toIso8601String(),
    }).toList();
  }

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

  /// Get single quote with line items
  Future<QuoteModel> getQuote(String id) async {
    return await fetch<QuoteModel>(
      cacheKey: 'quote_$id',
      apiCall: () async {
        // 1. Get quote header
        final url = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$id&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          final quoteJson = response.data[0] as Map<String, dynamic>;
          
          // 2. Fetch line items separately
          final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items?quote_id=eq.$id&select=*&order=created_at.asc';
          final lineItemsResponse = await apiClient.get(lineItemsUrl);
          
          List<LineItemModel> lineItems = [];
          if (lineItemsResponse.data is List) {
            lineItems = (lineItemsResponse.data as List)
                .map((item) => LineItemModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          
          // 3. Combine and return
          final quote = QuoteModel.fromJson(quoteJson);
          return quote.copyWith(lineItems: lineItems);
        }
        throw Exception('Quote not found');
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      mockData: null,
    );
  }

  /// Create a new quote - with offline support
  Future<QuoteModel> createQuote(QuoteModel quote) async {
    return await mutate<QuoteModel>(
      cacheKey: 'quote_${quote.id}',
      apiCall: () async {
        // Use REST API to insert
        // Map directly from model object to ensure correct types
        final dbJson = <String, dynamic>{
          'id': quote.id,
          'org_id': quote.orgId,
          'visit_id': quote.visitId,
          'quote_number': quote.quoteNumber,
          'status': quote.status.name, // Enum to string
          'taxable': quote.taxable,
          'subtotal': quote.subtotal,
          'discount_total': quote.discountTotal,
          'tax_total': quote.taxTotal,
          'grand_total': quote.grandTotal,
          'locked_at': quote.lockedAt?.toIso8601String(),
          'locked_by': quote.lockedBy,
          'version': quote.version,
          'notes': quote.notes,
          'terms': quote.terms,
          'expiration_date': quote.expirationDate?.toIso8601String(),
          'created_at': quote.createdAt.toIso8601String(),
          'updated_at': quote.updatedAt.toIso8601String(),
        };
        
        print('[QuoteRepository] Creating quote header...');
        // Prefer header will force return of created data
        final url = '${ApiEndpoints.restApiBaseFull}/quotes';
        
        // Debug payload
        print('[QuoteRepository] Payload: $dbJson');
        
        final response = await apiClient.post(url, data: dbJson);
        print('[QuoteRepository] Header created successfully. Response status: ${response.statusCode}');
        print('[QuoteRepository] Response data type: ${response.data.runtimeType}');
        
        QuoteModel createdQuote;
        
        // Supabase with Prefer header returns array
        if (response.data is List) {
          final list = response.data as List;
          if (list.isEmpty) {
             throw Exception('Quote created but no data returned. This should not happen with Prefer header.');
          }
          createdQuote = QuoteModel.fromJson(list[0] as Map<String, dynamic>);
        } else {
           throw Exception('Unexpected response format: ${response.data.runtimeType}');
        }

        // 2. Insert Line Items
        // Now that quote is created, insert the line items
        if (quote.lineItems.isNotEmpty) {
          print('[QuoteRepository] Inserting ${quote.lineItems.length} line items...');
          try {
            // Need to return data for line items too if we were to use them, but we don't strictly need them back here
            // as we are returning the optimistic quote with line items anyway.
            final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items';
            
            final lineItemsJson = _lineItemsToJson(quote.lineItems, quote.id, quote.orgId);

            // Debug line items
            print('[QuoteRepository] Line items payload: $lineItemsJson');

            await apiClient.post(lineItemsUrl, data: lineItemsJson);
            print('[QuoteRepository] Line items inserted successfully');
            
            // Return quote with line items (optimistic)
            // The response from DB won't have line items joined yet unless we re-fetch
            return createdQuote.copyWith(lineItems: quote.lineItems);
          } catch (e, stack) {
            print('[QuoteRepository] FAILED to insert line items: $e');
            print(stack);
            
            // Log error but don't fail the whole operation since quote header IS created
            // In a real app, might want to rollback or queue for retry
            // For now, rethrow to trigger error handling
            // Delete the orphan header to prevent "empty quote" state
             try {
               await apiClient.delete('${ApiEndpoints.restApiBaseFull}/quotes?id=eq.${quote.id}');
             } catch (_) {}
            throw Exception('Failed to save line items: $e');
          }
        }

        return createdQuote;
      },
      actionType: PendingActionType.createQuote,
      actionData: {
        'quote_id': quote.id,
        'visit_id': quote.visitId,
        'quote_number': quote.quoteNumber,
        // Store line items in action data for offline retry
        'line_items': quote.lineItems.map((e) => e.toJson()).toList(), 
      },
      fromJson: (data) => QuoteModel.fromJson(data as Map<String, dynamic>),
      // Return the full quote with line items for immediate UI update
      optimisticUpdate: () => quote, 
    );
  }

  /// Update a quote - with offline support
  Future<QuoteModel> updateQuote(QuoteModel quote) async {
    return await mutate<QuoteModel>(
      cacheKey: 'quote_${quote.id}',
      apiCall: () async {
        // 1. Update quote header
        final dbJson = <String, dynamic>{
          'org_id': quote.orgId,
          'visit_id': quote.visitId,
          'quote_number': quote.quoteNumber,
          'status': quote.status.name,
          'taxable': quote.taxable,
          'subtotal': quote.subtotal,
          'discount_total': quote.discountTotal,
          'tax_total': quote.taxTotal,
          'grand_total': quote.grandTotal,
          'locked_at': quote.lockedAt?.toIso8601String(),
          'locked_by': quote.lockedBy,
          'version': quote.version,
          'notes': quote.notes,
          'terms': quote.terms,
          'expiration_date': quote.expirationDate?.toIso8601String(),
          'updated_at': quote.updatedAt.toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.${quote.id}';
        final response = await apiClient.patch(url, data: dbJson);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          final updatedQuoteHeader = QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
          
          // 2. Clear existing line items
          print('[QuoteRepository] Deleting existing line items for: ${quote.id}');
          await apiClient.delete('${ApiEndpoints.restApiBaseFull}/line_items?quote_id=eq.${quote.id}');
          
          // 3. Insert new line items
          if (quote.lineItems.isNotEmpty) {
            print('[QuoteRepository] Inserting ${quote.lineItems.length} new line items...');
            final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items';
            final lineItemsJson = _lineItemsToJson(quote.lineItems, quote.id, quote.orgId);
            
            await apiClient.post(lineItemsUrl, data: lineItemsJson);
          }
          
          return updatedQuoteHeader.copyWith(lineItems: quote.lineItems);
        }
        throw Exception('Failed to update quote header');
      },
      actionType: PendingActionType.updateQuote,
      actionData: {
        'quote_id': quote.id,
        'visit_id': quote.visitId,
        'line_items': quote.lineItems.map((e) => e.toJson()).toList(),
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
        // Use RPC to finalize (bypasses RLS)
        // RPC: finalize_quote(quote_id UUID)
        const rpcName = 'finalize_quote';
        final response = await apiClient.post(
          '${ApiEndpoints.restApiBaseFull}/rpc/$rpcName',
          data: {'quote_id': id},
        );
        
        // RPC returns the updated quote object directly
        if (response.data != null) {
          // Supabase RPC might return the object directly or wrapped based on setup
          // Based on the function definition "RETURNS JSONB", it should be the map directly
          if (response.data is Map) {
             return QuoteModel.fromJson(response.data as Map<String, dynamic>);
          }
           // Fallback if it returns a list (unlikely for RETURNS JSONB but possible for RETURNS SETOF)
          if (response.data is List && (response.data as List).isNotEmpty) {
            return QuoteModel.fromJson(response.data[0] as Map<String, dynamic>);
          }
        }
        throw Exception('Failed to finalize quote: Empty or invalid response from RPC');
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
      // Use REST API instead of Edge Function
      await apiClient.delete('${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$id');
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

