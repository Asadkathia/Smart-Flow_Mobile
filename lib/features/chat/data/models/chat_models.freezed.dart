// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThreadModel _$ChatThreadModelFromJson(Map<String, dynamic> json) {
  return _ChatThreadModel.fromJson(json);
}

/// @nodoc
mixin _$ChatThreadModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId =>
      throw _privateConstructorUsedError; // PRD: required for multi-tenancy
  ChatType get type => throw _privateConstructorUsedError;
  String? get title =>
      throw _privateConstructorUsedError; // Only for group chats
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Updated when participants are added/removed (group chats only)
// Keep for UI: participants, lastMessage, unreadCount (not in PRD but needed for frontend)
  List<ChatParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  ChatMessageModel? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this ChatThreadModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadModelCopyWith<ChatThreadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadModelCopyWith<$Res> {
  factory $ChatThreadModelCopyWith(
          ChatThreadModel value, $Res Function(ChatThreadModel) then) =
      _$ChatThreadModelCopyWithImpl<$Res, ChatThreadModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      ChatType type,
      String? title,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<ChatParticipantModel> participants,
      ChatMessageModel? lastMessage,
      int unreadCount});

  $ChatMessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ChatThreadModelCopyWithImpl<$Res, $Val extends ChatThreadModel>
    implements $ChatThreadModelCopyWith<$Res> {
  _$ChatThreadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? type = null,
    Object? title = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatType,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ChatParticipantModel>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageModelCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $ChatMessageModelCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatThreadModelImplCopyWith<$Res>
    implements $ChatThreadModelCopyWith<$Res> {
  factory _$$ChatThreadModelImplCopyWith(_$ChatThreadModelImpl value,
          $Res Function(_$ChatThreadModelImpl) then) =
      __$$ChatThreadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      ChatType type,
      String? title,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      List<ChatParticipantModel> participants,
      ChatMessageModel? lastMessage,
      int unreadCount});

  @override
  $ChatMessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ChatThreadModelImplCopyWithImpl<$Res>
    extends _$ChatThreadModelCopyWithImpl<$Res, _$ChatThreadModelImpl>
    implements _$$ChatThreadModelImplCopyWith<$Res> {
  __$$ChatThreadModelImplCopyWithImpl(
      _$ChatThreadModelImpl _value, $Res Function(_$ChatThreadModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? type = null,
    Object? title = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_$ChatThreadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChatType,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participants: null == participants
          ? _value._participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<ChatParticipantModel>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as ChatMessageModel?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadModelImpl implements _ChatThreadModel {
  const _$ChatThreadModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      required this.type,
      this.title,
      @JsonKey(name: 'created_by') required this.createdBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      final List<ChatParticipantModel> participants = const [],
      this.lastMessage,
      this.unreadCount = 0})
      : _participants = participants;

  factory _$ChatThreadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
// PRD: required for multi-tenancy
  @override
  final ChatType type;
  @override
  final String? title;
// Only for group chats
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Updated when participants are added/removed (group chats only)
// Keep for UI: participants, lastMessage, unreadCount (not in PRD but needed for frontend)
  final List<ChatParticipantModel> _participants;
// Updated when participants are added/removed (group chats only)
// Keep for UI: participants, lastMessage, unreadCount (not in PRD but needed for frontend)
  @override
  @JsonKey()
  List<ChatParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final ChatMessageModel? lastMessage;
  @override
  @JsonKey()
  final int unreadCount;

  @override
  String toString() {
    return 'ChatThreadModel(id: $id, orgId: $orgId, type: $type, title: $title, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, participants: $participants, lastMessage: $lastMessage, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orgId,
      type,
      title,
      createdBy,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_participants),
      lastMessage,
      unreadCount);

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadModelImplCopyWith<_$ChatThreadModelImpl> get copyWith =>
      __$$ChatThreadModelImplCopyWithImpl<_$ChatThreadModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadModelImplToJson(
      this,
    );
  }
}

abstract class _ChatThreadModel implements ChatThreadModel {
  const factory _ChatThreadModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      required final ChatType type,
      final String? title,
      @JsonKey(name: 'created_by') required final String createdBy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final List<ChatParticipantModel> participants,
      final ChatMessageModel? lastMessage,
      final int unreadCount}) = _$ChatThreadModelImpl;

  factory _ChatThreadModel.fromJson(Map<String, dynamic> json) =
      _$ChatThreadModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId; // PRD: required for multi-tenancy
  @override
  ChatType get type;
  @override
  String? get title; // Only for group chats
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime
      get updatedAt; // Updated when participants are added/removed (group chats only)
// Keep for UI: participants, lastMessage, unreadCount (not in PRD but needed for frontend)
  @override
  List<ChatParticipantModel> get participants;
  @override
  ChatMessageModel? get lastMessage;
  @override
  int get unreadCount;

  /// Create a copy of ChatThreadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadModelImplCopyWith<_$ChatThreadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatParticipantModel _$ChatParticipantModelFromJson(Map<String, dynamic> json) {
  return _ChatParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$ChatParticipantModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId =>
      throw _privateConstructorUsedError; // PRD: required for multi-tenancy
  @JsonKey(name: 'chat_id')
  String get chatId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_in_chat')
  ChatParticipantRole get roleInChat =>
      throw _privateConstructorUsedError; // member, admin
  @JsonKey(name: 'joined_at')
  DateTime get joinedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError; // PRD: required
