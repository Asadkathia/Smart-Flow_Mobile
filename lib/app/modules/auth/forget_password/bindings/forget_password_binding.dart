import 'package:smartflowpro/app/modules/auth/forget_password/controller/forget_password_controller.dart';
import '../../../../export/exports.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
