import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Standard Error State Widget
/// 
/// Displays a consistent error state across all screens.
class StandardErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const StandardErrorState({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 60.sp,
              color: AppColors.errorRed,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.errorRed,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standard Empty State Widget
/// 
/// Displays a consistent empty state across all screens.
class StandardEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Widget? action;

  const StandardEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 80.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: 24.h),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Standard Loading State Widget
/// 
/// Displays a consistent loading state.
class StandardLoadingState extends StatelessWidget {
  final String? message;

  const StandardLoadingState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Async Value Builder Widget
/// 
/// Standardized builder for AsyncValue with consistent error, loading, and empty states.
class AsyncValueBuilder<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) data;
  final Widget Function(BuildContext context)? loading;
  final Widget Function(BuildContext context, Object error, StackTrace stack)? error;
  final String? emptyTitle;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final Widget? emptyAction;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AsyncValueBuilder({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
    this.emptyAction,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (data) {
        // Handle empty list case
        if (data is List && data.isEmpty && emptyTitle != null) {
          return StandardEmptyState(
            title: emptyTitle!,
            message: emptyMessage,
            icon: emptyIcon,
            action: emptyAction,
          );
        }
        return this.data(context, data);
      },
      loading: () => loading?.call(context) ?? const StandardLoadingState(),
      error: (error, stack) {
        if (this.error != null) {
          return this.error!(context, error, stack);
        }
        return StandardErrorState(
          title: errorTitle ?? 'Unable to load data',
          message: errorMessage ?? 'Please check your connection and try again',
          onRetry: onRetry,
        );
      },
    );
  }
}

/// Async List Builder Widget
/// 
/// Specialized builder for AsyncValue<List<T>> with empty state handling.
class AsyncListBuilder<T> extends StatelessWidget {
  final AsyncValue<List<T>> value;
  final Widget Function(BuildContext context, List<T> items) builder;
  final Widget Function(BuildContext context)? loading;
  final Widget Function(BuildContext context, Object error, StackTrace stack)? error;
  final String emptyTitle;
  final String? emptyMessage;
  final IconData? emptyIcon;
  final Widget? emptyAction;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AsyncListBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.loading,
    this.error,
    required this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
    this.emptyAction,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (items) {
        if (items.isEmpty) {
          return StandardEmptyState(
            title: emptyTitle,
            message: emptyMessage,
            icon: emptyIcon,
            action: emptyAction,
          );
        }
        return builder(context, items);
      },
      loading: () => loading?.call(context) ?? const StandardLoadingState(),
      error: (error, stack) {
        if (this.error != null) {
          return this.error!(context, error, stack);
        }
        return StandardErrorState(
          title: errorTitle ?? 'Unable to load data',
          message: errorMessage ?? 'Please check your connection and try again',
          onRetry: onRetry,
        );
      },
    );
  }
}


