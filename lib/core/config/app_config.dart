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
  /// Auto-enables if Supabase is not configured or in development mode
  /// 
  /// Priority:
  /// 1. If USE_MOCK_DATA env var is explicitly set, use that value
  /// 2. If Supabase is not configured, use mock data (fallback)
  /// 3. If in development mode, use mock data (default)
  /// 4. Otherwise, use real API (production with Supabase configured)
  static bool get useMockData {
    // Always use mock data if Supabase is not properly configured
    if (!SupabaseConfig.isValid) {
      return true;
    }
    
    // Check if USE_MOCK_DATA is explicitly set in environment
    if (const bool.hasEnvironment('USE_MOCK_DATA')) {
      return const bool.fromEnvironment('USE_MOCK_DATA');
    }
    
    // In development mode, default to mock data if not set
    if (SupabaseConfig.isDevelopment) {
      return true;
    }
    
    // In production/staging with valid Supabase config, use real API
    return false;
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
  /// Delegates to useMockData getter for consistency
  static bool get shouldUseMockData => useMockData;
  
  /// Check if we're in production mode
  static bool get isProduction => SupabaseConfig.isProduction && !useMockData;
  
  // ============ Supabase Configuration ============
  
  /// Validate Supabase configuration
  static bool get isSupabaseConfigured => SupabaseConfig.isValid;
}


