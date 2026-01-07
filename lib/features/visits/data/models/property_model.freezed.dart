// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) {
  return _PropertyModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_id')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line1')
  String get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line2')
  String? get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String get postalCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_instructions')
  String? get accessInstructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PropertyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyModelCopyWith<PropertyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyModelCopyWith<$Res> {
  factory $PropertyModelCopyWith(
          PropertyModel value, $Res Function(PropertyModel) then) =
      _$PropertyModelCopyWithImpl<$Res, PropertyModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'address_line1') String addressLine1,
      @JsonKey(name: 'address_line2') String? addressLine2,
      String city,
      String state,
      @JsonKey(name: 'postal_code') String postalCode,
      String? country,
      double? latitude,
      double? longitude,
      String? notes,
      @JsonKey(name: 'access_instructions') String? accessInstructions,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PropertyModelCopyWithImpl<$Res, $Val extends PropertyModel>
    implements $PropertyModelCopyWith<$Res> {
  _$PropertyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? customerId = null,
    Object? addressLine1 = null,
    Object? addressLine2 = freezed,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? accessInstructions = freezed,
    Object? isPrimary = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine1: null == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine2: freezed == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      accessInstructions: freezed == accessInstructions
          ? _value.accessInstructions
          : accessInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PropertyModelImplCopyWith<$Res>
    implements $PropertyModelCopyWith<$Res> {
  factory _$$PropertyModelImplCopyWith(
          _$PropertyModelImpl value, $Res Function(_$PropertyModelImpl) then) =
      __$$PropertyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'customer_id') String customerId,
      @JsonKey(name: 'address_line1') String addressLine1,
      @JsonKey(name: 'address_line2') String? addressLine2,
      String city,
      String state,
      @JsonKey(name: 'postal_code') String postalCode,
      String? country,
      double? latitude,
      double? longitude,
      String? notes,
      @JsonKey(name: 'access_instructions') String? accessInstructions,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PropertyModelImplCopyWithImpl<$Res>
    extends _$PropertyModelCopyWithImpl<$Res, _$PropertyModelImpl>
    implements _$$PropertyModelImplCopyWith<$Res> {
  __$$PropertyModelImplCopyWithImpl(
      _$PropertyModelImpl _value, $Res Function(_$PropertyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? customerId = null,
    Object? addressLine1 = null,
    Object? addressLine2 = freezed,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? notes = freezed,
    Object? accessInstructions = freezed,
    Object? isPrimary = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PropertyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine1: null == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine2: freezed == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      accessInstructions: freezed == accessInstructions
          ? _value.accessInstructions
          : accessInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyModelImpl implements _PropertyModel {
  const _$PropertyModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'customer_id') required this.customerId,
      @JsonKey(name: 'address_line1') required this.addressLine1,
      @JsonKey(name: 'address_line2') this.addressLine2,
      required this.city,
      required this.state,
      @JsonKey(name: 'postal_code') required this.postalCode,
      this.country,
      this.latitude,
      this.longitude,
      this.notes,
      @JsonKey(name: 'access_instructions') this.accessInstructions,
      @JsonKey(name: 'is_primary') this.isPrimary = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$PropertyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'customer_id')
  final String customerId;
  @override
  @JsonKey(name: 'address_line1')
  final String addressLine1;
  @override
  @JsonKey(name: 'address_line2')
  final String? addressLine2;
  @override
  final String city;
  @override
  final String state;
  @override
  @JsonKey(name: 'postal_code')
  final String postalCode;
  @override
  final String? country;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'access_instructions')
  final String? accessInstructions;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PropertyModel(id: $id, orgId: $orgId, customerId: $customerId, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postalCode: $postalCode, country: $country, latitude: $latitude, longitude: $longitude, notes: $notes, accessInstructions: $accessInstructions, isPrimary: $isPrimary, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.accessInstructions, accessInstructions) ||
                other.accessInstructions == accessInstructions) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
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
      customerId,
      addressLine1,
      addressLine2,
      city,
      state,
      postalCode,
      country,
      latitude,
      longitude,
      notes,
      accessInstructions,
      isPrimary,
      createdAt,
      updatedAt);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      __$$PropertyModelImplCopyWithImpl<_$PropertyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyModelImplToJson(
      this,
    );
  }
}

abstract class _PropertyModel implements PropertyModel {
  const factory _PropertyModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'customer_id') required final String customerId,
      @JsonKey(name: 'address_line1') required final String addressLine1,
      @JsonKey(name: 'address_line2') final String? addressLine2,
      required final String city,
      required final String state,
      @JsonKey(name: 'postal_code') required final String postalCode,
      final String? country,
      final double? latitude,
      final double? longitude,
      final String? notes,
      @JsonKey(name: 'access_instructions') final String? accessInstructions,
      @JsonKey(name: 'is_primary') final bool isPrimary,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$PropertyModelImpl;

  factory _PropertyModel.fromJson(Map<String, dynamic> json) =
      _$PropertyModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'customer_id')
  String get customerId;
  @override
  @JsonKey(name: 'address_line1')
  String get addressLine1;
  @override
  @JsonKey(name: 'address_line2')
  String? get addressLine2;
  @override
  String get city;
  @override
  String get state;
  @override
  @JsonKey(name: 'postal_code')
  String get postalCode;
  @override
  String? get country;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'access_instructions')
  String? get accessInstructions;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
