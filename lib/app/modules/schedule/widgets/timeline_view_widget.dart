import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../export/exports.dart';
import '../../../../features/visits/data/models/visit_model.dart';
import '../../../../features/visits/presentation/widgets/visit_card_widget.dart';

/// Timeline View Widget
/// 
/// Displays visits on a timeline from 7 AM to 10 PM.
class TimeLineView extends ConsumerWidget {
  final AsyncValue<List<VisitModel>> visitsAsync;
  final DateTime selectedDate;

  const TimeLineView({
    super.key,
    required this.visitsAsync,
    required this.selectedDate,
  });

  // Generate all times from 7:00 AM to 10:00 PM (hourly)
  static final List<TimeOfDay> times = List.generate(
    16, // from 7 AM to 10 PM inclusive = 16 entries
    (index) => TimeOfDay(hour: 7 + index, minute: 0),
  );

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour $period';
  }

  /// Get visits for a specific hour
  List<VisitModel> getVisitsForHour(List<VisitModel> visits, TimeOfDay hour) {
    final hourStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour.hour,
    );
    final hourEnd = hourStart.add(const Duration(hours: 1));

    return visits.where((visit) {
      final scheduledStart = visit.scheduledStart;
      return scheduledStart.isAfter(hourStart) && scheduledStart.isBefore(hourEnd);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return visitsAsync.when(
      data: (visits) {
        if (visits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64.sp,
                  color: AppColors.greyColor,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No visits scheduled',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.secondaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Select a different date',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final time = times[index];
            final hourVisits = getVisitsForHour(visits, time);

            return SizedBox(
              height: hourVisits.isNotEmpty ? 120.h : 60.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left time label
                  SizedBox(
                    width: 60.w,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        formatTime(time),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Timeline content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Horizontal line
                        Container(
                          height: 1,
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        // Visits for this hour
                        if (hourVisits.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          ...hourVisits.map((visit) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: AppColors.lightBeige,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(visit.status),
                                          borderRadius: BorderRadius.circular(2.r),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              visit.title ?? 'Service Visit',
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              '${_formatTime(visit.scheduledStart)} - ${_formatTime(visit.scheduledEnd)}',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.greyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60.sp,
                color: AppColors.errorRed,
              ),
              SizedBox(height: 16.h),
              Text(
                'Unable to load visits',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(VisitStatus status) {
    switch (status) {
      case VisitStatus.scheduled:
        return AppColors.primaryColor;
      case VisitStatus.inProgress:
        return AppColors.successGreen;
      case VisitStatus.completed:
        return AppColors.darkGrey;
      case VisitStatus.paused:
        return Colors.orange;
      case VisitStatus.cancelled:
        return AppColors.errorRed;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
