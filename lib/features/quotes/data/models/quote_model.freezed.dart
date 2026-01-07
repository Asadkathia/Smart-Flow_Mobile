// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteModel _$QuoteModelFromJson(Map<String, dynamic> json) {
  return _QuoteModel.fromJson(json);
}

/// @nodoc
mixin _$QuoteModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_id')
  String get visitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_number')
  String get quoteNumber => throw _privateConstructorUsedError;
  QuoteStatus get status => throw _privateConstructorUsedError;
  bool get taxable => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_total')
  double get discountTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_total')
  double get taxTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'grand_total')
  double get grandTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'locked_at')
  DateTime? get lockedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'locked_by')
  String? get lockedBy => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  List<LineItemModel> get lineItems => throw _privateConstructorUsedError;

  /// Serializes this QuoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteModelCopyWith<QuoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteModelCopyWith<$Res> {
  factory $QuoteModelCopyWith(
          QuoteModel value, $Res Function(QuoteModel) then) =
      _$QuoteModelCopyWithImpl<$Res, QuoteModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'quote_number') String quoteNumber,
      QuoteStatus status,
      bool taxable,
      double subtotal,
      @JsonKey(name: 'discount_total') double discountTotal,
      @JsonKey(name: 'tax_total') double taxTotal,
      @JsonKey(name: 'grand_total') double grandTotal,
      @JsonKey(name: 'locked_at') DateTime? lockedAt,
      @JsonKey(name: 'locked_by') String? lockedBy,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<LineItemModel> lineItems});
}

/// @nodoc
class _$QuoteModelCopyWithImpl<$Res, $Val extends QuoteModel>
    implements $QuoteModelCopyWith<$Res> {
  _$QuoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? quoteNumber = null,
    Object? status = null,
    Object? taxable = null,
    Object? subtotal = null,
    Object? discountTotal = null,
    Object? taxTotal = null,
    Object? grandTotal = null,
    Object? lockedAt = freezed,
    Object? lockedBy = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lineItems = null,
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
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuoteStatus,
      taxable: null == taxable
          ? _value.taxable
          : taxable // ignore: cast_nullable_to_non_nullable
              as bool,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountTotal: null == discountTotal
          ? _value.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxTotal: null == taxTotal
          ? _value.taxTotal
          : taxTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      lockedAt: freezed == lockedAt
          ? _value.lockedAt
          : lockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedBy: freezed == lockedBy
          ? _value.lockedBy
          : lockedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lineItems: null == lineItems
          ? _value.lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<LineItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteModelImplCopyWith<$Res>
    implements $QuoteModelCopyWith<$Res> {
  factory _$$QuoteModelImplCopyWith(
          _$QuoteModelImpl value, $Res Function(_$QuoteModelImpl) then) =
      __$$QuoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'quote_number') String quoteNumber,
      QuoteStatus status,
      bool taxable,
      double subtotal,
      @JsonKey(name: 'discount_total') double discountTotal,
      @JsonKey(name: 'tax_total') double taxTotal,
      @JsonKey(name: 'grand_total') double grandTotal,
      @JsonKey(name: 'locked_at') DateTime? lockedAt,
      @JsonKey(name: 'locked_by') String? lockedBy,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<LineItemModel> lineItems});
}

