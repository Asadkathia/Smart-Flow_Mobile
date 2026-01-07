import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../remote/api_client.dart';
import 'offline_queue_service.dart';

/// Sync Processor
/// 
/// Processes pending actions from the offline queue when online.
/// Handles retries with exponential backoff, error recovery, and conflict resolution.
class SyncProcessor {
  final OfflineQueueService _offlineQueue;
  final ApiClient _apiClient;
  bool _isSyncing = false;

  SyncProcessor(
    this._offlineQueue,
    this._apiClient,
  );

  /// Process all pending actions in the queue
  /// 
  /// Uses exponential backoff for retries and processes actions by priority.
  Future<SyncResult> processQueue() async {
    if (_isSyncing) {
      // Already syncing, return current status
      return await getCurrentSyncResult();
    }

    _isSyncing = true;
    try {
      // Get actions sorted by priority (critical first)
      final actions = await _offlineQueue.getActions();
      if (actions.isEmpty) {
        return SyncResult(successCount: 0, failureCount: 0, errors: []);
      }

      int successCount = 0;
      int failureCount = 0;
      final List<String> errors = [];

      for (var action in actions) {
        // Skip actions that have exceeded max retries
        if (action.hasExceededMaxRetries) {
          failureCount++;
          errors.add('${action.type.name}: ${action.errorMessage ?? "Max retries exceeded"}');
          continue;
        }

        try {
          // Apply exponential backoff delay for retries
          if (action.retryCount > 0) {
            final delay = _calculateBackoffDelay(action.retryCount);
            await Future.delayed(delay);
          }

          await _processAction(action);
          await _offlineQueue.removeAction(action.id);
          successCount++;
        } catch (e) {
          final error = ErrorHandler.handleToString(e);
          
          // Increment retry count
          final updatedAction = action.incrementRetry(error);
          await _offlineQueue.updateAction(updatedAction);

          if (updatedAction.hasExceededMaxRetries) {
            failureCount++;
            errors.add('${action.type.name}: ${error}');
          }
        }
      }

      return SyncResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Calculate exponential backoff delay
  /// 
  /// Formula: min(2^retryCount seconds, 30 seconds)
  Duration _calculateBackoffDelay(int retryCount) {
    final seconds = (1 << retryCount).clamp(1, 30);
    return Duration(seconds: seconds);
  }

  /// Get current sync result without processing
  Future<SyncResult> getCurrentSyncResult() async {
    final actions = await _offlineQueue.getActions();
    final failed = (await _offlineQueue.getFailedActions()).length;
    final success = actions.length - failed;
    
    return SyncResult(
      successCount: success,
      failureCount: failed,
      errors: failed > 0 
          ? (await _offlineQueue.getFailedActions())
              .map((a) => '${a.type.name}: ${a.errorMessage ?? "Failed"}')
              .toList()
          : [],
    );
  }

  /// Process a single action
  Future<void> _processAction(PendingAction action) async {
    switch (action.type) {
      case PendingActionType.startVisit:
        await _processStartVisit(action);
        break;
      case PendingActionType.pauseVisit:
        await _processPauseVisit(action);
        break;
      case PendingActionType.completeVisit:
        await _processCompleteVisit(action);
        break;
      case PendingActionType.addNote:
        await _processAddNote(action);
        break;
      case PendingActionType.uploadMedia:
        await _processUploadMedia(action);
        break;
      case PendingActionType.addSignature:
        await _processAddSignature(action);
        break;
      case PendingActionType.createQuote:
        await _processCreateQuote(action);
        break;
      case PendingActionType.addInventory:
        await _processAddInventory(action);
        break;
      case PendingActionType.sendMessage:
        await _processSendMessage(action);
        break;
      default:
        throw Exception('Unknown action type: ${action.type}');
    }
  }

  Future<void> _processStartVisit(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    // TODO (Phase 2): Call actual API when backend is ready
    // await _apiClient.post('/v1/tech/visits/$visitId/start');
  }

  Future<void> _processPauseVisit(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    // TODO (Phase 2): Call actual API when backend is ready
    // await _apiClient.post('/v1/tech/visits/$visitId/pause');
  }

  Future<void> _processCompleteVisit(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    // TODO (Phase 2): Call actual API when backend is ready
    // Validate signature exists before completing
    // await _apiClient.post('/v1/tech/visits/$visitId/complete');
  }

  Future<void> _processAddNote(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/visits/${action.data['visit_id']}/notes', data: action.data);
  }

  Future<void> _processUploadMedia(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/visits/${action.data['visit_id']}/media', data: action.data);
  }

  Future<void> _processAddSignature(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/visits/${action.data['visit_id']}/signatures', data: action.data);
  }

  Future<void> _processCreateQuote(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/quotes', data: action.data);
  }

  Future<void> _processAddInventory(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/inventory', data: action.data);
  }

  Future<void> _processSendMessage(PendingAction action) async {
    // TODO (Phase 2): Implement when backend is ready
    // await _apiClient.post('/v1/tech/chat/${action.data['thread_id']}/messages', data: action.data);
  }

  /// Get sync status
  Future<SyncStatus> getStatus() async {
    final total = await _offlineQueue.count;
    final retryable = (await _offlineQueue.getRetryableActions()).length;
    final failed = (await _offlineQueue.getFailedActions()).length;

    return SyncStatus(
      totalPending: total,
      retryable: retryable,
      failed: failed,
      isSyncing: _isSyncing,
    );
  }

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;
}

/// Sync Result
class SyncResult {
  final int successCount;
  final int failureCount;
  final List<String> errors;

  SyncResult({
    required this.successCount,
    required this.failureCount,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  int get totalProcessed => successCount + failureCount;
}

/// Sync Status
class SyncStatus {
  final int totalPending;
  final int retryable;
  final int failed;
  final bool isSyncing;

  SyncStatus({
    required this.totalPending,
    required this.retryable,
    required this.failed,
    this.isSyncing = false,
  });

  bool get hasPending => totalPending > 0;
  bool get hasFailed => failed > 0;
  
  /// Get sync progress percentage (0-100)
  double getProgress(int totalProcessed, int total) {
    if (total == 0) return 0.0;
    return (totalProcessed / total * 100).clamp(0.0, 100.0);
  }
}

/// Sync Processor Provider
final syncProcessorProvider = Provider<SyncProcessor>((ref) {
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  final apiClient = ref.watch(apiClientProvider);
  
  return SyncProcessor(offlineQueue, apiClient);
});

/// Sync Status Provider
final syncStatusProvider = FutureProvider<SyncStatus>((ref) async {
  final processor = ref.watch(syncProcessorProvider);
  return processor.getStatus();
});

