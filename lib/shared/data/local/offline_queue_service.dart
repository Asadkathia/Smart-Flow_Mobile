import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/constants/app_constants.dart';

/// Pending Action Types
enum PendingActionType {
  startVisit,
  pauseVisit,
  completeVisit,
  addNote,
  updateNote,
  deleteNote,
  uploadMedia,
  deleteMedia,
  addSignature,
  createQuote,
  updateQuote,
  deleteQuote,
  addInventory,
  updateInventory,
  deleteInventory,
  createInvoice,
  updateInvoice,
  finalizeInvoice,
  voidInvoice,
  sendMessage,
  updateBillingSettings,
}

/// Action Priority Levels
enum ActionPriority {
  critical, // Visit completion, signature upload
  high,     // Visit state changes, quote finalization
  normal,   // Notes, media uploads
  low,      // Updates, deletions
}

/// Extension to get priority for action types
extension PendingActionTypePriority on PendingActionType {
  ActionPriority get priority {
    switch (this) {
      case PendingActionType.completeVisit:
      case PendingActionType.addSignature:
        return ActionPriority.critical;
      case PendingActionType.startVisit:
      case PendingActionType.pauseVisit:
      case PendingActionType.finalizeInvoice:
      case PendingActionType.createInvoice:
        return ActionPriority.high;
      case PendingActionType.addNote:
      case PendingActionType.uploadMedia:
      case PendingActionType.createQuote:
      case PendingActionType.updateQuote:
      case PendingActionType.deleteQuote:
        return ActionPriority.normal;
      default:
        return ActionPriority.low;
    }
  }
}

/// Pending Action Model
/// 
/// Represents an action that needs to be synced when online.
class PendingAction {
  final String id;
  final PendingActionType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final String? errorMessage;

  PendingAction({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.errorMessage,
  });

  /// Get priority for this action
  ActionPriority get priority => type.priority;

  /// Create a copy with updated retry count
  PendingAction incrementRetry([String? error]) {
    return PendingAction(
      id: id,
      type: type,
      data: data,
      timestamp: timestamp,
      retryCount: retryCount + 1,
      errorMessage: error,
    );
  }

  /// Check if max retries exceeded
  bool get hasExceededMaxRetries => retryCount >= AppConstants.maxRetryAttempts;

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
    'errorMessage': errorMessage,
  };

  /// Create from JSON
  factory PendingAction.fromJson(Map<String, dynamic> json) => PendingAction(
    id: json['id'] as String,
    type: PendingActionType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => PendingActionType.addNote,
    ),
    data: Map<String, dynamic>.from(json['data'] as Map),
    timestamp: DateTime.parse(json['timestamp'] as String),
    retryCount: json['retryCount'] as int? ?? 0,
    errorMessage: json['errorMessage'] as String?,
  );
}

/// Offline Queue Service
/// 
/// Manages a queue of pending actions that need to be synced when online.
/// Uses Hive for persistent storage.
/// 
/// Per PRD: Maximum queue size is 1000 operations.
class OfflineQueueService {
  static const String _boxName = StorageKeys.offlineQueueBox;
  static const int maxQueueSize = 1000; // Per PRD requirement
  Box<Map>? _box;

