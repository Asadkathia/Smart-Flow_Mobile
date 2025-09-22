import '../../../export/exports.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
