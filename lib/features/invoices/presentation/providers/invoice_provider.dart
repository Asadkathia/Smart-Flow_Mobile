import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/invoice_model.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Invoice List Provider
///
/// Provides the list of all invoices.
final invoiceListProvider = FutureProvider.autoDispose<List<InvoiceModel>>((
  ref,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getInvoices();
});

/// Filtered Invoice List Provider
///
/// Provides filtered invoices based on status.
final filteredInvoiceProvider = FutureProvider.autoDispose
    .family<List<InvoiceModel>, InvoiceStatus?>((ref, status) async {
      final repository = ref.watch(invoiceRepositoryProvider);
      return repository.getInvoices(status: status);
    });

/// Draft Invoices Provider
///
/// Provides draft invoices only.
final draftInvoicesProvider = FutureProvider.autoDispose<List<InvoiceModel>>((
  ref,
) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getDraftInvoices();
});

/// Invoice Detail Provider
///
/// Provides a single invoice by ID.
final invoiceDetailProvider = FutureProvider.autoDispose
    .family<InvoiceModel, String>((ref, id) async {
      final repository = ref.watch(invoiceRepositoryProvider);
      return repository.getInvoice(id);
    });

/// Invoice Payments Provider
///
/// Provides payments for a specific invoice.
final invoicePaymentsProvider = FutureProvider.autoDispose
    .family<List<PaymentModel>, String>((ref, invoiceId) async {
      final repository = ref.watch(invoiceRepositoryProvider);
      return repository.getInvoicePayments(invoiceId, ignoreCache: true);
    });

/// Collector names for payments on a specific invoice.
/// Maps user_id -> full_name for audit-friendly invoice preview display.
final invoicePaymentCollectorsProvider = FutureProvider.autoDispose
    .family<Map<String, String>, String>((ref, invoiceId) async {
      final repository = ref.watch(invoiceRepositoryProvider);
      final payments = await repository.getInvoicePayments(
        invoiceId,
        ignoreCache: true,
      );
      final userIds = payments.map((p) => p.receivedBy).toSet().toList();
      return repository.getUserNamesByIds(userIds);
    });

/// Invoice Actions Provider
///
/// Handles invoice creation, update, and finalization.
class InvoiceActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final InvoiceRepository _repository;
  final Ref _ref;

  InvoiceActionsNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  /// Create draft invoice from quote
  Future<InvoiceModel?> createDraftFromQuote(String quoteId) async {
    state = const AsyncValue.loading();
    try {
      // Get orgId from auth provider
      final authState = _ref.read(authProvider);
      final orgId = authState.user?.orgId;
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      final invoice = await _repository.createDraftInvoiceFromQuote(
        quoteId: quoteId,
        orgId: orgId,
      );
      state = const AsyncValue.data(null);

      // Refresh invoice lists
      _ref.invalidate(invoiceListProvider);
      _ref.invalidate(draftInvoicesProvider);

      return invoice;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Update draft invoice
  Future<bool> updateDraft({
    required String id,
    List<dynamic>? lineItems,
    String? notes,
    DateTime? dueDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateDraftInvoice(
        id: id,
        lineItems: lineItems,
        notes: notes,
        dueDate: dueDate,
      );
      state = const AsyncValue.data(null);

      // Refresh invoice detail and lists
      _ref.invalidate(invoiceDetailProvider(id));
      _ref.invalidate(invoiceListProvider);
      _ref.invalidate(draftInvoicesProvider);

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Finalize draft invoice (changes status from draft to unpaid)
  Future<InvoiceModel?> finalize(String id) async {
    state = const AsyncValue.loading();
    try {
      final invoice = await _repository.finalizeInvoice(id);
      state = const AsyncValue.data(null);

      // Refresh invoice detail and lists
      _ref.invalidate(invoiceDetailProvider(id));
      _ref.invalidate(invoiceListProvider);
      _ref.invalidate(draftInvoicesProvider);
      _ref.invalidate(filteredInvoiceProvider(InvoiceStatus.unpaid));

      return invoice;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Void an unpaid invoice
  Future<bool> voidInvoice(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.voidInvoice(id);
      state = const AsyncValue.data(null);

      // Refresh invoice detail and lists
      _ref.invalidate(invoiceDetailProvider(id));
      _ref.invalidate(invoiceListProvider);
      _ref.invalidate(filteredInvoiceProvider(InvoiceStatus.unpaid));
      _ref.invalidate(filteredInvoiceProvider(InvoiceStatus.void_));

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Record payment for invoice
  Future<PaymentModel?> recordPayment({
    required String invoiceId,
    required double amount,
    required PaymentMethod method,
    String? reference,
  }) async {
    state = const AsyncValue.loading();
    try {
      final authState = _ref.read(authProvider);
      final orgId = authState.user?.orgId;
      final userId = authState.user?.id;

      if (orgId == null || userId == null) {
        throw Exception('User session invalid');
      }

      final payment = await _repository.recordPayment(
        invoiceId: invoiceId,
        orgId: orgId,
        amount: amount,
        method: method,
        receivedBy: userId,
        reference: reference,
      );

      state = const AsyncValue.data(null);

      // Invalidate providers to refresh UI
      _ref.invalidate(invoiceDetailProvider(invoiceId));
      _ref.invalidate(invoicePaymentsProvider(invoiceId));
      _ref.invalidate(invoiceListProvider);

      return payment;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final invoiceActionsProvider =
    StateNotifierProvider<InvoiceActionsNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(invoiceRepositoryProvider);
      return InvoiceActionsNotifier(repository, ref);
    });

/// Invoice Filter State Provider
///
/// Manages the current filter state for the invoice list.
final invoiceFilterProvider = StateProvider.autoDispose<InvoiceStatus?>(
  (ref) => null,
);
