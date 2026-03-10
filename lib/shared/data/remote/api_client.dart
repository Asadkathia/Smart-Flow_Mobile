import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/services/logger.dart';
import 'api_interceptor.dart';

/// Dio Provider - Main HTTP client instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'apikey':
            SupabaseConfig.supabaseAnonKey, // Supabase requires apikey header
      },
    ),
  );

  // Add auth interceptor (pass Dio instance for retry reuse)
  dio.interceptors.add(ApiInterceptor(ref, dio));

  // Add minimal logging in debug mode (reduced from verbose to avoid clutter)
  // Only log errors, not full request/response details
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader:
          false, // Disabled - headers already logged by ApiInterceptor
      requestBody: false, // Disabled - too verbose
      responseBody: false, // Disabled - too verbose
      responseHeader: false,
      error: true, // Keep error logging
      compact: true,
      maxWidth: 90,
    ),
  );

  return dio;
});

/// API Client for SmartFlowPro
///
/// Provides type-safe API methods for all endpoints.
/// - Uses Supabase functions.invoke() for Edge Functions (handles ES256 JWT auth)
/// - Uses Dio for REST API and other endpoints
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// Check if path is an Edge Function call
  bool _isEdgeFunction(String path) {
    return path.contains('/functions/v1/') || path.startsWith('tech-');
  }

  /// Extract function name from path
  String _extractFunctionName(String path) {
    // Handle full URL: https://xxx.supabase.co/functions/v1/tech-visits-today
    if (path.contains('/functions/v1/')) {
      final parts = path.split('/functions/v1/');
      if (parts.length > 1) {
        // Remove any trailing query params
        return parts[1].split('?')[0];
      }
    }
    // Handle relative path: tech-visits-today
    return path.split('?')[0];
  }

  /// Convert query parameters to string map
  Map<String, String>? _toStringMap(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return null;
    return params.map((k, v) => MapEntry(k, v.toString()));
  }

  // ============ Generic Request Methods ============

  /// GET request
  /// For Edge Functions, uses Supabase functions.invoke() to handle ES256 JWT auth
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // Use Supabase functions.invoke() for Edge Functions
    if (_isEdgeFunction(path)) {
      final functionName = _extractFunctionName(path);
      Logger.debug('GET Edge Function via Supabase client: $functionName');

      try {
        final response = await Supabase.instance.client.functions
            .invoke(
              functionName,
              headers: {'X-Channel': 'mobile_technician'},
              method: HttpMethod.get,
              queryParameters: _toStringMap(queryParameters),
            )
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                Logger.error(
                  'Edge Function GET timeout: $functionName after 30 seconds',
                );
                throw TimeoutException(
                  'Edge Function request timed out',
                  const Duration(seconds: 30),
                );
              },
            );

        // Convert to Dio Response format for compatibility
        return Response<T>(
          requestOptions: RequestOptions(path: path),
          data: response.data as T,
          statusCode: response.status,
        );
      } on TimeoutException catch (e) {
        Logger.error('Edge Function GET timeout: $functionName', e);
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: e,
          type: DioExceptionType.connectionTimeout,
          message: 'Request timed out after 30 seconds',
        );
      } catch (e) {
        Logger.error('Edge Function GET error: $functionName', e);
        // Convert FunctionException to DioException for consistent error handling
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: e,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 500,
            data: {'error': e.toString()},
          ),
        );
      }
    }

    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  /// For Edge Functions, uses Supabase functions.invoke() to handle ES256 JWT auth
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // Use Supabase functions.invoke() for Edge Functions
    if (_isEdgeFunction(path)) {
      final functionName = _extractFunctionName(path);
      Logger.debug('POST Edge Function via Supabase client: $functionName');

      try {
        final response = await Supabase.instance.client.functions.invoke(
          functionName,
          body: data is Map<String, dynamic> ? data : null,
          headers: {'X-Channel': 'mobile_technician'},
          method: HttpMethod.post,
        );

        // Convert to Dio Response format for compatibility
        return Response<T>(
          requestOptions: RequestOptions(path: path),
          data: response.data as T,
          statusCode: response.status,
        );
      } catch (e) {
        Logger.error('Edge Function POST error: $functionName', e);
        // Convert FunctionException to DioException for consistent error handling
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: e,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 500,
            data: {'error': e.toString()},
          ),
        );
      }
    }

    // Add Prefer header for Supabase to return created data
    final effectiveOptions = options ?? Options();
    effectiveOptions.headers = {
      ...?effectiveOptions.headers,
      'Prefer':
          'return=representation', // Force Supabase to return created data
    };

    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: effectiveOptions,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // Add Prefer header for Supabase to return updated data
    final effectiveOptions = options ?? Options();
    effectiveOptions.headers = {
      ...?effectiveOptions.headers,
      'Prefer':
          'return=representation', // Force Supabase to return updated data
    };

    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: effectiveOptions,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Upload file with multipart
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    void Function(int, int)? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
      ...?additionalData,
    });

    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  /// Upload multiple files
  Future<Response<T>> uploadFiles<T>(
    String path, {
    required List<String> filePaths,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    void Function(int, int)? onSendProgress,
  }) async {
    final files = await Future.wait(
      filePaths.map((path) => MultipartFile.fromFile(path)),
    );

    final formData = FormData.fromMap({fieldName: files, ...?additionalData});

    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
