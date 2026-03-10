import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/quote_model.dart';
import '../../../../core/services/supabase_realtime_service.dart';
import '../../../../core/services/logger.dart';

/// Quote Real-time Provider
///
/// Manages real-time updates for quotes using Supabase Realtime.
///
/// Per PRD Section 29.3: Real-time updates via Supabase Realtime channels.
/// Channel structure: `quotes:{visit_id}` for visit-specific quote updates.
class QuotesRealtimeNotifier extends StateNotifier<List<QuoteModel>> {
  final SupabaseRealtimeService _realtimeService;
  String? _currentVisitId;
  bool _isConnected = false;

  QuotesRealtimeNotifier(this._realtimeService) : super([]);

  /// Connect to real-time channel for a visit
  ///
  /// Subscribes to quote updates for a specific visit.
  /// Channel: quotes:{visit_id}
  /// Events: INSERT, UPDATE
  /// Filter: visit_id = {visitId}
  Future<void> connect(String visitId) async {
    if (_isConnected && _currentVisitId == visitId) {
      Logger.debug('Quotes Realtime: Already connected to visit $visitId');
      return;
    }

    // Disconnect from previous channel if different visit
    if (_isConnected && _currentVisitId != visitId) {
      await disconnect();
    }

    try {
      final channelName = 'quotes:$visitId';

      await _realtimeService.subscribeToQuotes(visitId, (data) {
        try {
          final quote = QuoteModel.fromJson(data);
          _handleQuoteStatusChange(quote);
          Logger.debug('Quotes Realtime: Quote changed - ${quote.id}');
        } catch (e, stackTrace) {
          Logger.error(
            'Quotes Realtime: Error handling change event',
            e,
            stackTrace,
          );
        }
      });

      _currentVisitId = visitId;
      _isConnected = true;
      Logger.info('Quotes Realtime: Connected to $channelName');
    } catch (e, stackTrace) {
      Logger.error('Quotes Realtime: Connection failed', e, stackTrace);
      _isConnected = false;
    }
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    if (!_isConnected || _currentVisitId == null) {
      return;
    }

    try {
      final channelName = 'quotes:$_currentVisitId';
      await _realtimeService.unsubscribe(channelName);

      _currentVisitId = null;
      _isConnected = false;
      Logger.info('Quotes Realtime: Disconnected from $channelName');
    } catch (e, stackTrace) {
      Logger.error('Quotes Realtime: Disconnection failed', e, stackTrace);
    }
  }

  /// Get connection status
  bool get isConnected => _isConnected;

  /// Get current visit ID
  String? get currentVisitId => _currentVisitId;

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
final quotesRealtimeProvider =
    StateNotifierProvider<QuotesRealtimeNotifier, List<QuoteModel>>((ref) {
      final realtimeService = ref.watch(supabaseRealtimeServiceProvider);
      return QuotesRealtimeNotifier(realtimeService);
    });

/// Connection Status Provider
final quotesRealtimeConnectionStatusProvider = Provider<bool>((ref) {
  final notifier = ref.watch(quotesRealtimeProvider.notifier);
  return notifier.isConnected;
});
