import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule/custom_tab_bar_widget.dart';
import '../widgets/schedule/day_view_widget.dart';
import '../widgets/schedule/list_view_widget.dart';
import '../widgets/schedule/map_view_widget.dart';

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
        return const DayViewWidget(key: ValueKey('day_view'));
      case 1:
        return const ListViewWidget(key: ValueKey('list_view'));
      case 2:
        return const MapViewWidget(key: ValueKey('map_view'));
      default:
        return const DayViewWidget(key: ValueKey('day_view'));
    }
  }
}

