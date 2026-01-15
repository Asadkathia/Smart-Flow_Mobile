// Media Upload Service
// Handles file uploads to Supabase Storage directly

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/logger.dart';
import '../remote/api_client.dart';

/// Media Upload Service
/// 
/// Handles uploading media files (images, videos, PDFs) to Supabase Storage
/// using the Supabase Storage API directly (works with ES256 JWT).
class MediaUploadService {
  final ApiClient _apiClient;
  final SupabaseClient _supabase = Supabase.instance.client;

  MediaUploadService(this._apiClient);

  /// Upload visit media (image, video, or PDF)
  /// 
  /// Uses Supabase Storage API directly (works with ES256 JWT).
  /// Uploads to: visits/{visitId}/media/{timestamp}_{filename}
  /// 
  /// Returns the file path in storage.
  Future<String> uploadVisitMedia({
    required String visitId,
    required File file,
    required String fileType, // 'image', 'video', 'pdf'
  }) async {
    try {
      Logger.info('Uploading media for visit: $visitId');
      
      // Generate unique filename with timestamp
      final fileExtension = file.path.split('.').last.toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '${timestamp}_${fileType}.$fileExtension';
      
      // Storage path: visits/{visitId}/media/{filename}
      final storagePath = 'visits/$visitId/media/$filename';
      
      // Read file bytes
      final fileBytes = await file.readAsBytes();
      
      // Upload directly to Supabase Storage
      // The 'visit-media' bucket should exist in Supabase Storage
      final uploadResult = await _supabase.storage
          .from('visit-media')
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: _getContentType(fileType, fileExtension),
              upsert: false,
            ),
          );
      
      Logger.info('Media uploaded successfully: $storagePath');
      
      // Return the public URL or path
      // For signatures and media, we typically use the path
      return storagePath;
    } catch (e, stackTrace) {
      Logger.error('Media upload failed', e, stackTrace);
      rethrow;
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> files, {
    required String prefix,
    String? entityId,
    String? entityType,
  }) async {
    final uploadedPaths = <String>[];
    
    for (final file in files) {
      try {
        // Extract visit ID from prefix if format is 'visits/{visitId}/media'
        final visitId = entityId ?? prefix.split('/').firstWhere(
          (part) => part.isNotEmpty,
          orElse: () => '',
        );
        
        if (visitId.isEmpty) {
          throw Exception('Cannot determine visit ID from prefix: $prefix');
        }

        final path = await uploadVisitMedia(
          visitId: visitId,
          file: file,
          fileType: 'image',
        );
        uploadedPaths.add(path);
      } catch (e) {
        Logger.error('Failed to upload image: ${file.path}', e);
        // Continue with other files
      }
    }
    
    return uploadedPaths;
  }

  /// Get content type for file
  String _getContentType(String fileType, String extension) {
    switch (fileType) {
      case 'image':
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            return 'image/jpeg';
          case 'png':
            return 'image/png';
          case 'webp':
            return 'image/webp';
          default:
            return 'image/jpeg';
        }
      case 'video':
        switch (extension) {
          case 'mp4':
            return 'video/mp4';
          case 'mov':
            return 'video/quicktime';
          default:
            return 'video/mp4';
        }
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Media Upload Service Provider
final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MediaUploadService(apiClient);
});
