import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Error Boundary Widget
/// 
/// Catches unhandled errors and displays a user-friendly error screen.
/// Wraps the app to catch errors at the widget level.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    // Set up error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorDetails = details;
            });
          }
        });
      }
      // Log error (can be extended with Sentry)
      FlutterError.presentError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      final errorWidget = widget.fallback ?? _buildErrorScreen();
      
      // If we're at the top level (no Directionality yet), wrap with MaterialApp
      try {
        Directionality.of(context);
        return errorWidget;
      } catch (_) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: errorWidget,
        );
      }
    }
    return widget.child;
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: AppColors.errorRed,
              ),
              SizedBox(height: 24.h),
              Text(
                'Something went wrong',
                style: AppTextStyles.heading4,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'We encountered an unexpected error. Please try again or contact support if the problem persists.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorDetails = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                ),
                child: Text(
                  'Retry',
                  style: AppTextStyles.buttonMedium,
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  // Error reporting will be implemented in Phase 2 with Sentry integration
                  // For now, log error details in debug mode
                  if (_errorDetails != null) {
                    debugPrint('Error: ${_errorDetails!.exception}');
                    debugPrint('Stack: ${_errorDetails!.stack}');
                  }
                },
                child: Text(
                  'Report Error',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error Widget Builder
/// 
/// Custom error widget builder for Flutter errors
Widget buildErrorWidget(FlutterErrorDetails details) {
  final content = Container(
    color: AppColors.whiteColor,
    padding: EdgeInsets.all(16.w),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: AppColors.errorRed,
          ),
          SizedBox(height: 16.h),
          Text(
            'An error occurred',
            style: AppTextStyles.heading5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            details.exception.toString(),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.greyColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: content),
  );
}


