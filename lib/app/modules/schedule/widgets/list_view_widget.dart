import 'package:table_calendar/table_calendar.dart';

import '../../../export/exports.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomePageController>();

    return Container(
      child: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.week,
            focusedDay: DateTime.now(),
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 30)),
            availableCalendarFormats: const {CalendarFormat.week: 'Week'},
          ),
          Divider(color: AppColors.greyColor.withOpacity(0.5)),
          const UserStatsWidget(userName: "Tony", statsText: "5/5"),
          10.verticalSpace,
          Expanded(child: _buildScheduledJobsList(homeController)),
        ],
      ),
    );
  }

  Widget _buildScheduledJobsList(HomePageController homeController) {
    return Obx(
      () => ListView.separated(
        separatorBuilder: (context, index) => 12.verticalSpace,
        // padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: homeController.scheduledJobs.length,
        itemBuilder: (context, index) {
          final job = homeController.scheduledJobs[index];
          return Container(
            // margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
            ),
            child: Row(
              children: [
                // Job time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.jobTitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTextColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.primaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.verticalSpace,
                      Text(
                        job.timeRange,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryTextColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.verticalSpace,
                      Text(
                        job.address,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.secondaryTextColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.secondaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      2.verticalSpace,
                      Text(
                        job.companyName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
