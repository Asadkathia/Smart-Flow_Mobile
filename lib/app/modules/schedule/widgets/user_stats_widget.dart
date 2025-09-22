import '../../../export/exports.dart';

class UserStatsWidget extends StatelessWidget {
  final String userName;
  final String statsText;

  const UserStatsWidget({
    super.key,
    required this.userName,
    required this.statsText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 30.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        // borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Text(
            userName,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            statsText,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
