import '../../../export/exports.dart';

class CreateQuotesSummaryRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;

  const CreateQuotesSummaryRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.heading3.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.blackColor,
                  )
                : AppTextStyles.heading4.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.blackColor,
                  ),
          ),
          Text(
            amount,
            style: isTotal
                ? AppTextStyles.heading3.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.blackColor,
                  )
                : AppTextStyles.heading4.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.blackColor,
                  ),
          ),
        ],
      ),
    );
  }
}
