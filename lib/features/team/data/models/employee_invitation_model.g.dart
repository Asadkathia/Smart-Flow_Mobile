// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeInvitationModelImpl _$$EmployeeInvitationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeInvitationModelImpl(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      role: $enumDecode(_$EmployeeRoleEnumMap, json['role']),
      invitedBy: json['invited_by'] as String,
      token: json['token'] as String,
      status: $enumDecodeNullable(_$InvitationStatusEnumMap, json['status']) ??
          InvitationStatus.pending,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$EmployeeInvitationModelImplToJson(
        _$EmployeeInvitationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'email': instance.email,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'role': _$EmployeeRoleEnumMap[instance.role]!,
      'invited_by': instance.invitedBy,
      'token': instance.token,
      'status': _$InvitationStatusEnumMap[instance.status]!,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$EmployeeRoleEnumMap = {
  EmployeeRole.admin: 'admin',
  EmployeeRole.dispatcher: 'dispatcher',
  EmployeeRole.accountant: 'accountant',
  EmployeeRole.technician: 'technician',
};

const _$InvitationStatusEnumMap = {
  InvitationStatus.pending: 'pending',
  InvitationStatus.accepted: 'accepted',
  InvitationStatus.expired: 'expired',
};
