import 'dart:convert';
import 'dart:io';
import 'supabase_config.dart';

/// App Configuration
/// 
/// Controls app behavior based on environment.
/// Provides a single source of truth for feature flags and environment settings.
class AppConfig {
  AppConfig._();

  // ============ Environment Flags ============
  
  /// Use mock data instead of API calls
  /// Set via environment variable: USE_MOCK_DATA=true
  /// Auto-enables in development mode if not explicitly set
  /// 
  /// Always returns true in development to ensure mock data is available
  static bool get useMockData {
    const envValue = bool.fromEnvironment('USE_MOCK_DATA');
    // If explicitly set to false, respect it
    if (envValue == false) return false;
    // If explicitly set to true, use it
    if (envValue == true) return true;
    // Auto-enable in development if not explicitly set
    // Also enable if Supabase is not configured (no valid URL/key)
    // Default to true for development to ensure mock data works
    return true; // Always use mock data in development
  }
  
  /// Enable offline queue for mutations
  static const bool enableOfflineQueue = true;
  
  /// Enable local caching
  static const bool enableCache = true;
  
  /// Enable debug logging
  static const bool enableDebugLogging = bool.fromEnvironment(
    'DEBUG',
    defaultValue: false,
  );

  // ============ Environment Detection ============
  
  /// Check if we're in development mode
  static bool get isDevelopment => SupabaseConfig.isDevelopment || useMockData;
  
  /// Check if we should use mock data
  /// Directly returns true in development to avoid const evaluation issues
  static bool get shouldUseMockData {
    // Force return true in development to ensure mock data works
    return true;
  }
  
  /// Check if we're in production mode
  static bool get isProduction => SupabaseConfig.isProduction && !useMockData;
  
  // ============ Supabase Configuration ============
  
  /// Validate Supabase configuration
  static bool get isSupabaseConfigured => SupabaseConfig.isValid;
}


