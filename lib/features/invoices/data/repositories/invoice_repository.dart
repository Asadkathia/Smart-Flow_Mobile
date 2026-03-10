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
  static const List<String> _finalizedStatuses = [
    'unpaid',
    'partially_paid',
    'paid',
  ];

  static const List<String> _activeInvoiceStatuses = [
    'draft',
    ..._finalizedStatuses,
  ];

  InvoiceRepository(
    super.apiClient,
    super.cache,
    super.offlineQueue, {
    super.useMockData,
  });

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
    final cacheKey =
        '${StorageKeys.invoicesListCache}_${status?.name ?? 'all'}';

    return await fetchList<InvoiceModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Use REST API directly (works with ES256 JWT)
        // Build query with filters
        String url =
            '${ApiEndpoints.restApiBaseFull}/invoices?select=*&order=created_at.desc';

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
        final url =
            '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id&select=*';
        final response = await apiClient.get(url);

        if (response.data is! List || (response.data as List).isEmpty) {
          throw Exception('Invoice not found');
        }

        final invoiceData = response.data[0] as Map<String, dynamic>;

        // 2. Fetch line items for this invoice
        final lineItemsUrl =
            '${ApiEndpoints.restApiBaseFull}/line_items?invoice_id=eq.$id&select=*&order=created_at.asc';
        final lineItemsResponse = await apiClient.get(lineItemsUrl);

        final lineItems = lineItemsResponse.data is List
            ? (lineItemsResponse.data as List)
                  .map(
                    (item) =>
                        LineItemModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
            : <LineItemModel>[];

        // 3. Return invoice with line items
        return InvoiceModel.fromJson({
          ...invoiceData,
          'line_items': lineItems.map((item) => item.toJson()).toList(),
        });
      },
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => InvoiceMockData.getInvoices().firstWhere(
              (invoice) => invoice.id == id,
            )
          : null,
      ignoreCache: ignoreCache,
    );
  }

  /// Get latest draft invoice for a visit.
  Future<InvoiceModel?> getDraftInvoiceByVisit(String visitId) async {
    final url =
        '${ApiEndpoints.restApiBaseFull}/invoices?visit_id=eq.$visitId&status=eq.draft&select=*&order=created_at.desc&limit=1';
    final response = await apiClient.get(url);
    if (response.data is List && (response.data as List).isNotEmpty) {
      return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
    }
    return null;
  }

  /// Get latest finalized invoice for a visit.
  Future<InvoiceModel?> getFinalizedInvoiceByVisit(String visitId) async {
    final url =
        '${ApiEndpoints.restApiBaseFull}/invoices?visit_id=eq.$visitId&status=in.(${_finalizedStatuses.join(',')})&select=*&order=created_at.desc&limit=1';
    final response = await apiClient.get(url);
    if (response.data is List && (response.data as List).isNotEmpty) {
      return InvoiceModel.fromJson(response.data[0] as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _getInvoicesForVisit({
    required String visitId,
    List<String>? statuses,
  }) async {
    String url =
        '${ApiEndpoints.restApiBaseFull}/invoices?visit_id=eq.$visitId&select=*&order=created_at.desc';
    if (statuses != null && statuses.isNotEmpty) {
      url += '&status=in.(${statuses.join(',')})';
    }

    final response = await apiClient.get(url);
    if (response.data is! List) {
      return const [];
    }

    return (response.data as List).whereType<Map<String, dynamic>>().toList();
  }

  Future<InvoiceModel?> _findReusableInvoice({
    required String visitId,
    String? quoteId,
  }) async {
    // Prefer an existing invoice on the same quote if available.
    if (quoteId != null) {
      final byQuoteUrl =
          '${ApiEndpoints.restApiBaseFull}/invoices?quote_id=eq.$quoteId&status=in.(${_activeInvoiceStatuses.join(',')})&select=*&order=created_at.desc';
      final byQuoteResponse = await apiClient.get(byQuoteUrl);
      if (byQuoteResponse.data is List &&
          (byQuoteResponse.data as List).isNotEmpty) {
        final existing =
            (byQuoteResponse.data as List).first as Map<String, dynamic>;
        return InvoiceModel.fromJson(existing);
      }
    }

    final byVisit = await _getInvoicesForVisit(
      visitId: visitId,
      statuses: _activeInvoiceStatuses,
    );

    if (byVisit.isEmpty) {
      return null;
    }

    // Return any finalized invoice first, otherwise fall back to an existing draft.
    for (final status in _finalizedStatuses) {
      final match = byVisit.where((row) => row['status'] == status).toList();
      if (match.isNotEmpty) {
        return InvoiceModel.fromJson(match.first);
      }
    }

    return InvoiceModel.fromJson(byVisit.first);
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
        final quoteUrl =
            '${ApiEndpoints.restApiBaseFull}/quotes?id=eq.$quoteId&select=*';
        final quoteResponse = await apiClient.get(quoteUrl);

        if (quoteResponse.data is! List ||
            (quoteResponse.data as List).isEmpty) {
          throw Exception('Quote not found');
        }

        final quoteData = quoteResponse.data[0] as Map<String, dynamic>;
        final visitId = quoteData['visit_id'] as String;

        // Prevent duplicate invoice creation for the same job/visit.
        final reusable = await _findReusableInvoice(
          visitId: visitId,
          quoteId: quoteId,
        );
        if (reusable != null) {
          return reusable;
        }

        // 2. Fetch visit to get customer information
        final visitUrl =
            '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId&select=*';
        final visitResponse = await apiClient.get(visitUrl);

        if (visitResponse.data is! List ||
            (visitResponse.data as List).isEmpty) {
          throw Exception('Visit not found');
        }

        final visitData = visitResponse.data[0] as Map<String, dynamic>;

        // 3. Fetch line items for the quote
        final lineItemsUrl =
            '${ApiEndpoints.restApiBaseFull}/line_items?quote_id=eq.$quoteId&select=*';
        final lineItemsResponse = await apiClient.get(lineItemsUrl);

        final lineItems = lineItemsResponse.data is List
            ? (lineItemsResponse.data as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList()
            : <Map<String, dynamic>>[];

        // 3. Create invoice header
        final invoiceId = generateId();
        final now = DateTime.now();

        final invoiceJson = {
          'id': invoiceId,
          'org_id': orgId,
          'visit_id': visitId,
          'quote_id': quoteId,
          'invoice_number':
              'INV-DRAFT-${generateId().substring(0, 8).toUpperCase()}', // Temporary number
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
          final invoiceLineItems = lineItems
              .map(
                (item) => {
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
                },
              )
              .toList();

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
      actionData: {'quote_id': quoteId, 'org_id': orgId},
      fromJson: (data) => InvoiceModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: useMockData
          ? () => InvoiceModel(
              id: generateId(),
              orgId: orgId,
              visitId: 'visit-mock',
              quoteId: quoteId,
              invoiceNumber:
                  'INV-DEMO-${DateTime.now().millisecondsSinceEpoch % 10000}',
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
          return InvoiceModel.fromJson(
            response.data[0] as Map<String, dynamic>,
          );
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
        message:
            'Invoice must have at least one line item before finalization.',
        code: 'INVOICE_EMPTY',
      );
    }

    return await mutate<InvoiceModel>(
      cacheKey: 'invoice_$id',
      apiCall: () async {
        // If another finalized invoice already exists for this visit, reuse it.
        final existingFinalized = await _findReusableInvoice(
          visitId: current.visitId,
          quoteId: current.quoteId,
        );
        if (existingFinalized != null &&
            existingFinalized.id != id &&
            _finalizedStatuses.contains(existingFinalized.status.name)) {
          return existingFinalized;
        }

        final updateData = {
          'status': 'unpaid',
          'updated_at': DateTime.now().toIso8601String(),
        };

        final url = '${ApiEndpoints.restApiBaseFull}/invoices?id=eq.$id';

        try {
          final response = await apiClient.patch(url, data: updateData);

          if (response.data is List && (response.data as List).isNotEmpty) {
            return InvoiceModel.fromJson(
              response.data[0] as Map<String, dynamic>,
            );
          }
          throw Exception('Failed to finalize invoice');
        } catch (e) {
          // Handle race conditions where another device finalized first.
          final racedFinalized = await _findReusableInvoice(
            visitId: current.visitId,
            quoteId: current.quoteId,
          );
          if (racedFinalized != null &&
              racedFinalized.id != id &&
              _finalizedStatuses.contains(racedFinalized.status.name)) {
            return racedFinalized;
          }
          rethrow;
        }
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
  Future<List<PaymentModel>> getInvoicePayments(
    String invoiceId, {
    bool ignoreCache = false,
  }) async {
    return await fetchList<PaymentModel>(
      cacheKey: 'invoice_payments_$invoiceId',
      apiCall: () async {
        final url =
            '${ApiEndpoints.restApiBaseFull}/payments?invoice_id=eq.$invoiceId&select=*&order=created_at.desc';
        final response = await apiClient.get(url);

        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data
              .map(
                (json) => PaymentModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      },
      fromJson: (data) => PaymentModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => InvoiceMockData.getMockPayments(invoiceId)
          : null,
      ignoreCache: ignoreCache,
    );
  }

  /// Resolve user full names for payment audit display.
  Future<Map<String, String>> getUserNamesByIds(List<String> userIds) async {
    if (userIds.isEmpty) return const {};

    final ids = userIds.toSet().toList();
    final url =
        '${ApiEndpoints.restApiBaseFull}/users?id=in.(${ids.join(',')})&select=id,full_name';
    final response = await apiClient.get(url);

    if (response.data is! List) {
      return const {};
    }

    final result = <String, String>{};
    for (final row in (response.data as List)) {
      if (row is Map<String, dynamic>) {
        final id = row['id'] as String?;
        final fullName = row['full_name'] as String?;
        if (id != null && fullName != null && fullName.trim().isNotEmpty) {
          result[id] = fullName.trim();
        }
      }
    }
    return result;
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
          return InvoiceModel.fromJson(
            response.data[0] as Map<String, dynamic>,
          );
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
        final invoice = await getInvoice(invoiceId, ignoreCache: true);
        final existingPayments = await getInvoicePayments(
          invoiceId,
          ignoreCache: true,
        );
        final totalPaid = existingPayments.fold<double>(
          0.0,
          (sum, p) => sum + p.amount,
        );
        final remaining = invoice.total - totalPaid;

        if (invoice.status == InvoiceStatus.draft ||
            invoice.status == InvoiceStatus.void_ ||
            invoice.status == InvoiceStatus.refunded ||
            invoice.status == InvoiceStatus.paid) {
          throw ValidationException(
            message: 'Invoice cannot receive payments in its current state.',
            code: 'INVOICE_PAYMENT_STATE_INVALID',
          );
        }

        if (amount <= 0) {
          throw ValidationException(
            message: 'Payment amount must be greater than zero.',
            code: 'PAYMENT_AMOUNT_INVALID',
          );
        }

        if (amount > remaining) {
          throw ValidationException.paymentExceedsBalanceError(
            remaining > 0 ? remaining : 0.0,
          );
        }

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

        return PaymentModel.fromJson(response.data[0] as Map<String, dynamic>);
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
