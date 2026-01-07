// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_interaction_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiInteractionLogModel _$AiInteractionLogModelFromJson(
    Map<String, dynamic> json) {
  return _AiInteractionLogModel.fromJson(json);
}

/// @nodoc
mixin _$AiInteractionLogModel {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get technicianId => throw _privateConstructorUsedError;
  String get visitId => throw _privateConstructorUsedError;
  String get prompt => throw _privateConstructorUsedError;
  String get response => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  int? get tokensIn => throw _privateConstructorUsedError;
  int? get tokensOut => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AiInteractionLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiInteractionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiInteractionLogModelCopyWith<AiInteractionLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiInteractionLogModelCopyWith<$Res> {
  factory $AiInteractionLogModelCopyWith(AiInteractionLogModel value,
          $Res Function(AiInteractionLogModel) then) =
      _$AiInteractionLogModelCopyWithImpl<$Res, AiInteractionLogModel>;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String technicianId,
      String visitId,
      String prompt,
      String response,
      String model,
      int? tokensIn,
      int? tokensOut,
      DateTime? createdAt});
}

/// @nodoc
class _$AiInteractionLogModelCopyWithImpl<$Res,
        $Val extends AiInteractionLogModel>
    implements $AiInteractionLogModelCopyWith<$Res> {
  _$AiInteractionLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiInteractionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? technicianId = null,
    Object? visitId = null,
    Object? prompt = null,
    Object? response = null,
    Object? model = null,
    Object? tokensIn = freezed,
    Object? tokensOut = freezed,
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
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokensIn: freezed == tokensIn
          ? _value.tokensIn
          : tokensIn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokensOut: freezed == tokensOut
          ? _value.tokensOut
          : tokensOut // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiInteractionLogModelImplCopyWith<$Res>
    implements $AiInteractionLogModelCopyWith<$Res> {
  factory _$$AiInteractionLogModelImplCopyWith(
          _$AiInteractionLogModelImpl value,
          $Res Function(_$AiInteractionLogModelImpl) then) =
      __$$AiInteractionLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String technicianId,
      String visitId,
      String prompt,
      String response,
      String model,
      int? tokensIn,
      int? tokensOut,
      DateTime? createdAt});
}

/// @nodoc
class __$$AiInteractionLogModelImplCopyWithImpl<$Res>
    extends _$AiInteractionLogModelCopyWithImpl<$Res,
        _$AiInteractionLogModelImpl>
    implements _$$AiInteractionLogModelImplCopyWith<$Res> {
  __$$AiInteractionLogModelImplCopyWithImpl(_$AiInteractionLogModelImpl _value,
      $Res Function(_$AiInteractionLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiInteractionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? technicianId = null,
    Object? visitId = null,
    Object? prompt = null,
    Object? response = null,
    Object? model = null,
    Object? tokensIn = freezed,
    Object? tokensOut = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AiInteractionLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      tokensIn: freezed == tokensIn
          ? _value.tokensIn
          : tokensIn // ignore: cast_nullable_to_non_nullable
              as int?,
      tokensOut: freezed == tokensOut
          ? _value.tokensOut
          : tokensOut // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiInteractionLogModelImpl extends _AiInteractionLogModel {
  const _$AiInteractionLogModelImpl(
      {required this.id,
      required this.orgId,
      required this.technicianId,
      required this.visitId,
      required this.prompt,
      required this.response,
      required this.model,
      this.tokensIn,
      this.tokensOut,
      this.createdAt})
      : super._();

  factory _$AiInteractionLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiInteractionLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String technicianId;
  @override
  final String visitId;
  @override
  final String prompt;
  @override
  final String response;
  @override
  final String model;
  @override
  final int? tokensIn;
  @override
  final int? tokensOut;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AiInteractionLogModel(id: $id, orgId: $orgId, technicianId: $technicianId, visitId: $visitId, prompt: $prompt, response: $response, model: $model, tokensIn: $tokensIn, tokensOut: $tokensOut, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiInteractionLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.technicianId, technicianId) ||
                other.technicianId == technicianId) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.tokensIn, tokensIn) ||
                other.tokensIn == tokensIn) &&
            (identical(other.tokensOut, tokensOut) ||
                other.tokensOut == tokensOut) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, technicianId, visitId,
      prompt, response, model, tokensIn, tokensOut, createdAt);

  /// Create a copy of AiInteractionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiInteractionLogModelImplCopyWith<_$AiInteractionLogModelImpl>
      get copyWith => __$$AiInteractionLogModelImplCopyWithImpl<
          _$AiInteractionLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiInteractionLogModelImplToJson(
      this,
    );
  }
}

abstract class _AiInteractionLogModel extends AiInteractionLogModel {
  const factory _AiInteractionLogModel(
      {required final String id,
      required final String orgId,
      required final String technicianId,
      required final String visitId,
      required final String prompt,
      required final String response,
      required final String model,
      final int? tokensIn,
      final int? tokensOut,
      final DateTime? createdAt}) = _$AiInteractionLogModelImpl;
  const _AiInteractionLogModel._() : super._();

  factory _AiInteractionLogModel.fromJson(Map<String, dynamic> json) =
      _$AiInteractionLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orgId;
  @override
  String get technicianId;
  @override
  String get visitId;
  @override
  String get prompt;
  @override
  String get response;
  @override
  String get model;
  @override
  int? get tokensIn;
  @override
  int? get tokensOut;
  @override
  DateTime? get createdAt;

  /// Create a copy of AiInteractionLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiInteractionLogModelImplCopyWith<_$AiInteractionLogModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
