import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/reset_password/controller/reset_password_controller.dart';

class ResetPasswordBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(() => ResetPasswordController());
  }
}