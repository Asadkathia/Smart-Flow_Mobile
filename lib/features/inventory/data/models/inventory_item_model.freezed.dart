// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryItemModel _$InventoryItemModelFromJson(Map<String, dynamic> json) {
  return _InventoryItemModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryItemModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError; // PRD Section 3.8
  String get name => throw _privateConstructorUsedError;
  String get unit =>
      throw _privateConstructorUsedError; // e.g., "each", "lb", "sq ft"
  @JsonKey(name: 'sale_price')
  double get price => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_path')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool get isActive => throw _privateConstructorUsedError;
  bool get isAiDetected => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError; // Technician ID
  @JsonKey(name: 'ai_suggested_price')
  double? get aiSuggestedPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'taxable_default')
  bool get taxableDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryItemModelCopyWith<InventoryItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemModelCopyWith<$Res> {
  factory $InventoryItemModelCopyWith(
          InventoryItemModel value, $Res Function(InventoryItemModel) then) =
      _$InventoryItemModelCopyWithImpl<$Res, InventoryItemModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String name,
      String unit,
      @JsonKey(name: 'sale_price') double price,
      String? sku,
      @JsonKey(name: 'image_path') String? imageUrl,
      String? category,
      String? description,
      @JsonKey(name: 'active') bool isActive,
      bool isAiDetected,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'ai_suggested_price') double? aiSuggestedPrice,
      @JsonKey(name: 'taxable_default') bool taxableDefault,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$InventoryItemModelCopyWithImpl<$Res, $Val extends InventoryItemModel>
    implements $InventoryItemModelCopyWith<$Res> {
  _$InventoryItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? name = null,
    Object? unit = null,
    Object? price = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? isAiDetected = null,
    Object? createdBy = freezed,
    Object? aiSuggestedPrice = freezed,
    Object? taxableDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAiDetected: null == isAiDetected
          ? _value.isAiDetected
          : isAiDetected // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      aiSuggestedPrice: freezed == aiSuggestedPrice
          ? _value.aiSuggestedPrice
          : aiSuggestedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      taxableDefault: null == taxableDefault
          ? _value.taxableDefault
          : taxableDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryItemModelImplCopyWith<$Res>
    implements $InventoryItemModelCopyWith<$Res> {
  factory _$$InventoryItemModelImplCopyWith(_$InventoryItemModelImpl value,
          $Res Function(_$InventoryItemModelImpl) then) =
      __$$InventoryItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String name,
      String unit,
      @JsonKey(name: 'sale_price') double price,
      String? sku,
      @JsonKey(name: 'image_path') String? imageUrl,
      String? category,
      String? description,
      @JsonKey(name: 'active') bool isActive,
      bool isAiDetected,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'ai_suggested_price') double? aiSuggestedPrice,
      @JsonKey(name: 'taxable_default') bool taxableDefault,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$InventoryItemModelImplCopyWithImpl<$Res>
    extends _$InventoryItemModelCopyWithImpl<$Res, _$InventoryItemModelImpl>
    implements _$$InventoryItemModelImplCopyWith<$Res> {
  __$$InventoryItemModelImplCopyWithImpl(_$InventoryItemModelImpl _value,
      $Res Function(_$InventoryItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? name = null,
    Object? unit = null,
    Object? price = null,
    Object? sku = freezed,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? isAiDetected = null,
    Object? createdBy = freezed,
    Object? aiSuggestedPrice = freezed,
    Object? taxableDefault = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InventoryItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAiDetected: null == isAiDetected
          ? _value.isAiDetected
          : isAiDetected // ignore: cast_nullable_to_non_nullable
              as bool,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      aiSuggestedPrice: freezed == aiSuggestedPrice
          ? _value.aiSuggestedPrice
          : aiSuggestedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      taxableDefault: null == taxableDefault
          ? _value.taxableDefault
          : taxableDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemModelImpl implements _InventoryItemModel {
  const _$InventoryItemModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      required this.name,
      required this.unit,
      @JsonKey(name: 'sale_price') required this.price,
      this.sku,
      @JsonKey(name: 'image_path') this.imageUrl,
      this.category,
      this.description,
      @JsonKey(name: 'active') this.isActive = true,
      this.isAiDetected = false,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'ai_suggested_price') this.aiSuggestedPrice,
      @JsonKey(name: 'taxable_default') this.taxableDefault = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$InventoryItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
// PRD Section 3.8
  @override
  final String name;
  @override
  final String unit;
// e.g., "each", "lb", "sq ft"
  @override
  @JsonKey(name: 'sale_price')
  final double price;
  @override
  final String? sku;
  @override
  @JsonKey(name: 'image_path')
  final String? imageUrl;
  @override
  final String? category;
  @override
  final String? description;
  @override
  @JsonKey(name: 'active')
  final bool isActive;
  @override
  @JsonKey()
  final bool isAiDetected;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
// Technician ID
  @override
  @JsonKey(name: 'ai_suggested_price')
  final double? aiSuggestedPrice;
  @override
  @JsonKey(name: 'taxable_default')
  final bool taxableDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'InventoryItemModel(id: $id, orgId: $orgId, name: $name, unit: $unit, price: $price, sku: $sku, imageUrl: $imageUrl, category: $category, description: $description, isActive: $isActive, isAiDetected: $isAiDetected, createdBy: $createdBy, aiSuggestedPrice: $aiSuggestedPrice, taxableDefault: $taxableDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAiDetected, isAiDetected) ||
                other.isAiDetected == isAiDetected) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.aiSuggestedPrice, aiSuggestedPrice) ||
                other.aiSuggestedPrice == aiSuggestedPrice) &&
            (identical(other.taxableDefault, taxableDefault) ||
                other.taxableDefault == taxableDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      name,
      unit,
      price,
      sku,
      imageUrl,
      category,
      description,
      isActive,
      isAiDetected,
      createdBy,
      aiSuggestedPrice,
      taxableDefault,
      createdAt,
      updatedAt);

  /// Create a copy of InventoryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemModelImplCopyWith<_$InventoryItemModelImpl> get copyWith =>
      __$$InventoryItemModelImplCopyWithImpl<_$InventoryItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemModelImplToJson(
      this,
    );
  }
}

