import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item_model.freezed.dart';
part 'inventory_item_model.g.dart';

/// Inventory Item Model
/// 
/// Represents an inventory item that can be used in quotes.
/// Technicians can create items manually or via AI detection.
@freezed
class InventoryItemModel with _$InventoryItemModel {
  const factory InventoryItemModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId, // PRD Section 3.8
    required String name,
    required String unit, // e.g., "each", "lb", "sq ft"
    @JsonKey(name: 'sale_price') required double price,
    String? sku,
    @JsonKey(name: 'image_path') String? imageUrl,
    String? category,
    String? description,
    @Default(true) @JsonKey(name: 'active') bool isActive,
    @Default(false) bool isAiDetected,
    @JsonKey(name: 'created_by') String? createdBy, // Technician ID
    @JsonKey(name: 'ai_suggested_price') double? aiSuggestedPrice,
    @JsonKey(name: 'taxable_default') @Default(false) bool taxableDefault,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _InventoryItemModel;

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemModelFromJson(json);
}

/// AI Price Suggestion Model
/// 
/// Response from AI price suggestion API.
@freezed
class AiPriceSuggestion with _$AiPriceSuggestion {
  const factory AiPriceSuggestion({
    required double suggestedPrice,
    required String currency,
    String? confidence, // "high", "medium", "low"
    String? reasoning,
    List<String>? similarItems,
  }) = _AiPriceSuggestion;

  factory AiPriceSuggestion.fromJson(Map<String, dynamic> json) =>
      _$AiPriceSuggestionFromJson(json);
}

/// AI Item Detection Model
/// 
/// Response from AI auto-detection API.
@freezed
class AiItemDetection with _$AiItemDetection {
  const factory AiItemDetection({
    required String name,
    required String unit,
    required double suggestedPrice,
    String? sku,
    String? category,
    String? description,
    String? brand,
    String? confidence,
  }) = _AiItemDetection;

  factory AiItemDetection.fromJson(Map<String, dynamic> json) =>
      _$AiItemDetectionFromJson(json);
}
