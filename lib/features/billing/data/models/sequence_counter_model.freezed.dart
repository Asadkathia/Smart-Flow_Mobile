// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sequence_counter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SequenceCounterModel _$SequenceCounterModelFromJson(Map<String, dynamic> json) {
  return _SequenceCounterModel.fromJson(json);
}

/// @nodoc
mixin _$SequenceCounterModel {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  SequenceEntityType get entityType => throw _privateConstructorUsedError;
  int get currentSequence => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SequenceCounterModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SequenceCounterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SequenceCounterModelCopyWith<SequenceCounterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SequenceCounterModelCopyWith<$Res> {
  factory $SequenceCounterModelCopyWith(SequenceCounterModel value,
          $Res Function(SequenceCounterModel) then) =
      _$SequenceCounterModelCopyWithImpl<$Res, SequenceCounterModel>;
  @useResult
  $Res call(
      {String id,
      String orgId,
      SequenceEntityType entityType,
      int currentSequence,
      DateTime? updatedAt});
}

/// @nodoc
class _$SequenceCounterModelCopyWithImpl<$Res,
        $Val extends SequenceCounterModel>
    implements $SequenceCounterModelCopyWith<$Res> {
  _$SequenceCounterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SequenceCounterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? entityType = null,
    Object? currentSequence = null,
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
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as SequenceEntityType,
      currentSequence: null == currentSequence
          ? _value.currentSequence
          : currentSequence // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SequenceCounterModelImplCopyWith<$Res>
    implements $SequenceCounterModelCopyWith<$Res> {
  factory _$$SequenceCounterModelImplCopyWith(_$SequenceCounterModelImpl value,
          $Res Function(_$SequenceCounterModelImpl) then) =
      __$$SequenceCounterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      SequenceEntityType entityType,
      int currentSequence,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SequenceCounterModelImplCopyWithImpl<$Res>
    extends _$SequenceCounterModelCopyWithImpl<$Res, _$SequenceCounterModelImpl>
    implements _$$SequenceCounterModelImplCopyWith<$Res> {
  __$$SequenceCounterModelImplCopyWithImpl(_$SequenceCounterModelImpl _value,
      $Res Function(_$SequenceCounterModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SequenceCounterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? entityType = null,
    Object? currentSequence = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SequenceCounterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as SequenceEntityType,
      currentSequence: null == currentSequence
          ? _value.currentSequence
          : currentSequence // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SequenceCounterModelImpl extends _SequenceCounterModel {
  const _$SequenceCounterModelImpl(
      {required this.id,
      required this.orgId,
      required this.entityType,
      this.currentSequence = 0,
      this.updatedAt})
      : super._();

  factory _$SequenceCounterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SequenceCounterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final SequenceEntityType entityType;
  @override
  @JsonKey()
  final int currentSequence;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SequenceCounterModel(id: $id, orgId: $orgId, entityType: $entityType, currentSequence: $currentSequence, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SequenceCounterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.currentSequence, currentSequence) ||
                other.currentSequence == currentSequence) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orgId, entityType, currentSequence, updatedAt);

  /// Create a copy of SequenceCounterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SequenceCounterModelImplCopyWith<_$SequenceCounterModelImpl>
      get copyWith =>
          __$$SequenceCounterModelImplCopyWithImpl<_$SequenceCounterModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SequenceCounterModelImplToJson(
      this,
    );
  }
}

abstract class _SequenceCounterModel extends SequenceCounterModel {
  const factory _SequenceCounterModel(
      {required final String id,
      required final String orgId,
      required final SequenceEntityType entityType,
      final int currentSequence,
      final DateTime? updatedAt}) = _$SequenceCounterModelImpl;
  const _SequenceCounterModel._() : super._();

  factory _SequenceCounterModel.fromJson(Map<String, dynamic> json) =
      _$SequenceCounterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orgId;
  @override
  SequenceEntityType get entityType;
  @override
  int get currentSequence;
  @override
  DateTime? get updatedAt;

  /// Create a copy of SequenceCounterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SequenceCounterModelImplCopyWith<_$SequenceCounterModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
