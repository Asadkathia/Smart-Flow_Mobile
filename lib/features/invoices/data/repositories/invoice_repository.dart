import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/invoice_model.dart';
import '../datasources/invoice_mock_data.dart';
import '../../domain/services/invoice_pdf_service.dart';
import 'package:smartflowpro/features/quotes/data/models/line_item_model.dart';
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
  Future<InvoiceModel> getInvoice(String id, {bool ignoreCache = false}) async {
    return await fetch<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        // 1. Fetch invoice header
        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is! List || (response.data as List).isEmpty) {
          throw Exception('Invoice not found');
        }
        
        final invoiceData = response.data[0] as Map<String, dynamic>;
        
        // 2. Fetch line items for this invoice
        final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items?invoice_id=eq.$id&select=*&order=created_at.asc';
        final lineItemsResponse = await apiClient.get(lineItemsUrl);
        
        final lineItems = lineItemsResponse.data is List
            ? (lineItemsResponse.data as List).map((item) => LineItemModel.fromJson(item as Map<String, dynamic>)).toList()
            : <LineItemModel>[];
        
        // 3. Return invoice with line items
        return InvoiceModel.fromJson({
          ...invoiceData,
          'line_items': lineItems.map((item) => item.toJson()).toList(),
        });
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => InvoiceMockData.getInvoices()
              .firstWhere((invoice) => invoice.id == id)
          : null,
      ignoreCache: ignoreCache,
    );
  }

  /// Create draft invoice from quote - with offline support
  /// 
  /// Uses REST API to fetch quote and create invoice directly.
  /// [orgId] should be passed from the caller (provider/screen) that has access to auth state
  Future<InvoiceModel> createDraftInvoiceFromQuote({
    required String quoteId,
    required String orgId,
  }) async {
    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_new',
      apiCall: () async {
        // 1. Fetch the quote to get all details
        final quoteUrl = '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$quoteId&select=*';
        final quoteResponse = await apiClient.get(quoteUrl);
        
        if (quoteResponse.data is! List || (quoteResponse.data as List).isEmpty) {
          throw Exception('Quote not found');
        }
        
        final quoteData = quoteResponse.data[0] as Map<String, dynamic>;
        final visitId = quoteData['visit_id'] as String;
        
        // 2. Fetch visit to get customer information
        final visitUrl = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId&select=*';
        final visitResponse = await apiClient.get(visitUrl);
        
        if (visitResponse.data is! List || (visitResponse.data as List).isEmpty) {
          throw Exception('Visit not found');
        }
        
        final visitData = visitResponse.data[0] as Map<String, dynamic>;
        
        // 3. Fetch line items for the quote
        final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items?quote_id=eq.$quoteId&select=*';
        final lineItemsResponse = await apiClient.get(lineItemsUrl);
        
        final lineItems = lineItemsResponse.data is List
            ? (lineItemsResponse.data as List).map((item) => item as Map<String, dynamic>).toList()
            : <Map<String, dynamic>>[];
        
        // 3. Create invoice header
        final invoiceId = generateId();
        final now = DateTime.now();
        
        final invoiceJson = {
          'id': invoiceId,
          'org_id': orgId,
          'visit_id': visitId,
          'quote_id': quoteId,
          'invoice_number': 'INV-DRAFT-${generateId().substring(0, 8).toUpperCase()}', // Temporary number
          'status': 'draft',
          'total': quoteData['grand_total'],
          'subtotal': quoteData['subtotal'],
          'tax_amount': quoteData['tax_total'],
          // Customer information from visit
          'customer_name': visitData['customer_name'],
          'customer_email': visitData['customer_email'],
          'customer_phone': visitData['customer_phone'],
          'property_address': visitData['property_address'],
          'visit_title': visitData['title'],
          // Notes from quote
          'notes': quoteData['notes'],
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/invoices';
        final response = await apiClient.post(url, data: invoiceJson);
        
        if (response.data is! List || (response.data as List).isEmpty) {
          throw Exception('Invoice created but no data returned');
        }
        
        final createdInvoice = response.data[0] as Map<String, dynamic>;
        
        // 4. Copy line items to invoice (update quote_id to invoice_id)
        if (lineItems.isNotEmpty) {
          final invoiceLineItems = lineItems.map((item) => {
                'id': generateId(),
                'org_id': orgId,
                'invoice_id': invoiceId,
                'quote_id': null, // Clear quote reference
                'type': item['type'],
                'reference_id': item['reference_id'],
                'description': item['description'],
                'unit': item['unit'],
                'qty': item['qty'],
                'unit_price': item['unit_price'],
                'taxable': item['taxable'],
                'created_at': now.toIso8601String(),
                'updated_at': now.toIso8601String(),
              }).toList();
          
          final lineItemsUrl = '${ApiEndpoints.restApiBaseFull}/line_items';
          await apiClient.post(lineItemsUrl, data: invoiceLineItems);
        }
        
        // Return invoice with copied line items
        return InvoiceModel.fromJson({
          ...createdInvoice,
          'subtotal': quoteData['subtotal'],
          'tax_amount': quoteData['tax_total'],
          'line_items': lineItems,
        });
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
  /// 
  /// Uses REST API to update invoice fields.
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
        final updateData = <String, dynamic>{
          if (notes != null) 'notes': notes,
          if (dueDate != null) 'due_date': dueDate.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id';
        final response = await apiClient.patch(url, data: updateData);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to update invoice');
      },
      actionType: PendingActionType.updateInvoice,
      actionData: {
        'invoice_id': id,
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
  /// Uses REST API to update status to 'unpaid'.
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
        final updateData = {
          'status': 'unpaid',
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id';
        final response = await apiClient.patch(url, data: updateData);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to finalize invoice');
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
  /// 
  /// Generates PDF bytes for the invoice using client-side PDF generation.
  /// Returns the PDF bytes that can be displayed or shared.
  Future<Uint8List> getInvoicePreview(String id) async {
    // Get full invoice data first
    final invoice = await getInvoice(id);
    
    // Generate PDF using the InvoicePdfService
    final pdfService = InvoicePdfService();
    return pdfService.generatePdf(invoice);
  }

  /// Get payments for an invoice
  /// 
  /// Uses REST API to fetch payments from the payments table.
  Future<List<PaymentModel>> getInvoicePayments(String invoiceId, {bool ignoreCache = false}) async {
    return await fetchList<PaymentModel>(
      cacheKey: 'invoice_payments_$invoiceId',
      apiCall: () async {
        final url = '${ApiEndpoints.restApiBaseFull}/payments?invoice_id=eq.$invoiceId&select=*&order=created_at.desc';
        final response = await apiClient.get(url);
        
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => PaymentModel.fromJson(json as Map<String, dynamic>)).toList();
        }
        return [];
      },
      fromJson: (data) => PaymentModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => InvoiceMockData.getMockPayments(invoiceId) : null,
      ignoreCache: ignoreCache,
    );
  }

  /// Void an unpaid invoice - with offline support
  /// 
  /// Per PRD Section 18: Only unpaid invoices (with no payments) can be voided.
  /// Uses REST API to update status to 'void'.
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
        final updateData = {
          'status': 'void',
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id';
        final response = await apiClient.patch(url, data: updateData);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to void invoice');
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

  /// Record a payment against an invoice - with offline support
  /// 
  /// Creates a payment record and updates invoice status based on total payments.
  Future<PaymentModel> recordPayment({
    required String invoiceId,
    required String orgId,
    required double amount,
    required PaymentMethod method,
    String? reference,
    required String receivedBy,
    DateTime? receivedAt,
  }) async {
    return await mutate<PaymentModel>(
      cacheKey: 'payment_${generateId()}',
      apiCall: () async {
        // 1. Create payment record
        final paymentId = generateId();
        final now = DateTime.now();
        final receivedAtTime = receivedAt ?? now;
        
        final paymentJson = {
          'id': paymentId,
          'org_id': orgId,
          'invoice_id': invoiceId,
          'amount': amount,
          'method': method.name,
          if (reference != null) 'reference': reference,
          'received_by': receivedBy,
          'received_at': receivedAtTime.toIso8601String(),
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };
        
        final url = '${ApiEndpoints.restApiBaseFull}/payments';
        final response = await apiClient.post(url, data: paymentJson);
        
        if (response.data is! List || (response.data as List).isEmpty) {
          throw Exception('Payment created but no data returned');
        }
        
        final createdPayment = PaymentModel.fromJson(response.data[0] as Map<String, dynamic>);
        
        // 2. Update invoice status based on total payments
        final invoice = await getInvoice(invoiceId, ignoreCache: true);
        final allPayments = await getInvoicePayments(invoiceId, ignoreCache: true);
        final totalPaid = allPayments.fold<double>(0.0, (sum, p) => sum + p.amount);
        
        String newStatus;
        if (totalPaid >= invoice.total) {
          newStatus = 'paid';
        } else if (totalPaid > 0) {
          newStatus = 'partially_paid';
        } else {
          newStatus = invoice.status.name;
        }
        
        if (newStatus != invoice.status.name) {
          final invoiceUrl = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$invoiceId';
          await apiClient.patch(invoiceUrl, data: {
            'status': newStatus,
            'updated_at': now.toIso8601String(),
          });
        }
        
        return createdPayment;
      },
      actionType: PendingActionType.recordPayment,
      actionData: {
        'invoice_id': invoiceId,
        'amount': amount,
        'method': method.name,
      },
      fromJson: (data) => PaymentModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => PaymentModel(
        id: generateId(),
        orgId: orgId,
        invoiceId: invoiceId,
        amount: amount,
        method: method,
        reference: reference,
        receivedBy: receivedBy,
        receivedAt: receivedAt ?? DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
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

