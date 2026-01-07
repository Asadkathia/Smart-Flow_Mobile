import '../config/supabase_config.dart';

/// API Endpoints for SmartFlowPro
/// 
/// This file contains all API endpoint constants used throughout the app.
/// Uses Supabase Edge Functions for business logic and REST API for direct database access.
/// 
/// Edge Function Routing Modes:
/// - Router style: /functions/v1/api/<path> (single Edge Function with routing)
/// - Direct style: /functions/v1/<function_name> (individual Edge Functions)
class ApiEndpoints {
  ApiEndpoints._();

  // ============ Edge Function Routing Configuration ============
  
  /// Edge Function routing mode
  /// Set to true to use router style: /functions/v1/api/<path>
  /// Set to false to use direct style: /functions/v1/<function_name>
  /// TODO(backend): Update this based on actual backend implementation
  static const bool useRouterStyle = true;
  
  /// Router path prefix (only used when useRouterStyle is true)
  static const String routerPrefix = '/api';

  // ============ Base URLs ============
  
  /// Base URL - Uses Supabase Edge Functions configuration
  static String get baseUrl => SupabaseConfig.edgeFunctionsBase;
  
  /// REST API Base URL (for direct database access)
  static String get restApiBase => SupabaseConfig.restApiBase;
  
  /// API Version
  static const String apiVersion = '/v1';
  
  /// Full API Base (Edge Functions)
  /// Returns router style or direct style based on useRouterStyle
  static String get apiBase {
    if (useRouterStyle) {
      return '$baseUrl$apiVersion$routerPrefix';
    }
    return '$baseUrl$apiVersion';
  }
  
  /// Full REST API Base
  static String get restApiBaseFull => '$restApiBase';
  
  // ============ Helper Methods ============
  
  /// Build endpoint path for router style
  /// Example: buildRouterPath('/tech/visits') -> '/api/tech/visits'
  static String buildRouterPath(String path) {
    if (useRouterStyle) {
      return '$routerPrefix$path';
    }
    return path;
  }
  
  /// Build endpoint path for direct function style
  /// Example: buildDirectPath('visits') -> '/visits'
  /// Note: Function name should match the Edge Function name
  static String buildDirectPath(String functionName) {
    return '/$functionName';
  }

  // ============ Auth Endpoints ============
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String signup = '$auth/signup';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String verifyOtp = '$auth/verify-otp';

  // ============ User Endpoints ============
  static const String users = '/users';
  static const String userProfile = '$users/profile';
  static const String updateProfile = '$users/profile';

  // ============ Technician Endpoints ============
  static const String tech = '/tech';
  
  // Visits
  static const String visits = '$tech/visits';
  static const String todayVisits = '$visits/today';
  static String visitDetails(String id) => '$visits/$id';
  static String startVisit(String id) => '$visits/$id/start';
  static String pauseVisit(String id) => '$visits/$id/pause';
  static String completeVisit(String id) => '$visits/$id/complete';
  
  // Notes
  static String visitNotes(String visitId) => '$visits/$visitId/notes';
  static String addNote(String visitId) => '$visits/$visitId/notes';
  static String updateNote(String visitId, String noteId) => '$visits/$visitId/notes/$noteId';
  static String deleteNote(String visitId, String noteId) => '$visits/$visitId/notes/$noteId';
  
  // Media
  static String visitMedia(String visitId) => '$visits/$visitId/media';
  static String uploadMedia(String visitId) => '$visits/$visitId/media';
  static String deleteMedia(String visitId, String mediaId) => '$visits/$visitId/media/$mediaId';
  
  // Signature
  static String visitSignature(String visitId) => '$visits/$visitId/signature';

  // ============ Quotes Endpoints ============
  static const String quotes = '$tech/quotes';
  static String quoteDetails(String id) => '$quotes/$id';
  static String createQuote(String visitId) => '$visits/$visitId/quotes';
  static String finalizeQuote(String id) => '$quotes/$id/finalize';

  // ============ Inventory Endpoints ============
  static const String inventory = '$tech/inventory';
  static String inventoryItem(String id) => '$inventory/$id';
  static const String addInventory = inventory;
  static const String aiDetectInventory = '$inventory/ai-detect';

  // ============ Invoice Endpoints ============
  static const String invoices = '$tech/invoices';
  static String invoiceDetails(String id) => '$invoices/$id';
  static String invoicePreview(String id) => '$invoices/$id/preview';
  static String invoiceFinalize(String id) => '$invoices/$id/finalize';

  // ============ Chat Endpoints ============
  static const String chat = '$tech/chat';
  static const String chatThreads = '$chat/threads';
  static String chatMessages(String threadId) => '$chat/threads/$threadId/messages';
  static String sendMessage(String threadId) => '$chat/threads/$threadId/messages';

  // ============ AI Assistant Endpoints ============
  static const String ai = '$tech/ai';
  static const String aiChat = '$ai/chat';
  static const String aiAnalyzeImage = '$ai/analyze-image';

  // ============ Schedule Endpoints ============
  static const String schedule = '$tech/schedule';
  static String scheduleByDate(String date) => '$schedule?date=$date';
  static String scheduleByRange(String start, String end) => '$schedule?start=$start&end=$end';

  // ============ Customers Endpoints ============
  static const String customers = '/customers';
  static String customerDetails(String id) => '$customers/$id';

  // ============ Jobs Endpoints ============
  static const String jobs = '/jobs';
  static String jobDetails(String id) => '$jobs/$id';
}


