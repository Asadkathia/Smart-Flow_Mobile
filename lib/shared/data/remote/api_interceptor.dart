import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

    // Add auth token if available (Supabase JWT)
    // Priority: Supabase session > Secure storage
    String? token;
    
    if (SupabaseConfig.isValid) {
      // Try to get token from Supabase session first
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        token = session.accessToken;
      }
    }
    
    // Fallback to secure storage if Supabase token not available
    if (token == null || token.isEmpty) {
      final authStorage = AuthStorage.instance;
      token = await authStorage.getAccessToken();
    }
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    
    // Add channel header for mobile_technician (PRD Section 4.1)
    // This ensures backend can validate channel-based access control
    options.headers['X-Channel'] = 'mobile_technician';

    Logger.network(options.method, options.uri.toString());
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
    final statusCode = err.response?.statusCode;
    final errorBody = err.response?.data;
    
    // Concise error logging without stack traces (reduces log clutter)
    Logger.error('API Error: ${err.requestOptions.method} ${err.requestOptions.uri} -> $statusCode');
    
    // Log error response body for debugging
    if (errorBody != null) {
      // Handle both gateway errors {code, message} and our format {error: {code, message}}
      if (errorBody is Map) {
        final gatewayMessage = errorBody['message'];
        final gatewayCode = errorBody['code'];
        final errorObj = errorBody['error'];
        
        if (gatewayMessage != null && gatewayCode != null) {
          // Gateway-level error (like "Invalid JWT")
          Logger.error('Gateway Error: [$gatewayCode] $gatewayMessage');
        } else if (errorObj is Map) {
          // Our Edge Function error format
          Logger.error('Edge Function Error: [${errorObj['code']}] ${errorObj['message']}');
        } else {
          Logger.debug('Error Body: $errorBody');
        }
      }
    }
    
    if (statusCode == 401) {
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
  /// Uses Supabase Flutter SDK if available, otherwise falls back to API call
  Future<bool> _tryRefreshToken() async {
    try {
      // Try Supabase SDK refresh first
      if (SupabaseConfig.isValid) {
        try {
          final session = await Supabase.instance.client.auth.refreshSession();
          if (session.session != null) {
            // Save tokens to secure storage for consistency
            final authStorage = AuthStorage.instance;
            await authStorage.saveAccessToken(session.session!.accessToken);
            await authStorage.saveRefreshToken(session.session!.refreshToken ?? '');
            
            if (session.session!.expiresAt != null) {
              final expiry = DateTime.fromMillisecondsSinceEpoch(session.session!.expiresAt! * 1000);
              await authStorage.saveTokenExpiry(expiry);
            }
            
            Logger.info('Token refresh successful via Supabase SDK');
            return true;
          }
        } catch (e) {
          Logger.warning('Supabase SDK refresh failed, trying API fallback', e);
        }
      }
      
      // Fallback to API refresh
      final authStorage = AuthStorage.instance;
      final refreshToken = await authStorage.getRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.warning('No refresh token available');
        return false;
      }

      Logger.debug('Attempting token refresh via API');

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
          Logger.info('Token refresh successful via API');
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


