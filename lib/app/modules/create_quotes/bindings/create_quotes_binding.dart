import 'package:get/get.dart';
import '../controller/create_quotes_controller.dart';

class CreateQuotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateQuotesController>(() => CreateQuotesController());
  }
}
