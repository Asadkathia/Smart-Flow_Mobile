import '../../../export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/on_my_way_provider.dart';

/// On My Way Screen - Riverpod Version
/// 
/// Allows sending "on my way" text messages.
/// Uses Riverpod for state management.
class OnMyWayScreen extends ConsumerWidget {
  /// Visit ID for this on-my-way notification
  final String visitId;
  
  /// Customer name to display
  final String customerName;
  
  /// Address to navigate to
  final String address;
  
  /// Latitude for navigation
  final double latitude;
  
  /// Longitude for navigation
  final double longitude;

  const OnMyWayScreen({
    super.key,
    this.visitId = '',
    this.customerName = 'Donald Richards',
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  // Contact type label
  static const String defaultContactType = 'Primary Contact';
  static const List<int> timeOptions = [5, 10, 15, 30, 45, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMinutes = ref.watch(onMyWayProvider);
    final messageText = generateMessageText(selectedMinutes, customerName);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Send on my way text",
        showBackButton: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.w),
        child: BuildBasicButton(
          onPressed: () {
            // TODO: Implement send text functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Text sent successfully'),
                backgroundColor: AppColors.successGreen,
              ),
            );
          },
          title: "Send Text",
        ),
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
              customerName,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            4.verticalSpace,
            Text(
              defaultContactType,
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
              children: timeOptions
                  .map((minutes) => _buildTimeButton(
                        context,
                        ref,
                        minutes,
                        selectedMinutes,
                      ))
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
            Text(
              messageText,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(
    BuildContext context,
    WidgetRef ref,
    int minutes,
    int selectedMinutes,
  ) {
    final isSelected = selectedMinutes == minutes;
    return GestureDetector(
      onTap: () => ref.read(onMyWayProvider.notifier).updateMinutes(minutes),
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
  }
}

