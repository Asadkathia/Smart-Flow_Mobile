// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemModelImpl _$$InventoryItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryItemModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      price: (json['sale_price'] as num).toDouble(),
      sku: json['sku'] as String?,
      imageUrl: json['image_path'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      isActive: json['active'] as bool? ?? true,
      isAiDetected: json['isAiDetected'] as bool? ?? false,
      createdBy: json['created_by'] as String?,
      aiSuggestedPrice: (json['ai_suggested_price'] as num?)?.toDouble(),
      taxableDefault: json['taxable_default'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InventoryItemModelImplToJson(
        _$InventoryItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'name': instance.name,
      'unit': instance.unit,
      'sale_price': instance.price,
      'sku': instance.sku,
      'image_path': instance.imageUrl,
      'category': instance.category,
      'description': instance.description,
      'active': instance.isActive,
      'isAiDetected': instance.isAiDetected,
      'created_by': instance.createdBy,
      'ai_suggested_price': instance.aiSuggestedPrice,
      'taxable_default': instance.taxableDefault,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AiPriceSuggestionImpl _$$AiPriceSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$AiPriceSuggestionImpl(
      suggestedPrice: (json['suggestedPrice'] as num).toDouble(),
      currency: json['currency'] as String,
      confidence: json['confidence'] as String?,
      reasoning: json['reasoning'] as String?,
      similarItems: (json['similarItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AiPriceSuggestionImplToJson(
        _$AiPriceSuggestionImpl instance) =>
    <String, dynamic>{
      'suggestedPrice': instance.suggestedPrice,
      'currency': instance.currency,
      'confidence': instance.confidence,
      'reasoning': instance.reasoning,
      'similarItems': instance.similarItems,
    };

_$AiItemDetectionImpl _$$AiItemDetectionImplFromJson(
        Map<String, dynamic> json) =>
    _$AiItemDetectionImpl(
      name: json['name'] as String,
      unit: json['unit'] as String,
      suggestedPrice: (json['suggestedPrice'] as num).toDouble(),
      sku: json['sku'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      confidence: json['confidence'] as String?,
    );

Map<String, dynamic> _$$AiItemDetectionImplToJson(
        _$AiItemDetectionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'unit': instance.unit,
      'suggestedPrice': instance.suggestedPrice,
      'sku': instance.sku,
      'category': instance.category,
      'description': instance.description,
      'brand': instance.brand,
      'confidence': instance.confidence,
    };
