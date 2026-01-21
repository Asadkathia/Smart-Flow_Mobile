import 'package:smartflowpro/core/services/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Offline Queue Manager
/// 
/// Manages offline operations queue with size limits and FIFO eviction.
/// PRD Section 29.4: Maximum 1000 operations per device.
class OfflineQueueManager {
  static const int maxQueueSize = 1000;
  static const String _boxName = 'offline_queue';
  
  Box<dynamic>? _box;
  
  /// Initialize the queue manager
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<dynamic>(_boxName);
    }
  }
  
  /// Add operation to queue
  /// 
  /// Enforces FIFO eviction when queue exceeds max size
  Future<void> addOperation(Map<String, dynamic> operation) async {
    await init();
    
    final queue = await getQueue();
    
    // Add timestamp if not present
    operation['queued_at'] = operation['queued_at'] ?? DateTime.now().toIso8601String();
    
    queue.add(operation);
    
    // Enforce size limit with FIFO eviction
    if (queue.length > maxQueueSize) {
      final removed = queue.removeAt(0); // Remove oldest
      Logger.warning('Queue size limit exceeded. Evicting oldest operation: ${removed['id']}');
    }
    
    await _box?.put('operations', queue);
    Logger.debug('Added operation to queue. Size: ${queue.length}/$maxQueueSize');
  }
  
  /// Get current queue
  Future<List<Map<String, dynamic>>> getQueue() async {
    await init();
    
    final stored = _box?.get('operations') as List<dynamic>?;
    if (stored == null) return [];
    
    return stored
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
  
  /// Remove operation from queue
  Future<void> removeOperation(String operationId) async {
    await init();
    
    final queue = await getQueue();
    queue.removeWhere((op) => op['id'] == operationId);
    
    await _box?.put('operations', queue);
    Logger.debug('Removed operation from queue. Size: ${queue.length}');
  }
  
  /// Get queue size
  Future<int> getQueueSize() async {
    final queue = await getQueue();
    return queue.length;
  }
  
  /// Clear entire queue
  Future<void> clearQueue() async {
    await init();
    await _box?.put('operations', []);
    Logger.info('Cleared offline queue');
  }
  
  /// Get remaining capacity
  Future<int> getRemainingCapacity() async {
    final size = await getQueueSize();
    return maxQueueSize - size;
  }
  
  /// Check if queue is full
  Future<bool> isFull() async {
    final size = await getQueueSize();
    return size >= maxQueueSize;
  }
}

/// Background Sync Manager
/// 
/// Manages background sync with battery optimization.
/// PRD Section 27: 15 minutes per hour limit for background sync.
class BackgroundSyncManager {
  static const Duration maxSyncDurationPerHour = Duration(minutes: 15);
  static const String _boxName = 'sync_tracking';
  
  Box<dynamic>? _box;
  
  /// Initialize the sync manager
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<dynamic>(_boxName);
    }
  }
  
  /// Check if sync is allowed (battery optimization)
  Future<bool> isSyncAllowed() async {
    await init();
    
    final now = DateTime.now();
    final hourStart = DateTime(now.year, now.month, now.day, now.hour);
    
    final syncDuration = await getSyncDurationThisHour(hourStart);
    
    return syncDuration < maxSyncDurationPerHour;
  }
  
  /// Record sync session
  Future<void> recordSyncSession(Duration duration) async {
    await init();
    
    final now = DateTime.now();
    final hourStart = DateTime(now.year, now.month, now.day, now.hour);
    final key = 'sync_${hourStart.toIso8601String()}';
    
    final currentDuration = await getSyncDurationThisHour(hourStart);
    final newDuration = currentDuration + duration;
    
    await _box?.put(key, newDuration.inMilliseconds);
    
    Logger.info('Recorded sync session: ${duration.inMinutes}m. Total this hour: ${newDuration.inMinutes}m/${maxSyncDurationPerHour.inMinutes}m');
  }
  
  /// Get sync duration for current hour
  Future<Duration> getSyncDurationThisHour(DateTime hourStart) async {
    await init();
    
    final key = 'sync_${hourStart.toIso8601String()}';
    final milliseconds = _box?.get(key) as int? ?? 0;
    
    return Duration(milliseconds: milliseconds);
  }
  
  /// Get remaining sync time for current hour
  Future<Duration> getRemainingSyncTime() async {
    final now = DateTime.now();
    final hourStart = DateTime(now.year, now.month, now.day, now.hour);
    
    final usedDuration = await getSyncDurationThisHour(hourStart);
    final remaining = maxSyncDurationPerHour - usedDuration;
    
    return remaining > Duration.zero ? remaining : Duration.zero;
  }
  
  /// Clean up old sync records (older than 24 hours)
  Future<void> cleanupOldRecords() async {
    await init();
    
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(hours: 24));
    
    final keys = _box?.keys.toList() ?? [];
    for (final key in keys) {
      if (key is String && key.startsWith('sync_')) {
        final timestamp = key.substring(5);
        final recordTime = DateTime.tryParse(timestamp);
        
        if (recordTime != null && recordTime.isBefore(cutoff)) {
          await _box?.delete(key);
        }
      }
    }
    
    Logger.debug('Cleaned up old sync records');
  }
}
