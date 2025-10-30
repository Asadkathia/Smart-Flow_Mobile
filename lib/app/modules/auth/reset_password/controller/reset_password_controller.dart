import 'package:smartflowpro/app/export/exports.dart';

class ResetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetPassword() {
    if (formKey.currentState!.validate()) {
      // TODO: Call reset password API
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
