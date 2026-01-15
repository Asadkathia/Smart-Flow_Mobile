import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quote_model.dart';
import '../../data/repositories/quote_repository.dart';
import 'quotes_paginated_provider.dart';

/// Quote Detail Provider
/// 
/// Provides a single quote by ID.
final quoteDetailProvider = FutureProvider.autoDispose.family<QuoteModel, String>((ref, id) async {
  final repository = ref.watch(quoteRepositoryProvider);
  return repository.getQuote(id);
});

/// Quote Actions Provider
/// 
/// Handles quote finalization and deletion.
class QuoteActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final QuoteRepository _repository;
  final Ref _ref;

  QuoteActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Finalize a quote
  Future<QuoteModel?> finalize(String id) async {
    state = const AsyncValue.loading();
    try {
      final quote = await _repository.finalizeQuote(id);
      state = const AsyncValue.data(null);
      
      // Refresh quote detail and lists
      _ref.invalidate(quoteDetailProvider(id));
      _ref.invalidate(paginatedQuotesListProvider('all_all'));
      
      return quote;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Delete a quote (only draft quotes can be deleted)
  Future<bool> delete(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteQuote(id);
      state = const AsyncValue.data(null);
      
      // Refresh quote lists
      _ref.invalidate(paginatedQuotesListProvider('all_all'));
      
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

final quoteActionsProvider = StateNotifierProvider<QuoteActionsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(quoteRepositoryProvider);
  return QuoteActionsNotifier(repository, ref);
});
