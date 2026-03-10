// Inventory Upload Service
// Handles inventory image uploads to Supabase Storage

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/logger.dart';

/// Inventory Upload Service
///
/// Handles uploading inventory item images to Supabase Storage
/// using the Supabase Storage API directly (works with ES256 JWT).
class InventoryUploadService {
  SupabaseClient get _supabase => Supabase.instance.client;

  InventoryUploadService();

  /// Upload inventory item image
  ///
  /// Uses Supabase Storage API directly (works with ES256 JWT).
  /// Uploads to: inventory/{orgId}/{itemId}/{timestamp}_{filename}
  ///
  /// Returns the file path in storage.
  Future<String> uploadInventoryImage({
    required String orgId,
    required String itemId,
    required File file,
  }) async {
    try {
      Logger.info('Uploading inventory image for item: $itemId');

      // Generate unique filename with timestamp
      final fileExtension = file.path.split('.').last.toLowerCase();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = '${timestamp}_image.$fileExtension';

      // Storage path: {orgId}/{itemId}/{filename} (within 'inventory' bucket)
      final storagePath = '$orgId/$itemId/$filename';

      // Read file bytes
      final fileBytes = await file.readAsBytes();

      // Upload directly to Supabase Storage
      // The 'inventory' bucket should exist in Supabase Storage
      // Storage path: {orgId}/{itemId}/{filename} (bucket name is 'inventory')
      await _supabase.storage
          .from('inventory')
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: _getContentType(fileExtension),
              upsert: false,
            ),
          );

      Logger.info('Inventory image uploaded successfully: $storagePath');

      // Return the storage path
      return storagePath;
    } catch (e, stackTrace) {
      Logger.error('Inventory image upload failed', e, stackTrace);
      rethrow;
    }
  }

  /// Get public URL for inventory image
  ///
  /// Returns a signed URL that expires after a certain time.
  /// For permanent access, use the storage path directly.
  Future<String> getPublicUrl({required String storagePath}) async {
    try {
      final url = _supabase.storage.from('inventory').getPublicUrl(storagePath);

      return url;
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to get public URL for inventory image',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete inventory image
  Future<void> deleteInventoryImage({required String storagePath}) async {
    try {
      Logger.info('Deleting inventory image: $storagePath');

      await _supabase.storage.from('inventory').remove([storagePath]);

      Logger.info('Inventory image deleted successfully');
    } catch (e, stackTrace) {
      Logger.error('Inventory image deletion failed', e, stackTrace);
      rethrow;
    }
  }

  /// Get content type for file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
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
  }
}

/// Inventory Upload Service Provider
final inventoryUploadServiceProvider = Provider<InventoryUploadService>((ref) {
  return InventoryUploadService();
});
