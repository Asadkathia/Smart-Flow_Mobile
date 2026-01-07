import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inventory_item_model.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Inventory List Provider
/// 
/// Provides the list of all inventory items.
final inventoryListProvider = FutureProvider.autoDispose<List<InventoryItemModel>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryItems();
});

/// Filtered Inventory List Provider
/// 
/// Provides filtered inventory items based on category and search query.
final filteredInventoryProvider = FutureProvider.autoDispose.family<List<InventoryItemModel>, InventoryFilter>((ref, filter) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  
  if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
    return repository.searchInventoryItems(filter.searchQuery!);
  }
  
  return repository.getInventoryItems(
    category: filter.category,
    isActive: filter.isActive,
  );
});

/// Inventory Item Detail Provider
/// 
/// Provides a single inventory item by ID.
final inventoryItemProvider = FutureProvider.autoDispose.family<InventoryItemModel, String>((ref, id) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryItem(id);
});

/// Inventory Actions Provider
/// 
/// Handles inventory item creation, update, and deletion.
class InventoryActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final InventoryRepository _repository;
  final Ref _ref;

  InventoryActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Create inventory item manually
  Future<InventoryItemModel?> createItem({
    required String name,
    required String unit,
    required double price,
    String? sku,
    String? category,
    String? description,
    File? image,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Get orgId from auth provider
      final authState = _ref.read(authProvider);
      final orgId = authState.user?.orgId;
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      final item = await _repository.createInventoryItem(
        orgId: orgId,
        name: name,
        unit: unit,
        price: price,
        sku: sku,
        category: category,
        description: description,
        image: image,
      );
      state = const AsyncValue.data(null);
      
      // Refresh inventory list
      _ref.invalidate(inventoryListProvider);
      
      return item;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Create inventory item with AI auto-detection
  Future<InventoryItemModel?> createItemWithAI({
    required File image,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Get orgId from auth provider
      final authState = _ref.read(authProvider);
      final orgId = authState.user?.orgId;
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      final item = await _repository.createInventoryItemWithAI(
        orgId: orgId,
        image: image,
      );
      state = const AsyncValue.data(null);
      
      // Refresh inventory list
      _ref.invalidate(inventoryListProvider);
      
      return item;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Get AI price suggestion
  Future<AiPriceSuggestion?> getAiPriceSuggestion({
    required File image,
    String? itemName,
  }) async {
    try {
      return await _repository.getAiPriceSuggestion(
        image: image,
        itemName: itemName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Update inventory item
  Future<bool> updateItem({
    required String id,
    String? name,
    String? unit,
    double? price,
    String? sku,
    String? category,
    String? description,
    bool? isActive,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Get orgId from auth provider
      final authState = _ref.read(authProvider);
      final orgId = authState.user?.orgId;
      if (orgId == null) {
        throw Exception('Organization ID not found');
      }

      await _repository.updateInventoryItem(
        id: id,
        orgId: orgId,
        name: name,
        unit: unit,
        price: price,
        sku: sku,
        category: category,
        description: description,
        isActive: isActive,
      );
      state = const AsyncValue.data(null);
      
      // Refresh inventory list and item detail
      _ref.invalidate(inventoryListProvider);
      _ref.invalidate(inventoryItemProvider(id));
      
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Delete inventory item
  Future<bool> deleteItem(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteInventoryItem(id);
      state = const AsyncValue.data(null);
      
      // Refresh inventory list
      _ref.invalidate(inventoryListProvider);
      _ref.invalidate(inventoryItemProvider(id));
      
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final inventoryActionsProvider = StateNotifierProvider<InventoryActionsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(inventoryRepositoryProvider);
  return InventoryActionsNotifier(repository, ref);
});

/// Inventory Filter Model
class InventoryFilter {
  final String? category;
  final bool? isActive;
  final String? searchQuery;

  const InventoryFilter({
    this.category,
    this.isActive,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryFilter &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          isActive == other.isActive &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode => category.hashCode ^ isActive.hashCode ^ searchQuery.hashCode;
}

/// Inventory Filter State Provider
final inventoryFilterProvider = StateProvider.autoDispose<InventoryFilter>((ref) {
  return const InventoryFilter();
});

