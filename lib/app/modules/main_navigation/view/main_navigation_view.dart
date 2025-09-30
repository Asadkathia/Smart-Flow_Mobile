import '../../../export/exports.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeView(),
      const ScheduleView(),
      const MoreView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
