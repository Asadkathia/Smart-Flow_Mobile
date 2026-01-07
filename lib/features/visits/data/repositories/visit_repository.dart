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
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
    MediaUploadService? mediaUploadService,
  }) : _mediaUploadService = mediaUploadService,
       super(apiClient, cache, offlineQueue, useMockData: useMockData);

  // ============ Visit Operations ============

  /// Get today's visits for the technician - unified pattern
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
        final queryParams = <String, dynamic>{};
        if (page != null) queryParams['page'] = page;
        if (pageSize != null) queryParams['page_size'] = pageSize;
        
        final response = await apiClient.get(
          ApiEndpoints.todayVisits,
          queryParameters: queryParams.isEmpty ? null : queryParams,
        );
        
        // Handle paginated response if page/pageSize provided
        if (page != null || pageSize != null) {
          if (response.data is Map && response.data['data'] != null) {
            final List<dynamic> data = response.data['data'] as List;
            return data.map((json) => VisitModel.fromJson(json)).toList();
          }
        }
        
        final List<dynamic> data = response.data as List;
        return data.map((json) => VisitModel.fromJson(json)).toList();
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
        final response = await apiClient.get(ApiEndpoints.visitDetails(visitId));
        return VisitModel.fromJson(response.data);
      },
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () => VisitMockData.getMockVisitDetails(visitId)
          : null,
    );
  }

  /// Start a visit - with offline support
  Future<VisitModel> startVisit(String visitId) async {
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    // Validate state transition (PRD Section 17.1)
    VisitValidator.validateCanStart(current);
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        final response = await apiClient.post(ApiEndpoints.startVisit(visitId));
        return VisitModel.fromJson(response.data);
      },
      actionType: PendingActionType.startVisit,
      actionData: {'visit_id': visitId},
      fromJson: (data) => VisitModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => current.copyWith(
        status: VisitStatus.inProgress,
        actualStart: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      localEntity: current,
      entityType: 'visit',
      checkConflict: true,
    );
  }

  /// Pause a visit - with offline support
  Future<VisitModel> pauseVisit(String visitId, {String? reason}) async {
    // Get current visit first for optimistic update
    final current = await getVisitDetails(visitId);
    
    // Validate state transition (PRD Section 17.1)
    VisitValidator.validateCanPause(current);
    
    return await mutate<VisitModel>(
      cacheKey: 'visit_$visitId',
      apiCall: () async {
        final response = await apiClient.post(
          ApiEndpoints.pauseVisit(visitId),
          data: reason != null ? {'reason': reason} : null,
        );
        return VisitModel.fromJson(response.data);
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

  /// Complete a visit - with offline support
  /// 
  /// Note: Signature upload is handled by SignatureUploadService before calling this method.
  /// The signaturePath should already be a URL from the upload service.
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
        final response = await apiClient.post(
          ApiEndpoints.completeVisit(visitId),
          data: signatureUrl != null ? {'signature_url': signatureUrl} : null,
        );
        return VisitModel.fromJson(response.data);
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
        imageUrls = await _mediaUploadService!.uploadMultipleImages(
          imageFiles,
          'visits/$visitId/media',
          entityId: visitId,
          entityType: 'visit',
        );
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
          authorName: 'Tony Stark',
          content: content,
          isInternal: isInternal,
          imageUrls: imageUrls,
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

