import '../export/exports.dart';

class NoInternet extends GetView {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (S) {
        // Get.to(Splash());
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                color: CupertinoColors.lightBackgroundGray,
                size: 100,
              ),
              2.verticalSpace,
              const Text("Internet Unavailable"),
              2.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.splash);
                  },
                  child: Text("Retry"),
                ),
              ),
              2.verticalSpace,
              ElevatedButton(
                onPressed: () =>
                    AppSettings.openAppSettings(type: AppSettingsType.wifi),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: const Text('Open Network Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
