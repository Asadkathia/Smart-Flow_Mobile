import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smartflowpro/shared/presentation/widgets/auth_base_layout.dart';
import 'package:smartflowpro/shared/presentation/widgets/build_form_field.dart';
import 'package:smartflowpro/shared/presentation/widgets/build_basic_button.dart';
import '../providers/forget_password_provider.dart';
import 'package:smartflowpro/router/app_router.dart';

/// Forgot Password Screen - Riverpod Version
/// 
/// Displays email input form to request OTP for password reset.
/// Uses Riverpod for state management.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendOtp() async {
    if (formKey.currentState!.validate()) {
      ref.read(forgotPasswordLoadingProvider.notifier).state = true;
      
      // TODO: Implement actual OTP sending with authProvider
      // For now, just navigate to verify OTP
      await Future.delayed(const Duration(seconds: 1));
      
      ref.read(forgotPasswordLoadingProvider.notifier).state = false;
      
      if (mounted) {
        context.showSuccessSnackBar("A verification code has been sent to your email.");
        context.push(AppRoutePaths.verifyOtp, extra: {'email': emailController.text.trim()});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forgotPasswordLoadingProvider);

    return AuthBaseLayout(
      sizedBoxHeight: 50.h,
      title: 'Forgot Password',
      subtitle: 'Enter your email to receive an OTP',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFormField(
                controller: emailController,
                labelText: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter email';
                  if (!_isValidEmail(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              BuildBasicButton(
                onPressed: isLoading ? () {} : () => _sendOtp(),
                title: isLoading ? "Sending..." : "Send OTP",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

