import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../providers/job_details_provider.dart';
import '../../providers/visits_provider.dart';
import '../../../data/models/visit_model.dart';

class JobDetailsHeader extends ConsumerWidget {
  const JobDetailsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitId = ref.watch(selectedVisitIdProvider);
    
    // Fallback: use first visit from today's visits if no visitId
    final todayVisits = ref.watch(todayVisitsProvider).value;
    final effectiveVisitId = visitId ?? (todayVisits?.isNotEmpty == true ? todayVisits!.first.id : null);
    
    if (effectiveVisitId == null) {
      return SizedBox.shrink();
    }

    final visitAsync = ref.watch(visitDetailsProvider(effectiveVisitId));
    
    return visitAsync.when(
      data: (visit) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row: Truck icon, status dot, status text
          Row(
            children: [
              Icon(Icons.delivery_dining, color: _getStatusColor(visit.status)),
              SizedBox(width: 8.w),
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: _getStatusColor(visit.status),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                visit.statusText,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Visit title - use customer name from visit
          Text(
            'Visit for ${visit.customerName ?? 'Customer'}',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // Item/Service - use title from visit
          Text(
            visit.title ?? 'Service Visit',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          // Address - use address from visit
          Text(
            visit.address ?? 'No address provided',
            style: AppTextStyles.bodyMedium,
          ),
          SizedBox(height: 10.h),
          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Directions button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement directions
                  },
                  icon: Icon(Icons.directions, size: 20.0, color: Colors.black87),
                  label: Text(
                    'Directions',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // On my way button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.goToOnMyWay(
                      visitId: visit.id,
                      customerName: visit.customerName ?? 'Customer',
                      address: visit.address ?? '',
                      latitude: visit.latitude ?? 0.0,
                      longitude: visit.longitude ?? 0.0,
                    );
                  },
                  icon: Icon(
                    Icons.delivery_dining,
                    size: 20.0,
                    color: Colors.black87,
                  ),
                  label: Text(
                    'On my way',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.greyColor.withAlpha(80)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (_, __) => SizedBox.shrink(),
    );
  }

  Color _getStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.scheduled:
        return Colors.orange;
      case VisitStatus.inProgress:
        return Colors.blue;
      case VisitStatus.paused:
        return Colors.yellow;
      case VisitStatus.completed:
        return Colors.green;
      case VisitStatus.cancelled:
        return Colors.red;
    }
  }
}

