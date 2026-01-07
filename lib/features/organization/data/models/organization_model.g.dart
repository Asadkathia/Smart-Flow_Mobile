// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationModelImpl _$$OrganizationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      timezone: json['timezone'] as String? ?? 'America/New_York',
      currency: json['currency'] as String? ?? 'USD',
      orgPrefix: json['org_prefix'] as String?,
      plan: json['plan'] as String?,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$OrganizationModelImplToJson(
        _$OrganizationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'timezone': instance.timezone,
      'currency': instance.currency,
      'org_prefix': instance.orgPrefix,
      'plan': instance.plan,
      'settings': instance.settings,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
