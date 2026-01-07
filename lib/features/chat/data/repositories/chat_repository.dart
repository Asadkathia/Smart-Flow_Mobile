import 'dart:io';
import 'dart:convert';
import '../models/chat_models.dart';
import '../datasources/chat_mock_data.dart';
import '../../../../shared/data/remote/api_client.dart';
import '../../../../shared/data/local/offline_queue_service.dart';
import '../../../../shared/data/local/hive_service.dart';
import '../../../../shared/data/repositories/base_repository.dart';
import '../../../../core/constants/storage_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chat Repository
/// 
/// Handles all chat-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class ChatRepository extends BaseRepository {
  ChatRepository(
    ApiClient apiClient,
    CacheService cache,
    OfflineQueueService offlineQueue, {
    bool? useMockData,
  }) : super(apiClient, cache, offlineQueue, useMockData: useMockData);

  /// Get all chat threads for current user - unified pattern
  /// 
  /// [page] and [pageSize] are optional for backward compatibility.
  /// When provided, enables pagination support.
  Future<List<ChatThreadModel>> getChatThreads({
    int? page,
    int? pageSize,
  }) async {
    return await fetchList<ChatThreadModel>(
      cacheKey: StorageKeys.chatBox,
      apiCall: () async {
        final queryParams = <String, dynamic>{};
        if (page != null) queryParams['page'] = page;
        if (pageSize != null) queryParams['page_size'] = pageSize;
        
        final response = await apiClient.get(
          '/v1/chats',
          queryParameters: queryParams.isEmpty ? null : queryParams,
        );
        
        // Handle paginated response if page/pageSize provided
        if (page != null || pageSize != null) {
          if (response.data is Map && response.data['data'] != null) {
            final List<dynamic> data = response.data['data'] as List;
            return data.map((json) => ChatThreadModel.fromJson(json)).toList();
          }
        }
        
        final List<dynamic> data = response.data as List;
        return data.map((json) => ChatThreadModel.fromJson(json)).toList();
      },
      fromJson: (data) => ChatThreadModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => ChatMockData.getChatThreads() : null,
    );
  }

  /// Get single chat thread - unified pattern
  Future<ChatThreadModel> getChatThread(String chatId) async {
    return await fetch<ChatThreadModel>(
      cacheKey: 'chat_thread_$chatId',
      apiCall: () async {
        final response = await apiClient.get('/v1/chats/$chatId');
        return ChatThreadModel.fromJson(response.data);
      },
      fromJson: (data) => ChatThreadModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              final threads = ChatMockData.getChatThreads();
              return threads.firstWhere((thread) => thread.id == chatId);
            }
          : null,
    );
  }

  /// Get messages for a chat thread - unified pattern
  Future<List<ChatMessageModel>> getMessages(String chatId) async {
    return await fetchList<ChatMessageModel>(
      cacheKey: 'chat_messages_$chatId',
      apiCall: () async {
        final response = await apiClient.get('/v1/chats/$chatId/messages');
        final List<dynamic> data = response.data as List;
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      },
      fromJson: (data) => ChatMessageModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData ? () => ChatMockData.getMessages(chatId) : null,
      cacheResult: false, // Don't cache messages (realtime updates)
    );
  }

  /// Send a message to a chat thread - with offline support
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String messageBody,
  }) async {
    final newMessage = ChatMessageModel(
      id: generateId(),
      chatId: chatId,
      // TODO (Phase 2): Get from auth provider when backend is ready
      senderId: ChatMockData.currentUserId,
      senderName: 'Tony Stark',
      messageBody: messageBody,
      createdAt: DateTime.now(),
    );

    return await mutate<ChatMessageModel>(
      cacheKey: 'chat_messages_$chatId',
      apiCall: () async {
        final response = await apiClient.post(
          '/v1/chats/$chatId/messages',
          data: {
            'message_body': messageBody,
          },
        );
        return ChatMessageModel.fromJson(response.data);
      },
      actionType: PendingActionType.sendMessage,
      actionData: {
        'chat_id': chatId,
        'message_body': messageBody,
      },
      fromJson: (data) => ChatMessageModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => newMessage,
      updateCache: false, // Don't update cache for messages (realtime)
    );
  }

  /// Create a direct chat - with offline support
  Future<ChatThreadModel> createDirectChat({
    required String otherUserId,
    required String otherUserName,
  }) async {
    final newThread = ChatThreadModel(
      id: generateId(),
      type: ChatType.direct,
      // TODO (Phase 2): Get from auth provider when backend is ready
      createdBy: ChatMockData.currentUserId,
      participants: [
        ChatParticipantModel(
          id: generateId(),
          chatId: 'chat-new',
          userId: ChatMockData.currentUserId,
          userName: 'Tony Stark',
          roleInChat: 'member',
        ),
        ChatParticipantModel(
          id: generateId(),
          chatId: 'chat-new',
          userId: otherUserId,
          userName: otherUserName,
          roleInChat: 'member',
        ),
      ],
      unreadCount: 0,
      createdAt: DateTime.now(),
    );

    return await mutate<ChatThreadModel>(
      cacheKey: StorageKeys.chatBox,
      apiCall: () async {
        final response = await apiClient.post(
          '/v1/chats',
          data: {
            'type': 'direct',
            'participant_id': otherUserId,
          },
        );
        return ChatThreadModel.fromJson(response.data);
      },
      actionType: PendingActionType.sendMessage, // Reuse sendMessage type for now
      actionData: {
        'type': 'direct',
        'participant_id': otherUserId,
      },
      fromJson: (data) => ChatThreadModel.fromJson(data as Map<String, dynamic>),
      optimisticUpdate: () => newThread,
    );
  }

  /// Mark messages as read
  Future<void> markAsRead(String chatId) async {
    try {
      await apiClient.post('/v1/chats/$chatId/mark-read');
      // Invalidate cache to refresh unread count
      await clearCache('chat_thread_$chatId');
      await clearCache(StorageKeys.chatBox);
    } catch (e) {
      // Silently fail - not critical
    }
  }

  /// Search chat threads - unified pattern
  Future<List<ChatThreadModel>> searchChats(String query) async {
    final cacheKey = '${StorageKeys.chatBox}_search_$query';
    
    return await fetchList<ChatThreadModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await apiClient.get(
          '/v1/chats',
          queryParameters: {'search': query},
        );
        final List<dynamic> data = response.data as List;
        return data.map((json) => ChatThreadModel.fromJson(json)).toList();
      },
      fromJson: (data) => ChatThreadModel.fromJson(data as Map<String, dynamic>),
      mockData: useMockData
          ? () {
              final threads = ChatMockData.getChatThreads();
              return threads
                  .where((thread) =>
                      thread.getDisplayName(ChatMockData.currentUserId)
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      (thread.lastMessage?.messageBody.toLowerCase().contains(query.toLowerCase()) ?? false))
                  .toList();
            }
          : null,
      cacheResult: false, // Don't cache search results
    );
  }
}

/// Chat Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cache = ref.watch(chatCacheProvider);
  final offlineQueue = ref.watch(offlineQueueServiceProvider);
  
  return ChatRepository(
    apiClient,
    cache,
    offlineQueue,
    useMockData: null, // Will use AppConfig default
  );
});

