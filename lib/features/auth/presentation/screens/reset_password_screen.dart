import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/shared/presentation/widgets/auth_base_layout.dart';
import 'package:smartflowpro/shared/presentation/widgets/build_form_field.dart';
import 'package:smartflowpro/shared/presentation/widgets/build_basic_button.dart';
import '../providers/reset_password_provider.dart';
import '../providers/auth_provider.dart';
import 'package:smartflowpro/router/app_router.dart';

/// Reset Password Screen - Riverpod Version
/// 
/// Displays password reset form with new password and confirm password fields.
/// Uses Riverpod for state management.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (formKey.currentState!.validate()) {
      ref.read(resetPasswordLoadingProvider.notifier).state = true;

      // Get email and OTP from route extra (passed from verify OTP screen)
      final route = GoRouterState.of(context);
      final extra = route.extra as Map<String, dynamic>?;
      final email = extra?['email'] as String? ?? '';
      final otp = extra?['otp'] as String? ?? '';
      
      if (email.isEmpty || otp.isEmpty) {
        ref.read(resetPasswordLoadingProvider.notifier).state = false;
        if (mounted) {
          context.showErrorSnackBar('Email and OTP are required');
        }
        return;
      }

      final newPassword = passwordController.text.trim();
      final success = await ref.read(authProvider.notifier).resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      ref.read(resetPasswordLoadingProvider.notifier).state = false;

      if (mounted) {
        if (success) {
          context.showSuccessSnackBar("Password reset successfully!");
          context.go(AppRoutePaths.auth);
        } else {
          final error = ref.read(authProvider).error;
          context.showErrorSnackBar(error ?? 'Password reset failed. Please try again.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibilityState = ref.watch(resetPasswordVisibilityProvider);
    final isLoading = ref.watch(resetPasswordLoadingProvider);

    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Reset Password',
      subtitle: 'Create a new password for your account',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              buildFormField(
                controller: passwordController,
                labelText: 'New Password',
                hint: 'Enter new password',
                obscureText: !visibilityState.isPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(resetPasswordVisibilityProvider.notifier).togglePasswordVisibility();
                  },
                  icon: Icon(
                    visibilityState.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6) return 'Password too short';
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              buildFormField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                hint: 'Re-enter password',
                obscureText: !visibilityState.isConfirmPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(resetPasswordVisibilityProvider.notifier).toggleConfirmPasswordVisibility();
                  },
                  icon: Icon(
                    visibilityState.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirm password';
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 23.h),
              BuildBasicButton(
                onPressed: isLoading ? () {} : () => _resetPassword(),
                title: isLoading ? "Resetting..." : "Reset Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

