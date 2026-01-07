import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/visit_model.dart';

/// Visit Real-time Provider
/// 
/// Manages real-time updates for visits using Supabase Realtime.
/// 
/// Per PRD Section 29.3: Real-time updates via Supabase Realtime channels.
/// Channel structure: `visits:{org_id}` for organization-wide updates.
/// 
/// Phase 2: Will integrate with Supabase Realtime when backend is ready.
class VisitsRealtimeNotifier extends StateNotifier<List<VisitModel>> {
  VisitsRealtimeNotifier() : super([]);

  /// Connect to real-time channel
  /// 
  /// Phase 2: Implement Supabase Realtime subscription
  /// Example: supabase.channel('visits:${orgId}').on('postgres_changes', ...)
  Future<void> connect(String orgId) async {
    // TODO (Phase 2): Connect to Supabase Realtime channel
    // Channel: visits:{org_id}
    // Events: INSERT, UPDATE, DELETE
    // Filter: org_id = {orgId}
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    // TODO (Phase 2): Disconnect from Supabase Realtime channel
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

  /// Handle visit assignment update
  void _handleVisitAssignment(VisitModel visit) {
    _handleVisitStatusChange(visit);
  }
}

/// Visits Real-time Provider
final visitsRealtimeProvider = StateNotifierProvider<VisitsRealtimeNotifier, List<VisitModel>>((ref) {
  return VisitsRealtimeNotifier();
});

/// Connection Status Provider
final visitsRealtimeConnectionStatusProvider = Provider<bool>((ref) {
  // TODO (Phase 2): Track actual connection status
  return false;
});


