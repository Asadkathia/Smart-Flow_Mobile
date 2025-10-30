import 'dart:async';
import 'package:smartflowpro/app/export/exports.dart';

class VerifyOtpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  var secondsRemaining = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resendOtp() {
    // TODO: Call resend OTP API here
    startTimer();
    Get.snackbar(
      "OTP Sent",
      "A new OTP has been sent to your email.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void verifyOtp() {
    if (formKey.currentState!.validate()) {
      // TODO: Verify OTP API call
      // Get.toNamed(AppRoutes.resetPassword);
      Get.snackbar("Success", "OTP Verified Successfully!",
          snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(Get.context!);
      Get.toNamed(AppRoutes.resetPassword);
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
