// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerModelImpl _$$CustomerModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      preferredContactMethod: $enumDecodeNullable(
              _$PreferredContactMethodEnumMap,
              json['preferred_contact_method']) ??
          PreferredContactMethod.call,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CustomerModelImplToJson(_$CustomerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'preferred_contact_method':
          _$PreferredContactMethodEnumMap[instance.preferredContactMethod]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PreferredContactMethodEnumMap = {
  PreferredContactMethod.call: 'call',
  PreferredContactMethod.sms: 'sms',
};
