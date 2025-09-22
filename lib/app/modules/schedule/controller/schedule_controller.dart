import '../../../export/exports.dart';

class ScheduleController extends GetxController {
  // Current tab index
  final RxInt currentTabIndex = 0.obs;

  // Tab names
  final List<String> tabNames = ['Day', 'List', 'Map'];

  // Current month name
  final RxString currentMonthName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _updateCurrentMonth();
  }

  void _updateCurrentMonth() {
    final now = DateTime.now();
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    currentMonthName.value = '${monthNames[now.month - 1]} ';
  }

  void changeTab(int index) {
    if (index >= 0 && index < tabNames.length) {
      currentTabIndex.value = index;
    }
  }
}
