// Media Upload Service
// Handles file uploads to Supabase Storage directly

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/logger.dart';

/// Media Upload Service
///
/// Handles uploading media files (images, videos, PDFs) to Supabase Storage
/// using the Supabase Storage API directly (works with ES256 JWT).
class MediaUploadService {
  SupabaseClient get _supabase => Supabase.instance.client;

  MediaUploadService();

  /// Generic media upload to any bucket
  Future<String> uploadMedia({
    required File file,
    required String bucket,
    required String path,
    String? contentType,
  }) async {
    try {
      final fileBytes = await file.readAsBytes();

      await _supabase.storage
          .from(bucket)
          .uploadBinary(
            path,
            fileBytes,
            fileOptions: FileOptions(
              contentType: contentType ?? 'image/jpeg',
              upsert: false,
            ),
          );

      return path;
    } catch (e, stackTrace) {
      Logger.error('Media upload failed to $bucket/$path', e, stackTrace);
      rethrow;
    }
  }

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
      final filename = '${timestamp}_$fileType.$fileExtension';

      // Storage path: visits/{visitId}/media/{filename}
      final storagePath = 'visits/$visitId/media/$filename';

      // Read file bytes
      final fileBytes = await file.readAsBytes();

      // Upload directly to Supabase Storage
      // The 'visit-media' bucket should exist in Supabase Storage
      await _supabase.storage
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
        final visitId =
            entityId ??
            prefix
                .split('/')
                .firstWhere((part) => part.isNotEmpty, orElse: () => '');

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

  /// Delete media from a bucket
  ///
  /// [bucket] - Storage bucket name
  /// [path] - File path within the bucket
  Future<void> deleteMedia({
    required String bucket,
    required String path,
  }) async {
    try {
      Logger.info('Deleting media from $bucket/$path');

      await _supabase.storage.from(bucket).remove([path]);

      Logger.info('Media deleted successfully: $bucket/$path');
    } catch (e, stackTrace) {
      Logger.error('Media deletion failed: $bucket/$path', e, stackTrace);
      rethrow;
    }
  }

  /// Delete visit media (image, video, PDF, or signature)
  ///
  /// [storagePath] - Full path in storage (e.g., 'visits/{visitId}/media/{filename}')
  Future<void> deleteVisitMedia({required String storagePath}) async {
    try {
      Logger.info('Deleting visit media: $storagePath');

      await _supabase.storage.from('visit-media').remove([storagePath]);

      Logger.info('Visit media deleted successfully: $storagePath');
    } catch (e, stackTrace) {
      Logger.error('Visit media deletion failed: $storagePath', e, stackTrace);
      rethrow;
    }
  }
}

/// Media Upload Service Provider
final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  return MediaUploadService();
});
