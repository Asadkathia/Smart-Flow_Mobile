import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

/// Skeleton Loader Widget
/// 
/// Provides reusable skeleton loading widgets for consistent loading states.
/// Uses shimmer effect for better UX.
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGray.withOpacity(0.3),
      highlightColor: AppColors.lightGray.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

/// List Item Skeleton
/// 
/// Skeleton loader for list items (e.g., quotes, invoices, visits).
class ListItemSkeleton extends StatelessWidget {
  final bool showAvatar;
  final bool showSubtitle;

  const ListItemSkeleton({
    super.key,
    this.showAvatar = false,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            SkeletonLoader(
              width: 48.w,
              height: 48.w,
              borderRadius: BorderRadius.circular(24.r),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                if (showSubtitle) ...[
                  SkeletonLoader(width: 200.w, height: 14.h),
                  SizedBox(height: 4.h),
                ],
                SkeletonLoader(width: 150.w, height: 12.h),
              ],
            ),
          ),
          SkeletonLoader(width: 60.w, height: 24.h),
        ],
      ),
    );
  }
}

/// Card Skeleton
/// 
/// Skeleton loader for card widgets.
class CardSkeleton extends StatelessWidget {
  final double? height;

  const CardSkeleton({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGray.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(width: double.infinity, height: 20.h),
          SizedBox(height: 12.h),
          SkeletonLoader(width: 150.w, height: 16.h),
          SizedBox(height: 8.h),
          SkeletonLoader(width: 200.w, height: 14.h),
          if (height != null) ...[
            SizedBox(height: 12.h),
            SkeletonLoader(width: double.infinity, height: height!),
          ],
        ],
      ),
    );
  }
}

/// Grid Item Skeleton
/// 
/// Skeleton loader for grid items (e.g., inventory items).
class GridItemSkeleton extends StatelessWidget {
  const GridItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGray.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            width: double.infinity,
            height: 120.h,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                SkeletonLoader(width: 100.w, height: 14.h),
                SizedBox(height: 8.h),
                SkeletonLoader(width: 80.w, height: 18.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


