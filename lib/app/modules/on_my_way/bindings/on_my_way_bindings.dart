import '../../../export/exports.dart';
import '../controller/on_my_way_controller.dart';

class OnMyWayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnMyWayController>(() => OnMyWayController());
  }
}
