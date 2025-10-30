import '../../../export/exports.dart';

class CreateQuotesLineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const CreateQuotesLineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray.withOpacity(0.3), width: 1),
          ),
        ),
        child: Row(
          children: [
            // Remove button
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: AppColors.errorRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: AppColors.white,
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutralDarkGray,
                      ),
                    ),
                ],
              ),
            ),
            // Amount
            if (amount.isNotEmpty)
              Text(
                amount,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
              ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, color: AppColors.lightGray, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
