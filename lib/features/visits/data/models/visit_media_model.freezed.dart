// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VisitMediaModel _$VisitMediaModelFromJson(Map<String, dynamic> json) {
  return _VisitMediaModel.fromJson(json);
}

/// @nodoc
mixin _$VisitMediaModel {
  String get id => throw _privateConstructorUsedError;
  String get orgId => throw _privateConstructorUsedError;
  String get visitId => throw _privateConstructorUsedError;
  String get uploadedBy => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  MediaFileType get fileType => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VisitMediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisitMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitMediaModelCopyWith<VisitMediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitMediaModelCopyWith<$Res> {
  factory $VisitMediaModelCopyWith(
          VisitMediaModel value, $Res Function(VisitMediaModel) then) =
      _$VisitMediaModelCopyWithImpl<$Res, VisitMediaModel>;
  @useResult
  $Res call(
      {String id,
      String orgId,
      String visitId,
      String uploadedBy,
      String filePath,
      MediaFileType fileType,
      DateTime? createdAt});
}

/// @nodoc
class _$VisitMediaModelCopyWithImpl<$Res, $Val extends VisitMediaModel>
    implements $VisitMediaModelCopyWith<$Res> {
  _$VisitMediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisitMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? uploadedBy = null,
    Object? filePath = null,
    Object? fileType = null,
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
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as MediaFileType,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitMediaModelImplCopyWith<$Res>
    implements $VisitMediaModelCopyWith<$Res> {
  factory _$$VisitMediaModelImplCopyWith(_$VisitMediaModelImpl value,
          $Res Function(_$VisitMediaModelImpl) then) =
      __$$VisitMediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orgId,
      String visitId,
      String uploadedBy,
      String filePath,
      MediaFileType fileType,
      DateTime? createdAt});
}

/// @nodoc
class __$$VisitMediaModelImplCopyWithImpl<$Res>
    extends _$VisitMediaModelCopyWithImpl<$Res, _$VisitMediaModelImpl>
    implements _$$VisitMediaModelImplCopyWith<$Res> {
  __$$VisitMediaModelImplCopyWithImpl(
      _$VisitMediaModelImpl _value, $Res Function(_$VisitMediaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VisitMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? uploadedBy = null,
    Object? filePath = null,
    Object? fileType = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$VisitMediaModelImpl(
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
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as MediaFileType,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitMediaModelImpl extends _VisitMediaModel {
  const _$VisitMediaModelImpl(
      {required this.id,
      required this.orgId,
      required this.visitId,
      required this.uploadedBy,
      required this.filePath,
      this.fileType = MediaFileType.image,
      this.createdAt})
      : super._();

  factory _$VisitMediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitMediaModelImplFromJson(json);

  @override
  final String id;
  @override
  final String orgId;
  @override
  final String visitId;
  @override
  final String uploadedBy;
  @override
  final String filePath;
  @override
  @JsonKey()
  final MediaFileType fileType;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'VisitMediaModel(id: $id, orgId: $orgId, visitId: $visitId, uploadedBy: $uploadedBy, filePath: $filePath, fileType: $fileType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitMediaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, visitId, uploadedBy,
      filePath, fileType, createdAt);

  /// Create a copy of VisitMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitMediaModelImplCopyWith<_$VisitMediaModelImpl> get copyWith =>
      __$$VisitMediaModelImplCopyWithImpl<_$VisitMediaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitMediaModelImplToJson(
      this,
    );
  }
}

abstract class _VisitMediaModel extends VisitMediaModel {
  const factory _VisitMediaModel(
      {required final String id,
      required final String orgId,
      required final String visitId,
      required final String uploadedBy,
      required final String filePath,
      final MediaFileType fileType,
      final DateTime? createdAt}) = _$VisitMediaModelImpl;
  const _VisitMediaModel._() : super._();

  factory _VisitMediaModel.fromJson(Map<String, dynamic> json) =
      _$VisitMediaModelImpl.fromJson;

  @override
  String get id;
  @override
  String get orgId;
  @override
  String get visitId;
  @override
  String get uploadedBy;
  @override
  String get filePath;
  @override
  MediaFileType get fileType;
  @override
  DateTime? get createdAt;

  /// Create a copy of VisitMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitMediaModelImplCopyWith<_$VisitMediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
