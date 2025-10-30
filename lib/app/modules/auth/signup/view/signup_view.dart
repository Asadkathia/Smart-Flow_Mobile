import 'package:smartflowpro/app/export/exports.dart';
import 'package:smartflowpro/app/modules/auth/signup/controller/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          // Full Name
          buildFormField(
            controller: controller.fullNameController,
            labelText: 'Full Name',
            hint: "Enter your full name",
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Full name is required";
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
    
          // Email
          buildFormField(
            controller: controller.emailController,
            labelText: 'Email Address',
            hint: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email is required";
              }
              if (!GetUtils.isEmail(value.trim())) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
    
          // Password
          Obx(() => buildFormField(
                controller: controller.passwordController,
                labelText: 'Password',
                hint: "Enter your password",
                obscureText: !controller.isPasswordVisible.value,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isPasswordVisible.toggle();
                  },
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              )),
          SizedBox(height: 16.h),
    
          // Confirm Password
          Obx(() => buildFormField(
                controller: controller.confirmPasswordController,
                labelText: 'Confirm Password',
                hint: "Re-enter your password",
                obscureText: !controller.isConfirmPasswordVisible.value,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isConfirmPasswordVisible.toggle();
                  },
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != controller.passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              )),
          SizedBox(height: 23.h),
    
          // Register Button
          BuildBasicButton(
            onPressed: controller.register,
            title: "Register",
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
