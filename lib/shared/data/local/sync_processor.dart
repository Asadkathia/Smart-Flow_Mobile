import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/constants/api_endpoints.dart';
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
      case PendingActionType.updateQuote:
        await _processUpdateQuote(action);
        break;
      case PendingActionType.deleteQuote:
        await _processDeleteQuote(action);
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
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.startVisit(visitId));
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'actual_start': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _processPauseVisit(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final reason = action.data['reason'] as String?;
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.pauseVisit(visitId));
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: reason != null ? {'status_reason': reason} : null,
    );
  }

  Future<void> _processCompleteVisit(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final signaturePath = action.data['signature_path'] as String?;
    
    if (signaturePath == null || signaturePath.isEmpty) {
      throw ValidationException.signatureRequiredError();
    }
    
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.completeVisit(visitId));
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'actual_end': DateTime.now().toIso8601String(),
        'signature_url': signaturePath,
      },
    );
  }

  Future<void> _processAddNote(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final content = action.data['content'] as String;
    final isInternal = action.data['is_internal'] as bool? ?? false;
    final imagePaths = action.data['image_paths'] as List<dynamic>?;
    
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.addNote(visitId));
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'body': content,
        'is_internal': isInternal,
        'image_urls': imagePaths?.cast<String>() ?? [],
      },
    );
  }

  Future<void> _processUploadMedia(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final filePath = action.data['file_path'] as String;
    final fileType = action.data['file_type'] as String? ?? 'image';
    
    // First request upload URL
    final uploadUrlEndpoint = ApiEndpoints.buildRouterPath(
      '${ApiEndpoints.visits}/$visitId/media/upload-url',
    );
    final uploadUrlResponse = await _apiClient.post(
      '${ApiEndpoints.apiBase}$uploadUrlEndpoint',
      data: {
        'path': 'visits/$visitId/media',
        'filename': filePath.split('/').last,
        'content_type': _getContentType(fileType),
      },
    );
    
    final uploadUrl = uploadUrlResponse.data['upload_url'] as String;
    final fileKey = uploadUrlResponse.data['file_key'] as String;
    
    // Note: File upload to signed URL should be handled by MediaUploadService
    // when the action is initially queued. When syncing, the file should already
    // be uploaded to the signed URL. This processor only confirms the upload.
    // TODO: If file upload failed during initial queue, we may need to retry upload here
    
    // Confirm upload
    final confirmEndpoint = ApiEndpoints.buildRouterPath(
      '${ApiEndpoints.visits}/$visitId/media/confirm',
    );
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$confirmEndpoint',
      data: {
        'file_key': fileKey,
        'path': 'visits/$visitId/media',
      },
    );
  }

  Future<void> _processAddSignature(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final signaturePath = action.data['signature_path'] as String;
    final signedBy = action.data['signed_by'] as String? ?? 'Customer';
    
    // Request upload URL for signature
    final uploadUrlEndpoint = ApiEndpoints.buildRouterPath(
      '${ApiEndpoints.visits}/$visitId/signature/upload-url',
    );
    final uploadUrlResponse = await _apiClient.post(
      '${ApiEndpoints.apiBase}$uploadUrlEndpoint',
      data: {
        'path': 'visits/$visitId/signatures',
        'filename': 'signature_${DateTime.now().millisecondsSinceEpoch}.png',
        'content_type': 'image/png',
      },
    );
    
    final uploadUrl = uploadUrlResponse.data['upload_url'] as String;
    final fileKey = uploadUrlResponse.data['file_key'] as String;
    
    // Upload signature (assume already uploaded, just confirm)
    final confirmEndpoint = ApiEndpoints.buildRouterPath(
      '${ApiEndpoints.visits}/$visitId/signature/confirm',
    );
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$confirmEndpoint',
      data: {
        'file_key': fileKey,
        'path': 'visits/$visitId/signatures',
        'signed_by': signedBy,
      },
    );
  }

  Future<void> _processCreateQuote(PendingAction action) async {
    final visitId = action.data['visit_id'] as String;
    final lineItems = action.data['line_items'] as List<dynamic>? ?? [];
    final taxable = action.data['taxable'] as bool? ?? true;
    
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.createQuote(visitId));
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'line_items': lineItems,
        'taxable': taxable,
      },
    );
  }

  Future<void> _processUpdateQuote(PendingAction action) async {
    final quoteId = action.data['quote_id'] as String;
    final actionType = action.data['action'] as String?;
    
    // Handle finalize action
    if (actionType == 'finalize') {
      final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.finalizeQuote(quoteId));
      await _apiClient.post('${ApiEndpoints.apiBase}$endpoint');
      return;
    }
    
    // Handle regular update - requires quote data
    // Note: Quote data should be stored in action.data['quote'] when queuing
    // For now, if quote data is missing, we'll need to fetch from cache or throw error
    final quoteData = action.data['quote'] as Map<String, dynamic>?;
    if (quoteData == null) {
      throw Exception('Quote data missing in updateQuote action. Cannot sync quote update.');
    }
    
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.quoteDetails(quoteId));
    await _apiClient.patch(
      '${ApiEndpoints.apiBase}$endpoint',
      data: quoteData,
    );
  }

  Future<void> _processDeleteQuote(PendingAction action) async {
    final quoteId = action.data['quote_id'] as String;
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.deleteQuote(quoteId));
    await _apiClient.delete('${ApiEndpoints.apiBase}$endpoint');
  }

  Future<void> _processAddInventory(PendingAction action) async {
    final name = action.data['name'] as String;
    final unit = action.data['unit'] as String;
    final price = action.data['price'] as num;
    final sku = action.data['sku'] as String?;
    final imagePath = action.data['image_path'] as String?;
    
    final endpoint = ApiEndpoints.buildRouterPath(ApiEndpoints.addInventory);
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'name': name,
        'unit': unit,
        'sale_price': price,
        'sku': sku,
        'image_path': imagePath,
        'taxable_default': true,
        'active': true,
      },
    );
  }

  Future<void> _processSendMessage(PendingAction action) async {
    final threadId = action.data['thread_id'] as String;
    final content = action.data['content'] as String;
    
    final endpoint = ApiEndpoints.buildRouterPath(
      ApiEndpoints.sendMessage(threadId),
    );
    await _apiClient.post(
      '${ApiEndpoints.apiBase}$endpoint',
      data: {
        'message_body': content,
      },
    );
  }

  /// Get content type from file type
  String _getContentType(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'image':
        return 'image/jpeg';
      case 'video':
        return 'video/mp4';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'image/jpeg';
    }
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

