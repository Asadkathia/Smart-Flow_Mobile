import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import 'package:smartflowpro/shared/presentation/widgets/signature_capture_widget.dart';
import '../../providers/visits_provider.dart';
import '../../providers/job_details_provider.dart';
import '../../../../quotes/presentation/providers/create_quotes_provider.dart';
import '../../../../invoices/presentation/providers/invoice_provider.dart';
import '../../../data/models/visit_model.dart';
import '../../providers/visit_documents_workflow_provider.dart';
import '../dialogs/post_completion_upload_dialog.dart';

class JobDetailsScheduleWidget extends ConsumerWidget {
  const JobDetailsScheduleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitId = ref.watch(selectedVisitIdProvider);

    // Fallback: use first visit from today's visits if no visitId
    final todayVisits = ref.watch(todayVisitsProvider).value;
    final effectiveVisitId =
        visitId ??
        (todayVisits?.isNotEmpty == true ? todayVisits!.first.id : null);

    if (effectiveVisitId == null) {
      return SizedBox.shrink();
    }

    final visitAsync = ref.watch(visitDetailsProvider(effectiveVisitId));

    return visitAsync.when(
      data: (visit) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _formatScheduleRange(visit.scheduledStart, visit.scheduledEnd),
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
          ),
          Text(
            'Arriving between ${_formatTime(visit.scheduledStart)} – ${_formatTime(visit.scheduledEnd)}',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              // Start Timer button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: visit.canStart
                      ? () async {
                          final success = await ref
                              .read(visitActionsProvider.notifier)
                              .startVisit(effectiveVisitId);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Visit started')),
                            );
                          }
                        }
                      : null,
                  icon: Icon(Icons.play_circle_outline, color: Colors.white),
                  label: Text(
                    'Start Timer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: visit.canStart
                        ? AppColors.primaryColor
                        : AppColors.greyColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Completed button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: visit.canComplete
                      ? () async {
                          // Validate visit can be completed
                          final validation = ValidationRules.canCompleteVisit(
                            currentStatus: visit.status,
                            hasSignature: false, // Will be captured below
                          );

                          if (!validation.isValid) {
                            if (context.mounted) {
                              context.showErrorSnackBar(
                                validation.errorMessage ??
                                    'Cannot complete visit',
                              );
                            }
                            return;
                          }

                          // Show signature capture dialog
                          final signaturePath = await showDialog<String>(
                            context: context,
                            builder: (context) => SignatureCaptureWidget(),
                          );

                          if (signaturePath == null) {
                            // User cancelled signature
                            return;
                          }

                          // Validate again with signature
                          final validationWithSignature =
                              ValidationRules.canCompleteVisit(
                                currentStatus: visit.status,
                                hasSignature: true,
                              );

                          if (!validationWithSignature.isValid) {
                            if (context.mounted) {
                              context.showErrorSnackBar(
                                validationWithSignature.errorMessage ??
                                    'Cannot complete visit',
                              );
                            }
                            return;
                          }

                          // Complete visit with signature
                          final success = await ref
                              .read(visitActionsProvider.notifier)
                              .completeVisit(
                                effectiveVisitId,
                                signaturePath: signaturePath,
                              );

                          if (success && context.mounted) {
                            context.showSuccessSnackBar('Visit completed');

                            // Show post-completion upload dialog
                            await showDialog(
                              context: context,
                              builder: (context) => PostCompletionUploadDialog(
                                visitId: effectiveVisitId,
                              ),
                            );
                          }
                        }
                      : null,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: visit.canComplete
                        ? AppColors.successGreen
                        : AppColors.greyColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // More button (Signature/Quote options)
              SizedBox(
                height: 48.h,
                width: 48.h,
                child: OutlinedButton(
                  onPressed: () {
                    _showMoreOptionsDialog(
                      context,
                      ref,
                      effectiveVisitId,
                      visit,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(Icons.more_horiz, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text(
        'Error loading schedule',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
      ),
    );
  }

  String _formatScheduleRange(DateTime start, DateTime end) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');

    final startDate = dateFormat.format(start);
    final startTime = timeFormat.format(start);
    final endTime = timeFormat.format(end);

    return '$startDate, $startTime – $endTime';
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  void _showMoreOptionsDialog(
    BuildContext context,
    WidgetRef ref,
    String visitId,
    VisitModel visit,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: AppColors.primaryColor),
              title: Text('Signature'),
              subtitle: Text('Capture customer signature'),
              onTap: () async {
                Navigator.pop(dialogContext);
                await _handleSignatureCapture(context, ref, visitId, visit);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.folder_copy_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text('Documents'),
              subtitle: Text('Manage quote and invoice'),
              onTap: () async {
                Navigator.pop(dialogContext);
                await _showDocumentsActionSheet(context, ref, visitId);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDocumentsActionSheet(
    BuildContext context,
    WidgetRef ref,
    String visitId,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    VisitDocumentsWorkflowState workflow;
    try {
      workflow = await ref.read(visitDocumentsWorkflowProvider(visitId).future);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        context.showErrorSnackBar('Failed to load document actions');
      }
      return;
    }

    if (!context.mounted) return;
    Navigator.pop(context);

    final actions = workflow.availableActions;
    if (actions.isEmpty) {
      context.showErrorSnackBar('No document actions available');
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Documents',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...actions.map(
              (action) => ListTile(
                title: Text(workflow.labelFor(action)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _runDocumentAction(
                    context: context,
                    ref: ref,
                    visitId: visitId,
                    workflow: workflow,
                    action: action,
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Future<void> _runDocumentAction({
    required BuildContext context,
    required WidgetRef ref,
    required String visitId,
    required VisitDocumentsWorkflowState workflow,
    required DocumentActionType action,
  }) async {
    switch (action) {
      case DocumentActionType.createQuote:
        ref.read(createQuotesProvider.notifier).reset();
        context.goToCreateQuotes(visitId, mode: 'create');
        break;
      case DocumentActionType.continueDraftQuote:
        if (workflow.draftQuoteId == null) return;
        context.goToCreateQuotes(
          visitId,
          mode: 'edit',
          quoteId: workflow.draftQuoteId,
        );
        break;
      case DocumentActionType.viewFinalizedQuote:
        if (workflow.finalizedQuoteId == null) return;
        context.goToQuoteDetails(workflow.finalizedQuoteId!);
        break;
      case DocumentActionType.createRevisionQuote:
        if (workflow.finalizedQuoteId == null) return;
        ref.read(createQuotesProvider.notifier).reset();
        context.goToCreateQuotes(
          visitId,
          mode: 'revision',
          sourceQuoteId: workflow.finalizedQuoteId,
        );
        break;
      case DocumentActionType.createInvoice:
        if (workflow.finalizedQuoteId == null) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        try {
          final invoice = await ref
              .read(invoiceActionsProvider.notifier)
              .createDraftFromQuote(workflow.finalizedQuoteId!);
          if (context.mounted) {
            Navigator.pop(context);
            if (invoice != null) {
              context.goToInvoicePreview(invoice.id);
            } else {
              context.showErrorSnackBar('Failed to create invoice');
            }
          }
        } catch (_) {
          if (context.mounted) {
            Navigator.pop(context);
            context.showErrorSnackBar('Failed to create invoice');
          }
        }
        break;
      case DocumentActionType.continueDraftInvoice:
        if (workflow.draftInvoiceId == null) return;
        context.goToInvoicePreview(workflow.draftInvoiceId!);
        break;
      case DocumentActionType.viewInvoice:
        if (workflow.finalizedInvoiceId == null) return;
        context.goToInvoicePreview(workflow.finalizedInvoiceId!);
        break;
    }
  }

  Future<void> _handleSignatureCapture(
    BuildContext context,
    WidgetRef ref,
    String visitId,
    VisitModel visit,
  ) async {
    // Show signature capture dialog
    final signaturePath = await showDialog<String>(
      context: context,
      builder: (context) => SignatureCaptureWidget(),
    );

    if (signaturePath == null) {
      // User cancelled signature
      return;
    }

    if (!context.mounted) return;

    // If visit can be completed, show option to complete
    if (visit.canComplete) {
      final shouldComplete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Complete Visit?'),
          content: Text(
            'Signature captured. Would you like to complete this visit now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Save Only'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
              ),
              child: Text('Complete Visit'),
            ),
          ],
        ),
      );

      if (shouldComplete == true && context.mounted) {
        // Complete visit with signature
        final success = await ref
            .read(visitActionsProvider.notifier)
            .completeVisit(visitId, signaturePath: signaturePath);

        if (success && context.mounted) {
          context.showSuccessSnackBar('Visit completed');

          // Show post-completion upload dialog
          await showDialog(
            context: context,
            builder: (context) => PostCompletionUploadDialog(visitId: visitId),
          );
        }
      } else if (context.mounted) {
        // Just save signature for later
        final success = await ref
            .read(visitActionsProvider.notifier)
            .saveSignature(visitId, signaturePath);
        if (success && context.mounted) {
          context.showSuccessSnackBar('Signature saved');
        }
      }
    } else {
      // Just save signature
      if (context.mounted) {
        final success = await ref
            .read(visitActionsProvider.notifier)
            .saveSignature(visitId, signaturePath);
        if (success && context.mounted) {
          context.showSuccessSnackBar('Signature saved');
        }
      }
    }
  }
}
