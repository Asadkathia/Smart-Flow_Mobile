import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Media Service
/// 
/// Handles image picking from camera and gallery.
class MediaService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    // Check camera permission
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      throw Exception('Camera permission denied');
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image from camera: $e');
    }
  }

  /// Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    // Check photos permission (iOS) or storage permission (Android)
    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }
    
    final status = await permission.request();
    if (!status.isGranted) {
      throw Exception('Photos permission denied');
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImagesFromGallery() async {
    // Check photos permission (iOS) or storage permission (Android)
    Permission permission;
    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }
    
    final status = await permission.request();
    if (!status.isGranted) {
      throw Exception('Photos permission denied');
    }

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return images;
    } catch (e) {
      throw Exception('Failed to pick images from gallery: $e');
    }
  }

  /// Convert XFile to File
  File? xFileToFile(XFile? xFile) {
    if (xFile == null) return null;
    return File(xFile.path);
  }
}

/// Media Service Provider
final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService();
});

