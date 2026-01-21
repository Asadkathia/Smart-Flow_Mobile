/// Storage Keys for SmartFlowPro
/// 
/// This file contains all storage key constants used for
/// SharedPreferences and Hive local storage.
class StorageKeys {
  StorageKeys._();

  // ============ Auth Storage ============
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String isLoggedIn = 'is_logged_in';
  static const String tokenExpiry = 'token_expiry';

  // ============ User Storage ============
  static const String userProfile = 'user_profile';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userAvatar = 'user_avatar';

  // ============ Organization Storage ============
  static const String organizationId = 'organization_id';
  static const String organizationName = 'organization_name';

  // ============ App Settings ============
  static const String isDarkMode = 'is_dark_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String language = 'language';
  static const String lastSyncTime = 'last_sync_time';

  // ============ Hive Box Names ============
  static const String offlineQueueBox = 'offline_queue';
  static const String visitsBox = 'visits_cache';
  static const String quotesBox = 'quotes_cache';
  static const String invoicesBox = 'invoices_cache';
  static const String inventoryBox = 'inventory_cache';
  static const String notesBox = 'notes_cache';
  static const String chatBox = 'chat_cache';
  static const String billingBox = 'billing_cache';

  // ============ Cache Keys ============
  static const String todayVisitsCache = 'today_visits';
  static const String completedVisitsCache = 'completed_visits';
  static const String scheduleCache = 'schedule_cache';
  static const String inventoryListCache = 'inventory_list';
  static const String invoicesListCache = 'invoices_list';
  static const String billingSettingsCache = 'billing_settings';
}

