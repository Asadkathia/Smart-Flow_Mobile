// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitMediaModelImpl _$$VisitMediaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VisitMediaModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      visitId: json['visitId'] as String,
      uploadedBy: json['uploadedBy'] as String,
      filePath: json['filePath'] as String,
      fileType: $enumDecodeNullable(_$MediaFileTypeEnumMap, json['fileType']) ??
          MediaFileType.image,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VisitMediaModelImplToJson(
        _$VisitMediaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'visitId': instance.visitId,
      'uploadedBy': instance.uploadedBy,
      'filePath': instance.filePath,
      'fileType': _$MediaFileTypeEnumMap[instance.fileType]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$MediaFileTypeEnumMap = {
  MediaFileType.image: 'image',
  MediaFileType.video: 'video',
  MediaFileType.pdf: 'pdf',
};
