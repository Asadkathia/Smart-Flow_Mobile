import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

/// Loading Skeleton Widget
/// 
/// Provides shimmer loading effect for list items.
/// Can be customized for different card types.
class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const LoadingSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor.withOpacity(0.3),
      highlightColor: AppColors.greyColor.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

/// List Item Skeleton
/// 
/// A skeleton loader for list items (cards).
class ListItemSkeleton extends StatelessWidget {
  final double? height;
  final EdgeInsets? padding;

  const ListItemSkeleton({
    super.key,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100.h,
      margin: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left colored bar
          LoadingSkeleton(
            width: 4.w,
            height: double.infinity,
            borderRadius: BorderRadius.circular(2.r),
          ),
          SizedBox(width: 12.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                LoadingSkeleton(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                LoadingSkeleton(
                  width: 200.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),
                // Bottom row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoadingSkeleton(
                      width: 80.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    LoadingSkeleton(
                      width: 60.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Right icon/status
          LoadingSkeleton(
            width: 24.w,
            height: 24.w,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ],
      ),
    );
  }
}

/// Invoice Card Skeleton
/// 
/// Specific skeleton for invoice list items.
class InvoiceCardSkeleton extends StatelessWidget {
  const InvoiceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItemSkeleton(height: 120.h);
  }
}

/// Quote Card Skeleton
/// 
/// Specific skeleton for quote list items.
class QuoteCardSkeleton extends StatelessWidget {
  const QuoteCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListItemSkeleton(height: 100.h);
  }
}

/// Visit Card Skeleton
/// 
/// Specific skeleton for visit/job list items.
class VisitCardSkeleton extends StatelessWidget {
  const VisitCardSkeleton({super.key});

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
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.greyColor.withOpacity(0.3),
        highlightColor: AppColors.greyColor.withOpacity(0.1),
        child: Row(
          children: [
            // Left colored bar
            Container(
              width: 4.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 150.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 80.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        width: 60.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Status icon
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat Thread Skeleton
/// 
/// Specific skeleton for chat list items.
class ChatThreadSkeleton extends StatelessWidget {
  const ChatThreadSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.greyColor.withOpacity(0.3),
        highlightColor: AppColors.greyColor.withOpacity(0.1),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Time
            Container(
              width: 40.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inventory Item Skeleton
/// 
/// Specific skeleton for inventory list items.
class InventoryItemSkeleton extends StatelessWidget {
  const InventoryItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.greyColor.withOpacity(0.3),
        highlightColor: AppColors.greyColor.withOpacity(0.1),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 100.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 80.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Price
            Container(
              width: 60.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// List Loading Skeleton
/// 
/// Shows multiple skeleton items for a list loading state.
class ListLoadingSkeleton extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const ListLoadingSkeleton({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
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
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeleton(width: double.infinity, height: 20.h),
          SizedBox(height: 12.h),
          LoadingSkeleton(width: 150.w, height: 16.h),
          SizedBox(height: 8.h),
          LoadingSkeleton(width: 200.w, height: 14.h),
          if (height != null) ...[
            SizedBox(height: 12.h),
            LoadingSkeleton(width: double.infinity, height: height!),
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
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingSkeleton(
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
                LoadingSkeleton(width: double.infinity, height: 16.h),
                SizedBox(height: 8.h),
                LoadingSkeleton(width: 100.w, height: 14.h),
                SizedBox(height: 8.h),
                LoadingSkeleton(width: 80.w, height: 18.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



