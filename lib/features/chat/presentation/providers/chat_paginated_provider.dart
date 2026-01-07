import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_models.dart';
import '../../data/repositories/chat_repository.dart';

/// Paginated Chat Threads List Notifier
/// 
/// Manages paginated chat threads list state with load more functionality.
class PaginatedChatThreadsListNotifier extends StateNotifier<AsyncValue<List<ChatThreadModel>>> {
  final ChatRepository _repository;
  final int _pageSize;
  int _currentPage = 1;
  bool _hasMore = true;

  PaginatedChatThreadsListNotifier(
    this._repository,
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
      final threads = await _repository.getChatThreads(
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        // First page - replace data
        state = AsyncValue.data(threads);
      } else {
        // Subsequent pages - append data
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, ...threads]);
      }

      _currentPage = page;
      _hasMore = threads.length >= _pageSize;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Load more threads (next page)
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

/// Paginated Chat Threads List Provider
final paginatedChatThreadsListProvider = StateNotifierProvider<PaginatedChatThreadsListNotifier, AsyncValue<List<ChatThreadModel>>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return PaginatedChatThreadsListNotifier(repository, 20);
});



