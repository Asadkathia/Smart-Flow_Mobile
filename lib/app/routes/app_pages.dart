import 'package:smartflowpro/app/modules/job_details/view/job_details_view.dart';
import 'package:smartflowpro/app/modules/quotes_list/bindings/quotes_list_bindings.dart';
import '../export/exports.dart';
import 'package:smartflowpro/app/modules/profile/view/profile_view.dart';
import 'package:smartflowpro/app/modules/profile/bindings/profile_bindings.dart';
import '../modules/on_my_way/view/on_my_way_view.dart';
import '../modules/on_my_way/bindings/on_my_way_bindings.dart';
import '../modules/quotes_list/view/quotes_list_view.dart';
import '../modules/splash/view/splash_view.dart';
import '../modules/splash/bindings/splash_bindings.dart';
import '../modules/create_quotes/view/create_quotes_view.dart';
import '../modules/create_quotes/bindings/create_quotes_binding.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
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
    GetPage(
      name: AppRoutes.onMyWay,
      page: () => const OnMyWayView(),
      binding: OnMyWayBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.createQuotes,
      page: () => const CreateQuotesView(),
      binding: CreateQuotesBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.quotesList,
      page: () => const QuotesListView(),
      binding: QuotesListBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
