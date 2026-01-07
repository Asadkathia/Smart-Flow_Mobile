import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/local/sync_processor.dart';
import '../providers/connectivity_provider.dart';

/// Sync Indicator Widget
/// 
/// Displays offline sync status and pending actions count.
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final syncStatusAsync = ref.watch(syncStatusProvider);

    if (!isOnline) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        color: AppColors.warningColor,
        child: Row(
          children: [
            Icon(Icons.wifi_off, color: AppColors.whiteColor, size: 16.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Offline - Changes will sync when online',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
      );
    }

    return syncStatusAsync.when(
      data: (status) {
        if (!status.hasPending) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          color: status.hasFailed ? AppColors.errorRed : AppColors.infoColor,
          child: Row(
            children: [
              if (status.hasFailed)
                Icon(Icons.error_outline, color: AppColors.whiteColor, size: 16.sp)
              else
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor),
                  ),
                ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  status.hasFailed
                    ? '${status.failed} action(s) failed to sync'
                    : 'Syncing ${status.retryable} pending action(s)...',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

