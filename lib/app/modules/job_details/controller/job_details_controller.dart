import '../../../export/exports.dart';

class JobDetailsController extends GetxController {
  var selectedTab = 0.obs; // Default to Notes

  void setTab(int index) => selectedTab.value = index;
}
