import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/config/supabase_config.dart';
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
        'apikey': SupabaseConfig.supabaseAnonKey, // Supabase requires apikey header
      },
    ),
  );

  // Add auth interceptor (pass Dio instance for retry reuse)
  dio.interceptors.add(ApiInterceptor(ref, dio));

  // Add logging in debug mode
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  return dio;
});

/// API Client for SmartFlowPro
/// 
/// Provides type-safe API methods for all endpoints.
/// Uses Dio for HTTP requests with automatic error handling.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // ============ Generic Request Methods ============

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
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
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
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
      options: Options(
        contentType: 'multipart/form-data',
      ),
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

    final formData = FormData.fromMap({
      fieldName: files,
      ...?additionalData,
    });

    return _dio.post<T>(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }
}

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});


