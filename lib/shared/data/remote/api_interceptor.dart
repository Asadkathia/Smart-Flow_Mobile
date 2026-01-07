import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/services/auth_storage.dart';
import '../../../core/services/logger.dart';
import '../../../router/app_router.dart';

/// API Interceptor for SmartFlowPro
/// 
/// Handles:
/// - Adding Supabase auth token to requests
/// - Token refresh on 401 using Supabase Auth (reuses same Dio instance)
/// - Request/Response logging
/// - Error transformation
class ApiInterceptor extends Interceptor {
  final Ref ref;
  final Dio _dio; // Reuse the same Dio instance for retries

  ApiInterceptor(this.ref, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Supabase apikey header (required for all requests)
    options.headers['apikey'] = SupabaseConfig.supabaseAnonKey;

    // Add auth token if available (Supabase JWT) - using secure storage
    final authStorage = AuthStorage.instance;
    final token = await authStorage.getAccessToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    Logger.network(options.method, options.uri.toString(), options.headers);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses
    Logger.networkResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
    );
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Logger.error(
      'API Error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.error,
      err.stackTrace,
    );
    
    if (err.response?.statusCode == 401) {
      Logger.warning('401 Unauthorized - Attempting token refresh');
      // Try to refresh token
      final refreshed = await _tryRefreshToken();
      
      if (refreshed) {
        // Retry the original request with new token using the SAME Dio instance
        try {
          final authStorage = AuthStorage.instance;
          final newToken = await authStorage.getAccessToken();
          
          if (newToken == null || newToken.isEmpty) {
            Logger.error('Token refresh succeeded but no token available');
            return handler.next(err);
          }
          
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          
          // CRITICAL: Reuse the same Dio instance instead of creating a new one
          final response = await _dio.fetch(options);
          Logger.info('Request retried successfully after token refresh');
          return handler.resolve(response);
        } catch (e, stackTrace) {
          Logger.error('Failed to retry request after token refresh', e, stackTrace);
          return handler.next(err);
        }
      } else {
        // Token refresh failed - clear auth and redirect to login
        Logger.warning('Token refresh failed - clearing auth and redirecting to login');
        await _clearAuthData();
        // Navigate to login screen using GoRouter
        final router = ref.read(routerProvider);
        router.go('/auth');
      }
    }

    return handler.next(err);
  }

  /// Attempt to refresh the auth token using Supabase Auth
  /// 
  /// Supabase Auth provides token refresh via POST /auth/v1/token?grant_type=refresh_token
  /// Uses the same Dio instance to avoid creating new connections
  Future<bool> _tryRefreshToken() async {
    try {
      final authStorage = AuthStorage.instance;
      final refreshToken = await authStorage.getRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.warning('No refresh token available');
        return false;
      }

      Logger.debug('Attempting token refresh');

      // Use the same Dio instance but with different base URL for auth endpoint
      // Create a temporary Dio instance only for auth (different base URL)
      // This is acceptable as it's a one-time auth operation
      final authDio = Dio(BaseOptions(
        baseUrl: SupabaseConfig.supabaseUrl,
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      ));

      final response = await authDio.post(
        '/auth/v1/token?grant_type=refresh_token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        
        if (newAccessToken != null) {
          await authStorage.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await authStorage.saveRefreshToken(newRefreshToken);
          }
          Logger.info('Token refresh successful');
          return true;
        }
      }

      Logger.warning('Token refresh failed: ${response.statusCode}');
      return false;
    } catch (e, stackTrace) {
      Logger.error('Token refresh exception', e, stackTrace);
      return false;
    }
  }

  /// Clear all auth data
  Future<void> _clearAuthData() async {
    final authStorage = AuthStorage.instance;
    await authStorage.clearAll();
    
    // Clear non-sensitive SharedPreferences flag if needed
    // Note: isLoggedIn is non-sensitive and can stay in SharedPreferences
    // but we clear it for consistency
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(StorageKeys.isLoggedIn, false);
    } catch (e) {
      Logger.warning('Failed to clear SharedPreferences flag', e);
    }
  }
}


