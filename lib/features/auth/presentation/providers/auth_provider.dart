import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/constants/api_endpoints.dart';
import 'package:smartflowpro/core/config/app_config.dart';
import 'package:smartflowpro/core/config/supabase_config.dart';
import 'package:smartflowpro/core/services/auth_storage.dart';
import 'package:smartflowpro/core/services/logger.dart';
import 'package:smartflowpro/shared/data/remote/api_client.dart';
import '../../data/models/user_model.dart';

part 'auth_provider.g.dart';

/// Auth State
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

/// Auth State Class
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

/// Auth Notifier
/// 
/// Manages authentication state throughout the app.
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    // Check for existing session on startup
    _checkExistingSession();
    return const AuthState(status: AuthStatus.initial);
  }

  /// Check for existing session
  /// 
  /// Supabase Flutter SDK automatically persists sessions, so we just need to check
  /// if a session exists and fetch the user profile.
  Future<void> _checkExistingSession() async {
    try {
      // Skip if using mock data
      if (AppConfig.useMockData) {
        final authStorage = AuthStorage.instance;
        final hasValidTokens = await authStorage.hasValidTokens();
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool(StorageKeys.isLoggedIn) ?? false;
        
        if (hasValidTokens && isLoggedIn) {
          Logger.debug('Existing session found (mock mode) - user authenticated');
          state = state.copyWith(status: AuthStatus.authenticated);
        } else {
          Logger.debug('No valid session found');
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
        return;
      }
      
      // Check Supabase session (automatically restored by SDK)
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;
      
      if (session != null && session.user != null) {
        Logger.debug('Supabase session found - fetching user profile');
        
        try {
          // Fetch user profile from database
          final profileResponse = await supabase
              .from('users')
              .select()
              .eq('id', session.user.id)
              .maybeSingle();

          if (profileResponse != null) {
            final user = UserModel.fromJson(profileResponse as Map<String, dynamic>);
            
            // Verify user is a technician and active
            if (user.role == UserRole.technician && user.status == UserStatus.active) {
              Logger.debug('Session validated - user authenticated');
              state = AuthState(
                status: AuthStatus.authenticated,
                user: user,
              );
              return;
            } else {
              Logger.warning('User is not an active technician');
              await supabase.auth.signOut();
            }
          } else {
            Logger.warning('User profile not found');
            await supabase.auth.signOut();
          }
        } catch (e, stackTrace) {
          Logger.error('Session validation error', e, stackTrace);
          await supabase.auth.signOut();
        }
      } else {
        Logger.debug('No Supabase session found');
      }
      
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e, stackTrace) {
      Logger.error('Error checking existing session', e, stackTrace);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login with email and password
  /// 
  /// Includes channel validation (mobile_technician) per PRD Section 4.1
  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      // Check if we should use mock data
      final useMock = AppConfig.useMockData;
      final supabaseValid = SupabaseConfig.isValid;
      Logger.info('Login attempt - useMockData: $useMock, SupabaseValid: $supabaseValid, email: $email');
      debugPrint('🔍 Login Debug - useMockData: $useMock, SupabaseValid: $supabaseValid');
      
      // Use Supabase Auth if configured, otherwise fall back to mock/API
      if (supabaseValid && !useMock) {
        debugPrint('✅ Using SUPABASE AUTH for login');
        Logger.info('Using Supabase Auth for login - email: $email');
        
        try {
          final supabase = Supabase.instance.client;
          
          // Authenticate with Supabase
          final response = await supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );

          if (response.session == null || response.user == null) {
            throw Exception('Login failed: No session created');
          }

          // Fetch user profile from database
          final profileResponse = await supabase
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .maybeSingle();

          if (profileResponse == null) {
            throw Exception('User profile not found');
          }

          final user = UserModel.fromJson(profileResponse as Map<String, dynamic>);
          
          // Verify user is a technician (PRD Section 4.1)
          if (user.role != UserRole.technician) {
            await supabase.auth.signOut();
            throw Exception('Only technicians can access the mobile app');
          }

          // Verify user is active
          if (user.status != UserStatus.active) {
            await supabase.auth.signOut();
            throw Exception('User account is not active');
          }

          // Save tokens securely
          final authStorage = AuthStorage.instance;
          await authStorage.saveAccessToken(response.session!.accessToken);
          await authStorage.saveRefreshToken(response.session!.refreshToken ?? '');
          await authStorage.saveUserId(user.id);
          
          // Save token expiry
          if (response.session!.expiresAt != null) {
            final expiry = DateTime.fromMillisecondsSinceEpoch(response.session!.expiresAt! * 1000);
            await authStorage.saveTokenExpiry(expiry);
          }
          
          // Save non-sensitive flag
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(StorageKeys.isLoggedIn, true);
          
          Logger.info('Login successful via Supabase - tokens saved securely');

          state = AuthState(
            status: AuthStatus.authenticated,
            user: user,
          );

          return true;
        } catch (e) {
          Logger.error('Supabase login error', e);
          throw e;
        }
      } else if (useMock) {
        debugPrint('✅ Using MOCK DATA for login');
        Logger.info('Using mock data for login - email: $email');
        
        // Simulate API call for development
        await Future.delayed(const Duration(seconds: 1));

        // Mock user for development - accepts any email/password
        final mockUser = UserModel(
          id: 'user_1',
          orgId: 'org_1',
          email: email,
          fullName: 'Tony Technician',
          role: UserRole.technician,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        debugPrint('✅ Mock user created: ${mockUser.email}');

        // Save tokens securely using AuthStorage
        final authStorage = AuthStorage.instance;
        await authStorage.saveAccessToken('mock_token');
        await authStorage.saveRefreshToken('mock_refresh_token');
        await authStorage.saveUserId(mockUser.id);
        
        debugPrint('✅ Tokens saved');
        
        // Save non-sensitive flag in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(StorageKeys.isLoggedIn, true);
        
        debugPrint('✅ Login successful (mock mode)');
        Logger.info('Login successful (mock mode) - tokens saved securely');

        state = AuthState(
          status: AuthStatus.authenticated,
          user: mockUser,
        );

        return true;
      } else {
        // Fallback to Edge Function API
        final apiClient = ref.read(apiClientProvider);
        final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.login)}';
        final response = await apiClient.post(
          endpoint,
          data: {
            'email': email,
            'password': password,
            'channel': 'mobile_technician',
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data as Map<String, dynamic>;
          final token = data['token'] as String? ?? data['access_token'] as String?;
          final refreshToken = data['refresh_token'] as String?;
          final userData = data['user'] as Map<String, dynamic>? ?? data;
          
          if (token == null) {
            throw Exception('No token received from server');
          }

          final user = UserModel.fromJson(userData);
          
          if (user.role != UserRole.technician) {
            throw Exception('Only technicians can access the mobile app');
          }

          final authStorage = AuthStorage.instance;
          await authStorage.saveAccessToken(token);
          if (refreshToken != null) {
            await authStorage.saveRefreshToken(refreshToken);
          }
          await authStorage.saveUserId(user.id);
          
          if (data['expires_at'] != null) {
            final expiry = DateTime.parse(data['expires_at'] as String);
            await authStorage.saveTokenExpiry(expiry);
          }
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(StorageKeys.isLoggedIn, true);
          
          Logger.info('Login successful via Edge Function - tokens saved securely');

          state = AuthState(
            status: AuthStatus.authenticated,
            user: user,
          );

          return true;
        } else {
          throw Exception('Login failed: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Login error: $e', e, stackTrace);
      final errorMessage = e.toString();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Login failed. ${errorMessage.contains('Exception') ? errorMessage : 'Please check your credentials.'}',
      );
      return false;
    }
  }

  /// Signup
  /// 
  /// Registers a new technician account with channel validation.
  /// After signup, user must verify OTP before logging in.
  Future<bool> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData) {
        // Simulate API call for development
        await Future.delayed(const Duration(seconds: 1));
        
        // In mock mode, signup succeeds and OTP is sent
        state = state.copyWith(status: AuthStatus.unauthenticated);
        Logger.info('Signup successful (mock mode) - OTP sent to email');
        return true;
      } else {
        // Call actual API with channel header
        final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.signup)}';
        final response = await apiClient.post(
          endpoint,
          data: {
            'email': email,
            'password': password,
            'first_name': firstName,
            'last_name': lastName,
            if (phone != null) 'phone': phone,
            'channel': 'mobile_technician', // PRD Section 4.1 - channel validation
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // After signup, user needs to verify OTP
          state = state.copyWith(status: AuthStatus.unauthenticated);
          Logger.info('Signup successful - OTP sent to email');
          return true;
        } else {
          throw Exception('Signup failed: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Signup error', e, stackTrace);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Signup failed. Please try again.',
      );
      return false;
    }
  }

  /// Forgot Password
  /// 
  /// Sends OTP to email for password reset.
  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        Logger.info('Forgot password OTP sent (mock mode)');
        return true;
      } else {
        final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.forgotPassword)}';
        final response = await apiClient.post(
          endpoint,
          data: {
            'email': email,
            'channel': 'mobile_technician', // PRD Section 4.1
          },
        );

        if (response.statusCode == 200) {
          Logger.info('Forgot password OTP sent');
          return true;
        } else {
          throw Exception('Failed to send OTP: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Forgot password error', e, stackTrace);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Failed to send OTP. Please try again.',
      );
      return false;
    }
  }

  /// Verify OTP
  /// 
  /// Verifies OTP for password reset or signup.
  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        // In mock mode, accept any 6-digit OTP
        if (otp.length == 6) {
          Logger.info('OTP verified (mock mode)');
          return true;
        } else {
          throw Exception('Invalid OTP format');
        }
      } else {
        final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.verifyOtp)}';
        final response = await apiClient.post(
          endpoint,
          data: {
            'email': email,
            'otp': otp,
            'channel': 'mobile_technician', // PRD Section 4.1
          },
        );

        if (response.statusCode == 200) {
          Logger.info('OTP verified successfully');
          return true;
        } else {
          throw Exception('Invalid OTP: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('OTP verification error', e, stackTrace);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Invalid OTP. Please try again.',
      );
      return false;
    }
  }

  /// Reset Password
  /// 
  /// Resets password using verified OTP.
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      // Use mock data if configured, otherwise call real API
      if (AppConfig.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        Logger.info('Password reset successful (mock mode)');
        return true;
      } else {
        final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.resetPassword)}';
        final response = await apiClient.post(
          endpoint,
          data: {
            'email': email,
            'otp': otp,
            'new_password': newPassword,
            'channel': 'mobile_technician', // PRD Section 4.1
          },
        );

        if (response.statusCode == 200) {
          Logger.info('Password reset successful');
          return true;
        } else {
          throw Exception('Password reset failed: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Password reset error', e, stackTrace);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Password reset failed. Please try again.',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Sign out from Supabase if configured
      if (SupabaseConfig.isValid) {
        try {
          await Supabase.instance.client.auth.signOut();
          Logger.info('Supabase sign out successful');
        } catch (e) {
          Logger.warning('Supabase sign out failed, continuing with local logout', e);
        }
      }
      
      // Call logout API if not using mock data and Supabase not available
      if (!AppConfig.useMockData && !SupabaseConfig.isValid) {
        try {
          final apiClient = ref.read(apiClientProvider);
          final endpoint = '${ApiEndpoints.apiBase}${ApiEndpoints.buildRouterPath(ApiEndpoints.logout)}';
          await apiClient.post(endpoint);
        } catch (e) {
          Logger.warning('Logout API call failed, continuing with local logout', e);
        }
      }
      
      // Clear all auth data securely
      await _clearAuthData();
      
      Logger.info('Logout successful - all auth data cleared');

      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e, stackTrace) {
      Logger.error('Error during logout', e, stackTrace);
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    final authStorage = AuthStorage.instance;
    await authStorage.clearAll();
    
    // Clear non-sensitive flag in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.isLoggedIn, false);
  }

  /// Update user profile
  void updateUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Current User Provider
@riverpod
UserModel? currentUser(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
}

/// Is Authenticated Provider
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
}

/// Auth Error Provider
@riverpod
String? authError(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.error;
}