/// @nodoc
class __$$QuoteModelImplCopyWithImpl<$Res>
    extends _$QuoteModelCopyWithImpl<$Res, _$QuoteModelImpl>
    implements _$$QuoteModelImplCopyWith<$Res> {
  __$$QuoteModelImplCopyWithImpl(
      _$QuoteModelImpl _value, $Res Function(_$QuoteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? quoteNumber = null,
    Object? status = null,
    Object? taxable = null,
    Object? subtotal = null,
    Object? discountTotal = null,
    Object? taxTotal = null,
    Object? grandTotal = null,
    Object? lockedAt = freezed,
    Object? lockedBy = freezed,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lineItems = null,
  }) {
    return _then(_$QuoteModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteNumber: null == quoteNumber
          ? _value.quoteNumber
          : quoteNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuoteStatus,
      taxable: null == taxable
          ? _value.taxable
          : taxable // ignore: cast_nullable_to_non_nullable
              as bool,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discountTotal: null == discountTotal
          ? _value.discountTotal
          : discountTotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxTotal: null == taxTotal
          ? _value.taxTotal
          : taxTotal // ignore: cast_nullable_to_non_nullable
              as double,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      lockedAt: freezed == lockedAt
          ? _value.lockedAt
          : lockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedBy: freezed == lockedBy
          ? _value.lockedBy
          : lockedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lineItems: null == lineItems
          ? _value._lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<LineItemModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteModelImpl implements _QuoteModel {
  const _$QuoteModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'visit_id') required this.visitId,
      @JsonKey(name: 'quote_number') required this.quoteNumber,
      required this.status,
      this.taxable = true,
      this.subtotal = 0.0,
      @JsonKey(name: 'discount_total') this.discountTotal = 0.0,
      @JsonKey(name: 'tax_total') this.taxTotal = 0.0,
      @JsonKey(name: 'grand_total') this.grandTotal = 0.0,
      @JsonKey(name: 'locked_at') this.lockedAt,
      @JsonKey(name: 'locked_by') this.lockedBy,
      this.version = 1,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      final List<LineItemModel> lineItems = const []})
      : _lineItems = lineItems;

  factory _$QuoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'visit_id')
  final String visitId;
  @override
  @JsonKey(name: 'quote_number')
  final String quoteNumber;
  @override
  final QuoteStatus status;
  @override
  @JsonKey()
  final bool taxable;
  @override
  @JsonKey()
  final double subtotal;
  @override
  @JsonKey(name: 'discount_total')
  final double discountTotal;
  @override
  @JsonKey(name: 'tax_total')
  final double taxTotal;
  @override
  @JsonKey(name: 'grand_total')
  final double grandTotal;
  @override
  @JsonKey(name: 'locked_at')
  final DateTime? lockedAt;
  @override
  @JsonKey(name: 'locked_by')
  final String? lockedBy;
  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Relations
  final List<LineItemModel> _lineItems;
// Relations
  @override
  @JsonKey()
  List<LineItemModel> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  String toString() {
    return 'QuoteModel(id: $id, orgId: $orgId, visitId: $visitId, quoteNumber: $quoteNumber, status: $status, taxable: $taxable, subtotal: $subtotal, discountTotal: $discountTotal, taxTotal: $taxTotal, grandTotal: $grandTotal, lockedAt: $lockedAt, lockedBy: $lockedBy, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, lineItems: $lineItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.quoteNumber, quoteNumber) ||
                other.quoteNumber == quoteNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.taxable, taxable) || other.taxable == taxable) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discountTotal, discountTotal) ||
                other.discountTotal == discountTotal) &&
            (identical(other.taxTotal, taxTotal) ||
                other.taxTotal == taxTotal) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.lockedAt, lockedAt) ||
                other.lockedAt == lockedAt) &&
            (identical(other.lockedBy, lockedBy) ||
                other.lockedBy == lockedBy) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._lineItems, _lineItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      visitId,
      quoteNumber,
      status,
      taxable,
      subtotal,
      discountTotal,
      taxTotal,
      grandTotal,
      lockedAt,
      lockedBy,
      version,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_lineItems));

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteModelImplCopyWith<_$QuoteModelImpl> get copyWith =>
      __$$QuoteModelImplCopyWithImpl<_$QuoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteModelImplToJson(
      this,
    );
  }
}

abstract class _QuoteModel implements QuoteModel {
  const factory _QuoteModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'visit_id') required final String visitId,
      @JsonKey(name: 'quote_number') required final String quoteNumber,
      required final QuoteStatus status,
      final bool taxable,
      final double subtotal,
      @JsonKey(name: 'discount_total') final double discountTotal,
      @JsonKey(name: 'tax_total') final double taxTotal,
      @JsonKey(name: 'grand_total') final double grandTotal,
      @JsonKey(name: 'locked_at') final DateTime? lockedAt,
      @JsonKey(name: 'locked_by') final String? lockedBy,
      final int version,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final List<LineItemModel> lineItems}) = _$QuoteModelImpl;

  factory _QuoteModel.fromJson(Map<String, dynamic> json) =
      _$QuoteModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'visit_id')
  String get visitId;
  @override
  @JsonKey(name: 'quote_number')
  String get quoteNumber;
  @override
  QuoteStatus get status;
  @override
  bool get taxable;
  @override
  double get subtotal;
  @override
  @JsonKey(name: 'discount_total')
  double get discountTotal;
  @override
  @JsonKey(name: 'tax_total')
  double get taxTotal;
  @override
  @JsonKey(name: 'grand_total')
  double get grandTotal;
  @override
  @JsonKey(name: 'locked_at')
  DateTime? get lockedAt;
  @override
  @JsonKey(name: 'locked_by')
  String? get lockedBy;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // Relations
  @override
  List<LineItemModel> get lineItems;

  /// Create a copy of QuoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteModelImplCopyWith<_$QuoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
