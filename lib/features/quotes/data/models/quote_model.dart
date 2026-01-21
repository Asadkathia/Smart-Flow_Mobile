import 'package:freezed_annotation/freezed_annotation.dart';
import 'line_item_model.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

/// Quote Status Enum (PRD Section 3.10)
enum QuoteStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('finalized')
  finalized,
  @JsonValue('invoiced')
  invoiced,
}

/// Quote Model (PRD Section 3.10)
/// 
/// Represents a quote/estimate for a job.
@freezed
class QuoteModel with _$QuoteModel {
  const factory QuoteModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'visit_id') required String visitId,
    @JsonKey(name: 'quote_number') required String quoteNumber,
    required QuoteStatus status,
    @Default(true) bool taxable,
    @Default(0.0) double subtotal,
    @Default(0.0) @JsonKey(name: 'discount_total') double discountTotal,
    @Default(0.0) @JsonKey(name: 'tax_total') double taxTotal,
    @Default(0.0) @JsonKey(name: 'grand_total') double grandTotal,
    @JsonKey(name: 'locked_at') DateTime? lockedAt,
    @JsonKey(name: 'locked_by') String? lockedBy,
    @Default(1) int version,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    String? notes,
    String? terms,
    @JsonKey(name: 'expiration_date') DateTime? expirationDate,

    // Relations
    @Default([]) List<LineItemModel> lineItems,
  }) = _QuoteModel;

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);
}

/// Extension methods for QuoteModel
extension QuoteModelX on QuoteModel {
  /// Get status display text
  String get statusText {
    switch (status) {
      case QuoteStatus.draft:
        return 'Draft';
      case QuoteStatus.finalized:
        return 'Finalized';
      case QuoteStatus.invoiced:
        return 'Invoiced';
    }
  }

  /// Check if quote can be edited
  bool get canEdit => status == QuoteStatus.draft;

  /// Check if quote can be finalized
  bool get canFinalize => status == QuoteStatus.draft;

  /// Check if quote can be invoiced
  bool get canInvoice => status == QuoteStatus.finalized;

  /// Check if quote is locked
  bool get isLocked => lockedAt != null;

  /// Check if quote is active
  bool get isActive => status == QuoteStatus.draft || status == QuoteStatus.finalized;

  /// Get service items only
  List<LineItemModel> get serviceItems =>
      lineItems.where((item) => item.type == LineItemType.service).toList();

  /// Get material items only
  List<LineItemModel> get materialItems =>
      lineItems.where((item) => item.type == LineItemType.material).toList();

  /// Get service call fee items only
  List<LineItemModel> get serviceCallFeeItems =>
      lineItems.where((item) => item.type == LineItemType.service_call_fee).toList();

  /// Calculate subtotal from line items
  double get calculatedSubtotal =>
      lineItems.fold(0.0, (sum, item) => sum + item.total);

  /// Calculate tax (PRD Section 18)
  /// 
  /// [taxRate] should be provided from BillingSettings (e.g., 0.082 for 8.2%)
  double calculateTax(double taxRate) {
    if (!taxable) return 0.0;

    // Get taxable items only
    final taxableItems = lineItems.where((item) =>
        item.type != LineItemType.discount && item.taxable);

    final taxableSubtotal = taxableItems.fold(0.0, (sum, item) => sum + item.total);

    return taxableSubtotal * taxRate;
  }

  /// Calculate total
  /// 
  /// [taxRate] should be provided from BillingSettings (e.g., 0.082 for 8.2%)
  double calculateTotal(double taxRate) => calculatedSubtotal + calculateTax(taxRate) - discountTotal;
}

