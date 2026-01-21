import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../data/models/invoice_model.dart';

class RecordPaymentDialog extends StatefulWidget {
  final double remainingBalance;
  final Function(double amount, PaymentMethod method, String? reference) onRecord;

  const RecordPaymentDialog({
    super.key,
    required this.remainingBalance,
    required this.onRecord,
  });

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  PaymentMethod _selectedMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.remainingBalance.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Record Payment',
        style: AppTextStyles.heading4,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount to pay',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryTextColor),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Payment Method',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryTextColor),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PaymentMethod>(
                  value: _selectedMethod,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    }
                  },
                  items: PaymentMethod.values.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(_getPaymentMethodName(method)),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Reference (Optional)',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.secondaryTextColor),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _referenceController,
              decoration: InputDecoration(
                hintText: 'Check #, TX ID, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppColors.greyColor)),
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(_amountController.text) ?? 0;
            if (amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid amount')),
              );
              return;
            }
            widget.onRecord(amount, _selectedMethod, _referenceController.text.trim());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: const Text('Record'),
        ),
      ],
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
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
