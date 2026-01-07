import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../providers/visits_provider.dart';
import '../../providers/job_details_provider.dart';
import '../../../data/models/visit_model.dart';

class JobDetailsVisitTab extends ConsumerWidget {
  const JobDetailsVisitTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitId = ref.watch(selectedVisitIdProvider);
    
    // Fallback: use first visit from today's visits if no visitId
    final todayVisits = ref.watch(todayVisitsProvider).value;
    final effectiveVisitId = visitId ?? (todayVisits?.isNotEmpty == true ? todayVisits!.first.id : null);
    
    if (effectiveVisitId == null) {
      return Center(
        child: Text(
          'No visit selected',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyColor),
        ),
      );
    }

    final visitAsync = ref.watch(visitDetailsProvider(effectiveVisitId));
    
    return visitAsync.when(
      data: (visit) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVisitTimeline(context, visit),
          SizedBox(height: 20.h),
          _buildServiceDetails(context, visit),
          SizedBox(height: 100.h), // Bottom padding
        ],
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading visit: $error',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
        ),
      ),
    );
  }

  Widget _buildVisitTimeline(BuildContext context, VisitModel visit) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final timeFormat = DateFormat('h:mm a');
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Timeline',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTimelineItem(
            icon: Icons.schedule,
            label: 'Scheduled',
            time: dateFormat.format(visit.scheduledStart),
            isCompleted: true,
          ),
          if (visit.actualStart != null)
            _buildTimelineItem(
              icon: Icons.play_circle_outline,
              label: 'Started',
              time: timeFormat.format(visit.actualStart!),
              isCompleted: true,
            ),
          if (visit.actualEnd != null)
            _buildTimelineItem(
              icon: Icons.check_circle,
              label: 'Completed',
              time: timeFormat.format(visit.actualEnd!),
              isCompleted: true,
            ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.greyColor.withAlpha(40)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Duration',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatDuration(visit.duration),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String label,
    required String time,
    required bool isCompleted,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCompleted ? AppColors.successGreen : AppColors.greyColor,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isCompleted ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            time,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails(BuildContext context, VisitModel visit) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          if (visit.title != null)
            _buildDetailRow('Service Type', visit.title!),
          _buildDetailRow('Status', visit.statusText, valueColor: _getStatusColor(visit.status)),
          if (visit.statusReason != null)
            _buildDetailRow('Status Reason', visit.statusReason!),
        ],
      ),
    );
  }

  Color _getStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.scheduled:
        return AppColors.softGold;
      case VisitStatus.inProgress:
        return AppColors.primaryColor;
      case VisitStatus.completed:
        return AppColors.successGreen;
      case VisitStatus.cancelled:
        return AppColors.errorRed;
      case VisitStatus.paused:
        return AppColors.accentColor;
    }
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.greyColor,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

