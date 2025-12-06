import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/login/controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFormField(
          controller: controller.emailController,
          labelText: 'Email Address',
          hint: "Enter your email",
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
     Obx(()=>    buildFormField(
          suffixIcon: IconButton(
            onPressed: () {
              controller.isPasswordVisible.toggle();
            },
            icon:  Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
              
            ),
          ),
          controller: controller.passwordController,
          labelText: 'Password',
          hint: "Enter your password",
          keyboardType: TextInputType.visiblePassword,
          obscureText: controller.isPasswordVisible.value,
        ),),
        SizedBox(height: 16.h),
        InkWell(
          onTap: (){
            Get.toNamed(AppRoutes.forgetPassword);
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Forgot Password?", style: AppTextStyles.captionBold),
          ),
        ),
        SizedBox(height: 23.h),
        BuildBasicButton(onPressed: () 
        {
          // Get.toNamed(AppRoutes.home);
          Get.toNamed(AppRoutes.mainNavigation);
        }, title: "Login"),
        SizedBox(height: 200.h),
      ],
    );
  }
}
