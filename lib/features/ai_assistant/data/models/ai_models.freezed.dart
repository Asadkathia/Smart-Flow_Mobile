// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiChatMessage _$AiChatMessageFromJson(Map<String, dynamic> json) {
  return _AiChatMessage.fromJson(json);
}

/// @nodoc
mixin _$AiChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // 'user' or 'assistant'
  String get content => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AiChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiChatMessageCopyWith<AiChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiChatMessageCopyWith<$Res> {
  factory $AiChatMessageCopyWith(
          AiChatMessage value, $Res Function(AiChatMessage) then) =
      _$AiChatMessageCopyWithImpl<$Res, AiChatMessage>;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      String? imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class _$AiChatMessageCopyWithImpl<$Res, $Val extends AiChatMessage>
    implements $AiChatMessageCopyWith<$Res> {
  _$AiChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiChatMessageImplCopyWith<$Res>
    implements $AiChatMessageCopyWith<$Res> {
  factory _$$AiChatMessageImplCopyWith(
          _$AiChatMessageImpl value, $Res Function(_$AiChatMessageImpl) then) =
      __$$AiChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      String? imageUrl,
      DateTime? createdAt});
}

/// @nodoc
class __$$AiChatMessageImplCopyWithImpl<$Res>
    extends _$AiChatMessageCopyWithImpl<$Res, _$AiChatMessageImpl>
    implements _$$AiChatMessageImplCopyWith<$Res> {
  __$$AiChatMessageImplCopyWithImpl(
      _$AiChatMessageImpl _value, $Res Function(_$AiChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AiChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiChatMessageImpl implements _AiChatMessage {
  const _$AiChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      this.imageUrl,
      this.createdAt});

  factory _$AiChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String role;
// 'user' or 'assistant'
  @override
  final String content;
  @override
  final String? imageUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AiChatMessage(id: $id, role: $role, content: $content, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, role, content, imageUrl, createdAt);

  /// Create a copy of AiChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiChatMessageImplCopyWith<_$AiChatMessageImpl> get copyWith =>
      __$$AiChatMessageImplCopyWithImpl<_$AiChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiChatMessageImplToJson(
      this,
    );
  }
}

abstract class _AiChatMessage implements AiChatMessage {
  const factory _AiChatMessage(
      {required final String id,
      required final String role,
      required final String content,
      final String? imageUrl,
      final DateTime? createdAt}) = _$AiChatMessageImpl;

  factory _AiChatMessage.fromJson(Map<String, dynamic> json) =
      _$AiChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get role; // 'user' or 'assistant'
  @override
  String get content;
  @override
  String? get imageUrl;
  @override
  DateTime? get createdAt;

  /// Create a copy of AiChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiChatMessageImplCopyWith<_$AiChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiRequest _$AiRequestFromJson(Map<String, dynamic> json) {
  return _AiRequest.fromJson(json);
}

