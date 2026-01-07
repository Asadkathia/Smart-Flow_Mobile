import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/visit_model.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/visit_repository.dart';
import '../../data/mock_data/visit_mock_data.dart';
import 'package:smartflowpro/shared/data/services/signature_upload_service.dart';

part 'visits_provider.g.dart';

/// Today's Visits Provider
/// 
/// Provides a list of visits scheduled for today.
/// Handles loading, error, and refresh states.
@riverpod
class TodayVisits extends _$TodayVisits {
  @override
  Future<List<VisitModel>> build() async {
    // Use repository to get visits - this will use mock data when enabled
    final repository = ref.read(visitRepositoryProvider);
    return repository.getTodayVisits();
  }

  /// Refresh the visits list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      return repository.getTodayVisits();
    });
  }

  /// Update a visit in the list (after status change)
  void updateVisit(VisitModel updatedVisit) {
    state.whenData((visits) {
      final index = visits.indexWhere((v) => v.id == updatedVisit.id);
      if (index != -1) {
        final newList = [...visits];
        newList[index] = updatedVisit;
        state = AsyncValue.data(newList);
      }
    });
  }
}

/// Single Visit Details Provider
/// 
/// Provides details for a specific visit by ID.
@riverpod
class VisitDetails extends _$VisitDetails {
  @override
  Future<VisitModel> build(String visitId) async {
    // Use repository to get visit details - this will use cached/updated data
    final repository = ref.read(visitRepositoryProvider);
    return repository.getVisitDetails(visitId);
  }

  /// Start the visit
  Future<void> startVisit() async {
    final visitId = state.value?.id;
    if (visitId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      final updated = await repository.startVisit(visitId);
      
      // Update the today's visits list
      ref.read(todayVisitsProvider.notifier).updateVisit(updated);
      
      return updated;
    });
  }

  /// Pause the visit
  Future<void> pauseVisit({String? reason}) async {
    final visitId = state.value?.id;
    if (visitId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      final updated = await repository.pauseVisit(visitId, reason: reason);
      
      ref.read(todayVisitsProvider.notifier).updateVisit(updated);
      
      return updated;
    });
  }

  /// Complete the visit
  Future<void> completeVisit() async {
    final visitId = state.value?.id;
    if (visitId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      final updated = await repository.completeVisit(visitId);
      
      ref.read(todayVisitsProvider.notifier).updateVisit(updated);
      
      return updated;
    });
  }

  /// Refresh visit details
  Future<void> refresh() async {
    final visitId = state.value?.id;
    if (visitId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      return repository.getVisitDetails(visitId);
    });
  }
}

/// Visit Notes Provider
/// 
/// Provides notes for a specific visit.
@riverpod
class VisitNotes extends _$VisitNotes {
  @override
  Future<List<NoteModel>> build(String visitId) async {
    // TODO (Phase 2): Replace with actual API call when backend is ready
    // final repository = ref.read(visitRepositoryProvider);
    // return repository.getVisitNotes(visitId);
    
    // Mock data for development/UI testing
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockNotes(visitId);
  }

  /// Mock notes for development
  /// Uses centralized mock data to ensure consistency
  List<NoteModel> _getMockNotes(String visitId) {
    return VisitMockData.getMockNotes(visitId);
  }

  /// Add a new note
  Future<void> addNote(
    String visitId,
    String content, {
    bool isInternal = false,
    List<String>? imagePaths,
    List<File>? imageFiles,
  }) async {
    final repository = ref.read(visitRepositoryProvider);
    
    state = await AsyncValue.guard(() async {
      final newNote = await repository.addNote(
        visitId,
        content,
        isInternal: isInternal,
        imagePaths: imagePaths,
        imageFiles: imageFiles,
      );
      
      // Add to the beginning of the list
      final currentNotes = state.value ?? [];
      return [newNote, ...currentNotes];
    });
  }

