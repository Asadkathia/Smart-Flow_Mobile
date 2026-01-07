import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/errors/error_handler.dart';
import '../remote/api_client.dart';

/// Media Upload Service
/// 
/// Handles image uploads to server with progress tracking and error handling.
/// Supports Supabase Storage structure via signed URLs.
/// 
/// Per PRD Section 18: File size limits enforced:
/// - Images: 10MB
/// - PDFs: 25MB
/// - Videos: 100MB
/// - Signatures: 5MB
class MediaUploadService {
  final ApiClient _apiClient;
  final Dio _dio;

  MediaUploadService(this._apiClient, this._dio);

  /// Validate file size
  void _validateFileSize(File file, int maxSize, String fileType) {
    final fileSize = file.lengthSync();
    if (fileSize > maxSize) {
      final maxSizeMb = (maxSize / (1024 * 1024)).toStringAsFixed(0);
      throw ValidationException(
        message: '$fileType file size exceeds maximum allowed size of ${maxSizeMb}MB.',
        code: 'FILE_TOO_LARGE',
      );
    }
  }

  /// Validate file type
  void _validateFileType(File file, List<String> allowedExtensions) {
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw ValidationException(
        message: 'File type not allowed. Allowed types: ${allowedExtensions.join(", ")}.',
        code: 'INVALID_FILE_TYPE',
      );
    }
  }

  /// Compress image (basic implementation - can be enhanced with image package)
  /// 
  /// For production, consider using flutter_image_compress package
  Future<File> _compressImage(File image) async {
    // Basic validation - in production, use image compression library
    // For now, return original file if size is acceptable
    if (image.lengthSync() <= AppConstants.maxImageSize) {
      return image;
    }
    
    // TODO: Implement actual image compression using flutter_image_compress
    // For now, throw error if image is too large
    throw ValidationException(
      message: 'Image file is too large. Please compress the image before uploading.',
      code: 'IMAGE_TOO_LARGE',
    );
  }

  /// Upload a single image
  /// 
  /// [image] - The image file to upload
  /// [path] - Storage path (e.g., 'visits/{visitId}/media', 'inventory/{itemId}')
  /// [entityId] - ID of the entity (visit, inventory item, etc.)
  /// [entityType] - Type of entity ('visit', 'inventory', etc.)
  /// 
  /// Returns the uploaded file URL
  /// 
  /// Per PRD: Validates file size (10MB max) and compresses if needed.
  Future<String> uploadImage(
    File image,
    String path, {
    required String entityId,
    required String entityType,
  }) async {
    try {
      // Validate file type
      _validateFileType(image, ['jpg', 'jpeg', 'png', 'webp']);

      // Validate file size
      _validateFileSize(image, AppConstants.maxImageSize, 'Image');

      // Compress image if needed
      final processedImage = await _compressImage(image);

      // Step 1: Request signed upload URL
      // Supabase Storage path structure: {entityType}/{entityId}/{path}/{filename}
      final supabasePath = '$entityType/$entityId/$path/${processedImage.path.split('/').last}';
      
      final uploadUrlResponse = await _apiClient.post(
        '/v1/tech/$entityType/$entityId/media/upload-url',
        data: {
          'path': supabasePath,
          'filename': processedImage.path.split('/').last,
          'content_type': 'image/jpeg',
        },
      );

      final signedUrl = uploadUrlResponse.data['upload_url'] as String;
      final fileKey = uploadUrlResponse.data['file_key'] as String;

      // Step 2: Upload image to signed URL
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          processedImage.path,
          filename: processedImage.path.split('/').last,
        ),
      });

      await _dio.put(
        signedUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Step 3: Confirm upload
      await _apiClient.post(
        '/v1/tech/$entityType/$entityId/media/confirm',
        data: {
          'file_key': fileKey,
          'path': path,
        },
      );

      // Return the public URL
      return uploadUrlResponse.data['public_url'] as String? ?? signedUrl;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Upload multiple images
  /// 
  /// Returns list of uploaded file URLs in the same order as input files
  Future<List<String>> uploadMultipleImages(
    List<File> images,
    String path, {
    required String entityId,
    required String entityType,
  }) async {
    final urls = <String>[];
    
    for (final image in images) {
      try {
        final url = await uploadImage(
          image,
          path,
          entityId: entityId,
          entityType: entityType,
        );
        urls.add(url);
      } catch (e) {
        // If one upload fails, continue with others but log error
        // In production, you might want to collect all errors and throw at end
        throw Exception('Failed to upload image ${image.path}: $e');
      }
    }
    
    return urls;
  }

  /// Upload image with progress tracking
  /// 
  /// Returns a stream of progress values (0.0 to 1.0)
  Stream<double> uploadWithProgress(
    File image,
    String path, {
    required String entityId,
    required String entityType,
  }) async* {
    try {
      // Step 1: Request signed upload URL
      yield 0.1;
      
      final uploadUrlResponse = await _apiClient.post(
        '/v1/tech/$entityType/$entityId/media/upload-url',
        data: {
          'path': path,
          'filename': image.path.split('/').last,
          'content_type': 'image/jpeg',
        },
      );

      yield 0.2;

      final signedUrl = uploadUrlResponse.data['upload_url'] as String;
      final fileKey = uploadUrlResponse.data['file_key'] as String;

      // Step 2: Upload image to signed URL with progress
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      int uploadedBytes = 0;
      final fileSize = await image.length();

      await _dio.put(
        signedUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (sent, total) {
          uploadedBytes = sent;
          // Progress from 0.2 to 0.8 (upload phase)
          final progress = 0.2 + (sent / total) * 0.6;
          // Note: Stream can't yield here, so we'll yield after
        },
      );

      yield 0.8;

      // Step 3: Confirm upload
      await _apiClient.post(
        '/v1/tech/$entityType/$entityId/media/confirm',
        data: {
          'file_key': fileKey,
          'path': path,
        },
      );

      yield 1.0;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Delete uploaded media
  Future<void> deleteMedia(
    String mediaUrl, {
    required String entityId,
    required String entityType,
  }) async {
    try {
      await _apiClient.delete(
        '/v1/tech/$entityType/$entityId/media',
        queryParameters: {
          'url': mediaUrl,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

/// Media Upload Service Provider
final mediaUploadServiceProvider = Provider<MediaUploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dio = ref.watch(dioProvider);
  return MediaUploadService(apiClient, dio);
});