  /// Initialize the queue storage
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox<Map>(_boxName);
  }

  /// Ensure box is initialized
  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await initialize();
    }
  }

  /// Add an action to the queue
  /// 
  /// If queue is full (1000 operations), removes oldest low-priority actions first.
  /// Per PRD: Maximum queue size is 1000 operations.
  Future<void> addAction(PendingAction action) async {
    await _ensureInitialized();
    
    // Check if queue is full
    final currentCount = _box?.length ?? 0;
    if (currentCount >= maxQueueSize) {
      // Remove oldest low-priority actions first (FIFO)
      await _removeOldestLowPriorityActions();
    }
    
    await _box?.put(action.id, action.toJson());
  }

  /// Remove oldest low-priority actions when queue is full
  Future<void> _removeOldestLowPriorityActions() async {
    final allActions = await getActions();
    
    // Sort by priority (low first), then timestamp (oldest first)
    allActions.sort((a, b) {
      final priorityCompare = a.priority.index.compareTo(b.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return a.timestamp.compareTo(b.timestamp);
    });
    
    // Remove oldest low-priority actions until we have space
    final toRemove = allActions
        .where((a) => a.priority == ActionPriority.low)
        .take(allActions.length - maxQueueSize + 1)
        .toList();
    
    for (final action in toRemove) {
      await removeAction(action.id);
    }
    
    // If still full, remove oldest normal-priority actions
    if ((_box?.length ?? 0) >= maxQueueSize) {
      final remainingActions = await getActions();
      remainingActions.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      final toRemoveNormal = remainingActions
          .where((a) => a.priority == ActionPriority.normal)
          .take(remainingActions.length - maxQueueSize + 1)
          .toList();
      
      for (final action in toRemoveNormal) {
        await removeAction(action.id);
      }
    }
  }

  /// Get all pending actions (sorted by priority, then timestamp)
  /// 
  /// Critical actions are processed first, then high, normal, and low priority.
  /// Within each priority level, oldest actions are processed first.
  Future<List<PendingAction>> getActions() async {
    await _ensureInitialized();
    
    final actions = _box?.values.map((json) {
      return PendingAction.fromJson(Map<String, dynamic>.from(json));
    }).toList() ?? [];

    // Sort by priority (critical first), then timestamp (oldest first)
    actions.sort((a, b) {
      final priorityCompare = a.priority.index.compareTo(b.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      return a.timestamp.compareTo(b.timestamp);
    });
    
    return actions;
  }

  /// Check if queue is full
  Future<bool> get isQueueFull async {
    return await count >= maxQueueSize;
  }

  /// Get pending actions by type
  Future<List<PendingAction>> getActionsByType(PendingActionType type) async {
    final allActions = await getActions();
    return allActions.where((a) => a.type == type).toList();
  }

  /// Get action by ID
  Future<PendingAction?> getAction(String id) async {
    await _ensureInitialized();
    final json = _box?.get(id);
    if (json == null) return null;
    return PendingAction.fromJson(Map<String, dynamic>.from(json));
  }

  /// Update an action (e.g., increment retry count)
  Future<void> updateAction(PendingAction action) async {
    await _ensureInitialized();
    await _box?.put(action.id, action.toJson());
  }

  /// Remove an action from the queue
  Future<void> removeAction(String id) async {
    await _ensureInitialized();
    await _box?.delete(id);
  }

  /// Clear all actions from the queue
  Future<void> clear() async {
    await _ensureInitialized();
    await _box?.clear();
  }

  /// Get count of pending actions
  Future<int> get count async {
    await _ensureInitialized();
    return _box?.length ?? 0;
  }

  /// Check if queue is empty
  Future<bool> get isEmpty async {
    return await count == 0;
  }

  /// Check if queue has pending actions
  Future<bool> get hasPendingActions async {
    return await count > 0;
  }

  /// Get actions that haven't exceeded max retries
  Future<List<PendingAction>> getRetryableActions() async {
    final allActions = await getActions();
    return allActions.where((a) => !a.hasExceededMaxRetries).toList();
  }

  /// Get failed actions (exceeded max retries)
  Future<List<PendingAction>> getFailedActions() async {
    final allActions = await getActions();
    return allActions.where((a) => a.hasExceededMaxRetries).toList();
  }

  /// Close the box
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}

/// Offline Queue Service Provider
final offlineQueueServiceProvider = Provider<OfflineQueueService>((ref) {
  final service = OfflineQueueService();
  ref.onDispose(() => service.close());
  return service;
});

/// Pending Actions Count Provider
final pendingActionsCountProvider = FutureProvider<int>((ref) async {
  final queue = ref.watch(offlineQueueServiceProvider);
  return queue.count;
});

/// Has Pending Actions Provider
final hasPendingActionsProvider = FutureProvider<bool>((ref) async {
  final queue = ref.watch(offlineQueueServiceProvider);
  return queue.hasPendingActions;
});

