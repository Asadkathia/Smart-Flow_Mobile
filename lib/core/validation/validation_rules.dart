import '../../features/visits/data/models/visit_model.dart';
import '../../features/quotes/data/models/quote_model.dart';
import '../../features/invoices/data/models/invoice_model.dart';

/// Validation Rules (PRD Section 17 & 18)
/// 
/// Centralized validation logic for state transitions and business rules.
/// These rules should be enforced both client-side and server-side.
class ValidationRules {
  ValidationRules._();

  // ============================================
  // VISIT STATE MACHINE (PRD Section 17)
  // ============================================

  /// Valid visit state transitions
  static const Map<VisitStatus, List<VisitStatus>> _visitTransitions = {
    VisitStatus.scheduled: [VisitStatus.inProgress, VisitStatus.cancelled],
    VisitStatus.inProgress: [VisitStatus.paused, VisitStatus.completed, VisitStatus.cancelled],
    VisitStatus.paused: [VisitStatus.inProgress, VisitStatus.completed, VisitStatus.cancelled],
    VisitStatus.completed: [], // Terminal state - no transitions allowed
    VisitStatus.cancelled: [], // Terminal state - no transitions allowed
  };

  /// Check if a visit state transition is valid
  static bool canTransitionVisit(VisitStatus from, VisitStatus to) {
    final allowedTransitions = _visitTransitions[from];
    return allowedTransitions?.contains(to) ?? false;
  }

  /// Get allowed transitions for a visit status
  static List<VisitStatus> getAllowedVisitTransitions(VisitStatus status) {
    return _visitTransitions[status] ?? [];
  }

  /// Validate visit completion requirements
  static ValidationResult canCompleteVisit({
    required VisitStatus currentStatus,
    required bool hasSignature,
  }) {
    if (currentStatus == VisitStatus.completed) {
      return ValidationResult.failure('Visit is already completed');
    }
    
    if (currentStatus == VisitStatus.cancelled) {
      return ValidationResult.failure('Cannot complete a cancelled visit');
    }
    
    if (currentStatus == VisitStatus.scheduled) {
      return ValidationResult.failure('Visit must be started before completion');
    }
    
    if (!hasSignature) {
      return ValidationResult.failure('Signature required for visit completion');
    }
    
    return ValidationResult.success();
  }

  // ============================================
  // QUOTE STATE MACHINE (PRD Section 17)
  // ============================================

  /// Valid quote state transitions
  static const Map<QuoteStatus, List<QuoteStatus>> _quoteTransitions = {
    QuoteStatus.draft: [QuoteStatus.finalized],
    QuoteStatus.finalized: [QuoteStatus.invoiced],
    QuoteStatus.invoiced: [], // Terminal state
  };

  /// Check if a quote state transition is valid
  static bool canTransitionQuote(QuoteStatus from, QuoteStatus to) {
    final allowedTransitions = _quoteTransitions[from];
    return allowedTransitions?.contains(to) ?? false;
  }

  /// Validate quote finalization requirements
  static ValidationResult canFinalizeQuote({
    required QuoteStatus currentStatus,
    required int lineItemCount,
    required bool hasServiceCallFee,
  }) {
    if (currentStatus != QuoteStatus.draft) {
      return ValidationResult.failure('Only draft quotes can be finalized');
    }
    
    if (lineItemCount == 0) {
      return ValidationResult.failure('Quote must have at least one line item');
    }
    
    if (!hasServiceCallFee) {
      return ValidationResult.failure('Service call fee is required');
    }
    
    return ValidationResult.success();
  }

  /// Check if quote can be edited
  static bool canEditQuote(QuoteStatus status) {
    return status == QuoteStatus.draft;
  }

  // ============================================
  // INVOICE STATE MACHINE (PRD Section 17)
  // ============================================

  /// Valid invoice state transitions
  static const Map<InvoiceStatus, List<InvoiceStatus>> _invoiceTransitions = {
    InvoiceStatus.draft: [InvoiceStatus.unpaid],
    InvoiceStatus.unpaid: [InvoiceStatus.partiallyPaid, InvoiceStatus.paid, InvoiceStatus.void_],
    InvoiceStatus.partiallyPaid: [InvoiceStatus.paid],
    InvoiceStatus.paid: [InvoiceStatus.refunded],
    InvoiceStatus.void_: [], // Terminal state
    InvoiceStatus.refunded: [], // Terminal state
  };

