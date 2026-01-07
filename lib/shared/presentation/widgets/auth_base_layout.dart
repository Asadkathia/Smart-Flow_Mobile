import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthBaseLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;
  final double ?sizedBoxHeight;

  const AuthBaseLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBackButton = true,
    this.sizedBoxHeight = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBackButton)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withAlpha(10),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                        ),
                      ),
                    4.verticalSpace,
                    Text(
                      title,
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.whiteColor.withValues(alpha: 0.7),
                      ),
                    ),
                    3.verticalSpace,
                  ],
                ),
              ),
            ),
            SizedBox(height: sizedBoxHeight,),
            Align(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: SafeArea(
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
