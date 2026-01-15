import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

/// Chat Type Enum
enum ChatType {
  @JsonValue('direct')
  direct,
  @JsonValue('group')
  group,
}

/// Chat Thread Model (PRD Section 3.14)
/// 
/// Represents a chat thread (direct or group).
@freezed
class ChatThreadModel with _$ChatThreadModel {
  const factory ChatThreadModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId, // PRD: required for multi-tenancy
    required ChatType type,
    String? title, // Only for group chats
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt, // Updated when participants are added/removed (group chats only)
    // Keep for UI: participants, lastMessage, unreadCount (not in PRD but needed for frontend)
    @Default([]) List<ChatParticipantModel> participants,
    ChatMessageModel? lastMessage,
    @Default(0) int unreadCount,
  }) = _ChatThreadModel;

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadModelFromJson(json);
}

/// Chat Thread extensions
extension ChatThreadModelX on ChatThreadModel {
  /// Get chat display name
  String getDisplayName(String currentUserId) {
    if (type == ChatType.group) {
      return title ?? 'Group Chat';
    }
    
    // For direct chats, show the other participant's name
    final otherParticipant = participants.firstWhere(
      (p) => p.userId != currentUserId,
      orElse: () => participants.first,
    );
    return otherParticipant.userName ?? 'Unknown User';
  }

  /// Check if current user is admin
  bool isUserAdmin(String currentUserId) {
    final participant = participants.firstWhere(
      (p) => p.userId == currentUserId,
      orElse: () => participants.first,
    );
    return participant.roleInChat == ChatParticipantRole.admin;
  }
}

/// Chat Participant Role Enum (PRD Section 3.15)
enum ChatParticipantRole {
  @JsonValue('member')
  member,
  @JsonValue('admin')
  admin, // Allows adding/removing members in group chats
}

/// Chat Participant Model (PRD Section 3.15)
/// 
/// Represents a participant in a chat thread.
@freezed
class ChatParticipantModel with _$ChatParticipantModel {
  const factory ChatParticipantModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId, // PRD: required for multi-tenancy
    @JsonKey(name: 'chat_id') required String chatId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role_in_chat')
    @Default(ChatParticipantRole.member)
    ChatParticipantRole roleInChat, // member, admin
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt, // PRD: required
    // Keep for UI: userName, userAvatar (not in PRD but needed for frontend)
    String? userName,
    String? userAvatar,
  }) = _ChatParticipantModel;

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantModelFromJson(json);
}

/// Message Status Enum
/// 
/// Represents the delivery status of a message.
enum MessageStatus {
  @JsonValue('sending')
  sending,
  @JsonValue('sent')
  sent,
  @JsonValue('delivered')
  delivered,
  @JsonValue('read')
  read,
  @JsonValue('failed')
  failed,
}

/// Chat Message Model (PRD Section 3.16)
/// 
/// Represents a message in a chat thread.
@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId, // PRD: required for multi-tenancy
    @JsonKey(name: 'chat_id') required String chatId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'message_body') required String messageBody, // Max length: 5000 characters
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Keep for UI: senderName, senderAvatar, isRead, status (not in PRD but needed for frontend)
    String? senderName,
    String? senderAvatar,
    @Default(false) bool isRead,
    @Default(MessageStatus.sent) MessageStatus status,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}

/// Chat Message extensions
extension ChatMessageModelX on ChatMessageModel {
  /// Check if message is from current user
  bool isFromCurrentUser(String currentUserId) {
    return senderId == currentUserId;
  }

  /// Get formatted time
  String getFormattedTime() {
    if (createdAt == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${createdAt!.month}/${createdAt!.day}/${createdAt!.year}';
    }
  }

  /// Get status icon for message
  IconData getStatusIcon() {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }

  /// Get status color
  Color getStatusColor() {
    switch (status) {
      case MessageStatus.sending:
        return Colors.grey;
      case MessageStatus.sent:
        return Colors.grey;
      case MessageStatus.delivered:
        return Colors.grey;
      case MessageStatus.read:
        return Colors.blue;
      case MessageStatus.failed:
        return Colors.red;
    }
  }
}
