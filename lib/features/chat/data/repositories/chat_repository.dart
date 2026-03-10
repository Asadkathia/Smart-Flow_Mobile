import '../models/chat_models.dart';
import '../datasources/chat_mock_data.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import 'package:smartflowpro/shared/data/local/offline_queue_service.dart';
import 'package:smartflowpro/shared/data/local/hive_service.dart';
import 'package:smartflowpro/shared/data/repositories/base_repository.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/services/auth_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chat Repository
/// 
/// Handles all chat-related data operations.
/// Extends BaseRepository for unified data fetching strategy:
/// API → Cache → Mock (dev only)
class ChatRepository extends BaseRepository {
  ChatRepository(
    super.apiClient,
    super.cache,
    super.offlineQueue, {
    super.useMockData,
  });

  /// Get all chat threads for current user - unified pattern
  /// 
  /// Uses REST API directly to avoid ES256 JWT issues with Edge Functions.
  /// RLS policies will filter by participant (current user) automatically.
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
        // Use REST API directly (works with ES256 JWT)
        // Order by last message timestamp descending to show most recent first
        String url = '${ApiEndpoints.restApiBaseFull}/chat_threads?select=*&order=updated_at.desc';
        
        // Note: page/pageSize support via limit/offset
        if (page != null && pageSize != null) {
          final offset = (page - 1) * pageSize;
          url += '&limit=$pageSize&offset=$offset';
        }
        
        final response = await apiClient.get(url);
        
        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => ChatThreadModel.fromJson(json)).toList();
        }
        
        return [];
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
        // Use REST API for single thread (or filter from threads list)
        final url = '${ApiEndpoints.restApiBaseFull}/chat_threads?id=eq.$chatId&select=*';
        final response = await apiClient.get(url);
        
        if (response.data is List && (response.data as List).isNotEmpty) {
          return ChatThreadModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        throw Exception('Chat thread not found');
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
        // Use REST API directly (works with ES256 JWT)
        // Order by created_at ascending to show oldest first
        final url = '${ApiEndpoints.restApiBaseFull}/chat_messages'
            '?chat_id=eq.$chatId'
            '&select=*'
            '&order=created_at.asc';
        
        final response = await apiClient.get(url);
        
        // REST API returns array directly
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          return data.map((json) => ChatMessageModel.fromJson(json)).toList();
        }
        
        return [];
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
    // Get current user ID from auth storage
    final authStorage = AuthStorage.instance;
    final userId = await authStorage.getUserId() ?? ChatMockData.currentUserId;
    final senderName = 'Technician'; // Default name, should come from user profile
    final orgId = 'org_1'; // Default orgId for optimistic update - backend will provide correct value
    
    final newMessage = ChatMessageModel(
      id: generateId(),
      orgId: orgId, // PRD: required for multi-tenancy
      chatId: chatId,
      senderId: userId,
      senderName: senderName,
      messageBody: messageBody,
      createdAt: DateTime.now(),
    );

    return await mutate<ChatMessageModel>(
      cacheKey: 'chat_messages_$chatId',
      apiCall: () async {
        // Use REST API directly to insert message
        final url = '${ApiEndpoints.restApiBaseFull}/chat_messages';
        
        final response = await apiClient.post(
          url,
          data: {
            'chat_id': chatId,
            'sender_id': userId,
            'sender_name': senderName,
            'message_body': messageBody,
            'org_id': orgId,
          },
        );
        
        // REST API returns array with single item on insert
        if (response.data is List && (response.data as List).isNotEmpty) {
          return ChatMessageModel.fromJson(response.data[0] as Map<String, dynamic>);
        }
        return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
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
    // Get current user ID from auth storage
    final authStorage = AuthStorage.instance;
    final userId = await authStorage.getUserId() ?? ChatMockData.currentUserId;
    final userName = 'Technician'; // Default name, should come from user profile
    final orgId = 'org_1'; // Default orgId for optimistic update - backend will provide correct value
    final now = DateTime.now();
    
    final newThread = ChatThreadModel(
      id: generateId(),
      orgId: orgId, // PRD: required for multi-tenancy
      type: ChatType.direct,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
      participants: [
        ChatParticipantModel(
          id: generateId(),
          orgId: orgId, // PRD: required for multi-tenancy
          chatId: 'chat-new',
          userId: userId,
          userName: userName,
          roleInChat: ChatParticipantRole.member,
          joinedAt: now,
          createdAt: now,
        ),
        ChatParticipantModel(
          id: generateId(),
          orgId: orgId, // PRD: required for multi-tenancy
          chatId: 'chat-new',
          userId: otherUserId,
          userName: otherUserName,
          roleInChat: ChatParticipantRole.member,
          joinedAt: now,
          createdAt: now,
        ),
      ],
      unreadCount: 0,
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
        // Use REST API with simple client-side filtering
        // For full-text search, we'd need to fetch all threads and filter locally
        // or use PostgREST's text search operators
        final url = '${ApiEndpoints.restApiBaseFull}/chat_threads?select=*&order=updated_at.desc';
        
        final response = await apiClient.get(url);
        
        // REST API returns array - filter client-side for simplicity
        if (response.data is List) {
          final List<dynamic> data = response.data as List;
          final threads = data.map((json) => ChatThreadModel.fromJson(json)).toList();
          
          // Simple client-side search filter
          return threads.where((thread) {
            final displayName = thread.getDisplayName('').toLowerCase();
            final lastMessage = thread.lastMessage?.messageBody.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();
            return displayName.contains(queryLower) || lastMessage.contains(queryLower);
          }).toList();
        }
        
        return [];
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

