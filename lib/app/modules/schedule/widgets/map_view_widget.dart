import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../export/exports.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';
import '../../../../features/visits/data/models/visit_model.dart';
import '../providers/schedule_provider.dart';

/// Map View Widget - Riverpod Version
/// 
/// Displays visits on a map with calendar.
class MapViewWidget extends ConsumerStatefulWidget {
  const MapViewWidget({super.key});

  @override
  ConsumerState<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends ConsumerState<MapViewWidget> {
  // Track which dates have already rendered a marker to prevent duplicates
  // Use static Set with widget-specific prefix to persist across rebuilds
  static final Set<String> _renderedMarkers = {};
  static DateTime? _lastFocusedWeek;

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final allVisitsAsync = ref.watch(todayVisitsProvider);
    
    // Only clear markers when week changes, not on every rebuild
    final currentWeek = _getWeekStart(selectedDate);
    if (_lastFocusedWeek == null || _lastFocusedWeek != currentWeek) {
      _renderedMarkers.clear();
      _lastFocusedWeek = currentWeek;
    }
    
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
            // markerDecoration removed - using custom markerBuilder instead
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return const SizedBox.shrink();
              
              // Use date as key with widget prefix to track if we've already rendered a marker for this date
              final dateKey = 'map_${date.toIso8601String()}';
              
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
                  // Map - Convert visits to jobs for MapWidget
                  MapWidget(jobs: _convertVisitsToJobs(visits)),
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

  // Helper method to convert visits to jobs for MapWidget compatibility
  List<Job> _convertVisitsToJobs(List<VisitModel> visits) {
    return visits.map((visit) {
      // Format start time for "startsIn"
      String formattedStartTime = 'Soon';
      final now = DateTime.now();
      if (visit.scheduledStart.isAfter(now)) {
        final diff = visit.scheduledStart.difference(now);
        if (diff.inHours > 0) {
          formattedStartTime = '${diff.inHours}h';
        } else if (diff.inMinutes > 0) {
          formattedStartTime = '${diff.inMinutes}m';
        }
      }
      
      return Job(
        id: visit.id,
        jobTitle: visit.title ?? 'Service Visit',
        address: visit.address ?? '',
        companyName: visit.customerName ?? 'Customer',
        timeRange: visit.timeRange,
        startsIn: formattedStartTime,
        statusLabel: visit.statusText,
        latitude: visit.latitude ?? 0.0,
        longitude: visit.longitude ?? 0.0,
      );
    }).toList();
  }
}
