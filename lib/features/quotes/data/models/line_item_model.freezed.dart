// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'line_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LineItemModel _$LineItemModelFromJson(Map<String, dynamic> json) {
  return _LineItemModel.fromJson(json);
}

/// @nodoc
mixin _$LineItemModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_id')
  String? get quoteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_id')
  String? get invoiceId => throw _privateConstructorUsedError;
  LineItemType get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty')
  int get qty => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'taxable')
  bool get taxable => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LineItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineItemModelCopyWith<LineItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineItemModelCopyWith<$Res> {
  factory $LineItemModelCopyWith(
          LineItemModel value, $Res Function(LineItemModel) then) =
      _$LineItemModelCopyWithImpl<$Res, LineItemModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'quote_id') String? quoteId,
      @JsonKey(name: 'invoice_id') String? invoiceId,
      LineItemType type,
      @JsonKey(name: 'reference_id') String? referenceId,
      String description,
      String unit,
      @JsonKey(name: 'qty') int qty,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'taxable') bool taxable,
      int version,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$LineItemModelCopyWithImpl<$Res, $Val extends LineItemModel>
    implements $LineItemModelCopyWith<$Res> {
  _$LineItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? quoteId = freezed,
    Object? invoiceId = freezed,
    Object? type = null,
    Object? referenceId = freezed,
    Object? description = null,
    Object? unit = null,
    Object? qty = null,
    Object? unitPrice = null,
    Object? taxable = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? createdAt = null,
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
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LineItemType,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      taxable: null == taxable
          ? _value.taxable
          : taxable // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LineItemModelImplCopyWith<$Res>
    implements $LineItemModelCopyWith<$Res> {
  factory _$$LineItemModelImplCopyWith(
          _$LineItemModelImpl value, $Res Function(_$LineItemModelImpl) then) =
      __$$LineItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'quote_id') String? quoteId,
      @JsonKey(name: 'invoice_id') String? invoiceId,
      LineItemType type,
      @JsonKey(name: 'reference_id') String? referenceId,
      String description,
      String unit,
      @JsonKey(name: 'qty') int qty,
      @JsonKey(name: 'unit_price') double unitPrice,
      @JsonKey(name: 'taxable') bool taxable,
      int version,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$LineItemModelImplCopyWithImpl<$Res>
    extends _$LineItemModelCopyWithImpl<$Res, _$LineItemModelImpl>
    implements _$$LineItemModelImplCopyWith<$Res> {
  __$$LineItemModelImplCopyWithImpl(
      _$LineItemModelImpl _value, $Res Function(_$LineItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? quoteId = freezed,
    Object? invoiceId = freezed,
    Object? type = null,
    Object? referenceId = freezed,
    Object? description = null,
    Object? unit = null,
    Object? qty = null,
    Object? unitPrice = null,
    Object? taxable = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$LineItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteId: freezed == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LineItemType,
      referenceId: freezed == referenceId
          ? _value.referenceId
          : referenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      taxable: null == taxable
          ? _value.taxable
          : taxable // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LineItemModelImpl implements _LineItemModel {
  const _$LineItemModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'quote_id') this.quoteId,
      @JsonKey(name: 'invoice_id') this.invoiceId,
      required this.type,
      @JsonKey(name: 'reference_id') this.referenceId,
      required this.description,
      required this.unit,
      @JsonKey(name: 'qty') required this.qty,
      @JsonKey(name: 'unit_price') required this.unitPrice,
      @JsonKey(name: 'taxable') required this.taxable,
      this.version = 1,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$LineItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineItemModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'quote_id')
  final String? quoteId;
  @override
  @JsonKey(name: 'invoice_id')
  final String? invoiceId;
  @override
  final LineItemType type;
  @override
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  final String description;
  @override
  final String unit;
  @override
  @JsonKey(name: 'qty')
  final int qty;
  @override
  @JsonKey(name: 'unit_price')
  final double unitPrice;
  @override
  @JsonKey(name: 'taxable')
  final bool taxable;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'LineItemModel(id: $id, orgId: $orgId, quoteId: $quoteId, invoiceId: $invoiceId, type: $type, referenceId: $referenceId, description: $description, unit: $unit, qty: $qty, unitPrice: $unitPrice, taxable: $taxable, version: $version, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.quoteId, quoteId) || other.quoteId == quoteId) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.taxable, taxable) || other.taxable == taxable) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      quoteId,
      invoiceId,
      type,
      referenceId,
      description,
      unit,
      qty,
      unitPrice,
      taxable,
      version,
      updatedAt,
      createdAt);

  /// Create a copy of LineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineItemModelImplCopyWith<_$LineItemModelImpl> get copyWith =>
      __$$LineItemModelImplCopyWithImpl<_$LineItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineItemModelImplToJson(
      this,
    );
  }
}

abstract class _LineItemModel implements LineItemModel {
  const factory _LineItemModel(
          {required final String id,
          @JsonKey(name: 'org_id') required final String orgId,
          @JsonKey(name: 'quote_id') final String? quoteId,
          @JsonKey(name: 'invoice_id') final String? invoiceId,
          required final LineItemType type,
          @JsonKey(name: 'reference_id') final String? referenceId,
          required final String description,
          required final String unit,
          @JsonKey(name: 'qty') required final int qty,
          @JsonKey(name: 'unit_price') required final double unitPrice,
          @JsonKey(name: 'taxable') required final bool taxable,
          final int version,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$LineItemModelImpl;

  factory _LineItemModel.fromJson(Map<String, dynamic> json) =
      _$LineItemModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'quote_id')
  String? get quoteId;
  @override
  @JsonKey(name: 'invoice_id')
  String? get invoiceId;
  @override
  LineItemType get type;
  @override
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  String get description;
  @override
  String get unit;
  @override
  @JsonKey(name: 'qty')
  int get qty;
  @override
  @JsonKey(name: 'unit_price')
  double get unitPrice;
  @override
  @JsonKey(name: 'taxable')
  bool get taxable;
  @override
  int get version;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of LineItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineItemModelImplCopyWith<_$LineItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
