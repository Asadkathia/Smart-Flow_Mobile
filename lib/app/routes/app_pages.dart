import 'package:smartflowpro/app/modules/job_details/view/job_details_view.dart';
import '../export/exports.dart';
import 'package:smartflowpro/app/modules/profile/view/profile_view.dart';
import 'package:smartflowpro/app/modules/profile/bindings/profile_bindings.dart';

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
    GetPage(
      name: AppRoutes.jobsDetailsView,
      page: () => const JobDetailsView(),
      binding: JobDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
