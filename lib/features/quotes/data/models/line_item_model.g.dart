// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineItemModelImpl _$$LineItemModelImplFromJson(Map<String, dynamic> json) =>
    _$LineItemModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      quoteId: json['quote_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      type: $enumDecode(_$LineItemTypeEnumMap, json['type']),
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String,
      unit: json['unit'] as String,
      qty: (json['qty'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      taxable: json['taxable'] as bool,
      version: (json['version'] as num?)?.toInt() ?? 1,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LineItemModelImplToJson(_$LineItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'quote_id': instance.quoteId,
      'invoice_id': instance.invoiceId,
      'type': _$LineItemTypeEnumMap[instance.type]!,
      'reference_id': instance.referenceId,
      'description': instance.description,
      'unit': instance.unit,
      'qty': instance.qty,
      'unit_price': instance.unitPrice,
      'taxable': instance.taxable,
      'version': instance.version,
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$LineItemTypeEnumMap = {
  LineItemType.service: 'service',
  LineItemType.material: 'material',
  LineItemType.service_call_fee: 'service_call_fee',
  LineItemType.discount: 'discount',
};
