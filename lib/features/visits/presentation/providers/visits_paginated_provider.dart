import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/visit_model.dart';
import '../../data/repositories/visit_repository.dart';

/// Paginated Visits List Notifier
/// 
/// Manages paginated visits list state with load more functionality.
class PaginatedVisitsListNotifier extends StateNotifier<AsyncValue<List<VisitModel>>> {
  final VisitRepository _repository;
  final int _pageSize;
  int _currentPage = 1;
  bool _hasMore = true;

  PaginatedVisitsListNotifier(
    this._repository,
    this._pageSize,
  ) : super(const AsyncValue.loading()) {
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    try {
      final visits = await _repository.getTodayVisits(
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        // First page - replace data
        state = AsyncValue.data(visits);
      } else {
        // Subsequent pages - append data
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, ...visits]);
      }

      _currentPage = page;
      _hasMore = visits.length >= _pageSize;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Load more visits (next page)
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

/// Paginated Visits List Provider
final paginatedVisitsListProvider = StateNotifierProvider<PaginatedVisitsListNotifier, AsyncValue<List<VisitModel>>>((ref) {
  final repository = ref.watch(visitRepositoryProvider);
  return PaginatedVisitsListNotifier(repository, 20);
});



