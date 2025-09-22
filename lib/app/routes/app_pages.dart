import '../export/exports.dart';

class AppPages {
  static const initial = AppRoutes.mainNavigation;

  static final routes = [
    GetPage(
      name: AppRoutes.mainNavigation,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => const ScheduleView(),
      binding: ScheduleBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
