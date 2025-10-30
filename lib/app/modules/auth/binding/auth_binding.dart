import 'package:smartflowpro/app/modules/auth/login/controller/login_controller.dart';
import 'package:smartflowpro/app/modules/auth/signup/controller/signup_controller.dart';

import '../../../export/exports.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
  }
}
