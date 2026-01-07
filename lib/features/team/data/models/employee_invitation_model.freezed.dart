// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_invitation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmployeeInvitationModel _$EmployeeInvitationModelFromJson(
    Map<String, dynamic> json) {
  return _EmployeeInvitationModel.fromJson(json);
}

/// @nodoc
mixin _$EmployeeInvitationModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  EmployeeRole get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_by')
  String get invitedBy => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  InvitationStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EmployeeInvitationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeInvitationModelCopyWith<EmployeeInvitationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeInvitationModelCopyWith<$Res> {
  factory $EmployeeInvitationModelCopyWith(EmployeeInvitationModel value,
          $Res Function(EmployeeInvitationModel) then) =
      _$EmployeeInvitationModelCopyWithImpl<$Res, EmployeeInvitationModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      EmployeeRole role,
      @JsonKey(name: 'invited_by') String invitedBy,
      String token,
      InvitationStatus status,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$EmployeeInvitationModelCopyWithImpl<$Res,
        $Val extends EmployeeInvitationModel>
    implements $EmployeeInvitationModelCopyWith<$Res> {
  _$EmployeeInvitationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? role = null,
    Object? invitedBy = null,
    Object? token = null,
    Object? status = null,
    Object? expiresAt = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as EmployeeRole,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeInvitationModelImplCopyWith<$Res>
    implements $EmployeeInvitationModelCopyWith<$Res> {
  factory _$$EmployeeInvitationModelImplCopyWith(
          _$EmployeeInvitationModelImpl value,
          $Res Function(_$EmployeeInvitationModelImpl) then) =
      __$$EmployeeInvitationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      String email,
      String? phone,
      @JsonKey(name: 'full_name') String? fullName,
      EmployeeRole role,
      @JsonKey(name: 'invited_by') String invitedBy,
      String token,
      InvitationStatus status,
      @JsonKey(name: 'expires_at') DateTime? expiresAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$EmployeeInvitationModelImplCopyWithImpl<$Res>
    extends _$EmployeeInvitationModelCopyWithImpl<$Res,
        _$EmployeeInvitationModelImpl>
    implements _$$EmployeeInvitationModelImplCopyWith<$Res> {
  __$$EmployeeInvitationModelImplCopyWithImpl(
      _$EmployeeInvitationModelImpl _value,
      $Res Function(_$EmployeeInvitationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? email = null,
    Object? phone = freezed,
    Object? fullName = freezed,
    Object? role = null,
    Object? invitedBy = null,
    Object? token = null,
    Object? status = null,
    Object? expiresAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$EmployeeInvitationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as EmployeeRole,
      invitedBy: null == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InvitationStatus,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
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
class _$EmployeeInvitationModelImpl extends _EmployeeInvitationModel {
  const _$EmployeeInvitationModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      required this.email,
      this.phone,
      @JsonKey(name: 'full_name') this.fullName,
      required this.role,
      @JsonKey(name: 'invited_by') required this.invitedBy,
      required this.token,
      this.status = InvitationStatus.pending,
      @JsonKey(name: 'expires_at') this.expiresAt,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$EmployeeInvitationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeInvitationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  final String email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  final EmployeeRole role;
  @override
  @JsonKey(name: 'invited_by')
  final String invitedBy;
  @override
  final String token;
  @override
  @JsonKey()
  final InvitationStatus status;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'EmployeeInvitationModel(id: $id, orgId: $orgId, email: $email, phone: $phone, fullName: $fullName, role: $role, invitedBy: $invitedBy, token: $token, status: $status, expiresAt: $expiresAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeInvitationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, email, phone,
      fullName, role, invitedBy, token, status, expiresAt, createdAt);

  /// Create a copy of EmployeeInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeInvitationModelImplCopyWith<_$EmployeeInvitationModelImpl>
      get copyWith => __$$EmployeeInvitationModelImplCopyWithImpl<
          _$EmployeeInvitationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeInvitationModelImplToJson(
      this,
    );
  }
}

abstract class _EmployeeInvitationModel extends EmployeeInvitationModel {
  const factory _EmployeeInvitationModel(
          {required final String id,
          @JsonKey(name: 'org_id') required final String orgId,
          required final String email,
          final String? phone,
          @JsonKey(name: 'full_name') final String? fullName,
          required final EmployeeRole role,
          @JsonKey(name: 'invited_by') required final String invitedBy,
          required final String token,
          final InvitationStatus status,
          @JsonKey(name: 'expires_at') final DateTime? expiresAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$EmployeeInvitationModelImpl;
  const _EmployeeInvitationModel._() : super._();

  factory _EmployeeInvitationModel.fromJson(Map<String, dynamic> json) =
      _$EmployeeInvitationModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  String get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  EmployeeRole get role;
  @override
  @JsonKey(name: 'invited_by')
  String get invitedBy;
  @override
  String get token;
  @override
  InvitationStatus get status;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of EmployeeInvitationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeInvitationModelImplCopyWith<_$EmployeeInvitationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
