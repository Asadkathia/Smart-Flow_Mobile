import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_media_model.freezed.dart';
part 'visit_media_model.g.dart';

/// File type enum for visit media
enum MediaFileType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('pdf')
  pdf,
}

/// Visit Media Model (PRD Section 3.19)
/// 
/// Represents media files (images, videos, PDFs) attached to visits.
@freezed
class VisitMediaModel with _$VisitMediaModel {
  const VisitMediaModel._();

  const factory VisitMediaModel({
    required String id,
    required String orgId,
    required String visitId,
    required String uploadedBy,
    required String filePath,
    @Default(MediaFileType.image) MediaFileType fileType,
    DateTime? createdAt,
  }) = _VisitMediaModel;

  factory VisitMediaModel.fromJson(Map<String, dynamic> json) =>
      _$VisitMediaModelFromJson(json);

  /// Check if this is an image
  bool get isImage => fileType == MediaFileType.image;

  /// Check if this is a video
  bool get isVideo => fileType == MediaFileType.video;

  /// Check if this is a PDF
  bool get isPdf => fileType == MediaFileType.pdf;

  /// Get file extension from path
  String get fileExtension {
    final parts = filePath.split('.');
    return parts.isNotEmpty ? parts.last.toLowerCase() : '';
  }
}



