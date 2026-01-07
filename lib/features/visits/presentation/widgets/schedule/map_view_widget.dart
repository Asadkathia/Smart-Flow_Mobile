import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../../providers/schedule_provider.dart';
import '../../providers/visits_provider.dart';
import '../../../data/models/visit_model.dart';
import '../../widgets/visits_map_widget.dart';
import 'user_stats_widget.dart';

/// Map View Widget - Riverpod Version
/// 
/// Displays visits on a map with calendar.
class MapViewWidget extends ConsumerStatefulWidget {
  const MapViewWidget({super.key});

  @override
  ConsumerState<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends ConsumerState<MapViewWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final allVisitsAsync = ref.watch(todayVisitsProvider);
    
    // Filter visits for the selected week
    final visitsAsync = allVisitsAsync.when(
      data: (allVisits) {
        // Get start and end of week for selected date
        final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        
        final filteredVisits = allVisits.where((visit) {
          final scheduledStart = visit.scheduledStart;
          return scheduledStart.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
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
            ref.read(scheduleSelectedDateProvider.notifier).setDate(selectedDay);
          },
          eventLoader: (day) {
            // Return events for this day (for highlighting)
            // Get current value synchronously instead of using async .when()
            if (!allVisitsAsync.hasValue) return [];
            
            final visits = allVisitsAsync.value ?? [];
            return visits.where((visit) {
              return isSameDay(visit.scheduledStart, day);
            }).map((v) => v.id).toList();
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
        // User stats - calculate from visits
        visitsAsync.when(
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
        Expanded(
          child: visitsAsync.when(
            data: (visits) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Map - Use VisitsMapWidget directly with VisitModel
                  VisitsMapWidget(visits: visits),
                  // Fade overlays (top & bottom)
                  IgnorePointer(
                    child: Column(
                      children: [
                        // Top fade
                        Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.backgroundColor,
                                AppColors.backgroundColor.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Bottom fade
                        Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.backgroundColor,
                                AppColors.backgroundColor.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Error loading map',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorRed),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

