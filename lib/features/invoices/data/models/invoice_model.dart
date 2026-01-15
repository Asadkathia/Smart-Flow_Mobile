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
  /// 
  /// Note: This is a computed property. For accurate calculation,
  /// use PaymentValidator.calculateRemainingBalance() with actual payments list.
  double get remainingBalance {
    // This is a fallback calculation based on status
    // For accurate balance, fetch payments and use PaymentValidator
    if (status == InvoiceStatus.paid || status == InvoiceStatus.void_ || status == InvoiceStatus.refunded) {
      return 0.0;
    }
    if (status == InvoiceStatus.partiallyPaid) {
      // Cannot calculate without payments - return placeholder
      // Callers should use PaymentValidator.calculateRemainingBalance() with payments
      return total * 0.5; // Placeholder - should be calculated from payments
    }
    return status == InvoiceStatus.unpaid ? total : 0.0;
  }

  /// Get paid amount
  /// 
  /// Note: This is a computed property. For accurate calculation,
  /// use PaymentValidator with actual payments list.
  double get paidAmount {
    if (status == InvoiceStatus.paid) return total;
    if (status == InvoiceStatus.partiallyPaid) {
      // Cannot calculate without payments - return placeholder
      // Callers should fetch payments and calculate
      return total - remainingBalance;
    }
    return 0.0;
  }

  /// Calculate remaining balance from payments list
  /// 
  /// Use this method when you have the payments list available.
  static double calculateRemainingBalanceFromPayments(
    InvoiceModel invoice,
    List<PaymentModel> payments,
  ) {
    final totalPaid = payments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );
    final remaining = invoice.total - totalPaid;
    return remaining > 0 ? remaining : 0.0;
  }

  /// Calculate paid amount from payments list
  /// 
  /// Use this method when you have the payments list available.
  static double calculatePaidAmountFromPayments(List<PaymentModel> payments) {
    return payments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );
  }
}

/// Payment Model (PRD Section 3.13)
/// 
/// For recording payments against invoices.
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    @JsonKey(name: 'org_id') required String orgId, // PRD: required for multi-tenancy
    @JsonKey(name: 'invoice_id') required String invoiceId,
    required double amount, // Must be > 0, cannot exceed remaining invoice balance
    required PaymentMethod method, // cash, bank_transfer, card, stripe_link
    String? reference, // Optional reference number
    @JsonKey(name: 'received_by') required String receivedBy, // User who recorded the payment
    @JsonKey(name: 'received_at') required DateTime receivedAt, // When payment was received
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt, // PRD: required
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
