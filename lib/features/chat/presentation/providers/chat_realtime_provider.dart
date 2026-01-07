import 'package:flutter_riverpod/flutter_riverpod.dart';

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
/// This will be connected to real-time updates in Phase 2.
final chatTypingProvider = StateNotifierProvider.family<
    ChatTypingNotifier, TypingState, String>((ref, chatId) {
  return ChatTypingNotifier(chatId);
});

/// Chat Typing Notifier
/// 
/// Manages typing state for a specific chat thread.
/// 
/// Phase 2: Will connect to Supabase Realtime channel `chat:{chat_id}`.
class ChatTypingNotifier extends StateNotifier<TypingState> {
  final String chatId;
  bool _isConnected = false;

  ChatTypingNotifier(this.chatId) : super(const TypingState()) {
    // TODO (Phase 2): Connect to Supabase Realtime channel
    // Channel: chat:{chatId}
    // Events: typing_start, typing_stop
  }

  /// Connect to real-time channel
  /// 
  /// Phase 2: Implement Supabase Realtime subscription
  /// Connection timeout: 30 seconds per PRD
  Future<void> connect() async {
    if (_isConnected) return;
    
    // TODO (Phase 2): Connect to Supabase Realtime channel
    // Example: supabase.channel('chat:$chatId').on('broadcast', {event: 'typing'}, ...)
    // Timeout: 30 seconds per PRD
    
    _isConnected = true;
  }

  /// Disconnect from real-time channel
  Future<void> disconnect() async {
    if (!_isConnected) return;
    
    // TODO (Phase 2): Disconnect from Supabase Realtime channel
    
    _isConnected = false;
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
/// Manages real-time connection state for chat.
/// This will be implemented in Phase 2 with Supabase Realtime.
final chatRealtimeConnectionProvider = StateProvider<bool>((ref) {
  // TODO (Phase 2): Connect to Supabase Realtime
  // For now, return false (not connected)
  return false;
});

