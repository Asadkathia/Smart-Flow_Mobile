import '../../../export/exports.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;

  const JobCardWidget({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.jobsDetailsView);
      },
      child: Card(
        color: AppColors.whiteColor, // Using white for card background
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical colored bar on the left
              Container(
                width: 5.w,
                height: 100.h, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.green, // Color based on status
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
                margin: EdgeInsets.only(right: 16.w),
              ),
              // Job details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      job.jobTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.timeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      job.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    Text(
                      'LG Washer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Status indicator (e.g., checkmark)
              Icon(
                Icons.check, // Example icon
                color: AppColors.blackColor,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
