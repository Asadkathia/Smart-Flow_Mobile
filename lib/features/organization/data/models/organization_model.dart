import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

/// Organization Model (PRD Section 3.1)
/// 
/// Represents a company/organization in the multi-tenant system.
/// All data is scoped by org_id for tenant isolation.
@freezed
class OrganizationModel with _$OrganizationModel {
  const OrganizationModel._();

  const factory OrganizationModel({
    required String id,
    required String name,
    @Default('America/New_York') String timezone,
    @Default('USD') String currency,
    @JsonKey(name: 'org_prefix') String? orgPrefix,
    String? plan,
    @Default({}) Map<String, dynamic> settings,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);

  /// Get file size limit from settings
  int get maxImageSizeMb => (settings['file_size_limits']?['images'] as int?) ?? 10;
  int get maxPdfSizeMb => (settings['file_size_limits']?['pdfs'] as int?) ?? 25;
  int get maxVideoSizeMb => (settings['file_size_limits']?['videos'] as int?) ?? 100;

  /// Get AI rate limits from settings
  int get aiRequestsPerHour => (settings['ai_rate_limits']?['requests_per_hour'] as int?) ?? 100;

  /// Get notification preferences
  bool get pushNotificationsEnabled => settings['notification_preferences']?['push'] ?? true;
  bool get emailNotificationsEnabled => settings['notification_preferences']?['email'] ?? true;
}