/// @nodoc
mixin _$AiRequest {
  String get visitId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get imageBase64 => throw _privateConstructorUsedError;
  List<AiChatMessage>? get conversationHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this AiRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiRequestCopyWith<AiRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiRequestCopyWith<$Res> {
  factory $AiRequestCopyWith(AiRequest value, $Res Function(AiRequest) then) =
      _$AiRequestCopyWithImpl<$Res, AiRequest>;
  @useResult
  $Res call(
      {String visitId,
      String message,
      String? imageBase64,
      List<AiChatMessage>? conversationHistory});
}

/// @nodoc
class _$AiRequestCopyWithImpl<$Res, $Val extends AiRequest>
    implements $AiRequestCopyWith<$Res> {
  _$AiRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitId = null,
    Object? message = null,
    Object? imageBase64 = freezed,
    Object? conversationHistory = freezed,
  }) {
    return _then(_value.copyWith(
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imageBase64: freezed == imageBase64
          ? _value.imageBase64
          : imageBase64 // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationHistory: freezed == conversationHistory
          ? _value.conversationHistory
          : conversationHistory // ignore: cast_nullable_to_non_nullable
              as List<AiChatMessage>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiRequestImplCopyWith<$Res>
    implements $AiRequestCopyWith<$Res> {
  factory _$$AiRequestImplCopyWith(
          _$AiRequestImpl value, $Res Function(_$AiRequestImpl) then) =
      __$$AiRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String visitId,
      String message,
      String? imageBase64,
      List<AiChatMessage>? conversationHistory});
}

/// @nodoc
class __$$AiRequestImplCopyWithImpl<$Res>
    extends _$AiRequestCopyWithImpl<$Res, _$AiRequestImpl>
    implements _$$AiRequestImplCopyWith<$Res> {
  __$$AiRequestImplCopyWithImpl(
      _$AiRequestImpl _value, $Res Function(_$AiRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visitId = null,
    Object? message = null,
    Object? imageBase64 = freezed,
    Object? conversationHistory = freezed,
  }) {
    return _then(_$AiRequestImpl(
      visitId: null == visitId
          ? _value.visitId
          : visitId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imageBase64: freezed == imageBase64
          ? _value.imageBase64
          : imageBase64 // ignore: cast_nullable_to_non_nullable
              as String?,
      conversationHistory: freezed == conversationHistory
          ? _value._conversationHistory
          : conversationHistory // ignore: cast_nullable_to_non_nullable
              as List<AiChatMessage>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiRequestImpl implements _AiRequest {
  const _$AiRequestImpl(
      {required this.visitId,
      required this.message,
      this.imageBase64,
      final List<AiChatMessage>? conversationHistory})
      : _conversationHistory = conversationHistory;

  factory _$AiRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiRequestImplFromJson(json);

  @override
  final String visitId;
  @override
  final String message;
  @override
  final String? imageBase64;
  final List<AiChatMessage>? _conversationHistory;
  @override
  List<AiChatMessage>? get conversationHistory {
    final value = _conversationHistory;
    if (value == null) return null;
    if (_conversationHistory is EqualUnmodifiableListView)
      return _conversationHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AiRequest(visitId: $visitId, message: $message, imageBase64: $imageBase64, conversationHistory: $conversationHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiRequestImpl &&
            (identical(other.visitId, visitId) || other.visitId == visitId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imageBase64, imageBase64) ||
                other.imageBase64 == imageBase64) &&
            const DeepCollectionEquality()
                .equals(other._conversationHistory, _conversationHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, visitId, message, imageBase64,
      const DeepCollectionEquality().hash(_conversationHistory));

  /// Create a copy of AiRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiRequestImplCopyWith<_$AiRequestImpl> get copyWith =>
      __$$AiRequestImplCopyWithImpl<_$AiRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiRequestImplToJson(
      this,
    );
  }
}

abstract class _AiRequest implements AiRequest {
  const factory _AiRequest(
      {required final String visitId,
      required final String message,
      final String? imageBase64,
      final List<AiChatMessage>? conversationHistory}) = _$AiRequestImpl;

  factory _AiRequest.fromJson(Map<String, dynamic> json) =
      _$AiRequestImpl.fromJson;

  @override
  String get visitId;
  @override
  String get message;
  @override
  String? get imageBase64;
  @override
  List<AiChatMessage>? get conversationHistory;

  /// Create a copy of AiRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiRequestImplCopyWith<_$AiRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiResponse _$AiResponseFromJson(Map<String, dynamic> json) {
  return _AiResponse.fromJson(json);
}

/// @nodoc
mixin _$AiResponse {
  String get message => throw _privateConstructorUsedError;
  List<String>? get suggestions => throw _privateConstructorUsedError;
  String? get confidence => throw _privateConstructorUsedError;

  /// Serializes this AiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiResponseCopyWith<AiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiResponseCopyWith<$Res> {
  factory $AiResponseCopyWith(
          AiResponse value, $Res Function(AiResponse) then) =
      _$AiResponseCopyWithImpl<$Res, AiResponse>;
  @useResult
  $Res call({String message, List<String>? suggestions, String? confidence});
}

/// @nodoc
class _$AiResponseCopyWithImpl<$Res, $Val extends AiResponse>
    implements $AiResponseCopyWith<$Res> {
  _$AiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? suggestions = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: freezed == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiResponseImplCopyWith<$Res>
    implements $AiResponseCopyWith<$Res> {
  factory _$$AiResponseImplCopyWith(
          _$AiResponseImpl value, $Res Function(_$AiResponseImpl) then) =
      __$$AiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, List<String>? suggestions, String? confidence});
}

/// @nodoc
class __$$AiResponseImplCopyWithImpl<$Res>
    extends _$AiResponseCopyWithImpl<$Res, _$AiResponseImpl>
    implements _$$AiResponseImplCopyWith<$Res> {
  __$$AiResponseImplCopyWithImpl(
      _$AiResponseImpl _value, $Res Function(_$AiResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? suggestions = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_$AiResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: freezed == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiResponseImpl implements _AiResponse {
  const _$AiResponseImpl(
      {required this.message, final List<String>? suggestions, this.confidence})
      : _suggestions = suggestions;

  factory _$AiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiResponseImplFromJson(json);

  @override
  final String message;
  final List<String>? _suggestions;
  @override
  List<String>? get suggestions {
    final value = _suggestions;
    if (value == null) return null;
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? confidence;

  @override
  String toString() {
    return 'AiResponse(message: $message, suggestions: $suggestions, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_suggestions), confidence);

  /// Create a copy of AiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiResponseImplCopyWith<_$AiResponseImpl> get copyWith =>
      __$$AiResponseImplCopyWithImpl<_$AiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiResponseImplToJson(
      this,
    );
  }
}

abstract class _AiResponse implements AiResponse {
  const factory _AiResponse(
      {required final String message,
      final List<String>? suggestions,
      final String? confidence}) = _$AiResponseImpl;

  factory _AiResponse.fromJson(Map<String, dynamic> json) =
      _$AiResponseImpl.fromJson;

  @override
  String get message;
  @override
  List<String>? get suggestions;
  @override
  String? get confidence;

  /// Create a copy of AiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiResponseImplCopyWith<_$AiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiSuggestion _$AiSuggestionFromJson(Map<String, dynamic> json) {
  return _AiSuggestion.fromJson(json);
}

/// @nodoc
mixin _$AiSuggestion {
  String get type =>
      throw _privateConstructorUsedError; // 'service' or 'material'
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double? get estimatedPrice => throw _privateConstructorUsedError;
  String? get reasoning => throw _privateConstructorUsedError;

  /// Serializes this AiSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiSuggestionCopyWith<AiSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiSuggestionCopyWith<$Res> {
  factory $AiSuggestionCopyWith(
          AiSuggestion value, $Res Function(AiSuggestion) then) =
      _$AiSuggestionCopyWithImpl<$Res, AiSuggestion>;
  @useResult
  $Res call(
      {String type,
      String name,
      String description,
      double? estimatedPrice,
      String? reasoning});
}

/// @nodoc
class _$AiSuggestionCopyWithImpl<$Res, $Val extends AiSuggestion>
    implements $AiSuggestionCopyWith<$Res> {
  _$AiSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? estimatedPrice = freezed,
    Object? reasoning = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedPrice: freezed == estimatedPrice
          ? _value.estimatedPrice
          : estimatedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiSuggestionImplCopyWith<$Res>
    implements $AiSuggestionCopyWith<$Res> {
  factory _$$AiSuggestionImplCopyWith(
          _$AiSuggestionImpl value, $Res Function(_$AiSuggestionImpl) then) =
      __$$AiSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String name,
      String description,
      double? estimatedPrice,
      String? reasoning});
}

/// @nodoc
class __$$AiSuggestionImplCopyWithImpl<$Res>
    extends _$AiSuggestionCopyWithImpl<$Res, _$AiSuggestionImpl>
    implements _$$AiSuggestionImplCopyWith<$Res> {
  __$$AiSuggestionImplCopyWithImpl(
      _$AiSuggestionImpl _value, $Res Function(_$AiSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? estimatedPrice = freezed,
    Object? reasoning = freezed,
  }) {
    return _then(_$AiSuggestionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedPrice: freezed == estimatedPrice
          ? _value.estimatedPrice
          : estimatedPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiSuggestionImpl implements _AiSuggestion {
  const _$AiSuggestionImpl(
      {required this.type,
      required this.name,
      required this.description,
      this.estimatedPrice,
      this.reasoning});

  factory _$AiSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiSuggestionImplFromJson(json);

  @override
  final String type;
// 'service' or 'material'
  @override
  final String name;
  @override
  final String description;
  @override
  final double? estimatedPrice;
  @override
  final String? reasoning;

  @override
  String toString() {
    return 'AiSuggestion(type: $type, name: $name, description: $description, estimatedPrice: $estimatedPrice, reasoning: $reasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiSuggestionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.estimatedPrice, estimatedPrice) ||
                other.estimatedPrice == estimatedPrice) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, name, description, estimatedPrice, reasoning);

  /// Create a copy of AiSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiSuggestionImplCopyWith<_$AiSuggestionImpl> get copyWith =>
      __$$AiSuggestionImplCopyWithImpl<_$AiSuggestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiSuggestionImplToJson(
      this,
    );
  }
}

abstract class _AiSuggestion implements AiSuggestion {
  const factory _AiSuggestion(
      {required final String type,
      required final String name,
      required final String description,
      final double? estimatedPrice,
      final String? reasoning}) = _$AiSuggestionImpl;

  factory _AiSuggestion.fromJson(Map<String, dynamic> json) =
      _$AiSuggestionImpl.fromJson;

  @override
  String get type; // 'service' or 'material'
  @override
  String get name;
  @override
  String get description;
  @override
  double? get estimatedPrice;
  @override
  String? get reasoning;

  /// Create a copy of AiSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiSuggestionImplCopyWith<_$AiSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