// Keep for UI: userName, userAvatar (not in PRD but needed for frontend)
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;

  /// Serializes this ChatParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatParticipantModelCopyWith<ChatParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatParticipantModelCopyWith<$Res> {
  factory $ChatParticipantModelCopyWith(ChatParticipantModel value,
          $Res Function(ChatParticipantModel) then) =
      _$ChatParticipantModelCopyWithImpl<$Res, ChatParticipantModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role_in_chat') ChatParticipantRole roleInChat,
      @JsonKey(name: 'joined_at') DateTime joinedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? userName,
      String? userAvatar});
}

/// @nodoc
class _$ChatParticipantModelCopyWithImpl<$Res,
        $Val extends ChatParticipantModel>
    implements $ChatParticipantModelCopyWith<$Res> {
  _$ChatParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? chatId = null,
    Object? userId = null,
    Object? roleInChat = null,
    Object? joinedAt = null,
    Object? createdAt = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
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
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roleInChat: null == roleInChat
          ? _value.roleInChat
          : roleInChat // ignore: cast_nullable_to_non_nullable
              as ChatParticipantRole,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatParticipantModelImplCopyWith<$Res>
    implements $ChatParticipantModelCopyWith<$Res> {
  factory _$$ChatParticipantModelImplCopyWith(_$ChatParticipantModelImpl value,
          $Res Function(_$ChatParticipantModelImpl) then) =
      __$$ChatParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role_in_chat') ChatParticipantRole roleInChat,
      @JsonKey(name: 'joined_at') DateTime joinedAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? userName,
      String? userAvatar});
}

/// @nodoc
class __$$ChatParticipantModelImplCopyWithImpl<$Res>
    extends _$ChatParticipantModelCopyWithImpl<$Res, _$ChatParticipantModelImpl>
    implements _$$ChatParticipantModelImplCopyWith<$Res> {
  __$$ChatParticipantModelImplCopyWithImpl(_$ChatParticipantModelImpl _value,
      $Res Function(_$ChatParticipantModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? chatId = null,
    Object? userId = null,
    Object? roleInChat = null,
    Object? joinedAt = null,
    Object? createdAt = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
  }) {
    return _then(_$ChatParticipantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      roleInChat: null == roleInChat
          ? _value.roleInChat
          : roleInChat // ignore: cast_nullable_to_non_nullable
              as ChatParticipantRole,
      joinedAt: null == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantModelImpl implements _ChatParticipantModel {
  const _$ChatParticipantModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'chat_id') required this.chatId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'role_in_chat')
      this.roleInChat = ChatParticipantRole.member,
      @JsonKey(name: 'joined_at') required this.joinedAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.userName,
      this.userAvatar});

  factory _$ChatParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
// PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'chat_id')
  final String chatId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'role_in_chat')
  final ChatParticipantRole roleInChat;
// member, admin
  @override
  @JsonKey(name: 'joined_at')
  final DateTime joinedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// PRD: required
// Keep for UI: userName, userAvatar (not in PRD but needed for frontend)
  @override
  final String? userName;
  @override
  final String? userAvatar;

  @override
  String toString() {
    return 'ChatParticipantModel(id: $id, orgId: $orgId, chatId: $chatId, userId: $userId, roleInChat: $roleInChat, joinedAt: $joinedAt, createdAt: $createdAt, userName: $userName, userAvatar: $userAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roleInChat, roleInChat) ||
                other.roleInChat == roleInChat) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, chatId, userId,
      roleInChat, joinedAt, createdAt, userName, userAvatar);

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatParticipantModelImplCopyWith<_$ChatParticipantModelImpl>
      get copyWith =>
          __$$ChatParticipantModelImplCopyWithImpl<_$ChatParticipantModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatParticipantModelImplToJson(
      this,
    );
  }
}

abstract class _ChatParticipantModel implements ChatParticipantModel {
  const factory _ChatParticipantModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'chat_id') required final String chatId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'role_in_chat') final ChatParticipantRole roleInChat,
      @JsonKey(name: 'joined_at') required final DateTime joinedAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final String? userName,
      final String? userAvatar}) = _$ChatParticipantModelImpl;

  factory _ChatParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId; // PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'chat_id')
  String get chatId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'role_in_chat')
  ChatParticipantRole get roleInChat; // member, admin
  @override
  @JsonKey(name: 'joined_at')
  DateTime get joinedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // PRD: required
// Keep for UI: userName, userAvatar (not in PRD but needed for frontend)
  @override
  String? get userName;
  @override
  String? get userAvatar;

  /// Create a copy of ChatParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatParticipantModelImplCopyWith<_$ChatParticipantModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return _ChatMessageModel.fromJson(json);
}

