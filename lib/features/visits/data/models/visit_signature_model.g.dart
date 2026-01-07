// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_signature_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitSignatureModelImpl _$$VisitSignatureModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VisitSignatureModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      visitId: json['visitId'] as String,
      signedBy: json['signedBy'] as String,
      signaturePath: json['signaturePath'] as String,
      signedAt: json['signedAt'] == null
          ? null
          : DateTime.parse(json['signedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VisitSignatureModelImplToJson(
        _$VisitSignatureModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'visitId': instance.visitId,
      'signedBy': instance.signedBy,
      'signaturePath': instance.signaturePath,
      'signedAt': instance.signedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
