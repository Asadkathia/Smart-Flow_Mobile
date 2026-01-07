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
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postal_code'] as String,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      accessInstructions: json['access_instructions'] as String?,
      isPrimary: json['is_primary'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PropertyModelImplToJson(_$PropertyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'customer_id': instance.customerId,
      'address_line1': instance.addressLine1,
      'address_line2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'access_instructions': instance.accessInstructions,
      'is_primary': instance.isPrimary,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
