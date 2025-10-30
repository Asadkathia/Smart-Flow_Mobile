import 'package:smartflowpro/app/export/exports.dart';

class LoginController extends GetxController {
 final emailController = TextEditingController();
 final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RxBool isPasswordVisible = false.obs;

}