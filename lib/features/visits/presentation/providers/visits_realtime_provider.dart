import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/visit_model.dart';
import '../../../../core/services/supabase_realtime_service.dart';
import '../../../../core/services/logger.dart';

/// Visit Real-time Provider
///
/// Manages real-time updates for visits using Supabase Realtime.
///
/// Per PRD Section 29.3: Real-time updates via Supabase Realtime channels.
/// Channel structure: `visits:{org_id}` for organization-wide updates.
class VisitsRealtimeNotifier extends StateNotifier<List<VisitModel>> {
  final SupabaseRealtimeService _realtimeService;
  String? _currentOrgId;
  bool _isConnected = false;

  VisitsRealtimeNotifier(this._realtimeService) : super([]);

  /// Connect to real-time channel
  ///
  /// Subscribes to visit updates for the organization.
  /// Channel: visits:{org_id}
  /// Events: INSERT, UPDATE, DELETE
  /// Filter: org_id = {orgId}
  Future<void> connect(String orgId) async {
    if (_isConnected && _currentOrgId == orgId) {
      Logger.debug('Visits Realtime: Already connected to org $orgId');
      return;
    }

    // Disconnect from previous channel if different org
    if (_isConnected && _currentOrgId != orgId) {
      await disconnect();
    }

    try {
      final channelName = 'visits:$orgId';

      await _realtimeService.subscribeToVisits(orgId, (data) {
        try {
          final visit = VisitModel.fromJson(data);
          _handleVisitStatusChange(visit);
          Logger.debug('Visits Realtime: Visit changed - ${visit.id}');
        } catch (e, stackTrace) {
          Logger.error(
            'Visits Realtime: Error handling change event',
            e,
            stackTrace,
          );
        }
      });

      _currentOrgId = orgId;
      _isConnected = true;
      Logger.info('Visits Realtime: Connected to $channelName');
    } catch (e, stackTrace) {
      Logger.error('Visits Realtime: Connection failed', e, stackTrace);
      _isConnected = false;
    }
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    if (!_isConnected || _currentOrgId == null) {
      return;
    }

    try {
      final channelName = 'visits:$_currentOrgId';
      await _realtimeService.unsubscribe(channelName);

      _currentOrgId = null;
      _isConnected = false;
      Logger.info('Visits Realtime: Disconnected from $channelName');
    } catch (e, stackTrace) {
      Logger.error('Visits Realtime: Disconnection failed', e, stackTrace);
    }
  }

  /// Handle visit status change
  void _handleVisitStatusChange(VisitModel visit) {
    final index = state.indexWhere((v) => v.id == visit.id);
    if (index >= 0) {
      state = [...state]..[index] = visit;
    } else {
      state = [...state, visit];
    }
  }

  /// Get connection status
  bool get isConnected => _isConnected;

  /// Get current organization ID
  String? get currentOrgId => _currentOrgId;
}

/// Visits Real-time Provider
final visitsRealtimeProvider =
    StateNotifierProvider<VisitsRealtimeNotifier, List<VisitModel>>((ref) {
      final realtimeService = ref.watch(supabaseRealtimeServiceProvider);
      return VisitsRealtimeNotifier(realtimeService);
    });

/// Connection Status Provider
final visitsRealtimeConnectionStatusProvider = Provider<bool>((ref) {
  final notifier = ref.watch(visitsRealtimeProvider.notifier);
  return notifier.isConnected;
});
