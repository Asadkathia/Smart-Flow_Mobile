import '../models/chat_models.dart';

/// Mock Chat Data
/// 
/// Provides sample chat threads and messages for development and testing.
class ChatMockData {
  static const String currentUserId = 'user-1'; // Mock current user
  static const String mockOrgId = 'org-1'; // Mock organization ID

  /// Get mock chat threads
  static List<ChatThreadModel> getChatThreads() {
    final now = DateTime.now();
    return [
      // Direct Chat 1
      ChatThreadModel(
        id: 'chat-1',
        orgId: mockOrgId, // PRD: required for multi-tenancy
        type: ChatType.direct,
        createdBy: 'user-1',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
        participants: [
          ChatParticipantModel(
            id: 'p-1',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-1',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 3)),
            createdAt: now.subtract(const Duration(days: 3)),
          ),
          ChatParticipantModel(
            id: 'p-2',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-1',
            userId: 'user-2',
            userName: 'Sarah Johnson',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 3)),
            createdAt: now.subtract(const Duration(days: 3)),
          ),
        ],
        lastMessage: ChatMessageModel(
          id: 'msg-1',
          orgId: mockOrgId, // PRD: required for multi-tenancy
          chatId: 'chat-1',
          senderId: 'user-2',
          senderName: 'Sarah Johnson',
          messageBody: 'Thanks for the update on the HVAC job!',
          createdAt: now.subtract(const Duration(minutes: 15)),
        ),
        unreadCount: 2,
      ),

      // Direct Chat 2
      ChatThreadModel(
        id: 'chat-2',
        orgId: mockOrgId, // PRD: required for multi-tenancy
        type: ChatType.direct,
        createdBy: 'user-1',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        participants: [
          ChatParticipantModel(
            id: 'p-3',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-2',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 5)),
            createdAt: now.subtract(const Duration(days: 5)),
          ),
          ChatParticipantModel(
            id: 'p-4',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-2',
            userId: 'user-3',
            userName: 'Mike Chen',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 5)),
            createdAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        lastMessage: ChatMessageModel(
          id: 'msg-2',
          orgId: mockOrgId, // PRD: required for multi-tenancy
          chatId: 'chat-2',
          senderId: 'user-1',
          senderName: 'Tony Stark',
          messageBody: 'I\'ll be at the site in 20 minutes',
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        unreadCount: 0,
      ),

      // Group Chat
      ChatThreadModel(
        id: 'chat-3',
        orgId: mockOrgId, // PRD: required for multi-tenancy
        type: ChatType.group,
        title: 'Phoenix Team',
        createdBy: 'admin-1',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 4)),
        participants: [
          ChatParticipantModel(
            id: 'p-5',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-3',
            userId: 'admin-1',
            userName: 'Admin User',
            roleInChat: ChatParticipantRole.admin,
            joinedAt: now.subtract(const Duration(days: 30)),
            createdAt: now.subtract(const Duration(days: 30)),
          ),
          ChatParticipantModel(
            id: 'p-6',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-3',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 30)),
            createdAt: now.subtract(const Duration(days: 30)),
          ),
          ChatParticipantModel(
            id: 'p-7',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-3',
            userId: 'user-2',
            userName: 'Sarah Johnson',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 30)),
            createdAt: now.subtract(const Duration(days: 30)),
          ),
          ChatParticipantModel(
            id: 'p-8',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-3',
            userId: 'user-3',
            userName: 'Mike Chen',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 30)),
            createdAt: now.subtract(const Duration(days: 30)),
          ),
        ],
        lastMessage: ChatMessageModel(
          id: 'msg-3',
          orgId: mockOrgId, // PRD: required for multi-tenancy
          chatId: 'chat-3',
          senderId: 'admin-1',
          senderName: 'Admin User',
          messageBody: 'Team meeting at 3 PM today',
          createdAt: now.subtract(const Duration(hours: 4)),
        ),
        unreadCount: 1,
      ),

      // Direct Chat 3
      ChatThreadModel(
        id: 'chat-4',
        orgId: mockOrgId, // PRD: required for multi-tenancy
        type: ChatType.direct,
        createdBy: 'user-4',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 1)),
        participants: [
          ChatParticipantModel(
            id: 'p-9',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-4',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 7)),
            createdAt: now.subtract(const Duration(days: 7)),
          ),
          ChatParticipantModel(
            id: 'p-10',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: 'chat-4',
            userId: 'user-4',
            userName: 'Emily Davis',
            roleInChat: ChatParticipantRole.member,
            joinedAt: now.subtract(const Duration(days: 7)),
            createdAt: now.subtract(const Duration(days: 7)),
          ),
        ],
        lastMessage: ChatMessageModel(
          id: 'msg-4',
          orgId: mockOrgId, // PRD: required for multi-tenancy
          chatId: 'chat-4',
          senderId: 'user-4',
          senderName: 'Emily Davis',
          messageBody: 'Can you check the inventory for thermostats?',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        unreadCount: 0,
      ),
    ];
  }

  /// Get mock messages for a chat thread
  static List<ChatMessageModel> getMessages(String chatId) {
    switch (chatId) {
      case 'chat-1':
        return [
          ChatMessageModel(
            id: 'msg-1-1',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Hey Sarah, I just finished the HVAC installation at the Phoenix location',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ChatMessageModel(
            id: 'msg-1-2',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Great! Did you test the system?',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-1-3',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Yes, everything is working perfectly. Customer signed off on it.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          ),
          ChatMessageModel(
            id: 'msg-1-4',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Excellent work! I\'ll update the office.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
          ChatMessageModel(
            id: 'msg-1-5',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Thanks for the update on the HVAC job!',
            createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
        ];

      case 'chat-2':
        return [
          ChatMessageModel(
            id: 'msg-2-1',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-3',
            senderName: 'Mike Chen',
            messageBody: 'Are you available for the plumbing emergency at Oak Street?',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          ChatMessageModel(
            id: 'msg-2-2',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Yes, I can head there now',
            createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-2-3',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'I\'ll be at the site in 20 minutes',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];

      case 'chat-3':
        return [
          ChatMessageModel(
            id: 'msg-3-1',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'admin-1',
            senderName: 'Admin User',
            messageBody: 'Good morning team! Quick update on today\'s schedule.',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          ChatMessageModel(
            id: 'msg-3-2',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Morning! Ready for the day.',
            createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 55)),
          ),
          ChatMessageModel(
            id: 'msg-3-3',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-3',
            senderName: 'Mike Chen',
            messageBody: 'Good morning everyone!',
            createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-3-4',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'admin-1',
            senderName: 'Admin User',
            messageBody: 'Team meeting at 3 PM today',
            createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ];

      case 'chat-4':
        return [
          ChatMessageModel(
            id: 'msg-4-1',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-4',
            senderName: 'Emily Davis',
            messageBody: 'Hi Tony, I need to check our thermostat inventory',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          ),
          ChatMessageModel(
            id: 'msg-4-2',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Sure, let me check the app',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          ),
          ChatMessageModel(
            id: 'msg-4-3',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'We have 3 digital thermostats in stock',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          ),
          ChatMessageModel(
            id: 'msg-4-4',
            orgId: mockOrgId, // PRD: required for multi-tenancy
            chatId: chatId,
            senderId: 'user-4',
            senderName: 'Emily Davis',
            messageBody: 'Can you check the inventory for thermostats?',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];

      default:
        return [];
    }
  }
}



