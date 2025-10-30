import 'package:smartflowpro/app/export/exports.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void sendOtp() {
    if (formKey.currentState!.validate()) {
      // TODO: Call API to send OTP
      Get.toNamed(AppRoutes.verifyOtp); // Navigate to OTP page
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
