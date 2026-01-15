// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceModelImpl _$$InvoiceModelImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      visitId: json['visitId'] as String,
      quoteId: json['quoteId'] as String?,
      invoiceNumber: json['invoiceNumber'] as String,
      status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
      total: (json['total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      lineItems: (json['lineItems'] as List<dynamic>)
          .map((e) => LineItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      propertyAddress: json['propertyAddress'] as String?,
      visitTitle: json['visitTitle'] as String?,
      notes: json['notes'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InvoiceModelImplToJson(_$InvoiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'visitId': instance.visitId,
      'quoteId': instance.quoteId,
      'invoiceNumber': instance.invoiceNumber,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'taxAmount': instance.taxAmount,
      'lineItems': instance.lineItems,
      'customerName': instance.customerName,
      'customerEmail': instance.customerEmail,
      'customerPhone': instance.customerPhone,
      'propertyAddress': instance.propertyAddress,
      'visitTitle': instance.visitTitle,
      'notes': instance.notes,
      'dueDate': instance.dueDate?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'version': instance.version,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.unpaid: 'unpaid',
  InvoiceStatus.partiallyPaid: 'partially_paid',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.void_: 'void_',
  InvoiceStatus.refunded: 'refunded',
};

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      invoiceId: json['invoice_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
      reference: json['reference'] as String?,
      receivedBy: json['received_by'] as String,
      receivedAt: DateTime.parse(json['received_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'invoice_id': instance.invoiceId,
      'amount': instance.amount,
      'method': _$PaymentMethodEnumMap[instance.method]!,
      'reference': instance.reference,
      'received_by': instance.receivedBy,
      'received_at': instance.receivedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.stripeLink: 'stripe_link',
};
