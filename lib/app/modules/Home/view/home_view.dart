import '../../../export/exports.dart';

class HomeView extends GetView<HomePageController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor, // Using color from app_colors.dart
      body: SafeArea(
        child: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Map View with job locations
              _buildGreetingSection(context),
              SizedBox(
                height: 0.5.sh, // 60% of screen height
                width: 1.sw,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Map
                    MapWidget(jobs: controller.scheduledJobs),
                    // Fade overlays (top & bottom)
                    IgnorePointer(
                      child: Column(
                        children: [
                          // Top fade
                          Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.backgroundColor,
                                  AppColors.backgroundColor.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Bottom fade
                          Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.backgroundColor,
                                  AppColors.backgroundColor.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content overlaying the map
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpNextHeader(),

                    SizedBox(height: 15.h),

                    // Scheduled Jobs List
                    _buildScheduledJobsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar moved to MainNavigationView
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Text(
            'Saturday, September 13th', // Placeholder, will be dynamic
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
          ),
          5.verticalSpace,
          Text(
            'Good evening, Tony', // Placeholder, will be dynamic
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpNextHeader() {
    return Text(
      'Up Next',
      style: AppTextStyles.heading4.copyWith(color: AppColors.primaryTextColor),
    );
  }

  Widget _buildScheduledJobsList() {
    return Obx(
      () => SizedBox(
        height: 140.h,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.scheduledJobs
                .map(
                  (job) => Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SizedBox(
                      width: 300.w,
                      child: JobCardWidget(job: job),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
