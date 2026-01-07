import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inventory_item_model.dart';
import '../../data/repositories/inventory_repository.dart';

/// Paginated Inventory List Notifier
/// 
/// Manages paginated inventory list state with load more functionality.
class PaginatedInventoryListNotifier extends StateNotifier<AsyncValue<List<InventoryItemModel>>> {
  final InventoryRepository _repository;
  final String? _category;
  final bool? _isActive;
  final int _pageSize;
  int _currentPage = 1;
  bool _hasMore = true;

  PaginatedInventoryListNotifier(
    this._repository,
    this._category,
    this._isActive,
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
      final items = await _repository.getInventoryItems(
        category: _category,
        isActive: _isActive,
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        // First page - replace data
        state = AsyncValue.data(items);
      } else {
        // Subsequent pages - append data
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, ...items]);
      }

      _currentPage = page;
      _hasMore = items.length >= _pageSize;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Load more items (next page)
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

/// Paginated Inventory List Provider Factory
/// 
/// Creates a provider for paginated inventory list with optional category and active filter.
/// Uses a string key format: "category_isActive" or "all_all" for all items
final paginatedInventoryListProvider = StateNotifierProvider.family<
    PaginatedInventoryListNotifier,
    AsyncValue<List<InventoryItemModel>>,
    String>((ref, key) {
  final repository = ref.watch(inventoryRepositoryProvider);
  // Parse key: format is "category_isActive" or "all_all" for all items
  final parts = key.split('_');
  final category = parts[0] == 'all' ? null : parts[0];
  final isActive = parts.length > 1 && parts[1] != 'all'
      ? (parts[1] == 'true')
      : null;
  return PaginatedInventoryListNotifier(repository, category, isActive, 20);
});

