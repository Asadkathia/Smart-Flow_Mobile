/// Custom exceptions for SmartFlowPro
/// 
/// These exceptions provide structured error handling throughout the app.

/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory NetworkException.noConnection() => const NetworkException(
    message: 'No internet connection. Please check your network.',
    code: 'NO_CONNECTION',
  );

  factory NetworkException.timeout() => const NetworkException(
    message: 'Request timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkException.serverError([String? details]) => NetworkException(
    message: details ?? 'Server error occurred. Please try again later.',
    code: 'SERVER_ERROR',
  );

  factory NetworkException.unknown([dynamic error]) => NetworkException(
    message: 'An unexpected network error occurred.',
    code: 'UNKNOWN',
    originalError: error,
  );
}

/// API-related exceptions
class ApiException extends AppException {
  final int? statusCode;

  const ApiException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });

  factory ApiException.badRequest([String? details]) => ApiException(
    message: details ?? 'Invalid request. Please check your input.',
    code: 'BAD_REQUEST',
    statusCode: 400,
  );

  factory ApiException.unauthorized() => const ApiException(
    message: 'Session expired. Please login again.',
    code: 'UNAUTHORIZED',
    statusCode: 401,
  );

  factory ApiException.forbidden() => const ApiException(
    message: 'You do not have permission to perform this action.',
    code: 'FORBIDDEN',
    statusCode: 403,
  );

  factory ApiException.notFound([String? resource]) => ApiException(
    message: resource != null ? '$resource not found.' : 'Resource not found.',
    code: 'NOT_FOUND',
    statusCode: 404,
  );

  factory ApiException.conflict([String? details]) => ApiException(
    message: details ?? 'A conflict occurred. Please refresh and try again.',
    code: 'CONFLICT',
    statusCode: 409,
  );

  factory ApiException.serverError([String? details]) => ApiException(
    message: details ?? 'Server error occurred. Please try again later.',
    code: 'SERVER_ERROR',
    statusCode: 500,
  );

  factory ApiException.unprocessableEntity([String? details, Map<String, String>? fieldErrors]) => ApiException(
    message: details ?? 'Validation error. Please check your input.',
    code: 'UNPROCESSABLE_ENTITY',
    statusCode: 422,
  );

  factory ApiException.rateLimitExceeded([String? retryAfter]) => ApiException(
    message: retryAfter != null 
        ? 'Rate limit exceeded. Please retry after $retryAfter seconds.'
        : 'Rate limit exceeded. Please try again later.',
    code: 'RATE_LIMIT_EXCEEDED',
    statusCode: 429,
  );

  factory ApiException.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ApiException.badRequest(message);
      case 401:
        return ApiException.unauthorized();
      case 403:
        return ApiException.forbidden();
      case 404:
        return ApiException.notFound(message);
      case 409:
        return ApiException.conflict(message);
      case 422:
        return ApiException.unprocessableEntity(message);
      case 429:
        return ApiException.rateLimitExceeded();
      case >= 500:
        return ApiException.serverError(message);
      default:
        return ApiException(
          message: message ?? 'An error occurred.',
          code: 'HTTP_$statusCode',
          statusCode: statusCode,
        );
    }
  }
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory AuthException.invalidCredentials() => const AuthException(
    message: 'Invalid email or password.',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthException.userNotFound() => const AuthException(
    message: 'No account found with this email.',
    code: 'USER_NOT_FOUND',
  );

  factory AuthException.emailAlreadyExists() => const AuthException(
    message: 'An account with this email already exists.',
    code: 'EMAIL_EXISTS',
  );

  factory AuthException.weakPassword() => const AuthException(
    message: 'Password is too weak. Please use a stronger password.',
    code: 'WEAK_PASSWORD',
  );

  factory AuthException.invalidOtp() => const AuthException(
    message: 'Invalid or expired verification code.',
    code: 'INVALID_OTP',
  );

  factory AuthException.sessionExpired() => const AuthException(
    message: 'Your session has expired. Please login again.',
    code: 'SESSION_EXPIRED',
  );
}

