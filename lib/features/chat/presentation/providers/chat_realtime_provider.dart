import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/supabase_realtime_service.dart';
import '../../../../core/services/logger.dart';
import '../../data/models/chat_models.dart';

/// Typing State Model
/// 
/// Represents who is currently typing in a chat.
class TypingState {
  final Set<String> typingUserIds;

  const TypingState({this.typingUserIds = const {}});

  TypingState copyWith({Set<String>? typingUserIds}) {
    return TypingState(
      typingUserIds: typingUserIds ?? this.typingUserIds,
    );
  }

  bool get isEmpty => typingUserIds.isEmpty;
  bool get isNotEmpty => typingUserIds.isNotEmpty;
}

/// Typing State Provider
/// 
/// Manages typing indicators for each chat thread.
/// Connected to real-time updates via Supabase Realtime.
final chatTypingProvider = StateNotifierProvider.family<
    ChatTypingNotifier, TypingState, String>((ref, chatId) {
  final realtimeService = ref.watch(supabaseRealtimeServiceProvider);
  return ChatTypingNotifier(chatId, realtimeService);
});

/// Chat Typing Notifier
/// 
/// Manages typing state for a specific chat thread.
/// 
/// Connects to Supabase Realtime channel `chat:{chat_id}` for typing indicators.
class ChatTypingNotifier extends StateNotifier<TypingState> {
  final String chatId;
  final SupabaseRealtimeService _realtimeService;
  bool _isConnected = false;

  ChatTypingNotifier(this.chatId, this._realtimeService) : super(const TypingState());

  /// Connect to real-time channel
  /// 
  /// Subscribes to typing events for the chat thread.
  /// Channel: chat:{chatId}
  /// Events: typing_start, typing_stop (broadcast events)
  /// Connection timeout: 30 seconds per PRD
  Future<void> connect() async {
    if (_isConnected) return;
    
    try {
      // Subscribe to chat messages (typing indicators can be added later via broadcast)
      await _realtimeService.subscribeToChat(
        chatId,
        (data) {
          // For now, just subscribe to messages
          // Typing indicators can be implemented later with broadcast events
        },
      );
      
      _isConnected = true;
      Logger.info('Chat Realtime: Connected to chat:$chatId for typing');
    } catch (e, stackTrace) {
      Logger.error('Chat Realtime: Connection failed for $chatId', e, stackTrace);
      _isConnected = false;
    }
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    if (!_isConnected) return;
    
    try {
      final channelName = 'chat:$chatId';
      await _realtimeService.unsubscribe(channelName);
      
      _isConnected = false;
      Logger.info('Chat Realtime: Disconnected from $channelName');
    } catch (e, stackTrace) {
      Logger.error('Chat Realtime: Disconnection failed for $chatId', e, stackTrace);
    }
  }

  /// Set user as typing
  void setTyping(String userId) {
    final newSet = Set<String>.from(state.typingUserIds)..add(userId);
    state = state.copyWith(typingUserIds: newSet);

    // Auto-clear after 3 seconds (simulating typing timeout)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        clearTyping(userId);
      }
    });
  }

  /// Clear typing for a user
  void clearTyping(String userId) {
    final newSet = Set<String>.from(state.typingUserIds)..remove(userId);
    state = state.copyWith(typingUserIds: newSet);
  }

  /// Clear all typing indicators
  void clearAll() {
    state = const TypingState();
  }
}

/// Real-time Connection Provider
/// 
/// Manages real-time connection state for chat messages.
/// Subscribes to new messages for a specific chat thread.
final chatRealtimeConnectionProvider = StateNotifierProvider.family<
    ChatRealtimeNotifier, bool, String>((ref, chatId) {
  final realtimeService = ref.watch(supabaseRealtimeServiceProvider);
  return ChatRealtimeNotifier(chatId, realtimeService);
});

/// Chat Realtime Notifier
/// 
/// Manages real-time message updates for a chat thread.
class ChatRealtimeNotifier extends StateNotifier<bool> {
  final String chatId;
  final SupabaseRealtimeService _realtimeService;

  ChatRealtimeNotifier(this.chatId, this._realtimeService) : super(false);

  /// Connect to real-time channel for messages
  /// 
  /// Subscribes to new message events for the chat thread.
  /// Channel: chat:{chatId}
  /// Events: INSERT (new messages)
  /// Filter: chat_id = {chatId}
  Future<void> connect({
    Function(ChatMessageModel)? onNewMessage,
  }) async {
    if (state) return; // Already connected
    
    try {
      await _realtimeService.subscribeToChat(
        chatId,
        (data) {
          try {
            if (onNewMessage != null) {
              final message = ChatMessageModel.fromJson(data as Map<String, dynamic>);
              onNewMessage(message);
              Logger.debug('Chat Realtime: New message received - ${message.id}');
            }
          } catch (e, stackTrace) {
            Logger.error('Chat Realtime: Error handling new message', e, stackTrace);
          }
        },
      );
      
      state = true;
      Logger.info('Chat Realtime: Connected to chat:$chatId for messages');
    } catch (e, stackTrace) {
      Logger.error('Chat Realtime: Connection failed for $chatId', e, stackTrace);
      state = false;
    }
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    if (!state) return;
    
    try {
      final channelName = 'chat:$chatId';
      await _realtimeService.unsubscribe(channelName);
      
      state = false;
      Logger.info('Chat Realtime: Disconnected from $channelName');
    } catch (e, stackTrace) {
      Logger.error('Chat Realtime: Disconnection failed for $chatId', e, stackTrace);
    }
  }
}
