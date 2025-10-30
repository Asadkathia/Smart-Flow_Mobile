import 'package:pinput/pinput.dart';
import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/verify_otp/controller/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Verify OTP',
      subtitle: 'Enter the OTP sent to your email',
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Pinput(
                length: 6,
                controller: controller.otpController,
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
            Obx(() => Center(
                  child: controller.secondsRemaining.value > 0
                      ? Text(
                          'Resend OTP in ${controller.secondsRemaining.value}s',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        )
                      : TextButton(
                          onPressed: controller.resendOtp,
                          child: Text(
                            "Resend OTP",
                            style: AppTextStyles.captionBold.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                )),
            SizedBox(height: 30.h),
            BuildBasicButton(
              onPressed: controller.verifyOtp,
              title: "Verify OTP",
            ),
          ],
        ),
      ),
    );
  }
}
