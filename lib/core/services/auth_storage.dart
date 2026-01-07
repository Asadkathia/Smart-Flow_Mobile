import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/storage_keys.dart';

/// Centralized authentication token storage using flutter_secure_storage
/// 
/// This service provides secure storage for sensitive authentication data.
/// Uses flutter_secure_storage which encrypts data using platform-specific
/// secure storage mechanisms (Keychain on iOS, Keystore on Android).
/// 
/// SECURITY: Never use SharedPreferences for tokens - they are not encrypted.
class AuthStorage {
  AuthStorage._();
  
  static final AuthStorage instance = AuthStorage._();
  
  // Configure secure storage with appropriate options
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ============ Access Token ============
  
  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageKeys.accessToken);
  }

  // ============ Refresh Token ============
  
  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  // ============ User ID ============
  
  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: StorageKeys.userId);
  }

  // ============ Token Expiry ============
  
  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(
      key: StorageKeys.tokenExpiry,
      value: expiry.toIso8601String(),
    );
  }

  /// Get token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _storage.read(key: StorageKeys.tokenExpiry);
    if (expiryStr == null) return null;
    return DateTime.tryParse(expiryStr);
  }

  // ============ Clear All Auth Data ============
  
  /// Clear all authentication data
  /// This should be called on logout or when tokens are invalid
  Future<void> clearAll() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);
    await _storage.delete(key: StorageKeys.tokenExpiry);
    // Note: isLoggedIn is stored in SharedPreferences (non-sensitive)
    // and should be cleared separately if needed
  }

  // ============ Check Auth State ============
  
  /// Check if user has valid tokens
  Future<bool> hasValidTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && 
           accessToken.isNotEmpty && 
           refreshToken != null && 
           refreshToken.isNotEmpty;
  }
}

/// AuthStorage Provider for Riverpod
final authStorageProvider = Provider<AuthStorage>((ref) {
  return AuthStorage.instance;
});

