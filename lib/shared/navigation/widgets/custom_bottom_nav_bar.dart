import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              index: 0,
              isSelected: currentIndex == 0,
            ),
            _buildNavItem(
              icon: Icons.calendar_today_outlined,
              label: 'Scheduled',
              index: 1,
              isSelected: currentIndex == 1,
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              index: 2,
              isSelected: currentIndex == 2,
            ),
            _buildNavItem(
              icon: Icons.smart_toy_outlined,
              label: 'AI',
              index: 3,
              isSelected: currentIndex == 3,
            ),
            _buildNavItem(
              icon: Icons.more_horiz,
              label: 'More',
              index: 4,
              isSelected: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    final Color color = isSelected
        ? AppColors.primaryTextColor
        : AppColors.greyColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Content
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 24.sp, color: color),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: AppTextStyles.darkBody.copyWith(
                      color: color,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Top indicator line when selected
            Positioned(
              top: 0,
              left: 12.w,
              right: 12.w,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isSelected ? 3.h : 0,
                decoration: BoxDecoration(
                  color: AppColors.primaryTextColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

