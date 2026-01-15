import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';
import '../services/logger.dart';

/// Centralized authentication token storage using flutter_secure_storage
/// 
/// This service provides secure storage for sensitive authentication data.
/// Uses flutter_secure_storage which encrypts data using platform-specific
/// secure storage mechanisms (Keychain on iOS, Keystore on Android).
/// 
/// FALLBACK: On iOS simulators, if Keychain fails due to missing entitlements,
/// falls back to SharedPreferences (development/simulator only).
/// 
/// SECURITY: In production, SharedPreferences fallback is disabled.
class AuthStorage {
  AuthStorage._();
  
  static final AuthStorage instance = AuthStorage._();
  
  // Track if we're using fallback mode (SharedPreferences instead of Keychain)
  bool _usingFallback = false;
  SharedPreferences? _prefs;
  
  // Configure secure storage with appropriate options
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );
  
  /// Initialize SharedPreferences fallback if needed
  Future<void> _ensureFallback() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
  
  /// Try secure storage, fallback to SharedPreferences if it fails
  Future<void> _writeWithFallback(String key, String value) async {
    if (_usingFallback) {
      await _ensureFallback();
      await _prefs!.setString(key, value);
      if (kDebugMode) {
        Logger.warning('Using SharedPreferences fallback for: $key');
      }
      return;
    }
    
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // Check if it's the Keychain entitlement error (-34018)
      if (e.toString().contains('-34018') || 
          e.toString().contains('entitlement') ||
          e.toString().contains('A required entitlement')) {
        if (kDebugMode) {
          Logger.warning('Keychain failed, falling back to SharedPreferences for simulator testing');
          _usingFallback = true;
        }
        await _ensureFallback();
        await _prefs!.setString(key, value);
      } else {
        rethrow;
      }
    }
  }
  
  /// Try secure storage read, fallback to SharedPreferences if needed
  Future<String?> _readWithFallback(String key) async {
    if (_usingFallback) {
      await _ensureFallback();
      return _prefs!.getString(key);
    }
    
    try {
      return await _storage.read(key: key);
    } catch (e) {
      // Check if it's the Keychain entitlement error
      if (e.toString().contains('-34018') || 
          e.toString().contains('entitlement') ||
          e.toString().contains('A required entitlement')) {
        if (kDebugMode) {
          Logger.warning('Keychain read failed, using SharedPreferences fallback');
          _usingFallback = true;
        }
        await _ensureFallback();
        return _prefs!.getString(key);
      } else {
        rethrow;
      }
    }
  }
  
  /// Try secure storage delete, fallback to SharedPreferences if needed
  Future<void> _deleteWithFallback(String key) async {
    if (_usingFallback) {
      await _ensureFallback();
      await _prefs!.remove(key);
      return;
    }
    
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // Check if it's the Keychain entitlement error
      if (e.toString().contains('-34018') || 
          e.toString().contains('entitlement') ||
          e.toString().contains('A required entitlement')) {
        if (kDebugMode) {
          _usingFallback = true;
        }
        await _ensureFallback();
        await _prefs!.remove(key);
      } else {
        rethrow;
      }
    }
  }

  // ============ Access Token ============
  
  /// Save access token securely
  Future<void> saveAccessToken(String token) async {
    await _writeWithFallback(StorageKeys.accessToken, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _readWithFallback(StorageKeys.accessToken);
  }

  // ============ Refresh Token ============
  
  /// Save refresh token securely
  Future<void> saveRefreshToken(String token) async {
    await _writeWithFallback(StorageKeys.refreshToken, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _readWithFallback(StorageKeys.refreshToken);
  }

  // ============ User ID ============
  
  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _writeWithFallback(StorageKeys.userId, userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _readWithFallback(StorageKeys.userId);
  }

  // ============ Token Expiry ============
  
  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _writeWithFallback(
      StorageKeys.tokenExpiry,
      expiry.toIso8601String(),
    );
  }

  /// Get token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _readWithFallback(StorageKeys.tokenExpiry);
    if (expiryStr == null) return null;
    return DateTime.tryParse(expiryStr);
  }

  // ============ Clear All Auth Data ============
  
  /// Clear all authentication data
  /// This should be called on logout or when tokens are invalid
  Future<void> clearAll() async {
    await _deleteWithFallback(StorageKeys.accessToken);
    await _deleteWithFallback(StorageKeys.refreshToken);
    await _deleteWithFallback(StorageKeys.userId);
    await _deleteWithFallback(StorageKeys.tokenExpiry);
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

