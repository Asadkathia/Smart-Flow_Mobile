import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/visits_provider.dart';
import '../../../data/models/visit_model.dart';
import 'user_stats_widget.dart';

/// List View Widget - Riverpod Version
///
/// Displays a list of scheduled visits in calendar format.
class ListViewWidget extends ConsumerStatefulWidget {
  const ListViewWidget({super.key});

  @override
  ConsumerState<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends ConsumerState<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final allVisitsAsync = ref.watch(todayVisitsProvider);

    // Filter visits for the selected week
    final visitsAsync = allVisitsAsync.when(
      data: (allVisits) {
        // Get start and end of week for selected date
        final startOfWeek = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 7));

        final filteredVisits = allVisits.where((visit) {
          final scheduledStart = visit.scheduledStart;
          return scheduledStart.isAfter(
                startOfWeek.subtract(const Duration(days: 1)),
              ) &&
              scheduledStart.isBefore(endOfWeek);
        }).toList();

        return AsyncValue.data(filteredVisits);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );

    return Column(
      children: [
        TableCalendar(
          calendarFormat: CalendarFormat.week,
          focusedDay: selectedDate,
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selectedDay, focusedDay) {
            ref
                .read(scheduleSelectedDateProvider.notifier)
                .setDate(selectedDay);
          },
          eventLoader: (day) {
            // Return events for this day (for highlighting)
            // Get current value synchronously instead of using async .when()
            if (!allVisitsAsync.hasValue) return [];

            final visits = allVisitsAsync.value ?? [];
            return visits
                .where((visit) {
                  return isSameDay(visit.scheduledStart, day);
                })
                .map((v) => v.id)
                .toList();
          },
          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
            markersAlignment: Alignment.bottomCenter,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox.shrink();

              return Positioned(
                bottom: 2,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        Divider(color: AppColors.greyColor.withOpacity(0.5)),
        // User stats - calculate from visits
        visitsAsync.when(
          data: (visits) {
            final completedCount = visits
                .where((v) => v.status == VisitStatus.completed)
                .length;
            final totalCount = visits.length;
            return UserStatsWidget(
              userName: "Tony",
              statsText: "$completedCount/$totalCount",
            );
          },
          loading: () =>
              const UserStatsWidget(userName: "Tony", statsText: "0/0"),
          error: (_, _) =>
              const UserStatsWidget(userName: "Tony", statsText: "0/0"),
        ),
        10.verticalSpace,
        Expanded(
          child: visitsAsync.when(
            data: (visits) => _buildScheduledJobsList(visits),
            loading: () => Center(child: CircularProgressIndicator()),
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
                    SizedBox(height: 8.h),
                    Text(
                      'Please check your connection and try again',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(todayVisitsProvider);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduledJobsList(List<VisitModel> visits) {
    if (visits.isEmpty) {
      return Center(
        child: Text(
          'No visits scheduled',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyColor),
        ),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, index) => 12.verticalSpace,
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        final isCompleted = visit.status == VisitStatus.completed;

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.greyColor.withOpacity(0.1),
          ),
          child: Row(
            children: [
              // Visit details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.title ?? 'Service Visit',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      visit.timeRange,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.secondaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Text(
                      visit.address ?? 'No address',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.secondaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    2.verticalSpace,
                    Text(
                      visit.customerName ?? 'Customer',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status indicator
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.greyColor
                      : AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
