import '../../../export/exports.dart';

class JobDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobDetailsController());
  }
}
