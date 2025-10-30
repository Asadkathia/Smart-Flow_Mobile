import '../../../export/exports.dart';

class CreateQuotesAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CreateQuotesAddButton({
    super.key,
    required this.label,
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
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.lightGray,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: AppColors.lightGray, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
