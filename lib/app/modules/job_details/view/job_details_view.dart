import '../../../export/exports.dart';

class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobDetailsController>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Spacer(),
                  IconButton(onPressed: () {}, icon: Icon(Icons.call_outlined)),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    JobDetailsHeader(),
                    SizedBox(height: 10.h),
                    JobDetailsScheduleWidget(),
                    SizedBox(height: 15.h),
                    Obx(
                      () => Column(
                        children: [
                          CustomTab(
                            selectedIndex: controller.selectedTab.value,
                            onTabSelected: (index) {
                              controller.setTab(index);
                            },
                          ),
                          SizedBox(height: 16),
                          if (controller.selectedTab.value == 0)
                            JobDetailsVisitTab() // Replace with your actual widget
                          else if (controller.selectedTab.value == 1)
                            JobDetailsDetailsTab() // Replace with your actual widget
                          else
                            JobDetailsNotesTab(), // Replace with your actual widget
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> tabs;

  const CustomTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.tabs = const ['Visit', 'Details', 'Notes'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  alignment: Alignment.center,
                  height: 44.h, // Ensures a large tap area
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.black87 : Colors.grey[700],
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (isSelected)
                        Container(
                          height: 4.h,
                          width: 100.w,
                          decoration: BoxDecoration(color: Colors.green),
                        )
                      else
                        SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.greyColor.withAlpha(80),
        ),
      ],
    );
  }
}
