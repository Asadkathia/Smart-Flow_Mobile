import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/config/supabase_config.dart';
import '../../../router/app_router.dart';

/// API Interceptor for SmartFlowPro
/// 
/// Handles:
/// - Adding Supabase auth token to requests
/// - Token refresh on 401 using Supabase Auth
/// - Request/Response logging
/// - Error transformation
class ApiInterceptor extends Interceptor {
  final Ref ref;

  ApiInterceptor(this.ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Supabase apikey header (required for all requests)
    options.headers['apikey'] = SupabaseConfig.supabaseAnonKey;

    // Add auth token if available (Supabase JWT)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(StorageKeys.accessToken);
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses in debug mode
    // Can add response transformation here if needed
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _tryRefreshToken();
      
      if (refreshed) {
        // Retry the original request with new token
        try {
          final prefs = await SharedPreferences.getInstance();
          final newToken = prefs.getString(StorageKeys.accessToken);
          
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          
          final dio = Dio();
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // Token refresh failed - clear auth and redirect to login
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
  Future<bool> _tryRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(StorageKeys.refreshToken);
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Supabase token refresh endpoint
      final dio = Dio(BaseOptions(
        baseUrl: SupabaseConfig.supabaseUrl,
        headers: {
          'apikey': SupabaseConfig.supabaseAnonKey,
          'Content-Type': 'application/json',
        },
      ));

      final response = await dio.post(
        '/auth/v1/token?grant_type=refresh_token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;
        
        if (newAccessToken != null) {
          await prefs.setString(StorageKeys.accessToken, newAccessToken);
          if (newRefreshToken != null) {
            await prefs.setString(StorageKeys.refreshToken, newRefreshToken);
          }
          return true;
        }
      }

      return false;
    } catch (e) {
      // Token refresh failed
      return false;
    }
  }

  /// Clear all auth data
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.accessToken);
    await prefs.remove(StorageKeys.refreshToken);
    await prefs.remove(StorageKeys.userId);
    await prefs.setBool(StorageKeys.isLoggedIn, false);
  }
}


