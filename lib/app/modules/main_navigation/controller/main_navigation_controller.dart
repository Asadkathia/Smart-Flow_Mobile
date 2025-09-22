import '../../../export/exports.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // List of pages for bottom navigation
  late final List<Widget> pages;

  // Page titles
  final List<String> pageTitles = ['Home', 'Scheduled', 'Account'];

  @override
  void onInit() {
    super.onInit();
    pages = const [HomeView(), _ScheduledStub(), _AccountStub()];
  }

  // Change current page
  void changePage(int index) {
    currentIndex.value = index;
  }

  // Get current page (optional)
  Widget get currentPage => pages[currentIndex.value];

  // Get current title
  String get currentTitle => pageTitles[currentIndex.value];
}

class _ScheduledStub extends StatelessWidget {
  const _ScheduledStub();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _AccountStub extends StatelessWidget {
  const _AccountStub();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
