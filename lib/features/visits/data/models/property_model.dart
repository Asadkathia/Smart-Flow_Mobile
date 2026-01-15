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
    required String address, // PRD: single address field (text)
    double? latitude, // Valid range: -90 to 90
    double? longitude, // Valid range: -180 to 180
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Remove: address_line1, address_line2, city, state, postal_code, country, notes, access_instructions, is_primary (not in PRD)
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}

/// Extension methods for PropertyModel
extension PropertyModelX on PropertyModel {
  /// Get address components (for backward compatibility)
  /// Parses address string into components if needed
  Map<String, String?> get addressComponents {
    // Simple parsing - adjust based on your address format
    final parts = address.split(',');
    return {
      'line1': parts.isNotEmpty ? parts.first.trim() : null,
      'line2': parts.length > 3 ? parts[1].trim() : null,
      'city': parts.length > 2 ? parts[parts.length - 2].trim() : null,
      'state': parts.length > 1 ? parts[parts.length - 1].trim().split(' ').first : null,
      'postal_code': parts.length > 1 
          ? parts[parts.length - 1].trim().split(' ').length > 1 
              ? parts[parts.length - 1].trim().split(' ').last 
              : null 
          : null,
    };
  }

  /// Get full address (alias for address for backward compatibility)
  String get fullAddress => address;

  /// Get short address (one line)
  String get shortAddress {
    final parts = address.split(',');
    return parts.length > 2 
        ? '${parts.first.trim()}, ${parts[parts.length - 2].trim()}, ${parts.last.trim().split(' ').first}'
        : address;
  }

  /// Check if has coordinates
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Validate coordinates
  bool get hasValidCoordinates {
    if (latitude == null || longitude == null) return false;
    return latitude! >= -90 && latitude! <= 90 &&
           longitude! >= -180 && longitude! <= 180;
  }
}



