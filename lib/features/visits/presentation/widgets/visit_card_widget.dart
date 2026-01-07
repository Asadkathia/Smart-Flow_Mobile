import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/visit_model.dart';
import '../../../../router/app_router.dart';

/// Visit Card Widget
/// 
/// Displays a visit card with status, time, and customer info.
/// Used in the home screen's "Up Next" section.
/// Matches the original JobCardWidget UI design.
class VisitCardWidget extends StatelessWidget {
  final VisitModel visit;
  final VoidCallback? onTap;

  const VisitCardWidget({
    super.key,
    required this.visit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        // Navigate to visit details using GoRouter
        context.goToJobDetails(visit.id);
      },
      child: Card(
        color: AppColors.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vertical colored bar on the left (based on status)
              Container(
                width: 5.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
                margin: EdgeInsets.only(right: 16.w),
              ),
              // Visit details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      visit.title ?? 'Service Visit',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      visit.timeRange,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      visit.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    Text(
                      visit.customerName ?? 'Customer',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Status indicator icon
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (visit.status) {
      case VisitStatus.scheduled:
        return AppColors.scheduledColor;
      case VisitStatus.inProgress:
        return AppColors.inProgressColor;
      case VisitStatus.paused:
        return AppColors.pausedColor;
      case VisitStatus.completed:
        return AppColors.completedColor;
      case VisitStatus.cancelled:
        return AppColors.cancelledColor;
    }
  }

  IconData _getStatusIcon() {
    switch (visit.status) {
      case VisitStatus.scheduled:
        return Icons.schedule;
      case VisitStatus.inProgress:
        return Icons.play_circle_outline;
      case VisitStatus.paused:
        return Icons.pause_circle_outline;
      case VisitStatus.completed:
        return Icons.check_circle;
      case VisitStatus.cancelled:
        return Icons.cancel;
    }
  }
}

