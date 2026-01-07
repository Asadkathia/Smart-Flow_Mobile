import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/features/auth/presentation/providers/auth_provider.dart';
import 'package:smartflowpro/router/app_router.dart';

/// More Screen - Riverpod Version
/// 
/// Displays more options, settings, and logout functionality.
/// Migrated from GetX to Riverpod.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user information from auth provider
    final userName = 'Prime Appliance Service'; // TODO: Get from actual user data
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Text(
              'More',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 25.sp,
                color: AppColors.darkText,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              userName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.greyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18.h),
            // Options list
            _MoreOption(
              icon: Icons.support_agent,
              label: 'Support',
              onTap: () {},
            ),
            _MoreOption(
              icon: Icons.inventory_2_outlined,
              label: 'Inventory',
              onTap: () {
                context.push(AppRoutePaths.inventoryList);
              },
            ),
            _MoreOption(icon: Icons.info_outline, label: 'About', onTap: () {}),
            Divider(height: 32.h, color: AppColors.darkGrey.withAlpha(40)),
            _MoreOption(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () {
                context.push(AppRoutePaths.profile);
              },
            ),
            _MoreOption(
              icon: Icons.settings_outlined,
              label: 'Preferences',
              onTap: () {},
            ),
            SizedBox(height: 8.h),
            Divider(height: 24.h, color: AppColors.darkGrey.withAlpha(40)),
            _MoreOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () => _handleLogout(context, ref),
              color: AppColors.errorRed,
              iconColor: AppColors.errorRed,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorRed,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Perform logout
      await ref.read(authProvider.notifier).logout();

      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        // Navigate to login screen
        context.go(AppRoutePaths.auth);
      }
    }
  }
}

class _MoreOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;
  const _MoreOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.darkGrey),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: color ?? AppColors.darkGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      minLeadingWidth: 32.w,
      horizontalTitleGap: 0,
    );
  }
}

