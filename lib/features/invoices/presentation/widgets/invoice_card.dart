import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/invoice_model.dart';

/// Invoice Card Widget
/// 
/// Displays an invoice in a card format.
/// Shows invoice number, customer, status, amount, and actions.
class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback? onTap;
  final VoidCallback? onFinalize;
  final bool isFinalizing;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
    this.onFinalize,
    this.isFinalizing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Invoice Number and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.invoiceNumber,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              SizedBox(height: 8.h),

              // Customer Info
              if (invoice.customerName != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16.sp,
                      color: AppColors.greyColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      invoice.customerName!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
              ],

              // Visit Title
              if (invoice.visitTitle != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 16.sp,
                      color: AppColors.greyColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      invoice.visitTitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
              ],

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16.sp,
                    color: AppColors.greyColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    invoice.createdAt != null
                        ? DateFormat('MMM d, yyyy').format(invoice.createdAt!)
                        : 'N/A',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
              Divider(height: 1.h, color: AppColors.lightGray),
              SizedBox(height: 12.h),

              // Amount and Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '\$${invoice.total.toStringAsFixed(2)}',
                        style: AppTextStyles.heading5.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (invoice.status == InvoiceStatus.partiallyPaid) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'Remaining: \$${invoice.remainingBalance.toStringAsFixed(2)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.errorRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Finalize Button (only for drafts)
                  if (onFinalize != null)
                    ElevatedButton(
                      onPressed: isFinalizing ? null : onFinalize,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        disabledBackgroundColor: AppColors.greyColor,
                      ),
                      child: isFinalizing
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                              ),
                            )
                          : Text(
                              'Finalize',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final color = _getStatusColor();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        invoice.statusText,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (invoice.status) {
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
}

