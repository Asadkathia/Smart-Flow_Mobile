import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quote_model.dart';
import '../../data/repositories/quote_repository.dart';

/// Paginated Quotes List Notifier
/// 
/// Manages paginated quotes list state with load more functionality.
class PaginatedQuotesListNotifier extends StateNotifier<AsyncValue<List<QuoteModel>>> {
  final QuoteRepository _repository;
  final String? _visitId;
  final QuoteStatus? _status;
  final int _pageSize;
  int _currentPage = 1;
  bool _hasMore = true;

  PaginatedQuotesListNotifier(
    this._repository,
    this._visitId,
    this._status,
    this._pageSize,
  ) : super(const AsyncValue.loading()) {
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    try {
      final quotes = await _repository.getQuotes(
        visitId: _visitId,
        status: _status,
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        // First page - replace data
        state = AsyncValue.data(quotes);
      } else {
        // Subsequent pages - append data
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, ...quotes]);
      }

      _currentPage = page;
      _hasMore = quotes.length >= _pageSize;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Load more quotes (next page)
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

/// Paginated Quotes List Provider Factory
/// 
/// Creates a provider for paginated quotes list with optional visitId and status filter.
/// Uses a simple string key format: "visitId_status" or "all_all" for all quotes
final paginatedQuotesListProvider = StateNotifierProvider.family<
    PaginatedQuotesListNotifier,
    AsyncValue<List<QuoteModel>>,
    String>((ref, key) {
  final repository = ref.watch(quoteRepositoryProvider);
  // Parse key: format is "visitId_status" or "all_all" for all quotes
  final parts = key.split('_');
  final visitId = parts[0] == 'all' ? null : parts[0];
  final status = parts.length > 1 && parts[1] != 'all'
      ? QuoteStatus.values.firstWhere((s) => s.name == parts[1], orElse: () => QuoteStatus.draft)
      : null;
  return PaginatedQuotesListNotifier(repository, visitId, status, 20);
});

