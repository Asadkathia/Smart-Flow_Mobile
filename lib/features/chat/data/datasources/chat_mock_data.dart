import '../models/chat_models.dart';

/// Mock Chat Data
/// 
/// Provides sample chat threads and messages for development and testing.
class ChatMockData {
  static const String currentUserId = 'user-1'; // Mock current user

  /// Get mock chat threads
  static List<ChatThreadModel> getChatThreads() {
    return [
      // Direct Chat 1
      ChatThreadModel(
        id: 'chat-1',
        type: ChatType.direct,
        createdBy: 'user-1',
        participants: [
          const ChatParticipantModel(
            id: 'p-1',
            chatId: 'chat-1',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: 'member',
          ),
          const ChatParticipantModel(
            id: 'p-2',
            chatId: 'chat-1',
            userId: 'user-2',
            userName: 'Sarah Johnson',
            roleInChat: 'member',
          ),
        ],
        lastMessage: const ChatMessageModel(
          id: 'msg-1',
          chatId: 'chat-1',
          senderId: 'user-2',
          senderName: 'Sarah Johnson',
          messageBody: 'Thanks for the update on the HVAC job!',
          createdAt: null,
        ),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),

      // Direct Chat 2
      ChatThreadModel(
        id: 'chat-2',
        type: ChatType.direct,
        createdBy: 'user-1',
        participants: [
          const ChatParticipantModel(
            id: 'p-3',
            chatId: 'chat-2',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: 'member',
          ),
          const ChatParticipantModel(
            id: 'p-4',
            chatId: 'chat-2',
            userId: 'user-3',
            userName: 'Mike Chen',
            roleInChat: 'member',
          ),
        ],
        lastMessage: const ChatMessageModel(
          id: 'msg-2',
          chatId: 'chat-2',
          senderId: 'user-1',
          senderName: 'Tony Stark',
          messageBody: 'I\'ll be at the site in 20 minutes',
          createdAt: null,
        ),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      // Group Chat
      ChatThreadModel(
        id: 'chat-3',
        type: ChatType.group,
        title: 'Phoenix Team',
        createdBy: 'admin-1',
        participants: [
          const ChatParticipantModel(
            id: 'p-5',
            chatId: 'chat-3',
            userId: 'admin-1',
            userName: 'Admin User',
            roleInChat: 'admin',
          ),
          const ChatParticipantModel(
            id: 'p-6',
            chatId: 'chat-3',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: 'member',
          ),
          const ChatParticipantModel(
            id: 'p-7',
            chatId: 'chat-3',
            userId: 'user-2',
            userName: 'Sarah Johnson',
            roleInChat: 'member',
          ),
          const ChatParticipantModel(
            id: 'p-8',
            chatId: 'chat-3',
            userId: 'user-3',
            userName: 'Mike Chen',
            roleInChat: 'member',
          ),
        ],
        lastMessage: const ChatMessageModel(
          id: 'msg-3',
          chatId: 'chat-3',
          senderId: 'admin-1',
          senderName: 'Admin User',
          messageBody: 'Team meeting at 3 PM today',
          createdAt: null,
        ),
        unreadCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),

      // Direct Chat 3
      ChatThreadModel(
        id: 'chat-4',
        type: ChatType.direct,
        createdBy: 'user-4',
        participants: [
          const ChatParticipantModel(
            id: 'p-9',
            chatId: 'chat-4',
            userId: 'user-1',
            userName: 'Tony Stark',
            roleInChat: 'member',
          ),
          const ChatParticipantModel(
            id: 'p-10',
            chatId: 'chat-4',
            userId: 'user-4',
            userName: 'Emily Davis',
            roleInChat: 'member',
          ),
        ],
        lastMessage: const ChatMessageModel(
          id: 'msg-4',
          chatId: 'chat-4',
          senderId: 'user-4',
          senderName: 'Emily Davis',
          messageBody: 'Can you check the inventory for thermostats?',
          createdAt: null,
        ),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
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
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Hey Sarah, I just finished the HVAC installation at the Phoenix location',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ChatMessageModel(
            id: 'msg-1-2',
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Great! Did you test the system?',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-1-3',
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Yes, everything is working perfectly. Customer signed off on it.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          ),
          ChatMessageModel(
            id: 'msg-1-4',
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Excellent work! I\'ll update the office.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
          ChatMessageModel(
            id: 'msg-1-5',
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
            chatId: chatId,
            senderId: 'user-3',
            senderName: 'Mike Chen',
            messageBody: 'Are you available for the plumbing emergency at Oak Street?',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          ChatMessageModel(
            id: 'msg-2-2',
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Yes, I can head there now',
            createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-2-3',
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
            chatId: chatId,
            senderId: 'admin-1',
            senderName: 'Admin User',
            messageBody: 'Good morning team! Quick update on today\'s schedule.',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          ChatMessageModel(
            id: 'msg-3-2',
            chatId: chatId,
            senderId: 'user-2',
            senderName: 'Sarah Johnson',
            messageBody: 'Morning! Ready for the day.',
            createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 55)),
          ),
          ChatMessageModel(
            id: 'msg-3-3',
            chatId: chatId,
            senderId: 'user-3',
            senderName: 'Mike Chen',
            messageBody: 'Good morning everyone!',
            createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)),
          ),
          ChatMessageModel(
            id: 'msg-3-4',
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
            chatId: chatId,
            senderId: 'user-4',
            senderName: 'Emily Davis',
            messageBody: 'Hi Tony, I need to check our thermostat inventory',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          ),
          ChatMessageModel(
            id: 'msg-4-2',
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'Sure, let me check the app',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          ),
          ChatMessageModel(
            id: 'msg-4-3',
            chatId: chatId,
            senderId: 'user-1',
            senderName: 'Tony Stark',
            messageBody: 'We have 3 digital thermostats in stock',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          ),
          ChatMessageModel(
            id: 'msg-4-4',
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



