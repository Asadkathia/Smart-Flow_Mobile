


import '../../../export/exports.dart';

class AuthController extends GetxController with GetSingleTickerProviderStateMixin {
  RxInt selectedIndex = 0.obs;

  void switchTab(int index) {
    selectedIndex.value = index;
  }
}
