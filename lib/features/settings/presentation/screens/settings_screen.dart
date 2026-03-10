import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/shared/presentation/widgets/custom_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Settings Screen
/// 
/// Displays app settings and preferences for the user.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Settings',
        showBackButton: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          // App Settings Section
          _buildSectionHeader('App Settings'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive notifications for new visits and updates',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Update notification settings
            },
          ),
          _buildSwitchTile(
            icon: Icons.volume_up_outlined,
            title: 'Sound',
            subtitle: 'Play sound for notifications',
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
              // TODO: Update sound settings
            },
          ),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'Vibration',
            subtitle: 'Vibrate for notifications',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
              // TODO: Update vibration settings
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
              // TODO: Update theme settings
            },
          ),
          
          SizedBox(height: 16.h),
          Divider(height: 1, color: AppColors.darkGrey.withAlpha(40)),
          
          // Account Settings Section
          _buildSectionHeader('Account Settings'),
          _buildTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // TODO: Navigate to change password screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Change password feature coming soon')),
              );
            },
          ),
          
          SizedBox(height: 16.h),
          Divider(height: 1, color: AppColors.darkGrey.withAlpha(40)),
          
          // Data & Storage Section
          _buildSectionHeader('Data & Storage'),
          _buildTile(
            icon: Icons.cleaning_services_outlined,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () async {
              final confirmed = await _showConfirmDialog(
                'Clear Cache',
                'This will clear all cached data. Continue?',
              );
              if (confirmed == true && mounted) {
                // TODO: Clear cache
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cache cleared successfully')),
                );
              }
            },
          ),
          _buildTile(
            icon: Icons.sync_outlined,
            title: 'Offline Data Sync',
            subtitle: 'Manage offline data synchronization',
            onTap: () {
              // TODO: Navigate to offline sync settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sync settings coming soon')),
              );
            },
          ),
          _buildTile(
            icon: Icons.storage_outlined,
            title: 'Storage Usage',
            subtitle: 'View app storage usage',
            onTap: () {
              // TODO: Navigate to storage usage screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Storage usage feature coming soon')),
              );
            },
          ),
          
          SizedBox(height: 16.h),
          Divider(height: 1, color: AppColors.darkGrey.withAlpha(40)),
          
          // About Section
          _buildSectionHeader('About'),
          _buildTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: _appVersion,
            showTrailing: false,
          ),
          _buildTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // TODO: Open terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening Terms of Service...')),
              );
            },
          ),
          _buildTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Open privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening Privacy Policy...')),
              );
            },
          ),
          _buildTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Open help & support
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening Help & Support...')),
              );
            },
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.greyColor,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkGrey, size: 24.sp),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.greyColor,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool showTrailing = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkGrey, size: 24.sp),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkText,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.greyColor,
              ),
            )
          : null,
      trailing: showTrailing
          ? Icon(Icons.chevron_right, color: AppColors.greyColor)
          : null,
      onTap: onTap,
    );
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
