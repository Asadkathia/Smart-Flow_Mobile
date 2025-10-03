import '../../../export/exports.dart';
import '../controller/on_my_way_controller.dart';

class OnMyWayView extends GetView<OnMyWayController> {
  const OnMyWayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Send on my way text", showBackButton: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.w),
        child: BuildBasicButton(onPressed: () {}, title: "Send Text"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            // Send to section
            Text(
              'Send to',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
                fontSize: 18.sp,
              ),
            ),
            8.verticalSpace,
            Text(
              controller.contactName,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            4.verticalSpace,
            Text(
              controller.contactType,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
            24.verticalSpace,
            // Time selection section
            Text(
              'Be there in (minutes)',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
                fontSize: 18.sp,
              ),
            ),
            16.verticalSpace,
            // Time options
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: controller.timeOptions
                  .map((minutes) => _buildTimeButton(minutes))
                  .toList(),
            ),
            24.verticalSpace,
            // Message section
            Text(
              'Message',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
                fontSize: 18.sp,
              ),
            ),
            12.verticalSpace,
            Obx(
              () => Text(
                controller.messageText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(int minutes) {
    return Obx(() {
      final isSelected = controller.selectedMinutes.value == minutes;
      return GestureDetector(
        onTap: () => controller.updateMinutes(minutes),
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.darkText : AppColors.backgroundColor,
            border: Border.all(
              color: isSelected
                  ? AppColors.darkText
                  : AppColors.greyColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              minutes.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.whiteColor : AppColors.darkText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
  }
}
