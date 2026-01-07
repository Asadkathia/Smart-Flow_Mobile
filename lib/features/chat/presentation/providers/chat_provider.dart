import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_models.dart';
import '../../data/repositories/chat_repository.dart';

/// Chat Threads List Provider
/// 
/// Provides the list of all chat threads for the current user.
final chatThreadsProvider = FutureProvider.autoDispose<List<ChatThreadModel>>((ref) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatThreads();
});

/// Chat Thread Detail Provider
/// 
/// Provides a single chat thread by ID.
final chatThreadProvider = FutureProvider.autoDispose.family<ChatThreadModel, String>((ref, chatId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatThread(chatId);
});

/// Chat Messages Provider
/// 
/// Provides messages for a specific chat thread.
final chatMessagesProvider = FutureProvider.autoDispose.family<List<ChatMessageModel>, String>((ref, chatId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(chatId);
});

/// Chat Actions Provider
/// 
/// Handles chat actions like sending messages, creating chats, marking as read.
class ChatActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _repository;
  final Ref _ref;

  ChatActionsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Send a message
  Future<ChatMessageModel?> sendMessage({
    required String chatId,
    required String messageBody,
  }) async {
    state = const AsyncValue.loading();
    try {
      final message = await _repository.sendMessage(
        chatId: chatId,
        messageBody: messageBody,
      );
      state = const AsyncValue.data(null);
      
      // Refresh messages and threads
      _ref.invalidate(chatMessagesProvider(chatId));
      _ref.invalidate(chatThreadsProvider);
      _ref.invalidate(chatThreadProvider(chatId));
      
      return message;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Create a direct chat
  Future<ChatThreadModel?> createDirectChat({
    required String otherUserId,
    required String otherUserName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final chat = await _repository.createDirectChat(
        otherUserId: otherUserId,
        otherUserName: otherUserName,
      );
      state = const AsyncValue.data(null);
      
      // Refresh chat threads
      _ref.invalidate(chatThreadsProvider);
      
      return chat;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Mark chat as read
  Future<void> markAsRead(String chatId) async {
    try {
      await _repository.markAsRead(chatId);
      
      // Refresh threads to update unread count
      _ref.invalidate(chatThreadsProvider);
      _ref.invalidate(chatThreadProvider(chatId));
    } catch (e) {
      // Silent fail for mark as read
    }
  }

  /// Search chats
  Future<List<ChatThreadModel>> searchChats(String query) async {
    try {
      return await _repository.searchChats(query);
    } catch (e) {
      return [];
    }
  }
}

final chatActionsProvider = StateNotifierProvider<ChatActionsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatActionsNotifier(repository, ref);
});

/// Current User ID Provider (mock for now)
final currentUserIdProvider = Provider<String>((ref) {
  // TODO: Get from auth provider
  return 'user-1';
});

