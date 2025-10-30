import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/forget_password/controller/forget_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Forgot Password',
      subtitle: 'Enter your email to receive an OTP',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFormField(
                controller: controller.emailController,
                labelText: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter email';
                  if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              BuildBasicButton(
                onPressed: controller.sendOtp,
                title: "Send OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
