// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingSettingsModelImpl _$$BillingSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BillingSettingsModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      serviceCallFee: (json['serviceCallFee'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['taxRate'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BillingSettingsModelImplToJson(
        _$BillingSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'serviceCallFee': instance.serviceCallFee,
      'taxRate': instance.taxRate,
      'currency': instance.currency,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
