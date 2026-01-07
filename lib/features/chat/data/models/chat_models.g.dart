// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadModelImpl _$$ChatThreadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      title: json['title'] as String?,
      createdBy: json['createdBy'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ChatParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChatThreadModelImplToJson(
        _$ChatThreadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'title': instance.title,
      'createdBy': instance.createdBy,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ChatTypeEnumMap = {
  ChatType.direct: 'direct',
  ChatType.group: 'group',
};

_$ChatParticipantModelImpl _$$ChatParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      roleInChat: json['roleInChat'] as String? ?? 'member',
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$$ChatParticipantModelImplToJson(
        _$ChatParticipantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'roleInChat': instance.roleInChat,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };

_$ChatMessageModelImpl _$$ChatMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
      messageBody: json['messageBody'] as String,
      isRead: json['isRead'] as bool? ?? false,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ChatMessageModelImplToJson(
        _$ChatMessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'messageBody': instance.messageBody,
      'isRead': instance.isRead,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
