import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

/// Note Model (PRD Section 3.7)
/// 
/// Represents a note attached to a visit.
@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'visit_id') required String visitId,
    @JsonKey(name: 'author_id') required String authorId,
    @JsonKey(name: 'body') required String body, // PRD: body (not content)
    @Default(1) int version,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Remove if not in PRD: author_name, is_internal, image_urls
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

/// Extension methods for NoteModel
extension NoteModelX on NoteModel {
  /// Get content (alias for body for backward compatibility)
  String get content => body;

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          return 'Just now';
        }
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

  /// Get preview text (first 100 chars)
  String get preview {
    if (body.length <= 100) return body;
    return '${body.substring(0, 100)}...';
  }
}

