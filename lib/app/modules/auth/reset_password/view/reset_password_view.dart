import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/reset_password/controller/reset_password_controller.dart';


class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Reset Password',
      subtitle: 'Create a new password for your account',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              buildFormField(
                controller: controller.passwordController,
                labelText: 'New Password',
                hint: 'Enter new password',

                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6) return 'Password too short';
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              buildFormField(
                controller: controller.confirmPasswordController,
                labelText: 'Confirm Password',
                hint: 'Re-enter password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirm password';
                  if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 23.h),
              BuildBasicButton(
                onPressed: controller.resetPassword,
                title: "Reset Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
