import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../router/app_router.dart';
import '../providers/completed_visits_provider.dart';
import '../widgets/visit_card_widget.dart';

/// Completed Visits Screen
/// 
/// Displays all completed visits with filtering and search capabilities.
class CompletedVisitsScreen extends ConsumerStatefulWidget {
  const CompletedVisitsScreen({super.key});

  @override
  ConsumerState<CompletedVisitsScreen> createState() => _CompletedVisitsScreenState();
}

class _CompletedVisitsScreenState extends ConsumerState<CompletedVisitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all'; // all, today, week, month

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyDateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate = now;

    switch (filter) {
      case 'today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'all':
      default:
        startDate = null;
        endDate = null;
    }

    ref.read(completedVisitsNotifierProvider.notifier).setDateFilter(
          startDate: startDate,
          endDate: endDate,
        );
  }

  void _onSearchChanged(String query) {
    ref.read(completedVisitsNotifierProvider.notifier).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final visitsAsync = ref.watch(completedVisitsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Visit History',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by customer, address, or job...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
              ),
            ),
          ),

          // Date Filter Chips
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Today', 'today'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('This Week', 'week'),
                  SizedBox(width: 8.w),
                  _buildFilterChip('This Month', 'month'),
                ],
              ),
            ),
          ),

          // Visits List
          Expanded(
            child: visitsAsync.when(
              data: (visits) {
                if (visits.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(completedVisitsNotifierProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      final visit = visits[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: VisitCardWidget(
                          visit: visit,
                          onTap: () {
                            context.goToJobDetails(visit.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: AppColors.errorRed,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load completed visits',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      error.toString(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(completedVisitsNotifierProvider.notifier).refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _applyDateFilter(value);
        }
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryColor.withOpacity(0.2),
      checkmarkColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryColor : AppColors.secondaryTextColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryColor : AppColors.greyColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80.sp,
            color: AppColors.greyColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'No Completed Visits',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.primaryTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _selectedFilter == 'all'
                ? 'Completed visits will appear here'
                : 'No visits completed in this time period',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (_selectedFilter != 'all') ...[
            SizedBox(height: 24.h),
            TextButton(
              onPressed: () => _applyDateFilter('all'),
              child: const Text('View All Completed Visits'),
            ),
          ],
        ],
      ),
    );
  }
}
