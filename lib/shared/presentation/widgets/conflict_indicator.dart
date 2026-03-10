import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Conflict Indicator Widget
///
/// A small badge widget that indicates an entity has a conflict.
/// Can be used on cards, list items, or detail screens.
class ConflictIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool showTooltip;

  const ConflictIndicator({
    super.key,
    this.size,
    this.color,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorSize = size ?? 8.sp;
    final indicatorColor = color ?? AppColors.warningColor;

    Widget indicator = Container(
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: indicatorColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: indicatorColor.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    if (showTooltip) {
      return Tooltip(message: 'Data conflict detected', child: indicator);
    }

    return indicator;
  }
}

/// Conflict Badge Widget
///
/// A larger badge with text that can be displayed on cards or list items.
class ConflictBadge extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;

  const ConflictBadge({super.key, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.warningColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColors.warningColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 12.sp,
              color: AppColors.warningColor,
            ),
            if (text != null) ...[
              SizedBox(width: 4.w),
              Text(
                text!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
