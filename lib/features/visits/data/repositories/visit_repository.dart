import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/shared/data/services/media_upload_service.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/errors/error_handler.dart';
import 'package:smartflowpro/core/services/logger.dart';
import 'package:smartflowpro/core/validation/visit_validator.dart';
import '../models/visit_model.dart';
import '../models/note_model.dart';
import '../mock_data/visit_mock_data.dart';

/// Visit Repository
/// 
/// Handles all visit-related data operations including:
/// - Fetching visits from API
/// - Caching visits locally
/// - Managing offline queue for visit actions
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class VisitRepository extends BaseRepository {
  final MediaUploadService? _mediaUploadService;

  VisitRepository(
    super.apiClient,
    super.cache,
    super.offlineQueue, {
    super.useMockData,
    MediaUploadService? mediaUploadService,
  }) : _mediaUploadService = mediaUploadService;

  // ============ Visit Operations ============

  /// Get today's visits for the technician - unified pattern
  /// 
  /// Uses REST API instead of Edge Functions to avoid ES256 JWT issues.
  /// Filters by: technician_id (from JWT), status (scheduled/in_progress)
  /// Shows visits from yesterday onwards to include recent/ongoing visits
  /// 
  /// [page] and [pageSize] are optional for backward compatibility.
  /// When provided, enables pagination support.
  Future<List<VisitModel>> getTodayVisits({
    int? page,
    int? pageSize,
  }) async {
    return await fetchList<VisitModel>(
      cacheKey: StorageKeys.todayVisitsCache,
      apiCall: () async {
        // Use REST API directly (works with ES256 JWT)
        // RLS policies will filter by technician_id automatically
        
        // Get yesterday's date to include recent visits
        // This helps show visits that may have started yesterday but are still in progress
        final now = DateTime.now();
        final yesterdayStart = DateTime(now.year, now.month, now.day - 1).toIso8601String();
        
        // Build REST API query
        // Filter: scheduled_start >= yesterday AND status IN (scheduled, in_progress)
        // Order by scheduled_start ascending to show earliest visits first
        final url = '${ApiEndpoints.restApiBaseFull}/visits'
            '?scheduled_start=gte.$yesterdayStart'
            '&status=in.(scheduled,in_progress)'
            '&select=*'
            '&order=scheduled_start.asc';
        
        final response = await apiClient.get(url);
        
        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => VisitModel.fromJson(json)).toList();
        }
        
        return [];
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => VisitMockData.getMockVisits() : null,
    );
  }

  /// Get visit details by ID - unified pattern
  Future<VisitModel> getVisitDetails(String visitId) async {
    return await fetch<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        // TODO: Create visit-details Edge Function or use REST API
        // For now, use REST API directly
        final url = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return VisitModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Visit not found');
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => VisitMockData.getMockVisitDetails(visitId)
          : null,
    );
  }

  /// Get completed visits with optional date filtering
  Future<List<VisitModel>> getCompletedVisits({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await fetchList<VisitModel>(
      cacheKey: StorageKeys.completedVisitsCache,
      apiCall: () async {
        final url = '${ApiEndpoints.restApiBaseFull}/visits';
        final queryParams = {
          'status': 'eq.completed',
          'select': '*',
          'order': 'actual_end.desc',
        };
        
        if (startDate != null) {
          queryParams['actual_end'] = 'gte.${startDate.toIso8601String()}';
        }
        if (endDate != null) {
          queryParams['actual_end'] = 'lte.${endDate.toIso8601String()}';
        }
        
        final response = await apiClient.get(url, queryParameters: queryParams);
        return (response.data as List)
            .map((json) => VisitModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => VisitMockData.getMockCompletedVisits() : null,
    );
  }

  /// Start a visit - with offline support
  /// Uses REST API directly to avoid ES256 JWT issues
  Future<VisitModel> startVisit(String visitId) async {
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    // Validate state transition (PRD Section 17.1)
    VisitValidator.validateCanStart(current);
    
    final now = DateTime.now();
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        // Use REST API PATCH to update visits table directly
        final url = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId';
        final response = await apiClient.patch(
          url,
          data: {
            'status': 'in_progress',
            'actual_start': now.toIso8601String(),
          },
        );
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return VisitModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to start visit');
      },
      actionType: PendingActionType.startVisit,
      actionData: {'visit_id': visitId},
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: VisitStatus.inProgress,
        actualStart: now,
        updatedAt: now,
      ),
      localEntity: current,
      entityType: 'visit',
      checkConflict: true,
    );
  }

  /// Pause a visit - with offline support
  /// Uses REST API directly to avoid ES256 JWT issues
  Future<VisitModel> pauseVisit(String visitId, {String? reason}) async {
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    // Validate state transition (PRD Section 17.1)
    VisitValidator.validateCanPause(current);
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        // Use REST API PATCH to update visits table directly
        final url = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId';
        final response = await apiClient.patch(
          url,
          data: {
            'status': 'paused',
            if (reason != null) 'status_reason': reason,
          },
        );
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return VisitModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to pause visit');
      },
      actionType: PendingActionType.pauseVisit,
      actionData: {'visit_id': visitId, 'reason': reason},
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: VisitStatus.paused,
        statusReason: reason,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'visit',
      checkConflict: true,
    );
  }

  /// Save signature for a visit (without completing)
  /// 
  /// This allows saving signature separately before completing the visit.
  /// The signaturePath should already be a URL from SignatureUploadService.
  /// Uses REST API directly to avoid ES256 JWT issues.
  Future<VisitModel> saveSignature(String visitId, String signaturePath) async {
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        // Use REST API PATCH to update visits table directly
        final url = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId';
        final response = await apiClient.patch(
          url,
          data: {'signature_url': signaturePath},
        );
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return VisitModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to save signature');
      },
      actionType: PendingActionType.addSignature,
      actionData: {
        'visit_id': visitId,
        'signature_path': signaturePath,
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        signatureUrl: signaturePath,
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'visit',
      checkConflict: false, // Signature save doesn't conflict with other operations
    );
  }

  /// Complete a visit - with offline support
  /// 
  /// Note: Signature upload is handled by SignatureUploadService before calling this method.
  /// The signaturePath should already be a URL from the upload service.
  /// Uses REST API directly to avoid ES256 JWT issues.
  /// 
  /// Per PRD Section 18: Signature is required for visit completion.
  Future<VisitModel> completeVisit(String visitId, {String? signaturePath}) async {
    final signatureUrl = signaturePath; // Should be URL from SignatureUploadService
    
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    // Validate state transition and signature requirement (PRD Section 17.1 & 18)
    VisitValidator.validateCanComplete(current, signatureUrl: signatureUrl);
    
    final now = DateTime.now();
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        // Use REST API PATCH to update visits table directly
        final url = '${ApiEndpoints.restApiBaseFull}/visits?id=eq.$visitId';
        final response = await apiClient.patch(
          url,
          data: {
            'status': 'completed',
            'actual_end': now.toIso8601String(),
            if (signatureUrl != null) 'signature_url': signatureUrl,
          },
        );
        
        // REST API returns array on update
        if (response.data is List && (response.data as List).isNotEmpty) {
          return VisitModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Failed to complete visit');
      },
      actionType: PendingActionType.completeVisit,
      actionData: {
        'visit_id': visitId,
        'signature_path': signaturePath,
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: VisitStatus.completed,
        actualEnd: now,
        updatedAt: now,
        notes: 'Service completed successfully. Customer satisfied with the work.',
        signatureUrl: signaturePath, // Store signature path/URL
      ),
      localEntity: current,
      entityType: 'visit',
      checkConflict: true,
    );
  }

  /// Upload completion images
  /// 
  /// Uploads job verification photos after visit completion.
  /// Images are stored in: {org_id}/visits/{visit_id}/completion/{timestamp}_image.jpg
  Future<void> uploadCompletionImages(String visitId, List<File> images) async {
    if (_mediaUploadService == null) {
      throw Exception('Media upload service not available');
    }

    if (images.isEmpty) {
      return;
    }

    try {
      // Get visit details to get org_id
      final visit = await getVisitDetails(visitId);
      
      // Upload each image
      final uploadedPaths = <String>[];
      for (var i = 0; i < images.length; i++) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = '${timestamp}_completion_$i.jpg';
        final storagePath = '${visit.orgId}/visits/$visitId/completion/$fileName';
        
        await _mediaUploadService.uploadMedia(
          file: images[i],
          bucket: 'visits',
          path: storagePath,
        );
        
        uploadedPaths.add(storagePath);
      }
      
      Logger.info('Uploaded ${uploadedPaths.length} completion images for visit $visitId');
    } catch (e) {
      Logger.error('Failed to upload completion images: $e');
      rethrow;
    }
  }


  // ============ Notes Operations ============

  /// Get notes for a visit - unified pattern
  Future<List<NoteModel>> getVisitNotes(String visitId) async {
    return await fetchList<NoteModel>(
      cacheKey: 'visit_notes_$visitId',
      apiCall: () async {
        final response = await apiClient.get(ApiEndpoints.visitNotes(visitId));
        final List<dynamic> data = response.data as List;
        return data.map((json) => NoteModel.fromJson(json)).toList();
      },
      fromJson: (data) => NoteModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => VisitMockData.getMockNotes(visitId) : null,
    );
  }

  /// Add a note to a visit - with offline support
  Future<NoteModel> addNote(
    String visitId,
    String content, {
    bool isInternal = false,
    List<String>? imagePaths,
    List<File>? imageFiles,
  }) async {
    // Upload images first if provided
    List<String> imageUrls = [];
    if (imageFiles != null && imageFiles.isNotEmpty && _mediaUploadService != null) {
      try {
        // Upload each image individually
        for (final file in imageFiles) {
          try {
            final path = await _mediaUploadService.uploadVisitMedia(
              visitId: visitId,
              file: file,
              fileType: 'image',
            );
            imageUrls.add(path);
          } catch (e) {
            // Continue with other files if one fails
            Logger.error('Failed to upload image: ${file.path}', e);
          }
        }
      } catch (e) {
        // If upload fails, fall back to local paths for offline support
        // The offline queue will handle retry when online
        imageUrls = imagePaths ?? [];
      }
    } else if (imagePaths != null) {
      // Use provided paths (for offline scenarios)
      imageUrls = imagePaths;
    }
    
    return await mutate<NoteModel>(
      cacheKey: 'visit_notes_$visitId',
      apiCall: () async {
        final response = await apiClient.post(
          ApiEndpoints.addNote(visitId),
          data: {
            'content': content,
            'is_internal': isInternal,
            'image_urls': imageUrls,
          },
        );
        return NoteModel.fromJson(response.data);
      },
      actionType: PendingActionType.addNote,
      actionData: {
        'visit_id': visitId,
        'content': content,
        'is_internal': isInternal,
        'image_paths': imagePaths ?? [],
      },
      fromJson: (data) => NoteModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () {
        final now = DateTime.now();
        return NoteModel(
          id: generateId(),
          orgId: 'org_1',
          visitId: visitId,
          authorId: 'tech_1',
          body: content, // PRD: body (not content)
          createdAt: now,
          updatedAt: now,
        );
      },
      updateCache: false, // Don't update cache for notes list, will be refreshed
    );
  }

  /// Update a note - with offline support
  Future<NoteModel> updateNote(String visitId, String noteId, String content) async {
    return await mutate<NoteModel>(
      cacheKey: 'note_$noteId',
      apiCall: () async {
        final response = await apiClient.put(
          ApiEndpoints.updateNote(visitId, noteId),
          data: {'content': content},
        );
        return NoteModel.fromJson(response.data);
      },
      actionType: PendingActionType.updateNote,
      actionData: {
        'visit_id': visitId,
        'note_id': noteId,
        'content': content,
      },
      fromJson: (data) => NoteModel.fromJson(data as Map<String, dynamic>),
      updateCache: false, // Don't update cache for notes list
    );
  }

  /// Delete a note - with offline support
  Future<void> deleteNote(String visitId, String noteId) async {
    try {
      await apiClient.delete(ApiEndpoints.deleteNote(visitId, noteId));
    } catch (e) {
      // Queue for offline sync if network error
      if (ErrorHandler.isNetworkError(e)) {
        await offlineQueue.addAction(PendingAction(
          id: generateId(),
          type: PendingActionType.deleteNote,
          data: {
            'visit_id': visitId,
            'note_id': noteId,
          },
          timestamp: DateTime.now(),
        ));
      }
      rethrow;
    }
  }
}

/// Visit Repository Provider
final visitRepositoryProvider = Provider<VisitRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  final cache = ref.watch(visitsCacheProvider);
  final mediaUploadService = ref.watch(mediaUploadServiceProvider);
  return VisitRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
    mediaUploadService: mediaUploadService,
  );
});

