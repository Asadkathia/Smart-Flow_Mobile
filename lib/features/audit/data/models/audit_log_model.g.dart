// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogModelImpl _$$AuditLogModelImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      entity: json['entity'] as String,
      entityId: json['entityId'] as String,
      action: json['action'] as String,
      performedBy: json['performedBy'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AuditLogModelImplToJson(_$AuditLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'entity': instance.entity,
      'entityId': instance.entityId,
      'action': instance.action,
      'performedBy': instance.performedBy,
      'payload': instance.payload,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
