// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobModelImpl _$$JobModelImplFromJson(Map<String, dynamic> json) =>
    _$JobModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      customerId: json['customer_id'] as String,
      propertyId: json['property_id'] as String,
      jobNumber: json['job_number'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: $enumDecode(_$JobStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$JobPriorityEnumMap, json['priority']) ??
          JobPriority.normal,
      serviceType: json['service_type'] as String?,
      estimatedDuration: (json['estimated_duration'] as num?)?.toInt(),
      actualDuration: (json['actual_duration'] as num?)?.toInt(),
      scheduledDate: json['scheduled_date'] == null
          ? null
          : DateTime.parse(json['scheduled_date'] as String),
      completedDate: json['completed_date'] == null
          ? null
          : DateTime.parse(json['completed_date'] as String),
      assignedTechnicianId: json['assigned_technician_id'] as String?,
      notes: json['notes'] as String?,
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      customer: json['customer'] == null
          ? null
          : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      property: json['property'] == null
          ? null
          : PropertyModel.fromJson(json['property'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$JobModelImplToJson(_$JobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'customer_id': instance.customerId,
      'property_id': instance.propertyId,
      'job_number': instance.jobNumber,
      'title': instance.title,
      'description': instance.description,
      'status': _$JobStatusEnumMap[instance.status]!,
      'priority': _$JobPriorityEnumMap[instance.priority]!,
      'service_type': instance.serviceType,
      'estimated_duration': instance.estimatedDuration,
      'actual_duration': instance.actualDuration,
      'scheduled_date': instance.scheduledDate?.toIso8601String(),
      'completed_date': instance.completedDate?.toIso8601String(),
      'assigned_technician_id': instance.assignedTechnicianId,
      'notes': instance.notes,
      'version': instance.version,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'customer': instance.customer,
      'property': instance.property,
    };

const _$JobStatusEnumMap = {
  JobStatus.pending: 'pending',
  JobStatus.scheduled: 'scheduled',
  JobStatus.inProgress: 'in_progress',
  JobStatus.completed: 'completed',
  JobStatus.cancelled: 'cancelled',
  JobStatus.onHold: 'on_hold',
};

const _$JobPriorityEnumMap = {
  JobPriority.low: 'low',
  JobPriority.normal: 'normal',
  JobPriority.high: 'high',
  JobPriority.urgent: 'urgent',
};