  /// Update a note
  Future<void> updateNote(String visitId, String noteId, String content) async {
    final repository = ref.read(visitRepositoryProvider);
    
    state = await AsyncValue.guard(() async {
      final updatedNote = await repository.updateNote(visitId, noteId, content);
      
      final currentNotes = state.value ?? [];
      final index = currentNotes.indexWhere((n) => n.id == noteId);
      
      if (index != -1) {
        final newList = [...currentNotes];
        newList[index] = updatedNote;
        return newList;
      }
      
      return currentNotes;
    });
  }

  /// Delete a note
  Future<void> deleteNote(String visitId, String noteId) async {
    final repository = ref.read(visitRepositoryProvider);
    
    state = await AsyncValue.guard(() async {
      await repository.deleteNote(visitId, noteId);
      
      final currentNotes = state.value ?? [];
      return currentNotes.where((n) => n.id != noteId).toList();
    });
  }

  /// Refresh notes
  Future<void> refresh(String visitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      return repository.getVisitNotes(visitId);
    });
  }
}

/// Visit Actions Provider
/// 
/// Handles visit actions (start, pause, complete) with loading states.
@riverpod
class VisitActions extends _$VisitActions {
  @override
  FutureOr<void> build() {}

  /// Start a visit
  Future<bool> startVisit(String visitId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      await repository.startVisit(visitId);
      
      // Invalidate both providers to refresh UI
      ref.invalidate(todayVisitsProvider);
      ref.invalidate(visitDetailsProvider(visitId));
    });
    
    return !state.hasError;
  }

  /// Pause a visit
  Future<bool> pauseVisit(String visitId, {String? reason}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      await repository.pauseVisit(visitId, reason: reason);
      
      ref.invalidate(todayVisitsProvider);
      ref.invalidate(visitDetailsProvider(visitId));
    });
    
    return !state.hasError;
  }

  /// Complete a visit
  /// 
  /// Uploads signature first if provided, then completes the visit.
  Future<bool> completeVisit(String visitId, {String? signaturePath}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitRepositoryProvider);
      
      // Upload signature first if provided
      String? signatureUrl = signaturePath;
      if (signaturePath != null) {
        try {
          final signatureFile = File(signaturePath);
          if (await signatureFile.exists()) {
            final signatureService = ref.read(signatureUploadServiceProvider);
            signatureUrl = await signatureService.uploadSignature(
              signatureFile,
              visitId,
            );
          }
        } catch (e) {
          // If upload fails, still proceed with local path for offline support
          // The repository will handle offline sync later
          signatureUrl = signaturePath;
        }
      }
      
      await repository.completeVisit(visitId, signaturePath: signatureUrl);
      
      ref.invalidate(todayVisitsProvider);
      ref.invalidate(visitDetailsProvider(visitId));
    });
    
    return !state.hasError;
  }
}

/// Selected Visit Provider
/// 
/// Tracks the currently selected visit ID.
@riverpod
class SelectedVisit extends _$SelectedVisit {
  @override
  String? build() => null;

  void select(String visitId) {
    state = visitId;
  }

  void clear() {
    state = null;
  }
}

/// Filtered Visits Provider
/// 
/// Provides visits filtered by status.
@riverpod
List<VisitModel> filteredVisits(Ref ref, VisitStatus? status) {
  final visitsAsync = ref.watch(todayVisitsProvider);
  
  return visitsAsync.when(
    data: (visits) {
      if (status == null) return visits;
      return visits.where((v) => v.status == status).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Active Visit Provider
/// 
/// Provides the currently active (in progress) visit, if any.
@riverpod
VisitModel? activeVisit(Ref ref) {
  final visitsAsync = ref.watch(todayVisitsProvider);
  
  return visitsAsync.when(
    data: (visits) {
      try {
        return visits.firstWhere(
          (v) => v.status == VisitStatus.inProgress,
        );
      } catch (_) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}

