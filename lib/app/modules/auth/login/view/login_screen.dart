import 'package:smartflowpro/app/export/exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/login_provider.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../router/app_router.dart';

/// Login Screen - Riverpod Version
/// 
/// Displays login form with email and password fields.
/// Uses Riverpod for state management.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = ref.watch(loginProvider);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    // Navigate to main navigation when authenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && previous?.isAuthenticated != true) {
        context.go(AppRoutePaths.mainNavigation);
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFormField(
            controller: emailController,
            labelText: 'Email Address',
            hint: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          buildFormField(
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(loginProvider.notifier).togglePasswordVisibility();
              },
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            controller: passwordController,
            labelText: 'Password',
            hint: "Enter your password",
            keyboardType: TextInputType.visiblePassword,
            obscureText: !isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () {
              context.push(AppRoutePaths.forgetPassword);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
                style: AppTextStyles.captionBold,
              ),
            ),
          ),
          SizedBox(height: 23.h),
          BuildBasicButton(
            onPressed: isLoading ? () {} : () => _handleLogin(),
            title: isLoading ? "Logging in..." : "Login",
          ),
          if (authState.error != null) ...[
            SizedBox(height: 16.h),
            Text(
              authState.error!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorRed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 200.h),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final success = await ref.read(authProvider.notifier).login(email, password);

    if (!success && mounted) {
      // Error is already shown via authState.error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(authProvider).error ?? 'Login failed'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}

