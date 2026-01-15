/// Supabase Configuration
/// 
/// Manages Supabase connection settings and environment variables.
/// Supports dev, staging, and production environments.
class SupabaseConfig {
  SupabaseConfig._();

  // ============ Environment Variables ============
  
  /// Supabase Project URL
  /// Set via environment variable: SUPABASE_URL
  /// Format: https://your-project.supabase.co
  static String get supabaseUrl {
    const envUrl = String.fromEnvironment('SUPABASE_URL');
    if (envUrl.isNotEmpty) return envUrl;
    
    // Default for development (should be overridden)
    return 'https://your-project.supabase.co';
  }
  
  /// Supabase Anonymous Key (public key)
  /// Set via environment variable: SUPABASE_ANON_KEY
  static String get supabaseAnonKey {
    const envKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (envKey.isNotEmpty) return envKey;
    
    // Default for development (should be overridden)
    return 'your-anon-key';
  }
  
  /// OpenAI API Key
  /// Set via environment variable: OPENAI_API_KEY
  /// Required for AI Assistant feature
  static String get openaiApiKey {
    const envKey = String.fromEnvironment('OPENAI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    
    // Return empty string if not set (will be validated when used)
    return '';
  }
  
  // SECURITY: Service Role Key removed from mobile client
  // The service role key should NEVER be included in mobile applications.
  // It bypasses Row Level Security (RLS) and grants full database access.
  // If admin operations are needed, they must be performed via Edge Functions
  // on the backend, not directly from the mobile client.
  // TODO(backend): Ensure all admin operations are implemented as Edge Functions
  
  // ============ API Configuration ============
  
  /// Supabase REST API Base URL
  /// Format: {supabaseUrl}/rest/v1
  static String get restApiBase => '$supabaseUrl/rest/v1';
  
  /// Supabase Edge Functions Base URL
  /// Format: {supabaseUrl}/functions/v1
  static String get edgeFunctionsBase => '$supabaseUrl/functions/v1';
  
  /// Supabase Storage Base URL
  /// Format: {supabaseUrl}/storage/v1
  static String get storageBase => '$supabaseUrl/storage/v1';
  
  /// Supabase Realtime URL
  /// Format: wss://{project-ref}.supabase.co/realtime/v1
  static String get realtimeUrl {
    final url = supabaseUrl;
    if (url.contains('supabase.co')) {
      return url.replaceAll('https://', 'wss://').replaceAll('http://', 'ws://') + '/realtime/v1';
    }
    return 'wss://your-project.supabase.co/realtime/v1';
  }
  
  // ============ Environment Detection ============
  
  /// Check if we're in development mode
  static bool get isDevelopment {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return env == 'development' || env == 'dev';
  }
  
  /// Check if we're in staging mode
  static bool get isStaging {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return env == 'staging';
  }
  
  /// Check if we're in production mode
  static bool get isProduction {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
    return env == 'production' || env == 'prod';
  }
  
  /// Get current environment name
  static String get environment {
    if (isProduction) return 'production';
    if (isStaging) return 'staging';
    return 'development';
  }
  
  // ============ Validation ============
  
  /// Validate configuration is set
  static bool get isValid {
    return supabaseUrl.isNotEmpty && 
           supabaseUrl != 'https://your-project.supabase.co' &&
           supabaseAnonKey.isNotEmpty && 
           supabaseAnonKey != 'your-anon-key';
  }
  
  /// Check if OpenAI API key is configured
  static bool get isOpenAiConfigured {
    return openaiApiKey.isNotEmpty;
  }
  
  /// Get validation errors
  static List<String> get validationErrors {
    final errors = <String>[];
    
    if (supabaseUrl.isEmpty || supabaseUrl == 'https://your-project.supabase.co') {
      errors.add('SUPABASE_URL is not set');
    }
    
    if (supabaseAnonKey.isEmpty || supabaseAnonKey == 'your-anon-key') {
      errors.add('SUPABASE_ANON_KEY is not set');
    }
    
    return errors;
  }
}
