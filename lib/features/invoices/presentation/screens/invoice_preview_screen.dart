import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../data/models/invoice_model.dart';
import '../../../quotes/data/models/line_item_model.dart';
import '../providers/invoice_provider.dart';
import 'package:smartflowpro/core/validation/validation_rules.dart';
import 'package:smartflowpro/shared/presentation/widgets/standard_states.dart';
import '../widgets/record_payment_dialog.dart';

/// Invoice Preview Screen
///
/// Displays a formatted invoice with print and share functionality.
class InvoicePreviewScreen extends ConsumerWidget {
  final String invoiceId;

  const InvoicePreviewScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));
    final paymentsAsync = ref.watch(invoicePaymentsProvider(invoiceId));
    final collectorsAsync = ref.watch(
      invoicePaymentCollectorsProvider(invoiceId),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          'Invoice Preview',
          style: AppTextStyles.heading3.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 22.sp,
          ),
          iconSize: 22.sp,
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.whiteColor),
            onSelected: (value) {
              switch (value) {
                case 'print':
                  _printInvoice(context);
                  break;
                case 'share':
                  _shareInvoice(context);
                  break;
                case 'finalize':
                  if (invoiceAsync.value?.canFinalize ?? false) {
                    _finalizeInvoice(context, ref, invoiceAsync.value!);
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Icons.print, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text('Print'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text('Share'),
                  ],
                ),
              ),
              if (invoiceAsync.value?.canFinalize ?? false)
                PopupMenuItem(
                  value: 'finalize',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20.sp),
                      SizedBox(width: 12.w),
                      Text('Finalize Invoice'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: invoiceAsync.when(
        data: (invoice) {
          final payments = paymentsAsync.valueOrNull ?? const <PaymentModel>[];
          final collectors =
              collectorsAsync.valueOrNull ?? const <String, String>{};
          final paidAmount = payments.fold<double>(
            0.0,
            (sum, payment) => sum + payment.amount,
          );
          final remainingBalance = (invoice.total - paidAmount)
              .clamp(0.0, invoice.total)
              .toDouble();

          return SingleChildScrollView(
            child: _buildInvoiceContent(
              context,
              ref,
              invoice,
              payments: payments,
              collectors: collectors,
              paidAmount: paidAmount,
              remainingBalance: remainingBalance,
            ),
          );
        },
        loading: () => StandardLoadingState(message: 'Loading invoice...'),
        error: (error, stack) => StandardErrorState(
          title: 'Failed to load invoice',
          message: 'Please try again',
          onRetry: () => ref.invalidate(invoiceDetailProvider(invoiceId)),
        ),
      ),
    );
  }

  Widget _buildInvoiceContent(
    BuildContext context,
    WidgetRef ref,
    InvoiceModel invoice, {
    required List<PaymentModel> payments,
    required Map<String, String> collectors,
    required double paidAmount,
    required double remainingBalance,
  }) {
    return Container(
      color: AppColors.whiteColor,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(invoice),
          SizedBox(height: 32.h),

          // Customer & Invoice Info Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Info
              Expanded(child: _buildCustomerSection(invoice)),
              SizedBox(width: 32.w),
              // Invoice Info
              Expanded(child: _buildInvoiceInfoSection(invoice)),
            ],
          ),
          SizedBox(height: 32.h),

          // Line Items Table
          _buildLineItemsTable(invoice),
          SizedBox(height: 32.h),

          // Totals Section
          _buildTotalsSection(
            invoice,
            paidAmount: paidAmount,
            remainingBalance: remainingBalance,
          ),
          SizedBox(height: 32.h),

          // Payment History (audit log)
          if (payments.isNotEmpty) ...[
            _buildPaymentHistory(payments, collectors),
            SizedBox(height: 32.h),
          ],

          // Notes Section
          if (invoice.notes != null && invoice.notes!.isNotEmpty)
            _buildNotesSection(invoice.notes!),

          // Record Payment Button
          if (invoice.status != InvoiceStatus.paid &&
              invoice.status != InvoiceStatus.void_ &&
              invoice.status != InvoiceStatus.draft)
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _showRecordPaymentDialog(context, ref, invoice),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Record Payment',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(InvoiceModel invoice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INVOICE',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              invoice.invoiceNumber,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _getStatusColor(invoice.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _getStatusColor(invoice.status).withOpacity(0.3),
            ),
          ),
          child: Text(
            invoice.statusText.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getStatusColor(invoice.status),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSection(InvoiceModel invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bill To:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTextColor,
          ),
        ),
        SizedBox(height: 12.h),
        if (invoice.customerName != null)
          Text(
            invoice.customerName!,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        if (invoice.propertyAddress != null) ...[
          SizedBox(height: 4.h),
          Text(invoice.propertyAddress!, style: AppTextStyles.bodyMedium),
        ],
        if (invoice.customerEmail != null) ...[
          SizedBox(height: 4.h),
          Text(invoice.customerEmail!, style: AppTextStyles.bodyMedium),
        ],
        if (invoice.customerPhone != null) ...[
          SizedBox(height: 4.h),
          Text(invoice.customerPhone!, style: AppTextStyles.bodyMedium),
        ],
      ],
    );
  }

  Widget _buildInvoiceInfoSection(InvoiceModel invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          'Invoice Date:',
          invoice.createdAt != null
              ? DateFormat('MMM d, yyyy').format(invoice.createdAt!)
              : 'N/A',
        ),
        if (invoice.dueDate != null)
          _buildInfoRow(
            'Due Date:',
            DateFormat('MMM d, yyyy').format(invoice.dueDate!),
          ),
        if (invoice.visitTitle != null)
          _buildInfoRow('Service:', invoice.visitTitle!),
        if (invoice.paidAt != null)
          _buildInfoRow(
            'Paid Date:',
            DateFormat('MMM d, yyyy').format(invoice.paidAt!),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItemsTable(InvoiceModel invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table Header
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Description',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Qty',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Unit',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Price',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                child: Text(
                  'Total',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // Table Rows
        ...invoice.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == invoice.lineItems.length - 1;

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(
                bottom: BorderSide(color: AppColors.lightGray, width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.description, style: AppTextStyles.bodyMedium),
                      if (item.type == LineItemType.material &&
                          item.referenceId != null)
                        Text(
                          'SKU: ${item.referenceId}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    item.qty.toString(),
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.unit,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '\$${item.unitPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    '\$${(item.qty * item.unitPrice).toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTotalsSection(
    InvoiceModel invoice, {
    required double paidAmount,
    required double remainingBalance,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal:', invoice.subtotal),
          if (invoice.taxAmount > 0) _buildTotalRow('Tax:', invoice.taxAmount),
          Divider(height: 24.h),
          _buildTotalRow('Total:', invoice.total, isTotal: true),
          if (invoice.status != InvoiceStatus.draft &&
              invoice.status != InvoiceStatus.void_ &&
              invoice.status != InvoiceStatus.refunded &&
              paidAmount > 0) ...[
            SizedBox(height: 8.h),
            _buildTotalRow('Paid:', paidAmount, color: AppColors.successGreen),
            _buildTotalRow(
              'Remaining:',
              remainingBalance,
              color: AppColors.errorRed,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isTotal = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.heading5.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: (isTotal ? AppTextStyles.heading5 : AppTextStyles.bodyMedium)
                .copyWith(
                  fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(notes, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory(
    List<PaymentModel> payments,
    Map<String, String> collectors,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment History',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 12.h),
          ...payments.map((payment) {
            final shortId = payment.receivedBy.length > 8
                ? payment.receivedBy.substring(0, 8)
                : payment.receivedBy;
            final collectedBy =
                collectors[payment.receivedBy] ?? 'Technician ($shortId)';
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${payment.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.successGreen,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'MMM d, yyyy • h:mm a',
                        ).format(payment.receivedAt),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Collected by: $collectedBy',
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    'Method: ${payment.method.displayName}',
                    style: AppTextStyles.bodySmall,
                  ),
                  if (payment.reference != null &&
                      payment.reference!.trim().isNotEmpty)
                    Text(
                      'Reference: ${payment.reference}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.draft:
        return AppColors.greyColor;
      case InvoiceStatus.unpaid:
        return Colors.orange;
      case InvoiceStatus.partiallyPaid:
        return Colors.blue;
      case InvoiceStatus.paid:
        return AppColors.successGreen;
      case InvoiceStatus.void_:
        return AppColors.errorRed;
      case InvoiceStatus.refunded:
        return Colors.purple;
    }
  }

  void _printInvoice(BuildContext context) {
    // TODO (Phase 2): Implement print functionality
    context.showSnackBar('Print functionality coming soon');
  }

  void _shareInvoice(BuildContext context) {
    // TODO (Phase 2): Implement share functionality (PDF generation)
    context.showSnackBar('Share functionality coming soon');
  }

  Future<void> _finalizeInvoice(
    BuildContext context,
    WidgetRef ref,
    InvoiceModel invoice,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finalize Invoice'),
        content: Text(
          'Are you sure you want to finalize this invoice? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text('Finalize'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await ref
          .read(invoiceActionsProvider.notifier)
          .finalize(invoice.id);
      if (result != null && context.mounted) {
        context.showSuccessSnackBar('Invoice finalized successfully');
        ref.invalidate(invoiceDetailProvider(invoiceId));
      } else if (context.mounted) {
        context.showErrorSnackBar('Failed to finalize invoice');
      }
    }
  }

  Future<void> _showRecordPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    InvoiceModel invoice,
  ) async {
    double remainingBalance = invoice.total;
    try {
      final payments = await ref.read(
        invoicePaymentsProvider(invoice.id).future,
      );
      final paidAmount = payments.fold<double>(
        0.0,
        (sum, payment) => sum + payment.amount,
      );
      remainingBalance = (invoice.total - paidAmount)
          .clamp(0.0, invoice.total)
          .toDouble();
    } catch (_) {
      // Keep fallback remaining value; server-side validation still prevents overpayment.
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => RecordPaymentDialog(
        remainingBalance: remainingBalance,
        onRecord: (amount, method, reference) async {
          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          try {
            await ref
                .read(invoiceActionsProvider.notifier)
                .recordPayment(
                  invoiceId: invoice.id,
                  amount: amount,
                  method: method,
                  reference: reference,
                );

            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading
              context.showSuccessSnackBar('Payment recorded successfully');
              // Refresh invoice details
              ref.invalidate(invoiceDetailProvider(invoiceId));
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading
              context.showErrorSnackBar('Failed to record payment: $e');
            }
          }
        },
      ),
    );
  }
}
