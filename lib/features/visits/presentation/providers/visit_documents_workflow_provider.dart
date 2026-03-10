import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartflowpro/features/invoices/data/repositories/invoice_repository.dart';
import 'package:smartflowpro/features/quotes/data/repositories/quote_repository.dart';

enum VisitDocumentState { none, draft, finalized }

enum DocumentActionType {
  createQuote,
  continueDraftQuote,
  viewFinalizedQuote,
  createRevisionQuote,
  createInvoice,
  continueDraftInvoice,
  viewInvoice,
}

class VisitDocumentsWorkflowState {
  const VisitDocumentsWorkflowState({
    required this.quoteState,
    required this.invoiceState,
    this.quoteId,
    this.invoiceId,
    this.draftQuoteId,
    this.finalizedQuoteId,
    this.draftInvoiceId,
    this.finalizedInvoiceId,
  });

  final VisitDocumentState quoteState;
  final VisitDocumentState invoiceState;
  final String? quoteId;
  final String? invoiceId;
  final String? draftQuoteId;
  final String? finalizedQuoteId;
  final String? draftInvoiceId;
  final String? finalizedInvoiceId;

  bool get hasFinalizedQuote => finalizedQuoteId != null;
  bool get hasDraftQuote => draftQuoteId != null;
  bool get hasFinalizedInvoice => finalizedInvoiceId != null;
  bool get hasDraftInvoice => draftInvoiceId != null;

  List<DocumentActionType> get availableActions {
    final actions = <DocumentActionType>[];

    if (!hasDraftQuote && !hasFinalizedQuote) {
      actions.add(DocumentActionType.createQuote);
    }
    if (hasDraftQuote) {
      actions.add(DocumentActionType.continueDraftQuote);
    }
    if (hasFinalizedQuote) {
      actions.add(DocumentActionType.viewFinalizedQuote);
      if (!hasDraftQuote) {
        actions.add(DocumentActionType.createRevisionQuote);
      }
    }

    if (hasFinalizedQuote) {
      if (hasFinalizedInvoice) {
        actions.add(DocumentActionType.viewInvoice);
      } else if (hasDraftInvoice) {
        actions.add(DocumentActionType.continueDraftInvoice);
      } else {
        actions.add(DocumentActionType.createInvoice);
      }
    }

    return actions;
  }

  String labelFor(DocumentActionType action) {
    switch (action) {
      case DocumentActionType.createQuote:
        return 'Create Quote';
      case DocumentActionType.continueDraftQuote:
        return 'Continue Draft Quote';
      case DocumentActionType.viewFinalizedQuote:
        return 'View Finalized Quote';
      case DocumentActionType.createRevisionQuote:
        return 'Create Revision Quote';
      case DocumentActionType.createInvoice:
        return 'Create Invoice';
      case DocumentActionType.continueDraftInvoice:
        return 'Continue Draft Invoice';
      case DocumentActionType.viewInvoice:
        return 'View Invoice';
    }
  }
}

final visitDocumentsWorkflowProvider = FutureProvider.autoDispose
    .family<VisitDocumentsWorkflowState, String>((ref, visitId) async {
      final quoteRepository = ref.watch(quoteRepositoryProvider);
      final invoiceRepository = ref.watch(invoiceRepositoryProvider);

      final draftQuote = await quoteRepository.getLatestDraftQuoteByVisit(
        visitId,
      );
      final finalizedQuote = await quoteRepository
          .getLatestFinalizedQuoteByVisit(visitId);
      final draftInvoice = await invoiceRepository.getDraftInvoiceByVisit(
        visitId,
      );
      final finalizedInvoice = await invoiceRepository
          .getFinalizedInvoiceByVisit(visitId);

      final quoteState = draftQuote != null
          ? VisitDocumentState.draft
          : finalizedQuote != null
          ? VisitDocumentState.finalized
          : VisitDocumentState.none;
      final invoiceState = finalizedInvoice != null
          ? VisitDocumentState.finalized
          : draftInvoice != null
          ? VisitDocumentState.draft
          : VisitDocumentState.none;

      final activeQuoteId = draftQuote?.id ?? finalizedQuote?.id;
      final activeInvoiceId = finalizedInvoice?.id ?? draftInvoice?.id;

      return VisitDocumentsWorkflowState(
        quoteState: quoteState,
        invoiceState: invoiceState,
        quoteId: activeQuoteId,
        invoiceId: activeInvoiceId,
        draftQuoteId: draftQuote?.id,
        finalizedQuoteId: finalizedQuote?.id,
        draftInvoiceId: draftInvoice?.id,
        finalizedInvoiceId: finalizedInvoice?.id,
      );
    });
