import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice_model.dart';
import '../datasources/invoice_mock_data.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/errors/app_exceptions.dart';
import 'package:smartflowpro/core/services/logger.dart';

/// Invoice Repository
/// 
/// Handles all invoice-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class InvoiceRepository extends BaseRepository {
  InvoiceRepository(
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
  }) : super(apiClient, cache, offlineQueue, useMockData: useMockData);

  /// Get all invoices - unified pattern
  /// 
  /// Uses REST API directly to avoid ES256 JWT issues with Edge Functions.
  /// RLS policies will filter by technician's organization automatically.
  /// 
  /// [page] and [pageSize] are optional for backward compatibility.
  /// When provided, enables pagination support.
  Future<List<InvoiceModel>> getInvoices({
    InvoiceStatus? status,
    int? page,
    int? pageSize,
  }) async {
    final cacheKey = '${StorageKeys.invoicesListCache}_${status?.name ?? 'all'}';
    
    return await fetchList<InvoiceModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Use REST API directly (works with ES256 JWT)
        // Build query with filters
        String url = '${ApiEndpoints.restApiBaseFull}/invoices?select=*&order=created_at.desc';
        
        // Add status filter if provided
        if (status != null) {
          url += '&status=eq.${status.name}';
        }
        
        // Note: page/pageSize not supported by PostgREST directly
        // Would need to use limit/offset instead
        if (page != null && pageSize != null) {
          final offset = (page - 1) * pageSize;
          url += '&limit=$pageSize&offset=$offset';
        }
        
        final response = await apiClient.get(url);
        
        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => InvoiceModel.fromJson(json)).toList();
        }
        
        return [];
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => InvoiceMockData.getInvoices()
              .where((inv) => status == null || inv.status == status)
              .toList()
          : null,
    );
  }

  /// Get draft invoices
  Future<List<InvoiceModel>> getDraftInvoices() async {
    return getInvoices(status: InvoiceStatus.draft);
  }

  /// Get single invoice - unified pattern
  Future<InvoiceModel> getInvoice(String id) async {
    return await fetch<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        // Use REST API directly
        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Invoice not found');
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => InvoiceMockData.getInvoices()
              .firstWhere((invoice) => invoice.id == id)
          : null,
    );
  }

  /// Create draft invoice from quote - with offline support
  /// 
  /// [orgId] should be passed from the caller (provider/screen) that has access to auth state
  Future<InvoiceModel> createDraftInvoiceFromQuote({
    required String quoteId,
    required String orgId,
  }) async {
    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_new',
      apiCall: () async {
        final endpoint = ApiEndpoints.buildRouterPath(
          ApiEndpoints.createInvoiceDraft(quoteId),
        );
        final response = await apiClient.post(
          '${ApiEndpoints.apiBase}$endpoint',
        );
        return InvoiceModel.fromJson(response.data);
      },
      actionType: PendingActionType.createInvoice,
      actionData: {
        'quote_id': quoteId,
        'org_id': orgId,
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: useMockData
          ? () => InvoiceModel(
                id: generateId(),
                orgId: orgId,
                visitId: 'visit-mock',
                quoteId: quoteId,
                invoiceNumber: 'INV-DEMO-${DateTime.now().millisecondsSinceEpoch % 10000}',
                status: InvoiceStatus.draft,
                total: 0.0,
                subtotal: 0.0,
                taxAmount: 0.0,
                lineItems: [],
                customerName: 'Mock Customer',
                createdAt: DateTime.now(),
              )
          : null,
    );
  }

  /// Update draft invoice - with offline support
  Future<InvoiceModel> updateDraftInvoice({
    required String id,
    List<dynamic>? lineItems,
    String? notes,
    DateTime? dueDate,
  }) async {
    // Get current invoice first for optimistic update
    final current = await getInvoice(id);
    
    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        final response = await apiClient.patch(
          '/v1/tech/invoices/$id',
          data: {
            if (lineItems != null) 'line_items': lineItems,
            if (notes != null) 'notes': notes,
            if (dueDate != null) 'due_date': dueDate.toIso8601String(),
          },
        );
        return InvoiceModel.fromJson(response.data);
      },
      actionType: PendingActionType.updateInvoice,
      actionData: {
        'invoice_id': id,
        'line_items': lineItems,
        'notes': notes,
        'due_date': dueDate?.toIso8601String(),
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        notes: notes ?? current.notes,
        dueDate: dueDate ?? current.dueDate,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'invoice',
      checkConflict: true,
    );
  }

  /// Finalize draft invoice - with offline support
  /// 
  /// Per PRD Section 18: Invoice must have at least one line item before finalization.
  Future<InvoiceModel> finalizeInvoice(String id) async {
    // Get current invoice first for optimistic update
    final current = await getInvoice(id);
    
    // Validate invoice can be finalized (PRD Section 18)
    if (current.status != InvoiceStatus.draft) {
      throw ValidationException(
        message: 'Only draft invoices can be finalized.',
        code: 'INVOICE_NOT_DRAFT',
      );
    }
    
    if (current.lineItems.isEmpty) {
      throw ValidationException(
        message: 'Invoice must have at least one line item before finalization.',
        code: 'INVOICE_EMPTY',
      );
    }
    
    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        final response = await apiClient.post('/v1/tech/invoices/$id/finalize');
        return InvoiceModel.fromJson(response.data);
      },
      actionType: PendingActionType.finalizeInvoice,
      actionData: {'invoice_id': id, 'action': 'finalize'},
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: InvoiceStatus.unpaid,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'invoice',
      checkConflict: true,
    );
  }

  /// Get invoice preview (formatted view)
  Future<String> getInvoicePreview(String id) async {
    return await fetch<String>(
      cacheKey: 'invoice_preview_$id',
      apiCall: () async {
        final response = await apiClient.get('/v1/tech/invoices/$id/preview');
        return response.data['preview_url'] as String;
      },
      fromJson: (data) => data as String,
      mockData: useMockData ? () => 'mock_preview_url_$id' : null,
      cacheResult: false, // Don't cache preview URLs
    );
  }

  /// Get payments for an invoice
  Future<List<PaymentModel>> getInvoicePayments(String invoiceId) async {
    return await fetchList<PaymentModel>(
      cacheKey: 'invoice_payments_$invoiceId',
      apiCall: () async {
        final response = await apiClient.get('/v1/invoices/$invoiceId/payments');
        final List<dynamic> data = response.data as List;
        return data.map((json) => PaymentModel.fromJson(json)).toList();
      },
      fromJson: (data) => PaymentModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => InvoiceMockData.getMockPayments(invoiceId) : null,
    );
  }

  /// Void an unpaid invoice - with offline support
  /// 
  /// Per PRD Section 18: Only unpaid invoices (with no payments) can be voided.
  Future<InvoiceModel> voidInvoice(String id) async {
    // Get current invoice first for optimistic update
    final current = await getInvoice(id);
    
    // Validate invoice can be voided (PRD Section 18)
    if (current.status != InvoiceStatus.unpaid) {
      throw ValidationException(
        message: 'Only unpaid invoices can be voided.',
        code: 'INVOICE_NOT_UNPAID',
      );
    }
    
    // Check if invoice has any payments (should be none for unpaid status)
    try {
      final payments = await getInvoicePayments(id);
      if (payments.isNotEmpty) {
        throw ValidationException(
          message: 'Cannot void invoice with existing payments.',
          code: 'INVOICE_HAS_PAYMENTS',
        );
      }
    } catch (e) {
      // If payment fetch fails, log but continue (may be offline)
      Logger.warning('Could not verify payments before voiding invoice', e);
    }
    
    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        final response = await apiClient.post('/v1/tech/invoices/$id/void');
        return InvoiceModel.fromJson(response.data);
      },
      actionType: PendingActionType.voidInvoice,
      actionData: {'invoice_id': id, 'action': 'void'},
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: InvoiceStatus.void_,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'invoice',
      checkConflict: true,
    );
  }
}

/// Invoice Repository Provider
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cache = ref.watch(invoicesCacheProvider);
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  
  return InvoiceRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
  );
});

