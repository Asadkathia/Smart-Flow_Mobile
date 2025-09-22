import '../../../export/exports.dart';

class CustomTabBarWidget extends StatelessWidget {
  final List<String> tabNames;
  final int currentTabIndex;
  final Function(int) onTabChanged;

  const CustomTabBarWidget({
    super.key,
    required this.tabNames,
    required this.currentTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: List.generate(
          tabNames.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: currentTabIndex == index
                      ? AppColors.whiteColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: currentTabIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tabNames[index],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: currentTabIndex == index
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
