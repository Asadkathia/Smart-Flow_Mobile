import '../../features/quotes/data/models/quote_model.dart';
import '../../features/quotes/data/models/line_item_model.dart';
import '../errors/app_exceptions.dart';

/// Quote Validator
/// 
/// Validates quote operations per PRD Section 18 requirements.
class QuoteValidator {
  QuoteValidator._();

  /// Validate quote can be finalized
  /// 
  /// PRD Rule: Quote must have at least one line item before finalization.
  /// Service call fee counts as a valid line item.
  static void validateCanFinalize(QuoteModel quote) {
    if (quote.lineItems.isEmpty) {
      throw ValidationException.quoteFinalizationError();
    }
  }

  /// Validate service call fee cannot be deleted
  /// 
  /// PRD Rule: Service call fee line item cannot be deleted or modified.
  static void validateServiceCallFeeDeletion(LineItemModel item) {
    if (item.type == LineItemType.service_call_fee) {
      throw ValidationException.serviceCallFeeLockedError();
    }
  }

  /// Validate service call fee cannot be modified
  /// 
  /// PRD Rule: Service call fee is locked once created.
  static void validateServiceCallFeeModification(LineItemModel item) {
    if (item.type == LineItemType.service_call_fee) {
      throw ValidationException.serviceCallFeeLockedError();
    }
  }

  /// Validate quote is editable
  /// 
  /// PRD Rule: Only draft quotes can be edited.
  static void validateCanEdit(QuoteModel quote) {
    if (quote.status != QuoteStatus.draft) {
      throw ValidationException(
        message: 'Only draft quotes can be edited.',
        code: 'QUOTE_NOT_EDITABLE',
      );
    }
  }

  /// Validate quote can be invoiced
  /// 
  /// PRD Rule: Only finalized quotes can be invoiced.
  static void validateCanInvoice(QuoteModel quote) {
    if (quote.status != QuoteStatus.finalized) {
      throw ValidationException(
        message: 'Only finalized quotes can be invoiced.',
        code: 'QUOTE_NOT_INVOICABLE',
      );
    }
  }

  /// Validate all line items are valid
  static void validateLineItems(List<LineItemModel> lineItems) {
    for (final item in lineItems) {
      if (item.qty <= 0) {
        throw ValidationException(
          message: 'Line item quantity must be greater than zero.',
          code: 'INVALID_QUANTITY',
        );
      }
      
      if (item.unitPrice < 0) {
        throw ValidationException(
          message: 'Line item unit price cannot be negative.',
          code: 'INVALID_UNIT_PRICE',
        );
      }
    }
  }
}


