import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/logger.dart';

/// Supabase Functions Client
/// 
/// Uses Supabase Flutter client's functions.invoke() method which properly
/// handles JWT authentication for Edge Functions. This bypasses the relay
/// layer's JWT validation issues with ES256 tokens.
class SupabaseFunctionsClient {
  SupabaseFunctionsClient._();
  
  static final instance = SupabaseFunctionsClient._();
  
  SupabaseClient get _client => Supabase.instance.client;
  
  /// Invoke a Supabase Edge Function
  /// 
  /// [functionName] - The name of the Edge Function (e.g., 'tech-visits-today')
  /// [body] - Optional request body (for POST requests)
  /// [queryParams] - Optional query parameters (appended to URL)
  /// [method] - HTTP method (GET, POST, etc.) - Note: invoke() uses POST by default
  /// 
  /// Returns the response data or throws an exception on error.
  Future<dynamic> invoke(
    String functionName, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    HttpMethod method = HttpMethod.post,
    Map<String, String>? headers,
  }) async {
    try {
      Logger.debug('Invoking Edge Function: $functionName');
      
      final response = await _client.functions.invoke(
        functionName,
        body: body,
        headers: {
          'X-Channel': 'mobile_technician',
          ...?headers,
        },
        method: method,
        queryParameters: queryParams,
      );
      
      Logger.debug('Edge Function response status: ${response.status}');
      
      // Check for error status codes
      if (response.status >= 400) {
        final errorData = response.data;
        String errorMessage = 'Edge Function error';
        String errorCode = 'UNKNOWN';
        
        if (errorData is Map) {
          // Handle our error format: {error: {code, message}}
          final error = errorData['error'];
          if (error is Map) {
            errorCode = error['code']?.toString() ?? 'UNKNOWN';
            errorMessage = error['message']?.toString() ?? 'Unknown error';
          } else {
            // Handle relay format: {code, message}
            errorCode = errorData['code']?.toString() ?? 'UNKNOWN';
            errorMessage = errorData['message']?.toString() ?? 'Unknown error';
          }
        }
        
        Logger.error('Edge Function error: [$errorCode] $errorMessage');
        throw EdgeFunctionException(
          code: errorCode,
          message: errorMessage,
          statusCode: response.status,
        );
      }
      
      // Return data from response
      // Handle our format: {data: ..., meta: ...}
      if (response.data is Map && response.data['data'] != null) {
        return response.data['data'];
      }
      
      return response.data;
    } catch (e) {
      if (e is EdgeFunctionException) rethrow;
      
      Logger.error('Edge Function invoke error: $functionName', e);
      throw EdgeFunctionException(
        code: 'INVOKE_ERROR',
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
  
  /// GET request to Edge Function
  Future<dynamic> get(
    String functionName, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    return invoke(
      functionName,
      method: HttpMethod.get,
      queryParams: queryParams,
      headers: headers,
    );
  }
  
  /// POST request to Edge Function
  Future<dynamic> post(
    String functionName, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return invoke(
      functionName,
      body: body,
      method: HttpMethod.post,
      headers: headers,
    );
  }
}

/// Exception for Edge Function errors
class EdgeFunctionException implements Exception {
  final String code;
  final String message;
  final int statusCode;
  
  EdgeFunctionException({
    required this.code,
    required this.message,
    required this.statusCode,
  });
  
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;
  
  @override
  String toString() => 'EdgeFunctionException: [$code] $message (status: $statusCode)';
}
