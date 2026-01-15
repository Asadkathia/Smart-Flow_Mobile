import 'package:flutter/foundation.dart';

/// Lightweight logging wrapper for SmartFlowPro
/// 
/// Provides consistent logging across the app with different log levels.
/// In debug mode, logs to console. In release mode, can be extended
/// to send logs to remote logging service (e.g., Sentry, Firebase).
class Logger {
  Logger._();
  
  static const String _tag = '[SmartFlowPro]';

  /// Log debug messages (development only)
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_tag [DEBUG] $message');
      if (error != null) {
        debugPrint('$_tag [DEBUG] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [DEBUG] StackTrace: $stackTrace');
      }
    }
  }

  /// Log info messages
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('$_tag [INFO] $message');
    }
    // TODO: In production, send to remote logging service
  }

  /// Log warning messages
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_tag [WARNING] $message');
      if (error != null) {
        debugPrint('$_tag [WARNING] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [WARNING] StackTrace: $stackTrace');
      }
    }
    // TODO: In production, send to remote logging service
  }

  /// Log error messages
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_tag [ERROR] $message');
      if (error != null) {
        debugPrint('$_tag [ERROR] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [ERROR] StackTrace: $stackTrace');
      }
    }
    // TODO: In production, send to error tracking service (e.g., Sentry)
  }

  /// Log network requests (for API calls)
  static void network(String method, String url, [Map<String, dynamic>? headers]) {
    if (kDebugMode) {
      debugPrint('$_tag [NETWORK] $method $url');
      if (headers != null && headers.isNotEmpty) {
        debugPrint('$_tag [NETWORK] Headers: $headers');
      }
    }
  }

  /// Log network responses
  static void networkResponse(String method, String url, int statusCode, [dynamic data]) {
    if (kDebugMode) {
      if (statusCode >= 200 && statusCode < 300) {
        debugPrint('$_tag [NETWORK] $method $url -> $statusCode OK');
      } else {
        debugPrint('$_tag [NETWORK] $method $url -> $statusCode ERROR');
        if (data != null) {
          debugPrint('$_tag [NETWORK] Response: $data');
        }
      }
    }
  }
}

