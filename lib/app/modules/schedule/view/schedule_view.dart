import '../../../export/exports.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Obx(
                () => Text(
                  controller.currentMonthName.value,
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              12.verticalSpace,
              Obx(
                () => CustomTabBarWidget(
                  tabNames: controller.tabNames,
                  currentTabIndex: controller.currentTabIndex.value,
                  onTabChanged: controller.changeTab,
                ),
              ),
              Expanded(child: Obx(() => _buildTabContent())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (controller.currentTabIndex.value) {
      case 0:
        return const DayViewWidget();
      case 1:
        return const ListViewWidget();
      case 2:
        return const MapViewWidget();
      default:
        return const DayViewWidget();
    }
  }
}
