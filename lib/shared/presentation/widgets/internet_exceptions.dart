import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_settings/app_settings.dart';
import '../../../router/app_router.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent back navigation
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
              SizedBox(height: 16.h),
              const Text("Internet Unavailable"),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutePaths.splash);
                  },
                  child: Text("Retry"),
                ),
              ),
              SizedBox(height: 16.h),
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
