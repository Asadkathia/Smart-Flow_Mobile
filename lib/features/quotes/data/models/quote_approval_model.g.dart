// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_approval_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteApprovalModelImpl _$$QuoteApprovalModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuoteApprovalModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      quoteId: json['quote_id'] as String,
      approvalStatus:
          $enumDecode(_$ApprovalStatusEnumMap, json['approval_status']),
      method: $enumDecode(_$ApprovalMethodEnumMap, json['method']),
      recordedBy: json['recorded_by'] as String,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$QuoteApprovalModelImplToJson(
        _$QuoteApprovalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'quote_id': instance.quoteId,
      'approval_status': _$ApprovalStatusEnumMap[instance.approvalStatus]!,
      'method': _$ApprovalMethodEnumMap[instance.method]!,
      'recorded_by': instance.recordedBy,
      'recorded_at': instance.recordedAt.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ApprovalStatusEnumMap = {
  ApprovalStatus.approved: 'approved',
  ApprovalStatus.rejected: 'rejected',
};

const _$ApprovalMethodEnumMap = {
  ApprovalMethod.call: 'call',
  ApprovalMethod.sms: 'sms',
};
