import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/visits_provider.dart';
import '../widgets/visit_card_widget.dart';
import '../widgets/visits_map_widget.dart';

/// Home Screen - Riverpod Version
/// 
/// Displays the technician's home view with:
/// - Greeting section
/// - Map with visit locations
/// - "Up Next" visits list
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(todayVisitsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(todayVisitsProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                _buildGreetingSection(currentUser?.fullName.split(' ').first ?? 'there'),
                
                // Map View
                SizedBox(
                  height: 0.5.sh,
                  width: 1.sw,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Map with visits
                      visitsAsync.when(
                        data: (visits) => VisitsMapWidget(visits: visits),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) => const Center(
                          child: Icon(Icons.map_outlined, size: 48),
                        ),
                      ),
                      
                      // Fade overlays
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

                // Up Next Section
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUpNextHeader(context),
                      SizedBox(height: 15.h),
                      _buildVisitsList(ref, visitsAsync),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingSection(String userName) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');
    final greeting = _getGreeting(now.hour);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Text(
            dateFormat.format(now),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
          ),
          5.verticalSpace,
          Text(
            '$greeting, $userName',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildUpNextHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Up Next',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.primaryTextColor,
          ),
        ),
        TextButton(
          onPressed: () {
            context.push(AppRoutePaths.schedule);
          },
          child: Text(
            'See All',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.skyAqua,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitsList(WidgetRef ref, AsyncValue visitsAsync) {
    return visitsAsync.when(
      data: (visits) {
        if (visits.isEmpty) {
          return _buildEmptyState();
        }

        return SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visits.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300.w,
                child: VisitCardWidget(visit: visits[index]),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 140.h,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => SizedBox(
        height: 140.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.errorRed,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'Failed to load visits',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.errorRed,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  ref.invalidate(todayVisitsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 140.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              color: AppColors.greyColor,
              size: 48.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'No visits scheduled for today',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


