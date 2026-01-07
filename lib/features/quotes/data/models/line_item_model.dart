import 'package:freezed_annotation/freezed_annotation.dart';

part 'line_item_model.freezed.dart';
part 'line_item_model.g.dart';

/// Line Item Type Enum (PRD Section 3.11)
enum LineItemType {
  @JsonValue('service')
  service,
  @JsonValue('material')
  material,
  @JsonValue('service_call_fee')
  service_call_fee,
  @JsonValue('discount')
  discount,
}

/// Line Item Model (PRD Section 3.11)
/// 
/// Represents a line item in a quote or invoice.
@freezed
class LineItemModel with _$LineItemModel {
  const factory LineItemModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    @JsonKey(name: 'quote_id') String? quoteId,
    @JsonKey(name: 'invoice_id') String? invoiceId,
    required LineItemType type,
    @JsonKey(name: 'reference_id') String? referenceId,
    required String description,
    required String unit,
    @JsonKey(name: 'qty') required int qty,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'taxable') required bool taxable,
    @Default(1) int version,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LineItemModel;

  factory LineItemModel.fromJson(Map<String, dynamic> json) =>
      _$LineItemModelFromJson(json);
}

/// Extension methods for LineItemModel
extension LineItemModelX on LineItemModel {
  /// Calculate line total
  double get total => qty * unitPrice;

  /// Get type display text
  String get typeText {
    switch (type) {
      case LineItemType.service:
        return 'Service';
      case LineItemType.material:
        return 'Material';
      case LineItemType.service_call_fee:
        return 'Service Call Fee';
      case LineItemType.discount:
        return 'Discount';
    }
  }

  /// Check if this is a service call fee
  bool get isServiceCallFee => type == LineItemType.service_call_fee;

  /// Create a copy with updated quantity
  LineItemModel withQty(int newQty) => copyWith(qty: newQty);

  /// Create a copy with updated unit price
  LineItemModel withUnitPrice(double newPrice) =>
      copyWith(unitPrice: newPrice);
}

/// Service Call Fee Factory (PRD Section 3.11)
class ServiceCallFee {
  static LineItemModel create({
    required String orgId,
    required double amount,
    String description = 'Service Call Fee',
    String unit = 'each',
  }) {
    return LineItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orgId: orgId,
      type: LineItemType.service_call_fee,
      description: description,
      unit: unit,
      qty: 1,
      unitPrice: amount,
      taxable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

