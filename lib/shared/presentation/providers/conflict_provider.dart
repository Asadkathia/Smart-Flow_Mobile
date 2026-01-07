import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/conflict_model.dart';

/// Conflict State Model
/// 
/// Tracks conflicts across the application.
class ConflictState {
  final Map<String, ConflictInfo> conflicts; // entityId -> ConflictInfo
  final int totalCount;

  const ConflictState({
    required this.conflicts,
  }) : totalCount = conflicts.length;

  bool get hasConflicts => conflicts.isNotEmpty;

  ConflictState addConflict(String entityId, ConflictInfo conflict) {
    final newConflicts = Map<String, ConflictInfo>.from(conflicts);
    newConflicts[entityId] = conflict;
    return ConflictState(conflicts: newConflicts);
  }

  ConflictState removeConflict(String entityId) {
    final newConflicts = Map<String, ConflictInfo>.from(conflicts);
    newConflicts.remove(entityId);
    return ConflictState(conflicts: newConflicts);
  }

  ConflictState clear() {
    return ConflictState(conflicts: {});
  }
}

/// Conflict State Provider
/// 
/// Manages global conflict state across the application.
final conflictStateManagerProvider = StateNotifierProvider<ConflictStateManager, ConflictState>((ref) {
  return ConflictStateManager();
});

class ConflictStateManager extends StateNotifier<ConflictState> {
  ConflictStateManager() : super(ConflictState(conflicts: {}));

  /// Add a conflict
  void addConflict(String entityId, ConflictInfo conflict) {
    state = state.addConflict(entityId, conflict);
  }

  /// Remove a conflict (after resolution)
  void removeConflict(String entityId) {
    state = state.removeConflict(entityId);
  }

  /// Clear all conflicts
  void clearConflicts() {
    state = state.clear();
  }

  /// Get conflict for a specific entity
  ConflictInfo? getConflict(String entityId) {
    return state.conflicts[entityId];
  }
}

/// Conflict Count Provider
/// 
/// Provides the total number of unresolved conflicts.
final conflictCountProvider = Provider<int>((ref) {
  final conflictState = ref.watch(conflictStateManagerProvider);
  return conflictState.totalCount;
});

