import 'package:smartflowpro/app/export/exports.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Prime Appliance Service',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.greyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18.h),
            // Apps & integrations card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Icon(Icons.grid_view_rounded, color: AppColors.darkGrey),
                  Text(
                    'Apps & integrations',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
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
              icon: Icons.card_giftcard,
              label: 'Refer a friend',
              onTap: () {},
            ),
            _MoreOption(icon: Icons.info_outline, label: 'About', onTap: () {}),
            Divider(height: 32.h, color: AppColors.darkGrey.withAlpha(40)),
            _MoreOption(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () {
                Get.toNamed(AppRoutes.profile);
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
              onTap: () {},
              color: AppColors.errorRed,
              iconColor: AppColors.errorRed,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
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
