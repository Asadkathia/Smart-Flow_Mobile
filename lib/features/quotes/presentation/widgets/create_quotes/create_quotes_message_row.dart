import 'package:smartflowpro/app/export/exports.dart';

class CreateQuotesMessageRow extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const CreateQuotesMessageRow({
    super.key,
    required this.message,
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
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.blackColor,
                ),
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

