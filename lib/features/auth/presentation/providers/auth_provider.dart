import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartflowpro/core/constants/storage_keys.dart';
import 'package:smartflowpro/core/services/auth_storage.dart';
import 'package:smartflowpro/core/services/logger.dart';
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
  Future<void> _checkExistingSession() async {
    try {
      final authStorage = AuthStorage.instance;
      final hasValidTokens = await authStorage.hasValidTokens();
      
      // Check non-sensitive flag in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(StorageKeys.isLoggedIn) ?? false;

      if (hasValidTokens && isLoggedIn) {
        // TODO(backend): Validate token with backend
        // For now, assume valid if exists
        Logger.debug('Existing session found - user authenticated');
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        Logger.debug('No valid session found');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e, stackTrace) {
      Logger.error('Error checking existing session', e, stackTrace);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      // TODO: Call actual API
      // final response = await ref.read(apiClientProvider).post(
      //   ApiEndpoints.login,
      //   data: LoginRequest(email: email, password: password).toJson(),
      // );

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 1));

      // Mock user for development
      final mockUser = UserModel(
        id: 'user_1',
        orgId: 'org_1',
        email: email,
        firstName: 'Tony',
        lastName: 'Technician',
        role: UserRole.technician,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save tokens securely using AuthStorage
      final authStorage = AuthStorage.instance;
      await authStorage.saveAccessToken('mock_token');
      await authStorage.saveRefreshToken('mock_refresh_token'); // TODO(backend): Get from API response
      await authStorage.saveUserId(mockUser.id);
      
      // Save non-sensitive flag in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(StorageKeys.isLoggedIn, true);
      
      Logger.info('Login successful - tokens saved securely');

      state = AuthState(
        status: AuthStatus.authenticated,
        user: mockUser,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Login failed. Please check your credentials.',
      );
      return false;
    }
  }

  /// Signup
  Future<bool> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      // TODO: Call actual API
      await Future.delayed(const Duration(seconds: 1));

      // After signup, user needs to verify OTP
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Signup failed. Please try again.',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Clear all auth data securely
      final authStorage = AuthStorage.instance;
      await authStorage.clearAll();
      
      // Clear non-sensitive flag in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(StorageKeys.isLoggedIn, false);
      
      Logger.info('Logout successful - all auth data cleared');

      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e, stackTrace) {
      Logger.error('Error during logout', e, stackTrace);
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
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



