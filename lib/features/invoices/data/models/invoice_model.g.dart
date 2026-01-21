// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceModelImpl _$$InvoiceModelImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      visitId: json['visit_id'] as String,
      quoteId: json['quote_id'] as String?,
      invoiceNumber: json['invoice_number'] as String,
      status: $enumDecode(_$InvoiceStatusEnumMap, json['status']),
      total: (json['total'] as num).toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      lineItems: (json['line_items'] as List<dynamic>?)
              ?.map((e) => LineItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerPhone: json['customer_phone'] as String?,
      propertyAddress: json['property_address'] as String?,
      visitTitle: json['visit_title'] as String?,
      notes: json['notes'] as String?,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InvoiceModelImplToJson(_$InvoiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'visit_id': instance.visitId,
      'quote_id': instance.quoteId,
      'invoice_number': instance.invoiceNumber,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'total': instance.total,
      'subtotal': instance.subtotal,
      'tax_amount': instance.taxAmount,
      'line_items': instance.lineItems,
      'customer_name': instance.customerName,
      'customer_email': instance.customerEmail,
      'customer_phone': instance.customerPhone,
      'property_address': instance.propertyAddress,
      'visit_title': instance.visitTitle,
      'notes': instance.notes,
      'due_date': instance.dueDate?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'version': instance.version,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
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
