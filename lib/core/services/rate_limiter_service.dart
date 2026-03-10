import 'package:smartflowpro/core/services/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Rate Limiter Service
///
/// Provides client-side rate limiting for API requests.
/// PRD Section 12.5: AI usage is rate-limited per organization (100 req/hr default).
class RateLimiterService {
  static const String _boxName = 'rate_limits';

  final int _maxRequestsPerHour;
  final Duration _windowDuration;

  Box<dynamic>? _box;

  RateLimiterService({int maxRequestsPerHour = 100, Duration? windowDuration})
    : _maxRequestsPerHour = maxRequestsPerHour,
      _windowDuration = windowDuration ?? const Duration(hours: 1);

  /// Initialize the rate limiter
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<dynamic>(_boxName);
    }
  }

  /// Check if a request is allowed
  ///
  /// Returns true if request is within rate limit, false otherwise.
  Future<bool> isRequestAllowed(String key) async {
    await init();

    final timestamps = _getTimestamps(key);
    final now = DateTime.now();
    final windowStart = now.subtract(_windowDuration);

    // Filter timestamps within the current window
    final validTimestamps = timestamps
        .where((ts) => ts.isAfter(windowStart))
        .toList();

    return validTimestamps.length < _maxRequestsPerHour;
  }

  /// Record a request
  Future<void> recordRequest(String key) async {
    await init();

    final timestamps = _getTimestamps(key);
    final now = DateTime.now();
    final windowStart = now.subtract(_windowDuration);

    // Keep only timestamps within the window + add new one
    final validTimestamps = timestamps
        .where((ts) => ts.isAfter(windowStart))
        .toList();
    validTimestamps.add(now);

    // Store as ISO strings for serialization
    final isoStrings = validTimestamps
        .map((ts) => ts.toIso8601String())
        .toList();
    await _box?.put(key, isoStrings);

    Logger.debug(
      'Rate limiter: Recorded request for $key. Count: ${validTimestamps.length}/$_maxRequestsPerHour',
    );
  }

  /// Check and record a request in one call
  ///
  /// Returns true if request is allowed and recorded, false if rate limited.
  Future<bool> checkAndRecord(String key) async {
    final allowed = await isRequestAllowed(key);
    if (allowed) {
      await recordRequest(key);
    } else {
      Logger.warning('Rate limit exceeded for key: $key');
    }
    return allowed;
  }

  /// Get remaining requests in current window
  Future<int> getRemainingRequests(String key) async {
    await init();

    final timestamps = _getTimestamps(key);
    final now = DateTime.now();
    final windowStart = now.subtract(_windowDuration);

    final validTimestamps = timestamps
        .where((ts) => ts.isAfter(windowStart))
        .toList();

    return _maxRequestsPerHour - validTimestamps.length;
  }

  /// Get time until rate limit resets (oldest request drops off)
  Future<Duration?> getTimeUntilReset(String key) async {
    await init();

    final timestamps = _getTimestamps(key);
    if (timestamps.isEmpty) return null;

    final now = DateTime.now();
    final windowStart = now.subtract(_windowDuration);

    final validTimestamps = timestamps
        .where((ts) => ts.isAfter(windowStart))
        .toList();
    if (validTimestamps.isEmpty) return null;

    // Find the oldest timestamp - that's when the first slot opens up
    validTimestamps.sort();
    final oldestTimestamp = validTimestamps.first;
    final resetTime = oldestTimestamp.add(_windowDuration);

    if (resetTime.isAfter(now)) {
      return resetTime.difference(now);
    }
    return Duration.zero;
  }

  /// Clear all rate limit data (for testing or reset)
  Future<void> clear() async {
    await init();
    await _box?.clear();
  }

  /// Get timestamps for a key
  List<DateTime> _getTimestamps(String key) {
    final stored = _box?.get(key) as List<dynamic>?;
    if (stored == null) return [];

    return stored
        .whereType<String>()
        .map((s) => DateTime.tryParse(s))
        .whereType<DateTime>()
        .toList();
  }
}

/// Rate limit exception
class RateLimitException implements Exception {
  final String message;
  final Duration? retryAfter;
  final int remaining;

  const RateLimitException({
    required this.message,
    this.retryAfter,
    this.remaining = 0,
  });

  @override
  String toString() => message;
}
