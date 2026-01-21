import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartflowpro/core/services/logger.dart';
import 'package:flutter/foundation.dart';

/// Push Notification Service
/// 
/// Handles Firebase Cloud Messaging (FCM) for push notifications.
/// PRD Section 19: Appointment reminders, status change alerts, etc.
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  bool _isInitialized = false;
  String? _fcmToken;

  /// Initialize push notifications
  /// 
  /// Call this in main.dart after Firebase.initializeApp()
  Future<void> initialize() async {
    if (_isInitialized) {
      Logger.debug('Push notifications already initialized');
      return;
    }

    try {
      // Request permission (iOS)
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Logger.info('User granted notification permissions');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        Logger.info('User granted provisional notification permissions');
      } else {
        Logger.warning('User declined notification permissions');
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _fcm.getToken();
      Logger.info('FCM Token: $_fcmToken');

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        Logger.info('FCM Token refreshed: $newToken');
        // TODO: Send new token to backend
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages (iOS/Android)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Handle notification tap when app is terminated
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      _isInitialized = true;
      Logger.info('Push notifications initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to initialize push notifications', e, stackTrace);
    }
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle foreground messages (show local notification)
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    Logger.info('Received foreground message: ${message.messageId}');
    
    final notification = message.notification;
    if (notification == null) return;

    // Show local notification
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  /// Handle message opened from notification tap
  void _handleMessageOpenedApp(RemoteMessage message) {
    Logger.info('Notification tapped: ${message.messageId}');
    
    // Navigate based on notification data
    final data = message.data;
    if (data.containsKey('visit_id')) {
      // TODO: Navigate to visit details
      Logger.info('Navigate to visit: ${data['visit_id']}');
    } else if (data.containsKey('quote_id')) {
      // TODO: Navigate to quote details
      Logger.info('Navigate to quote: ${data['quote_id']}');
    } else if (data.containsKey('route')) {
      // TODO: Navigate to specified route
      Logger.info('Navigate to route: ${data['route']}');
    }
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    Logger.info('Local notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Get current FCM token
  String? get fcmToken => _fcmToken;

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      Logger.info('Subscribed to topic: $topic');
    } catch (e) {
      Logger.error('Failed to subscribe to topic: $topic', e);
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      Logger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      Logger.error('Failed to unsubscribe from topic: $topic', e);
    }
  }

  /// Delete FCM token (on logout)
  Future<void> deleteToken() async {
    try {
      await _fcm.deleteToken();
      _fcmToken = null;
      Logger.info('FCM token deleted');
    } catch (e) {
      Logger.error('Failed to delete FCM token', e);
    }
  }
}

/// Background message handler (must be top-level function)
/// 
/// Called when app receives message in background/terminated state
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already done
  await Firebase.initializeApp();
  
  Logger.info('Background message: ${message.messageId}');
  
  // Process notification data
  if (message.data.isNotEmpty) {
    Logger.info('Message data: ${message.data}');
  }
}