  /// Check if an invoice state transition is valid
  static bool canTransitionInvoice(InvoiceStatus from, InvoiceStatus to) {
    final allowedTransitions = _invoiceTransitions[from];
    return allowedTransitions?.contains(to) ?? false;
  }

  /// Validate invoice finalization
  static ValidationResult canFinalizeInvoice(InvoiceStatus currentStatus) {
    if (currentStatus != InvoiceStatus.draft) {
      return ValidationResult.failure('Only draft invoices can be finalized');
    }
    return ValidationResult.success();
  }

  /// Check if invoice can be edited
  static bool canEditInvoice(InvoiceStatus status) {
    return status == InvoiceStatus.draft;
  }

  /// Validate payment recording
  static ValidationResult canRecordPayment({
    required InvoiceStatus currentStatus,
    required double amount,
    required double remainingBalance,
  }) {
    if (currentStatus == InvoiceStatus.draft) {
      return ValidationResult.failure('Cannot record payment on draft invoice');
    }
    
    if (currentStatus == InvoiceStatus.paid) {
      return ValidationResult.failure('Invoice is already fully paid');
    }
    
    if (currentStatus == InvoiceStatus.void_) {
      return ValidationResult.failure('Cannot record payment on voided invoice');
    }
    
    if (currentStatus == InvoiceStatus.refunded) {
      return ValidationResult.failure('Cannot record payment on refunded invoice');
    }
    
    if (amount <= 0) {
      return ValidationResult.failure('Payment amount must be greater than zero');
    }
    
    if (amount > remainingBalance) {
      return ValidationResult.failure(
        'Payment amount exceeds remaining balance of \$${remainingBalance.toStringAsFixed(2)}'
      );
    }
    
    return ValidationResult.success();
  }

  // ============================================
  // TAX CALCULATION (PRD Section 18)
  // ============================================

  /// Calculate tax for a quote
  /// 
  /// Rules:
  /// - If quote.taxable = false: tax_total = 0
  /// - If quote.taxable = true:
  ///   - service, material, service_call_fee are taxable
  ///   - discount is never taxable
  ///   - Apply discount proportionally to taxable items
  static double calculateTax({
    required bool quoteTaxable,
    required double taxRate,
    required double servicesTotal,
    required double materialsTotal,
    required double serviceCallFee,
    required double discountTotal,
  }) {
    if (!quoteTaxable || taxRate == 0) {
      return 0.0;
    }
    
    final taxableSubtotal = servicesTotal + materialsTotal + serviceCallFee;
    final subtotal = taxableSubtotal - discountTotal.abs();
    
    if (subtotal <= 0) {
      return 0.0;
    }
    
    // Calculate discount ratio
    final discountRatio = discountTotal.abs() / (taxableSubtotal + discountTotal.abs());
    final taxableDiscount = taxableSubtotal * discountRatio;
    
    // Tax = (taxable items) - (proportional discount applied to taxable items)
    final taxableAmount = taxableSubtotal - taxableDiscount;
    return taxableAmount * taxRate;
  }

  // ============================================
  // LINE ITEM VALIDATION
  // ============================================

  /// Check if a line item can be deleted
  static ValidationResult canDeleteLineItem({
    required String lineItemType,
    required QuoteStatus quoteStatus,
  }) {
    if (quoteStatus != QuoteStatus.draft) {
      return ValidationResult.failure('Cannot delete line items from finalized quotes');
    }
    
    if (lineItemType == 'service_call_fee') {
      return ValidationResult.failure('Service call fee cannot be deleted');
    }
    
    return ValidationResult.success();
  }

  /// Check if a line item can be edited
  static ValidationResult canEditLineItem({
    required String lineItemType,
    required QuoteStatus quoteStatus,
  }) {
    if (quoteStatus != QuoteStatus.draft) {
      return ValidationResult.failure('Cannot edit line items on finalized quotes');
    }
    
    if (lineItemType == 'service_call_fee') {
      return ValidationResult.failure('Service call fee cannot be modified');
    }
    
    return ValidationResult.success();
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
  });

  factory ValidationResult.success() {
    return const ValidationResult._(isValid: true);
  }

  factory ValidationResult.failure(String message) {
    return ValidationResult._(isValid: false, errorMessage: message);
  }
}

