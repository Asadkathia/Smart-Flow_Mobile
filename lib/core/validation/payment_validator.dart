import '../../features/invoices/data/models/invoice_model.dart';
import '../errors/app_exceptions.dart';

/// Payment Validator
///
/// Validates payment operations per PRD Section 18 requirements.
class PaymentValidator {
  PaymentValidator._();

  /// Validate payment amount
  ///
  /// PRD Rule: Payment amount must be > 0
  static void validateAmount(double amount) {
    if (amount <= 0) {
      throw ValidationException.paymentAmountError();
    }
  }

  /// Validate payment doesn't exceed remaining balance
  ///
  /// PRD Rule: Payment amount cannot exceed remaining invoice balance.
  /// Sum of all payments for an invoice cannot exceed invoice total.
  static void validatePaymentAmount(
    double paymentAmount,
    InvoiceModel invoice,
    List<PaymentModel> existingPayments,
  ) {
    validateAmount(paymentAmount);

    // Calculate total paid amount
    final totalPaid = existingPayments.fold<double>(
      0.0,
      (sum, payment) => sum + payment.amount,
    );

    // Calculate remaining balance
    final remainingBalance = invoice.total - totalPaid;

    // Validate payment doesn't exceed remaining balance
    if (paymentAmount > remainingBalance) {
      throw ValidationException.paymentExceedsBalanceError(remainingBalance);
    }

    // Validate total payments don't exceed invoice total
    final newTotalPaid = totalPaid + paymentAmount;
    if (newTotalPaid > invoice.total) {
      throw ValidationException.paymentExceedsBalanceError(remainingBalance);
    }
  }

  /// Calculate remaining balance for an invoice
  ///
  /// Returns the amount still owed on the invoice.
  static double calculateRemainingBalance(
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

  /// Validate invoice can receive payment
  ///
  /// PRD Rule: Only unpaid or partially_paid invoices can receive payments.
  static void validateCanReceivePayment(InvoiceModel invoice) {
    if (invoice.status == InvoiceStatus.paid) {
      throw ValidationException(
        message: 'Invoice is already fully paid.',
        code: 'INVOICE_ALREADY_PAID',
      );
    }

    if (invoice.status == InvoiceStatus.void_) {
      throw ValidationException(
        message: 'Cannot record payment for voided invoice.',
        code: 'INVOICE_VOIDED',
      );
    }

    if (invoice.status == InvoiceStatus.draft) {
      throw ValidationException(
        message:
            'Cannot record payment for draft invoice. Please finalize the invoice first.',
        code: 'INVOICE_DRAFT',
      );
    }
  }
}
