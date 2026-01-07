import 'package:smartflowpro/app/export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/signup_provider.dart';
import '../../../../../router/app_router.dart';

/// Signup Screen - Riverpod Version
/// 
/// Displays signup form with name, email, password, and confirm password fields.
/// Uses Riverpod for state management.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (formKey.currentState!.validate()) {
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // TODO: Implement actual signup with authProvider
      // For now, show success and navigate
      if (mounted) {
        context.showSuccessSnackBar("Account created successfully!");
        context.go(AppRoutePaths.mainNavigation);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibility = ref.watch(signupPasswordVisibilityProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          // Full Name
          buildFormField(
            controller: fullNameController,
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
            controller: emailController,
            labelText: 'Email Address',
            hint: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email is required";
              }
              if (!_isValidEmail(value.trim())) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),

          // Password
          buildFormField(
            controller: passwordController,
            labelText: 'Password',
            hint: "Enter your password",
            obscureText: !passwordVisibility.isPasswordVisible,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                ref
                    .read(signupPasswordVisibilityProvider.notifier)
                    .togglePasswordVisibility();
              },
              icon: Icon(
                passwordVisibility.isPasswordVisible
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
          ),
          SizedBox(height: 16.h),

          // Confirm Password
          buildFormField(
            controller: confirmPasswordController,
            labelText: 'Confirm Password',
            hint: "Re-enter your password",
            obscureText: !passwordVisibility.isConfirmPasswordVisible,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                ref
                    .read(signupPasswordVisibilityProvider.notifier)
                    .toggleConfirmPasswordVisibility();
              },
              icon: Icon(
                passwordVisibility.isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please confirm your password";
              }
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          SizedBox(height: 23.h),

          // Register Button
          BuildBasicButton(
            onPressed: () => _register(),
            title: "Register",
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

