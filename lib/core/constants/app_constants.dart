/// App Constants for SmartFlowPro
/// 
/// This file contains general app constants like timeouts,
/// limits, and configuration values.
class AppConstants {
  AppConstants._();

  // ============ App Info ============
  static const String appName = 'SmartFlowPro';
  static const String appVersion = '2.0.0';
  static const String appBuildNumber = '1';

  // ============ Network Timeouts ============
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============ Offline Queue ============
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 5);
  static const Duration syncInterval = Duration(minutes: 5);

  // ============ Pagination ============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ============ Cache ============
  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration shortCacheExpiry = Duration(minutes: 30);

  // ============ Validation ============
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 5);

  // ============ Media ============
  /// Maximum image file size in MB (per PRD Section 18)
  static const int maxImageSizeMb = 10;
  /// Maximum image file size in bytes
  static const int maxImageSize = maxImageSizeMb * 1024 * 1024; // 10MB
  /// Maximum PDF file size in MB (per PRD Section 18)
  static const int maxPdfSizeMb = 25;
  /// Maximum PDF file size in bytes
  static const int maxPdfSize = maxPdfSizeMb * 1024 * 1024; // 25MB
  /// Maximum video file size in MB (per PRD Section 18)
  static const int maxVideoSizeMb = 100;
  /// Maximum video file size in bytes
  static const int maxVideoSize = maxVideoSizeMb * 1024 * 1024; // 100MB
  /// Maximum signature file size in MB (per PRD Section 18)
  static const int maxSignatureSizeMb = 5;
  /// Maximum signature file size in bytes
  static const int maxSignatureSize = maxSignatureSizeMb * 1024 * 1024; // 5MB
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // ============ Signature ============
  static const double signatureStrokeWidth = 3.0;
  static const int signatureMinPoints = 20;

  // ============ Map ============
  static const double defaultLatitude = 33.4484;
  static const double defaultLongitude = -112.0740;
  static const double defaultZoom = 12.0;
  static const double markerZoom = 15.0;

  // ============ UI ============
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration splashDuration = Duration(seconds: 2);

  // ============ Date Formats ============
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
}


