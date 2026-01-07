import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Conflict Banner Widget
/// 
/// Displays a banner at the top of the screen when conflicts are detected.
/// Provides quick actions to resolve conflicts.
class ConflictBanner extends StatelessWidget {
  final String message;
  final int conflictCount;
  final VoidCallback onResolve;
  final VoidCallback? onDismiss;

  const ConflictBanner({
    super.key,
    required this.message,
    required this.conflictCount,
    required this.onResolve,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade900,
                  ),
                ),
                if (conflictCount > 0) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '$conflictCount conflict${conflictCount > 1 ? 's' : ''} detected',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          TextButton(
            onPressed: onResolve,
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange.shade900,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Resolve',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 4.w),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 20.sp,
                color: Colors.orange.shade900,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Conflict Indicator Widget
/// 
/// Small indicator showing conflict count in app bar or navigation.
class ConflictIndicator extends StatelessWidget {
  final int conflictCount;
  final VoidCallback? onTap;

  const ConflictIndicator({
    super.key,
    required this.conflictCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (conflictCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 16.sp,
              color: AppColors.whiteColor,
            ),
            SizedBox(width: 4.w),
            Text(
              conflictCount.toString(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



