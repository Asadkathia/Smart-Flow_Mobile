import '../../../export/exports.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.mainNavigation);
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
            SizedBox(height: 24),
            Text(
              'SmartFlow Pro',
              style: AppTextStyles.heading1.copyWith(color: AppColors.whiteColor),
            ),
            SizedBox(height: 12),
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
