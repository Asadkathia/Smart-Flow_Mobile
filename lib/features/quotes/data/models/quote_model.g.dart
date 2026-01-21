// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteModelImpl _$$QuoteModelImplFromJson(Map<String, dynamic> json) =>
    _$QuoteModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      visitId: json['visit_id'] as String,
      quoteNumber: json['quote_number'] as String,
      status: $enumDecode(_$QuoteStatusEnumMap, json['status']),
      taxable: json['taxable'] as bool? ?? true,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountTotal: (json['discount_total'] as num?)?.toDouble() ?? 0.0,
      taxTotal: (json['tax_total'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      lockedAt: json['locked_at'] == null
          ? null
          : DateTime.parse(json['locked_at'] as String),
      lockedBy: json['locked_by'] as String?,
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      notes: json['notes'] as String?,
      terms: json['terms'] as String?,
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.parse(json['expiration_date'] as String),
      lineItems: (json['lineItems'] as List<dynamic>?)
              ?.map((e) => LineItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$QuoteModelImplToJson(_$QuoteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'visit_id': instance.visitId,
      'quote_number': instance.quoteNumber,
      'status': _$QuoteStatusEnumMap[instance.status]!,
      'taxable': instance.taxable,
      'subtotal': instance.subtotal,
      'discount_total': instance.discountTotal,
      'tax_total': instance.taxTotal,
      'grand_total': instance.grandTotal,
      'locked_at': instance.lockedAt?.toIso8601String(),
      'locked_by': instance.lockedBy,
      'version': instance.version,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'terms': instance.terms,
      'expiration_date': instance.expirationDate?.toIso8601String(),
      'lineItems': instance.lineItems,
    };

const _$QuoteStatusEnumMap = {
  QuoteStatus.draft: 'draft',
  QuoteStatus.finalized: 'finalized',
  QuoteStatus.invoiced: 'invoiced',
};
