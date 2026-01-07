import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';
import '../../../../features/visits/data/models/visit_model.dart';

part 'schedule_provider.g.dart';

/// Schedule Tab Provider
/// 
/// Manages the currently selected tab in the Schedule screen.
@riverpod
class ScheduleTab extends _$ScheduleTab {
  @override
  int build() {
    return 0; // Default to Day view
  }

  void setTab(int index) {
    if (index >= 0 && index < 3) {
      state = index;
    }
  }
}

/// Schedule Selected Date Provider
/// 
/// Manages the currently selected date in the Schedule screen.
@riverpod
class ScheduleSelectedDate extends _$ScheduleSelectedDate {
  @override
  DateTime build() {
    return DateTime.now(); // Default to today
  }

  void setDate(DateTime date) {
    state = date;
  }
}

/// Schedule Month Provider
/// 
/// Provides the current month name for display.
@riverpod
String scheduleMonth(Ref ref) {
  final selectedDate = ref.watch(scheduleSelectedDateProvider);
  return DateFormat('MMMM yyyy').format(selectedDate);
}

/// Visits for Selected Date Provider
/// 
/// Provides visits filtered by the selected date.
@riverpod
Future<List<VisitModel>> scheduleVisitsForDate(Ref ref, DateTime date) async {
  final allVisitsAsync = ref.watch(todayVisitsProvider);
  
  return allVisitsAsync.when(
    data: (visits) {
      // Filter visits for the selected date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      return visits.where((visit) {
        final scheduledStart = visit.scheduledStart;
        return scheduledStart.isAfter(startOfDay) && scheduledStart.isBefore(endOfDay);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Visits for Date Range Provider
/// 
/// Provides visits filtered by a date range (for week/month views).
@riverpod
Future<List<VisitModel>> scheduleVisitsForDateRange(
  Ref ref,
  ({DateTime start, DateTime end}) dateRange,
) async {
  final allVisitsAsync = ref.watch(todayVisitsProvider);
  
  return allVisitsAsync.when(
    data: (visits) {
      return visits.where((visit) {
        final scheduledStart = visit.scheduledStart;
        return scheduledStart.isAfter(dateRange.start) && 
               scheduledStart.isBefore(dateRange.end);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}


