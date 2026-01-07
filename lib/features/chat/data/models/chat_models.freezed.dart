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
  ChatType get type => throw _privateConstructorUsedError;
  String? get title =>
      throw _privateConstructorUsedError; // Only for group chats
  String get createdBy => throw _privateConstructorUsedError;
  List<ChatParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  ChatMessageModel? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
      ChatType type,
      String? title,
      String createdBy,
      List<ChatParticipantModel> participants,
      ChatMessageModel? lastMessage,
      int unreadCount,
      DateTime? createdAt,
      DateTime? updatedAt});

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
    Object? type = null,
    Object? title = freezed,
    Object? createdBy = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      ChatType type,
      String? title,
      String createdBy,
      List<ChatParticipantModel> participants,
      ChatMessageModel? lastMessage,
      int unreadCount,
      DateTime? createdAt,
      DateTime? updatedAt});

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
    Object? type = null,
    Object? title = freezed,
    Object? createdBy = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChatThreadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadModelImpl implements _ChatThreadModel {
  const _$ChatThreadModelImpl(
      {required this.id,
      required this.type,
      this.title,
      required this.createdBy,
      required final List<ChatParticipantModel> participants,
      this.lastMessage,
      this.unreadCount = 0,
      this.createdAt,
      this.updatedAt})
      : _participants = participants;

  factory _$ChatThreadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadModelImplFromJson(json);

  @override
  final String id;
  @override
  final ChatType type;
  @override
  final String? title;
// Only for group chats
  @override
  final String createdBy;
  final List<ChatParticipantModel> _participants;
  @override
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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChatThreadModel(id: $id, type: $type, title: $title, createdBy: $createdBy, participants: $participants, lastMessage: $lastMessage, unreadCount: $unreadCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality()
                .equals(other._participants, _participants) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
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
      type,
      title,
      createdBy,
      const DeepCollectionEquality().hash(_participants),
      lastMessage,
      unreadCount,
      createdAt,
      updatedAt);

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
      required final ChatType type,
      final String? title,
      required final String createdBy,
      required final List<ChatParticipantModel> participants,
      final ChatMessageModel? lastMessage,
      final int unreadCount,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ChatThreadModelImpl;

  factory _ChatThreadModel.fromJson(Map<String, dynamic> json) =
      _$ChatThreadModelImpl.fromJson;

  @override
  String get id;
  @override
  ChatType get type;
  @override
  String? get title; // Only for group chats
  @override
  String get createdBy;
  @override
  List<ChatParticipantModel> get participants;
  @override
  ChatMessageModel? get lastMessage;
  @override
  int get unreadCount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

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
  String get chatId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String get roleInChat =>
      throw _privateConstructorUsedError; // 'admin' or 'member'
  DateTime? get joinedAt => throw _privateConstructorUsedError;

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
      String chatId,
      String userId,
      String? userName,
      String? userAvatar,
      String roleInChat,
      DateTime? joinedAt});
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
    Object? chatId = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? roleInChat = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      roleInChat: null == roleInChat
          ? _value.roleInChat
          : roleInChat // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      String chatId,
      String userId,
      String? userName,
      String? userAvatar,
      String roleInChat,
      DateTime? joinedAt});
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
    Object? chatId = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? roleInChat = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_$ChatParticipantModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      roleInChat: null == roleInChat
          ? _value.roleInChat
          : roleInChat // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatParticipantModelImpl implements _ChatParticipantModel {
  const _$ChatParticipantModelImpl(
      {required this.id,
      required this.chatId,
      required this.userId,
      this.userName,
      this.userAvatar,
      this.roleInChat = 'member',
      this.joinedAt});

  factory _$ChatParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatParticipantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String chatId;
  @override
  final String userId;
  @override
  final String? userName;
  @override
  final String? userAvatar;
  @override
  @JsonKey()
  final String roleInChat;
// 'admin' or 'member'
  @override
  final DateTime? joinedAt;

  @override
  String toString() {
    return 'ChatParticipantModel(id: $id, chatId: $chatId, userId: $userId, userName: $userName, userAvatar: $userAvatar, roleInChat: $roleInChat, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatParticipantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.roleInChat, roleInChat) ||
                other.roleInChat == roleInChat) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, chatId, userId, userName,
      userAvatar, roleInChat, joinedAt);

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
      required final String chatId,
      required final String userId,
      final String? userName,
      final String? userAvatar,
      final String roleInChat,
      final DateTime? joinedAt}) = _$ChatParticipantModelImpl;

  factory _ChatParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ChatParticipantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get chatId;
  @override
  String get userId;
  @override
  String? get userName;
  @override
  String? get userAvatar;
  @override
  String get roleInChat; // 'admin' or 'member'
  @override
  DateTime? get joinedAt;

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
  String get chatId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String? get senderName => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String get messageBody => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  MessageStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
      String chatId,
      String senderId,
      String? senderName,
      String? senderAvatar,
      String messageBody,
      bool isRead,
      MessageStatus status,
      DateTime? createdAt});
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
    Object? chatId = null,
    Object? senderId = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? messageBody = null,
    Object? isRead = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      messageBody: null == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      String chatId,
      String senderId,
      String? senderName,
      String? senderAvatar,
      String messageBody,
      bool isRead,
      MessageStatus status,
      DateTime? createdAt});
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
    Object? chatId = null,
    Object? senderId = null,
    Object? senderName = freezed,
    Object? senderAvatar = freezed,
    Object? messageBody = null,
    Object? isRead = null,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ChatMessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: freezed == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      messageBody: null == messageBody
          ? _value.messageBody
          : messageBody // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MessageStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageModelImpl implements _ChatMessageModel {
  const _$ChatMessageModelImpl(
      {required this.id,
      required this.chatId,
      required this.senderId,
      this.senderName,
      this.senderAvatar,
      required this.messageBody,
      this.isRead = false,
      this.status = MessageStatus.sent,
      this.createdAt});

  factory _$ChatMessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String chatId;
  @override
  final String senderId;
  @override
  final String? senderName;
  @override
  final String? senderAvatar;
  @override
  final String messageBody;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final MessageStatus status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ChatMessageModel(id: $id, chatId: $chatId, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, messageBody: $messageBody, isRead: $isRead, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.messageBody, messageBody) ||
                other.messageBody == messageBody) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, chatId, senderId, senderName,
      senderAvatar, messageBody, isRead, status, createdAt);

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
      required final String chatId,
      required final String senderId,
      final String? senderName,
      final String? senderAvatar,
      required final String messageBody,
      final bool isRead,
      final MessageStatus status,
      final DateTime? createdAt}) = _$ChatMessageModelImpl;

  factory _ChatMessageModel.fromJson(Map<String, dynamic> json) =
      _$ChatMessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get chatId;
  @override
  String get senderId;
  @override
  String? get senderName;
  @override
  String? get senderAvatar;
  @override
  String get messageBody;
  @override
  bool get isRead;
  @override
  MessageStatus get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of ChatMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageModelImplCopyWith<_$ChatMessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