/// @nodoc
mixin _$ChatMessageModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'org_id')
  String get orgId =>
      throw _privateConstructorUsedError; // PRD: required for multi-tenancy
  @JsonKey(name: 'chat_id')
  String get chatId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  String get senderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_body')
  String get messageBody =>
      throw _privateConstructorUsedError; // Max length: 5000 characters
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Keep for UI: senderName, senderAvatar, isRead, status (not in PRD but needed for frontend)
  String? get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;

  /// Serializes this ChatMessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageModelCopyWith<ChatMessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageModelCopyWith<$Res> {
  factory $ChatMessageModelCopyWith(
          ChatMessageModel value, $Res Function(ChatMessageModel) then) =
      _$ChatMessageModelCopyWithImpl<$Res, ChatMessageModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'sender_id') String senderId,
      @JsonKey(name: 'message_body') String messageBody,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? senderName,
      String? senderAvatar,
      bool isRead,
      MessageStatus status});
}

/// @nodoc
class _$ChatMessageModelCopyWithImpl<$Res, $Val extends ChatMessageModel>
    implements $ChatMessageModelCopyWith<$Res> {
  _$ChatMessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? messageBody = null,
    Object? createdAt = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? isRead = null,
    Object? status = null,
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
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      messageBody: null == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageModelImplCopyWith<$Res>
    implements $ChatMessageModelCopyWith<$Res> {
  factory _$$ChatMessageModelImplCopyWith(_$ChatMessageModelImpl value,
          $Res Function(_$ChatMessageModelImpl) then) =
      __$$ChatMessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'org_id') String orgId,
      @JsonKey(name: 'chat_id') String chatId,
      @JsonKey(name: 'sender_id') String senderId,
      @JsonKey(name: 'message_body') String messageBody,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? senderName,
      String? senderAvatar,
      bool isRead,
      MessageStatus status});
}

/// @nodoc
class __$$ChatMessageModelImplCopyWithImpl<$Res>
    extends _$ChatMessageModelCopyWithImpl<$Res, _$ChatMessageModelImpl>
    implements _$$ChatMessageModelImplCopyWith<$Res> {
  __$$ChatMessageModelImplCopyWithImpl(_$ChatMessageModelImpl _value,
      $Res Function(_$ChatMessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orgId = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? messageBody = null,
    Object? createdAt = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? isRead = null,
    Object? status = null,
  }) {
    return _then(_$ChatMessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orgId: null == orgId
          ? _value.orgId
          : orgId // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      messageBody: null == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageModelImpl implements _ChatMessageModel {
  const _$ChatMessageModelImpl(
      {required this.id,
      @JsonKey(name: 'org_id') required this.orgId,
      @JsonKey(name: 'chat_id') required this.chatId,
      @JsonKey(name: 'sender_id') required this.senderId,
      @JsonKey(name: 'message_body') required this.messageBody,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.senderName,
      this.senderAvatar,
      this.isRead = false,
      this.status = MessageStatus.sent});

  factory _$ChatMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'org_id')
  final String orgId;
// PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'chat_id')
  final String chatId;
  @override
  @JsonKey(name: 'sender_id')
  final String senderId;
  @override
  @JsonKey(name: 'message_body')
  final String messageBody;
// Max length: 5000 characters
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// Keep for UI: senderName, senderAvatar, isRead, status (not in PRD but needed for frontend)
  @override
  final String? senderName;
  @override
  final String? senderAvatar;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final MessageStatus status;

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, orgId: $orgId, chatId: $chatId, senderId: $senderId, messageBody: $messageBody, createdAt: $createdAt, senderName: $senderName, senderAvatar: $senderAvatar, isRead: $isRead, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orgId, orgId) || other.orgId == orgId) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.messageBody, messageBody) ||
                other.messageBody == messageBody) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orgId, chatId, senderId,
      messageBody, createdAt, senderName, senderAvatar, isRead, status);

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      __$$ChatMessageModelImplCopyWithImpl<_$ChatMessageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageModelImplToJson(
      this,
    );
  }
}

abstract class _ChatMessageModel implements ChatMessageModel {
  const factory _ChatMessageModel(
      {required final String id,
      @JsonKey(name: 'org_id') required final String orgId,
      @JsonKey(name: 'chat_id') required final String chatId,
      @JsonKey(name: 'sender_id') required final String senderId,
      @JsonKey(name: 'message_body') required final String messageBody,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final String? senderName,
      final String? senderAvatar,
      final bool isRead,
      final MessageStatus status}) = _$ChatMessageModelImpl;

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$ChatMessageModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'org_id')
  String get orgId; // PRD: required for multi-tenancy
  @override
  @JsonKey(name: 'chat_id')
  String get chatId;
  @override
  @JsonKey(name: 'sender_id')
  String get senderId;
  @override
  @JsonKey(name: 'message_body')
  String get messageBody; // Max length: 5000 characters
  @override
  @JsonKey(name: 'created_at')
  DateTime
      get createdAt; // Keep for UI: senderName, senderAvatar, isRead, status (not in PRD but needed for frontend)
  @override
  String? get senderName;
  @override
  String? get senderAvatar;
  @override
  bool get isRead;
  @override
  MessageStatus get status;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
