import 'package:freezed_annotation/freezed_annotation.dart';
import 'customer_model.dart';
import 'property_model.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

/// Job Status Enum
enum JobStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('on_hold')
  onHold,
}

/// Job Priority Enum
enum JobPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Job Model (PRD Section 3.5)
/// 
/// Represents a job/work order in the system.
@freezed
class JobModel with _$JobModel {
  const factory JobModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'property_id') required String propertyId,
    @JsonKey(name: 'job_number') String? jobNumber,
    required String title,
    String? description,
    required JobStatus status,
    @Default(JobPriority.normal) JobPriority priority,
    @JsonKey(name: 'service_type') String? serviceType,
    @JsonKey(name: 'estimated_duration') int? estimatedDuration,
    @JsonKey(name: 'actual_duration') int? actualDuration,
    @JsonKey(name: 'scheduled_date') DateTime? scheduledDate,
    @JsonKey(name: 'completed_date') DateTime? completedDate,
    @JsonKey(name: 'assigned_technician_id') String? assignedTechnicianId,
    String? notes,
    @Default(1) int version,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    
    // Relations
    CustomerModel? customer,
    PropertyModel? property,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}

/// Extension methods for JobModel
extension JobModelX on JobModel {
  /// Get status display text
  String get statusText {
    switch (status) {
      case JobStatus.pending:
        return 'Pending';
      case JobStatus.scheduled:
        return 'Scheduled';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
      case JobStatus.onHold:
        return 'On Hold';
    }
  }

  /// Get priority display text
  String get priorityText {
    switch (priority) {
      case JobPriority.low:
        return 'Low';
      case JobPriority.normal:
        return 'Normal';
      case JobPriority.high:
        return 'High';
      case JobPriority.urgent:
        return 'Urgent';
    }
  }

  /// Check if job is active
  bool get isActive => status == JobStatus.inProgress;

  /// Check if job is completed
  bool get isCompleted => status == JobStatus.completed;

  /// Get estimated duration in hours
  double? get estimatedHours => 
      estimatedDuration != null ? estimatedDuration! / 60 : null;

  /// Get actual duration in hours
  double? get actualHours => 
      actualDuration != null ? actualDuration! / 60 : null;
}



