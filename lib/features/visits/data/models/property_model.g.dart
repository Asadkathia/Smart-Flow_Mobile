// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyModelImpl _$$PropertyModelImplFromJson(Map<String, dynamic> json) =>
    _$PropertyModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      customerId: json['customer_id'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PropertyModelImplToJson(_$PropertyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'customer_id': instance.customerId,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
