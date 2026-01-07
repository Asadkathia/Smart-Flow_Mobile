import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartflowpro/shared/presentation/widgets/auth_base_layout.dart';
import 'package:smartflowpro/core/theme/app_colors.dart';
import 'package:smartflowpro/core/theme/app_text_styles.dart';
import '../providers/auth_tab_provider.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Auth Screen - Riverpod Version
/// 
/// Displays Login/Signup toggle and form content.
/// Uses Riverpod for state management.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(authTabProvider);

    return AuthBaseLayout(
      showBackButton: true,
      title: "Go ahead and complete your account and setup.",
      subtitle: "Create your account and simplify your workflow instantly.",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔘 Login / Signup Toggle
            Container(
              height: 52.h,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(authTabProvider.notifier).switchTab(0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? AppColors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: selectedIndex == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: selectedIndex == 0
                                  ? AppColors.darkGrey
                                  : AppColors.whiteColor.withOpacity(0.6),
                              fontWeight: selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(authTabProvider.notifier).switchTab(1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? AppColors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: selectedIndex == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            "Signup",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: selectedIndex == 1
                                  ? AppColors.darkGrey
                                  : AppColors.whiteColor.withOpacity(0.6),
                              fontWeight: selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            30.verticalSpace,

            // 🔁 Animated Form Content (Fade Transition)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: selectedIndex == 0
                  ? Container(
                      key: const ValueKey(0),
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: LoginScreen(),
                    )
                  : Container(
                      key: const ValueKey(1),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SignupScreen(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

