import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

/// Preferred Contact Method Enum (PRD Section 3.3)
enum PreferredContactMethod {
  @JsonValue('call')
  call,
  @JsonValue('sms')
  sms,
}

/// Customer Model (PRD Section 3.3)
/// 
/// Represents a customer in the system.
@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    required String name, // PRD: single name field (not first_name/last_name)
    String? phone, // E.164 format recommended
    String? email, // Must be valid email format if provided
    @JsonKey(name: 'preferred_contact_method')
    @Default(PreferredContactMethod.call)
    PreferredContactMethod preferredContactMethod, // PRD: required field
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Remove: first_name, last_name, alt_phone, company, notes, is_active (not in PRD)
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}

/// Extension methods for CustomerModel
extension CustomerModelX on CustomerModel {
  /// Get first name (derived from name for backward compatibility)
  String get firstName {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  /// Get last name (derived from name for backward compatibility)
  String get lastName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  /// Get full name (alias for name for backward compatibility)
  String get fullName => name;

  /// Get display name
  String get displayName => name;

  /// Get initials
  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    final first = parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '';
    final last = parts.length > 1 && parts.last.isNotEmpty 
        ? parts.last[0].toUpperCase() 
        : '';
    return '$first$last';
  }

  /// Check if customer has contact info
  bool get hasContactInfo => email != null || phone != null;
}



