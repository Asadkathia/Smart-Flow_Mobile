import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../providers/job_details_provider.dart';
import '../providers/visits_provider.dart';
import '../widgets/job_details/job_details_header.dart';
import '../widgets/job_details/job_details_schedule_widget.dart';
import '../widgets/job_details/job_details_visit_tab.dart';
import '../widgets/job_details/job_details_details_tab.dart';
import '../widgets/job_details/job_details_notes_tab.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  /// The visit ID to display details for
  final String? visitId;

  const JobDetailsScreen({super.key, this.visitId});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Set visitId from widget parameter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? visitIdToUse = widget.visitId;
      
      if (visitIdToUse != null && visitIdToUse.isNotEmpty) {
        ref.read(selectedVisitIdProvider.notifier).setVisitId(visitIdToUse);
      } else {
        // Fallback: use first visit from today's visits if no visitId provided
        final visitsAsync = ref.read(todayVisitsProvider);
        visitsAsync.whenData((visits) {
          if (visits.isNotEmpty) {
            final currentVisitId = ref.read(selectedVisitIdProvider);
            if (currentVisitId == null) {
              ref.read(selectedVisitIdProvider.notifier).setVisitId(visits.first.id);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(jobDetailsTabProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryTextColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call_outlined, color: AppColors.primaryTextColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      JobDetailsHeader(),
                      SizedBox(height: 10.h),
                      JobDetailsScheduleWidget(),
                      SizedBox(height: 15.h),
                      CustomTab(
                        selectedIndex: selectedTab,
                        onTabSelected: (index) {
                          ref.read(jobDetailsTabProvider.notifier).setTab(index);
                        },
                      ),
                      SizedBox(height: 16),
                      // Tab content - each tab handles its own scrolling
                      if (selectedTab == 0)
                        JobDetailsVisitTab()
                      else if (selectedTab == 1)
                        JobDetailsDetailsTab()
                      else
                        JobDetailsNotesTab(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> tabs;

  const CustomTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.tabs = const ['Visit', 'Details', 'Notes'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  alignment: Alignment.center,
                  height: 44.h, // Ensures a large tap area
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.black87 : Colors.grey[700],
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (isSelected)
                        Container(
                          height: 4.h,
                          width: 100.w,
                          decoration: BoxDecoration(color: Colors.green),
                        )
                      else
                        SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.greyColor.withAlpha(80),
        ),
      ],
    );
  }
}

