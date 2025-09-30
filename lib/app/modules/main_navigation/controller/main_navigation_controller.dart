import '../../../export/exports.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // List of pages for bottom navigation
  late final List<Widget> pages;

  // Change current page
  void changePage(int index) {
    currentIndex.value = index;
  }

  // Get current page (optional)
  Widget get currentPage => pages[currentIndex.value];
}
