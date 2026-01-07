// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitModelImpl _$$VisitModelImplFromJson(Map<String, dynamic> json) =>
    _$VisitModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      jobId: json['job_id'] as String,
      technicianId: json['technician_id'] as String,
      scheduledStart: DateTime.parse(json['scheduled_start'] as String),
      scheduledEnd: DateTime.parse(json['scheduled_end'] as String),
      actualStart: json['actual_start'] == null
          ? null
          : DateTime.parse(json['actual_start'] as String),
      actualEnd: json['actual_end'] == null
          ? null
          : DateTime.parse(json['actual_end'] as String),
      status: $enumDecode(_$VisitStatusEnumMap, json['status']),
      statusReason: json['status_reason'] as String?,
      sequenceOrder: (json['sequence_order'] as num?)?.toInt(),
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      title: json['title'] as String?,
      address: json['address'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      signatureUrl: json['signature_url'] as String?,
    );

Map<String, dynamic> _$$VisitModelImplToJson(_$VisitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'job_id': instance.jobId,
      'technician_id': instance.technicianId,
      'scheduled_start': instance.scheduledStart.toIso8601String(),
      'scheduled_end': instance.scheduledEnd.toIso8601String(),
      'actual_start': instance.actualStart?.toIso8601String(),
      'actual_end': instance.actualEnd?.toIso8601String(),
      'status': _$VisitStatusEnumMap[instance.status]!,
      'status_reason': instance.statusReason,
      'sequence_order': instance.sequenceOrder,
      'version': instance.version,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'address': instance.address,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'signature_url': instance.signatureUrl,
    };

const _$VisitStatusEnumMap = {
  VisitStatus.scheduled: 'scheduled',
  VisitStatus.inProgress: 'in_progress',
  VisitStatus.paused: 'paused',
  VisitStatus.completed: 'completed',
  VisitStatus.cancelled: 'cancelled',
};
