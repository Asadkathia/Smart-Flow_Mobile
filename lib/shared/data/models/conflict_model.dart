/// Conflict Resolution Strategy Enum
/// 
/// Defines how to resolve conflicts when local and server versions differ.
enum ConflictResolutionStrategy {
  /// Use server version (discard local changes)
  serverWins,
  
  /// Use local version (force local changes)
  clientWins,
  
  /// Manual merge required (user must resolve)
  manualMerge,
}

/// Conflict Information Model
/// 
/// Contains information about a data conflict detected during mutation.
class ConflictInfo {
  /// Entity ID that has the conflict
  final String entityId;
  
  /// Local version number
  final int localVersion;
  
  /// Server version number
  final int serverVersion;
  
  /// Local data (as JSON)
  final Map<String, dynamic> localData;
  
  /// Server data (as JSON)
  final Map<String, dynamic> serverData;
  
  /// Entity type (e.g., 'visit', 'quote', 'invoice')
  final String entityType;
  
  /// Timestamp when conflict was detected
  final DateTime detectedAt;

  const ConflictInfo({
    required this.entityId,
    required this.localVersion,
    required this.serverVersion,
    required this.localData,
    required this.serverData,
    required this.entityType,
    required this.detectedAt,
  });

  /// Check if conflict exists (versions don't match)
  bool get hasConflict => localVersion != serverVersion;

  /// Get conflict message
  String get message => 
      'Conflict detected: Local version ($localVersion) differs from server version ($serverVersion)';

  @override
  String toString() => 
      'ConflictInfo(entityId: $entityId, localVersion: $localVersion, serverVersion: $serverVersion, entityType: $entityType)';
}

/// Conflict Exception
/// 
/// Thrown when a conflict is detected during mutation.
class ConflictException implements Exception {
  final ConflictInfo conflictInfo;

  const ConflictException(this.conflictInfo);

  @override
  String toString() => 'ConflictException: ${conflictInfo.message}';
}



