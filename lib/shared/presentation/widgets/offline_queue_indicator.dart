import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../data/local/sync_processor.dart';
import '../../data/local/offline_queue_service.dart';

/// Offline Queue Indicator Widget
/// 
/// Displays pending actions count and sync status.
/// Allows manual sync trigger and shows failed actions with retry option.
class OfflineQueueIndicator extends ConsumerWidget {
  const OfflineQueueIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(syncStatusProvider);
    final syncProcessor = ref.watch(syncProcessorProvider);

    return syncStatusAsync.when(
      data: (status) {
        if (!status.hasPending) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: status.hasFailed 
                ? AppColors.errorColor.withOpacity(0.1)
                : AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: status.hasFailed 
                  ? AppColors.errorColor
                  : AppColors.primaryColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                status.isSyncing 
                    ? Icons.sync
                    : status.hasFailed
                        ? Icons.error_outline
                        : Icons.cloud_upload,
                color: status.hasFailed 
                    ? AppColors.errorColor
                    : AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.isSyncing
                          ? 'Syncing...'
                          : status.hasFailed
                              ? 'Sync failed'
                              : 'Pending sync',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: status.hasFailed 
                            ? AppColors.errorColor
                            : AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${status.totalPending} pending${status.totalPending == 1 ? '' : 's'}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    if (status.hasFailed) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${status.failed} failed',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.errorColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!status.isSyncing)
                TextButton(
                  onPressed: () async {
                    await syncProcessor.processQueue();
                    ref.invalidate(syncStatusProvider);
                  },
                  child: Text(
                    status.hasFailed ? 'Retry' : 'Sync',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
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


