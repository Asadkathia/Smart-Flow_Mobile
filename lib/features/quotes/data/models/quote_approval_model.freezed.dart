// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_approval_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuoteApprovalModel _$QuoteApprovalModelFromJson(Map<String, dynamic> json) {
  return _QuoteApprovalModel.fromJson(json);
}

/// @nodoc
mixin _$QuoteApprovalModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_id')
  String get quoteId => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_status')
  ApprovalStatus get approvalStatus =>
      throw _privateConstructorUsedError; // approved | rejected
  ApprovalMethod get method => throw _privateConstructorUsedError; // call | sms
  @JsonKey(name: 'recorded_by')
  String get recordedBy =>
      throw _privateConstructorUsedError; // User who recorded the approval
  @JsonKey(name: 'recorded_at')
  DateTime get recordedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError; // Optional notes
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this QuoteApprovalModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuoteApprovalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteApprovalModelCopyWith<QuoteApprovalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteApprovalModelCopyWith<$Res> {
  factory $QuoteApprovalModelCopyWith(
          QuoteApprovalModel value, $Res Function(QuoteApprovalModel) then) =
      _$QuoteApprovalModelCopyWithImpl<$Res, QuoteApprovalModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'quote_id') String quoteId,
      @JsonKey(name: 'approval_status') ApprovalStatus approvalStatus,
      ApprovalMethod method,
      @JsonKey(name: 'recorded_by') String recordedBy,
      @JsonKey(name: 'recorded_at') DateTime recordedAt,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$QuoteApprovalModelCopyWithImpl<$Res, $Val extends QuoteApprovalModel>
    implements $QuoteApprovalModelCopyWith<$Res> {
  _$QuoteApprovalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuoteApprovalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? quoteId = null,
    Object? approvalStatus = null,
    Object? method = null,
    Object? recordedBy = null,
    Object? recordedAt = null,
    Object? notes = freezed,
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
      quoteId: null == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as ApprovalStatus,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as ApprovalMethod,
      recordedBy: null == recordedBy
          ? _value.recordedBy
          : recordedBy // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuoteApprovalModelImplCopyWith<$Res>
    implements $QuoteApprovalModelCopyWith<$Res> {
  factory _$$QuoteApprovalModelImplCopyWith(_$QuoteApprovalModelImpl value,
          $Res Function(_$QuoteApprovalModelImpl) then) =
      __$$QuoteApprovalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'quote_id') String quoteId,
      @JsonKey(name: 'approval_status') ApprovalStatus approvalStatus,
      ApprovalMethod method,
      @JsonKey(name: 'recorded_by') String recordedBy,
      @JsonKey(name: 'recorded_at') DateTime recordedAt,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$QuoteApprovalModelImplCopyWithImpl<$Res>
    extends _$QuoteApprovalModelCopyWithImpl<$Res, _$QuoteApprovalModelImpl>
    implements _$$QuoteApprovalModelImplCopyWith<$Res> {
  __$$QuoteApprovalModelImplCopyWithImpl(_$QuoteApprovalModelImpl _value,
      $Res Function(_$QuoteApprovalModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuoteApprovalModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? quoteId = null,
    Object? approvalStatus = null,
    Object? method = null,
    Object? recordedBy = null,
    Object? recordedAt = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$QuoteApprovalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteId: null == quoteId
          ? _value.quoteId
          : quoteId // ignore: cast_nullable_to_non_nullable
              as String,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as ApprovalStatus,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as ApprovalMethod,
      recordedBy: null == recordedBy
          ? _value.recordedBy
          : recordedBy // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteApprovalModelImpl implements _QuoteApprovalModel {
  const _$QuoteApprovalModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'quote_id') required this.quoteId,
      @JsonKey(name: 'approval_status') required this.approvalStatus,
      required this.method,
      @JsonKey(name: 'recorded_by') required this.recordedBy,
      @JsonKey(name: 'recorded_at') required this.recordedAt,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$QuoteApprovalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteApprovalModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'quote_id')
  final String quoteId;
  @override
  @JsonKey(name: 'approval_status')
  final ApprovalStatus approvalStatus;
// approved | rejected
  @override
  final ApprovalMethod method;
// call | sms
  @override
  @JsonKey(name: 'recorded_by')
  final String recordedBy;
// User who recorded the approval
  @override
  @JsonKey(name: 'recorded_at')
  final DateTime recordedAt;
  @override
  final String? notes;
// Optional notes
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'QuoteApprovalModel(id: $id, orgId: $orgId, quoteId: $quoteId, approvalStatus: $approvalStatus, method: $method, recordedBy: $recordedBy, recordedAt: $recordedAt, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteApprovalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.quoteId, quoteId) || other.quoteId == quoteId) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.recordedBy, recordedBy) ||
                other.recordedBy == recordedBy) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, quoteId,
      approvalStatus, method, recordedBy, recordedAt, notes, createdAt);

  /// Create a copy of QuoteApprovalModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteApprovalModelImplCopyWith<_$QuoteApprovalModelImpl> get copyWith =>
      __$$QuoteApprovalModelImplCopyWithImpl<_$QuoteApprovalModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteApprovalModelImplToJson(
      this,
    );
  }
}

abstract class _QuoteApprovalModel implements QuoteApprovalModel {
  const factory _QuoteApprovalModel(
          {required final String id,
          @JsonKey(name: 'org_id') required final String orgId,
          @JsonKey(name: 'quote_id') required final String quoteId,
          @JsonKey(name: 'approval_status')
          required final ApprovalStatus approvalStatus,
          required final ApprovalMethod method,
          @JsonKey(name: 'recorded_by') required final String recordedBy,
          @JsonKey(name: 'recorded_at') required final DateTime recordedAt,
          final String? notes,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$QuoteApprovalModelImpl;

  factory _QuoteApprovalModel.fromJson(Map<String, dynamic> json) =
      _$QuoteApprovalModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'quote_id')
  String get quoteId;
  @override
  @JsonKey(name: 'approval_status')
  ApprovalStatus get approvalStatus; // approved | rejected
  @override
  ApprovalMethod get method; // call | sms
  @override
  @JsonKey(name: 'recorded_by')
  String get recordedBy; // User who recorded the approval
  @override
  @JsonKey(name: 'recorded_at')
  DateTime get recordedAt;
  @override
  String? get notes; // Optional notes
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of QuoteApprovalModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteApprovalModelImplCopyWith<_$QuoteApprovalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
