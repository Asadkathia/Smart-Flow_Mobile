import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Conflict Resolution Dialog
/// 
/// Displays a dialog for resolving data conflicts when offline changes
/// conflict with server data.
class ConflictResolutionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String localValue;
  final String serverValue;
  final VoidCallback onKeepLocal;
  final VoidCallback onUseServer;
  final VoidCallback? onCancel;

  const ConflictResolutionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.localValue,
    required this.serverValue,
    required this.onKeepLocal,
    required this.onUseServer,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.heading5,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: 24.h),
            _buildValueCard(
              'Your Local Version',
              localValue,
              AppColors.primaryColor,
            ),
            SizedBox(height: 16.h),
            _buildValueCard(
              'Server Version',
              serverValue,
              AppColors.greyColor,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20.sp,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Choose which version to keep. The other will be discarded.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
        TextButton(
          onPressed: onUseServer,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.greyColor,
          ),
          child: Text(
            'Use Server',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onKeepLocal,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
          ),
          child: Text(
            'Keep Local',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard(String label, String value, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Show conflict resolution dialog
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String localValue,
    required String serverValue,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? result;
        return ConflictResolutionDialog(
          title: title,
          message: message,
          localValue: localValue,
          serverValue: serverValue,
          onKeepLocal: () {
            result = 'local';
            Navigator.of(context).pop(result);
          },
          onUseServer: () {
            result = 'server';
            Navigator.of(context).pop(result);
          },
          onCancel: () {
            result = null;
            Navigator.of(context).pop(result);
          },
        );
      },
    );
  }
}



