/// App Exceptions
/// 
/// Custom exception classes for handling different error scenarios.
/// These exceptions are thrown by network and data layers.

import 'package:flutter/material.dart';

/// Base exception class for all app exceptions
class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._prefix, this._message]);

  @override
  String toString() {
    return '$_prefix: $_message';
  }

  String get message => _message ?? 'Unknown error';
  String get prefix => _prefix ?? 'Error';
}

/// Exception thrown when there is no internet connectivity
class InternetException extends AppExceptions {
  InternetException([String? message]) : super('No internet', message);
  
  /// Note: Navigation to NoInternet screen should be handled by the caller
  /// using GoRouter context navigation
}

/// Exception thrown when a request times out
class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? message]) : super('Request TimeOut', message);
}

/// Exception thrown when the server returns an error
class ServerException extends AppExceptions {
  ServerException([String? message]) : super('Internal server error', message);
}

/// Exception thrown when the URL is invalid
class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? message]) : super('Invalid Url', message);
}

/// Exception thrown when data fetching fails
class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super('Fetch Error', message);
}

/// Exception thrown when authentication fails
class AuthException extends AppExceptions {
  AuthException([String? message]) : super('Authentication Error', message);
}

/// Exception thrown when authorization fails
class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message]) : super('Unauthorized', message);
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppExceptions {
  NotFoundException([String? message]) : super('Not Found', message);
}

/// Exception thrown when validation fails
class ValidationException extends AppExceptions {
  final Map<String, List<String>>? errors;
  
  ValidationException([String? message, this.errors]) : super('Validation Error', message);
}
