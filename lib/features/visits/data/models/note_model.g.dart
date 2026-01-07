// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteModelImpl _$$NoteModelImplFromJson(Map<String, dynamic> json) =>
    _$NoteModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      visitId: json['visit_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String?,
      content: json['body'] as String,
      isInternal: json['is_internal'] as bool? ?? false,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NoteModelImplToJson(_$NoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'visit_id': instance.visitId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'body': instance.content,
      'is_internal': instance.isInternal,
      'image_urls': instance.imageUrls,
      'version': instance.version,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
