import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_invitation_model.freezed.dart';
part 'employee_invitation_model.g.dart';

/// Employee invitation status
enum InvitationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('expired')
  expired,
}

/// Employee role types
enum EmployeeRole {
  @JsonValue('admin')
  admin,
  @JsonValue('dispatcher')
  dispatcher,
  @JsonValue('accountant')
  accountant,
  @JsonValue('technician')
  technician,
}

/// Employee Invitation Model (PRD Section 3.21)
/// 
/// Tracks employee invitations for team management.
/// Invitations expire after 7 days by default.
@freezed
class EmployeeInvitationModel with _$EmployeeInvitationModel {
  const EmployeeInvitationModel._();

  const factory EmployeeInvitationModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    required String email,
    String? phone,
    @JsonKey(name: 'full_name') String? fullName,
    required EmployeeRole role,
    @JsonKey(name: 'invited_by') required String invitedBy,
    required String token,
    @Default(InvitationStatus.pending) InvitationStatus status,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _EmployeeInvitationModel;

  factory EmployeeInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInvitationModelFromJson(json);

  /// Check if invitation is still valid
  bool get isValid {
    if (status != InvitationStatus.pending) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }

  /// Check if invitation has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Days until expiration
  int get daysUntilExpiry {
    if (expiresAt == null) return -1;
    final diff = expiresAt!.difference(DateTime.now());
    return diff.inDays;
  }

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case EmployeeRole.admin:
        return 'Admin';
      case EmployeeRole.dispatcher:
        return 'Dispatcher';
      case EmployeeRole.accountant:
        return 'Accountant';
      case EmployeeRole.technician:
        return 'Technician';
    }
  }

  /// Get status display name
  String get statusDisplayName {
    switch (status) {
      case InvitationStatus.pending:
        return 'Pending';
      case InvitationStatus.accepted:
        return 'Accepted';
      case InvitationStatus.expired:
        return 'Expired';
    }
  }
}


