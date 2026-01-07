import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

/// Property Model (PRD Section 3.4)
/// 
/// Represents a service location/property.
@freezed
class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'address_line1') required String addressLine1,
    @JsonKey(name: 'address_line2') String? addressLine2,
    required String city,
    required String state,
    @JsonKey(name: 'postal_code') required String postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? notes,
    @JsonKey(name: 'access_instructions') String? accessInstructions,
    @Default(true) @JsonKey(name: 'is_primary') bool isPrimary,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}

/// Extension methods for PropertyModel
extension PropertyModelX on PropertyModel {
  /// Get full address
  String get fullAddress {
    final parts = <String>[addressLine1];
    if (addressLine2?.isNotEmpty == true) parts.add(addressLine2!);
    parts.add('$city, $state $postalCode');
    if (country?.isNotEmpty == true) parts.add(country!);
    return parts.join('\n');
  }

  /// Get short address (one line)
  String get shortAddress => '$addressLine1, $city, $state';

  /// Check if has coordinates
  bool get hasCoordinates => latitude != null && longitude != null;
}



