import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_settings_model.freezed.dart';
part 'billing_settings_model.g.dart';

/// Billing Settings Model (PRD Section 3.9)
/// 
/// Organization-level billing configuration including
/// service call fees and tax rates.
@freezed
class BillingSettingsModel with _$BillingSettingsModel {
  const BillingSettingsModel._();

  const factory BillingSettingsModel({
    required String id,
    required String orgId,
    @Default(0.0) double serviceCallFee,
    @Default(0.0) double taxRate,
    String? currency,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) = _BillingSettingsModel;

  factory BillingSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$BillingSettingsModelFromJson(json);

  /// Tax rate as percentage (e.g., 0.16 = 16%)
  double get taxPercentage => taxRate * 100;

  /// Calculate tax for an amount
  double calculateTax(double amount) => amount * taxRate;

  /// Calculate total with tax
  double calculateTotalWithTax(double subtotal) => subtotal + calculateTax(subtotal);
}



