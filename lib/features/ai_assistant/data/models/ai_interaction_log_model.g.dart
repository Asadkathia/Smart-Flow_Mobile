// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_interaction_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiInteractionLogModelImpl _$$AiInteractionLogModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AiInteractionLogModelImpl(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      technicianId: json['technicianId'] as String,
      visitId: json['visitId'] as String,
      prompt: json['prompt'] as String,
      response: json['response'] as String,
      model: json['model'] as String,
      tokensIn: (json['tokensIn'] as num?)?.toInt(),
      tokensOut: (json['tokensOut'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AiInteractionLogModelImplToJson(
        _$AiInteractionLogModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'technicianId': instance.technicianId,
      'visitId': instance.visitId,
      'prompt': instance.prompt,
      'response': instance.response,
      'model': instance.model,
      'tokensIn': instance.tokensIn,
      'tokensOut': instance.tokensOut,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
