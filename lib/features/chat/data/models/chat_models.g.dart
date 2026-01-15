// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadModelImpl _$$ChatThreadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      title: json['title'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) =>
                  ChatParticipantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessageModel.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChatThreadModelImplToJson(
        _$ChatThreadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'title': instance.title,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
    };

const _$ChatTypeEnumMap = {
  ChatType.direct: 'direct',
  ChatType.group: 'group',
};

_$ChatParticipantModelImpl _$$ChatParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      roleInChat: $enumDecodeNullable(
              _$ChatParticipantRoleEnumMap, json['role_in_chat']) ??
          ChatParticipantRole.member,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );

Map<String, dynamic> _$$ChatParticipantModelImplToJson(
        _$ChatParticipantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'chat_id': instance.chatId,
      'user_id': instance.userId,
      'role_in_chat': _$ChatParticipantRoleEnumMap[instance.roleInChat]!,
      'joined_at': instance.joinedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
    };

const _$ChatParticipantRoleEnumMap = {
  ChatParticipantRole.member: 'member',
  ChatParticipantRole.admin: 'admin',
};

_$ChatMessageModelImpl _$$ChatMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      messageBody: json['message_body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderName: json['senderName'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sent,
    );

Map<String, dynamic> _$$ChatMessageModelImplToJson(
        _$ChatMessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'message_body': instance.messageBody,
      'created_at': instance.createdAt.toIso8601String(),
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'isRead': instance.isRead,
      'status': _$MessageStatusEnumMap[instance.status]!,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
