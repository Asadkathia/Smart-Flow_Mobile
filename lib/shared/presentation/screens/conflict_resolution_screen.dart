import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/conflict_provider.dart';
import '../widgets/conflict_resolution_dialog.dart';

/// Conflict Resolution Screen
/// 
/// Displays all active conflicts and allows users to resolve them.
/// This screen will be fully implemented in Phase 2 with backend integration.
class ConflictResolutionScreen extends ConsumerWidget {
  const ConflictResolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflicts = ref.watch(conflictStateManagerProvider);
    final conflictNotifier = ref.read(conflictStateManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resolve Conflicts',
          style: AppTextStyles.heading3.copyWith(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryTextColor,
        elevation: 0,
      ),
      body: !conflicts.hasConflicts
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80.sp,
                    color: AppColors.successGreen,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No conflicts',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'All data is synchronized',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: conflicts.totalCount,
              itemBuilder: (context, index) {
                final conflict = conflicts.conflicts.values.elementAt(index);
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ListTile(
                    leading: Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warningColor,
                    ),
                    title: Text(
                      conflict.entityType,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'ID: ${conflict.entityId}',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        // Show resolution dialog
                        final result = await ConflictResolutionDialog.show(
                          context,
                          title: 'Resolve Conflict',
                          message: 'Choose which version to keep',
                          localValue: 'Local version',
                          serverValue: 'Server version',
                        );

                        if (result != null && context.mounted) {
                          // Resolve conflict
                          conflictNotifier.removeConflict(conflict.entityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Conflict resolved')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                      ),
                      child: Text('Resolve'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}


