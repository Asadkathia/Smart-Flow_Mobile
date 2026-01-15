import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_approval_model.freezed.dart';
part 'quote_approval_model.g.dart';

/// Approval Status Enum (PRD Section 3.22)
enum ApprovalStatus {
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

/// Approval Method Enum (PRD Section 3.22)
enum ApprovalMethod {
  @JsonValue('call')
  call,
  @JsonValue('sms')
  sms,
}

/// Quote Approval Model (PRD Section 3.22 - Optional)
/// 
/// For internal tracking of quote approvals/rejections.
/// Does not block invoice creation.
@freezed
class QuoteApprovalModel with _$QuoteApprovalModel {
  const factory QuoteApprovalModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'quote_id') required String quoteId,
    @JsonKey(name: 'approval_status') required ApprovalStatus approvalStatus, // approved | rejected
    required ApprovalMethod method, // call | sms
    @JsonKey(name: 'recorded_by') required String recordedBy, // User who recorded the approval
    @JsonKey(name: 'recorded_at') required DateTime recordedAt,
    String? notes, // Optional notes
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _QuoteApprovalModel;

  factory QuoteApprovalModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteApprovalModelFromJson(json);
}

/// Extension methods for QuoteApprovalModel
extension QuoteApprovalModelX on QuoteApprovalModel {
  /// Get approval status display text
  String get statusText {
    switch (approvalStatus) {
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  /// Get method display text
  String get methodText {
    switch (method) {
      case ApprovalMethod.call:
        return 'Call';
      case ApprovalMethod.sms:
        return 'SMS';
    }
  }
}

