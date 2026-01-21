import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/errors/error_handler.dart';
import '../remote/api_client.dart';
import 'media_upload_service.dart';

/// Signature Upload Service
/// 
/// Handles signature image uploads to server.
/// Specialized service for visit signatures.
/// 
/// Per PRD Section 18: Signature file size limit is 5MB.
class SignatureUploadService {
  final ApiClient _apiClient;
  final MediaUploadService _mediaUploadService;

  SignatureUploadService(this._apiClient, this._mediaUploadService);

  /// Validate signature file size
  void _validateSignatureSize(File signature) {
    final fileSize = signature.lengthSync();
    if (fileSize > AppConstants.maxSignatureSize) {
      throw ValidationException(
        message: 'Signature file size exceeds maximum allowed size of ${AppConstants.maxSignatureSizeMb}MB.',
        code: 'SIGNATURE_TOO_LARGE',
      );
    }
    
    if (fileSize == 0) {
      throw ValidationException.signatureRequiredError();
    }
  }

  /// Upload signature image for a visit
  /// 
  /// [signatureFile] - The signature image file
  /// [visitId] - ID of the visit
  /// 
  /// Returns the uploaded signature URL
  /// 
  /// Per PRD: Validates signature file size (5MB max) and is required for visit completion.
  Future<String> uploadSignature(
    File signatureFile,
    String visitId,
  ) async {
    try {
      // Validate signature file size (5MB max per PRD)
      _validateSignatureSize(signatureFile);

      // Use media upload service with visit-specific path
      // Supabase Storage path: visits/{visitId}/signatures/{filename}
      final signaturePath = await _mediaUploadService.uploadVisitMedia(
        visitId: visitId,
        file: signatureFile,
        fileType: 'image',
      );

      return signaturePath;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Upload signature with progress tracking
  /// 
  /// Returns a stream of progress values (0.0 to 1.0)
  /// Note: Progress tracking not yet implemented in MediaUploadService
  Future<String> uploadSignatureWithProgress(
    File signatureFile,
    String visitId,
  ) async {
    // For now, use regular upload (progress tracking can be added later)
    return uploadSignature(signatureFile, visitId);
  }

  /// Delete signature from storage
  /// 
  /// [signaturePath] - Full storage path of the signature (e.g., 'visits/{visitId}/media/{filename}')
  /// [visitId] - ID of the visit (for logging purposes)
  Future<void> deleteSignature(
    String signaturePath,
    String visitId,
  ) async {
    try {
      await _mediaUploadService.deleteVisitMedia(storagePath: signaturePath);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

/// Signature Upload Service Provider
final signatureUploadServiceProvider = Provider<SignatureUploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final mediaUploadService = ref.watch(mediaUploadServiceProvider);
  return SignatureUploadService(apiClient, mediaUploadService);
});