abstract class _InventoryItemModel implements InventoryItemModel {
  const factory _InventoryItemModel(
          {required final String id,
          @JsonKey(name: 'org_id') required final String orgId,
          required final String name,
          required final String unit,
          @JsonKey(name: 'sale_price') required final double price,
          final String? sku,
          @JsonKey(name: 'image_path') final String? imageUrl,
          final String? category,
          final String? description,
          @JsonKey(name: 'active') final bool isActive,
          final bool isAiDetected,
          @JsonKey(name: 'created_by') final String? createdBy,
          @JsonKey(name: 'ai_suggested_price') final double? aiSuggestedPrice,
          @JsonKey(name: 'taxable_default') final bool taxableDefault,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$InventoryItemModelImpl;

  factory _InventoryItemModel.fromJson(Map<String, dynamic> json) =
      _$InventoryItemModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId; // PRD Section 3.8
  @override
  String get name;
  @override
  String get unit; // e.g., "each", "lb", "sq ft"
  @override
  @JsonKey(name: 'sale_price')
  double get price;
  @override
  String? get sku;
  @override
  @JsonKey(name: 'image_path')
  String? get imageUrl;
  @override
  String? get category;
  @override
  String? get description;
  @override
  @JsonKey(name: 'active')
  bool get isActive;
  @override
  bool get isAiDetected;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy; // Technician ID
  @override
  @JsonKey(name: 'ai_suggested_price')
  double? get aiSuggestedPrice;
  @override
  @JsonKey(name: 'taxable_default')
  bool get taxableDefault;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of InventoryItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryItemModelImplCopyWith<_$InventoryItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiPriceSuggestion _$AiPriceSuggestionFromJson(Map<String, dynamic> json) {
  return _AiPriceSuggestion.fromJson(json);
}

/// @nodoc
mixin _$AiPriceSuggestion {
  double get suggestedPrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get confidence =>
      throw _privateConstructorUsedError; // "high", "medium", "low"
  String? get reasoning => throw _privateConstructorUsedError;
  List<String>? get similarItems => throw _privateConstructorUsedError;

  /// Serializes this AiPriceSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiPriceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiPriceSuggestionCopyWith<AiPriceSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiPriceSuggestionCopyWith<$Res> {
  factory $AiPriceSuggestionCopyWith(
          AiPriceSuggestion value, $Res Function(AiPriceSuggestion) then) =
      _$AiPriceSuggestionCopyWithImpl<$Res, AiPriceSuggestion>;
  @useResult
  $Res call(
      {double suggestedPrice,
      String currency,
      String? confidence,
      String? reasoning,
      List<String>? similarItems});
}

/// @nodoc
class _$AiPriceSuggestionCopyWithImpl<$Res, $Val extends AiPriceSuggestion>
    implements $AiPriceSuggestionCopyWith<$Res> {
  _$AiPriceSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiPriceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedPrice = null,
    Object? currency = null,
    Object? confidence = freezed,
    Object? reasoning = freezed,
    Object? similarItems = freezed,
  }) {
    return _then(_value.copyWith(
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      similarItems: freezed == similarItems
          ? _value.similarItems
          : similarItems // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiPriceSuggestionImplCopyWith<$Res>
    implements $AiPriceSuggestionCopyWith<$Res> {
  factory _$$AiPriceSuggestionImplCopyWith(_$AiPriceSuggestionImpl value,
          $Res Function(_$AiPriceSuggestionImpl) then) =
      __$$AiPriceSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double suggestedPrice,
      String currency,
      String? confidence,
      String? reasoning,
      List<String>? similarItems});
}

/// @nodoc
class __$$AiPriceSuggestionImplCopyWithImpl<$Res>
    extends _$AiPriceSuggestionCopyWithImpl<$Res, _$AiPriceSuggestionImpl>
    implements _$$AiPriceSuggestionImplCopyWith<$Res> {
  __$$AiPriceSuggestionImplCopyWithImpl(_$AiPriceSuggestionImpl _value,
      $Res Function(_$AiPriceSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiPriceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedPrice = null,
    Object? currency = null,
    Object? confidence = freezed,
    Object? reasoning = freezed,
    Object? similarItems = freezed,
  }) {
    return _then(_$AiPriceSuggestionImpl(
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      similarItems: freezed == similarItems
          ? _value._similarItems
          : similarItems // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiPriceSuggestionImpl implements _AiPriceSuggestion {
  const _$AiPriceSuggestionImpl(
      {required this.suggestedPrice,
      required this.currency,
      this.confidence,
      this.reasoning,
      final List<String>? similarItems})
      : _similarItems = similarItems;

  factory _$AiPriceSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiPriceSuggestionImplFromJson(json);

  @override
  final double suggestedPrice;
  @override
  final String currency;
  @override
  final String? confidence;
// "high", "medium", "low"
  @override
  final String? reasoning;
  final List<String>? _similarItems;
  @override
  List<String>? get similarItems {
    final value = _similarItems;
    if (value == null) return null;
    if (_similarItems is EqualUnmodifiableListView) return _similarItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AiPriceSuggestion(suggestedPrice: $suggestedPrice, currency: $currency, confidence: $confidence, reasoning: $reasoning, similarItems: $similarItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiPriceSuggestionImpl &&
            (identical(other.suggestedPrice, suggestedPrice) ||
                other.suggestedPrice == suggestedPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            const DeepCollectionEquality()
                .equals(other._similarItems, _similarItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      suggestedPrice,
      currency,
      confidence,
      reasoning,
      const DeepCollectionEquality().hash(_similarItems));

  /// Create a copy of AiPriceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiPriceSuggestionImplCopyWith<_$AiPriceSuggestionImpl> get copyWith =>
      __$$AiPriceSuggestionImplCopyWithImpl<_$AiPriceSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiPriceSuggestionImplToJson(
      this,
    );
  }
}

abstract class _AiPriceSuggestion implements AiPriceSuggestion {
  const factory _AiPriceSuggestion(
      {required final double suggestedPrice,
      required final String currency,
      final String? confidence,
      final String? reasoning,
      final List<String>? similarItems}) = _$AiPriceSuggestionImpl;

  factory _AiPriceSuggestion.fromJson(Map<String, dynamic> json) =
      _$AiPriceSuggestionImpl.fromJson;

  @override
  double get suggestedPrice;
  @override
  String get currency;
  @override
  String? get confidence; // "high", "medium", "low"
  @override
  String? get reasoning;
  @override
  List<String>? get similarItems;

  /// Create a copy of AiPriceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiPriceSuggestionImplCopyWith<_$AiPriceSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiItemDetection _$AiItemDetectionFromJson(Map<String, dynamic> json) {
  return _AiItemDetection.fromJson(json);
}

/// @nodoc
mixin _$AiItemDetection {
  String get name => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get suggestedPrice => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get confidence => throw _privateConstructorUsedError;

  /// Serializes this AiItemDetection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiItemDetection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiItemDetectionCopyWith<AiItemDetection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiItemDetectionCopyWith<$Res> {
  factory $AiItemDetectionCopyWith(
          AiItemDetection value, $Res Function(AiItemDetection) then) =
      _$AiItemDetectionCopyWithImpl<$Res, AiItemDetection>;
  @useResult
  $Res call(
      {String name,
      String unit,
      double suggestedPrice,
      String? sku,
      String? category,
      String? description,
      String? brand,
      String? confidence});
}

/// @nodoc
class _$AiItemDetectionCopyWithImpl<$Res, $Val extends AiItemDetection>
    implements $AiItemDetectionCopyWith<$Res> {
  _$AiItemDetectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiItemDetection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? unit = null,
    Object? suggestedPrice = null,
    Object? sku = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? brand = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiItemDetectionImplCopyWith<$Res>
    implements $AiItemDetectionCopyWith<$Res> {
  factory _$$AiItemDetectionImplCopyWith(_$AiItemDetectionImpl value,
          $Res Function(_$AiItemDetectionImpl) then) =
      __$$AiItemDetectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String unit,
      double suggestedPrice,
      String? sku,
      String? category,
      String? description,
      String? brand,
      String? confidence});
}

/// @nodoc
class __$$AiItemDetectionImplCopyWithImpl<$Res>
    extends _$AiItemDetectionCopyWithImpl<$Res, _$AiItemDetectionImpl>
    implements _$$AiItemDetectionImplCopyWith<$Res> {
  __$$AiItemDetectionImplCopyWithImpl(
      _$AiItemDetectionImpl _value, $Res Function(_$AiItemDetectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiItemDetection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? unit = null,
    Object? suggestedPrice = null,
    Object? sku = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? brand = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_$AiItemDetectionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiItemDetectionImpl implements _AiItemDetection {
  const _$AiItemDetectionImpl(
      {required this.name,
      required this.unit,
      required this.suggestedPrice,
      this.sku,
      this.category,
      this.description,
      this.brand,
      this.confidence});

  factory _$AiItemDetectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiItemDetectionImplFromJson(json);

  @override
  final String name;
  @override
  final String unit;
  @override
  final double suggestedPrice;
  @override
  final String? sku;
  @override
  final String? category;
  @override
  final String? description;
  @override
  final String? brand;
  @override
  final String? confidence;

  @override
  String toString() {
    return 'AiItemDetection(name: $name, unit: $unit, suggestedPrice: $suggestedPrice, sku: $sku, category: $category, description: $description, brand: $brand, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiItemDetectionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.suggestedPrice, suggestedPrice) ||
                other.suggestedPrice == suggestedPrice) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, unit, suggestedPrice, sku,
      category, description, brand, confidence);

  /// Create a copy of AiItemDetection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiItemDetectionImplCopyWith<_$AiItemDetectionImpl> get copyWith =>
      __$$AiItemDetectionImplCopyWithImpl<_$AiItemDetectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiItemDetectionImplToJson(
      this,
    );
  }
}

abstract class _AiItemDetection implements AiItemDetection {
  const factory _AiItemDetection(
      {required final String name,
      required final String unit,
      required final double suggestedPrice,
      final String? sku,
      final String? category,
      final String? description,
      final String? brand,
      final String? confidence}) = _$AiItemDetectionImpl;

  factory _AiItemDetection.fromJson(Map<String, dynamic> json) =
      _$AiItemDetectionImpl.fromJson;

  @override
  String get name;
  @override
  String get unit;
  @override
  double get suggestedPrice;
  @override
  String? get sku;
  @override
  String? get category;
  @override
  String? get description;
  @override
  String? get brand;
  @override
  String? get confidence;

  /// Create a copy of AiItemDetection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiItemDetectionImplCopyWith<_$AiItemDetectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
