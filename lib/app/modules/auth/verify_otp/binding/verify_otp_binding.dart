import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/verify_otp/controller/verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpController>(() => VerifyOtpController());
  }
}