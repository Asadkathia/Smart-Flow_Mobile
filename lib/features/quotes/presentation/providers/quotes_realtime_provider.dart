import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quote_model.dart';

/// Quote Real-time Provider
/// 
/// Manages real-time updates for quotes using Supabase Realtime.
/// 
/// Per PRD Section 29.3: Real-time updates via Supabase Realtime channels.
/// Channel structure: `quotes:{visit_id}` for visit-specific quote updates.
/// 
/// Phase 2: Will integrate with Supabase Realtime when backend is ready.
class QuotesRealtimeNotifier extends StateNotifier<List<QuoteModel>> {
  QuotesRealtimeNotifier() : super([]);

  /// Connect to real-time channel for a visit
  /// 
  /// Phase 2: Implement Supabase Realtime subscription
  /// Example: supabase.channel('quotes:${visitId}').on('postgres_changes', ...)
  Future<void> connect(String visitId) async {
    // TODO (Phase 2): Connect to Supabase Realtime channel
    // Channel: quotes:{visit_id}
    // Events: INSERT, UPDATE
    // Filter: visit_id = {visitId}
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    // TODO (Phase 2): Disconnect from Supabase Realtime channel
  }

  /// Handle quote status change
  void _handleQuoteStatusChange(QuoteModel quote) {
    final index = state.indexWhere((q) => q.id == quote.id);
    if (index >= 0) {
      state = [...state]..[index] = quote;
    } else {
      state = [...state, quote];
    }
  }
}

/// Quotes Real-time Provider
final quotesRealtimeProvider = StateNotifierProvider<QuotesRealtimeNotifier, List<QuoteModel>>((ref) {
  return QuotesRealtimeNotifier();
});

/// Connection Status Provider
final quotesRealtimeConnectionStatusProvider = Provider<bool>((ref) {
  // TODO (Phase 2): Track actual connection status
  return false;
});


