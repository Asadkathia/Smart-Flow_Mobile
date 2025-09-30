import '../../../export/exports.dart';

class MoreViewBindings extends Bindings {
  void dependencies() {
    Get.lazyPut<MoreViewController>(() => MoreViewController());
  }
}