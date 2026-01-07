import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../quotes/data/models/line_item_model.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

/// Invoice Status Enum
enum InvoiceStatus {
  draft,
  unpaid,
  @JsonValue('partially_paid')
  partiallyPaid,
  paid,
  void_,
  refunded,
}

/// Invoice Model
/// 
/// Represents an invoice that can be created from a finalized quote.
/// Technicians can create draft invoices and preview them before finalizing.
@freezed
class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId,
    required String visitId,
    String? quoteId,
    required String invoiceNumber,
    required InvoiceStatus status,
    required double total,
    required double subtotal,
    required double taxAmount,
    required List<LineItemModel> lineItems,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? propertyAddress,
    String? visitTitle,
    String? notes,
    DateTime? dueDate,
    DateTime? paidAt,
    @Default(1) int version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}

/// Invoice with computed properties
extension InvoiceModelX on InvoiceModel {
  /// Get status text
  String get statusText {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.unpaid:
        return 'Unpaid';
      case InvoiceStatus.partiallyPaid:
        return 'Partially Paid';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.void_:
        return 'Void';
      case InvoiceStatus.refunded:
        return 'Refunded';
    }
  }

  /// Check if invoice is editable
  bool get isEditable => status == InvoiceStatus.draft;

  /// Check if invoice can be finalized
  bool get canFinalize => status == InvoiceStatus.draft && lineItems.isNotEmpty;

  /// Check if invoice can be voided
  bool get canVoid => status == InvoiceStatus.unpaid;

  /// Check if invoice is finalized (not draft)
  bool get isFinalized => status != InvoiceStatus.draft;

  /// Get remaining balance (for partially paid invoices)
  double get remainingBalance {
    if (status == InvoiceStatus.partiallyPaid) {
      // TODO: Calculate from payments when payment model is integrated
      return total * 0.5; // Mock: assume 50% paid
    }
    return status == InvoiceStatus.unpaid ? total : 0.0;
  }

  /// Get paid amount
  double get paidAmount {
    if (status == InvoiceStatus.paid) return total;
    if (status == InvoiceStatus.partiallyPaid) {
      return total - remainingBalance;
    }
    return 0.0;
  }
}

/// Payment Model (for recording payments against invoices)
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String invoiceId,
    required double amount,
    required PaymentMethod method,
    String? reference,
    String? receivedBy,
    DateTime? receivedAt,
    DateTime? createdAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

/// Payment Method Enum
enum PaymentMethod {
  cash,
  @JsonValue('bank_transfer')
  bankTransfer,
  card,
  @JsonValue('stripe_link')
  stripeLink,
}

extension PaymentMethodX on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.stripeLink:
        return 'Stripe Link';
    }
  }
}
