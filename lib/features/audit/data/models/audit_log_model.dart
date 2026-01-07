import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

/// Audit Log Model (PRD Section 3.18)
/// 
/// Immutable audit trail for all system actions.
/// Required for compliance and accountability tracking.
@freezed
class AuditLogModel with _$AuditLogModel {
  const AuditLogModel._();

  const factory AuditLogModel({
    required String id,
    required String orgId,
    required String entity,
    required String entityId,
    required String action,
    required String performedBy,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  /// Common entity types
  static const String entityVisit = 'visit';
  static const String entityQuote = 'quote';
  static const String entityInvoice = 'invoice';
  static const String entityUser = 'user';
  static const String entityInventory = 'inventory';
  static const String entityChat = 'chat';

  /// Common action types
  static const String actionCreate = 'create';
  static const String actionUpdate = 'update';
  static const String actionDelete = 'delete';
  static const String actionStatusChange = 'status_change';
  static const String actionRoleChange = 'role_change';

  /// Get formatted action description
  String get actionDescription {
    switch (action) {
      case actionCreate:
        return 'Created $entity';
      case actionUpdate:
        return 'Updated $entity';
      case actionDelete:
        return 'Deleted $entity';
      case actionStatusChange:
        final oldStatus = payload?['old_status'];
        final newStatus = payload?['new_status'];
        return 'Changed $entity status from $oldStatus to $newStatus';
      case actionRoleChange:
        final oldRole = payload?['old_role'];
        final newRole = payload?['new_role'];
        return 'Changed role from $oldRole to $newRole';
      default:
        return '$action on $entity';
    }
  }

  /// Get formatted timestamp
  String get formattedTimestamp {
    if (createdAt == null) return 'Unknown';
    return '${createdAt!.month}/${createdAt!.day}/${createdAt!.year} ${createdAt!.hour}:${createdAt!.minute.toString().padLeft(2, '0')}';
  }
}



