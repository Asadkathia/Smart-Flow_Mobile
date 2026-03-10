import 'dart:io';
import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Error Handler for SmartFlowPro
///
/// Centralizes error handling and converts various error types
/// to appropriate AppException subclasses.
class ErrorHandler {
  ErrorHandler._();

  /// Handle any error and convert to AppException
  static AppException handle(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return NetworkException.noConnection();
    }

    if (error is FormatException) {
      return ApiException.badRequest('Invalid response format.');
    }

    return NetworkException.unknown(error);
  }

  /// Handle Dio-specific errors
  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();

      case DioExceptionType.connectionError:
        return NetworkException.noConnection();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Invalid security certificate.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException.noConnection();
        }
        return NetworkException.unknown(error);
    }
  }

  /// Handle bad HTTP responses
  static AppException _handleBadResponse(Response? response) {
    if (response == null) {
      return NetworkException.serverError();
    }

    final statusCode = response.statusCode ?? 500;
    String? message;
    Map<String, String>? fieldErrors;

    // Try to extract error message and field errors from response
    try {
      final data = response.data;
      if (data is Map) {
        message =
            data['message'] as String? ??
            data['error'] as String? ??
            data['error_description'] as String?;

        // Extract field-specific errors (for 422 validation errors)
        if (data['errors'] is Map) {
          fieldErrors = Map<String, String>.from(
            (data['errors'] as Map).map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          );
        } else if (data['field_errors'] is Map) {
          fieldErrors = Map<String, String>.from(
            (data['field_errors'] as Map).map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          );
        }
      }
    } catch (_) {
      // Ignore parsing errors
    }

    // Handle 422 with field errors
    if (statusCode == 422 && fieldErrors != null) {
      return ValidationException.multiple(fieldErrors);
    }

    // Handle 409 conflicts with version information
    if (statusCode == 409) {
      try {
        final data = response.data;
        if (data is Map && data['conflict_type'] == 'version') {
          return ConflictException.versionConflict(
            entityType: data['entity_type'] as String? ?? 'unknown',
            entityId: data['entity_id'] as String? ?? 'unknown',
            localData: data['local_data'] as Map<String, dynamic>?,
            serverData: data['server_data'] as Map<String, dynamic>?,
          );
        }
      } catch (_) {
        // Fall through to default conflict handling
      }
    }

    // Handle 403 with role/channel context
    if (statusCode == 403) {
      try {
        final data = response.data;
        if (data is Map) {
          final role = data['required_role'] as String?;
          final channel = data['required_channel'] as String?;
          if (role != null || channel != null) {
            final context = [
              if (role != null) 'Required role: $role',
              if (channel != null) 'Required channel: $channel',
            ].join(', ');
            return ApiException(
              message: message ?? 'Access denied. $context',
              code: 'FORBIDDEN',
              statusCode: 403,
            );
          }
        }
      } catch (_) {
        // Fall through to default forbidden handling
      }
    }

    return ApiException.fromStatusCode(statusCode, message);
  }

  /// Get user-friendly error message
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is DioException) {
      return handle(error).message;
    }

    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }

    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle any error and return user-friendly message (for sync processor)
  /// This is a convenience method that returns a string instead of an exception
  static String handleToString(dynamic error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is DioException) {
      return _handleDioErrorString(error);
    }

    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }

    return 'An unexpected error occurred. Please try again.';
  }

  static String _handleDioErrorString(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        return _handleResponseErrorString(error.response);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      default:
        return 'Network error. Please try again.';
    }
  }

  static String _handleResponseErrorString(Response? response) {
    if (response == null) return 'Server error. Please try again.';

    switch (response.statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Session expired. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict detected. Please refresh and try again.';
      case 422:
        final message = response.data?['message'] ?? response.data?['error'];
        return message ?? 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please wait a moment.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Error ${response.statusCode}. Please try again.';
    }
  }

  /// Get retry delay based on error
  static Duration getRetryDelay(dynamic error, int retryCount) {
    if (error is DioException &&
        error.type == DioExceptionType.connectionError) {
      // Exponential backoff for connection errors
      return Duration(seconds: (2 * retryCount).clamp(2, 30));
    }
    return const Duration(seconds: 2);
  }

  /// Check if error is a network error
  static bool isNetworkError(dynamic error) {
    if (error is NetworkException) return true;
    if (error is SocketException) return true;
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout;
    }
    return false;
  }

  /// Check if error requires re-authentication
  static bool requiresReAuth(dynamic error) {
    if (error is ApiException) {
      return error.statusCode == 401;
    }
    if (error is AuthException) {
      return error.code == 'SESSION_EXPIRED' || error.code == 'UNAUTHORIZED';
    }
    if (error is DioException && error.response?.statusCode == 401) {
      return true;
    }
    return false;
  }
}
