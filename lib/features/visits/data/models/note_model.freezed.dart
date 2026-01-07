// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) {
  return _NoteModel.fromJson(json);
}

/// @nodoc
mixin _$NoteModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId => throw _privateConstructorUsedError;
  @JsonKey(name: 'visit_id')
  String get visitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_id')
  String get authorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_name')
  String? get authorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'body')
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_internal')
  bool get isInternal => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteModelCopyWith<NoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) then) =
      _$NoteModelCopyWithImpl<$Res, NoteModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'author_id') String authorId,
      @JsonKey(name: 'author_name') String? authorName,
      @JsonKey(name: 'body') String content,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'image_urls') List<String> imageUrls,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res, $Val extends NoteModel>
    implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? content = null,
    Object? isInternal = null,
    Object? imageUrls = null,
    Object? version = null,
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
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteModelImplCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$$NoteModelImplCopyWith(
          _$NoteModelImpl value, $Res Function(_$NoteModelImpl) then) =
      __$$NoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'visit_id') String visitId,
      @JsonKey(name: 'author_id') String authorId,
      @JsonKey(name: 'author_name') String? authorName,
      @JsonKey(name: 'body') String content,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'image_urls') List<String> imageUrls,
      int version,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$NoteModelImplCopyWithImpl<$Res>
    extends _$NoteModelCopyWithImpl<$Res, _$NoteModelImpl>
    implements _$$NoteModelImplCopyWith<$Res> {
  __$$NoteModelImplCopyWithImpl(
      _$NoteModelImpl _value, $Res Function(_$NoteModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? visitId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? content = null,
    Object? isInternal = null,
    Object? imageUrls = null,
    Object? version = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NoteModelImpl(
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
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteModelImpl implements _NoteModel {
  const _$NoteModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'visit_id') required this.visitId,
      @JsonKey(name: 'author_id') required this.authorId,
      @JsonKey(name: 'author_name') this.authorName,
      @JsonKey(name: 'body') required this.content,
      @JsonKey(name: 'is_internal') this.isInternal = false,
      @JsonKey(name: 'image_urls') final List<String> imageUrls = const [],
      this.version = 1,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _imageUrls = imageUrls;

  factory _$NoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
  @override
  @JsonKey(name: 'visit_id')
  final String visitId;
  @override
  @JsonKey(name: 'author_id')
  final String authorId;
  @override
  @JsonKey(name: 'author_name')
  final String? authorName;
  @override
  @JsonKey(name: 'body')
  final String content;
  @override
  @JsonKey(name: 'is_internal')
  final bool isInternal;
  final List<String> _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NoteModel(id: $id, orgId: $orgId, visitId: $visitId, authorId: $authorId, authorName: $authorName, content: $content, isInternal: $isInternal, imageUrls: $imageUrls, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.version, version) || other.version == version) &&
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
      visitId,
      authorId,
      authorName,
      content,
      isInternal,
      const DeepCollectionEquality().hash(_imageUrls),
      version,
      createdAt,
      updatedAt);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      __$$NoteModelImplCopyWithImpl<_$NoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteModelImplToJson(
      this,
    );
  }
}

abstract class _NoteModel implements NoteModel {
  const factory _NoteModel(
          {required final String id,
          @JsonKey(name: 'org_id') required final String orgId,
          @JsonKey(name: 'visit_id') required final String visitId,
          @JsonKey(name: 'author_id') required final String authorId,
          @JsonKey(name: 'author_name') final String? authorName,
          @JsonKey(name: 'body') required final String content,
          @JsonKey(name: 'is_internal') final bool isInternal,
          @JsonKey(name: 'image_urls') final List<String> imageUrls,
          final int version,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$NoteModelImpl;

  factory _NoteModel.fromJson(Map<String, dynamic> json) =
      _$NoteModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId;
  @override
  @JsonKey(name: 'visit_id')
  String get visitId;
  @override
  @JsonKey(name: 'author_id')
  String get authorId;
  @override
  @JsonKey(name: 'author_name')
  String? get authorName;
  @override
  @JsonKey(name: 'body')
  String get content;
  @override
  @JsonKey(name: 'is_internal')
  bool get isInternal;
  @override
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls;
  @override
  int get version;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
