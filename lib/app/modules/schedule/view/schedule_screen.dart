import '../../../export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/schedule_provider.dart';

/// Schedule Screen - Riverpod Version
/// 
/// Displays the schedule with Day, List, and Map views.
/// Uses Riverpod for state management.
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(scheduleTabProvider);
    final currentMonthName = ref.watch(scheduleMonthProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Text(
                currentMonthName,
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              12.verticalSpace,
              CustomTabBarWidget(
                tabNames: const ['Day', 'List', 'Map'],
                currentTabIndex: currentTabIndex,
                onTabChanged: (index) {
                  ref.read(scheduleTabProvider.notifier).setTab(index);
                },
              ),
              Expanded(child: _buildTabContent(ref, currentTabIndex)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(WidgetRef ref, int currentTabIndex) {
    switch (currentTabIndex) {
      case 0:
        return const DayViewWidget();
      case 1:
        return const ListViewWidget();
      case 2:
        return const MapViewWidget();
      default:
        return const DayViewWidget();
    }
  }
}