/// Validation-related exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
  });

  factory ValidationException.required(String field) => ValidationException(
    message: '$field is required.',
    code: 'REQUIRED',
    fieldErrors: {field: '$field is required.'},
  );

  factory ValidationException.invalid(String field, [String? details]) => ValidationException(
    message: details ?? 'Invalid $field.',
    code: 'INVALID',
    fieldErrors: {field: details ?? 'Invalid $field.'},
  );

  factory ValidationException.multiple(Map<String, String> errors) => ValidationException(
    message: 'Please fix the errors below.',
    code: 'MULTIPLE_ERRORS',
    fieldErrors: errors,
  );

  /// Unprocessable Entity (422) - Validation error per PRD Section 18
  factory ValidationException.unprocessableEntity(String message, [Map<String, String>? fieldErrors]) => ValidationException(
    message: message,
    code: 'UNPROCESSABLE_ENTITY',
    fieldErrors: fieldErrors,
  );

  /// Quote finalization error - Quote must have at least one line item (PRD Section 18)
  factory ValidationException.quoteFinalizationError() => ValidationException(
    message: 'Quote must have at least one line item before finalization.',
    code: 'QUOTE_FINALIZATION_ERROR',
  );

  /// Payment amount error - Payment amount must be greater than zero (PRD Section 18)
  factory ValidationException.paymentAmountError() => ValidationException(
    message: 'Payment amount must be greater than zero.',
    code: 'PAYMENT_AMOUNT_ERROR',
  );

  /// Payment exceeds balance error (PRD Section 18)
  factory ValidationException.paymentExceedsBalanceError(double remainingBalance) => ValidationException(
    message: 'Payment amount exceeds remaining invoice balance of \$${remainingBalance.toStringAsFixed(2)}.',
    code: 'PAYMENT_EXCEEDS_BALANCE',
  );

  /// Signature required error (PRD Section 18)
  factory ValidationException.signatureRequiredError() => ValidationException(
    message: 'Signature required for visit completion.',
    code: 'SIGNATURE_REQUIRED',
  );

  /// Service call fee locked error (PRD Section 18)
  factory ValidationException.serviceCallFeeLockedError() => ValidationException(
    message: 'Service call fee line item cannot be deleted.',
    code: 'SERVICE_CALL_FEE_LOCKED',
  );
}

/// Conflict-related exceptions (for optimistic locking)
class ConflictException extends AppException {
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? localData;
  final Map<String, dynamic>? serverData;

  const ConflictException({
    required super.message,
    super.code,
    super.originalError,
    this.entityType,
    this.entityId,
    this.localData,
    this.serverData,
  });

  factory ConflictException.versionConflict({
    required String entityType,
    required String entityId,
    Map<String, dynamic>? localData,
    Map<String, dynamic>? serverData,
  }) => ConflictException(
    message: 'A conflict was detected. The data has been modified by another user. Please refresh and try again.',
    code: 'VERSION_CONFLICT',
    entityType: entityType,
    entityId: entityId,
    localData: localData,
    serverData: serverData,
  );

  factory ConflictException.stateTransitionConflict(String currentState, String attemptedState) => ConflictException(
    message: 'Invalid state transition from $currentState to $attemptedState.',
    code: 'STATE_TRANSITION_CONFLICT',
  );
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory CacheException.notFound([String? key]) => CacheException(
    message: key != null ? 'Cache for $key not found.' : 'Cache not found.',
    code: 'NOT_FOUND',
  );

  factory CacheException.expired([String? key]) => CacheException(
    message: key != null ? 'Cache for $key has expired.' : 'Cache has expired.',
    code: 'EXPIRED',
  );

  factory CacheException.writeError([String? details]) => CacheException(
    message: details ?? 'Failed to write to cache.',
    code: 'WRITE_ERROR',
  );
}

/// Offline-related exceptions
class OfflineException extends AppException {
  const OfflineException({
    required super.message,
    super.code,
    super.originalError,
  });

  factory OfflineException.queueFull() => const OfflineException(
    message: 'Offline queue is full. Please sync when online.',
    code: 'QUEUE_FULL',
  );

  factory OfflineException.syncFailed([String? details]) => OfflineException(
    message: details ?? 'Failed to sync offline data.',
    code: 'SYNC_FAILED',
  );
}


