import '../../../export/exports.dart';
import '../controller/quotes_list_controller.dart';

class QuotesListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuotesListController>(() => QuotesListController());
  }
}
