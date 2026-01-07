// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiChatMessageImpl _$$AiChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$AiChatMessageImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AiChatMessageImplToJson(_$AiChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$AiRequestImpl _$$AiRequestImplFromJson(Map<String, dynamic> json) =>
    _$AiRequestImpl(
      visitId: json['visitId'] as String,
      message: json['message'] as String,
      imageBase64: json['imageBase64'] as String?,
      conversationHistory: (json['conversationHistory'] as List<dynamic>?)
          ?.map((e) => AiChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AiRequestImplToJson(_$AiRequestImpl instance) =>
    <String, dynamic>{
      'visitId': instance.visitId,
      'message': instance.message,
      'imageBase64': instance.imageBase64,
      'conversationHistory': instance.conversationHistory,
    };

_$AiResponseImpl _$$AiResponseImplFromJson(Map<String, dynamic> json) =>
    _$AiResponseImpl(
      message: json['message'] as String,
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      confidence: json['confidence'] as String?,
    );

Map<String, dynamic> _$$AiResponseImplToJson(_$AiResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'suggestions': instance.suggestions,
      'confidence': instance.confidence,
    };

_$AiSuggestionImpl _$$AiSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$AiSuggestionImpl(
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble(),
      reasoning: json['reasoning'] as String?,
    );

Map<String, dynamic> _$$AiSuggestionImplToJson(_$AiSuggestionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'estimatedPrice': instance.estimatedPrice,
      'reasoning': instance.reasoning,
    };
