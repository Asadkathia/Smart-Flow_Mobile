import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/invoice_model.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../../../shared/data/models/pagination_model.dart';

/// Paginated Invoice List Notifier
/// 
/// Manages paginated invoice list state with load more functionality.
/// This is a framework-ready implementation that will be fully functional
/// once backend pagination endpoints are available.
class PaginatedInvoiceListNotifier extends StateNotifier<AsyncValue<List<InvoiceModel>>> {
  final InvoiceRepository _repository;
  final InvoiceStatus? _status;
  final int _pageSize;
  int _currentPage = 1;
  bool _hasMore = true;

  PaginatedInvoiceListNotifier(
    this._repository,
    this._status,
    this._pageSize,
  ) : super(const AsyncValue.loading()) {
    // Don't set loading state here - _loadPage will set it
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    // Remove the guard - we want to load even if already loading (for initial load)
    // Only skip if we're already loading AND it's not the first page
    if (state.isLoading && page != 1) return;

    state = const AsyncValue.loading();
    try {
      final invoices = await _repository.getInvoices(
        status: _status,
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        // First page - replace data
        state = AsyncValue.data(invoices);
      } else {
        // Subsequent pages - append data
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, ...invoices]);
      }

      _currentPage = page;
      _hasMore = invoices.length >= _pageSize;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Load more invoices (next page)
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    await _loadPage(_currentPage + 1);
  }

  /// Refresh the list (reset to page 1)
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    await _loadPage(1);
  }

  /// Check if can load more
  bool get canLoadMore => _hasMore && !state.isLoading;
}

/// Paginated Invoice List Provider Factory
/// 
/// Creates a provider for paginated invoice list with status filter.
final paginatedInvoiceListProvider = StateNotifierProvider.family<
    PaginatedInvoiceListNotifier,
    AsyncValue<List<InvoiceModel>>,
    InvoiceStatus?>((ref, status) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return PaginatedInvoiceListNotifier(repository, status, 20);
});

