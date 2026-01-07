import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../export/exports.dart';
import '../providers/schedule_provider.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';
import '../../../../features/visits/data/models/visit_model.dart';

/// Day View Widget - Riverpod Version
/// 
/// Displays visits for a selected day in timeline format.
class DayViewWidget extends ConsumerStatefulWidget {
  const DayViewWidget({super.key});

  @override
  ConsumerState<DayViewWidget> createState() => _DayViewWidgetState();
}

class _DayViewWidgetState extends ConsumerState<DayViewWidget> {
  // Track which dates have already rendered a marker to prevent duplicates
  // Use static Set to persist across rebuilds
  static final Set<String> _renderedMarkers = {};
  DateTime? _lastFocusedMonth;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final visitsAsync = ref.watch(scheduleVisitsForDateProvider(selectedDate));
    final todayVisitsAsync = ref.watch(todayVisitsProvider);
    
    // Only clear markers when month changes, not on every rebuild
    final currentMonth = DateTime(selectedDate.year, selectedDate.month);
    if (_lastFocusedMonth != currentMonth) {
      _renderedMarkers.clear();
      _lastFocusedMonth = currentMonth;
    }

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
              
              // Use date as key with widget prefix to track if we've already rendered a marker for this date
              final dateKey = 'day_${date.toIso8601String()}';
              
              // If we've already rendered a marker for this date, skip
              if (_renderedMarkers.contains(dateKey)) {
                return const SizedBox.shrink();
              }
              
              // Mark this date as rendered
              _renderedMarkers.add(dateKey);
              
              return Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  '${events.length}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
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
