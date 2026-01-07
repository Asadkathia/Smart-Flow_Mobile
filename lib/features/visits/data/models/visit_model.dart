import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_model.freezed.dart';
part 'visit_model.g.dart';

/// Visit Status Enum
enum VisitStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Visit Model (PRD Section 3.6)
/// 
/// Represents a technician visit to a customer location.
@freezed
class VisitModel with _$VisitModel {
  const factory VisitModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'job_id') required String jobId,
    @JsonKey(name: 'technician_id') required String technicianId,
    @JsonKey(name: 'scheduled_start') required DateTime scheduledStart,
    @JsonKey(name: 'scheduled_end') required DateTime scheduledEnd,
    @JsonKey(name: 'actual_start') DateTime? actualStart,
    @JsonKey(name: 'actual_end') DateTime? actualEnd,
    required VisitStatus status,
    @JsonKey(name: 'status_reason') String? statusReason,
    @JsonKey(name: 'sequence_order') int? sequenceOrder,
    @Default(1) int version,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    
    // Extended fields for UI
    String? title,
    String? address,
    String? customerName,
    String? customerPhone,
    double? latitude,
    double? longitude,
    String? notes,
    @JsonKey(name: 'signature_url') String? signatureUrl,
  }) = _VisitModel;

  factory VisitModel.fromJson(Map<String, dynamic> json) =>
      _$VisitModelFromJson(json);
}

/// Extension methods for VisitModel
extension VisitModelX on VisitModel {
  /// Check if visit is active
  bool get isActive => status == VisitStatus.inProgress || status == VisitStatus.paused;

  /// Check if visit can be started
  bool get canStart => status == VisitStatus.scheduled;

  /// Check if visit can be paused
  bool get canPause => status == VisitStatus.inProgress;

  /// Check if visit can be resumed
  bool get canResume => status == VisitStatus.paused;

  /// Check if visit can be completed
  bool get canComplete => status == VisitStatus.inProgress || status == VisitStatus.paused;

  /// Get status display text
  String get statusText {
    switch (status) {
      case VisitStatus.scheduled:
        return 'Scheduled';
      case VisitStatus.inProgress:
        return 'In Progress';
      case VisitStatus.paused:
        return 'Paused';
      case VisitStatus.completed:
        return 'Completed';
      case VisitStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get duration (actual or scheduled)
  Duration get duration {
    if (actualStart != null && actualEnd != null) {
      return actualEnd!.difference(actualStart!);
    }
    return scheduledEnd.difference(scheduledStart);
  }

  /// Get formatted time range
  String get timeRange {
    final start = _formatTime(scheduledStart);
    final end = _formatTime(scheduledEnd);
    return '$start - $end';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

