import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// Customer Model (PRD Section 3.3)
/// 
/// Represents a customer in the system.
@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? email,
    String? phone,
    @JsonKey(name: 'alt_phone') String? altPhone,
    String? company,
    String? notes,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}

/// Extension methods for CustomerModel
extension CustomerModelX on CustomerModel {
  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get display name (company or full name)
  String get displayName => company?.isNotEmpty == true ? company! : fullName;

  /// Get initials
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Check if customer has contact info
  bool get hasContactInfo => email != null || phone != null;
}



