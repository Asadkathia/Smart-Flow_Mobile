import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import 'package:smartflowpro/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutePaths.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flash_on, size: 100, color: AppColors.whiteColor),
            SizedBox(height: 24.h),
            Text(
              'SmartFlow Pro',
              style: AppTextStyles.heading1.copyWith(color: AppColors.whiteColor),
            ),
            SizedBox(height: 12.h),
            Text(
              'Welcome to your smart workflow!',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.whiteColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

