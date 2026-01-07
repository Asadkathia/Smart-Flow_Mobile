// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sequence_counter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SequenceCounterModelImpl _$$SequenceCounterModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SequenceCounterModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      entityType: $enumDecode(_$SequenceEntityTypeEnumMap, json['entityType']),
      currentSequence: (json['currentSequence'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SequenceCounterModelImplToJson(
        _$SequenceCounterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'entityType': _$SequenceEntityTypeEnumMap[instance.entityType]!,
      'currentSequence': instance.currentSequence,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SequenceEntityTypeEnumMap = {
  SequenceEntityType.quote: 'quote',
  SequenceEntityType.invoice: 'invoice',
  SequenceEntityType.job: 'job',
};
