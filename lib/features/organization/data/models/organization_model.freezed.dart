// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) {
  return _OrganizationModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_prefix')
  String? get orgPrefix => throw _privateConstructorUsedError;
  String? get plan => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this OrganizationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrganizationModelCopyWith<OrganizationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationModelCopyWith<$Res> {
  factory $OrganizationModelCopyWith(
          OrganizationModel value, $Res Function(OrganizationModel) then) =
      _$OrganizationModelCopyWithImpl<$Res, OrganizationModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String timezone,
      String currency,
      @JsonKey(name: 'org_prefix') String? orgPrefix,
      String? plan,
      Map<String, dynamic> settings,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$OrganizationModelCopyWithImpl<$Res, $Val extends OrganizationModel>
    implements $OrganizationModelCopyWith<$Res> {
  _$OrganizationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timezone = null,
    Object? currency = null,
    Object? orgPrefix = freezed,
    Object? plan = freezed,
    Object? settings = null,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      orgPrefix: freezed == orgPrefix
          ? _value.orgPrefix
          : orgPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
abstract class _$$OrganizationModelImplCopyWith<$Res>
    implements $OrganizationModelCopyWith<$Res> {
  factory _$$OrganizationModelImplCopyWith(_$OrganizationModelImpl value,
          $Res Function(_$OrganizationModelImpl) then) =
      __$$OrganizationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String timezone,
      String currency,
      @JsonKey(name: 'org_prefix') String? orgPrefix,
      String? plan,
      Map<String, dynamic> settings,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$OrganizationModelImplCopyWithImpl<$Res>
    extends _$OrganizationModelCopyWithImpl<$Res, _$OrganizationModelImpl>
    implements _$$OrganizationModelImplCopyWith<$Res> {
  __$$OrganizationModelImplCopyWithImpl(_$OrganizationModelImpl _value,
      $Res Function(_$OrganizationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? timezone = null,
    Object? currency = null,
    Object? orgPrefix = freezed,
    Object? plan = freezed,
    Object? settings = null,
    Object? updatedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$OrganizationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      orgPrefix: freezed == orgPrefix
          ? _value.orgPrefix
          : orgPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
class _$OrganizationModelImpl extends _OrganizationModel {
  const _$OrganizationModelImpl(
      {required this.id,
      required this.name,
      this.timezone = 'America/New_York',
      this.currency = 'USD',
      @JsonKey(name: 'org_prefix') this.orgPrefix,
      this.plan,
      final Map<String, dynamic> settings = const {},
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_at') this.createdAt})
      : _settings = settings,
        super._();

  factory _$OrganizationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'org_prefix')
  final String? orgPrefix;
  @override
  final String? plan;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'OrganizationModel(id: $id, name: $name, timezone: $timezone, currency: $currency, orgPrefix: $orgPrefix, plan: $plan, settings: $settings, updatedAt: $updatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.orgPrefix, orgPrefix) ||
                other.orgPrefix == orgPrefix) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
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
      name,
      timezone,
      currency,
      orgPrefix,
      plan,
      const DeepCollectionEquality().hash(_settings),
      updatedAt,
      createdAt);

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      __$$OrganizationModelImplCopyWithImpl<_$OrganizationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationModelImplToJson(
      this,
    );
  }
}

abstract class _OrganizationModel extends OrganizationModel {
  const factory _OrganizationModel(
          {required final String id,
          required final String name,
          final String timezone,
          final String currency,
          @JsonKey(name: 'org_prefix') final String? orgPrefix,
          final String? plan,
          final Map<String, dynamic> settings,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$OrganizationModelImpl;
  const _OrganizationModel._() : super._();

  factory _OrganizationModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get timezone;
  @override
  String get currency;
  @override
  @JsonKey(name: 'org_prefix')
  String? get orgPrefix;
  @override
  String? get plan;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of OrganizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrganizationModelImplCopyWith<_$OrganizationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
