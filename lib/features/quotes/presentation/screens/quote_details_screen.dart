import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/line_item_model.dart';
import '../providers/quote_provider.dart';
import 'package:smartflowpro/shared/presentation/widgets/standard_states.dart';

/// Quote Details Screen
/// 
/// Displays a formatted quote with finalize and delete functionality.
class QuoteDetailsScreen extends ConsumerWidget {
  final String quoteId;

  const QuoteDetailsScreen({
    super.key,
    required this.quoteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteDetailProvider(quoteId));
    final actionsState = ref.watch(quoteActionsProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          'Quote Details',
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
                case 'finalize':
                  if (quoteAsync.value?.canFinalize ?? false) {
                    _finalizeQuote(context, ref, quoteAsync.value!);
                  }
                  break;
                case 'delete':
                  if (quoteAsync.value?.canEdit ?? false) {
                    _deleteQuote(context, ref, quoteAsync.value!);
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              if (quoteAsync.value?.canFinalize ?? false)
                PopupMenuItem(
                  value: 'finalize',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20.sp),
                      SizedBox(width: 12.w),
                      Text('Finalize Quote'),
                    ],
                  ),
                ),
              if (quoteAsync.value?.canEdit ?? false)
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20.sp, color: AppColors.errorRed),
                      SizedBox(width: 12.w),
                      Text(
                        'Delete Quote',
                        style: TextStyle(color: AppColors.errorRed),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: quoteAsync.when(
        data: (quote) => SingleChildScrollView(
          child: _buildQuoteContent(context, ref, quote),
        ),
        loading: () => StandardLoadingState(message: 'Loading quote...'),
        error: (error, stack) => StandardErrorState(
          title: 'Failed to load quote',
          message: 'Please try again',
          onRetry: () => ref.invalidate(quoteDetailProvider(quoteId)),
        ),
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context, WidgetRef ref, QuoteModel quote) {
    return Container(
      color: AppColors.whiteColor,
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(quote),
          SizedBox(height: 32.h),

          // Quote Info Section
          _buildQuoteInfoSection(quote),
          SizedBox(height: 32.h),

          // Line Items Table
          _buildLineItemsTable(quote),
          SizedBox(height: 32.h),

          // Totals Section
          _buildTotalsSection(quote),
        ],
      ),
    );
  }

  Widget _buildHeader(QuoteModel quote) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QUOTE',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primaryTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              quote.quoteNumber,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _getStatusColor(quote.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: _getStatusColor(quote.status).withOpacity(0.3),
            ),
          ),
          child: Text(
            quote.statusText.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getStatusColor(quote.status),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteInfoSection(QuoteModel quote) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Quote Date:', DateFormat('MMM d, yyyy').format(quote.createdAt)),
          _buildInfoRow('Last Updated:', DateFormat('MMM d, yyyy').format(quote.updatedAt)),
          if (quote.lockedAt != null)
            _buildInfoRow('Finalized At:', DateFormat('MMM d, yyyy h:mm a').format(quote.lockedAt!)),
          if (quote.version > 1)
            _buildInfoRow('Version:', quote.version.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
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

  Widget _buildLineItemsTable(QuoteModel quote) {
    if (quote.lineItems.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.lightGray.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            'No line items',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
          ),
        ),
      );
    }

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
              Expanded(flex: 3, child: Text('Description', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
              Expanded(child: Text('Qty', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(child: Text('Unit', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              Expanded(child: Text('Price', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
              Expanded(child: Text('Total', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.right)),
            ],
          ),
        ),
        // Table Rows
        ...quote.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightGray,
                  width: 1,
                ),
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
                      Text(
                        item.description,
                        style: AppTextStyles.bodyMedium,
                      ),
                      if (item.type == LineItemType.material && item.referenceId != null)
                        Text(
                          'SKU: ${item.referenceId}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondaryTextColor,
                          ),
                        ),
                      SizedBox(height: 4.h),
                      Text(
                        item.typeText,
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
                    '\$${item.total.toStringAsFixed(2)}',
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

  Widget _buildTotalsSection(QuoteModel quote) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal:', quote.subtotal),
          if (quote.discountTotal > 0)
            _buildTotalRow('Discount:', -quote.discountTotal, color: AppColors.successGreen),
          if (quote.taxTotal > 0)
            _buildTotalRow('Tax:', quote.taxTotal),
          Divider(height: 24.h),
          _buildTotalRow(
            'Grand Total:',
            quote.grandTotal,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.heading5.copyWith(
                    fontWeight: FontWeight.w700,
                  )
                : AppTextStyles.bodyMedium,
          ),
          Text(
            '\$${amount.abs().toStringAsFixed(2)}',
            style: (isTotal
                ? AppTextStyles.heading5
                : AppTextStyles.bodyMedium).copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(QuoteStatus status) {
    switch (status) {
      case QuoteStatus.draft:
        return AppColors.greyColor;
      case QuoteStatus.finalized:
        return AppColors.successGreen;
      case QuoteStatus.invoiced:
        return AppColors.primaryColor;
    }
  }

  Future<void> _finalizeQuote(
    BuildContext context,
    WidgetRef ref,
    QuoteModel quote,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Finalize Quote'),
        content: Text('Are you sure you want to finalize this quote? Once finalized, it cannot be edited.'),
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
      final result = await ref.read(quoteActionsProvider.notifier).finalize(quote.id);
      if (result != null && context.mounted) {
        context.showSuccessSnackBar('Quote finalized successfully');
        ref.invalidate(quoteDetailProvider(quoteId));
      } else if (context.mounted) {
        context.showErrorSnackBar('Failed to finalize quote');
      }
    }
  }

  Future<void> _deleteQuote(
    BuildContext context,
    WidgetRef ref,
    QuoteModel quote,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Quote'),
        content: Text('Are you sure you want to delete this quote? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await ref.read(quoteActionsProvider.notifier).delete(quote.id);
      if (result && context.mounted) {
        context.showSuccessSnackBar('Quote deleted successfully');
        // Navigate back to quotes list
        context.pop();
      } else if (context.mounted) {
        context.showErrorSnackBar('Failed to delete quote');
      }
    }
  }
}
