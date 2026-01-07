import 'package:pinput/pinput.dart';
import 'package:smartflowpro/app/export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/verify_otp_provider.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../router/app_router.dart';

/// Verify OTP Screen - Riverpod Version
/// 
/// Displays OTP verification form with 6-digit PIN input.
/// Uses Riverpod for state management.
class VerifyOtpScreen extends ConsumerStatefulWidget {
  /// The email address to verify OTP for
  final String email;

  const VerifyOtpScreen({super.key, this.email = ''});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (formKey.currentState!.validate()) {
      final otp = otpController.text.trim();
      
      // TODO: Implement actual OTP verification with authProvider
      // For now, just navigate to reset password
      if (mounted) {
        context.showSuccessSnackBar("OTP Verified Successfully!");
        context.go(AppRoutePaths.resetPassword);
      }
    }
  }

  void _resendOtp() {
    // TODO: Implement actual OTP resend with authProvider
    ref.read(otpTimerProvider.notifier).reset();
    if (mounted) {
      context.showSuccessSnackBar("A new OTP has been sent to your email.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(otpTimerProvider);

    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Verify OTP',
      subtitle: 'Enter the OTP sent to your email',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Pinput(
                length: 6,
                controller: otpController,
                defaultPinTheme: PinTheme(
                  width: 50.w,
                  height: 55.h,
                  textStyle: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.greyColor),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50.w,
                  height: 55.h,
                  textStyle: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter OTP';
                  if (value.length != 6) return 'Enter 6-digit OTP';
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: timerState.secondsRemaining > 0
                  ? Text(
                      'Resend OTP in ${timerState.secondsRemaining}s',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.darkGrey,
                      ),
                    )
                  : TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        "Resend OTP",
                        style: AppTextStyles.captionBold.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 30.h),
            BuildBasicButton(
              onPressed: () => _verifyOtp(),
              title: "Verify OTP",
            ),
          ],
        ),
      ),
    );
  }
}

