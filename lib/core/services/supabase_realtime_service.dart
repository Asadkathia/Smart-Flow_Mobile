// Supabase Realtime Service
// Manages WebSocket subscriptions for real-time updates

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/logger.dart';

/// Supabase Realtime Service
/// 
/// Handles real-time subscriptions for:
/// - Visit updates (visits:{org_id})
/// - Chat messages (chat:{chat_id})
/// - Quote updates (quotes:{visit_id})
class SupabaseRealtimeService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _channels = {};

  /// Subscribe to visit updates for an organization
  /// 
  /// Listens to all visit changes (status updates, assignments, etc.)
  /// for visits in the user's organization.
  Future<void> subscribeToVisits(
    String orgId,
    Function(Map<String, dynamic>) onUpdate,
  ) async {
    try {
      final channelName = 'visits:$orgId';
      
      // Unsubscribe if already subscribed
      if (_channels.containsKey(channelName)) {
        await unsubscribe(channelName);
      }

      final channel = _supabase.channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'visits',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'org_id',
            value: orgId,
          ),
          callback: (payload) {
            Logger.debug('Visit update received: ${payload.eventType}');
            if (payload.newRecord != null) {
              onUpdate(payload.newRecord);
            }
          },
        )
        .subscribe();

      _channels[channelName] = channel;
      Logger.info('Subscribed to visit updates for org: $orgId');
    } catch (e, stackTrace) {
      Logger.error('Failed to subscribe to visits', e, stackTrace);
      rethrow;
    }
  }

  /// Subscribe to chat messages for a specific chat thread
  /// 
  /// Listens to new messages in a chat thread.
  Future<void> subscribeToChat(
    String chatId,
    Function(Map<String, dynamic>) onMessage,
  ) async {
    try {
      final channelName = 'chat:$chatId';
      
      // Unsubscribe if already subscribed
      if (_channels.containsKey(channelName)) {
        await unsubscribe(channelName);
      }

      final channel = _supabase.channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) {
            Logger.debug('Chat message received: ${payload.eventType}');
            if (payload.newRecord != null) {
              onMessage(payload.newRecord);
            }
          },
        )
        .subscribe();

      _channels[channelName] = channel;
      Logger.info('Subscribed to chat messages for chat: $chatId');
    } catch (e, stackTrace) {
      Logger.error('Failed to subscribe to chat', e, stackTrace);
      rethrow;
    }
  }

  /// Subscribe to quote updates for a visit
  /// 
  /// Listens to quote changes (create, update, finalize) for a specific visit.
  Future<void> subscribeToQuotes(
    String visitId,
    Function(Map<String, dynamic>) onUpdate,
  ) async {
    try {
      final channelName = 'quotes:$visitId';
      
      // Unsubscribe if already subscribed
      if (_channels.containsKey(channelName)) {
        await unsubscribe(channelName);
      }

      final channel = _supabase.channel(channelName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'quotes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'visit_id',
            value: visitId,
          ),
          callback: (payload) {
            Logger.debug('Quote update received: ${payload.eventType}');
            if (payload.newRecord != null) {
              onUpdate(payload.newRecord);
            }
          },
        )
        .subscribe();

      _channels[channelName] = channel;
      Logger.info('Subscribed to quote updates for visit: $visitId');
    } catch (e, stackTrace) {
      Logger.error('Failed to subscribe to quotes', e, stackTrace);
      rethrow;
    }
  }

  /// Unsubscribe from a specific channel
  Future<void> unsubscribe(String channelName) async {
    try {
      final channel = _channels[channelName];
      if (channel != null) {
        await _supabase.removeChannel(channel);
        _channels.remove(channelName);
        Logger.info('Unsubscribed from channel: $channelName');
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to unsubscribe from channel: $channelName', e, stackTrace);
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    try {
      for (final channelName in _channels.keys.toList()) {
        await unsubscribe(channelName);
      }
      Logger.info('Unsubscribed from all channels');
    } catch (e, stackTrace) {
      Logger.error('Failed to unsubscribe from all channels', e, stackTrace);
    }
  }

  /// Get channel status
  bool isSubscribed(String channelName) {
    return _channels.containsKey(channelName);
  }

  /// Get all subscribed channel names
  List<String> getSubscribedChannels() {
    return _channels.keys.toList();
  }
}

/// Supabase Realtime Service Provider
final supabaseRealtimeServiceProvider = Provider<SupabaseRealtimeService>((ref) {
  return SupabaseRealtimeService();
});
