import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Lightweight logging wrapper for SmartFlowPro
/// 
/// Provides consistent logging across the app with different log levels.
/// In debug mode, logs to console. In release mode, sends logs to Sentry.
/// 
/// PRD Section 24: Centralized logging and error monitoring (Sentry).
class Logger {
  Logger._();
  
  static const String _tag = '[SmartFlowPro]';
  static bool _isInitialized = false;

  /// Initialize Sentry for production error tracking
  /// 
  /// Call this in main.dart before runApp()
  static Future<void> initialize({
    required String dsn,
    String? environment,
  }) async {
    if (dsn.isEmpty) {
      debugPrint('$_tag [LOGGER] Sentry DSN not configured, skipping initialization');
      return;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = environment ?? (kDebugMode ? 'development' : 'production');
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.2; // 20% of transactions in production
        options.attachStacktrace = true;
        options.beforeSend = (event, hint) {
          // Don't send events in debug mode
          if (kDebugMode) return null;
          return event;
        };
      },
    );
    _isInitialized = true;
    debugPrint('$_tag [LOGGER] Sentry initialized');
  }

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
    // Add breadcrumb for Sentry context
    if (_isInitialized && !kDebugMode) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message,
        category: 'info',
        level: SentryLevel.info,
      ));
    }
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
    // Add breadcrumb for Sentry context
    if (_isInitialized && !kDebugMode) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message,
        category: 'warning',
        level: SentryLevel.warning,
        data: error != null ? {'error': error.toString()} : null,
      ));
    }
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
    // Send to Sentry in production
    if (_isInitialized && !kDebugMode && error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('log_message', message);
        },
      );
    }
  }

  /// Capture a fatal error (app crashes)
  static void fatal(String message, Object error, StackTrace stackTrace) {
    debugPrint('$_tag [FATAL] $message');
    debugPrint('$_tag [FATAL] Error: $error');
    debugPrint('$_tag [FATAL] StackTrace: $stackTrace');
    
    if (_isInitialized && !kDebugMode) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.level = SentryLevel.fatal;
          scope.setTag('log_message', message);
        },
      );
    }
  }

  /// Set user context for Sentry
  static void setUser({
    required String id,
    String? email,
    String? username,
    Map<String, String>? extras,
  }) {
    if (_isInitialized) {
      Sentry.configureScope((scope) {
        scope.setUser(SentryUser(
          id: id,
          email: email,
          username: username,
          data: extras,
        ));
      });
    }
  }

  /// Clear user context
  static void clearUser() {
    if (_isInitialized) {
      Sentry.configureScope((scope) {
        scope.setUser(null);
      });
    }
  }

  /// Log network requests (for API calls)
  static void network(String method, String url, [Map<String, dynamic>? headers]) {
    if (kDebugMode) {
      debugPrint('$_tag [NETWORK] $method $url');
      if (headers != null && headers.isNotEmpty) {
        debugPrint('$_tag [NETWORK] Headers: $headers');
      }
    }
    // Add HTTP breadcrumb
    if (_isInitialized && !kDebugMode) {
      Sentry.addBreadcrumb(Breadcrumb(
        type: 'http',
        category: 'http',
        message: '$method $url',
        level: SentryLevel.info,
      ));
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
    // Add HTTP response breadcrumb
    if (_isInitialized && !kDebugMode) {
      Sentry.addBreadcrumb(Breadcrumb(
        type: 'http',
        category: 'http.response',
        message: '$method $url -> $statusCode',
        level: statusCode >= 400 ? SentryLevel.error : SentryLevel.info,
        data: {'status_code': statusCode},
      ));
    }
  }
}
