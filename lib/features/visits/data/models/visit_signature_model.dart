import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit_signature_model.freezed.dart';
part 'visit_signature_model.g.dart';

/// Visit Signature Model (PRD Section 3.20)
/// 
/// Represents customer signatures captured during visit completion.
/// Required for completing a visit per PRD requirements.
@freezed
class VisitSignatureModel with _$VisitSignatureModel {
  const VisitSignatureModel._();

  const factory VisitSignatureModel({
    required String id,
    required String orgId,
    required String visitId,
    required String signedBy,
    required String signaturePath,
    DateTime? signedAt,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) = _VisitSignatureModel;

  factory VisitSignatureModel.fromJson(Map<String, dynamic> json) =>
      _$VisitSignatureModelFromJson(json);

  /// Check if signature is valid (has path and signer name)
  bool get isValid => signaturePath.isNotEmpty && signedBy.isNotEmpty;

  /// Get formatted signed date
  String get formattedSignedDate {
    if (signedAt == null) return 'Not signed';
    return '${signedAt!.month}/${signedAt!.day}/${signedAt!.year}';
  }
}



