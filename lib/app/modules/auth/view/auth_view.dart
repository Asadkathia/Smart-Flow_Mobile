import 'package:smartflowpro/app/modules/auth/controller/auth_controller.dart';
import 'package:smartflowpro/app/modules/auth/login/view/login_view.dart';
import 'package:smartflowpro/app/modules/auth/signup/view/signup_view.dart';
import '../../../export/exports.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBaseLayout(
      showBackButton: true,
      title: "Go ahead and complete your account and setup.",
      subtitle: "Create your account and simplify your workflow instantly.",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w,),
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
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.switchTab(0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: controller.selectedIndex.value == 0
                                  ? AppColors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow:
                                  controller.selectedIndex.value == 0
                                      ? [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.08),
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
                                  color:
                                      controller.selectedIndex.value == 0
                                          ? AppColors.darkGrey
                                          : AppColors.whiteColor
                                              .withOpacity(0.6),
                                  fontWeight:
                                      controller.selectedIndex.value == 0
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
                          onTap: () => controller.switchTab(1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: controller.selectedIndex.value == 1
                                  ? AppColors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow:
                                  controller.selectedIndex.value == 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.08),
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
                                  color:
                                      controller.selectedIndex.value == 1
                                          ? AppColors.darkGrey
                                          : AppColors.whiteColor
                                              .withOpacity(0.6),
                                  fontWeight:
                                      controller.selectedIndex.value == 1
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),

            30.verticalSpace,

            // 🔁 Animated Form Content (Fade Transition)
            Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: controller.selectedIndex.value == 0
                    ? Container(
                        key: const ValueKey(0),
                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
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
                        child: LoginView(),
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
                        child: SignupView(),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}













