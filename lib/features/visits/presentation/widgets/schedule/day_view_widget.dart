import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/visits_provider.dart';
import '../../../data/models/visit_model.dart';
import 'timeline_view_widget.dart';
import 'user_stats_widget.dart';

/// Day View Widget - Riverpod Version
/// 
/// Displays visits for a selected day in timeline format.
class DayViewWidget extends ConsumerStatefulWidget {
  const DayViewWidget({super.key});

  @override
  ConsumerState<DayViewWidget> createState() => _DayViewWidgetState();
}

class _DayViewWidgetState extends ConsumerState<DayViewWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final visitsAsync = ref.watch(scheduleVisitsForDateProvider(selectedDate));
    final todayVisitsAsync = ref.watch(todayVisitsProvider);

    return Column(
      children: [
        10.verticalSpace,
        TableCalendar(
          focusedDay: selectedDate,
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (selectedDay, focusedDay) {
            ref.read(scheduleSelectedDateProvider.notifier).setDate(selectedDay);
          },
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          eventLoader: (day) {
            // Return events for this day (for highlighting)
            if (!todayVisitsAsync.hasValue) return [];
            
            final visits = todayVisitsAsync.value ?? [];
            final events = visits.where((visit) {
              return isSameDay(visit.scheduledStart, day);
            }).map((v) => v.id).toList();
            return events;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            markersMaxCount: 1,
            markersAlignment: Alignment.bottomCenter,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: AppTextStyles.heading5,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: AppTextStyles.bodySmall,
            weekendStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryTextColor,
            ),
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
        todayVisitsAsync.when(
          data: (visits) {
            final completedCount = visits.where((v) => v.status == VisitStatus.completed).length;
            final totalCount = visits.length;
            return UserStatsWidget(
              userName: "Tony",
              statsText: "$completedCount/$totalCount",
            );
          },
          loading: () => const UserStatsWidget(userName: "Tony", statsText: "0/0"),
          error: (_, __) => const UserStatsWidget(userName: "Tony", statsText: "0/0"),
        ),
        10.verticalSpace,
        Expanded(
          child: TimeLineView(
            visitsAsync: visitsAsync,
            selectedDate: selectedDate,
          ),
        ),
      ],
    );
  }
}

