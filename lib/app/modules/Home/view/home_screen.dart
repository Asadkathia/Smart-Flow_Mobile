import '../../../export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/visits/presentation/providers/visits_provider.dart';
import '../../../../features/visits/data/models/visit_model.dart';
import '../../../../features/visits/presentation/widgets/visit_card_widget.dart';
import '../models/job.dart'; // For MapWidget compatibility
import '../../../../shared/presentation/widgets/loading_skeleton.dart';

/// Home Screen - Riverpod Version
/// 
/// Displays the home screen with map and upcoming visits.
/// Uses Riverpod for state management.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(todayVisitsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map View with visit locations
              _buildGreetingSection(context),
              SizedBox(
                height: 0.5.sh,
                width: 1.sw,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Map
                    visitsAsync.when(
                      data: (visits) => MapWidget(
                        jobs: _convertVisitsToJobs(visits),
                      ),
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (error, stack) => MapWidget(jobs: []),
                    ),
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
                ),
              ),

              // Content overlaying the map
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpNextHeader(),
                    SizedBox(height: 15.h),
                    // Scheduled Visits List
                    visitsAsync.when(
                      data: (visits) => _buildScheduledVisitsList(visits),
                      loading: () => SizedBox(
                        height: 140.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: 3,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: SizedBox(
                              width: 300.w,
                              child: const VisitCardSkeleton(),
                            ),
                          ),
                        ),
                      ),
                      error: (error, stack) => SizedBox(
                        height: 140.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 40.sp,
                                color: AppColors.errorRed,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Unable to load visits',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.errorRed,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextButton.icon(
                                onPressed: () {
                                  ref.invalidate(todayVisitsProvider);
                                },
                                icon: Icon(Icons.refresh, size: 16.sp),
                                label: Text('Retry'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Text(
            'Saturday, September 13th', // Placeholder, will be dynamic
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
          ),
          5.verticalSpace,
          Text(
            'Good evening, Tony', // Placeholder, will be dynamic
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpNextHeader() {
    return Text(
      'Up Next',
      style: AppTextStyles.heading4.copyWith(color: AppColors.primaryTextColor),
    );
  }

  Widget _buildScheduledVisitsList(List<VisitModel> visits) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: visits
              .map(
                (visit) => Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SizedBox(
                    width: 300.w,
                    child: VisitCardWidget(visit: visit),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// Convert VisitModel list to Job list for MapWidget compatibility
  /// This is a temporary compatibility layer until MapWidget is migrated
  List<Job> _convertVisitsToJobs(List<VisitModel> visits) {
    return visits.map((visit) {
      return Job(
        id: visit.id,
        jobTitle: visit.title ?? 'Service Visit',
        companyName: visit.customerName ?? 'Customer',
        address: visit.address ?? '',
        timeRange: visit.timeRange,
        startsIn: _getStartsIn(visit),
        statusLabel: visit.statusText,
        latitude: visit.latitude ?? 33.4484, // Default to Phoenix
        longitude: visit.longitude ?? -112.0740,
      );
    }).toList();
  }

  String _getStartsIn(VisitModel visit) {
    final now = DateTime.now();
    final diff = visit.scheduledStart.difference(now);

    if (diff.isNegative) {
      if (visit.status == VisitStatus.inProgress) {
        return 'In Progress';
      }
      return 'Started';
    }

    if (diff.inMinutes < 60) {
      return 'Starts in ${diff.inMinutes}m';
    }

    if (diff.inHours < 24) {
      return 'Starts in ${diff.inHours}h';
    }

    return 'Tomorrow';
  }
}
