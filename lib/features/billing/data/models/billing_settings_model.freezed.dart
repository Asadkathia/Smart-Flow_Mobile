// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BillingSettingsModel _$BillingSettingsModelFromJson(Map<String, dynamic> json) {
  return _BillingSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$BillingSettingsModel {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  double get serviceCallFee => throw _privateConstructorUsedError;
  double get taxRate => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BillingSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingSettingsModelCopyWith<BillingSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingSettingsModelCopyWith<$Res> {
  factory $BillingSettingsModelCopyWith(BillingSettingsModel value,
          $Res Function(BillingSettingsModel) then) =
      _$BillingSettingsModelCopyWithImpl<$Res, BillingSettingsModel>;
  @useResult
  $Res call(
      {String id,
      String orgId,
      double serviceCallFee,
      double taxRate,
      String? currency,
      DateTime? updatedAt,
      DateTime? createdAt});
}

/// @nodoc
class _$BillingSettingsModelCopyWithImpl<$Res,
        $Val extends BillingSettingsModel>
    implements $BillingSettingsModelCopyWith<$Res> {
  _$BillingSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? serviceCallFee = null,
    Object? taxRate = null,
    Object? currency = freezed,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
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
      serviceCallFee: null == serviceCallFee
          ? _value.serviceCallFee
          : serviceCallFee // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillingSettingsModelImplCopyWith<$Res>
    implements $BillingSettingsModelCopyWith<$Res> {
  factory _$$BillingSettingsModelImplCopyWith(_$BillingSettingsModelImpl value,
          $Res Function(_$BillingSettingsModelImpl) then) =
      __$$BillingSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      double serviceCallFee,
      double taxRate,
      String? currency,
      DateTime? updatedAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$BillingSettingsModelImplCopyWithImpl<$Res>
    extends _$BillingSettingsModelCopyWithImpl<$Res, _$BillingSettingsModelImpl>
    implements _$$BillingSettingsModelImplCopyWith<$Res> {
  __$$BillingSettingsModelImplCopyWithImpl(_$BillingSettingsModelImpl _value,
      $Res Function(_$BillingSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BillingSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? serviceCallFee = null,
    Object? taxRate = null,
    Object? currency = freezed,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$BillingSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      serviceCallFee: null == serviceCallFee
          ? _value.serviceCallFee
          : serviceCallFee // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingSettingsModelImpl extends _BillingSettingsModel {
  const _$BillingSettingsModelImpl(
      {required this.id,
      required this.orgId,
      this.serviceCallFee = 0.0,
      this.taxRate = 0.0,
      this.currency,
      this.updatedAt,
      this.createdAt})
      : super._();

  factory _$BillingSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingSettingsModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  @JsonKey()
  final double serviceCallFee;
  @override
  @JsonKey()
  final double taxRate;
  @override
  final String? currency;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BillingSettingsModel(id: $id, orgId: $orgId, serviceCallFee: $serviceCallFee, taxRate: $taxRate, currency: $currency, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.serviceCallFee, serviceCallFee) ||
                other.serviceCallFee == serviceCallFee) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, serviceCallFee,
      taxRate, currency, updatedAt, createdAt);

  /// Create a copy of BillingSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingSettingsModelImplCopyWith<_$BillingSettingsModelImpl>
      get copyWith =>
          __$$BillingSettingsModelImplCopyWithImpl<_$BillingSettingsModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _BillingSettingsModel extends BillingSettingsModel {
  const factory _BillingSettingsModel(
      {required final String id,
      required final String orgId,
      final double serviceCallFee,
      final double taxRate,
      final String? currency,
      final DateTime? updatedAt,
      final DateTime? createdAt}) = _$BillingSettingsModelImpl;
  const _BillingSettingsModel._() : super._();

  factory _BillingSettingsModel.fromJson(Map<String, dynamic> json) =
      _$BillingSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orgId;
  @override
  double get serviceCallFee;
  @override
  double get taxRate;
  @override
  String? get currency;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of BillingSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingSettingsModelImplCopyWith<_$BillingSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
